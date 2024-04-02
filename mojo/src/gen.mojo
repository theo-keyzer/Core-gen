import structs

@value
struct WinT(CollectionElement):
    var name: String
    var me2: Int

    fn __init__(inout self):
        self.name = "a"
        self.me2 = 0

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

#		new_act(glob, glob.acts.ap_actor[0].k_name, "", "run:1", "", "", "");
#		go_act(glob, kp);

fn new_act(inout glob: GlobT):
    var winp = glob.winp+1;
    if len(glob.wins) <= winp:
        glob.wins.append( WinT() )


fn go_act[T: structs.Kp](dat: T, inout glob: GlobT, act: Int):
#    print( glob.winp, len( glob.wins) )
    var name = glob.acts.ap_actor[act].k_name
    glob.winp = glob.winp+1
    glob.wins[ glob.winp ].me2 = dat.get_me2()
    glob.wins[ glob.winp ].name = name
    for a in range( len( glob.acts.ap_actor ) ):
        if name != glob.acts.ap_actor[a].k_name:
            continue
        var attr = glob.acts.ap_actor[a].k_attr
        var val = glob.acts.ap_actor[a].k_value
        var cc = glob.acts.ap_actor[a].k_cc
        var eq = glob.acts.ap_actor[a].k_eq
        if attr != "E_O_L":
#            var aval = dat.get_var(glob.dats, attr)
            var aval = s_get_var(dat, glob, attr)
#            if aval != val:
            if chk(eq, aval, val) == False:
#                print(eq,aval,val)
                continue
        if cc != "":
            print( strs(dat, glob, cc) )
        var ret = go_cmds(dat, glob, a)
        if ret != 0:
            break
    glob.winp = glob.winp-1

fn go_cmds[T: structs.Kp](dat: T, inout glob: GlobT, act: Int) -> Int:
    for c in range(glob.acts.ap_actor[act].cmds_from, glob.acts.ap_actor[act].cmds_to):
        var cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            var cc = glob.acts.ap_c[ cmd.ind ]
            print( strs(dat, glob, cc.k_desc) )
        if cmd.cmd == "All":
            var all = glob.acts.ap_all[ cmd.ind ]
            var what = all.k_what
            new_act(glob)
            do_all(glob, what, all.k_actorp)
        if cmd.cmd == "Its":
            var its = glob.acts.ap_its[ cmd.ind ]
            var what = its.k_what
            new_act(glob)
            dat.do_its(glob, what, its.k_actorp)
        if cmd.cmd == "Du":
            var du = glob.acts.ap_du[ cmd.ind ]
            new_act(glob)
            go_act(dat, glob, du.k_actorp)
        if cmd.cmd == "Break":
            return(1)
    return(0)

fn chk(eq: String, aval: String, val: String) -> Bool:
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

fn do_all(inout glob: GlobT, what: String, act: Int):
    if what == "Comp":
        for i in range( len(glob.dats.ap_comp) ):
            go_act(glob.dats.ap_comp[i], glob, act)


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
            for i in range( glob.winp, 0, -1):
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

