import structs

struct GlobT():
    var acts: structs.ActT
    var dats: structs.ActT

    fn __init__(inout self):
        self.acts = structs.ActT()
        self.dats = structs.ActT()

fn go_act[T: structs.Kp](dat: T, glob: GlobT, act: Int):
    var attr = glob.acts.ap_actor[act].get_var(glob.acts, "attr")
    var val = glob.acts.ap_actor[act].get_var(glob.acts, "value")
    if attr != "E_O_L":
        var aval = dat.get_var(glob.dats, attr)
        if aval != val:
            return
    for c in range(glob.acts.ap_actor[act].cmds_from, glob.acts.ap_actor[act].cmds_to):
        var cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            var cc = glob.acts.ap_c[ cmd.ind ]
            print( strs(dat, glob, cc.get_var(glob.acts, "desc") ) )
        if cmd.cmd == "All":
            var all = glob.acts.ap_all[ cmd.ind ]
            var what = all.get_var(glob.acts, "what")
            do_all(glob, what, all.k_actorp)
        if cmd.cmd == "Its":
            var its = glob.acts.ap_its[ cmd.ind ]
            var what = its.get_var(glob.acts, "what")
            dat.do_its(glob, what, its.k_actorp)

fn do_all(glob: GlobT, what: String, act: Int):
    if what == "Comp":
        for i in range( len(glob.dats.ap_comp) ):
            go_act(glob.dats.ap_comp[i], glob, act)


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
                va = dat.get_var(glob.dats, va)
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
