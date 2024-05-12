import structs

class WinT:
    def __init__(self):
        self.dat = structs.Kp()
        self.name = ""
        self.item = ""
        self.arg = ""
        self.lcnt = 0
        self.brk_act = False
        self.cur_act = 0
        self.cur_pos = 0
        self.on_pos = 0
        self.is_on = False
        self.is_trig = False
        self.is_prev = False
        self.is_check = False

def new_act(glob, arg):
    winp = glob.winp + 1
    if len(glob.wins) <= winp:
        glob.wins.append(WinT())
    glob.wins[winp].arg = arg
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
        lno = glob.acts.ap_actor[a].line_no
        if attr != "E_O_L":
            ss = attr.split(".")
            val,err = strs(glob, val, glob.winp, lno, False, False)
            aval,aerr = s_get_var(glob, ss, glob.winp, lno)
            prev = chk(glob, eq, aval, val, prev, aerr, err, lno)
            if not prev:
                continue
        if cc != "":
            ps,err = strs(glob, cc, glob.winp, lno, True, True)
            print(ps)
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

def go_cmds(dat, glob, act: int) -> int:
    glob.wins[glob.winp].is_on = False
    glob.wins[glob.winp].is_trig = False
    glob.wins[glob.winp].on_pos = -1
    glob.wins[glob.winp].is_check = False
    for c in range(glob.acts.ap_actor[act].all_from, glob.acts.ap_actor[act].all_to):
        glob.wins[glob.winp].cur_pos = c
        cmd = glob.acts.kp_all[c]
        if isinstance(cmd,structs.KpC):
            if glob.wins[glob.winp].is_on and not glob.wins[glob.winp].is_trig:
                continue
            trig(glob, glob.winp)
            cc = cmd
            st,err = strs(glob, cc.k_desc, glob.winp, cc.line_no, False, True)
            print( st )
        if isinstance(cmd,structs.KpCs):
            if glob.wins[glob.winp].is_on and not glob.wins[glob.winp].is_trig:
                continue
            trig(glob, glob.winp)
            cc = cmd
            st,err = strs(glob, cc.k_desc, glob.winp, cc.line_no, False, True)
            print( st, end="" )
        elif isinstance(cmd,structs.KpCf):
            if glob.wins[glob.winp].lcnt == 0:
                cf = cmd
                st,err = strs(glob, cf.k_desc, glob.winp, cf.line_no, False, True)
                print(st)
        elif isinstance(cmd,structs.KpAll):
            all = cmd
            what = all.k_what.split(".")
            new_act(glob,all.k_args)
            ret = structs.do_all(glob, what, all.k_actorp)
            if ret > 1 or ret < 0:
                return ret
        elif isinstance(cmd,structs.KpThis):
            its = cmd
            what = its.k_what.split(".")
            val,err = strs(glob, its.k_args, glob.winp, cmd.line_no, True, True)
            new_act(glob, val)
            col = ""
            if what[0] == "set":
                col = glob.sets
            elif what[0] == "list":
                col = glob.lists
            elif what[0] == "var":
                col = glob.vars
            else:
                continue
            if len(what) > 1:
                if what[1] in col:
                    glob.wins[glob.winp+1].item = what[1]
                    poc = col[ what[1] ]
                    if what[0] == "var":
                        ret = go_act(poc, glob, its.k_actorp)
                        if ret > 1 or ret < 0:
                            return ret
                        continue
                    for sts in poc:
                        ret = go_act(sts,glob, its.k_actorp)
                        if ret > 1 or ret < 0:
                            return ret
                continue
            keys = list(col.keys())
            for key in keys:
                glob.wins[glob.winp+1].item = key
                poc = col[ key ]
                if what[0] == "var":
                    ret = go_act(poc, glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
                    continue
                for sts in poc:
                    ret = go_act(sts,glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
            continue
        elif isinstance(cmd,structs.KpIts):
            its = cmd
            what = its.k_what.split(".")
            val,err = strs(glob, its.k_args, glob.winp, cmd.line_no, True, True)
            new_act(glob, val)
            ret = dat.do_its(glob, what, its.k_actorp)
            if ret > 1 or ret < 0:
                return ret
        elif isinstance(cmd,structs.KpDu):
            du = cmd
            st,err = strs(glob, du.k_args, glob.winp, du.line_no, True, True)
            new_act(glob, st)
            ret = go_act(dat, glob, du.k_actorp)
            if ret != 0:
                return ret
        elif isinstance(cmd,structs.KpAdd):
            add_cmd(cmd,glob,dat)
        elif isinstance(cmd,structs.KpCheck):
            check_cmd(cmd,glob,dat)
        elif isinstance(cmd,structs.KpClear):
            clear_cmd(cmd,glob,dat)
        elif isinstance(cmd,structs.KpOut):
            out = cmd
            if out.k_what == "delay":
                glob.wins[glob.winp].is_on = True
                glob.wins[glob.winp].on_pos = c
            elif out.k_what == "normal":
                glob.wins[glob.winp].is_on = False
                glob.wins[glob.winp].is_trig = False
        elif isinstance(cmd,structs.KpBreak):
            brk = cmd
            if brk.k_check == "True" and glob.wins[glob.winp].is_check == False:
                continue
            if brk.k_check == "False" and glob.wins[glob.winp].is_check == True:
                continue
            ret = 0
            if brk.k_what == "E_O_L" or brk.k_what == "actor":
                ret = 2
            elif brk.k_what == "loop":
                ret = 1
            elif brk.k_what == "cmds":
                ret = 3
            if brk.k_actor != "E_O_L" and brk.k_actor != ".":
                for i in range(glob.winp - 1, -1, -1):
                    if brk.k_actor == glob.wins[i].name:
                        glob.wins[i + 1].brk_act = True
                        ret = -ret
            return ret
    return 0

def add_cmd(cmd,glob,dat):
    glob.wins[glob.winp].is_check = False
    if cmd.k_data != "":
        val,err = strs(glob, cmd.k_data, glob.winp, cmd.line_no, True, True)
    else:
        val = dat
    if cmd.k_what == "var":
        glob.vars[ cmd.k_item ] = val
    if cmd.k_what == "set":
        if cmd.k_item in glob.sets:
            if val in glob.sets[ cmd.k_item ]:
                glob.wins[glob.winp].is_check = True
            else:
                glob.sets[ cmd.k_item ].add(val)
        else:
            glob.sets[ cmd.k_item ] = {val}
        return
    if cmd.k_what == "list":
        if cmd.k_item in glob.lists:
            glob.lists[ cmd.k_item ].append(val)
        else:
            glob.lists[ cmd.k_item ] = [val]
        return
    sw = cmd.k_what.split('.')
    if len(sw) > 1 and sw[0] == "set" and sw[1] == "split":
        sc = '.'
        if len(sw) > 2:
            sc = sw[2]
        svs = val.split( sc )
        for sv in svs:
            if cmd.k_item in glob.sets:
                glob.sets[ cmd.k_item ].add(sv)
            else:
                glob.sets[ cmd.k_item ] = {sv}
        return



def clear_cmd(cmd,glob,dat):
    if cmd.k_what == "set":
        if cmd.k_item in glob.sets:
            glob.sets[ cmd.k_item ].clear()
    if cmd.k_what == "list":
        if cmd.k_item in glob.lists:
            glob.lists[ cmd.k_item ].clear()

def check_cmd(cmd,glob,dat):
    if cmd.k_data != "E_O_L":
        val = cmd.k_data
    else:
        val = dat
    if cmd.k_what == "set":
        if cmd.k_item in glob.sets:
            if val in glob.sets[ cmd.k_item ]:
                glob.wins[glob.winp].is_check = True

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
    if glob.wins[winp].on_pos < 0:
        return
    a = glob.acts.ap_actor[glob.wins[winp].cur_act]
    for c in range(glob.wins[winp].on_pos, glob.wins[winp].cur_pos):
        cmd = glob.acts.kp_all[c]
        if isinstance(cmd,structs.KpC):
            cc = cmd
            st,err = strs(glob, cc.k_desc, winp, cc.line_no, False, True)
            print(st)
        if isinstance(cmd,structs.KpCs):
            cc = cmd
            st,err = strs(glob, cc.k_desc, winp, cc.line_no, False, True)
            print(st, end="")


def chk(glob, eqa: str, aval: str, val: str, prev: bool, attr_err: bool, val_err: bool, lno: str) -> bool:
    eq = eqa
    if eq == "??":
        return attr_err or val_err
    if eq[0] == "?":
        if attr_err or val_err:
            return False
        if len(eq) == 1:
            return True
        eq = eq[1:]
    if eq[0] == "&":
        if not prev:
            return False
        if len(eq) == 1:
            return True
        eq = eq[1:]
    if eq[0] == "|":
        if prev:
            return True
        if len(eq) == 1:
            return True
        eq = eq[1:]
    if val_err:
        glob.run_errs = True
        print(val)
        return False
    if attr_err:
        glob.run_errs = True
        print(aval)
        return False
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
    elif eq == "has":
        try:
            ss = aval.split(",")
            for i in range(len(ss)):
                if val == ss[i]:
                    return True
            return False
        except:
            return False
    print("?No actor match (" + eqa + ") " + lno + "?")
    glob.run_errs = True
    return False

def s_get_var(glob, ss: list[str], winp: int, lno: str) -> (str, bool):
    try:
        if len( ss[0] ) != 0:
            return glob.wins[winp].dat.get_var(glob.dats, ss, lno)
        if len(ss) == 1:
            return( glob.wins[winp].dat.line_no + ", " + lno, False )
        if ss[1] == "_str":
            return( glob.wins[winp].dat, False )
        if ss[1] == "_arg":
            return( glob.wins[winp].arg, False )
        if ss[1] == "_key":
            return( glob.wins[winp].item, False )
        if ss[1] == "+":
            return( str( glob.wins[winp].lcnt+1 ), False )
        if ss[1] == '-':
            return( str( glob.wins[winp].lcnt ), False )
        if ss[1] == '_depth':
            return( str( winp ), False )
        if len(ss) < 3:
            return ("?" + str(ss) + "?" + lno + "?", True)
        if ss[1] == "_var":
            dat = glob.vars[ ss[2] ]
            if len(ss) == 3:
                return(dat, False)
            return( dat.get_var(glob.dats, ss[3:], lno) )
        if ss[1] == "0":
            if glob.wins[winp].lcnt != 0:
                return( "", False )
            return( ss[2], False )
        if ss[1] == "1":
            if glob.wins[winp].lcnt == 0:
                return( "", False )
            return( ss[2], False )
        for i in range(winp, -1, -1):
            if ss[1] == glob.wins[i].name:
                return( s_get_var(glob, ss[2:], i, lno) )
        return ("?" + str(ss) + "?" + lno + "?", True)
    except Exception as e:
        return ("?" + str(ss) + "?" + lno + "?", True)

def strs(glob, s: str, winp: int, lno: str, pr_err, is_err) -> (str, bool):
    err = False
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
                ss = va.split(".")
                va, er = s_get_var(glob, ss, winp, lno)
                if er:
                    err = True
                    if is_err:
                        glob.run_errs = True
                    if pr_err:
                        print(va)
                else:
                    if len(s) > i + 1:
                        i += 1
                        va = tocase(va, s[i])
                ret += va
                pos = i + 1
                bp = -3
                dp = -3
    if pos < len(s):
        ret += s[pos:len(s)]
    return(ret, err)

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

