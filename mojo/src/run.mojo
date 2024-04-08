import structs

from inputs import Input

fn load(inout act: structs.ActT, inout ff: Input, tok: String, ln: Int):
        if tok == "Comp":
            var kp = structs.KpComp(ff, ln, act)
            act.ap_comp.append(kp)
            var cmd = structs.CmdT("Comp", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Element":
            var kp = structs.KpElement(ff, ln, act)
            act.ap_element.append(kp)
            var cmd = structs.CmdT("Element", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Ref":
            var kp = structs.KpRef(ff, ln, act)
            act.ap_ref.append(kp)
            var cmd = structs.CmdT("Ref", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Actor":
            var kp = structs.KpActor(ff, ln, act)
            act.ap_actor.append(kp)
            var cmd = structs.CmdT("Actor", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "All":
            var kp = structs.KpAll(ff, ln, act)
            act.ap_all.append(kp)
            var cmd = structs.CmdT("All", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Du":
            var kp = structs.KpDu(ff, ln, act)
            act.ap_du.append(kp)
            var cmd = structs.CmdT("Du", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Its":
            var kp = structs.KpIts(ff, ln, act)
            act.ap_its.append(kp)
            var cmd = structs.CmdT("Its", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "C":
            var kp = structs.KpC(ff, ln, act)
            act.ap_c.append(kp)
            var cmd = structs.CmdT("C", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Cs":
            var kp = structs.KpCs(ff, ln, act)
            act.ap_cs.append(kp)
            var cmd = structs.CmdT("Cs", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Cf":
            var kp = structs.KpCf(ff, ln, act)
            act.ap_cf.append(kp)
            var cmd = structs.CmdT("Cf", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Out":
            var kp = structs.KpOut(ff, ln, act)
            act.ap_out.append(kp)
            var cmd = structs.CmdT("Out", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Break":
            var kp = structs.KpBreak(ff, ln, act)
            act.ap_break.append(kp)
            var cmd = structs.CmdT("Break", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Unique":
            var kp = structs.KpUnique(ff, ln, act)
            act.ap_unique.append(kp)
            var cmd = structs.CmdT("Unique", kp.me)
            act.ap_cmds.append(cmd)

fn refs(inout act: structs.ActT):
    for i in range( len(act.ap_comp) ):
        try:
            var p = act.names["Comp_" + String(i) + "_parent" ]
            act.ap_comp[i].k_parentp = act.index["Comp_" + p]
        except:
            if "." != ".":
                print("except Comp_" + String(i) + "_parent Comp_"  )

    for i in range( len(act.ap_ref) ):
        try:
            var p = act.names["Ref_" + String(i) + "_element" ]
            act.ap_ref[i].k_elementp = act.index[String(act.ap_ref[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                print("except " + "Ref_" + String(i) + "_element" + " : " + String(act.ap_ref[i].parentp) + "_Element_"  )
        try:
            var p = act.names["Ref_" + String(i) + "_comp" ]
            act.ap_ref[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                print("except Ref_" + String(i) + "_comp Comp_"  )

    for i in range( len(act.ap_all) ):
        try:
            var p = act.ap_all[i].k_actor
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                print("except All_" + String(i) + "_actor Actor_"  )

    for i in range( len(act.ap_du) ):
        try:
            var p = act.ap_du[i].k_actor
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                print("except Du_" + String(i) + "_actor Actor_"  )

    for i in range( len(act.ap_its) ):
        try:
            var p = act.ap_its[i].k_actor
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                print("except Its_" + String(i) + "_actor Actor_"  )

fn d_get_var(dats: structs.ActT, cmt: structs.CmdT, va: List[String]) -> String:
    if cmt.cmd == "Comp":
        return( dats.ap_comp[ cmt.ind ].get_var(dats, va) )
    if cmt.cmd == "Element":
        return( dats.ap_element[ cmt.ind ].get_var(dats, va) )
    if cmt.cmd == "Ref":
        return( dats.ap_ref[ cmt.ind ].get_var(dats, va) )
    if cmt.cmd == "Actor":
        return( dats.ap_actor[ cmt.ind ].get_var(dats, va) )
    return("? d_get_var ?")

