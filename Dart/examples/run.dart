part of gen;

class ActT 
{
	Map index = new Map();
	List<KpComp> ap_comp = [];
	List<KpElement> ap_element = [];
	List<KpRef> ap_ref = [];
	List<KpActor> ap_actor = [];
	List<KpC> ap_c = [];
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
	if ( tok.compareTo( "Element" ) == 0 ) {
		var comp = new KpElement();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_element.add( comp );
	}
	if ( tok.compareTo( "Ref" ) == 0 ) {
		var comp = new KpRef();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_ref.add( comp );
	}
	if ( tok.compareTo( "Actor" ) == 0 ) {
		var comp = new KpActor();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_actor.add( comp );
	}
	if ( tok.compareTo( "C" ) == 0 ) {
		var comp = new KpC();
		var r = comp.load(act, ln, pos, lno);
		if (r == false) {
			errs = true;
		}
		act.ap_c.add( comp );
	}
	return(errs);
}
