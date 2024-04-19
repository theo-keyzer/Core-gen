import structs

from inputs import Input

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
        if tok == "Actor":
            kp = structs.KpActor(ff, ln, act, lno)
            act.ap_actor.append(kp)
            act.kp_all.append(kp)
        if tok == "Dbcreate":
            kp = structs.KpDbcreate(ff, ln, act, lno)
            act.ap_dbcreate.append(kp)
            act.kp_all.append(kp)
        if tok == "Dbload":
            kp = structs.KpDbload(ff, ln, act, lno)
            act.ap_dbload.append(kp)
            act.kp_all.append(kp)
        if tok == "Dbselect":
            kp = structs.KpDbselect(ff, ln, act, lno)
            act.ap_dbselect.append(kp)
            act.kp_all.append(kp)
        if tok == "All":
            kp = structs.KpAll(ff, ln, act, lno)
            act.ap_all.append(kp)
            act.kp_all.append(kp)
        if tok == "Du":
            kp = structs.KpDu(ff, ln, act, lno)
            act.ap_du.append(kp)
            act.kp_all.append(kp)
        if tok == "New":
            kp = structs.KpNew(ff, ln, act, lno)
            act.ap_new.append(kp)
            act.kp_all.append(kp)
        if tok == "Refs":
            kp = structs.KpRefs(ff, ln, act, lno)
            act.ap_refs.append(kp)
            act.kp_all.append(kp)
        if tok == "Var":
            kp = structs.KpVar(ff, ln, act, lno)
            act.ap_var.append(kp)
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
        if tok == "Include":
            kp = structs.KpInclude(ff, ln, act, lno)
            act.ap_include.append(kp)
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
        if tok == "Collect":
            kp = structs.KpCollect(ff, ln, act, lno)
            act.ap_collect.append(kp)
            act.kp_all.append(kp)
        if tok == "Hash":
            kp = structs.KpHash(ff, ln, act, lno)
            act.ap_hash.append(kp)
            act.kp_all.append(kp)
        if tok == "Group":
            kp = structs.KpGroup(ff, ln, act, lno)
            act.ap_group.append(kp)
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
        if tok == "Json":
            kp = structs.KpJson(ff, ln, act, lno)
            act.ap_json.append(kp)
            act.kp_all.append(kp)
        if tok == "Yaml":
            kp = structs.KpYaml(ff, ln, act, lno)
            act.ap_yaml.append(kp)
            act.kp_all.append(kp)
        if tok == "Xml":
            kp = structs.KpXml(ff, ln, act, lno)
            act.ap_xml.append(kp)
            act.kp_all.append(kp)

def refs(act) -> bool:
    err = False
    for i in range( len(act.ap_node) ):
        try:
            p = act.ap_node[i].names[ "parent" ]
            act.ap_node[i].k_parentp = act.index["Node_" + p]
        except:
            if "." != ".":
                err = True
                print("Node_" + p + " not found " + act.ap_node[i].line_no)

    for i in range( len(act.ap_link) ):
        try:
            p = act.ap_link[i].names[ "to" ]
            act.ap_link[i].k_top = act.index["Node_" + p]
        except:
            if "check" != ".":
                err = True
                print("Node_" + p + " not found " + act.ap_link[i].line_no)

    for i in range( len(act.ap_field) ):
        try:
            p = act.ap_field[i].names[ "type" ]
            act.ap_field[i].k_typep = act.index["Type_" + p]
        except:
            if "." != ".":
                err = True
                print("Type_" + p + " not found " + act.ap_field[i].line_no)

    for i in range( len(act.ap_of) ):
        try:
            p = act.ap_of[i].names[ "field" ]
            act.ap_of[i].k_fieldp = act.index[ str(act.ap_of[i].parentp) + "_Field_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_of[i].parentp) + "_Field_" + p + " not found " + act.ap_of[i].line_no)

    for i in range( len(act.ap_join) ):
        try:
            p = act.ap_join[i].names[ "field1" ]
            act.ap_join[i].k_field1p = act.index[ str(act.ap_join[i].parentp) + "_Field_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_join[i].parentp) + "_Field_" + p + " not found " + act.ap_join[i].line_no)
        try:
            p = act.ap_join[i].names[ "table2" ]
            act.ap_join[i].k_table2p = act.index["Table_" + p]
        except:
            if "check" != ".":
                err = True
                print("Table_" + p + " not found " + act.ap_join[i].line_no)

    for i in range( len(act.ap_join2) ):
        try:
            p = act.ap_join2[i].names[ "field1" ]
            act.ap_join2[i].k_field1p = act.index[ str(act.ap_join2[i].parentp) + "_Field_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_join2[i].parentp) + "_Field_" + p + " not found " + act.ap_join2[i].line_no)
        try:
            p = act.ap_join2[i].names[ "table2" ]
            act.ap_join2[i].k_table2p = act.index["Table_" + p]
        except:
            if "check" != ".":
                err = True
                print("Table_" + p + " not found " + act.ap_join2[i].line_no)

    for i in range( len(act.ap_attr) ):
        try:
            p = act.ap_attr[i].names[ "table" ]
            act.ap_attr[i].k_tablep = act.index["Type_" + p]
        except:
            if "." != ".":
                err = True
                print("Type_" + p + " not found " + act.ap_attr[i].line_no)

    for i in range( len(act.ap_where) ):
        try:
            p = act.ap_where[i].names[ "attr" ]
            act.ap_where[i].k_attrp = act.index[ str(act.ap_where[i].parentp) + "_Attr_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_where[i].parentp) + "_Attr_" + p + " not found " + act.ap_where[i].line_no)
        try:
            p = act.ap_where[i].names[ "id" ]
            act.ap_where[i].k_idp = act.index[ str(act.ap_where[i].parentp) + "_Attr_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(act.ap_where[i].parentp) + "_Attr_" + p + " not found " + act.ap_where[i].line_no)

    for i in range( len(act.ap_logic) ):
        try:
            p = act.ap_logic[i].names[ "attr" ]
            act.ap_logic[i].k_attrp = act.index[ str(act.ap_logic[i].parentp) + "_Attr_" + p]
        except:
            if "." != ".":
                err = True
                print( str(act.ap_logic[i].parentp) + "_Attr_" + p + " not found " + act.ap_logic[i].line_no)

    for i in range( len(act.ap_dbselect) ):
        try:
            p = act.ap_dbselect[i].k_actor
            act.ap_dbselect[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_dbselect[i].line_no)

    for i in range( len(act.ap_all) ):
        try:
            p = act.ap_all[i].k_actor
            act.ap_all[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_all[i].line_no)

    for i in range( len(act.ap_du) ):
        try:
            p = act.ap_du[i].k_actor
            act.ap_du[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_du[i].line_no)

    for i in range( len(act.ap_its) ):
        try:
            p = act.ap_its[i].k_actor
            act.ap_its[i].k_actorp = act.index["Actor_" + p]
        except:
            if "check" != ".":
                err = True
                print("Actor_" + p + " not found " + act.ap_its[i].line_no)

    for i in range( len(act.ap_join) ):
        t = -2
        try:
            t = act.ap_join[i].k_table2p
            p = act.ap_join[i].names[ "field2" ]
            act.ap_join[i].k_field2p = act.index[ str(t) + "_Field_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(t) + "_Field_" + p + " not found " + act.ap_join[i].line_no)

    for i in range( len(act.ap_join2) ):
        t = -2
        try:
            t = act.ap_join2[i].k_table2p
            p = act.ap_join2[i].names[ "field2" ]
            act.ap_join2[i].k_field2p = act.index[ str(t) + "_Field_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(t) + "_Field_" + p + " not found " + act.ap_join2[i].line_no)
        try:
            t = act.ap_join2[i].k_field2p
            p = act.ap_join2[i].names[ "attr2" ]
            act.ap_join2[i].k_attr2p = act.index[ str(t) + "_Attrs_" + p]
        except:
            if "check" != ".":
                err = True
                print( str(t) + "_Attrs_" + p + " not found " + act.ap_join2[i].line_no)

    return err

