part of gen;

class ActT 
{
	Map index = new Map();
	List<KpType> ap_type = [];
	List<KpData> ap_data = [];
	List<KpAttr> ap_attr = [];
	List<KpWhere> ap_where = [];
	List<KpLogic> ap_logic = [];
	List<KpNode> ap_node = [];
	List<KpLink> ap_link = [];
	List<KpGraph> ap_graph = [];
	List<KpMatrix> ap_matrix = [];
	List<KpTable> ap_table = [];
	List<KpField> ap_field = [];
	List<KpAttrs> ap_attrs = [];
	List<KpOf> ap_of = [];
	List<KpJoin1> ap_join1 = [];
	List<KpJoin2> ap_join2 = [];
	List<KpDomain> ap_domain = [];
	List<KpModel> ap_model = [];
	List<KpFrame> ap_frame = [];
	List<KpA> ap_a = [];
	List<KpUse> ap_use = [];
	List<KpCol> ap_col = [];
	List<KpGrid> ap_grid = [];
	List<KpConcept> ap_concept = [];
	List<KpTopic> ap_topic = [];
	List<KpT> ap_t = [];
	List<KpActor> ap_actor = [];
	List<KpAll> ap_all = [];
	List<KpDu> ap_du = [];
	List<KpNew> ap_new = [];
	List<KpRefs> ap_refs = [];
	List<KpVar> ap_var = [];
	List<KpIts> ap_its = [];
	List<KpC> ap_c = [];
	List<KpCs> ap_cs = [];
	List<KpOut> ap_out = [];
	List<KpIn> ap_in = [];
	List<KpBreak> ap_break = [];
	List<KpAdd> ap_add = [];
	List<KpThis> ap_this = [];
	List<KpReplace> ap_replace = [];
	List<KpComp> ap_comp = [];
	List<KpElement> ap_element = [];
	List<KpOpt> ap_opt = [];
	List<KpRef> ap_ref = [];
	List<KpRef2> ap_ref2 = [];
	List<KpRef3> ap_ref3 = [];
	List<KpRefq> ap_refq = [];
	List<KpRefu> ap_refu = [];
	List<KpJoin> ap_join = [];
}

bool refs(act)
{
	var errs = false;
	var res = fnd(act, '', '', '', '');
	for(var st in act.ap_attr) {
		res = fnd(act, "Type_" + get_name(st.names, "table") , get_name(st.names, "table"),  ".", st.line_no );
		st.k_tablep = res[1];
		st.names["k_tablep"] = st.k_tablep.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_where) {
		res = fnd(act, st.k_parentp.toString() + "_Attr_" + get_name(st.names, "attr") , get_name(st.names, "attr"),  "check", st.line_no );
		st.k_attrp = res[1];
		st.names["k_attrp"] = st.k_attrp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, st.k_parentp.toString() + "_Attr_" + get_name(st.names, "id") , get_name(st.names, "id"),  "check", st.line_no );
		st.k_idp = res[1];
		st.names["k_idp"] = st.k_idp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_logic) {
		res = fnd(act, st.k_parentp.toString() + "_Attr_" + get_name(st.names, "attr") , get_name(st.names, "attr"),  ".", st.line_no );
		st.k_attrp = res[1];
		st.names["k_attrp"] = st.k_attrp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_node) {
		res = fnd(act, "Node_" + get_name(st.names, "parent") , get_name(st.names, "parent"),  ".", st.line_no );
		st.k_parentp = res[1];
		st.names["k_parentp"] = st.k_parentp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_link) {
		res = fnd(act, "Node_" + get_name(st.names, "to") , get_name(st.names, "to"),  "check", st.line_no );
		st.k_top = res[1];
		st.names["k_top"] = st.k_top.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_field) {
		res = fnd(act, "Type_" + get_name(st.names, "type") , get_name(st.names, "type"),  ".", st.line_no );
		st.k_typep = res[1];
		st.names["k_typep"] = st.k_typep.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_of) {
		res = fnd(act, st.k_parentp.toString() + "_Field_" + get_name(st.names, "field") , get_name(st.names, "field"),  "check", st.line_no );
		st.k_fieldp = res[1];
		st.names["k_fieldp"] = st.k_fieldp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_join1) {
		res = fnd(act, st.k_parentp.toString() + "_Field_" + get_name(st.names, "field1") , get_name(st.names, "field1"),  "check", st.line_no );
		st.k_field1p = res[1];
		st.names["k_field1p"] = st.k_field1p.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Table_" + get_name(st.names, "table2") , get_name(st.names, "table2"),  "check", st.line_no );
		st.k_table2p = res[1];
		st.names["k_table2p"] = st.k_table2p.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_join2) {
		res = fnd(act, st.k_parentp.toString() + "_Field_" + get_name(st.names, "field1") , get_name(st.names, "field1"),  "check", st.line_no );
		st.k_field1p = res[1];
		st.names["k_field1p"] = st.k_field1p.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Table_" + get_name(st.names, "table2") , get_name(st.names, "table2"),  "check", st.line_no );
		st.k_table2p = res[1];
		st.names["k_table2p"] = st.k_table2p.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_frame) {
		res = fnd(act, "Domain_" + get_name(st.names, "domain") , get_name(st.names, "domain"),  ".", st.line_no );
		st.k_domainp = res[1];
		st.names["k_domainp"] = st.k_domainp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_col) {
		res = fnd(act, "Grid_" + get_name(st.names, "name") , get_name(st.names, "name"),  "?", st.line_no );
		st.k_namep = res[1];
		st.names["k_namep"] = st.k_namep.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_grid) {
		res = fnd(act, "Grid_" + get_name(st.names, "name") , get_name(st.names, "name"),  "?", st.line_no );
		st.k_namep = res[1];
		st.names["k_namep"] = st.k_namep.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_all) {
		res = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no );
		st.k_actorp = res[1];
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_du) {
		res = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no );
		st.k_actorp = res[1];
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_its) {
		res = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no );
		st.k_actorp = res[1];
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_this) {
		res = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no );
		st.k_actorp = res[1];
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_comp) {
		res = fnd(act, "Comp_" + get_name(st.names, "parent") , get_name(st.names, "parent"),  ".", st.line_no );
		st.k_parentp = res[1];
		st.names["k_parentp"] = st.k_parentp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_ref) {
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
		st.k_elementp = res[1];
		st.names["k_elementp"] = st.k_elementp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp") , get_name(st.names, "comp"),  "check", st.line_no );
		st.k_compp = res[1];
		st.names["k_compp"] = st.k_compp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_ref2) {
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
		st.k_elementp = res[1];
		st.names["k_elementp"] = st.k_elementp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp") , get_name(st.names, "comp"),  "check", st.line_no );
		st.k_compp = res[1];
		st.names["k_compp"] = st.k_compp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element2") , get_name(st.names, "element2"),  "check", st.line_no );
		st.k_element2p = res[1];
		st.names["k_element2p"] = st.k_element2p.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_ref3) {
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
		st.k_elementp = res[1];
		st.names["k_elementp"] = st.k_elementp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp") , get_name(st.names, "comp"),  "check", st.line_no );
		st.k_compp = res[1];
		st.names["k_compp"] = st.k_compp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element2") , get_name(st.names, "element2"),  "check", st.line_no );
		st.k_element2p = res[1];
		st.names["k_element2p"] = st.k_element2p.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp_ref") , get_name(st.names, "comp_ref"),  "check", st.line_no );
		st.k_comp_refp = res[1];
		st.names["k_comp_refp"] = st.k_comp_refp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_refq) {
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
		st.k_elementp = res[1];
		st.names["k_elementp"] = st.k_elementp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp") , get_name(st.names, "comp"),  "check", st.line_no );
		st.k_compp = res[1];
		st.names["k_compp"] = st.k_compp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp_ref") , get_name(st.names, "comp_ref"),  "check", st.line_no );
		st.k_comp_refp = res[1];
		st.names["k_comp_refp"] = st.k_comp_refp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_refu) {
		res = fnd(act, st.k_parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
		st.k_elementp = res[1];
		st.names["k_elementp"] = st.k_elementp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp") , get_name(st.names, "comp"),  "check", st.line_no );
		st.k_compp = res[1];
		st.names["k_compp"] = st.k_compp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, "Comp_" + get_name(st.names, "comp_ref") , get_name(st.names, "comp_ref"),  "check", st.line_no );
		st.k_comp_refp = res[1];
		st.names["k_comp_refp"] = st.k_comp_refp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_where) {
		var t = st.k_attrp;
		if(t >= 0) {
			st.k_tablep = act.ap_attr[t].k_tablep;
		} else if ( "E_O_L".compareTo( "?" ) != 0 ) {
			print( "ref error attr not resolved " + st.line_no);
			errs = true;
		}
		st.names["k_tablep"] = st.k_tablep.toString();
		res = fnd(act, st.k_tablep.toString() + "_Attr_" + get_name(st.names, "from_id") , get_name(st.names, "from_id"),  "E_O_L", st.line_no );
		st.k_from_idp = res[1];
		st.names["k_from_idp"] = st.k_from_idp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_of) {
		var t = st.k_fieldp;
		if(t >= 0) {
			st.k_typep = act.ap_field[t].k_typep;
		} else if ( "E_O_L".compareTo( "?" ) != 0 ) {
			print( "ref error field not resolved " + st.line_no);
			errs = true;
		}
		st.names["k_typep"] = st.k_typep.toString();
		res = fnd(act, st.k_typep.toString() + "_Attr_" + get_name(st.names, "attr") , get_name(st.names, "attr"),  "E_O_L", st.line_no );
		st.k_attrp = res[1];
		st.names["k_attrp"] = st.k_attrp.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, st.k_typep.toString() + "_Attr_" + get_name(st.names, "from") , get_name(st.names, "from"),  "E_O_L", st.line_no );
		st.k_fromp = res[1];
		st.names["k_fromp"] = st.k_fromp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_join1) {
		res = fnd(act, st.k_table2p.toString() + "_Field_" + get_name(st.names, "field2") , get_name(st.names, "field2"),  "check", st.line_no );
		st.k_field2p = res[1];
		st.names["k_field2p"] = st.k_field2p.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_join2) {
		res = fnd(act, st.k_table2p.toString() + "_Field_" + get_name(st.names, "field2") , get_name(st.names, "field2"),  "check", st.line_no );
		st.k_field2p = res[1];
		st.names["k_field2p"] = st.k_field2p.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, st.k_field2p.toString() + "_Attrs_" + get_name(st.names, "attr2") , get_name(st.names, "attr2"),  "check", st.line_no );
		st.k_attr2p = res[1];
		st.names["k_attr2p"] = st.k_attr2p.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_a) {
		var t = st.k_parentp;
		if(t >= 0) {
			st.k_domainp = act.ap_frame[t].k_domainp;
		} else if ( ".".compareTo( "?" ) != 0 ) {
			print( "ref error parent not resolved " + st.line_no);
			errs = true;
		}
		st.names["k_domainp"] = st.k_domainp.toString();
		res = fnd(act, st.k_domainp.toString() + "_Model_" + get_name(st.names, "model") , get_name(st.names, "model"),  "?", st.line_no );
		st.k_modelp = res[1];
		st.names["k_modelp"] = st.k_modelp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_use) {
		var t = st.k_parentp;
		if(t >= 0) {
			st.k_modelp = act.ap_a[t].k_modelp;
		} else if ( ".".compareTo( "?" ) != 0 ) {
			print( "ref error parent not resolved " + st.line_no);
			errs = true;
		}
		st.names["k_modelp"] = st.k_modelp.toString();
		res = fnd(act, st.k_modelp.toString() + "_Frame_" + get_name(st.names, "frame") , get_name(st.names, "frame"),  ".", st.line_no );
		st.k_framep = res[1];
		st.names["k_framep"] = st.k_framep.toString();
		if (res[0] == false) {
			errs = true;
		}
		res = fnd(act, st.k_framep.toString() + "_A_" + get_name(st.names, "a") , get_name(st.names, "a"),  ".", st.line_no );
		st.k_ap = res[1];
		st.names["k_ap"] = st.k_ap.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	return(errs);
}

List var_all(glob, va, lno) 
{
	if (va.length < 3) {
		return( [false, "?" + va.length.toString() + "<3?" + lno + "?"] );
	}
	if (va[0].compareTo("Type") == 0) {
		var en = glob.dats.index["Type_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_type[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Node") == 0) {
		var en = glob.dats.index["Node_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_node[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Graph") == 0) {
		var en = glob.dats.index["Graph_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_graph[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Matrix") == 0) {
		var en = glob.dats.index["Matrix_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_matrix[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Table") == 0) {
		var en = glob.dats.index["Table_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_table[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Domain") == 0) {
		var en = glob.dats.index["Domain_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_domain[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Grid") == 0) {
		var en = glob.dats.index["Grid_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_grid[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Actor") == 0) {
		var en = glob.dats.index["Actor_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_actor[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	if (va[0].compareTo("Comp") == 0) {
		var en = glob.dats.index["Comp_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_comp[en].get_var(glob, va.sublist(2), lno));
		}
		return( [false, "?" + va[0] + "=" + va[1] + "?" + lno + "?"] );
	}
	return( [false, "?" + va[0] + "?" + lno + "?"] );
}

int do_all(glob, va, lno)
{
	if (va[0].compareTo("Type") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Type_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_type[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_type[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_type) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Data") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Data_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_data[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_data[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_data) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Attr") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Attr_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_attr[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_attr[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_attr) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Where") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Where_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_where[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_where[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_where) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Logic") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Logic_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_logic[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_logic[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_logic) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Node") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Node_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_node[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_node[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_node) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Link") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Link_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_link[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_link[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_link) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Graph") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Graph_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_graph[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_graph[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_graph) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Matrix") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Matrix_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_matrix[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_matrix[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_matrix) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Table") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Table_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_table[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_table[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_table) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Field") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Field_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_field[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_field[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_field) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Attrs") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Attrs_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_attrs[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_attrs[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_attrs) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Of") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Of_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_of[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_of[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_of) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Join1") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Join1_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_join1[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_join1[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_join1) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Join2") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Join2_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_join2[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_join2[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_join2) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Domain") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Domain_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_domain[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_domain[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_domain) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Model") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Model_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_model[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_model[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_model) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Frame") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Frame_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_frame[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_frame[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_frame) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("A") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["A_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_a[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_a[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_a) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Use") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Use_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_use[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_use[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_use) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Col") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Col_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_col[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_col[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_col) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Grid") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Grid_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_grid[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_grid[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_grid) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Concept") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Concept_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_concept[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_concept[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_concept) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Topic") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Topic_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_topic[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_topic[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_topic) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("T") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["T_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_t[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_t[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_t) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Actor") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Actor_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_actor[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_actor[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_actor) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Comp") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Comp_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_comp[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_comp[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_comp) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Element") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Element_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_element[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_element[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_element) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Opt") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Opt_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_opt[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_opt[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_opt) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Ref") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Ref_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_ref[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_ref[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_ref) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Ref2") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Ref2_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_ref2[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_ref2[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_ref2) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Ref3") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Ref3_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_ref3[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_ref3[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_ref3) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Refq") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Refq_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_refq[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_refq[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_refq) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Refu") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Refu_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_refu[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_refu[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_refu) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	if (va[0].compareTo("Join") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Join_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_join[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_join[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_join) {
			if (va.length > 2) {
				var ret = st.do_its(glob, va.sublist(2), lno);
				if (ret != 0) {
					return(ret);
				}
				continue;
			}
			var ret = go_act(glob, st);
			if (ret != 0) {
				return(ret);
			}
		}
		return(0);
	}
	print("?No all " + va[0] + " cmd " + "," + lno + "?");
	return 0;
}

bool load(act, toks, ln, pos, lno)
{
	bool errs = false;
	var ss = toks.split(".");
	var tok = ss[0];
	var flag = ss.sublist(1);
	if ( tok.compareTo( "Type" ) == 0 ) {
		var comp = new KpType();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_type.add( comp );
	}
	if ( tok.compareTo( "Data" ) == 0 ) {
		var comp = new KpData();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_data.add( comp );
	}
	if ( tok.compareTo( "Attr" ) == 0 ) {
		var comp = new KpAttr();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_attr.add( comp );
	}
	if ( tok.compareTo( "Where" ) == 0 ) {
		var comp = new KpWhere();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_where.add( comp );
	}
	if ( tok.compareTo( "Logic" ) == 0 ) {
		var comp = new KpLogic();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_logic.add( comp );
	}
	if ( tok.compareTo( "Node" ) == 0 ) {
		var comp = new KpNode();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_node.add( comp );
	}
	if ( tok.compareTo( "Link" ) == 0 ) {
		var comp = new KpLink();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_link.add( comp );
	}
	if ( tok.compareTo( "Graph" ) == 0 ) {
		var comp = new KpGraph();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_graph.add( comp );
	}
	if ( tok.compareTo( "Matrix" ) == 0 ) {
		var comp = new KpMatrix();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_matrix.add( comp );
	}
	if ( tok.compareTo( "Table" ) == 0 ) {
		var comp = new KpTable();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_table.add( comp );
	}
	if ( tok.compareTo( "Field" ) == 0 ) {
		var comp = new KpField();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_field.add( comp );
	}
	if ( tok.compareTo( "Attrs" ) == 0 ) {
		var comp = new KpAttrs();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_attrs.add( comp );
	}
	if ( tok.compareTo( "Of" ) == 0 ) {
		var comp = new KpOf();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_of.add( comp );
	}
	if ( tok.compareTo( "Join1" ) == 0 ) {
		var comp = new KpJoin1();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_join1.add( comp );
	}
	if ( tok.compareTo( "Join2" ) == 0 ) {
		var comp = new KpJoin2();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_join2.add( comp );
	}
	if ( tok.compareTo( "Domain" ) == 0 ) {
		var comp = new KpDomain();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_domain.add( comp );
	}
	if ( tok.compareTo( "Model" ) == 0 ) {
		var comp = new KpModel();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_model.add( comp );
	}
	if ( tok.compareTo( "Frame" ) == 0 ) {
		var comp = new KpFrame();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_frame.add( comp );
	}
	if ( tok.compareTo( "A" ) == 0 ) {
		var comp = new KpA();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_a.add( comp );
	}
	if ( tok.compareTo( "Use" ) == 0 ) {
		var comp = new KpUse();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_use.add( comp );
	}
	if ( tok.compareTo( "Col" ) == 0 ) {
		var comp = new KpCol();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_col.add( comp );
	}
	if ( tok.compareTo( "Grid" ) == 0 ) {
		var comp = new KpGrid();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_grid.add( comp );
	}
	if ( tok.compareTo( "Concept" ) == 0 ) {
		var comp = new KpConcept();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_concept.add( comp );
	}
	if ( tok.compareTo( "Topic" ) == 0 ) {
		var comp = new KpTopic();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_topic.add( comp );
	}
	if ( tok.compareTo( "T" ) == 0 ) {
		var comp = new KpT();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_t.add( comp );
	}
	if ( tok.compareTo( "Actor" ) == 0 ) {
		var comp = new KpActor();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_actor.add( comp );
	}
	if ( tok.compareTo( "All" ) == 0 ) {
		var comp = new KpAll();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_all.add( comp );
	}
	if ( tok.compareTo( "Du" ) == 0 ) {
		var comp = new KpDu();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_du.add( comp );
	}
	if ( tok.compareTo( "New" ) == 0 ) {
		var comp = new KpNew();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_new.add( comp );
	}
	if ( tok.compareTo( "Refs" ) == 0 ) {
		var comp = new KpRefs();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_refs.add( comp );
	}
	if ( tok.compareTo( "Var" ) == 0 ) {
		var comp = new KpVar();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_var.add( comp );
	}
	if ( tok.compareTo( "Its" ) == 0 ) {
		var comp = new KpIts();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_its.add( comp );
	}
	if ( tok.compareTo( "C" ) == 0 ) {
		var comp = new KpC();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_c.add( comp );
	}
	if ( tok.compareTo( "Cs" ) == 0 ) {
		var comp = new KpCs();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_cs.add( comp );
	}
	if ( tok.compareTo( "Out" ) == 0 ) {
		var comp = new KpOut();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_out.add( comp );
	}
	if ( tok.compareTo( "In" ) == 0 ) {
		var comp = new KpIn();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_in.add( comp );
	}
	if ( tok.compareTo( "Break" ) == 0 ) {
		var comp = new KpBreak();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_break.add( comp );
	}
	if ( tok.compareTo( "Add" ) == 0 ) {
		var comp = new KpAdd();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_add.add( comp );
	}
	if ( tok.compareTo( "This" ) == 0 ) {
		var comp = new KpThis();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_this.add( comp );
	}
	if ( tok.compareTo( "Replace" ) == 0 ) {
		var comp = new KpReplace();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_replace.add( comp );
	}
	if ( tok.compareTo( "Comp" ) == 0 ) {
		var comp = new KpComp();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_comp.add( comp );
	}
	if ( tok.compareTo( "Element" ) == 0 ) {
		var comp = new KpElement();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_element.add( comp );
	}
	if ( tok.compareTo( "Opt" ) == 0 ) {
		var comp = new KpOpt();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_opt.add( comp );
	}
	if ( tok.compareTo( "Ref" ) == 0 ) {
		var comp = new KpRef();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_ref.add( comp );
	}
	if ( tok.compareTo( "Ref2" ) == 0 ) {
		var comp = new KpRef2();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_ref2.add( comp );
	}
	if ( tok.compareTo( "Ref3" ) == 0 ) {
		var comp = new KpRef3();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_ref3.add( comp );
	}
	if ( tok.compareTo( "Refq" ) == 0 ) {
		var comp = new KpRefq();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_refq.add( comp );
	}
	if ( tok.compareTo( "Refu" ) == 0 ) {
		var comp = new KpRefu();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_refu.add( comp );
	}
	if ( tok.compareTo( "Join" ) == 0 ) {
		var comp = new KpJoin();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_join.add( comp );
	}
	return(errs);
}
