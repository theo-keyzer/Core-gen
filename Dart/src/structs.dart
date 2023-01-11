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
	List <KpToken> itstoken = [];
	List <KpElement> itselement = [];
	List <KpRef> itsref = [];
	List <KpRef2> itsref2 = [];
	List <KpRef3> itsref3 = [];
	List <KpRefq> itsrefq = [];
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:16, d_struct.act:647
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("Comp_parent") == 0 && va.length > 1) { // gen.unit:16, d_struct.act:742
			for (var st in glob.dats.ap_comp) {
				if (st.k_parentp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref_comp") == 0 && va.length > 1) { // gen.unit:83, d_struct.act:742
			for (var st in glob.dats.ap_ref) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_comp") == 0 && va.length > 1) { // gen.unit:101, d_struct.act:742
			for (var st in glob.dats.ap_ref2) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_comp") == 0 && va.length > 1) { // gen.unit:122, d_struct.act:742
			for (var st in glob.dats.ap_ref3) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_comp_ref") == 0 && va.length > 1) { // gen.unit:123, d_struct.act:742
			for (var st in glob.dats.ap_ref3) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_comp") == 0 && va.length > 1) { // gen.unit:144, d_struct.act:742
			for (var st in glob.dats.ap_refq) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_comp_ref") == 0 && va.length > 1) { // gen.unit:145, d_struct.act:742
			for (var st in glob.dats.ap_refq) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Token") == 0 && va.length > 2 && itstoken.length > 0) { // gen.unit:19, d_struct.act:459
			return (itstoken[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Element") == 0 && va.length > 2) { // gen.unit:42, d_struct.act:447
			var en = glob.dats.index[me.toString() + "_Element_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_element[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		if (va[0].compareTo("Ref") == 0 && va.length > 2 && itsref.length > 0) { // gen.unit:68, d_struct.act:459
			return (itsref[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Ref2") == 0 && va.length > 2 && itsref2.length > 0) { // gen.unit:86, d_struct.act:459
			return (itsref2[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Ref3") == 0 && va.length > 2 && itsref3.length > 0) { // gen.unit:105, d_struct.act:459
			return (itsref3[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Refq") == 0 && va.length > 2 && itsrefq.length > 0) { // gen.unit:127, d_struct.act:459
			return (itsrefq[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Token") == 0) { // gen.unit:19, d_struct.act:721
			for(var st in itstoken) {
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
		if (va[0].compareTo("Element") == 0) { // gen.unit:37, d_struct.act:721
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
		if (va[0].compareTo("Ref") == 0) { // gen.unit:68, d_struct.act:721
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
		if (va[0].compareTo("Ref2") == 0) { // gen.unit:86, d_struct.act:721
			for(var st in itsref2) {
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
		if (va[0].compareTo("Ref3") == 0) { // gen.unit:105, d_struct.act:721
			for(var st in itsref3) {
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
		if (va[0].compareTo("Refq") == 0) { // gen.unit:127, d_struct.act:721
			for(var st in itsrefq) {
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
		if (va[0].compareTo("Comp_parent") == 0) { // gen.unit:16, d_struct.act:552
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
		if (va[0].compareTo("Ref_comp") == 0) { // gen.unit:83, d_struct.act:552
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
		if (va[0].compareTo("Ref2_comp") == 0) { // gen.unit:101, d_struct.act:552
			for (KpRef2 st in glob.dats.ap_ref2) {
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
		if (va[0].compareTo("Ref3_comp") == 0) { // gen.unit:122, d_struct.act:552
			for (KpRef3 st in glob.dats.ap_ref3) {
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
		if (va[0].compareTo("Ref3_comp_ref") == 0) { // gen.unit:123, d_struct.act:552
			for (KpRef3 st in glob.dats.ap_ref3) {
				if (st.k_comp_refp == me) {
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
		if (va[0].compareTo("Refq_comp") == 0) { // gen.unit:144, d_struct.act:552
			for (KpRefq st in glob.dats.ap_refq) {
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
		if (va[0].compareTo("Refq_comp_ref") == 0) { // gen.unit:145, d_struct.act:552
			for (KpRefq st in glob.dats.ap_refq) {
				if (st.k_comp_refp == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:2, d_struct.act:159
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

class KpToken extends Kp 
{
	int parentp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Token";
		line_no = lno;
		me = act.ap_token.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Token";
		tok = getw(ln,tok[0]);
		names["token"] = tok[1];
		parentp = act.ap_comp.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Token has no Comp parent" );
			return false;
		}
		act.ap_comp[ parentp ].itstoken.add( this );
		act.ap_comp[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Token?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:527
			if (parentp >= 0) {
				var st = glob.dats.ap_comp[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:19, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Token," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpStar extends Kp 
{

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Star";
		line_no = lno;
		me = act.ap_star.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Star";
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		return true;
	}

	List get_var(glob, va, lno) {
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Star?"] );
	}

	int do_its(glob, va, lno) {
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:27, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Star," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpElement extends Kp 
{
	int parentp = -1;
	List <KpOpt> itsopt = [];
	List <Kp> childs = [];

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
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Ref_element") == 0 && va.length > 1) { // gen.unit:82, d_struct.act:742
			for (var st in glob.dats.ap_ref) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_element") == 0 && va.length > 1) { // gen.unit:100, d_struct.act:742
			for (var st in glob.dats.ap_ref2) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_element2") == 0 && va.length > 1) { // gen.unit:102, d_struct.act:742
			for (var st in glob.dats.ap_ref2) {
				if (st.k_element2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_element") == 0 && va.length > 1) { // gen.unit:121, d_struct.act:742
			for (var st in glob.dats.ap_ref3) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_element2") == 0 && va.length > 1) { // gen.unit:124, d_struct.act:742
			for (var st in glob.dats.ap_ref3) {
				if (st.k_element2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_element") == 0 && va.length > 1) { // gen.unit:143, d_struct.act:742
			for (var st in glob.dats.ap_refq) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Opt") == 0 && va.length > 2) { // gen.unit:63, d_struct.act:447
			var en = glob.dats.index[me.toString() + "_Opt_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_opt[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Element?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Opt") == 0) { // gen.unit:57, d_struct.act:721
			for(var st in itsopt) {
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:527
			if (parentp >= 0) {
				var st = glob.dats.ap_comp[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Ref_element") == 0) { // gen.unit:82, d_struct.act:552
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
		if (va[0].compareTo("Ref2_element") == 0) { // gen.unit:100, d_struct.act:552
			for (KpRef2 st in glob.dats.ap_ref2) {
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
		if (va[0].compareTo("Ref2_element2") == 0) { // gen.unit:102, d_struct.act:552
			for (KpRef2 st in glob.dats.ap_ref2) {
				if (st.k_element2p == me) {
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
		if (va[0].compareTo("Ref3_element") == 0) { // gen.unit:121, d_struct.act:552
			for (KpRef3 st in glob.dats.ap_ref3) {
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
		if (va[0].compareTo("Ref3_element2") == 0) { // gen.unit:124, d_struct.act:552
			for (KpRef3 st in glob.dats.ap_ref3) {
				if (st.k_element2p == me) {
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
		if (va[0].compareTo("Refq_element") == 0) { // gen.unit:143, d_struct.act:552
			for (KpRefq st in glob.dats.ap_refq) {
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:37, d_struct.act:159
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
		print("?No its " + va[0] + " cmd for Element," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpOpt extends Kp 
{
	int parentp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Opt";
		line_no = lno;
		me = act.ap_opt.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Opt";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		parentp = act.ap_element.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Opt has no Element parent" );
			return false;
		}
		act.ap_element[ parentp ].itsopt.add( this );
		act.ap_element[ parentp ].childs.add( this );
		var s = parentp.toString() + "_Opt_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:37, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Opt?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:37, d_struct.act:527
			if (parentp >= 0) {
				var st = glob.dats.ap_element[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:57, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Opt," + line_no + "," + lno + "?");
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
		if (va[0].compareTo("element") == 0) { // gen.unit:82, d_struct.act:647
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:83, d_struct.act:647
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:542
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:527
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:68, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRef2 extends Kp 
{
	int parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_element2p = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Ref2";
		line_no = lno;
		me = act.ap_ref2.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Ref2";
		tok = getw(ln,tok[0]);
		names["element"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp"] = tok[1];
		tok = getw(ln,tok[0]);
		names["element2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["opt"] = tok[1];
		tok = getw(ln,tok[0]);
		names["var"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		parentp = act.ap_comp.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Ref2 has no Comp parent" );
			return false;
		}
		act.ap_comp[ parentp ].itsref2.add( this );
		act.ap_comp[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:100, d_struct.act:647
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:101, d_struct.act:647
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("element2") == 0) { // gen.unit:102, d_struct.act:647
			if (k_element2p >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref2?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:527
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
		if (va[0].compareTo("element2") == 0) {
			if (k_element2p >= 0) {
				var st = glob.dats.ap_element[ k_element2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:86, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref2," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRef3 extends Kp 
{
	int parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_element2p = -1;
	int k_comp_refp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Ref3";
		line_no = lno;
		me = act.ap_ref3.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Ref3";
		tok = getw(ln,tok[0]);
		names["element"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp"] = tok[1];
		tok = getw(ln,tok[0]);
		names["element2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp_ref"] = tok[1];
		tok = getw(ln,tok[0]);
		names["element3"] = tok[1];
		tok = getw(ln,tok[0]);
		names["opt"] = tok[1];
		tok = getw(ln,tok[0]);
		names["var"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		parentp = act.ap_comp.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Ref3 has no Comp parent" );
			return false;
		}
		act.ap_comp[ parentp ].itsref3.add( this );
		act.ap_comp[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:121, d_struct.act:647
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:122, d_struct.act:647
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:123, d_struct.act:647
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("element2") == 0) { // gen.unit:124, d_struct.act:647
			if (k_element2p >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref3?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:527
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
		if (va[0].compareTo("comp_ref") == 0) {
			if (k_comp_refp >= 0) {
				var st = glob.dats.ap_comp[ k_comp_refp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element2") == 0) {
			if (k_element2p >= 0) {
				var st = glob.dats.ap_element[ k_element2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:105, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref3," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRefq extends Kp 
{
	int parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_comp_refp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Refq";
		line_no = lno;
		me = act.ap_refq.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Refq";
		tok = getw(ln,tok[0]);
		names["element"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp"] = tok[1];
		tok = getw(ln,tok[0]);
		names["element2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp_ref"] = tok[1];
		tok = getw(ln,tok[0]);
		names["opt"] = tok[1];
		tok = getw(ln,tok[0]);
		names["var"] = tok[1];
		tok = getws(ln,tok[0]);
		names["doc"] = tok[1];
		parentp = act.ap_comp.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Refq has no Comp parent" );
			return false;
		}
		act.ap_comp[ parentp ].itsrefq.add( this );
		act.ap_comp[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:143, d_struct.act:647
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:144, d_struct.act:647
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:145, d_struct.act:647
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:542
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Refq?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:527
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
		if (va[0].compareTo("comp_ref") == 0) {
			if (k_comp_refp >= 0) {
				var st = glob.dats.ap_comp[ k_comp_refp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:127, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Refq," + line_no + "," + lno + "?");
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

class KpDbcreate extends Kp 
{
	int parentp = -1;
	String k_where = "";
	String k_tbl = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Dbcreate";
		line_no = lno;
		me = act.ap_dbcreate.length;
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		tok = getw(ln,tok[0]);
		k_tbl = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Dbcreate has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpDbload extends Kp 
{
	int parentp = -1;
	String k_where = "";
	String k_tbl = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Dbload";
		line_no = lno;
		me = act.ap_dbload.length;
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		tok = getw(ln,tok[0]);
		k_tbl = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Dbload has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpDbselect extends Kp 
{
	int parentp = -1;
	String k_actor = "";
	String k_where = "";
	String k_what = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Dbselect";
		line_no = lno;
		me = act.ap_dbselect.length;
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		tok = getws(ln,tok[0]);
		k_what = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Dbselect has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpAll extends Kp 
{
	int parentp = -1;
	String k_what = "";
	String k_actor = "";
	String k_attr = "";
	String k_eq = "";
	String k_value = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "All";
		line_no = lno;
		me = act.ap_all.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getw(ln,tok[0]);
		k_value = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " All has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpDu extends Kp 
{
	int parentp = -1;
	String k_actor = "";
	String k_attr = "";
	String k_eq = "";
	String k_value = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Du";
		line_no = lno;
		me = act.ap_du.length;
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getw(ln,tok[0]);
		k_value = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Du has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpNew extends Kp 
{
	int parentp = -1;
	String k_where = "";
	String k_what = "";
	String k_line = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "New";
		line_no = lno;
		me = act.ap_new.length;
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getws(ln,tok[0]);
		k_line = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " New has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpRefs extends Kp 
{
	int parentp = -1;
	String k_where = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Refs";
		line_no = lno;
		me = act.ap_refs.length;
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Refs has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpVar extends Kp 
{
	int parentp = -1;
	String k_attr = "";
	String k_eq = "";
	String k_value = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Var";
		line_no = lno;
		me = act.ap_var.length;
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getws(ln,tok[0]);
		k_value = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Var has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpIts extends Kp 
{
	int parentp = -1;
	String k_what = "";
	String k_actor = "";
	String k_attr = "";
	String k_eq = "";
	String k_value = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Its";
		line_no = lno;
		me = act.ap_its.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getw(ln,tok[0]);
		k_value = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Its has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
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

class KpCs extends Kp 
{
	int parentp = -1;
	String k_desc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Cs";
		line_no = lno;
		me = act.ap_cs.length;
		tok = getws(ln,tok[0]);
		k_desc = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Cs has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpInclude extends Kp 
{
	int parentp = -1;
	String k_opt = "";
	String k_file = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Include";
		line_no = lno;
		me = act.ap_include.length;
		tok = getw(ln,tok[0]);
		k_opt = tok[1];
		tok = getws(ln,tok[0]);
		k_file = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Include has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpOut extends Kp 
{
	int parentp = -1;
	String k_what = "";
	String k_pad = "";
	String k_desc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Out";
		line_no = lno;
		me = act.ap_out.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_pad = tok[1];
		tok = getws(ln,tok[0]);
		k_desc = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Out has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpBreak extends Kp 
{
	int parentp = -1;
	String k_what = "";
	String k_on = "";
	String k_vars = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Break";
		line_no = lno;
		me = act.ap_break.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_on = tok[1];
		tok = getws(ln,tok[0]);
		k_vars = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Break has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpUnique extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_key = "";
	String k_value = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Unique";
		line_no = lno;
		me = act.ap_unique.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_key = tok[1];
		tok = getws(ln,tok[0]);
		k_value = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Unique has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpCollect extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_pocket = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Collect";
		line_no = lno;
		me = act.ap_collect.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Collect has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpHash extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_pocket = "";
	String k_key = "";
	String k_value = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Hash";
		line_no = lno;
		me = act.ap_hash.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getw(ln,tok[0]);
		k_key = tok[1];
		tok = getws(ln,tok[0]);
		k_value = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Hash has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpGroup extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_pocket = "";
	String k_key = "";
	String k_value = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Group";
		line_no = lno;
		me = act.ap_group.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getw(ln,tok[0]);
		k_key = tok[1];
		tok = getws(ln,tok[0]);
		k_value = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Group has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpJson extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_pocket = "";
	String k_file = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Json";
		line_no = lno;
		me = act.ap_json.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getws(ln,tok[0]);
		k_file = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Json has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpYaml extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_pocket = "";
	String k_file = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Yaml";
		line_no = lno;
		me = act.ap_yaml.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getws(ln,tok[0]);
		k_file = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Yaml has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpXml extends Kp 
{
	int parentp = -1;
	String k_cmd = "";
	String k_pocket = "";
	String k_file = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Xml";
		line_no = lno;
		me = act.ap_xml.length;
		tok = getw(ln,tok[0]);
		k_cmd = tok[1];
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getws(ln,tok[0]);
		k_file = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Xml has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

