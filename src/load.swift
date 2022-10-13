func load(_ tok: String, _ act: ActT, _ ln: Array<Character>) {
	if tok == "Node" { ld_node(act,  ln); }
	if tok == "Link" { ld_link(act,  ln); }
	if tok == "Graph" { ld_graph(act,  ln); }
	if tok == "Matrix" { ld_matrix(act,  ln); }
	if tok == "Table" { ld_table(act,  ln); }
	if tok == "Field" { ld_field(act,  ln); }
	if tok == "Attr" { ld_attr(act,  ln); }
	if tok == "Join" { ld_join(act,  ln); }
	if tok == "Join2" { ld_join2(act,  ln); }
	if tok == "Comp" { ld_comp(act,  ln); }
	if tok == "Token" { ld_token(act,  ln); }
	if tok == "Star" { ld_star(act,  ln); }
	if tok == "*" { ld_star(act,  ln); }
	if tok == "Element" { ld_element(act,  ln); }
	if tok == "Opt" { ld_opt(act,  ln); }
	if tok == "Ref" { ld_ref(act,  ln); }
	if tok == "Ref2" { ld_ref2(act,  ln); }
	if tok == "Actor" { ld_actor(act,  ln); }
	if tok == "All" { ld_all(act,  ln); }
	if tok == "Du" { ld_du(act,  ln); }
	if tok == "Set" { ld_set(act,  ln); }
	if tok == "Its" { ld_its(act,  ln); }
	if tok == "C" { ld_c(act,  ln); }
	if tok == "Cs" { ld_cs(act,  ln); }
	if tok == "Out" { ld_out(act,  ln); }
	if tok == "Break" { ld_break(act,  ln); }
	if tok == "Unique" { ld_unique(act,  ln); }
	if tok == "Collect" { ld_collect(act,  ln); }
	if tok == "Group" { ld_group(act,  ln); }
	if tok == "Json" { ld_json(act,  ln); }
}

func refs(_ act: ActT) {
	for i in 0..<act.ap_node.count  {
		let st = act.ap_node[i];
		st.kparentp = fnd( "Node_" + st.kparent , st.kparent, ".", st.kline ); // R1
	}
	for i in 0..<act.ap_link.count  {
		let st = act.ap_link[i];
		st.ktop = fnd( "Node_" + st.kto , st.kto, "check", st.kline ); // R1
	}
	for i in 0..<act.ap_join.count  {
		let st = act.ap_join[i];
		st.kfield1p = fnd( String( st.parentp ) + "_Field_" + st.kfield1 , st.kfield1, "check", st.kline ); // F1
		st.ktable2p = fnd( "Table_" + st.ktable2 , st.ktable2, "check", st.kline ); // R1
		st.kfield2p = fnd( String( st.ktable2p ) + "_Field_" + st.kfield2 , st.kfield2, "check", st.kline ); // L1
	}
	for i in 0..<act.ap_join2.count  {
		let st = act.ap_join2[i];
		st.kfield1p = fnd( String( st.parentp ) + "_Field_" + st.kfield1 , st.kfield1, "check", st.kline ); // F1
		st.ktable2p = fnd( "Table_" + st.ktable2 , st.ktable2, "check", st.kline ); // R1
		st.kfield2p = fnd( String( st.ktable2p ) + "_Field_" + st.kfield2 , st.kfield2, "check", st.kline ); // L1
		st.kattr2p = fnd( String( st.kfield2p ) + "_Attr_" + st.kattr2 , st.kattr2, "check", st.kline ); // L1
	}
	for i in 0..<act.ap_comp.count  {
		let st = act.ap_comp[i];
		st.kparentp = fnd( "Comp_" + st.kparent , st.kparent, ".", st.kline ); // R1
	}
	for i in 0..<act.ap_ref.count  {
		let st = act.ap_ref[i];
		st.kelementp = fnd( String( st.parentp ) + "_Element_" + st.kelement , st.kelement, "check", st.kline ); // F1
		st.kcompp = fnd( "Comp_" + st.kcomp , st.kcomp, "check", st.kline ); // R1
	}
	for i in 0..<act.ap_ref2.count  {
		let st = act.ap_ref2[i];
		st.kelementp = fnd( String( st.parentp ) + "_Element_" + st.kelement , st.kelement, "check", st.kline ); // F1
		st.kcompp = fnd( "Comp_" + st.kcomp , st.kcomp, "check", st.kline ); // R1
		st.kelement2p = fnd( String( st.parentp ) + "_Element_" + st.kelement2 , st.kelement2, "check", st.kline ); // F1
	}
	for i in 0..<act.ap_all.count  {
		let st = act.ap_all[i];
		st.kactorp = fnd( "Actor_" + st.kactor , st.kactor, "check", st.kline ); // R1
	}
	for i in 0..<act.ap_du.count  {
		let st = act.ap_du[i];
		st.kactorp = fnd( "Actor_" + st.kactor , st.kactor, "check", st.kline ); // R1
	}
	for i in 0..<act.ap_its.count  {
		let st = act.ap_its[i];
		st.kactorp = fnd( "Actor_" + st.kactor , st.kactor, "check", st.kline ); // R1
	}
	for i in 0..<act.ap_actor.count  {
		let st = act.ap_actor[i];
		if st.kcomp == "." { continue; }
		if st.kcomp == "E_O_L" { continue; }
		if st.kcomp == "Ikp" { continue; }
		if st.kcomp == "Ijson" { continue; }
		if st.kcomp == "Igroup" { continue; }
		if st.kcomp == "Node" { continue; }
		if st.kcomp == "Link" { continue; }
		if st.kcomp == "Graph" { continue; }
		if st.kcomp == "Matrix" { continue; }
		if st.kcomp == "Table" { continue; }
		if st.kcomp == "Field" { continue; }
		if st.kcomp == "Attr" { continue; }
		if st.kcomp == "Join" { continue; }
		if st.kcomp == "Join2" { continue; }
		if st.kcomp == "Comp" { continue; }
		if st.kcomp == "Token" { continue; }
		if st.kcomp == "Star" { continue; }
		if st.kcomp == "Element" { continue; }
		if st.kcomp == "Opt" { continue; }
		if st.kcomp == "Ref" { continue; }
		if st.kcomp == "Ref2" { continue; }
		if st.kcomp == "Actor" { continue; }
		if st.kcomp == "All" { continue; }
		if st.kcomp == "Du" { continue; }
		if st.kcomp == "Set" { continue; }
		if st.kcomp == "Its" { continue; }
		if st.kcomp == "C" { continue; }
		if st.kcomp == "Cs" { continue; }
		if st.kcomp == "Out" { continue; }
		if st.kcomp == "Break" { continue; }
		if st.kcomp == "Unique" { continue; }
		if st.kcomp == "Collect" { continue; }
		if st.kcomp == "Group" { continue; }
		if st.kcomp == "Json" { continue; }
		print("?No " + st.kcomp + " Comp " + st.kline + "?")
	}
}

func ld_node(_ act: ActT, _ ln: Array<Character>) {
	let k = KpNode.init();
	k.kid = act.ap_node.count;
	k.kme = "Node"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kparent = getw(ln);
	k.names[ "parent" ] = k.kparent;
	k.kvar = getw(ln);
	k.names[ "var" ] = k.kvar;
	k.keq = getw(ln);
	k.names[ "eq" ] = k.keq;
	k.kvalue = getw(ln);
	k.names[ "value" ] = k.kvalue;
	Dict[ "Node_" + k.kname ] = k.kid;
	act.ap_node.append( k );
}


func ld_link(_ act: ActT, _ ln: Array<Character>) {
	let k = KpLink.init();
	k.kid = act.ap_link.count;
	k.kme = "Link"
	k.kline = String( Lno );
	k.kto = getw(ln);
	k.names[ "to" ] = k.kto;
	k.parentp = act.ap_node.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_node[ k.parentp ].itslink.append( k );
	act.ap_node[ k.parentp ].kchilds.append( k );
	act.ap_link.append( k );
}


func ld_graph(_ act: ActT, _ ln: Array<Character>) {
	let k = KpGraph.init();
	k.kid = act.ap_graph.count;
	k.kme = "Graph"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.ksearch = getws(ln)
	k.names[ "search" ] = k.ksearch;
	Dict[ "Graph_" + k.kname ] = k.kid;
	act.ap_graph.append( k );
}


func ld_matrix(_ act: ActT, _ ln: Array<Character>) {
	let k = KpMatrix.init();
	k.kid = act.ap_matrix.count;
	k.kme = "Matrix"
	k.kline = String( Lno );
	k.ka = getw(ln);
	k.names[ "a" ] = k.ka;
	k.kb = getw(ln);
	k.names[ "b" ] = k.kb;
	k.kc = getw(ln);
	k.names[ "c" ] = k.kc;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.ksearch = getw(ln);
	k.names[ "search" ] = k.ksearch;
	act.ap_matrix.append( k );
}


func ld_table(_ act: ActT, _ ln: Array<Character>) {
	let k = KpTable.init();
	k.kid = act.ap_table.count;
	k.kme = "Table"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kvalue = getw(ln);
	k.names[ "value" ] = k.kvalue;
	Dict[ "Table_" + k.kname ] = k.kid;
	act.ap_table.append( k );
}


func ld_field(_ act: ActT, _ ln: Array<Character>) {
	let k = KpField.init();
	k.kid = act.ap_field.count;
	k.kme = "Field"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kdt = getw(ln);
	k.names[ "dt" ] = k.kdt;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kuse = getw(ln);
	k.names[ "use" ] = k.kuse;
	k.parentp = act.ap_table.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_table[ k.parentp ].itsfield.append( k );
	act.ap_table[ k.parentp ].kchilds.append( k );
	Dict[ String( k.parentp ) + "_Field_" + k.kname ] = k.kid;
	act.ap_field.append( k );
}


func ld_attr(_ act: ActT, _ ln: Array<Character>) {
	let k = KpAttr.init();
	k.kid = act.ap_attr.count;
	k.kme = "Attr"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.parentp = act.ap_field.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_field[ k.parentp ].itsattr.append( k );
	act.ap_field[ k.parentp ].kchilds.append( k );
	Dict[ String( k.parentp ) + "_Attr_" + k.kname ] = k.kid;
	act.ap_attr.append( k );
}


func ld_join(_ act: ActT, _ ln: Array<Character>) {
	let k = KpJoin.init();
	k.kid = act.ap_join.count;
	k.kme = "Join"
	k.kline = String( Lno );
	k.kfield1 = getw(ln);
	k.names[ "field1" ] = k.kfield1;
	k.ktable2 = getw(ln);
	k.names[ "table2" ] = k.ktable2;
	k.kfield2 = getw(ln);
	k.names[ "field2" ] = k.kfield2;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kuse = getw(ln);
	k.names[ "use" ] = k.kuse;
	k.parentp = act.ap_table.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_table[ k.parentp ].itsjoin.append( k );
	act.ap_table[ k.parentp ].kchilds.append( k );
	act.ap_join.append( k );
}


func ld_join2(_ act: ActT, _ ln: Array<Character>) {
	let k = KpJoin2.init();
	k.kid = act.ap_join2.count;
	k.kme = "Join2"
	k.kline = String( Lno );
	k.kfield1 = getw(ln);
	k.names[ "field1" ] = k.kfield1;
	k.ktable2 = getw(ln);
	k.names[ "table2" ] = k.ktable2;
	k.kfield2 = getw(ln);
	k.names[ "field2" ] = k.kfield2;
	k.kattr2 = getw(ln);
	k.names[ "attr2" ] = k.kattr2;
	k.parentp = act.ap_table.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_table[ k.parentp ].itsjoin2.append( k );
	act.ap_table[ k.parentp ].kchilds.append( k );
	act.ap_join2.append( k );
}


func ld_comp(_ act: ActT, _ ln: Array<Character>) {
	let k = KpComp.init();
	k.kid = act.ap_comp.count;
	k.kme = "Comp"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.knop = getw(ln);
	k.names[ "nop" ] = k.knop;
	k.kparent = getw(ln);
	k.names[ "parent" ] = k.kparent;
	k.kfind = getw(ln);
	k.names[ "find" ] = k.kfind;
	k.kdoc = getws(ln)
	k.names[ "doc" ] = k.kdoc;
	Dict[ "Comp_" + k.kname ] = k.kid;
	act.ap_comp.append( k );
}


func ld_token(_ act: ActT, _ ln: Array<Character>) {
	let k = KpToken.init();
	k.kid = act.ap_token.count;
	k.kme = "Token"
	k.kline = String( Lno );
	k.ktoken = getw(ln);
	k.names[ "token" ] = k.ktoken;
	k.parentp = act.ap_comp.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_comp[ k.parentp ].itstoken.append( k );
	act.ap_comp[ k.parentp ].kchilds.append( k );
	act.ap_token.append( k );
}


func ld_star(_ act: ActT, _ ln: Array<Character>) {
	let k = KpStar.init();
	k.kid = act.ap_star.count;
	k.kme = "Star"
	k.kline = String( Lno );
	k.kdoc = getws(ln)
	k.names[ "doc" ] = k.kdoc;
	act.ap_star.append( k );
}


func ld_element(_ act: ActT, _ ln: Array<Character>) {
	let k = KpElement.init();
	k.kid = act.ap_element.count;
	k.kme = "Element"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kmw = getw(ln);
	k.names[ "mw" ] = k.kmw;
	k.kmw2 = getw(ln);
	k.names[ "mw2" ] = k.kmw2;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kdoc = getws(ln)
	k.names[ "doc" ] = k.kdoc;
	k.parentp = act.ap_comp.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_comp[ k.parentp ].itselement.append( k );
	act.ap_comp[ k.parentp ].kchilds.append( k );
	Dict[ String( k.parentp ) + "_Element_" + k.kname ] = k.kid;
	act.ap_element.append( k );
}


func ld_opt(_ act: ActT, _ ln: Array<Character>) {
	let k = KpOpt.init();
	k.kid = act.ap_opt.count;
	k.kme = "Opt"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kdoc = getws(ln)
	k.names[ "doc" ] = k.kdoc;
	k.parentp = act.ap_element.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_element[ k.parentp ].itsopt.append( k );
	act.ap_element[ k.parentp ].kchilds.append( k );
	Dict[ String( k.parentp ) + "_Opt_" + k.kname ] = k.kid;
	act.ap_opt.append( k );
}


func ld_ref(_ act: ActT, _ ln: Array<Character>) {
	let k = KpRef.init();
	k.kid = act.ap_ref.count;
	k.kme = "Ref"
	k.kline = String( Lno );
	k.kelement = getw(ln);
	k.names[ "element" ] = k.kelement;
	k.kcomp = getw(ln);
	k.names[ "comp" ] = k.kcomp;
	k.kopt = getw(ln);
	k.names[ "opt" ] = k.kopt;
	k.kvar = getw(ln);
	k.names[ "var" ] = k.kvar;
	k.kdoc = getws(ln)
	k.names[ "doc" ] = k.kdoc;
	k.parentp = act.ap_comp.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_comp[ k.parentp ].itsref.append( k );
	act.ap_comp[ k.parentp ].kchilds.append( k );
	act.ap_ref.append( k );
}


func ld_ref2(_ act: ActT, _ ln: Array<Character>) {
	let k = KpRef2.init();
	k.kid = act.ap_ref2.count;
	k.kme = "Ref2"
	k.kline = String( Lno );
	k.kelement = getw(ln);
	k.names[ "element" ] = k.kelement;
	k.kcomp = getw(ln);
	k.names[ "comp" ] = k.kcomp;
	k.kelement2 = getw(ln);
	k.names[ "element2" ] = k.kelement2;
	k.kopt = getw(ln);
	k.names[ "opt" ] = k.kopt;
	k.kvar = getw(ln);
	k.names[ "var" ] = k.kvar;
	k.kdoc = getws(ln)
	k.names[ "doc" ] = k.kdoc;
	k.parentp = act.ap_comp.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_comp[ k.parentp ].itsref2.append( k );
	act.ap_comp[ k.parentp ].kchilds.append( k );
	act.ap_ref2.append( k );
}


func ld_actor(_ act: ActT, _ ln: Array<Character>) {
	let k = KpActor.init();
	k.kid = act.ap_actor.count;
	k.kme = "Actor"
	k.kline = String( Lno );
	k.kname = getw(ln);
	k.names[ "name" ] = k.kname;
	k.kcomp = getw(ln);
	k.names[ "comp" ] = k.kcomp;
	k.kattr = getw(ln);
	k.names[ "attr" ] = k.kattr;
	k.keq = getw(ln);
	k.names[ "eq" ] = k.keq;
	k.kvalue = getw(ln);
	k.names[ "value" ] = k.kvalue;
	k.kcc = getws(ln)
	k.names[ "cc" ] = k.kcc;
	Dict[ "Actor_" + k.kname ] = k.kid;
	act.ap_actor.append( k );
}


func ld_all(_ act: ActT, _ ln: Array<Character>) {
	let k = KpAll.init();
	k.kid = act.ap_all.count;
	k.kme = "All"
	k.kline = String( Lno );
	k.kwhat = getw(ln);
	k.names[ "what" ] = k.kwhat;
	k.kactor = getw(ln);
	k.names[ "actor" ] = k.kactor;
	k.kargs = getws(ln)
	k.names[ "args" ] = k.kargs;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_all.append( k );
}


func ld_du(_ act: ActT, _ ln: Array<Character>) {
	let k = KpDu.init();
	k.kid = act.ap_du.count;
	k.kme = "Du"
	k.kline = String( Lno );
	k.kactor = getw(ln);
	k.names[ "actor" ] = k.kactor;
	k.kattr = getw(ln);
	k.names[ "attr" ] = k.kattr;
	k.keq = getw(ln);
	k.names[ "eq" ] = k.keq;
	k.kvalue = getw(ln);
	k.names[ "value" ] = k.kvalue;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_du.append( k );
}


func ld_set(_ act: ActT, _ ln: Array<Character>) {
	let k = KpSet.init();
	k.kid = act.ap_set.count;
	k.kme = "Set"
	k.kline = String( Lno );
	k.kattr = getw(ln);
	k.names[ "attr" ] = k.kattr;
	k.keq = getw(ln);
	k.names[ "eq" ] = k.keq;
	k.kvalue = getws(ln)
	k.names[ "value" ] = k.kvalue;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_set.append( k );
}


func ld_its(_ act: ActT, _ ln: Array<Character>) {
	let k = KpIts.init();
	k.kid = act.ap_its.count;
	k.kme = "Its"
	k.kline = String( Lno );
	k.kwhat = getw(ln);
	k.names[ "what" ] = k.kwhat;
	k.kactor = getw(ln);
	k.names[ "actor" ] = k.kactor;
	k.kargs = getws(ln)
	k.names[ "args" ] = k.kargs;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_its.append( k );
}


func ld_c(_ act: ActT, _ ln: Array<Character>) {
	let k = KpC.init();
	k.kid = act.ap_c.count;
	k.kme = "C"
	k.kline = String( Lno );
	k.kdesc = getws(ln)
	k.names[ "desc" ] = k.kdesc;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_c.append( k );
}


func ld_cs(_ act: ActT, _ ln: Array<Character>) {
	let k = KpCs.init();
	k.kid = act.ap_cs.count;
	k.kme = "Cs"
	k.kline = String( Lno );
	k.kdesc = getws(ln)
	k.names[ "desc" ] = k.kdesc;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_cs.append( k );
}


func ld_out(_ act: ActT, _ ln: Array<Character>) {
	let k = KpOut.init();
	k.kid = act.ap_out.count;
	k.kme = "Out"
	k.kline = String( Lno );
	k.kwhat = getw(ln);
	k.names[ "what" ] = k.kwhat;
	k.kpad = getw(ln);
	k.names[ "pad" ] = k.kpad;
	k.kdesc = getws(ln)
	k.names[ "desc" ] = k.kdesc;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_out.append( k );
}


func ld_break(_ act: ActT, _ ln: Array<Character>) {
	let k = KpBreak.init();
	k.kid = act.ap_break.count;
	k.kme = "Break"
	k.kline = String( Lno );
	k.kwhat = getw(ln);
	k.names[ "what" ] = k.kwhat;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_break.append( k );
}


func ld_unique(_ act: ActT, _ ln: Array<Character>) {
	let k = KpUnique.init();
	k.kid = act.ap_unique.count;
	k.kme = "Unique"
	k.kline = String( Lno );
	k.kcmd = getw(ln);
	k.names[ "cmd" ] = k.kcmd;
	k.kkey = getw(ln);
	k.names[ "key" ] = k.kkey;
	k.kvalue = getws(ln)
	k.names[ "value" ] = k.kvalue;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_unique.append( k );
}


func ld_collect(_ act: ActT, _ ln: Array<Character>) {
	let k = KpCollect.init();
	k.kid = act.ap_collect.count;
	k.kme = "Collect"
	k.kline = String( Lno );
	k.kcmd = getw(ln);
	k.names[ "cmd" ] = k.kcmd;
	k.kpocket = getw(ln);
	k.names[ "pocket" ] = k.kpocket;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_collect.append( k );
}


func ld_group(_ act: ActT, _ ln: Array<Character>) {
	let k = KpGroup.init();
	k.kid = act.ap_group.count;
	k.kme = "Group"
	k.kline = String( Lno );
	k.kcmd = getw(ln);
	k.names[ "cmd" ] = k.kcmd;
	k.kpocket = getw(ln);
	k.names[ "pocket" ] = k.kpocket;
	k.kkey = getw(ln);
	k.names[ "key" ] = k.kkey;
	k.kvalue = getws(ln)
	k.names[ "value" ] = k.kvalue;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_group.append( k );
}


func ld_json(_ act: ActT, _ ln: Array<Character>) {
	let k = KpJson.init();
	k.kid = act.ap_json.count;
	k.kme = "Json"
	k.kline = String( Lno );
	k.kcmd = getw(ln);
	k.names[ "cmd" ] = k.kcmd;
	k.kpocket = getw(ln);
	k.names[ "pocket" ] = k.kpocket;
	k.kfile = getws(ln)
	k.names[ "file" ] = k.kfile;
	k.parentp = act.ap_actor.count-1;
	if k.parentp < 0 { 
		print(Lno + " has no parent"); 
		return;
	}
	act.ap_actor[ k.parentp ].kchilds.append( k );
	act.ap_json.append( k );
}


