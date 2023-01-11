part of gen;

class Kp
{
	int me = -1;
	String comp = "Kp";
	String line_no = "";
	Map names = new Map();
	int do_its(glob, va, lno) {
		print("?No its " + va[0] + " cmd for Kp," + lno + "?");
		return(0);
	}

	List get_var(glob, va, lno) {
		var v = names[ va[0] ];
		if (v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Kp?"] );
	}
}

class KpComp extends Kp 
{
	int k_parentp = -1;
	List <KpElement> itselement = [];
	List <KpRef> itsref = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Comp";
		line_no = lno;
		me = act.ap_comp.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Comp";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["nop"] = tok[1];
		tok = getw(ln,tok[0]);
		names["parent"] = tok[1];
		tok = getw(ln,tok[0]);
		names["find"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		act.index["Comp_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // tst.unit:16, d_struct.act:647
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("Comp_parent") == 0 && va.length > 1) { // tst.unit:16, d_struct.act:742
			for (var st in glob.dats.ap_comp) {
				if (st.k_parentp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref_comp") == 0 && va.length > 1) { // tst.unit:54, d_struct.act:742
			for (var st in glob.dats.ap_ref) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Element") == 0 && va.length > 2) { // tst.unit:24, d_struct.act:447
			var en = glob.dats.index[me.toString() + "_Element_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_element[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		if (va[0].compareTo("Ref") == 0 && va.length > 2 && itsref.length > 0) { // tst.unit:39, d_struct.act:459
			return (itsref[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Element") == 0) { // tst.unit:19, d_struct.act:721
			for(var st in itselement) {
				if (va.length > 1) {
					var ret = st.do_its(glob, va.sublist(1), lno);
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
		if (va[0].compareTo("Ref") == 0) { // tst.unit:39, d_struct.act:721
			for(var st in itsref) {
				if (va.length > 1) {
					var ret = st.do_its(glob, va.sublist(1), lno);
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
		if (va[0].compareTo("parent") == 0) {
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Comp_parent") == 0) { // tst.unit:16, d_struct.act:552
			for (KpComp st in glob.dats.ap_comp) {
				if (st.k_parentp == me) {
					if (va.length > 1) {
						var ret = st.do_its(glob, va.sublist(1), lno);
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
			}
			return(0);
		}
		if (va[0].compareTo("Ref_comp") == 0) { // tst.unit:54, d_struct.act:552
			for (KpRef st in glob.dats.ap_ref) {
				if (st.k_compp == me) {
					if (va.length > 1) {
						var ret = st.do_its(glob, va.sublist(1), lno);
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
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // tst.unit:2, d_struct.act:159
			for (var st in childs) {
				if (va.length > 1) {
					var ret = st.do_its(glob, va.sublist(1), lno);
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
		print("?No its " + va[0] + " cmd for Comp," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpElement extends Kp 
{
	int parentp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Element";
		line_no = lno;
		me = act.ap_element.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Element";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["mw"] = tok[1];
		tok = getw(ln,tok[0]);
		names["mw2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		parentp = act.ap_comp.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Element has no Comp parent" );
			return false;
		}
		act.ap_comp[ parentp ].itselement.add( this );
		act.ap_comp[ parentp ].childs.add( this );
		var s = parentp.toString() + "_Element_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // tst.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Ref_element") == 0 && va.length > 1) { // tst.unit:53, d_struct.act:742
			for (var st in glob.dats.ap_ref) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Element?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // tst.unit:2, d_struct.act:527
			if (parentp >= 0) {
				var st = glob.dats.ap_comp[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Ref_element") == 0) { // tst.unit:53, d_struct.act:552
			for (KpRef st in glob.dats.ap_ref) {
				if (st.k_elementp == me) {
					if (va.length > 1) {
						var ret = st.do_its(glob, va.sublist(1), lno);
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
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // tst.unit:19, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Element," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRef extends Kp 
{
	int parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Ref";
		line_no = lno;
		me = act.ap_ref.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Ref";
		tok = getw(ln,tok[0]);
		names["element"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp"] = tok[1];
		tok = getw(ln,tok[0]);
		names["opt"] = tok[1];
		tok = getw(ln,tok[0]);
		names["var"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		parentp = act.ap_comp.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Ref has no Comp parent" );
			return false;
		}
		act.ap_comp[ parentp ].itsref.add( this );
		act.ap_comp[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // tst.unit:53, d_struct.act:647
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // tst.unit:54, d_struct.act:647
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // tst.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // tst.unit:2, d_struct.act:527
			if (parentp >= 0) {
				var st = glob.dats.ap_comp[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element") == 0) {
			if (k_elementp >= 0) {
				var st = glob.dats.ap_element[ k_elementp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp") == 0) {
			if (k_compp >= 0) {
				var st = glob.dats.ap_comp[ k_compp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // tst.unit:39, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpActor extends Kp 
{
	String k_name = "";
	String k_comp = "";
	String k_attr = "";
	String k_eq = "";
	String k_value = "";
	String k_cc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Actor";
		line_no = lno;
		me = act.ap_actor.length;
		tok = getw(ln,tok[0]);
		k_name = tok[1];
		tok = getw(ln,tok[0]);
		k_comp = tok[1];
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getw(ln,tok[0]);
		k_value = tok[1];
		tok = getws(ln,tok[0]);
		k_cc = tok[1];
		act.index["Actor_" + k_name] = me;
		return true;
	}
}

class KpC extends Kp 
{
	int parentp = -1;
	String k_desc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "C";
		line_no = lno;
		me = act.ap_c.length;
		tok = getws(ln,tok[0]);
		k_desc = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " C has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

