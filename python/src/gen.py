import structs

class WinT:
    def __init__(self):
        self.dat = structs.Kp()
        self.name = ""
        self.lcnt = 0
        self.brk_act = False
        self.cur_act = 0
        self.cur_pos = 0
        self.on_pos = 0
        self.is_on = False
        self.is_trig = False
        self.is_prev = False

class GlobT:
    def __init__(self):
        self.acts = structs.ActT()
        self.dats = structs.ActT()
        self.wins = []
        self.winp = -1

def new_act(glob):
    winp = glob.winp + 1
    if len(glob.wins) <= winp:
        glob.wins.append(WinT())
    glob.wins[winp].lcnt = -1
    glob.wins[winp].brk_act = False
    if winp == 0:
        return
    if glob.wins[winp - 1].is_on or glob.wins[winp - 1].is_prev:
        if not glob.wins[winp - 1].is_trig:
            glob.wins[winp].is_prev = True

def go_act(dat, glob, act):
    name = glob.acts.ap_actor[act].k_name
    glob.winp += 1
    glob.wins[glob.winp].dat = dat;
    glob.wins[glob.winp].name = name
    prev = False
    for a in range(len(glob.acts.ap_actor)):
        if name != glob.acts.ap_actor[a].k_name:
            continue
        attr = glob.acts.ap_actor[a].k_attr
        val = glob.acts.ap_actor[a].k_value
        cc = glob.acts.ap_actor[a].k_cc
        eq = glob.acts.ap_actor[a].k_eq
        if attr != "E_O_L":
            aval = s_get_var(glob, attr, glob.winp)
            prev = chk(eq, aval, val, prev)
            if not prev:
                continue
        if cc != "":
            print(strs(glob, cc, glob.winp))
        glob.wins[glob.winp].cur_act = a
        glob.wins[glob.winp].lcnt += 1
        ret = go_cmds(dat, glob, a)
        if ret == 0 or ret == 3:
            continue
        nret = ret
        if ret == 2:
            nret = 0
        if ret < 0 and glob.wins[glob.winp].brk_act:
            nret = -ret
        glob.winp -= 1
        return nret
    glob.winp -= 1
    return 0

def go_cmds(dat, glob: GlobT, act: int) -> int:
    glob.wins[glob.winp].is_on = False
    glob.wins[glob.winp].is_trig = False
    for c in range(glob.acts.ap_actor[act].cmds_from, glob.acts.ap_actor[act].cmds_to):
        glob.wins[glob.winp].cur_pos = c
        cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            if glob.wins[glob.winp].is_on and not glob.wins[glob.winp].is_trig:
                continue
            trig(glob, glob.winp)
            cc = glob.acts.ap_c[cmd.ind]
            print(strs(glob, cc.k_desc, glob.winp))
        elif cmd.cmd == "Cf":
            if glob.wins[glob.winp].lcnt == 0:
                cf = glob.acts.ap_cf[cmd.ind]
                print(strs(glob, cf.k_desc, glob.winp))
        elif cmd.cmd == "All":
            all = glob.acts.ap_all[cmd.ind]
            what = all.k_what
            new_act(glob)
            ret = do_all(glob, what, all.k_actorp)
            if ret > 1 or ret < 0:
                return ret
        elif cmd.cmd == "Its":
            its = glob.acts.ap_its[cmd.ind]
            what = its.k_what
            new_act(glob)
            ret = dat.do_its(glob, what, its.k_actorp)
            if ret > 1 or ret < 0:
                return ret
        elif cmd.cmd == "Du":
            du = glob.acts.ap_du[cmd.ind]
            new_act(glob)
            ret = go_act(dat, glob, du.k_actorp)
            if ret != 0:
                return ret
        elif cmd.cmd == "Out":
            out = glob.acts.ap_out[cmd.ind]
            if out.k_what == "delay":
                glob.wins[glob.winp].is_on = True
                glob.wins[glob.winp].on_pos = c
            elif out.k_what == "normal":
                glob.wins[glob.winp].is_on = False
                glob.wins[glob.winp].is_trig = False
        elif cmd.cmd == "Break":
            brk = glob.acts.ap_break[cmd.ind]
            ret = 0
            if brk.k_what == "E_O_L" or brk.k_what == "actor":
                ret = 2
            elif brk.k_what == "loop":
                ret = 1
            elif brk.k_what == "cmds":
                ret = 3
            if brk.k_actor != "E_O_L":
                for i in range(glob.winp - 1, -1, -1):
                    if brk.k_actor == glob.wins[i].name:
                        glob.wins[i + 1].brk_act = True
                        ret = -ret
            return ret
    return 0

def trig(glob, winp):
    if not glob.wins[winp].is_prev or winp == 0:
        return
    glob.wins[winp].is_prev = False
    prev = winp - 1
    if not glob.wins[prev].is_on and not glob.wins[prev].is_prev:
        return
    if glob.wins[prev].is_trig:
        return
    glob.wins[prev].is_trig = True
    re_go_cmds(glob, prev)

def re_go_cmds(glob, winp):
    trig(glob, winp)
    a = glob.acts.ap_actor[glob.wins[winp].cur_act]
    for c in range(glob.wins[winp].on_pos, glob.wins[winp].cur_pos):
        cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            cc = glob.acts.ap_c[cmd.ind]
            print(strs(glob, cc.k_desc, winp))

# Remaining functions and classes omitted for brevity

def chk(eqa: str, aval: str, val: str, prev: bool) -> bool:
    eq = eqa
    if eq[0] == "&":
        if not prev:
            return False
        eq = eq[1:]
    if eq == "=":
        return aval == val
    elif eq == "!=":
        return aval != val
    elif eq == "in":
        try:
            ss = val.split(",")
            for i in range(len(ss)):
                if aval == ss[i]:
                    return True
            return False
        except:
            return False
    return False

def do_all(glob: GlobT, what: str, act: int) -> int:
    if what == "Comp":
        for i in range(len(glob.dats.ap_comp)):
            ret = go_act(glob.dats.ap_comp[i], glob, act)
            if ret != 0:
                return ret
    return 0

def s_get_var(glob: GlobT, va: str, winp: int) -> str:
    try:
        ss = va.split(".")
        if ss[0] == "":
            for i in range(winp, -1, -1):
                if ss[1] == glob.wins[i].name:
                    return glob.wins[i].dat.get_var(glob.dats, ss[2:])
        return glob.wins[winp].dat.get_var(glob.dats, ss)
    except Exception as e:
        print("s_get_var")
        return "????"

def strs(glob: GlobT, s: str, winp: int) -> str:
    ret = ""
    pos = 0
    dp = -3
    bp = -3
    for i in range(len(s)):
        if s[i] == '$':
            dp = i
        if s[i] == '{':
            if i == dp + 1:
                ret += s[pos:i - 1]
                pos = i
                bp = i
        if s[i] == '}':
            if bp > 0:
                va = s[bp + 1:i]
                va = s_get_var(glob, va, winp)
                if len(s) > i + 1:
                    i += 1
                    va = tocase(va, s[i])
                ret += va
                pos = i + 1
                bp = -3
                dp = -3
    if pos < len(s):
        ret += s[pos:len(s)]
    return ret

def tocase(s: str, c: str) -> str:
    if c == "l":
        return s.lower()
    elif c == "c":
        return s[0].upper() + s[1:].lower()
    return s

def sub_list(s: str, pos: int) -> str:
    try:
        ss = s.split(".")
        if pos >= len(ss):
            return ""
        ret = ""
        for i in range(pos, len(ss)):
            ret += ss[i]
        return ret
    except:
        return ""

