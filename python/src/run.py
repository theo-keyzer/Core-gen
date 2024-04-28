import structs

from inputs import Input

def refs(act) -> bool:
    err = False
    err = ref(act)
    er, cnt = ref_other(act, True)
    err = err or er
    return err

def refs_multi_pass(act) -> bool:
    err = ref(act)
    prev = 1000
    for i in range(0,6):
        er, cnt = ref_other(act, False)
        if cnt == 0 or cnt == prev:
            break
        prev = cnt
    er, cnt = ref_other(act, True)
    err = err or er
    return err

def load(act, ff: Input, tok: str, ln: int, lno: str):
        if tok == "Comp":
            kp = structs.KpComp(ff, ln, act, lno)
            act.ap_comp.append(kp)
            act.kp_all.append(kp)
        if tok == "Element":
            kp = structs.KpElement(ff, ln, act, lno)
            act.ap_element.append(kp)
            act.kp_all.append(kp)
        if tok == "Opt":
            kp = structs.KpOpt(ff, ln, act, lno)
            act.ap_opt.append(kp)
            act.kp_all.append(kp)
        if tok == "Ref":
            kp = structs.KpRef(ff, ln, act, lno)
            act.ap_ref.append(kp)
            act.kp_all.append(kp)
        if tok == "Ref2":
            kp = structs.KpRef2(ff, ln, act, lno)
            act.ap_ref2.append(kp)
            act.kp_all.append(kp)
        if tok == "Refu":
            kp = structs.KpRefu(ff, ln, act, lno)
            act.ap_refu.append(kp)
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

def ref(act) -> bool:
    err = False
    for i in range( len(act.ap_comp) ):
        try:
            act.ap_comp[i].k_parentp = -2
            p = act.ap_comp[i].names[ "parent" ]
            act.ap_comp[i].k_parentp = act.index["Comp_" + p]
        except:
            if "." != ".":
                err = True
                print("Comp_" + p + " not found " + act.ap_comp[i].line_no)

    for i in range( len(act.ap_ref) ):
        try:
            act.ap_ref[i].k_elementp = -2
            p = act.ap_ref[i].names[ "element" ]
            act.ap_ref[i].k_elementp = act.index[ str(act.ap_ref[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_ref[i].parentp) + "_Element_" + p + " not found " + act.ap_ref[i].line_no)
        try:
            act.ap_ref[i].k_compp = -2
            p = act.ap_ref[i].names[ "comp" ]
            act.ap_ref[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                err = True
                print("Comp_" + p + " not found " + act.ap_ref[i].line_no)

    for i in range( len(act.ap_ref2) ):
        try:
            act.ap_ref2[i].k_elementp = -2
            p = act.ap_ref2[i].names[ "element" ]
            act.ap_ref2[i].k_elementp = act.index[ str(act.ap_ref2[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_ref2[i].parentp) + "_Element_" + p + " not found " + act.ap_ref2[i].line_no)
        try:
            act.ap_ref2[i].k_compp = -2
            p = act.ap_ref2[i].names[ "comp" ]
            act.ap_ref2[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                err = True
                print("Comp_" + p + " not found " + act.ap_ref2[i].line_no)
        try:
            act.ap_ref2[i].k_element2p = -2
            p = act.ap_ref2[i].names[ "element2" ]
            act.ap_ref2[i].k_element2p = act.index[ str(act.ap_ref2[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_ref2[i].parentp) + "_Element_" + p + " not found " + act.ap_ref2[i].line_no)

    for i in range( len(act.ap_refu) ):
        try:
            act.ap_refu[i].k_elementp = -2
            p = act.ap_refu[i].names[ "element" ]
            act.ap_refu[i].k_elementp = act.index[ str(act.ap_refu[i].parentp) + "_Element_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_refu[i].parentp) + "_Element_" + p + " not found " + act.ap_refu[i].line_no)
        try:
            act.ap_refu[i].k_compp = -2
            p = act.ap_refu[i].names[ "comp" ]
            act.ap_refu[i].k_compp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                err = True
                print("Comp_" + p + " not found " + act.ap_refu[i].line_no)
        try:
            act.ap_refu[i].k_comp_refp = -2
            p = act.ap_refu[i].names[ "comp_ref" ]
            act.ap_refu[i].k_comp_refp = act.index["Comp_" + p]
        except:
            if "check" != ".":
                err = True
                print("Comp_" + p + " not found " + act.ap_refu[i].line_no)

    for i in range( len(act.ap_all) ):
        try:
            act.ap_all[i].k_actorp = -2
            p = act.ap_all[i].k_actor
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_all[i].line_no)

    for i in range( len(act.ap_du) ):
        try:
            act.ap_du[i].k_actorp = -2
            p = act.ap_du[i].k_actor
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_du[i].line_no)

    for i in range( len(act.ap_its) ):
        try:
            act.ap_its[i].k_actorp = -2
            p = act.ap_its[i].k_actor
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_its[i].line_no)

    return(err)

def ref_other(act, check: bool) -> (bool, int):
    err = False
    cnt = 0
    return(err,cnt)

