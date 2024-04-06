import structs

@value
struct WinT(CollectionElement):
    var name: String
    var me2: Int
    var lcnt: Int
    var brk_act: Bool
    var cur_act: Int
    var cur_pos: Int
    var on_pos: Int
    var is_on: Bool
    var is_trig: Bool
    var is_prev: Bool

# The Du cmd is for nested if/case
# The control flow (Break) in the Duing actor aplies to the caling actor

    fn __init__(inout self):
        self.name = "a"
        self.me2 = 0
        self.lcnt = 0
        self.brk_act = False
        self.cur_act = 0
        self.cur_pos = 0
        self.on_pos = 0
        self.is_on = False
        self.is_trig = False
        self.is_prev = False

struct GlobT():
    var acts: structs.ActT
    var dats: structs.ActT
    var wins: List[WinT]
    var winp: Int

    fn __init__(inout self):
        self.acts = structs.ActT()
        self.dats = structs.ActT()
        self.wins = List[WinT]()
        self.winp = -1


fn new_act(inout glob: GlobT):
    var winp = glob.winp+1;
    if len(glob.wins) <= winp:
        glob.wins.append( WinT() )
    glob.wins[winp].lcnt = -1
    glob.wins[winp].brk_act = False
    if (winp == 0):
        return
    if glob.wins[winp-1].is_on or glob.wins[winp-1].is_prev:
        if glob.wins[winp-1].is_trig == False: 
            glob.wins[winp].is_prev = True

fn go_act[T: structs.Kp](dat: T, inout glob: GlobT, act: Int) -> Int:
    var name = glob.acts.ap_actor[act].k_name
    glob.winp = glob.winp+1
    glob.wins[ glob.winp ].me2 = dat.get_me2()
    glob.wins[ glob.winp ].name = name
    var prev = False
    for a in range( len( glob.acts.ap_actor ) ):
        if name != glob.acts.ap_actor[a].k_name:
            continue
        var attr = glob.acts.ap_actor[a].k_attr
        var val = glob.acts.ap_actor[a].k_value
        var cc = glob.acts.ap_actor[a].k_cc
        var eq = glob.acts.ap_actor[a].k_eq
        if attr != "E_O_L":
            var aval = s_get_var(dat, glob, attr)
            prev = chk(eq, aval, val, prev)
            if prev == False:
                continue
        if cc != "":
            print( strs(dat, glob, cc) )
        glob.wins[ glob.winp ].cur_act = a;
        glob.wins[ glob.winp ].lcnt += 1
        var ret = go_cmds(dat, glob, a)
        if ret == 0 or ret == 3:
            continue
        var nret = ret
        if ret == 2:
            nret = 0
        if ret < 0 and glob.wins[ glob.winp ].brk_act == True:
            nret = 0-ret
        glob.winp = glob.winp-1
        return(nret)
    glob.winp = glob.winp-1
    return(0)

fn go_cmds[T: structs.Kp](dat: T, inout glob: GlobT, act: Int) -> Int:
    glob.wins[glob.winp].is_on   = False
    glob.wins[glob.winp].is_trig = False
    for c in range(glob.acts.ap_actor[act].cmds_from, glob.acts.ap_actor[act].cmds_to):
        glob.wins[glob.winp].cur_pos = c
        var cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            if glob.wins[glob.winp].is_on and glob.wins[glob.winp].is_trig == False:
                continue
            trig(glob,glob.winp)
            var cc = glob.acts.ap_c[ cmd.ind ]
            print( strs(dat, glob, cc.k_desc) )
        if cmd.cmd == "Cf":
            if glob.wins[ glob.winp ].lcnt == 0:
                var cf = glob.acts.ap_cf[ cmd.ind ]
                print( strs(dat, glob, cf.k_desc) )
        if cmd.cmd == "All":
            var all = glob.acts.ap_all[ cmd.ind ]
            var what = all.k_what
            new_act(glob)
            var ret = do_all(glob, what, all.k_actorp)
            if ret > 1 or ret < 0:
                return(ret)
        if cmd.cmd == "Its":
            var its = glob.acts.ap_its[ cmd.ind ]
            var what = its.k_what
            new_act(glob)
            var ret = dat.do_its(glob, what, its.k_actorp)
            if ret > 1 or ret < 0:
                return(ret)
        if cmd.cmd == "Du":
            var du = glob.acts.ap_du[ cmd.ind ]
            new_act(glob)
            var ret = go_act(dat, glob, du.k_actorp)
            if ret != 0:
                return(ret)
        if cmd.cmd == "Out":
            var out = glob.acts.ap_out[ cmd.ind ]
            if out.k_what == "delay":
                glob.wins[ glob.winp ].is_on = True
                glob.wins[ glob.winp ].on_pos = c
            if out.k_what == "normal":
                glob.wins[ glob.winp ].is_on = False
                glob.wins[ glob.winp ].is_trig = False
        if cmd.cmd == "Break":
            var brk = glob.acts.ap_break[ cmd.ind ]
            var ret = 0
            if brk.k_what == "E_O_L" or brk.k_what == "actor":
                ret = 2
            if brk.k_what == "loop":
                ret = 1
            if brk.k_what == "cmds":
                ret = 3
            if brk.k_actor != "E_O_L":
                for i in range( glob.winp-1, -1, -1):
                    if brk.k_actor == glob.wins[i].name:
                        glob.wins[i+1].brk_act = True
                        ret = 0 - ret
            return(ret)
    return(0)

fn trig(inout glob: GlobT, winp: Int):
    if glob.wins[winp].is_prev == False or winp == 0:
        return
    glob.wins[winp].is_prev = False
    var prev = winp - 1
    if glob.wins[ prev ].is_on == False and glob.wins[ prev ].is_prev == False:
        return
    if glob.wins[ prev ].is_trig == True:
        return
    glob.wins[ prev ].is_trig = True
    re_go_cmds(glob, prev )


fn re_go_cmds(inout glob: GlobT, winp: Int):
    trig(glob,winp);
    var a = glob.acts.ap_actor[ glob.wins[winp].cur_act ];
    var me2 = glob.wins[winp].me2
    for c in range(glob.wins[winp].on_pos, glob.wins[winp].cur_pos):
        var cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            var cc = glob.acts.ap_c[ cmd.ind ]
            if glob.dats.ap_cmds[ me2 ].cmd == "Comp":
                print( strs(glob.dats.ap_comp[ glob.dats.ap_cmds[ me2 ].ind ], glob, cc.k_desc) )

fn chk(eqa: String, aval: String, val: String, prev: Bool) -> Bool:
    var eq = eqa
    if eq[0] == "&":
        if prev == False:
            return( False )
        eq = eq[1:]
    if eq == "=":
        if aval == val:
            return(True)
        return(False)
    if eq == "in":
        try:
            var ss = val.split(",")
            for i in range( len(ss) ):
                if aval == ss[i]:
                    return(True)
            return(False)
        except:
            return(False)
    return(False)

fn do_all(inout glob: GlobT, what: String, act: Int) -> Int:
    if what == "Comp":
        for i in range( len(glob.dats.ap_comp) ):
            var ret = go_act(glob.dats.ap_comp[i], glob, act)
            if ret != 0:
                return(ret)
    return(0)


fn d_get_var(glob: GlobT, i: Int, va: List[String]) -> String:
    var me2 = glob.wins[i].me2
    if glob.dats.ap_cmds[ me2 ].cmd == "Comp":
        return( glob.dats.ap_comp[ glob.dats.ap_cmds[ me2 ].ind ].get_var(glob.dats, va) )
    if glob.dats.ap_cmds[ me2 ].cmd == "Element":
        return( glob.dats.ap_element[ glob.dats.ap_cmds[ me2 ].ind ].get_var(glob.dats, va) )
    if glob.dats.ap_cmds[ me2 ].cmd == "Ref":
        return( glob.dats.ap_ref[ glob.dats.ap_cmds[ me2 ].ind ].get_var(glob.dats, va) )
    return("? d_get_var ?")

fn s_get_var[T: structs.Kp](dat: T, glob: GlobT, va: String) -> String:
    try:
        var ss = va.split(".")
        if ss[0] == "":
#            return( ss[1] )
            for i in range( glob.winp, -1, -1):
                if ss[1] == glob.wins[i].name:
                    return( d_get_var(glob, i, ss[2:]) )
        var val = dat.get_var(glob.dats, ss)
        return val
    except:
        print("s_get_var"  )
        return("????")


fn strs[T: structs.Kp](dat: T, glob: GlobT, s: String) -> String:
    var ret: String = ""
    var pos = 0
    var dp = -3
    var bp = -3
    for i in range(len(s)):
        if s[i] == '$':
            dp = i
        if s[i] == '{':
            if i == dp+1:
                ret += s[pos:i-1]
                pos = i
                bp = i
        if s[i] == '}':
            if bp > 0:
                var va = s[bp+1:i]
                va = s_get_var(dat, glob, va)
#                va = dat.get_var(glob.dats, va)
                if len(s) > i+1:
                    i += 1
                    va = tocase(va, s[i])
                ret += va
                pos = i+1
                bp = -3
                dp = -3
    if pos < len(s):
        ret += s[pos:len(s)]
    return(ret)

fn tocase(s: String, c: String) -> String:
    if c == "l":
        return(s.lower())
    if c == "c":
        return( s[0].upper() + s[1:].lower() )
    return(s)

fn sub_list(s: String, pos: Int) -> String : 
    try:
        var ss = s.split(".")
        if pos >= len(ss):
            return("")
        var ret: String = ""
        for i in range(pos, len(ss)):
            ret += ss[i]
        return(ret)
    except:
        return("")

