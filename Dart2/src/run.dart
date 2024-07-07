part of gen;

class ActT 
{
	Map index = new Map();
	List<KpDomain> ap_domain = [];
	List<KpModel> ap_model = [];
	List<KpFrame> ap_frame = [];
	List<KpA> ap_a = [];
	List<KpUse> ap_use = [];
	List<KpGrid> ap_grid = [];
	List<KpCol> ap_col = [];
	List<KpR> ap_r = [];
	List<KpConcept> ap_concept = [];
	List<KpTopic> ap_topic = [];
	List<KpT> ap_t = [];
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
	List<KpAdd> ap_add = [];
	List<KpAppend> ap_append = [];
	List<KpThis> ap_this = [];
	List<KpClear> ap_clear = [];
	List<KpCheck> ap_check = [];
	List<KpJson> ap_json = [];
	List<KpYaml> ap_yaml = [];
	List<KpXml> ap_xml = [];
}

bool refs(act)
{
	var errs = false;
	var res = fnd(act, '', '', '', '');
	for(var st in act.ap_frame) {
		res = fnd(act, "Domain_" + get_name(st.names, "domain") , get_name(st.names, "domain"),  "?", st.line_no );
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
	for(var st in act.ap_r) {
		res = fnd(act, "Grid_" + get_name(st.names, "name") , get_name(st.names, "name"),  "?", st.line_no );
		st.k_namep = res[1];
		st.names["k_namep"] = st.k_namep.toString();
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
	for(var st in act.ap_this) {
		res = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no );
		st.k_actorp = res[1];
		if (res[0] == false) {
			errs = true;
		}
	}
	for(var st in act.ap_a) {
		{
		var tp = -1;
		var ap = st.parentp;
		if (ap >= 0) {
			tp = act.ap_frame[ap].k_domainp;
		}
		if (tp >= 0) {
			res = fnd(act, tp.toString() + "_Model_" + get_name(st.names, "model") , get_name(st.names, "model"),  "?", st.line_no );
			st.k_modelp = res[1];
			if (res[0] == false) {
				errs = true;
			}
		} else if ("?".compareTo( "?" ) != 0 && get_name(st.names, "model").compareTo( "?") != 0) {
			print( "ref error " + st.line_no );
			errs = true;
		}
		st.names["k_modelp"] = st.k_modelp.toString();
		}
	}
	for(var st in act.ap_use) {
		{
		var tp = -1;
		var ap = st.parentp;
		if (ap >= 0) {
			tp = act.ap_a[ap].k_modelp;
		}
		if (tp >= 0) {
			res = fnd(act, tp.toString() + "_Frame_" + get_name(st.names, "frame") , get_name(st.names, "frame"),  "?", st.line_no );
			st.k_framep = res[1];
			if (res[0] == false) {
				errs = true;
			}
		} else if ("?".compareTo( "?" ) != 0 && get_name(st.names, "frame").compareTo( "?") != 0) {
			print( "ref error " + st.line_no );
			errs = true;
		}
		st.names["k_framep"] = st.k_framep.toString();
		}
		res = fnd(act, st.k_framep.toString() + "_A_" + get_name(st.names, "a") , get_name(st.names, "a"),  "?", st.line_no );
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
	return( [false, "?" + va[0] + "?" + lno + "?"] );
}

int do_all(glob, va, lno)
{
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
	if (va[0].compareTo("R") == 0) {
		if (va.length > 1 && va[1].length > 0) {
			var en = glob.dats.index["R_" + va[1] ];
			if (en != null) {
				if (va.length > 2) {
					return( glob.dats.ap_r[en].do_its(glob, va.sublist(2), lno) );
				}
				return( go_act(glob, glob.dats.ap_r[en]) );
			}
			return(0);
		}
		for(var st in glob.dats.ap_r) {
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
	print("?No all " + va[0] + " cmd " + "," + lno + "?");
	return 0;
}

bool load(act, toks, ln, pos, lno)
{
	bool errs = false;
	var ss = toks.split(".");
	var tok = ss[0];
	var flag = ss.sublist(1);
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
	if ( tok.compareTo( "Grid" ) == 0 ) {
		var comp = new KpGrid();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_grid.add( comp );
	}
	if ( tok.compareTo( "Col" ) == 0 ) {
		var comp = new KpCol();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_col.add( comp );
	}
	if ( tok.compareTo( "R" ) == 0 ) {
		var comp = new KpR();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_r.add( comp );
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
	if ( tok.compareTo( "Dbcreate" ) == 0 ) {
		var comp = new KpDbcreate();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_dbcreate.add( comp );
	}
	if ( tok.compareTo( "Dbload" ) == 0 ) {
		var comp = new KpDbload();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_dbload.add( comp );
	}
	if ( tok.compareTo( "Dbselect" ) == 0 ) {
		var comp = new KpDbselect();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_dbselect.add( comp );
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
	if ( tok.compareTo( "Include" ) == 0 ) {
		var comp = new KpInclude();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_include.add( comp );
	}
	if ( tok.compareTo( "Out" ) == 0 ) {
		var comp = new KpOut();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_out.add( comp );
	}
	if ( tok.compareTo( "Break" ) == 0 ) {
		var comp = new KpBreak();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_break.add( comp );
	}
	if ( tok.compareTo( "Unique" ) == 0 ) {
		var comp = new KpUnique();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_unique.add( comp );
	}
	if ( tok.compareTo( "Collect" ) == 0 ) {
		var comp = new KpCollect();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_collect.add( comp );
	}
	if ( tok.compareTo( "Hash" ) == 0 ) {
		var comp = new KpHash();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_hash.add( comp );
	}
	if ( tok.compareTo( "Group" ) == 0 ) {
		var comp = new KpGroup();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_group.add( comp );
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
	if ( tok.compareTo( "Json" ) == 0 ) {
		var comp = new KpJson();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_json.add( comp );
	}
	if ( tok.compareTo( "Yaml" ) == 0 ) {
		var comp = new KpYaml();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_yaml.add( comp );
	}
	if ( tok.compareTo( "Xml" ) == 0 ) {
		var comp = new KpXml();
		var r = comp.load(act, ln, pos, lno, flag);
		if (r == false) {
			errs = true;
		}
		act.ap_xml.add( comp );
	}
	return(errs);
}
