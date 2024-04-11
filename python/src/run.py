import structs

from inputs import Input

def load(act: structs.ActT, ff: Input, tok: str, ln: int):
        if tok == "Comp":
            kp = structs.KpComp(ff, ln, act)
            act.ap_comp.append(kp)
            cmd = structs.CmdT("Comp", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Element":
            kp = structs.KpElement(ff, ln, act)
            act.ap_element.append(kp)
            cmd = structs.CmdT("Element", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Ref":
            kp = structs.KpRef(ff, ln, act)
            act.ap_ref.append(kp)
            cmd = structs.CmdT("Ref", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Actor":
            kp = structs.KpActor(ff, ln, act)
            act.ap_actor.append(kp)
            cmd = structs.CmdT("Actor", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "All":
            kp = structs.KpAll(ff, ln, act)
            act.ap_all.append(kp)
            cmd = structs.CmdT("All", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Du":
            kp = structs.KpDu(ff, ln, act)
            act.ap_du.append(kp)
            cmd = structs.CmdT("Du", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Its":
            kp = structs.KpIts(ff, ln, act)
            act.ap_its.append(kp)
            cmd = structs.CmdT("Its", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "C":
            kp = structs.KpC(ff, ln, act)
            act.ap_c.append(kp)
            cmd = structs.CmdT("C", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Cs":
            kp = structs.KpCs(ff, ln, act)
            act.ap_cs.append(kp)
            cmd = structs.CmdT("Cs", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Cf":
            kp = structs.KpCf(ff, ln, act)
            act.ap_cf.append(kp)
            cmd = structs.CmdT("Cf", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Out":
            kp = structs.KpOut(ff, ln, act)
            act.ap_out.append(kp)
            cmd = structs.CmdT("Out", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Break":
            kp = structs.KpBreak(ff, ln, act)
            act.ap_break.append(kp)
            cmd = structs.CmdT("Break", kp.me)
            act.ap_cmds.append(cmd)
        if tok == "Unique":
            kp = structs.KpUnique(ff, ln, act)
            act.ap_unique.append(kp)
            cmd = structs.CmdT("Unique", kp.me)
            act.ap_cmds.append(cmd)

def refs(act: structs.ActT):
    for i in range( len(act.ap_comp) ):
        try:
            p = act.ap_comp[i].names[ "parent" ]
            act.ap_comp[i].k_parentp = act.index["Comp_" + p]
        except:
            if "." != ".":
                print("except Comp_" + str(i) + "_parent Comp_"  )

    for i in range( len(act.ap_ref) ):
        try:
            p = act.ap_ref[i].names[ "element" ]
            act.ap_ref[i].k_elementp = act.index[ str(act.ap_ref[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                print("except " + "Ref_" + str(i) + "_element" + " : " + str(act.ap_ref[i].parentp) + "_Element_"  )
        try:
            p = act.ap_ref[i].names[ "comp" ]
            act.ap_ref[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                print("except Ref_" + str(i) + "_comp Comp_"  )

    for i in range( len(act.ap_all) ):
        try:
            p = act.ap_all[i].k_actor
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                print("except All_" + str(i) + "_actor Actor_"  )

    for i in range( len(act.ap_du) ):
        try:
            p = act.ap_du[i].k_actor
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                print("except Du_" + str(i) + "_actor Actor_"  )

    for i in range( len(act.ap_its) ):
        try:
            p = act.ap_its[i].k_actor
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                print("except Its_" + str(i) + "_actor Actor_"  )

