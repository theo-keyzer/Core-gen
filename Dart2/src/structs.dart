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

class KpDomain extends Kp 
{
	List <KpModel> itsmodel = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Domain";
		line_no = lno;
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
		if (va[0].compareTo("Frame_domain") == 0 && va.length > 1) { // note.unit:27, d_struct.act:747
			for (var st in glob.dats.ap_frame) {
				if (st.k_domainp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Model") == 0 && va.length > 2) { // note.unit:13, d_struct.act:452
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
		if (va[0].compareTo("Model") == 0) { // note.unit:10, d_struct.act:726
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
		if (va[0].compareTo("Frame_domain") == 0) { // note.unit:27, d_struct.act:557
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:2, d_struct.act:159
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
	int parentp = -1;
	List <KpFrame> itsframe = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Model";
		line_no = lno;
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
		parentp = act.ap_domain.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Model has no Domain parent" );
			return false;
		}
		act.ap_domain[ parentp ].itsmodel.add( this );
		act.ap_domain[ parentp ].childs.add( this );
		var s = parentp.toString() + "_Model_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:2, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_domain[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Frame") == 0 && va.length > 2) { // note.unit:23, d_struct.act:452
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
		if (va[0].compareTo("Frame") == 0) { // note.unit:18, d_struct.act:726
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
		if (va[0].compareTo("parent") == 0) { // note.unit:2, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_domain[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("A_model") == 0) { // note.unit:38, d_struct.act:628
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:10, d_struct.act:159
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
	int parentp = -1;
	int k_domainp = -1;
	List <KpA> itsa = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Frame";
		line_no = lno;
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
		parentp = act.ap_model.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Frame has no Model parent" );
			return false;
		}
		act.ap_model[ parentp ].itsframe.add( this );
		act.ap_model[ parentp ].childs.add( this );
		var s = parentp.toString() + "_Frame_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("domain") == 0) { // note.unit:27, d_struct.act:652
			if (k_domainp >= 0 && va.length > 1) {
				return( glob.dats.ap_domain[ k_domainp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:10, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_model[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("A") == 0 && va.length > 2) { // note.unit:34, d_struct.act:452
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
		if (va[0].compareTo("A") == 0) { // note.unit:30, d_struct.act:726
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
		if (va[0].compareTo("parent") == 0) { // note.unit:10, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_model[ parentp ];
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
		if (va[0].compareTo("Use_frame") == 0) { // note.unit:49, d_struct.act:628
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
		if (va[0].compareTo("group") == 0 && va.length > 1 && parentp >= 0) { // note.unit:21, d_struct.act:177
			var pos = 0;
			var v = names[ "group" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_model[ parentp ];
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
				var pst = glob.dats.ap_model[ parentp ];
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
				var pst = glob.dats.ap_model[ parentp ];
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
				var pst = glob.dats.ap_model[ parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:18, d_struct.act:159
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
	int parentp = -1;
	int k_modelp = -1;
	List <KpUse> itsuse = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "A";
		line_no = lno;
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
		parentp = act.ap_frame.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " A has no Frame parent" );
			return false;
		}
		act.ap_frame[ parentp ].itsa.add( this );
		act.ap_frame[ parentp ].childs.add( this );
		var s = parentp.toString() + "_A_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:18, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_frame[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Use_a") == 0 && va.length > 1) { // note.unit:50, d_struct.act:759
			for (var st in glob.dats.ap_use) {
				if (st.k_ap == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Use") == 0 && va.length > 2 && itsuse.length > 0) { // note.unit:41, d_struct.act:464
			return (itsuse[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",A?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Use") == 0) { // note.unit:41, d_struct.act:726
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
		if (va[0].compareTo("parent") == 0) { // note.unit:18, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_frame[ parentp ];
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
		if (va[0].compareTo("Use_a") == 0) { // note.unit:50, d_struct.act:580
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:30, d_struct.act:159
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
	int parentp = -1;
	int k_framep = -1;
	int k_ap = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Use";
		line_no = lno;
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
		parentp = act.ap_a.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Use has no A parent" );
			return false;
		}
		act.ap_a[ parentp ].itsuse.add( this );
		act.ap_a[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("a") == 0) { // note.unit:50, d_struct.act:662
			if (k_ap >= 0 && va.length > 1) {
				return( glob.dats.ap_a[ k_ap ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:30, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_a[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Use?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:30, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_a[ parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:41, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for Use," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpGrid extends Kp 
{
	List <KpCol> itscol = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Grid";
		line_no = lno;
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
		if (va[0].compareTo("Col_name") == 0 && va.length > 1) { // note.unit:70, d_struct.act:747
			for (var st in glob.dats.ap_col) {
				if (st.k_namep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("R_name") == 0 && va.length > 1) { // note.unit:80, d_struct.act:747
			for (var st in glob.dats.ap_r) {
				if (st.k_namep == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Col") == 0 && va.length > 2) { // note.unit:64, d_struct.act:452
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
		if (va[0].compareTo("Col") == 0) { // note.unit:61, d_struct.act:726
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
		if (va[0].compareTo("Col_name") == 0) { // note.unit:70, d_struct.act:557
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
		if (va[0].compareTo("R_name") == 0) { // note.unit:80, d_struct.act:557
			for (KpR st in glob.dats.ap_r) {
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:53, d_struct.act:159
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

class KpCol extends Kp 
{
	int parentp = -1;
	int k_namep = -1;
	List <KpR> itsr = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Col";
		line_no = lno;
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
		parentp = act.ap_grid.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Col has no Grid parent" );
			return false;
		}
		act.ap_grid[ parentp ].itscol.add( this );
		act.ap_grid[ parentp ].childs.add( this );
		var s = parentp.toString() + "_Col_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("name") == 0) { // note.unit:70, d_struct.act:652
			if (k_namep >= 0 && va.length > 1) {
				return( glob.dats.ap_grid[ k_namep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:53, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_grid[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("R") == 0 && va.length > 2) { // note.unit:76, d_struct.act:452
			var en = glob.dats.index[me.toString() + "_R_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_r[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Col?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("R") == 0) { // note.unit:73, d_struct.act:726
			for(var st in itsr) {
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
		if (va[0].compareTo("parent") == 0) { // note.unit:53, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_grid[ parentp ];
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
		if (va[0].compareTo("index") == 0 && va.length > 1 && parentp >= 0) { // note.unit:65, d_struct.act:177
			var pos = 0;
			var v = names[ "index" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ parentp ];
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
				var pst = glob.dats.ap_grid[ parentp ];
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
				var pst = glob.dats.ap_grid[ parentp ];
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
				var pst = glob.dats.ap_grid[ parentp ];
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
		if (va[0].compareTo("group") == 0 && va.length > 1 && parentp >= 0) { // note.unit:66, d_struct.act:177
			var pos = 0;
			var v = names[ "group" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_grid[ parentp ];
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
				var pst = glob.dats.ap_grid[ parentp ];
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
				var pst = glob.dats.ap_grid[ parentp ];
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
				var pst = glob.dats.ap_grid[ parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:61, d_struct.act:159
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
		print("?No its " + va[0] + " cmd for Col," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpR extends Kp 
{
	int parentp = -1;
	int k_namep = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "R";
		line_no = lno;
		me = act.ap_r.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "R";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		tok = getw(ln,tok[0]);
		names["file"] = tok[1];
		tok = getws(ln,tok[0]);
		names["info"] = tok[1];
		parentp = act.ap_col.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " R has no Col parent" );
			return false;
		}
		act.ap_col[ parentp ].itsr.add( this );
		act.ap_col[ parentp ].childs.add( this );
		var s = parentp.toString() + "_R_" + get_name(names, "name");
		act.index[s] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("name") == 0) { // note.unit:80, d_struct.act:652
			if (k_namep >= 0 && va.length > 1) {
				return( glob.dats.ap_grid[ k_namep ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // note.unit:61, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_col[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",R?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:61, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_col[ parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:73, d_struct.act:159
			return(0);
		}
		print("?No its " + va[0] + " cmd for R," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpConcept extends Kp 
{
	List <KpTopic> itstopic = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Concept";
		line_no = lno;
		me = act.ap_concept.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Concept";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("Topic") == 0 && va.length > 2 && itstopic.length > 0) { // note.unit:89, d_struct.act:464
			return (itstopic[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Concept?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("Topic") == 0) { // note.unit:89, d_struct.act:726
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:83, d_struct.act:159
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
	int parentp = -1;
	List <KpT> itst = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Topic";
		line_no = lno;
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
		parentp = act.ap_concept.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " Topic has no Concept parent" );
			return false;
		}
		act.ap_concept[ parentp ].itstopic.add( this );
		act.ap_concept[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:83, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_concept[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("T") == 0 && va.length > 2 && itst.length > 0) { // note.unit:98, d_struct.act:464
			return (itst[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Topic?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("T") == 0) { // note.unit:98, d_struct.act:726
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
		if (va[0].compareTo("parent") == 0) { // note.unit:83, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_concept[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("level") == 0 && va.length > 1 && parentp >= 0) { // note.unit:93, d_struct.act:177
			var pos = 0;
			var v = names[ "level" ];
			if( v != null) {
				pos = int.parse(v);
			}
			if (va[1].compareTo("down") == 0 && pos > 0) {
				var pst = glob.dats.ap_concept[ parentp ];
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
				var pst = glob.dats.ap_concept[ parentp ];
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
				var pst = glob.dats.ap_concept[ parentp ];
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
				var pst = glob.dats.ap_concept[ parentp ];
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
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:89, d_struct.act:159
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
	int parentp = -1;

	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "T";
		line_no = lno;
		me = act.ap_t.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "T";
		tok = getw(ln,tok[0]);
		names["file"] = tok[1];
		tok = getws(ln,tok[0]);
		names["desc"] = tok[1];
		parentp = act.ap_topic.length-1;
		names["k_parent"] = parentp.toString();
		if (parentp < 0 ) { 
			print( lno + " T has no Topic parent" );
			return false;
		}
		act.ap_topic[ parentp ].itst.add( this );
		act.ap_topic[ parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:89, d_struct.act:547
			if (parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_topic[ parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",T?"] );
	}

	int do_its(glob, va, lno) {
		if (va[0].compareTo("parent") == 0) { // note.unit:89, d_struct.act:532
			if (parentp >= 0) {
				var st = glob.dats.ap_topic[ parentp ];
				if (va.length > 1) {
					return( st.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // note.unit:98, d_struct.act:159
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

class KpAdd extends Kp 
{
	int parentp = -1;
	String k_pocket = "";
	String k_what = "";
	String k_item = "";
	String k_data = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Add";
		line_no = lno;
		me = act.ap_add.length;
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_item = tok[1];
		tok = getws(ln,tok[0]);
		k_data = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Add has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpAppend extends Kp 
{
	int parentp = -1;
	String k_path = "";
	String k_data = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Append";
		line_no = lno;
		me = act.ap_append.length;
		tok = getw(ln,tok[0]);
		k_path = tok[1];
		tok = getws(ln,tok[0]);
		k_data = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Append has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpThis extends Kp 
{
	int parentp = -1;
	String k_path = "";
	String k_actor = "";
	String k_args = "";
	int k_actorp = -1;
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "This";
		line_no = lno;
		me = act.ap_this.length;
		tok = getw(ln,tok[0]);
		k_path = tok[1];
		tok = getw(ln,tok[0]);
		k_actor = tok[1];
		tok = getws(ln,tok[0]);
		k_args = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " This has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpClear extends Kp 
{
	int parentp = -1;
	String k_pocket = "";
	String k_what = "";
	String k_item = "";
	String k_data = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Clear";
		line_no = lno;
		me = act.ap_clear.length;
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_item = tok[1];
		tok = getws(ln,tok[0]);
		k_data = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Clear has no Actor parent") ;
			return false;
		}
		act.ap_actor[ parentp ].childs.add( this );
		return true;
	}
}

class KpCheck extends Kp 
{
	int parentp = -1;
	String k_pocket = "";
	String k_what = "";
	String k_item = "";
	String k_data = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno) {
		var tok = [pos, ''];
		comp = "Check";
		line_no = lno;
		me = act.ap_check.length;
		tok = getw(ln,tok[0]);
		k_pocket = tok[1];
		tok = getw(ln,tok[0]);
		k_what = tok[1];
		tok = getw(ln,tok[0]);
		k_item = tok[1];
		tok = getws(ln,tok[0]);
		k_data = tok[1];
		parentp = act.ap_actor.length-1;
		if (parentp < 0 ) { 
			print(lno + " Check has no Actor parent") ;
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

