part of gen;

class Kp
{
	int me = -1;
	String comp = "Kp";
	String line_no = "";
	List <String> flags = [];
	Map names = new Map();
	int kp_doc_from = -1;
	Future<int> do_its(glob, va, lno) async  {
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
		kp_doc_from = act.kp_doc.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "Concept";
		tok = getw(ln,tok[0]);
		names["name"] = tok[1];
		act.index["Concept_" + get_name(names, "name") ] = me;
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("See_concept") == 0 && va.length > 1) { // concept.unit:29, d_struct.act:756
			for (var st in glob.dats.ap_see) {
				if (st.k_conceptp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Topic") == 0 && va.length > 2 && itstopic.length > 0) { // concept.unit:8, d_struct.act:480
			return (itstopic[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Concept?"] );
	}

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("Topic") == 0) { // concept.unit:8, d_struct.act:735
			for(var st in itstopic) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("See_concept") == 0) { // concept.unit:29, d_struct.act:573
			for (KpSee st in glob.dats.ap_see) {
				if (st.k_conceptp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // concept.unit:2, d_struct.act:167
			for (var st in childs) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
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
	List <KpSee> itssee = [];
	List <Kp> childs = [];

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Topic";
		line_no = lno;
		flags = flag;
		me = act.ap_topic.length;
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("parent") == 0) { // concept.unit:2, d_struct.act:563
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_concept[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("T") == 0 && va.length > 2 && itst.length > 0) { // concept.unit:17, d_struct.act:480
			return (itst[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("See") == 0 && va.length > 2 && itssee.length > 0) { // concept.unit:24, d_struct.act:480
			return (itssee[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Topic?"] );
	}

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("T") == 0) { // concept.unit:17, d_struct.act:735
			for(var st in itst) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("See") == 0) { // concept.unit:24, d_struct.act:735
			for(var st in itssee) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("parent") == 0) { // concept.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_concept[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("level") == 0 && va.length > 1 && k_parentp >= 0) { // concept.unit:12, d_struct.act:193
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
							return( await  st.do_its(glob, va.sublist(2), lno) );
						}
						return( await  go_act(glob, st) );
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
						return( await  go_act(glob, glob.dats.ap_topic[prev] ) );
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
						return( await  go_act(glob, glob.dats.ap_topic[prev] ) );
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
							var ret = await  st.do_its(glob, va.sublist(2), lno);
							if (ret != 0) {
								return(ret);
							}
							continue;
						}
						var ret = await  go_act(glob, st);
						if (ret != 0) {
							return(ret);
						}
					}
				}
				return(0);
			}
		}
		if ( va[0].compareTo("Child") == 0 ) { // concept.unit:8, d_struct.act:167
			for (var st in childs) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("parent") == 0) { // concept.unit:8, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // concept.unit:8, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_topic[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // concept.unit:17, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
			return(0);
		}
		print("?No its " + va[0] + " cmd for T," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

class KpSee extends Kp 
{
	int k_parentp = -1;
	int k_conceptp = -1;

	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "See";
		line_no = lno;
		flags = flag;
		me = act.ap_see.length;
		kp_doc_from = act.kp_doc.length;
		names["k_me"] = me.toString();
		names["k_parent"] = "-1";
		names["k_comp"] = "See";
		tok = getw(ln,tok[0]);
		names["concept"] = tok[1];
		k_parentp = act.ap_topic.length-1;
		names["k_parent"] = k_parentp.toString();
		if (k_parentp < 0 ) { 
			print( lno + " See has no Topic parent" );
			return false;
		}
		act.ap_topic[ k_parentp ].itssee.add( this );
		act.ap_topic[ k_parentp ].childs.add( this );
		return true;
	}

	List get_var(glob, va, lno) {
		if (va[0].compareTo("concept") == 0) { // concept.unit:29, d_struct.act:668
			if (k_conceptp >= 0 && va.length > 1) {
				return( glob.dats.ap_concept[ k_conceptp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // concept.unit:8, d_struct.act:563
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_topic[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",See?"] );
	}

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // concept.unit:8, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_topic[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("concept") == 0) {
			if (k_conceptp >= 0) {
				var st = glob.dats.ap_concept[ k_conceptp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // concept.unit:24, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
			return(0);
		}
		print("?No its " + va[0] + " cmd for See," + line_no + "," + lno + "?");
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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
		kp_doc_from = act.kp_doc.length;
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

class KpDbconn extends Kp 
{
	int k_parentp = -1;
	String k_host = "";
	String k_database = "";
	String k_username = "";
	String k_password = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Dbconn";
		line_no = lno;
		flags = flag;
		me = act.ap_dbconn.length;
		kp_doc_from = act.kp_doc.length;
		tok = getw(ln,tok[0]);
		k_host = tok[1];
		tok = getw(ln,tok[0]);
		k_database = tok[1];
		tok = getw(ln,tok[0]);
		k_username = tok[1];
		tok = getw(ln,tok[0]);
		k_password = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Dbconn has no Actor parent") ;
			return false;
		}
		act.ap_actor[ k_parentp ].childs.add( this );
		return true;
	}
}

class KpHttp extends Kp 
{
	int k_parentp = -1;
	String k_path = "";
	String k_data = "";
	String k_body = "";
	List <Kp> childs = [];
	bool load(act, ln, pos, lno, flag) {
		var tok = [pos, ''];
		comp = "Http";
		line_no = lno;
		flags = flag;
		me = act.ap_http.length;
		kp_doc_from = act.kp_doc.length;
		tok = getw(ln,tok[0]);
		k_path = tok[1];
		tok = getw(ln,tok[0]);
		k_data = tok[1];
		tok = getws(ln,tok[0]);
		k_body = tok[1];
		k_parentp = act.ap_actor.length-1;
		if (k_parentp < 0 ) { 
			print(lno + " Http has no Actor parent") ;
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:16, d_struct.act:668
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("Comp_parent") == 0 && va.length > 1) { // gen.unit:16, d_struct.act:756
			for (var st in glob.dats.ap_comp) {
				if (st.k_parentp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref_comp") == 0 && va.length > 1) { // gen.unit:65, d_struct.act:756
			for (var st in glob.dats.ap_ref) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_comp") == 0 && va.length > 1) { // gen.unit:83, d_struct.act:756
			for (var st in glob.dats.ap_ref2) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_comp") == 0 && va.length > 1) { // gen.unit:104, d_struct.act:756
			for (var st in glob.dats.ap_ref3) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_comp_ref") == 0 && va.length > 1) { // gen.unit:105, d_struct.act:756
			for (var st in glob.dats.ap_ref3) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_comp") == 0 && va.length > 1) { // gen.unit:126, d_struct.act:756
			for (var st in glob.dats.ap_refq) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_comp_ref") == 0 && va.length > 1) { // gen.unit:127, d_struct.act:756
			for (var st in glob.dats.ap_refq) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refu_comp") == 0 && va.length > 1) { // gen.unit:147, d_struct.act:756
			for (var st in glob.dats.ap_refu) {
				if (st.k_compp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refu_comp_ref") == 0 && va.length > 1) { // gen.unit:148, d_struct.act:756
			for (var st in glob.dats.ap_refu) {
				if (st.k_comp_refp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Element") == 0 && va.length > 2) { // gen.unit:24, d_struct.act:468
			var en = glob.dats.index[me.toString() + "_Element_" + va[1] ];
			if(en != null) {
				return (glob.dats.ap_element[en].get_var(glob, va.sublist(2), lno));
			}
			return( [false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?"] );
		}
		if (va[0].compareTo("Ref") == 0 && va.length > 2 && itsref.length > 0) { // gen.unit:50, d_struct.act:480
			return (itsref[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Ref2") == 0 && va.length > 2 && itsref2.length > 0) { // gen.unit:68, d_struct.act:480
			return (itsref2[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Ref3") == 0 && va.length > 2 && itsref3.length > 0) { // gen.unit:87, d_struct.act:480
			return (itsref3[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Refq") == 0 && va.length > 2 && itsrefq.length > 0) { // gen.unit:109, d_struct.act:480
			return (itsrefq[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Refu") == 0 && va.length > 2 && itsrefu.length > 0) { // gen.unit:130, d_struct.act:480
			return (itsrefu[0].get_var(glob, va.sublist(1), lno));
		}
		if (va[0].compareTo("Join") == 0 && va.length > 2 && itsjoin.length > 0) { // gen.unit:151, d_struct.act:480
			return (itsjoin[0].get_var(glob, va.sublist(1), lno));
		}
		var v = names[ va[0] ];
		if( v != null) {
			return( [true, v] );
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?"] );
	}

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("Element") == 0) { // gen.unit:19, d_struct.act:735
			for(var st in itselement) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref") == 0) { // gen.unit:50, d_struct.act:735
			for(var st in itsref) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref2") == 0) { // gen.unit:68, d_struct.act:735
			for(var st in itsref2) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref3") == 0) { // gen.unit:87, d_struct.act:735
			for(var st in itsref3) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refq") == 0) { // gen.unit:109, d_struct.act:735
			for(var st in itsrefq) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refu") == 0) { // gen.unit:130, d_struct.act:735
			for(var st in itsrefu) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("Join") == 0) { // gen.unit:151, d_struct.act:735
			for(var st in itsjoin) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
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
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Comp_parent") == 0) { // gen.unit:16, d_struct.act:573
			for (KpComp st in glob.dats.ap_comp) {
				if (st.k_parentp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref_comp") == 0) { // gen.unit:65, d_struct.act:573
			for (KpRef st in glob.dats.ap_ref) {
				if (st.k_compp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref2_comp") == 0) { // gen.unit:83, d_struct.act:573
			for (KpRef2 st in glob.dats.ap_ref2) {
				if (st.k_compp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref3_comp") == 0) { // gen.unit:104, d_struct.act:573
			for (KpRef3 st in glob.dats.ap_ref3) {
				if (st.k_compp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref3_comp_ref") == 0) { // gen.unit:105, d_struct.act:573
			for (KpRef3 st in glob.dats.ap_ref3) {
				if (st.k_comp_refp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refq_comp") == 0) { // gen.unit:126, d_struct.act:573
			for (KpRefq st in glob.dats.ap_refq) {
				if (st.k_compp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refq_comp_ref") == 0) { // gen.unit:127, d_struct.act:573
			for (KpRefq st in glob.dats.ap_refq) {
				if (st.k_comp_refp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refu_comp") == 0) { // gen.unit:147, d_struct.act:573
			for (KpRefu st in glob.dats.ap_refu) {
				if (st.k_compp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refu_comp_ref") == 0) { // gen.unit:148, d_struct.act:573
			for (KpRefu st in glob.dats.ap_refu) {
				if (st.k_comp_refp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:2, d_struct.act:167
			for (var st in childs) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
			if (k_parentp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va.sublist(1),lno) );
			}
		}
		if (va[0].compareTo("Ref_element") == 0 && va.length > 1) { // gen.unit:64, d_struct.act:756
			for (var st in glob.dats.ap_ref) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_element") == 0 && va.length > 1) { // gen.unit:82, d_struct.act:756
			for (var st in glob.dats.ap_ref2) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref2_element2") == 0 && va.length > 1) { // gen.unit:84, d_struct.act:756
			for (var st in glob.dats.ap_ref2) {
				if (st.k_element2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_element") == 0 && va.length > 1) { // gen.unit:103, d_struct.act:756
			for (var st in glob.dats.ap_ref3) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Ref3_element2") == 0 && va.length > 1) { // gen.unit:106, d_struct.act:756
			for (var st in glob.dats.ap_ref3) {
				if (st.k_element2p == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refq_element") == 0 && va.length > 1) { // gen.unit:125, d_struct.act:756
			for (var st in glob.dats.ap_refq) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Refu_element") == 0 && va.length > 1) { // gen.unit:146, d_struct.act:756
			for (var st in glob.dats.ap_refu) {
				if (st.k_elementp == me) {
					return (st.get_var(glob, va.sublist(1), lno) );
				}
			}
		}
		if (va[0].compareTo("Opt") == 0 && va.length > 2) { // gen.unit:45, d_struct.act:468
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("Opt") == 0) { // gen.unit:39, d_struct.act:735
			for(var st in itsopt) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("Ref_element") == 0) { // gen.unit:64, d_struct.act:573
			for (KpRef st in glob.dats.ap_ref) {
				if (st.k_elementp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref2_element") == 0) { // gen.unit:82, d_struct.act:573
			for (KpRef2 st in glob.dats.ap_ref2) {
				if (st.k_elementp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref2_element2") == 0) { // gen.unit:84, d_struct.act:573
			for (KpRef2 st in glob.dats.ap_ref2) {
				if (st.k_element2p == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref3_element") == 0) { // gen.unit:103, d_struct.act:573
			for (KpRef3 st in glob.dats.ap_ref3) {
				if (st.k_elementp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Ref3_element2") == 0) { // gen.unit:106, d_struct.act:573
			for (KpRef3 st in glob.dats.ap_ref3) {
				if (st.k_element2p == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refq_element") == 0) { // gen.unit:125, d_struct.act:573
			for (KpRefq st in glob.dats.ap_refq) {
				if (st.k_elementp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if (va[0].compareTo("Refu_element") == 0) { // gen.unit:146, d_struct.act:573
			for (KpRefu st in glob.dats.ap_refu) {
				if (st.k_elementp == me) {
					if (va.length > 1) {
						var ret = await  st.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = await  go_act(glob, st);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:19, d_struct.act:167
			for (var st in childs) {
				if (va.length > 1) {
					var ret = await  st.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = await  go_act(glob, st);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:19, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:19, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_element[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:39, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("element") == 0) { // gen.unit:64, d_struct.act:668
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:65, d_struct.act:668
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element") == 0) {
			if (k_elementp >= 0) {
				var st = glob.dats.ap_element[ k_elementp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp") == 0) {
			if (k_compp >= 0) {
				var st = glob.dats.ap_comp[ k_compp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:50, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("element") == 0) { // gen.unit:82, d_struct.act:668
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:83, d_struct.act:668
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("element2") == 0) { // gen.unit:84, d_struct.act:668
			if (k_element2p >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element") == 0) {
			if (k_elementp >= 0) {
				var st = glob.dats.ap_element[ k_elementp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp") == 0) {
			if (k_compp >= 0) {
				var st = glob.dats.ap_comp[ k_compp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element2") == 0) {
			if (k_element2p >= 0) {
				var st = glob.dats.ap_element[ k_element2p ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:68, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("element") == 0) { // gen.unit:103, d_struct.act:668
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:104, d_struct.act:668
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:105, d_struct.act:668
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("element2") == 0) { // gen.unit:106, d_struct.act:668
			if (k_element2p >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element") == 0) {
			if (k_elementp >= 0) {
				var st = glob.dats.ap_element[ k_elementp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp") == 0) {
			if (k_compp >= 0) {
				var st = glob.dats.ap_comp[ k_compp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp_ref") == 0) {
			if (k_comp_refp >= 0) {
				var st = glob.dats.ap_comp[ k_comp_refp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element2") == 0) {
			if (k_element2p >= 0) {
				var st = glob.dats.ap_element[ k_element2p ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:87, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("element") == 0) { // gen.unit:125, d_struct.act:668
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:126, d_struct.act:668
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:127, d_struct.act:668
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element") == 0) {
			if (k_elementp >= 0) {
				var st = glob.dats.ap_element[ k_elementp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp") == 0) {
			if (k_compp >= 0) {
				var st = glob.dats.ap_comp[ k_compp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp_ref") == 0) {
			if (k_comp_refp >= 0) {
				var st = glob.dats.ap_comp[ k_comp_refp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:109, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("element") == 0) { // gen.unit:146, d_struct.act:668
			if (k_elementp >= 0 && va.length > 1) {
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp") == 0) { // gen.unit:147, d_struct.act:668
			if (k_compp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("comp_ref") == 0) { // gen.unit:148, d_struct.act:668
			if (k_comp_refp >= 0 && va.length > 1) {
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va.sublist(1), lno) );
			}
		}
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("element") == 0) {
			if (k_elementp >= 0) {
				var st = glob.dats.ap_element[ k_elementp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp") == 0) {
			if (k_compp >= 0) {
				var st = glob.dats.ap_comp[ k_compp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if (va[0].compareTo("comp_ref") == 0) {
			if (k_comp_refp >= 0) {
				var st = glob.dats.ap_comp[ k_comp_refp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:130, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
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
		kp_doc_from = act.kp_doc.length;
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
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:563
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

	Future<int> do_its(glob, va, lno) async  {
		if (va[0].compareTo("parent") == 0) { // gen.unit:2, d_struct.act:548
			if (k_parentp >= 0) {
				var st = glob.dats.ap_comp[ k_parentp ];
				if (va.length > 1) {
					return( await  st.do_its(glob, va.sublist(1), lno) );
				}
				return( await  go_act(glob, st) );
			}
			return(0);
		}
		if ( va[0].compareTo("Child") == 0 ) { // gen.unit:151, d_struct.act:167
			return(0);
		}
		if ( va[0].compareTo("kp_doc") == 0 ) { 
			for(var i = kp_doc_from; i <  glob.dats.kp_doc.length; i++) {
				if( glob.dats.kp_doc[i] == "" ) return(0);
				return( await  go_act(glob, glob.dats.kp_doc[i] ) );
			}
			return(0);
		}
		print("?No its " + va[0] + " cmd for Join," + line_no + "," + lno + "?");
		glob.run_errs = true;
		return(0);
	}
}

