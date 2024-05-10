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
        if tok == "Node":
            kp = structs.KpNode(ff, ln, act, lno)
            act.ap_node.append(kp)
            act.kp_all.append(kp)
        if tok == "Link":
            kp = structs.KpLink(ff, ln, act, lno)
            act.ap_link.append(kp)
            act.kp_all.append(kp)
        if tok == "Graph":
            kp = structs.KpGraph(ff, ln, act, lno)
            act.ap_graph.append(kp)
            act.kp_all.append(kp)
        if tok == "Matrix":
            kp = structs.KpMatrix(ff, ln, act, lno)
            act.ap_matrix.append(kp)
            act.kp_all.append(kp)
        if tok == "Table":
            kp = structs.KpTable(ff, ln, act, lno)
            act.ap_table.append(kp)
            act.kp_all.append(kp)
        if tok == "Field":
            kp = structs.KpField(ff, ln, act, lno)
            act.ap_field.append(kp)
            act.kp_all.append(kp)
        if tok == "Attrs":
            kp = structs.KpAttrs(ff, ln, act, lno)
            act.ap_attrs.append(kp)
            act.kp_all.append(kp)
        if tok == "Of":
            kp = structs.KpOf(ff, ln, act, lno)
            act.ap_of.append(kp)
            act.kp_all.append(kp)
        if tok == "Join":
            kp = structs.KpJoin(ff, ln, act, lno)
            act.ap_join.append(kp)
            act.kp_all.append(kp)
        if tok == "Join2":
            kp = structs.KpJoin2(ff, ln, act, lno)
            act.ap_join2.append(kp)
            act.kp_all.append(kp)
        if tok == "Type":
            kp = structs.KpType(ff, ln, act, lno)
            act.ap_type.append(kp)
            act.kp_all.append(kp)
        if tok == "Data":
            kp = structs.KpData(ff, ln, act, lno)
            act.ap_data.append(kp)
            act.kp_all.append(kp)
        if tok == "Attr":
            kp = structs.KpAttr(ff, ln, act, lno)
            act.ap_attr.append(kp)
            act.kp_all.append(kp)
        if tok == "Where":
            kp = structs.KpWhere(ff, ln, act, lno)
            act.ap_where.append(kp)
            act.kp_all.append(kp)
        if tok == "Logic":
            kp = structs.KpLogic(ff, ln, act, lno)
            act.ap_logic.append(kp)
            act.kp_all.append(kp)
        if tok == "Domain":
            kp = structs.KpDomain(ff, ln, act, lno)
            act.ap_domain.append(kp)
            act.kp_all.append(kp)
        if tok == "Model":
            kp = structs.KpModel(ff, ln, act, lno)
            act.ap_model.append(kp)
            act.kp_all.append(kp)
        if tok == "Frame":
            kp = structs.KpFrame(ff, ln, act, lno)
            act.ap_frame.append(kp)
            act.kp_all.append(kp)
        if tok == "A":
            kp = structs.KpA(ff, ln, act, lno)
            act.ap_a.append(kp)
            act.kp_all.append(kp)
        if tok == "Use":
            kp = structs.KpUse(ff, ln, act, lno)
            act.ap_use.append(kp)
            act.kp_all.append(kp)
        if tok == "Grid":
            kp = structs.KpGrid(ff, ln, act, lno)
            act.ap_grid.append(kp)
            act.kp_all.append(kp)
        if tok == "Col":
            kp = structs.KpCol(ff, ln, act, lno)
            act.ap_col.append(kp)
            act.kp_all.append(kp)
        if tok == "R":
            kp = structs.KpR(ff, ln, act, lno)
            act.ap_r.append(kp)
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
        if tok == "This":
            kp = structs.KpThis(ff, ln, act, lno)
            act.ap_this.append(kp)
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
        if tok == "Add":
            kp = structs.KpAdd(ff, ln, act, lno)
            act.ap_add.append(kp)
            act.kp_all.append(kp)
        if tok == "Clear":
            kp = structs.KpClear(ff, ln, act, lno)
            act.ap_clear.append(kp)
            act.kp_all.append(kp)
        if tok == "Check":
            kp = structs.KpCheck(ff, ln, act, lno)
            act.ap_check.append(kp)
            act.kp_all.append(kp)

def ref(act) -> bool:
    err = False
    for i in range( len(act.ap_node) ):
        p = ""
        try:
            act.ap_node[i].k_parentp = -2
            p = act.ap_node[i].names[ "parent" ]
            act.ap_node[i].k_parentp = act.index["Node_" + p]
        except:
            if p != ".":
                print("Node_" + p + " not found " + act.ap_node[i].line_no)
                err = True

    for i in range( len(act.ap_link) ):
        p = ""
        try:
            act.ap_link[i].k_top = -2
            p = act.ap_link[i].names[ "to" ]
            act.ap_link[i].k_top = act.index["Node_" + p]
        except:
            print("Node_" + p + " not found " + act.ap_link[i].line_no)
            err = True

    for i in range( len(act.ap_field) ):
        p = ""
        try:
            act.ap_field[i].k_typep = -2
            p = act.ap_field[i].names[ "type" ]
            act.ap_field[i].k_typep = act.index["Type_" + p]
        except:
            if p != ".":
                print("Type_" + p + " not found " + act.ap_field[i].line_no)
                err = True

    for i in range( len(act.ap_of) ):
        p = ""
        try:
            act.ap_of[i].k_fieldp = -2
            p = act.ap_of[i].names[ "field" ]
            act.ap_of[i].k_fieldp = act.index[ str(act.ap_of[i].k_parentp) + "_Field_" + p]
        except:
            err = True
            print( str(act.ap_of[i].k_parentp) + "_Field_" + p + " not found " + act.ap_of[i].line_no)

    for i in range( len(act.ap_join) ):
        p = ""
        try:
            act.ap_join[i].k_field1p = -2
            p = act.ap_join[i].names[ "field1" ]
            act.ap_join[i].k_field1p = act.index[ str(act.ap_join[i].k_parentp) + "_Field_" + p]
        except:
            err = True
            print( str(act.ap_join[i].k_parentp) + "_Field_" + p + " not found " + act.ap_join[i].line_no)
        try:
            act.ap_join[i].k_table2p = -2
            p = act.ap_join[i].names[ "table2" ]
            act.ap_join[i].k_table2p = act.index["Table_" + p]
        except:
            print("Table_" + p + " not found " + act.ap_join[i].line_no)
            err = True

    for i in range( len(act.ap_join2) ):
        p = ""
        try:
            act.ap_join2[i].k_field1p = -2
            p = act.ap_join2[i].names[ "field1" ]
            act.ap_join2[i].k_field1p = act.index[ str(act.ap_join2[i].k_parentp) + "_Field_" + p]
        except:
            err = True
            print( str(act.ap_join2[i].k_parentp) + "_Field_" + p + " not found " + act.ap_join2[i].line_no)
        try:
            act.ap_join2[i].k_table2p = -2
            p = act.ap_join2[i].names[ "table2" ]
            act.ap_join2[i].k_table2p = act.index["Table_" + p]
        except:
            print("Table_" + p + " not found " + act.ap_join2[i].line_no)
            err = True

    for i in range( len(act.ap_attr) ):
        p = ""
        try:
            act.ap_attr[i].k_tablep = -2
            p = act.ap_attr[i].names[ "table" ]
            act.ap_attr[i].k_tablep = act.index["Type_" + p]
        except:
            if p != ".":
                print("Type_" + p + " not found " + act.ap_attr[i].line_no)
                err = True

    for i in range( len(act.ap_where) ):
        p = ""
        try:
            act.ap_where[i].k_attrp = -2
            p = act.ap_where[i].names[ "attr" ]
            act.ap_where[i].k_attrp = act.index[ str(act.ap_where[i].k_parentp) + "_Attr_" + p]
        except:
            err = True
            print( str(act.ap_where[i].k_parentp) + "_Attr_" + p + " not found " + act.ap_where[i].line_no)
        try:
            act.ap_where[i].k_idp = -2
            p = act.ap_where[i].names[ "id" ]
            act.ap_where[i].k_idp = act.index[ str(act.ap_where[i].k_parentp) + "_Attr_" + p]
        except:
            err = True
            print( str(act.ap_where[i].k_parentp) + "_Attr_" + p + " not found " + act.ap_where[i].line_no)

    for i in range( len(act.ap_logic) ):
        p = ""
        try:
            act.ap_logic[i].k_attrp = -2
            p = act.ap_logic[i].names[ "attr" ]
            act.ap_logic[i].k_attrp = act.index[ str(act.ap_logic[i].k_parentp) + "_Attr_" + p]
        except:
            if "." != p:
                err = True
                print( str(act.ap_logic[i].k_parentp) + "_Attr_" + p + " not found " + act.ap_logic[i].line_no)

    for i in range( len(act.ap_frame) ):
        p = ""
        try:
            act.ap_frame[i].k_domainp = -2
            p = act.ap_frame[i].names[ "domain" ]
            act.ap_frame[i].k_domainp = act.index["Domain_" + p]
        except:
            if p != ".":
                print("Domain_" + p + " not found " + act.ap_frame[i].line_no)
                err = True

    for i in range( len(act.ap_col) ):
        p = ""
        try:
            act.ap_col[i].k_namep = -2
            p = act.ap_col[i].names[ "name" ]
            act.ap_col[i].k_namep = act.index["Grid_" + p]
        except:
            pass

    for i in range( len(act.ap_r) ):
        p = ""
        try:
            act.ap_r[i].k_namep = -2
            p = act.ap_r[i].names[ "name" ]
            act.ap_r[i].k_namep = act.index["Grid_" + p]
        except:
            pass

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

    return(err)

def ref_other(act, check: bool) -> (bool, int):
    err = False
    cnt = 0
    for i in range( len(act.ap_of) ):
        t = -2
        p = ""
        try:
            t = act.ap_of[i].k_fieldp
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "field not resolved " + act.ap_of[i].line_no)
            else:
                act.ap_of[i].k_typep = -2
            act.ap_of[i].k_typep = act.ap_field[t].k_typep
        except:
            pass
        try:
            t = act.ap_of[i].k_typep
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "type not resolved " + act.ap_of[i].line_no)
            else:
                act.ap_of[i].k_attrp = -2
            p = act.ap_of[i].names[ "attr" ]
            act.ap_of[i].k_attrp = act.index[ str(t) + "_Attr_" + p]
        except:
            if p != "E_O_L":
                if check:
                    err = True
                    print( str(t) + "_Attr_" + p + " not found " + act.ap_of[i].line_no)
        try:
            t = act.ap_of[i].k_typep
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "type not resolved " + act.ap_of[i].line_no)
            else:
                act.ap_of[i].k_fromp = -2
            p = act.ap_of[i].names[ "from" ]
            act.ap_of[i].k_fromp = act.index[ str(t) + "_Attr_" + p]
        except:
            if p != "E_O_L":
                if check:
                    err = True
                    print( str(t) + "_Attr_" + p + " not found " + act.ap_of[i].line_no)

    for i in range( len(act.ap_join) ):
        t = -2
        p = ""
        try:
            t = act.ap_join[i].k_table2p
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "table2 not resolved " + act.ap_join[i].line_no)
            else:
                act.ap_join[i].k_field2p = -2
            p = act.ap_join[i].names[ "field2" ]
            act.ap_join[i].k_field2p = act.index[ str(t) + "_Field_" + p]
        except:
            if check:
                err = True
                print( str(t) + "_Field_" + p + " not found " + act.ap_join[i].line_no)

    for i in range( len(act.ap_join2) ):
        t = -2
        p = ""
        try:
            t = act.ap_join2[i].k_table2p
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "table2 not resolved " + act.ap_join2[i].line_no)
            else:
                act.ap_join2[i].k_field2p = -2
            p = act.ap_join2[i].names[ "field2" ]
            act.ap_join2[i].k_field2p = act.index[ str(t) + "_Field_" + p]
        except:
            if check:
                err = True
                print( str(t) + "_Field_" + p + " not found " + act.ap_join2[i].line_no)
        try:
            t = act.ap_join2[i].k_field2p
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "field2 not resolved " + act.ap_join2[i].line_no)
            else:
                act.ap_join2[i].k_attr2p = -2
            p = act.ap_join2[i].names[ "attr2" ]
            act.ap_join2[i].k_attr2p = act.index[ str(t) + "_Attrs_" + p]
        except:
            if check:
                err = True
                print( str(t) + "_Attrs_" + p + " not found " + act.ap_join2[i].line_no)

    for i in range( len(act.ap_where) ):
        t = -2
        p = ""
        try:
            t = act.ap_where[i].k_attrp
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "attr not resolved " + act.ap_where[i].line_no)
            else:
                act.ap_where[i].k_tablep = -2
            act.ap_where[i].k_tablep = act.ap_attr[t].k_tablep
        except:
            pass
        try:
            t = act.ap_where[i].k_tablep
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "table not resolved " + act.ap_where[i].line_no)
            else:
                act.ap_where[i].k_from_idp = -2
            p = act.ap_where[i].names[ "from_id" ]
            act.ap_where[i].k_from_idp = act.index[ str(t) + "_Attr_" + p]
        except:
            if p != "E_O_L":
                if check:
                    err = True
                    print( str(t) + "_Attr_" + p + " not found " + act.ap_where[i].line_no)

    for i in range( len(act.ap_a) ):
        t = -2
        p = ""
        try:
            t = act.ap_a[i].k_parentp
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "parent not resolved " + act.ap_a[i].line_no)
            else:
                act.ap_a[i].k_domainp = -2
            act.ap_a[i].k_domainp = act.ap_frame[t].k_domainp
        except:
            pass
        try:
            t = act.ap_a[i].k_domainp
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "domain not resolved " + act.ap_a[i].line_no)
            else:
                act.ap_a[i].k_modelp = -2
            p = act.ap_a[i].names[ "model" ]
            act.ap_a[i].k_modelp = act.index[ str(t) + "_Model_" + p]
        except:
            pass

    for i in range( len(act.ap_use) ):
        t = -2
        p = ""
        try:
            t = act.ap_use[i].k_parentp
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "parent not resolved " + act.ap_use[i].line_no)
            else:
                act.ap_use[i].k_modelp = -2
            act.ap_use[i].k_modelp = act.ap_a[t].k_modelp
        except:
            pass
        try:
            t = act.ap_use[i].k_modelp
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "model not resolved " + act.ap_use[i].line_no)
            else:
                act.ap_use[i].k_framep = -2
            p = act.ap_use[i].names[ "frame" ]
            act.ap_use[i].k_framep = act.index[ str(t) + "_Frame_" + p]
        except:
            if p != ".":
                if check:
                    err = True
                    print( str(t) + "_Frame_" + p + " not found " + act.ap_use[i].line_no)
        try:
            t = act.ap_use[i].k_framep
            if t == -1:
                cnt = cnt + 1
                if check:
                    err = True
                    print( "frame not resolved " + act.ap_use[i].line_no)
            else:
                act.ap_use[i].k_ap = -2
            p = act.ap_use[i].names[ "a" ]
            act.ap_use[i].k_ap = act.index[ str(t) + "_A_" + p]
        except:
            if p != ".":
                if check:
                    err = True
                    print( str(t) + "_A_" + p + " not found " + act.ap_use[i].line_no)

    return(err,cnt)

