import structs

from inputs import Input

def load(act, ff: Input, tok: str, ln: int, lno: str):
        if tok == "Comp":
            kp = structs.KpComp(ff, ln, act, lno)
            act.ap_comp.append(kp)
            act.kp_all.append(kp)
        if tok == "Element":
            kp = structs.KpElement(ff, ln, act, lno)
            act.ap_element.append(kp)
            act.kp_all.append(kp)
        if tok == "Ref":
            kp = structs.KpRef(ff, ln, act, lno)
            act.ap_ref.append(kp)
            act.kp_all.append(kp)
        if tok == "Ref2":
            kp = structs.KpRef2(ff, ln, act, lno)
            act.ap_ref2.append(kp)
            act.kp_all.append(kp)
        if tok == "Actor":
            kp = structs.KpActor(ff, ln, act, lno)
            act.ap_actor.append(kp)
            act.kp_all.append(kp)
        if tok == "All":
            kp = structs.KpAll(ff, ln, act, lno)
            act.ap_all.append(kp)
            act.kp_all.append(kp)
        if tok == "Du":
            kp = structs.KpDu(ff, ln, act, lno)
            act.ap_du.append(kp)
            act.kp_all.append(kp)
        if tok == "Its":
            kp = structs.KpIts(ff, ln, act, lno)
            act.ap_its.append(kp)
            act.kp_all.append(kp)
        if tok == "C":
            kp = structs.KpC(ff, ln, act, lno)
            act.ap_c.append(kp)
            act.kp_all.append(kp)
        if tok == "Cs":
            kp = structs.KpCs(ff, ln, act, lno)
            act.ap_cs.append(kp)
            act.kp_all.append(kp)
        if tok == "Cf":
            kp = structs.KpCf(ff, ln, act, lno)
            act.ap_cf.append(kp)
            act.kp_all.append(kp)
        if tok == "Out":
            kp = structs.KpOut(ff, ln, act, lno)
            act.ap_out.append(kp)
            act.kp_all.append(kp)
        if tok == "Break":
            kp = structs.KpBreak(ff, ln, act, lno)
            act.ap_break.append(kp)
            act.kp_all.append(kp)
        if tok == "Unique":
            kp = structs.KpUnique(ff, ln, act, lno)
            act.ap_unique.append(kp)
            act.kp_all.append(kp)

def refs(act) -> bool:
    err = False
    for i in range( len(act.ap_comp) ):
        try:
            p = act.ap_comp[i].names[ "parent" ]
            act.ap_comp[i].k_parentp = act.index["Comp_" + p]
        except:
            if "." != ".":
                err = True
                print("except Comp_" + str(i) + "_parent Comp_"  )

    for i in range( len(act.ap_ref) ):
        try:
            p = act.ap_ref[i].names[ "element" ]
            act.ap_ref[i].k_elementp = act.index[ str(act.ap_ref[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print("except " + "Ref_" + str(i) + "_element" + " : " + str(act.ap_ref[i].parentp) + "_Element_"  )
        try:
            p = act.ap_ref[i].names[ "comp" ]
            act.ap_ref[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                err = True
                print("except Ref_" + str(i) + "_comp Comp_"  )

    for i in range( len(act.ap_ref2) ):
        try:
            p = act.ap_ref2[i].names[ "element" ]
            act.ap_ref2[i].k_elementp = act.index[ str(act.ap_ref2[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print("except " + "Ref2_" + str(i) + "_element" + " : " + str(act.ap_ref2[i].parentp) + "_Element_"  )
        try:
            p = act.ap_ref2[i].names[ "comp" ]
            act.ap_ref2[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                err = True
                print("except Ref2_" + str(i) + "_comp Comp_"  )
        try:
            p = act.ap_ref2[i].names[ "element2" ]
            act.ap_ref2[i].k_element2p = act.index[ str(act.ap_ref2[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print("except " + "Ref2_" + str(i) + "_element2" + " : " + str(act.ap_ref2[i].parentp) + "_Element_"  )

    for i in range( len(act.ap_all) ):
        try:
            p = act.ap_all[i].k_actor
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("except All_" + str(i) + "_actor Actor_"  )

    for i in range( len(act.ap_du) ):
        try:
            p = act.ap_du[i].k_actor
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("except Du_" + str(i) + "_actor Actor_"  )

    for i in range( len(act.ap_its) ):
        try:
            p = act.ap_its[i].k_actor
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("except Its_" + str(i) + "_actor Actor_"  )

    return err

