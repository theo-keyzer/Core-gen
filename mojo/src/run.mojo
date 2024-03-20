import structs

from inputs import Input

fn load(inout act: structs.ActT, inout ff: Input, tok: String, ln: Int):
        if tok == "Comp":
            var kp = structs.KpComp(ff, ln, act)
            act.ap_comp.push_back(kp)
        if tok == "Token":
            var kp = structs.KpToken(ff, ln, act)
            act.ap_token.push_back(kp)
        if tok == "Star":
            var kp = structs.KpStar(ff, ln, act)
            act.ap_star.push_back(kp)
        if tok == "Element":
            var kp = structs.KpElement(ff, ln, act)
            act.ap_element.push_back(kp)
        if tok == "Opt":
            var kp = structs.KpOpt(ff, ln, act)
            act.ap_opt.push_back(kp)
        if tok == "Ref":
            var kp = structs.KpRef(ff, ln, act)
            act.ap_ref.push_back(kp)
        if tok == "Ref2":
            var kp = structs.KpRef2(ff, ln, act)
            act.ap_ref2.push_back(kp)
        if tok == "Ref3":
            var kp = structs.KpRef3(ff, ln, act)
            act.ap_ref3.push_back(kp)
        if tok == "Refq":
            var kp = structs.KpRefq(ff, ln, act)
            act.ap_refq.push_back(kp)

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

    for i in range( len(act.ap_ref2) ):
        try:
            var p = act.names["Ref2_" + String(i) + "_comp" ]
            act.ap_ref2[i].k_compp = act.index["Comp_" + p]
        except:
            print("except")

    for i in range( len(act.ap_ref3) ):
        try:
            var p = act.names["Ref3_" + String(i) + "_comp" ]
            act.ap_ref3[i].k_compp = act.index["Comp_" + p]
        except:
            print("except")
        try:
            var p = act.names["Ref3_" + String(i) + "_comp_ref" ]
            act.ap_ref3[i].k_comp_refp = act.index["Comp_" + p]
        except:
            print("except")

    for i in range( len(act.ap_refq) ):
        try:
            var p = act.names["Refq_" + String(i) + "_comp" ]
            act.ap_refq[i].k_compp = act.index["Comp_" + p]
        except:
            print("except")
        try:
            var p = act.names["Refq_" + String(i) + "_comp_ref" ]
            act.ap_refq[i].k_comp_refp = act.index["Comp_" + p]
        except:
            print("except")

