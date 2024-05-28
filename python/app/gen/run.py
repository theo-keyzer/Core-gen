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

def load(act, ff: Input, tok: str, ln: int, lno: str) -> bool:
        err = False
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Comp":
            kp = structs.KpComp(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_comp.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Element":
            kp = structs.KpElement(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_element.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Opt":
            kp = structs.KpOpt(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_opt.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Ref":
            kp = structs.KpRef(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_ref.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Ref2":
            kp = structs.KpRef2(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_ref2.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Refu":
            kp = structs.KpRefu(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_refu.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Actor":
            kp = structs.KpActor(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_actor.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "All":
            kp = structs.KpAll(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_all.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Du":
            kp = structs.KpDu(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_du.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Its":
            kp = structs.KpIts(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_its.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "This":
            kp = structs.KpThis(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_this.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "That":
            kp = structs.KpThat(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_that.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "In":
            kp = structs.KpIn(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_in.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "C":
            kp = structs.KpC(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_c.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Cs":
            kp = structs.KpCs(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_cs.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Cf":
            kp = structs.KpCf(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_cf.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Out":
            kp = structs.KpOut(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_out.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Break":
            kp = structs.KpBreak(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_break.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Add":
            kp = structs.KpAdd(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_add.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Clear":
            kp = structs.KpClear(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_clear.append(kp)
            act.kp_all.append(kp)
        ss = tok.split('.',1)
        flag = ""
        flag = []
        if len(ss) > 1:
            flag = ss[1].split('.')
        if ss[0] == "Check":
            kp = structs.KpCheck(ff, ln, act, lno,flag)
            err = err or kp.err
            act.ap_check.append(kp)
            act.kp_all.append(kp)
        return(err)
def ref(act) -> bool:
    err = False
    for i in range( len(act.ap_comp) ):
        p = ""
        try:
            act.ap_comp[i].k_parentp = -2
            p = act.ap_comp[i].names[ "parent" ]
            act.ap_comp[i].k_parentp = act.index["Comp_" + p]
        except:
            if p != ".":
                print("Comp_" + p + " not found " + act.ap_comp[i].line_no)
                err = True

    for i in range( len(act.ap_ref) ):
        p = ""
        try:
            act.ap_ref[i].k_elementp = -2
            p = act.ap_ref[i].names[ "element" ]
            act.ap_ref[i].k_elementp = act.index[ str(act.ap_ref[i].k_parentp) + "_Element_" + p]
        except:
            err = True
            print( str(act.ap_ref[i].k_parentp) + "_Element_" + p + " not found " + act.ap_ref[i].line_no)
        try:
            act.ap_ref[i].k_compp = -2
            p = act.ap_ref[i].names[ "comp" ]
            act.ap_ref[i].k_compp = act.index["Comp_" + p]
        except:
            print("Comp_" + p + " not found " + act.ap_ref[i].line_no)
            err = True

    for i in range( len(act.ap_ref2) ):
        p = ""
        try:
            act.ap_ref2[i].k_elementp = -2
            p = act.ap_ref2[i].names[ "element" ]
            act.ap_ref2[i].k_elementp = act.index[ str(act.ap_ref2[i].k_parentp) + "_Element_" + p]
        except:
            err = True
            print( str(act.ap_ref2[i].k_parentp) + "_Element_" + p + " not found " + act.ap_ref2[i].line_no)
        try:
            act.ap_ref2[i].k_compp = -2
            p = act.ap_ref2[i].names[ "comp" ]
            act.ap_ref2[i].k_compp = act.index["Comp_" + p]
        except:
            print("Comp_" + p + " not found " + act.ap_ref2[i].line_no)
            err = True
        try:
            act.ap_ref2[i].k_element2p = -2
            p = act.ap_ref2[i].names[ "element2" ]
            act.ap_ref2[i].k_element2p = act.index[ str(act.ap_ref2[i].k_parentp) + "_Element_" + p]
        except:
            err = True
            print( str(act.ap_ref2[i].k_parentp) + "_Element_" + p + " not found " + act.ap_ref2[i].line_no)

    for i in range( len(act.ap_refu) ):
        p = ""
        try:
            act.ap_refu[i].k_elementp = -2
            p = act.ap_refu[i].names[ "element" ]
            act.ap_refu[i].k_elementp = act.index[ str(act.ap_refu[i].k_parentp) + "_Element_" + p]
        except:
            err = True
            print( str(act.ap_refu[i].k_parentp) + "_Element_" + p + " not found " + act.ap_refu[i].line_no)
        try:
            act.ap_refu[i].k_compp = -2
            p = act.ap_refu[i].names[ "comp" ]
            act.ap_refu[i].k_compp = act.index["Comp_" + p]
        except:
            print("Comp_" + p + " not found " + act.ap_refu[i].line_no)
            err = True
        try:
            act.ap_refu[i].k_comp_refp = -2
            p = act.ap_refu[i].names[ "comp_ref" ]
            act.ap_refu[i].k_comp_refp = act.index["Comp_" + p]
        except:
            print("Comp_" + p + " not found " + act.ap_refu[i].line_no)
            err = True

    for i in range( len(act.ap_all) ):
        try:
            act.ap_all[i].k_actorp = -2
            p = act.ap_all[i].k_actor
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            print("Actor_" + p + " not found " + act.ap_all[i].line_no)
            err = True

    for i in range( len(act.ap_du) ):
        try:
            act.ap_du[i].k_actorp = -2
            p = act.ap_du[i].k_actor
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            print("Actor_" + p + " not found " + act.ap_du[i].line_no)
            err = True

    for i in range( len(act.ap_its) ):
        try:
            act.ap_its[i].k_actorp = -2
            p = act.ap_its[i].k_actor
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            print("Actor_" + p + " not found " + act.ap_its[i].line_no)
            err = True

    for i in range( len(act.ap_this) ):
        try:
            act.ap_this[i].k_actorp = -2
            p = act.ap_this[i].k_actor
            act.ap_this[i].k_actorp = act.index["Actor_" + p]
        except:
            print("Actor_" + p + " not found " + act.ap_this[i].line_no)
            err = True

    for i in range( len(act.ap_that) ):
        try:
            act.ap_that[i].k_actorp = -2
            p = act.ap_that[i].k_actor
            act.ap_that[i].k_actorp = act.index["Actor_" + p]
        except:
            print("Actor_" + p + " not found " + act.ap_that[i].line_no)
            err = True

    return(err)

def ref_other(act, check: bool) -> (bool, int):
    err = False
    cnt = 0
    return(err,cnt)

