import structs

from inputs import Input

fn load(inout act: structs.ActT, inout ff: Input, tok: String, ln: Int):
        if tok == "Comp":
            var kp = structs.KpComp(ff, ln, act)
            act.ap_comp.push_back(kp)
        if tok == "Element":
            var kp = structs.KpElement(ff, ln, act)
            act.ap_element.push_back(kp)
        if tok == "Ref":
            var kp = structs.KpRef(ff, ln, act)
            act.ap_ref.push_back(kp)
        if tok == "Actor":
            var kp = structs.KpActor(ff, ln, act)
            act.ap_actor.push_back(kp)
        if tok == "All":
            var kp = structs.KpAll(ff, ln, act)
            act.ap_all.push_back(kp)
            var cmd = structs.CmdT(4, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "Du":
            var kp = structs.KpDu(ff, ln, act)
            act.ap_du.push_back(kp)
            var cmd = structs.CmdT(5, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "Its":
            var kp = structs.KpIts(ff, ln, act)
            act.ap_its.push_back(kp)
            var cmd = structs.CmdT(6, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "C":
            var kp = structs.KpC(ff, ln, act)
            act.ap_c.push_back(kp)
            var cmd = structs.CmdT(7, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "Cs":
            var kp = structs.KpCs(ff, ln, act)
            act.ap_cs.push_back(kp)
            var cmd = structs.CmdT(8, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "Out":
            var kp = structs.KpOut(ff, ln, act)
            act.ap_out.push_back(kp)
            var cmd = structs.CmdT(9, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "Break":
            var kp = structs.KpBreak(ff, ln, act)
            act.ap_break.push_back(kp)
            var cmd = structs.CmdT(10, kp.me2)
            act.ap_cmds.push_back(cmd)
        if tok == "Unique":
            var kp = structs.KpUnique(ff, ln, act)
            act.ap_unique.push_back(kp)
            var cmd = structs.CmdT(11, kp.me2)
            act.ap_cmds.push_back(cmd)

fn refs(inout act: structs.ActT):
    for i in range( len(act.ap_comp) ):
        try:
            var p = act.names["Comp_" + String(i) + "_parent" ]
            act.ap_comp[i].k_parentp = act.index["Comp_" + p]
        except:
            print("except")

    for i in range( len(act.ap_ref) ):
        try:
            var p = act.names["Ref_" + String(i) + "_comp" ]
            act.ap_ref[i].k_compp = act.index["Comp_" + p]
        except:
            print("except")

    for i in range( len(act.ap_all) ):
        try:
            var p = act.names["All_" + String(i) + "_actor" ]
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            print("except")

    for i in range( len(act.ap_du) ):
        try:
            var p = act.names["Du_" + String(i) + "_actor" ]
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            print("except")

    for i in range( len(act.ap_its) ):
        try:
            var p = act.names["Its_" + String(i) + "_actor" ]
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            print("except")
