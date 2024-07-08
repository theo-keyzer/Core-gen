part of gen;

class ActT 
{
	Map index = new Map();
	List<KpComp> ap_comp = [];
	List<KpElement> ap_element = [];
	List<KpOpt> ap_opt = [];
	List<KpRef> ap_ref = [];
	List<KpRef2> ap_ref2 = [];
	List<KpRef3> ap_ref3 = [];
	List<KpRefq> ap_refq = [];
	List<KpRefu> ap_refu = [];
	List<KpJoin> ap_join = [];
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
	List<KpAppend> ap_append = [];
	List<KpThis> ap_this = [];
	List<KpClear> ap_clear = [];
	List<KpCheck> ap_check = [];
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
	for(var st in act.ap_refu) {
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
	return(errs);
}

List var_all(glob, va, lno) 
{
	if (va.length < 3) {
		return( [false, "?" + va.length.toString() + "<3?" + lno + "?"] );
	}
	if (va[0].compareTo("Comp") == 0) {
		var en = glob.dats.index["Comp_" + va[1] ];
		if(en != null) {
			return (glob.dats.ap_comp[en].get_var(glob, va.sublist(2), lno));
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

bool load(act, toks, ln, pos, lno)
{
	bool errs = false;
	var ss = toks.split(".");
	var tok = ss[0];
	var flag = ss.sublist(1);
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
	if ( tok.compareTo( "Append" ) == 0 ) {
		var comp = new KpAppend();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_append.add( comp );
	}
	if ( tok.compareTo( "This" ) == 0 ) {
		var comp = new KpThis();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_this.add( comp );
	}
	if ( tok.compareTo( "Clear" ) == 0 ) {
		var comp = new KpClear();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_clear.add( comp );
	}
	if ( tok.compareTo( "Check" ) == 0 ) {
		var comp = new KpCheck();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_check.add( comp );
	}
	return(errs);
}
