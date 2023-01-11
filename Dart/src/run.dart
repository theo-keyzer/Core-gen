part of gen;

class ActT 
{
	Map index = new Map();
	List<KpComp> ap_comp = [];
	List<KpToken> ap_token = [];
	List<KpStar> ap_star = [];
	List<KpElement> ap_element = [];
	List<KpOpt> ap_opt = [];
	List<KpRef> ap_ref = [];
	List<KpRef2> ap_ref2 = [];
	List<KpRef3> ap_ref3 = [];
	List<KpRefq> ap_refq = [];
	List<KpActor> ap_actor = [];
	List<KpDbcreate> ap_dbcreate = [];
	List<KpDbload> ap_dbload = [];
	List<KpDbselect> ap_dbselect = [];
	List<KpAll> ap_all = [];
	List<KpDu> ap_du = [];
	List<KpNew> ap_new = [];
	List<KpRefs> ap_refs = [];
	List<KpVar> ap_var = [];
	List<KpIts> ap_its = [];
	List<KpC> ap_c = [];
	List<KpCs> ap_cs = [];
	List<KpInclude> ap_include = [];
	List<KpOut> ap_out = [];
	List<KpBreak> ap_break = [];
	List<KpUnique> ap_unique = [];
	List<KpCollect> ap_collect = [];
	List<KpHash> ap_hash = [];
	List<KpGroup> ap_group = [];
	List<KpJson> ap_json = [];
	List<KpYaml> ap_yaml = [];
	List<KpXml> ap_xml = [];
}

bool refs(act)
{
	var errs = false;
	var res = fnd(act, '', '', '', '');
	for(var st in act.ap_comp) {
		res = fnd(act, "Comp_" + get_name(st.names, "parent") , get_name(st.names, "parent"),  ".", st.line_no );
		st.k_parentp = res[1];
		st.names["k_parentp"] = st.k_parentp.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_ref) {
		res = fnd(act, st.parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
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
		res = fnd(act, st.parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
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
		res = fnd(act, st.parentp.toString() + "_Element_" + get_name(st.names, "element2") , get_name(st.names, "element2"),  "check", st.line_no );
		st.k_element2p = res[1];
		st.names["k_element2p"] = st.k_element2p.toString();
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_ref3) {
		res = fnd(act, st.parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
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
		res = fnd(act, st.parentp.toString() + "_Element_" + get_name(st.names, "element2") , get_name(st.names, "element2"),  "check", st.line_no );
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
		res = fnd(act, st.parentp.toString() + "_Element_" + get_name(st.names, "element") , get_name(st.names, "element"),  "check", st.line_no );
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
	for(var st in act.ap_dbselect) {
		res = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no );
		st.k_actorp = res[1];
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
	return(errs);
}

List var_all(glob, va, lno) 
{
	if (va.size < 3) {
		return( [false, "?" + va.size.toString() + "<3?" + lno + "?"] );
	}
	return( [false, "?" + va[0] + "?" + lno + "?"] );
}

int do_all(glob, va, lno)
{
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
	if (va[0].compareTo("Token") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Token_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_token[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_token[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_token) {
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
	if (va[0].compareTo("Star") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["Star_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_star[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_star[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_star) {
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
	print("?No all " + va[0] + " cmd " + "," + lno + "?");
	return 0;
}

bool load(act, tok, ln, pos, lno)
{
	bool errs = false;
	if ( tok.compareTo( "Comp" ) == 0 ) {
		var comp = new KpComp();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_comp.add( comp );
	}
	if ( tok.compareTo( "Token" ) == 0 ) {
		var comp = new KpToken();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_token.add( comp );
	}
	if ( tok.compareTo( "Star" ) == 0 ) {
		var comp = new KpStar();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_star.add( comp );
	}
	if ( tok.compareTo( "*" ) == 0 ) {
		var comp = KpStar();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_star.add( comp );
	}
	if ( tok.compareTo( "Element" ) == 0 ) {
		var comp = new KpElement();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_element.add( comp );
	}
	if ( tok.compareTo( "Opt" ) == 0 ) {
		var comp = new KpOpt();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_opt.add( comp );
	}
	if ( tok.compareTo( "Ref" ) == 0 ) {
		var comp = new KpRef();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_ref.add( comp );
	}
	if ( tok.compareTo( "Ref2" ) == 0 ) {
		var comp = new KpRef2();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_ref2.add( comp );
	}
	if ( tok.compareTo( "Ref3" ) == 0 ) {
		var comp = new KpRef3();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_ref3.add( comp );
	}
	if ( tok.compareTo( "Refq" ) == 0 ) {
		var comp = new KpRefq();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_refq.add( comp );
	}
	if ( tok.compareTo( "Actor" ) == 0 ) {
		var comp = new KpActor();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_actor.add( comp );
	}
	if ( tok.compareTo( "Dbcreate" ) == 0 ) {
		var comp = new KpDbcreate();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_dbcreate.add( comp );
	}
	if ( tok.compareTo( "Dbload" ) == 0 ) {
		var comp = new KpDbload();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_dbload.add( comp );
	}
	if ( tok.compareTo( "Dbselect" ) == 0 ) {
		var comp = new KpDbselect();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_dbselect.add( comp );
	}
	if ( tok.compareTo( "All" ) == 0 ) {
		var comp = new KpAll();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_all.add( comp );
	}
	if ( tok.compareTo( "Du" ) == 0 ) {
		var comp = new KpDu();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_du.add( comp );
	}
	if ( tok.compareTo( "New" ) == 0 ) {
		var comp = new KpNew();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_new.add( comp );
	}
	if ( tok.compareTo( "Refs" ) == 0 ) {
		var comp = new KpRefs();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_refs.add( comp );
	}
	if ( tok.compareTo( "Var" ) == 0 ) {
		var comp = new KpVar();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_var.add( comp );
	}
	if ( tok.compareTo( "Its" ) == 0 ) {
		var comp = new KpIts();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_its.add( comp );
	}
	if ( tok.compareTo( "C" ) == 0 ) {
		var comp = new KpC();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_c.add( comp );
	}
	if ( tok.compareTo( "Cs" ) == 0 ) {
		var comp = new KpCs();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_cs.add( comp );
	}
	if ( tok.compareTo( "Include" ) == 0 ) {
		var comp = new KpInclude();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_include.add( comp );
	}
	if ( tok.compareTo( "Out" ) == 0 ) {
		var comp = new KpOut();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_out.add( comp );
	}
	if ( tok.compareTo( "Break" ) == 0 ) {
		var comp = new KpBreak();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_break.add( comp );
	}
	if ( tok.compareTo( "Unique" ) == 0 ) {
		var comp = new KpUnique();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_unique.add( comp );
	}
	if ( tok.compareTo( "Collect" ) == 0 ) {
		var comp = new KpCollect();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_collect.add( comp );
	}
	if ( tok.compareTo( "Hash" ) == 0 ) {
		var comp = new KpHash();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_hash.add( comp );
	}
	if ( tok.compareTo( "Group" ) == 0 ) {
		var comp = new KpGroup();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_group.add( comp );
	}
	if ( tok.compareTo( "Json" ) == 0 ) {
		var comp = new KpJson();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_json.add( comp );
	}
	if ( tok.compareTo( "Yaml" ) == 0 ) {
		var comp = new KpYaml();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_yaml.add( comp );
	}
	if ( tok.compareTo( "Xml" ) == 0 ) {
		var comp = new KpXml();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_xml.add( comp );
	}
	return(errs);
}
