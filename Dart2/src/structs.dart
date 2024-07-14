part of gen;

class Kp
{
	int me = -1;
	String comp = "Kp";
	String line_no = "";
	List <String> flags = [];
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

class KpType extends Kp 
{
	List <KpData> itsdata = [];
	List <KpAttr> itsattr = [];
	List <KpWhere> itswhere = [];
	List <KpLogic> itslogic = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Type";
		line_no = lno;
		flags = flag;
		me = act.ap_type.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Type";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getws(ln,tok[0]);
		names["desc"] = tok[1];
		act.index["Type_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("Attr_table") == 0 && va.length > 1) { // sample.unit:58, d_struct.act:744
			for (var st in glob.dats.ap_attr) {
				if (st.k_tablep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Field_type") == 0 && va.length > 1) { // app.unit:62, d_struct.act:744
			for (var st in glob.dats.ap_field) {
				if (st.k_typep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Data") == 0 && va.length > 2 && itsdata.length > 0) { // sample.unit:13, d_struct.act:468
			return (itsdata[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Attr") == 0 && va.length > 2) { // sample.unit:51, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Attr_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_attr[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		if (va[0].compareTo("Where") == 0 && va.length > 2 && itswhere.length > 0) { // sample.unit:61, d_struct.act:468
			return (itswhere[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Logic") == 0 && va.length > 2 && itslogic.length > 0) { // sample.unit:83, d_struct.act:468
			return (itslogic[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Type?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Data") == 0) { // sample.unit:13, d_struct.act:723
			for(var st in itsdata) {
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
		if (va[0].compareTo("Attr") == 0) { // sample.unit:24, d_struct.act:723
			for(var st in itsattr) {
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
		if (va[0].compareTo("Where") == 0) { // sample.unit:61, d_struct.act:723
			for(var st in itswhere) {
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
		if (va[0].compareTo("Logic") == 0) { // sample.unit:83, d_struct.act:723
			for(var st in itslogic) {
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
		if (va[0].compareTo("Attr_table") == 0) { // sample.unit:58, d_struct.act:561
			for (KpAttr st in glob.dats.ap_attr) {
				if (st.k_tablep == me) {
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
		if (va[0].compareTo("Field_type") == 0) { // app.unit:62, d_struct.act:561
			for (KpField st in glob.dats.ap_field) {
				if (st.k_typep == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // sample.unit:2, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Type," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpData extends Kp 
{
	int k_parentp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Data";
		line_no = lno;
		flags = flag;
		me = act.ap_data.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Data";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["op"] = tok[1];
		tok = getws(ln,tok[0]);
		names["value"] = tok[1];
		k_parentp = act.ap_type.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Data has no Type parent" );
			return false;
		}
		act.ap_type[ k_parentp ].itsdata.add( this );
		act.ap_type[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_type[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Data?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_type[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // sample.unit:13, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Data," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpAttr extends Kp 
{
	int k_parentp = -1;
	int k_tablep = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Attr";
		line_no = lno;
		flags = flag;
		me = act.ap_attr.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Attr";
		tok = getw(ln,tok[0]);
		names["table"] = tok[1];
		tok = getw(ln,tok[0]);
		names["relation"] = tok[1];
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["mytype"] = tok[1];
		tok = getw(ln,tok[0]);
		names["len"] = tok[1];
		tok = getw(ln,tok[0]);
		names["null"] = tok[1];
		tok = getw(ln,tok[0]);
		names["flags"] = tok[1];
		tok = getws(ln,tok[0]);
		names["desc"] = tok[1];
		k_parentp = act.ap_type.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Attr has no Type parent" );
			return false;
		}
		act.ap_type[ k_parentp ].itsattr.add( this );
		act.ap_type[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Attr_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("table") == 0) { // sample.unit:58, d_struct.act:656
			if (k_tablep >= 0 && va.length > 1) {
				return( glob.dats.ap_type[ k_tablep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_type[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Where_attr") == 0 && va.length > 1) { // sample.unit:75, d_struct.act:744
			for (var st in glob.dats.ap_where) {
				if (st.k_attrp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Where_id") == 0 && va.length > 1) { // sample.unit:76, d_struct.act:744
			for (var st in glob.dats.ap_where) {
				if (st.k_idp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Logic_attr") == 0 && va.length > 1) { // sample.unit:96, d_struct.act:744
			for (var st in glob.dats.ap_logic) {
				if (st.k_attrp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Where_from_id") == 0 && va.length > 1) { // sample.unit:78, d_struct.act:756
			for (var st in glob.dats.ap_where) {
				if (st.k_from_idp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Of_attr") == 0 && va.length > 1) { // app.unit:84, d_struct.act:756
			for (var st in glob.dats.ap_of) {
				if (st.k_attrp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Of_from") == 0 && va.length > 1) { // app.unit:85, d_struct.act:756
			for (var st in glob.dats.ap_of) {
				if (st.k_fromp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Attr?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_type[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("table") == 0) {
			if (k_tablep >= 0) {
				var st = glob.dats.ap_type[ k_tablep ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Where_attr") == 0) { // sample.unit:75, d_struct.act:561
			for (KpWhere st in glob.dats.ap_where) {
				if (st.k_attrp == me) {
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
		if (va[0].compareTo("Where_id") == 0) { // sample.unit:76, d_struct.act:561
			for (KpWhere st in glob.dats.ap_where) {
				if (st.k_idp == me) {
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
		if (va[0].compareTo("Logic_attr") == 0) { // sample.unit:96, d_struct.act:561
			for (KpLogic st in glob.dats.ap_logic) {
				if (st.k_attrp == me) {
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
		if (va[0].compareTo("Where_from_id") == 0) { // sample.unit:78, d_struct.act:584
			for (KpWhere st in glob.dats.ap_where) {
				if (st.k_from_idp == me) {
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
		if (va[0].compareTo("Of_attr") == 0) { // app.unit:84, d_struct.act:584
			for (KpOf st in glob.dats.ap_of) {
				if (st.k_attrp == me) {
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
		if (va[0].compareTo("Of_from") == 0) { // app.unit:85, d_struct.act:584
			for (KpOf st in glob.dats.ap_of) {
				if (st.k_fromp == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // sample.unit:24, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Attr," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpWhere extends Kp 
{
	int k_parentp = -1;
	int k_attrp = -1;
	int k_tablep = -1;
	int k_from_idp = -1;
	int k_idp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Where";
		line_no = lno;
		flags = flag;
		me = act.ap_where.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Where";
		tok = getw(ln,tok[0]);
		names["attr"] = tok[1];
		tok = getw(ln,tok[0]);
		names["from_id"] = tok[1];
		tok = getw(ln,tok[0]);
		names["eq"] = tok[1];
		tok = getw(ln,tok[0]);
		names["id"] = tok[1];
		tok = getw(ln,tok[0]);
		names["op"] = tok[1];
		tok = getws(ln,tok[0]);
		names["value"] = tok[1];
		k_parentp = act.ap_type.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Where has no Type parent" );
			return false;
		}
		act.ap_type[ k_parentp ].itswhere.add( this );
		act.ap_type[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("attr") == 0) { // sample.unit:75, d_struct.act:656
			if (k_attrp >= 0 && va.length > 1) {
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("id") == 0) { // sample.unit:76, d_struct.act:656
			if (k_idp >= 0 && va.length > 1) {
				return( glob.dats.ap_attr[ k_idp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("from_id") == 0) { // sample.unit:78, d_struct.act:666
			if (k_from_idp >= 0 && va.length > 1) {
				return( glob.dats.ap_attr[ k_from_idp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_type[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Where?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_type[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("attr") == 0) {
			if (k_attrp >= 0) {
				var st = glob.dats.ap_attr[ k_attrp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("id") == 0) {
			if (k_idp >= 0) {
				var st = glob.dats.ap_attr[ k_idp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("from_id") == 0) {
			if (k_from_idp >= 0) {
				var st = glob.dats.ap_attr[ k_from_idp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // sample.unit:61, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Where," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpLogic extends Kp 
{
	int k_parentp = -1;
	int k_attrp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Logic";
		line_no = lno;
		flags = flag;
		me = act.ap_logic.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Logic";
		tok = getw(ln,tok[0]);
		names["attr"] = tok[1];
		tok = getw(ln,tok[0]);
		names["op"] = tok[1];
		tok = getw(ln,tok[0]);
		names["code"] = tok[1];
		k_parentp = act.ap_type.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Logic has no Type parent" );
			return false;
		}
		act.ap_type[ k_parentp ].itslogic.add( this );
		act.ap_type[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("attr") == 0) { // sample.unit:96, d_struct.act:656
			if (k_attrp >= 0 && va.length > 1) {
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_type[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Logic?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // sample.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_type[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("attr") == 0) {
			if (k_attrp >= 0) {
				var st = glob.dats.ap_attr[ k_attrp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // sample.unit:83, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Logic," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpNode extends Kp 
{
	int k_parentp = -1;
	List <KpLink> itslink = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Node";
		line_no = lno;
		flags = flag;
		me = act.ap_node.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Node";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getw(ln,tok[0]);
		names["parent"] = tok[1];
		tok = getw(ln,tok[0]);
		names["var"] = tok[1];
		tok = getw(ln,tok[0]);
		names["eq"] = tok[1];
		tok = getw(ln,tok[0]);
		names["value"] = tok[1];
		act.index["Node_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:12, d_struct.act:656
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_node[ k_parentp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("Node_parent") == 0 && va.length > 1) { // app.unit:12, d_struct.act:744
			for (var st in glob.dats.ap_node) {
				if (st.k_parentp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Link_to") == 0 && va.length > 1) { // app.unit:20, d_struct.act:744
			for (var st in glob.dats.ap_link) {
				if (st.k_top == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Link") == 0 && va.length > 2 && itslink.length > 0) { // app.unit:15, d_struct.act:468
			return (itslink[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Node?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Link") == 0) { // app.unit:15, d_struct.act:723
			for(var st in itslink) {
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
				var st = glob.dats.ap_node[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Node_parent") == 0) { // app.unit:12, d_struct.act:561
			for (KpNode st in glob.dats.ap_node) {
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
		if (va[0].compareTo("Link_to") == 0) { // app.unit:20, d_struct.act:561
			for (KpLink st in glob.dats.ap_link) {
				if (st.k_top == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:2, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Node," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpLink extends Kp 
{
	int k_parentp = -1;
	int k_top = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Link";
		line_no = lno;
		flags = flag;
		me = act.ap_link.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Link";
		tok = getw(ln,tok[0]);
		names["to"] = tok[1];
		k_parentp = act.ap_node.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Link has no Node parent" );
			return false;
		}
		act.ap_node[ k_parentp ].itslink.add( this );
		act.ap_node[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("to") == 0) { // app.unit:20, d_struct.act:656
			if (k_top >= 0 && va.length > 1) {
				return( glob.dats.ap_node[ k_top ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // app.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_node[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Link?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_node[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("to") == 0) {
			if (k_top >= 0) {
				var st = glob.dats.ap_node[ k_top ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:15, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Link," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpGraph extends Kp 
{

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Graph";
		line_no = lno;
		flags = flag;
		me = act.ap_graph.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Graph";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["search"] = tok[1];
		act.index["Graph_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Graph?"] );
	}

	int do_its(glob, va, lno) {
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:23, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Graph," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpMatrix extends Kp 
{

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Matrix";
		line_no = lno;
		flags = flag;
		me = act.ap_matrix.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Matrix";
		tok = getw(ln,tok[0]);
		names["a"] = tok[1];
		tok = getw(ln,tok[0]);
		names["b"] = tok[1];
		tok = getw(ln,tok[0]);
		names["c"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getw(ln,tok[0]);
		names["search"] = tok[1];
		return true;
	}

	List get_var(glob, va, lno) {
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Matrix?"] );
	}

	int do_its(glob, va, lno) {
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:31, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Matrix," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpTable extends Kp 
{
	List <KpField> itsfield = [];
	List <KpOf> itsof = [];
	List <KpJoin1> itsjoin1 = [];
	List <KpJoin2> itsjoin2 = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Table";
		line_no = lno;
		flags = flag;
		me = act.ap_table.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Table";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getw(ln,tok[0]);
		names["value"] = tok[1];
		act.index["Table_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("Join1_table2") == 0 && va.length > 1) { // app.unit:104, d_struct.act:744
			for (var st in glob.dats.ap_join1) {
				if (st.k_table2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Join2_table2") == 0 && va.length > 1) { // app.unit:119, d_struct.act:744
			for (var st in glob.dats.ap_join2) {
				if (st.k_table2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Field") == 0 && va.length > 2) { // app.unit:53, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Field_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_field[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		if (va[0].compareTo("Of") == 0 && va.length > 2 && itsof.length > 0) { // app.unit:71, d_struct.act:468
			return (itsof[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Join1") == 0 && va.length > 2 && itsjoin1.length > 0) { // app.unit:92, d_struct.act:468
			return (itsjoin1[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Join2") == 0 && va.length > 2 && itsjoin2.length > 0) { // app.unit:108, d_struct.act:468
			return (itsjoin2[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Table?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Field") == 0) { // app.unit:49, d_struct.act:723
			for(var st in itsfield) {
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
		if (va[0].compareTo("Of") == 0) { // app.unit:71, d_struct.act:723
			for(var st in itsof) {
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
		if (va[0].compareTo("Join1") == 0) { // app.unit:92, d_struct.act:723
			for(var st in itsjoin1) {
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
		if (va[0].compareTo("Join2") == 0) { // app.unit:108, d_struct.act:723
			for(var st in itsjoin2) {
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
		if (va[0].compareTo("Join1_table2") == 0) { // app.unit:104, d_struct.act:561
			for (KpJoin1 st in glob.dats.ap_join1) {
				if (st.k_table2p == me) {
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
		if (va[0].compareTo("Join2_table2") == 0) { // app.unit:119, d_struct.act:561
			for (KpJoin2 st in glob.dats.ap_join2) {
				if (st.k_table2p == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:41, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Table," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpField extends Kp 
{
	int k_parentp = -1;
	int k_typep = -1;
	List <KpAttrs> itsattrs = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Field";
		line_no = lno;
		flags = flag;
		me = act.ap_field.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Field";
		tok = getw(ln,tok[0]);
		names["type"] = tok[1];
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["dt"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getw(ln,tok[0]);
		names["use"] = tok[1];
		k_parentp = act.ap_table.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Field has no Table parent" );
			return false;
		}
		act.ap_table[ k_parentp ].itsfield.add( this );
		act.ap_table[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Field_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("type") == 0) { // app.unit:62, d_struct.act:656
			if (k_typep >= 0 && va.length > 1) {
				return( glob.dats.ap_type[ k_typep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_table[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Of_field") == 0 && va.length > 1) { // app.unit:82, d_struct.act:744
			for (var st in glob.dats.ap_of) {
				if (st.k_fieldp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Join1_field1") == 0 && va.length > 1) { // app.unit:103, d_struct.act:744
			for (var st in glob.dats.ap_join1) {
				if (st.k_field1p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Join2_field1") == 0 && va.length > 1) { // app.unit:118, d_struct.act:744
			for (var st in glob.dats.ap_join2) {
				if (st.k_field1p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Join1_field2") == 0 && va.length > 1) { // app.unit:105, d_struct.act:756
			for (var st in glob.dats.ap_join1) {
				if (st.k_field2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Join2_field2") == 0 && va.length > 1) { // app.unit:120, d_struct.act:756
			for (var st in glob.dats.ap_join2) {
				if (st.k_field2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Attrs") == 0 && va.length > 2) { // app.unit:68, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Attrs_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_attrs[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Field?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Attrs") == 0) { // app.unit:65, d_struct.act:723
			for(var st in itsattrs) {
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
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_table[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("type") == 0) {
			if (k_typep >= 0) {
				var st = glob.dats.ap_type[ k_typep ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Of_field") == 0) { // app.unit:82, d_struct.act:561
			for (KpOf st in glob.dats.ap_of) {
				if (st.k_fieldp == me) {
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
		if (va[0].compareTo("Join1_field1") == 0) { // app.unit:103, d_struct.act:561
			for (KpJoin1 st in glob.dats.ap_join1) {
				if (st.k_field1p == me) {
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
		if (va[0].compareTo("Join2_field1") == 0) { // app.unit:118, d_struct.act:561
			for (KpJoin2 st in glob.dats.ap_join2) {
				if (st.k_field1p == me) {
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
		if (va[0].compareTo("Join1_field2") == 0) { // app.unit:105, d_struct.act:584
			for (KpJoin1 st in glob.dats.ap_join1) {
				if (st.k_field2p == me) {
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
		if (va[0].compareTo("Join2_field2") == 0) { // app.unit:120, d_struct.act:584
			for (KpJoin2 st in glob.dats.ap_join2) {
				if (st.k_field2p == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:49, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Field," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpAttrs extends Kp 
{
	int k_parentp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Attrs";
		line_no = lno;
		flags = flag;
		me = act.ap_attrs.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Attrs";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		k_parentp = act.ap_field.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Attrs has no Field parent" );
			return false;
		}
		act.ap_field[ k_parentp ].itsattrs.add( this );
		act.ap_field[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Attrs_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:49, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_field[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Join2_attr2") == 0 && va.length > 1) { // app.unit:121, d_struct.act:756
			for (var st in glob.dats.ap_join2) {
				if (st.k_attr2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Attrs?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:49, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_field[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Join2_attr2") == 0) { // app.unit:121, d_struct.act:584
			for (KpJoin2 st in glob.dats.ap_join2) {
				if (st.k_attr2p == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:65, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Attrs," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpOf extends Kp 
{
	int k_parentp = -1;
	int k_fieldp = -1;
	int k_typep = -1;
	int k_attrp = -1;
	int k_fromp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Of";
		line_no = lno;
		flags = flag;
		me = act.ap_of.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Of";
		tok = getw(ln,tok[0]);
		names["field"] = tok[1];
		tok = getw(ln,tok[0]);
		names["attr"] = tok[1];
		tok = getw(ln,tok[0]);
		names["from"] = tok[1];
		tok = getw(ln,tok[0]);
		names["op"] = tok[1];
		tok = getws(ln,tok[0]);
		names["value"] = tok[1];
		k_parentp = act.ap_table.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Of has no Table parent" );
			return false;
		}
		act.ap_table[ k_parentp ].itsof.add( this );
		act.ap_table[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("field") == 0) { // app.unit:82, d_struct.act:656
			if (k_fieldp >= 0 && va.length > 1) {
				return( glob.dats.ap_field[ k_fieldp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("attr") == 0) { // app.unit:84, d_struct.act:666
			if (k_attrp >= 0 && va.length > 1) {
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("from") == 0) { // app.unit:85, d_struct.act:666
			if (k_fromp >= 0 && va.length > 1) {
				return( glob.dats.ap_attr[ k_fromp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_table[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Of?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_table[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("field") == 0) {
			if (k_fieldp >= 0) {
				var st = glob.dats.ap_field[ k_fieldp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("attr") == 0) {
			if (k_attrp >= 0) {
				var st = glob.dats.ap_attr[ k_attrp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("from") == 0) {
			if (k_fromp >= 0) {
				var st = glob.dats.ap_attr[ k_fromp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:71, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Of," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpJoin1 extends Kp 
{
	int k_parentp = -1;
	int k_field1p = -1;
	int k_table2p = -1;
	int k_field2p = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Join1";
		line_no = lno;
		flags = flag;
		me = act.ap_join1.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Join1";
		tok = getw(ln,tok[0]);
		names["field1"] = tok[1];
		tok = getw(ln,tok[0]);
		names["table2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["field2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getw(ln,tok[0]);
		names["use"] = tok[1];
		k_parentp = act.ap_table.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Join1 has no Table parent" );
			return false;
		}
		act.ap_table[ k_parentp ].itsjoin1.add( this );
		act.ap_table[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("field1") == 0) { // app.unit:103, d_struct.act:656
			if (k_field1p >= 0 && va.length > 1) {
				return( glob.dats.ap_field[ k_field1p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("table2") == 0) { // app.unit:104, d_struct.act:656
			if (k_table2p >= 0 && va.length > 1) {
				return( glob.dats.ap_table[ k_table2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("field2") == 0) { // app.unit:105, d_struct.act:666
			if (k_field2p >= 0 && va.length > 1) {
				return( glob.dats.ap_field[ k_field2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_table[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Join1?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_table[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("field1") == 0) {
			if (k_field1p >= 0) {
				var st = glob.dats.ap_field[ k_field1p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("table2") == 0) {
			if (k_table2p >= 0) {
				var st = glob.dats.ap_table[ k_table2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("field2") == 0) {
			if (k_field2p >= 0) {
				var st = glob.dats.ap_field[ k_field2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:92, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Join1," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpJoin2 extends Kp 
{
	int k_parentp = -1;
	int k_field1p = -1;
	int k_table2p = -1;
	int k_field2p = -1;
	int k_attr2p = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Join2";
		line_no = lno;
		flags = flag;
		me = act.ap_join2.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Join2";
		tok = getw(ln,tok[0]);
		names["field1"] = tok[1];
		tok = getw(ln,tok[0]);
		names["table2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["field2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["attr2"] = tok[1];
		k_parentp = act.ap_table.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Join2 has no Table parent" );
			return false;
		}
		act.ap_table[ k_parentp ].itsjoin2.add( this );
		act.ap_table[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("field1") == 0) { // app.unit:118, d_struct.act:656
			if (k_field1p >= 0 && va.length > 1) {
				return( glob.dats.ap_field[ k_field1p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("table2") == 0) { // app.unit:119, d_struct.act:656
			if (k_table2p >= 0 && va.length > 1) {
				return( glob.dats.ap_table[ k_table2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("field2") == 0) { // app.unit:120, d_struct.act:666
			if (k_field2p >= 0 && va.length > 1) {
				return( glob.dats.ap_field[ k_field2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("attr2") == 0) { // app.unit:121, d_struct.act:666
			if (k_attr2p >= 0 && va.length > 1) {
				return( glob.dats.ap_attrs[ k_attr2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_table[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Join2?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // app.unit:41, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_table[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("field1") == 0) {
			if (k_field1p >= 0) {
				var st = glob.dats.ap_field[ k_field1p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("table2") == 0) {
			if (k_table2p >= 0) {
				var st = glob.dats.ap_table[ k_table2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("field2") == 0) {
			if (k_field2p >= 0) {
				var st = glob.dats.ap_field[ k_field2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("attr2") == 0) {
			if (k_attr2p >= 0) {
				var st = glob.dats.ap_attrs[ k_attr2p ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // app.unit:108, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Join2," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpDomain extends Kp 
{
	List <KpModel> itsmodel = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Domain";
		line_no = lno;
		flags = flag;
		me = act.ap_domain.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Domain";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		act.index["Domain_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("Frame_domain") == 0 && va.length > 1) { // note.unit:27, d_struct.act:744
			for (var st in glob.dats.ap_frame) {
				if (st.k_domainp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Model") == 0 && va.length > 2) { // note.unit:13, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Model_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_model[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Domain?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Model") == 0) { // note.unit:10, d_struct.act:723
			for(var st in itsmodel) {
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
		if (va[0].compareTo("Frame_domain") == 0) { // note.unit:27, d_struct.act:561
			for (KpFrame st in glob.dats.ap_frame) {
				if (st.k_domainp == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:2, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Domain," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpModel extends Kp 
{
	int k_parentp = -1;
	List <KpFrame> itsframe = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Model";
		line_no = lno;
		flags = flag;
		me = act.ap_model.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Model";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		k_parentp = act.ap_domain.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Model has no Domain parent" );
			return false;
		}
		act.ap_domain[ k_parentp ].itsmodel.add( this );
		act.ap_domain[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Model_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_domain[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("A_model") == 0 && va.length > 1) { // note.unit:43, d_struct.act:756
			for (var st in glob.dats.ap_a) {
				if (st.k_modelp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Frame") == 0 && va.length > 2) { // note.unit:23, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Frame_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_frame[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Model?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Frame") == 0) { // note.unit:18, d_struct.act:723
			for(var st in itsframe) {
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
		if (va[0].compareTo("parent") == 0) { // note.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_domain[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("A_model") == 0) { // note.unit:43, d_struct.act:584
			for (KpA st in glob.dats.ap_a) {
				if (st.k_modelp == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:10, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Model," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpFrame extends Kp 
{
	int k_parentp = -1;
	int k_domainp = -1;
	List <KpA> itsa = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Frame";
		line_no = lno;
		flags = flag;
		me = act.ap_frame.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Frame";
		tok = getw(ln,tok[0]);
		names["group"] = tok[1];
		tok = getsw(ln,tok[0]);
		names["domain"] = tok[1];
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		k_parentp = act.ap_model.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Frame has no Model parent" );
			return false;
		}
		act.ap_model[ k_parentp ].itsframe.add( this );
		act.ap_model[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Frame_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("domain") == 0) { // note.unit:27, d_struct.act:656
			if (k_domainp >= 0 && va.length > 1) {
				return( glob.dats.ap_domain[ k_domainp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:10, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_model[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Use_frame") == 0 && va.length > 1) { // note.unit:57, d_struct.act:756
			for (var st in glob.dats.ap_use) {
				if (st.k_framep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("A") == 0 && va.length > 2) { // note.unit:38, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_A_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_a[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Frame?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("A") == 0) { // note.unit:30, d_struct.act:723
			for(var st in itsa) {
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
		if (va[0].compareTo("parent") == 0) { // note.unit:10, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_model[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("domain") == 0) {
			if (k_domainp >= 0) {
				var st = glob.dats.ap_domain[ k_domainp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Use_frame") == 0) { // note.unit:57, d_struct.act:584
			for (KpUse st in glob.dats.ap_use) {
				if (st.k_framep == me) {
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
		if (va[0].compareTo("group") == 0 && va.length > 1 && k_parentp >= 0) { // note.unit:21, d_struct.act:181
			var pos = 0;
			var v = names[ "group" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_model[ k_parentp ];
				var isin = false;
				for(var st in pst.itsframe) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						break;
					}
					if (pos2 == pos) {
						if (va.length > 2) {
							return( st.do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, st) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("up") == 0 && pos > 0) {
				var pst = glob.dats.ap_model[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itsframe) {
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == pos && st.me != me) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (pos2 == (pos-1)) {
						isin = false;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_frame[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_frame[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("left") == 0 && pos > 0) {
				var pst = glob.dats.ap_model[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itsframe) {
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_frame[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_frame[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("right") == 0 && pos > 0) {
				var pst = glob.dats.ap_model[ k_parentp ];
				var isin = false;
				for(var st in pst.itsframe) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 <= pos) {
						break;
					}
					if (pos2 == (pos+1)) {
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
				}
				return(0);
			}
		}
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:18, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Frame," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpA extends Kp 
{
	int k_parentp = -1;
	int k_domainp = -1;
	int k_modelp = -1;
	List <KpUse> itsuse = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "A";
		line_no = lno;
		flags = flag;
		me = act.ap_a.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "A";
		tok = getsw(ln,tok[0]);
		names["model"] = tok[1];
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		k_parentp = act.ap_frame.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " A has no Frame parent" );
			return false;
		}
		act.ap_frame[ k_parentp ].itsa.add( this );
		act.ap_frame[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_A_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("model") == 0) { // note.unit:43, d_struct.act:666
			if (k_modelp >= 0 && va.length > 1) {
				return( glob.dats.ap_model[ k_modelp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:18, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_frame[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Use_a") == 0 && va.length > 1) { // note.unit:58, d_struct.act:756
			for (var st in glob.dats.ap_use) {
				if (st.k_ap == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Use") == 0 && va.length > 2 && itsuse.length > 0) { // note.unit:47, d_struct.act:468
			return (itsuse[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",A?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Use") == 0) { // note.unit:47, d_struct.act:723
			for(var st in itsuse) {
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
		if (va[0].compareTo("parent") == 0) { // note.unit:18, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_frame[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("model") == 0) {
			if (k_modelp >= 0) {
				var st = glob.dats.ap_model[ k_modelp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Use_a") == 0) { // note.unit:58, d_struct.act:584
			for (KpUse st in glob.dats.ap_use) {
				if (st.k_ap == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:30, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for A," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpUse extends Kp 
{
	int k_parentp = -1;
	int k_modelp = -1;
	int k_framep = -1;
	int k_ap = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Use";
		line_no = lno;
		flags = flag;
		me = act.ap_use.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Use";
		tok = getsw(ln,tok[0]);
		names["frame"] = tok[1];
		tok = getw(ln,tok[0]);
		names["a"] = tok[1];
		tok = getw(ln,tok[0]);
		names["pad"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		k_parentp = act.ap_a.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Use has no A parent" );
			return false;
		}
		act.ap_a[ k_parentp ].itsuse.add( this );
		act.ap_a[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("frame") == 0) { // note.unit:57, d_struct.act:666
			if (k_framep >= 0 && va.length > 1) {
				return( glob.dats.ap_frame[ k_framep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("a") == 0) { // note.unit:58, d_struct.act:666
			if (k_ap >= 0 && va.length > 1) {
				return( glob.dats.ap_a[ k_ap ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:30, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_a[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Use?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:30, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_a[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("frame") == 0) {
			if (k_framep >= 0) {
				var st = glob.dats.ap_frame[ k_framep ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("a") == 0) {
			if (k_ap >= 0) {
				var st = glob.dats.ap_a[ k_ap ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:47, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Use," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpCol extends Kp 
{
	int k_parentp = -1;
	int k_namep = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Col";
		line_no = lno;
		flags = flag;
		me = act.ap_col.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Col";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["index"] = tok[1];
		tok = getw(ln,tok[0]);
		names["group"] = tok[1];
		tok = getw(ln,tok[0]);
		names["file"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		k_parentp = act.ap_grid.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Col has no Grid parent" );
			return false;
		}
		act.ap_grid[ k_parentp ].itscol.add( this );
		act.ap_grid[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Col_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("name") == 0) { // note.unit:71, d_struct.act:656
			if (k_namep >= 0 && va.length > 1) {
				return( glob.dats.ap_grid[ k_namep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:74, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_grid[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Col?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:74, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_grid[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("name") == 0) {
			if (k_namep >= 0) {
				var st = glob.dats.ap_grid[ k_namep ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("index") == 0 && va.length > 1 && k_parentp >= 0) { // note.unit:66, d_struct.act:181
			var pos = 0;
			var v = names[ "index" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				for(var st in pst.itscol) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "index" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						break;
					}
					if (pos2 == pos) {
						if (va.length > 2) {
							return( st.do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, st) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("up") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itscol) {
					var pos2 = 0;
					var v2 = st.names[ "index" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == pos && st.me != me) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (pos2 == (pos-1)) {
						isin = false;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_col[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_col[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("left") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itscol) {
					var pos2 = 0;
					var v2 = st.names[ "index" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_col[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_col[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("right") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				for(var st in pst.itscol) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "index" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 <= pos) {
						break;
					}
					if (pos2 == (pos+1)) {
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
				}
				return(0);
			}
		}
		if (va[0].compareTo("group") == 0 && va.length > 1 && k_parentp >= 0) { // note.unit:67, d_struct.act:181
			var pos = 0;
			var v = names[ "group" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				for(var st in pst.itscol) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						break;
					}
					if (pos2 == pos) {
						if (va.length > 2) {
							return( st.do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, st) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("up") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itscol) {
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == pos && st.me != me) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (pos2 == (pos-1)) {
						isin = false;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_col[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_col[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("left") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itscol) {
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_col[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_col[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("right") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ k_parentp ];
				var isin = false;
				for(var st in pst.itscol) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "group" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 <= pos) {
						break;
					}
					if (pos2 == (pos+1)) {
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
				}
				return(0);
			}
		}
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:62, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Col," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpGrid extends Kp 
{
	int k_namep = -1;
	List <KpCol> itscol = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Grid";
		line_no = lno;
		flags = flag;
		me = act.ap_grid.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Grid";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["file"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		act.index["Grid_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("name") == 0) { // note.unit:81, d_struct.act:656
			if (k_namep >= 0 && va.length > 1) {
				return( glob.dats.ap_grid[ k_namep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("Col_name") == 0 && va.length > 1) { // note.unit:71, d_struct.act:744
			for (var st in glob.dats.ap_col) {
				if (st.k_namep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Grid_name") == 0 && va.length > 1) { // note.unit:81, d_struct.act:744
			for (var st in glob.dats.ap_grid) {
				if (st.k_namep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Col") == 0 && va.length > 2) { // note.unit:65, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Col_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_col[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Grid?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Col") == 0) { // note.unit:62, d_struct.act:723
			for(var st in itscol) {
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
		if (va[0].compareTo("name") == 0) {
			if (k_namep >= 0) {
				var st = glob.dats.ap_grid[ k_namep ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Col_name") == 0) { // note.unit:71, d_struct.act:561
			for (KpCol st in glob.dats.ap_col) {
				if (st.k_namep == me) {
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
		if (va[0].compareTo("Grid_name") == 0) { // note.unit:81, d_struct.act:561
			for (KpGrid st in glob.dats.ap_grid) {
				if (st.k_namep == me) {
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:74, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Grid," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpConcept extends Kp 
{
	List <KpTopic> itstopic = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Concept";
		line_no = lno;
		flags = flag;
		me = act.ap_concept.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Concept";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("Topic") == 0 && va.length > 2 && itstopic.length > 0) { // note.unit:91, d_struct.act:468
			return (itstopic[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Concept?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Topic") == 0) { // note.unit:91, d_struct.act:723
			for(var st in itstopic) {
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:85, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Concept," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpTopic extends Kp 
{
	int k_parentp = -1;
	List <KpT> itst = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Topic";
		line_no = lno;
		flags = flag;
		me = act.ap_topic.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Topic";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["level"] = tok[1];
		tok = getw(ln,tok[0]);
		names["tag"] = tok[1];
		tok = getws(ln,tok[0]);
		names["desc"] = tok[1];
		k_parentp = act.ap_concept.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Topic has no Concept parent" );
			return false;
		}
		act.ap_concept[ k_parentp ].itstopic.add( this );
		act.ap_concept[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:85, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_concept[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("T") == 0 && va.length > 2 && itst.length > 0) { // note.unit:100, d_struct.act:468
			return (itst[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Topic?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("T") == 0) { // note.unit:100, d_struct.act:723
			for(var st in itst) {
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
		if (va[0].compareTo("parent") == 0) { // note.unit:85, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_concept[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("level") == 0 && va.length > 1 && k_parentp >= 0) { // note.unit:95, d_struct.act:181
			var pos = 0;
			var v = names[ "level" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_concept[ k_parentp ];
				var isin = false;
				for(var st in pst.itstopic) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "level" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						break;
					}
					if (pos2 == pos) {
						if (va.length > 2) {
							return( st.do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, st) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("up") == 0 && pos > 0) {
				var pst = glob.dats.ap_concept[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itstopic) {
					var pos2 = 0;
					var v2 = st.names[ "level" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == pos && st.me != me) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (pos2 == (pos-1)) {
						isin = false;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_topic[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_topic[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("left") == 0 && pos > 0) {
				var pst = glob.dats.ap_concept[ k_parentp ];
				var isin = false;
				var prev = 0;
				for(var st in pst.itstopic) {
					var pos2 = 0;
					var v2 = st.names[ "level" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 == (pos-1)) {
						prev = st.me;
						isin = true;
						continue;
					}
					if (st.me == me && isin == true) {
						if (va.length > 2) {
							return( glob.dats.ap_topic[prev].do_its(glob, va.sublist(2), lno) );
						}
						return( go_act(glob, glob.dats.ap_topic[prev] ) );
					}
				}
				return(0);
			}
			if (va[1].compareTo("right") == 0 && pos > 0) {
				var pst = glob.dats.ap_concept[ k_parentp ];
				var isin = false;
				for(var st in pst.itstopic) {
					if (st.me == me) {
						isin = true;
						continue;
					}
					if (isin == false) {
						continue;
					}
					var pos2 = 0;
					var v2 = st.names[ "level" ];
					if(v2 != null) {
						pos2 = int.parse(v2);
					}
					if (pos2 == 0) {
						continue;
					}
					if (pos2 <= pos) {
						break;
					}
					if (pos2 == (pos+1)) {
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
				}
				return(0);
			}
		}
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:91, d_struct.act:163
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
		print("?No its " + va[0] + " cmd for Topic," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpT extends Kp 
{
	int k_parentp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "T";
		line_no = lno;
		flags = flag;
		me = act.ap_t.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "T";
		tok = getw(ln,tok[0]);
		names["file"] = tok[1];
		tok = getws(ln,tok[0]);
		names["desc"] = tok[1];
		k_parentp = act.ap_topic.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " T has no Topic parent" );
			return false;
		}
		act.ap_topic[ k_parentp ].itst.add( this );
		act.ap_topic[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:91, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_topic[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",T?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:91, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_topic[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:100, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for T," + line_no + "," + lno + "?");
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
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Actor";
		line_no = lno;
		flags = flag;
		me = act.ap_actor.length;
		tok = getw(ln,tok[0]);
		k_name = tok[1];
		tok = getw(ln,tok[0]);
		k_comp = tok[1];
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getws(ln,tok[0]);
		k_value = tok[1];
		act.index["Actor_" + k_name] = me;
		return true;
	}
}

class KpAll extends Kp 
{
	int k_parentp = -1;
	String k_what = "";
	String k_actor = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "All";
		line_no = lno;
		flags = flag;
		me = act.ap_all.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " All has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpDu extends Kp 
{
	int k_parentp = -1;
	String k_actor = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Du";
		line_no = lno;
		flags = flag;
		me = act.ap_du.length;
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Du has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpNew extends Kp 
{
	int k_parentp = -1;
	String k_where = "";
	String k_what = "";
	String k_line = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "New";
		line_no = lno;
		flags = flag;
		me = act.ap_new.length;
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getws(ln,tok[0]);
		k_line = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " New has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpRefs extends Kp 
{
	int k_parentp = -1;
	String k_where = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Refs";
		line_no = lno;
		flags = flag;
		me = act.ap_refs.length;
		tok = getw(ln,tok[0]);
		k_where = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Refs has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpVar extends Kp 
{
	int k_parentp = -1;
	String k_attr = "";
	String k_eq = "";
	String k_value = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Var";
		line_no = lno;
		flags = flag;
		me = act.ap_var.length;
		tok = getw(ln,tok[0]);
		k_attr = tok[1];
		tok = getw(ln,tok[0]);
		k_eq = tok[1];
		tok = getws(ln,tok[0]);
		k_value = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Var has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpIts extends Kp 
{
	int k_parentp = -1;
	String k_what = "";
	String k_actor = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Its";
		line_no = lno;
		flags = flag;
		me = act.ap_its.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Its has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpC extends Kp 
{
	int k_parentp = -1;
	String k_desc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "C";
		line_no = lno;
		flags = flag;
		me = act.ap_c.length;
		tok = getws(ln,tok[0]);
		k_desc = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " C has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpCs extends Kp 
{
	int k_parentp = -1;
	String k_desc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Cs";
		line_no = lno;
		flags = flag;
		me = act.ap_cs.length;
		tok = getws(ln,tok[0]);
		k_desc = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Cs has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpOut extends Kp 
{
	int k_parentp = -1;
	String k_what = "";
	String k_pad = "";
	String k_desc = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Out";
		line_no = lno;
		flags = flag;
		me = act.ap_out.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_pad = tok[1];
		tok = getws(ln,tok[0]);
		k_desc = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Out has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpIn extends Kp 
{
	int k_parentp = -1;
	String k_flag = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "In";
		line_no = lno;
		flags = flag;
		me = act.ap_in.length;
		tok = getw(ln,tok[0]);
		k_flag = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " In has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpBreak extends Kp 
{
	int k_parentp = -1;
	String k_what = "";
	String k_pad = "";
	String k_actor = "";
	String k_check = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Break";
		line_no = lno;
		flags = flag;
		me = act.ap_break.length;
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_pad = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getw(ln,tok[0]);
		k_check = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Break has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpAdd extends Kp 
{
	int k_parentp = -1;
	String k_path = "";
	String k_data = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Add";
		line_no = lno;
		flags = flag;
		me = act.ap_add.length;
		tok = getw(ln,tok[0]);
		k_path = tok[1];
		tok = getws(ln,tok[0]);
		k_data = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Add has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpThis extends Kp 
{
	int k_parentp = -1;
	String k_path = "";
	String k_actor = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "This";
		line_no = lno;
		flags = flag;
		me = act.ap_this.length;
		tok = getw(ln,tok[0]);
		k_path = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " This has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpReplace extends Kp 
{
	int k_parentp = -1;
	String k_path = "";
	String k_pad = "";
	String k_with = "";
	String k_pad2 = "";
	String k_match = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Replace";
		line_no = lno;
		flags = flag;
		me = act.ap_replace.length;
		tok = getw(ln,tok[0]);
		k_path = tok[1];
		tok = getw(ln,tok[0]);
		k_pad = tok[1];
		tok = getw(ln,tok[0]);
		k_with = tok[1];
		tok = getw(ln,tok[0]);
		k_pad2 = tok[1];
		tok = getws(ln,tok[0]);
		k_match = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Replace has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpComp extends Kp 
{
	int k_parentp = -1;
	List <KpElement> itselement = [];
	List <KpRef> itsref = [];
	List <KpRef2> itsref2 = [];
	List <KpRef3> itsref3 = [];
	List <KpRefq> itsrefq = [];
	List <KpRefu> itsrefu = [];
	List <KpJoin> itsjoin = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Comp";
		line_no = lno;
		flags = flag;
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:16, d_struct.act:656
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("Comp_parent") == 0 && va.length > 1) { // gen.unit:16, d_struct.act:744
			for (var st in glob.dats.ap_comp) {
				if (st.k_parentp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref_comp") == 0 && va.length > 1) { // gen.unit:65, d_struct.act:744
			for (var st in glob.dats.ap_ref) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_comp") == 0 && va.length > 1) { // gen.unit:83, d_struct.act:744
			for (var st in glob.dats.ap_ref2) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_comp") == 0 && va.length > 1) { // gen.unit:104, d_struct.act:744
			for (var st in glob.dats.ap_ref3) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_comp_ref") == 0 && va.length > 1) { // gen.unit:105, d_struct.act:744
			for (var st in glob.dats.ap_ref3) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_comp") == 0 && va.length > 1) { // gen.unit:126, d_struct.act:744
			for (var st in glob.dats.ap_refq) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_comp_ref") == 0 && va.length > 1) { // gen.unit:127, d_struct.act:744
			for (var st in glob.dats.ap_refq) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refu_comp") == 0 && va.length > 1) { // gen.unit:147, d_struct.act:744
			for (var st in glob.dats.ap_refu) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refu_comp_ref") == 0 && va.length > 1) { // gen.unit:148, d_struct.act:744
			for (var st in glob.dats.ap_refu) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Element") == 0 && va.length > 2) { // gen.unit:24, d_struct.act:456
			var en = glob.dats.index[me.toString() + "_Element_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_element[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		if (va[0].compareTo("Ref") == 0 && va.length > 2 && itsref.length > 0) { // gen.unit:50, d_struct.act:468
			return (itsref[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Ref2") == 0 && va.length > 2 && itsref2.length > 0) { // gen.unit:68, d_struct.act:468
			return (itsref2[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Ref3") == 0 && va.length > 2 && itsref3.length > 0) { // gen.unit:87, d_struct.act:468
			return (itsref3[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Refq") == 0 && va.length > 2 && itsrefq.length > 0) { // gen.unit:109, d_struct.act:468
			return (itsrefq[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Refu") == 0 && va.length > 2 && itsrefu.length > 0) { // gen.unit:130, d_struct.act:468
			return (itsrefu[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Join") == 0 && va.length > 2 && itsjoin.length > 0) { // gen.unit:151, d_struct.act:468
			return (itsjoin[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Element") == 0) { // gen.unit:19, d_struct.act:723
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
		if (va[0].compareTo("Ref") == 0) { // gen.unit:50, d_struct.act:723
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
		if (va[0].compareTo("Ref2") == 0) { // gen.unit:68, d_struct.act:723
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
		if (va[0].compareTo("Ref3") == 0) { // gen.unit:87, d_struct.act:723
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
		if (va[0].compareTo("Refq") == 0) { // gen.unit:109, d_struct.act:723
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
		if (va[0].compareTo("Refu") == 0) { // gen.unit:130, d_struct.act:723
			for(var st in itsrefu) {
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
		if (va[0].compareTo("Join") == 0) { // gen.unit:151, d_struct.act:723
			for(var st in itsjoin) {
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
		if (va[0].compareTo("Comp_parent") == 0) { // gen.unit:16, d_struct.act:561
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
		if (va[0].compareTo("Ref_comp") == 0) { // gen.unit:65, d_struct.act:561
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
		if (va[0].compareTo("Ref2_comp") == 0) { // gen.unit:83, d_struct.act:561
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
		if (va[0].compareTo("Ref3_comp") == 0) { // gen.unit:104, d_struct.act:561
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
		if (va[0].compareTo("Ref3_comp_ref") == 0) { // gen.unit:105, d_struct.act:561
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
		if (va[0].compareTo("Refq_comp") == 0) { // gen.unit:126, d_struct.act:561
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
		if (va[0].compareTo("Refq_comp_ref") == 0) { // gen.unit:127, d_struct.act:561
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
		if (va[0].compareTo("Refu_comp") == 0) { // gen.unit:147, d_struct.act:561
			for (KpRefu st in glob.dats.ap_refu) {
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
		if (va[0].compareTo("Refu_comp_ref") == 0) { // gen.unit:148, d_struct.act:561
			for (KpRefu st in glob.dats.ap_refu) {
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:2, d_struct.act:163
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
	int k_parentp = -1;
	List <KpOpt> itsopt = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Element";
		line_no = lno;
		flags = flag;
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
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Element has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itselement.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Element_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Ref_element") == 0 && va.length > 1) { // gen.unit:64, d_struct.act:744
			for (var st in glob.dats.ap_ref) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_element") == 0 && va.length > 1) { // gen.unit:82, d_struct.act:744
			for (var st in glob.dats.ap_ref2) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_element2") == 0 && va.length > 1) { // gen.unit:84, d_struct.act:744
			for (var st in glob.dats.ap_ref2) {
				if (st.k_element2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_element") == 0 && va.length > 1) { // gen.unit:103, d_struct.act:744
			for (var st in glob.dats.ap_ref3) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_element2") == 0 && va.length > 1) { // gen.unit:106, d_struct.act:744
			for (var st in glob.dats.ap_ref3) {
				if (st.k_element2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_element") == 0 && va.length > 1) { // gen.unit:125, d_struct.act:744
			for (var st in glob.dats.ap_refq) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refu_element") == 0 && va.length > 1) { // gen.unit:146, d_struct.act:744
			for (var st in glob.dats.ap_refu) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Opt") == 0 && va.length > 2) { // gen.unit:45, d_struct.act:456
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
		if (va[0].compareTo("Opt") == 0) { // gen.unit:39, d_struct.act:723
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Ref_element") == 0) { // gen.unit:64, d_struct.act:561
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
		if (va[0].compareTo("Ref2_element") == 0) { // gen.unit:82, d_struct.act:561
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
		if (va[0].compareTo("Ref2_element2") == 0) { // gen.unit:84, d_struct.act:561
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
		if (va[0].compareTo("Ref3_element") == 0) { // gen.unit:103, d_struct.act:561
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
		if (va[0].compareTo("Ref3_element2") == 0) { // gen.unit:106, d_struct.act:561
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
		if (va[0].compareTo("Refq_element") == 0) { // gen.unit:125, d_struct.act:561
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
		if (va[0].compareTo("Refu_element") == 0) { // gen.unit:146, d_struct.act:561
			for (KpRefu st in glob.dats.ap_refu) {
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:19, d_struct.act:163
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
	int k_parentp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Opt";
		line_no = lno;
		flags = flag;
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
		k_parentp = act.ap_element.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Opt has no Element parent" );
			return false;
		}
		act.ap_element[ k_parentp ].itsopt.add( this );
		act.ap_element[ k_parentp ].childs.add( this );
		var s = k_parentp.toString() + "_Opt_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:19, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Opt?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:19, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_element[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:39, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Opt," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRef extends Kp 
{
	int k_parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Ref";
		line_no = lno;
		flags = flag;
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
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Ref has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itsref.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:64, d_struct.act:656
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:65, d_struct.act:656
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:50, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRef2 extends Kp 
{
	int k_parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_element2p = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Ref2";
		line_no = lno;
		flags = flag;
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
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Ref2 has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itsref2.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:82, d_struct.act:656
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:83, d_struct.act:656
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("element2") == 0) { // gen.unit:84, d_struct.act:656
			if (k_element2p >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref2?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:68, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref2," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRef3 extends Kp 
{
	int k_parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_element2p = -1;
	int k_comp_refp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Ref3";
		line_no = lno;
		flags = flag;
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
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Ref3 has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itsref3.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:103, d_struct.act:656
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:104, d_struct.act:656
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:105, d_struct.act:656
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("element2") == 0) { // gen.unit:106, d_struct.act:656
			if (k_element2p >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref3?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:87, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Ref3," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRefq extends Kp 
{
	int k_parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_comp_refp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Refq";
		line_no = lno;
		flags = flag;
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
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Refq has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itsrefq.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:125, d_struct.act:656
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:126, d_struct.act:656
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:127, d_struct.act:656
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Refq?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:109, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Refq," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpRefu extends Kp 
{
	int k_parentp = -1;
	int k_elementp = -1;
	int k_compp = -1;
	int k_comp_refp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Refu";
		line_no = lno;
		flags = flag;
		me = act.ap_refu.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Refu";
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
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Refu has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itsrefu.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("element") == 0) { // gen.unit:146, d_struct.act:656
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:147, d_struct.act:656
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:148, d_struct.act:656
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Refu?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:130, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Refu," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpJoin extends Kp 
{
	int k_parentp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Join";
		line_no = lno;
		flags = flag;
		me = act.ap_join.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Join";
		tok = getw(ln,tok[0]);
		names["element"] = tok[1];
		tok = getw(ln,tok[0]);
		names["dir"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp"] = tok[1];
		tok = getw(ln,tok[0]);
		names["using"] = tok[1];
		tok = getw(ln,tok[0]);
		names["element2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["comp2"] = tok[1];
		tok = getw(ln,tok[0]);
		names["element3"] = tok[1];
		k_parentp = act.ap_comp.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " Join has no Comp parent" );
			return false;
		}
		act.ap_comp[ k_parentp ].itsjoin.add( this );
		act.ap_comp[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:551
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Join?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:536
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:151, d_struct.act:163
			return(0);
		}
		print("?No its " + va[0] + " cmd for Join," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

