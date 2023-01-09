require "./*"

class ActT 
{
	Map index = new Map();
	List<KpComp> ap_comp = [];
	List<KpElement> ap_element = [];
	List<KpRef> ap_ref = [];
	List<KpActor> ap_actor = [];
	List<KpC> ap_c = [];
}

def refs(act)
	errs = false
	act.ap_comp.each_with_index do |st,i|
		r, st.k_parentp = fnd(act, "Comp_" + st.names["parent"] , st.names["parent"],  ".", st.line_no )
		st.names["k_parentp"] = st.k_parentp.to_s
		if r == false
			errs = true
		end
	end
	act.ap_ref.each_with_index do |st,i|
		r, st.k_elementp = fnd(act, st.parentp.to_s + "_Element_" + st.names["element"] , st.names["element"],  "check", st.line_no )
		st.names["k_elementp"] = st.k_elementp.to_s
		if r == false
			errs = true
		end
		r, st.k_compp = fnd(act, "Comp_" + st.names["comp"] , st.names["comp"],  "check", st.line_no )
		st.names["k_compp"] = st.k_compp.to_s
		if r == false
			errs = true
		end
	end
	return(errs)
end

def var_all(glob, va, lno) 
	if va.size < 3
		return(false, "?" + va.size.to_s + "<3?" + lno + "?")
	end
	if va[0] == "Comp" # tst.unit:2, d_run.act:211
		if en = glob.dats.index["Comp_" + va[1] ]?
			return (glob.dats.ap_comp[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Actor" # tst.unit:57, d_run.act:211
		if en = glob.dats.index["Actor_" + va[1] ]?
			return (glob.dats.ap_actor[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	return(false, "?" + va[0] + "?" + lno + "?")
end

def do_all(glob, va, lno)
	if va[0] == "Comp" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Comp_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_comp[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_comp[en]) )
			end
			return(0)
		end
		glob.dats.ap_comp.each do |st|
			if va.size > 2
				ret = st.do_its(glob, va[2..], lno)
				if ret != 0
					return(ret)
				end
				next
			end
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Element" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Element_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_element[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_element[en]) )
			end
			return(0)
		end
		glob.dats.ap_element.each do |st|
			if va.size > 2
				ret = st.do_its(glob, va[2..], lno)
				if ret != 0
					return(ret)
				end
				next
			end
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Ref" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Ref_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_ref[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_ref[en]) )
			end
			return(0)
		end
		glob.dats.ap_ref.each do |st|
			if va.size > 2
				ret = st.do_its(glob, va[2..], lno)
				if ret != 0
					return(ret)
				end
				next
			end
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Actor" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Actor_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_actor[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_actor[en]) )
			end
			return(0)
		end
		glob.dats.ap_actor.each do |st|
			if va.size > 2
				ret = st.do_its(glob, va[2..], lno)
				if ret != 0
					return(ret)
				end
				next
			end
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	puts "?No all " + va[0] + " cmd " + "," + lno + "?"
	return 0
end

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
