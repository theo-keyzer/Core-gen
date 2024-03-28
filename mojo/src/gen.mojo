import structs

struct GlobT():
    var acts: structs.ActT
    var dats: structs.ActT

    fn __init__(inout self):
        self.acts = structs.ActT()
        self.dats = structs.ActT()

fn go_act[T: structs.Kp](dat: T, glob: GlobT, act: Int):
    for c in range(glob.acts.ap_actor[act].cmds_from, glob.acts.ap_actor[act].cmds_to):
        var cmd = glob.acts.ap_cmds[c]
        if cmd.cmd == "C":
            var cc = glob.acts.ap_c[ cmd.ind ]
            print( cc.get_var(glob.acts, "desc") )
        if cmd.cmd == "All":
            var all = glob.acts.ap_all[ cmd.ind ]
            var what = all.get_var(glob.acts, "what")
            do_all(glob, what, all.k_actorp)

fn do_all(glob: GlobT, what: String, act: Int):
    if what == "Comp":
        for i in range( len(glob.dats.ap_comp) ):
            go_act(glob.dats.ap_comp[i], glob, act)



