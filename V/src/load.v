
pub fn load(tok string, ln string, pos int, mut kp_all Kall, fl string) {
	if tok == "Node" { ld_node(ln,pos, mut kp_all, fl) }
	if tok == "Link" { ld_link(ln,pos, mut kp_all, fl) }
	if tok == "Graph" { ld_graph(ln,pos, mut kp_all, fl) }
	if tok == "Matrix" { ld_matrix(ln,pos, mut kp_all, fl) }
	if tok == "Table" { ld_table(ln,pos, mut kp_all, fl) }
	if tok == "Field" { ld_field(ln,pos, mut kp_all, fl) }
	if tok == "Join" { ld_join(ln,pos, mut kp_all, fl) }
	if tok == "Actor" { ld_actor(ln,pos, mut kp_all, fl) }
	if tok == "D" { ld_d(ln,pos, mut kp_all, fl) }
	if tok == "All" { ld_all(ln,pos, mut kp_all, fl) }
	if tok == "Du" { ld_du(ln,pos, mut kp_all, fl) }
	if tok == "Set" { ld_set(ln,pos, mut kp_all, fl) }
	if tok == "Its" { ld_its(ln,pos, mut kp_all, fl) }
	if tok == "C" { ld_c(ln,pos, mut kp_all, fl) }
	if tok == "Cs" { ld_cs(ln,pos, mut kp_all, fl) }
	if tok == "Out" { ld_out(ln,pos, mut kp_all, fl) }
	if tok == "Break" { ld_break(ln,pos, mut kp_all, fl) }
	if tok == "Unique" { ld_unique(ln,pos, mut kp_all, fl) }
	if tok == "Collect" { ld_collect(ln,pos, mut kp_all, fl) }
	if tok == "Group" { ld_group(ln,pos, mut kp_all, fl) }
}

pub fn refs(mut kp_all Kall) {
	for mut st in kp_all.ap_node  {
		st.k_parentp = fnd(kp_all, "Node_" + st.k_parent , st.k_parent, ".", st.fline ) // R1
	}
	for mut st in kp_all.ap_link  {
		st.k_top = fnd(kp_all, "Node_" + st.k_to , st.k_to, "check", st.fline ) // R1
	}
	for mut st in kp_all.ap_join  {
		st.k_field1p = fnd(kp_all, st.parentp.str() + "_Field_" + st.k_field1 , st.k_field1, "check", st.fline ) // F1
		st.k_table2p = fnd(kp_all, "Table_" + st.k_table2 , st.k_table2, "check", st.fline ) // R1
		st.k_field2p = fnd(kp_all, st.k_table2p.str() + "_Field_" + st.k_field2 , st.k_field2, "check", st.fline ) // L1
	}
}

pub type Tcmd =  KpD | KpAll | KpDu | KpSet | KpIts | KpC | KpCs | KpOut | KpBreak | KpUnique | KpCollect | KpGroup

pub struct Kall {
	mut:
	dict map[string]int
	ap_node []KpNode
	ap_link []KpLink
	ap_graph []KpGraph
	ap_matrix []KpMatrix
	ap_table []KpTable
	ap_field []KpField
	ap_join []KpJoin
	ap_actor []KpActor
}

pub struct KpNode {
	mut:
	kme int
	names map[string]string
	fline string
	k_name string
	k_pad string
	k_parent string
	k_var string
	k_eq string
	k_value string
	k_parentp int
	its_link []int
}

pub struct KpLink {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_to string
	k_top int
}

pub struct KpGraph {
	mut:
	kme int
	names map[string]string
	fline string
	k_name string
	k_pad string
	k_search string
}

pub struct KpMatrix {
	mut:
	kme int
	names map[string]string
	fline string
	k_a string
	k_b string
	k_c string
	k_pad string
	k_search string
}

pub struct KpTable {
	mut:
	kme int
	names map[string]string
	fline string
	k_name string
	k_pad string
	k_value string
	its_field []int
	its_join []int
}

pub struct KpField {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_name string
	k_dt string
	k_pad string
	k_use string
}

pub struct KpJoin {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_field1 string
	k_table2 string
	k_field2 string
	k_pad string
	k_use string
	k_field1p int
	k_table2p int
	k_field2p int
}

pub struct KpActor {
	mut:
	kme int
	names map[string]string
	fline string
	k_name string
	k_parent string
	k_attr string
	k_eq string
	k_value string
	k_cc string
	kchilds []Tcmd
}

pub struct KpD {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_ds string
}

pub struct KpAll {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_what string
	k_actor string
	k_args string
	k_actorp int
}

pub struct KpDu {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_actor string
	k_attr string
	k_eq string
	k_value string
	k_actorp int
}

pub struct KpSet {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_attr string
	k_eq string
	k_value string
}

pub struct KpIts {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_what string
	k_actor string
	k_args string
	k_actorp int
}

pub struct KpC {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_desc string
}

pub struct KpCs {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_desc string
}

pub struct KpOut {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_what string
	k_pad string
	k_desc string
}

pub struct KpBreak {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_what string
}

pub struct KpUnique {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_cmd string
	k_key string
	k_cc string
}

pub struct KpCollect {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_cmd string
	k_pocket string
}

pub struct KpGroup {
	mut:
	kme int
	names map[string]string
	fline string
	parentp int
	k_cmd string
	k_pocket string
	k_key string
	k_value string
}

pub fn ld_node(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpNode{}
	node.kme = kp_all.ap_node.len
	node.fline = lc
	node.k_name, pos = getw(ln,pos)
	node.names[ "name" ] = node.k_name
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_parent, pos = getw(ln,pos)
	node.names[ "parent" ] = node.k_parent
	node.k_var, pos = getw(ln,pos)
	node.names[ "var" ] = node.k_var
	node.k_eq, pos = getw(ln,pos)
	node.names[ "eq" ] = node.k_eq
	node.k_value, pos = getw(ln,pos)
	node.names[ "value" ] = node.k_value
	kp_all.dict[ "Node_" + node.k_name ] = node.kme
	kp_all.ap_node << node
}


pub fn ld_link(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpLink{}
	node.kme = kp_all.ap_link.len
	node.fline = lc
	node.k_to, pos = getw(ln,pos)
	node.names[ "to" ] = node.k_to
	node.parentp = kp_all.ap_node.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_node[node.parentp].its_link << node.kme
	kp_all.ap_link << node
}


pub fn ld_graph(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpGraph{}
	node.kme = kp_all.ap_graph.len
	node.fline = lc
	node.k_name, pos = getw(ln,pos)
	node.names[ "name" ] = node.k_name
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_search, pos = getws(ln,pos)
	node.names[ "search" ] = node.k_search
	kp_all.dict[ "Graph_" + node.k_name ] = node.kme
	kp_all.ap_graph << node
}


pub fn ld_matrix(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpMatrix{}
	node.kme = kp_all.ap_matrix.len
	node.fline = lc
	node.k_a, pos = getw(ln,pos)
	node.names[ "a" ] = node.k_a
	node.k_b, pos = getw(ln,pos)
	node.names[ "b" ] = node.k_b
	node.k_c, pos = getw(ln,pos)
	node.names[ "c" ] = node.k_c
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_search, pos = getw(ln,pos)
	node.names[ "search" ] = node.k_search
	kp_all.ap_matrix << node
}


pub fn ld_table(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpTable{}
	node.kme = kp_all.ap_table.len
	node.fline = lc
	node.k_name, pos = getw(ln,pos)
	node.names[ "name" ] = node.k_name
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_value, pos = getw(ln,pos)
	node.names[ "value" ] = node.k_value
	kp_all.dict[ "Table_" + node.k_name ] = node.kme
	kp_all.ap_table << node
}


pub fn ld_field(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpField{}
	node.kme = kp_all.ap_field.len
	node.fline = lc
	node.k_name, pos = getw(ln,pos)
	node.names[ "name" ] = node.k_name
	node.k_dt, pos = getw(ln,pos)
	node.names[ "dt" ] = node.k_dt
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_use, pos = getw(ln,pos)
	node.names[ "use" ] = node.k_use
	node.parentp = kp_all.ap_table.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_table[node.parentp].its_field << node.kme
	kp_all.dict[ node.parentp.str() + "_Field_" + node.k_name ] = node.kme
	kp_all.ap_field << node
}


pub fn ld_join(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpJoin{}
	node.kme = kp_all.ap_join.len
	node.fline = lc
	node.k_field1, pos = getw(ln,pos)
	node.names[ "field1" ] = node.k_field1
	node.k_table2, pos = getw(ln,pos)
	node.names[ "table2" ] = node.k_table2
	node.k_field2, pos = getw(ln,pos)
	node.names[ "field2" ] = node.k_field2
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_use, pos = getw(ln,pos)
	node.names[ "use" ] = node.k_use
	node.parentp = kp_all.ap_table.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_table[node.parentp].its_join << node.kme
	kp_all.ap_join << node
}


pub fn ld_actor(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpActor{}
	node.kme = kp_all.ap_actor.len
	node.fline = lc
	node.k_name, pos = getw(ln,pos)
	node.names[ "name" ] = node.k_name
	node.k_parent, pos = getw(ln,pos)
	node.names[ "parent" ] = node.k_parent
	node.k_attr, pos = getw(ln,pos)
	node.names[ "attr" ] = node.k_attr
	node.k_eq, pos = getw(ln,pos)
	node.names[ "eq" ] = node.k_eq
	node.k_value, pos = getw(ln,pos)
	node.names[ "value" ] = node.k_value
	node.k_cc, pos = getws(ln,pos)
	node.names[ "cc" ] = node.k_cc
	kp_all.dict[ "Actor_" + node.k_name ] = node.kme
	kp_all.ap_actor << node
}


pub fn ld_d(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpD{}
	node.fline = lc
	node.k_ds, pos = getws(ln,pos)
	node.names[ "ds" ] = node.k_ds
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_all(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpAll{}
	node.fline = lc
	node.k_what, pos = getw(ln,pos)
	node.names[ "what" ] = node.k_what
	node.k_actor, pos = getw(ln,pos)
	node.names[ "actor" ] = node.k_actor
	node.k_args, pos = getws(ln,pos)
	node.names[ "args" ] = node.k_args
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_du(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpDu{}
	node.fline = lc
	node.k_actor, pos = getw(ln,pos)
	node.names[ "actor" ] = node.k_actor
	node.k_attr, pos = getw(ln,pos)
	node.names[ "attr" ] = node.k_attr
	node.k_eq, pos = getw(ln,pos)
	node.names[ "eq" ] = node.k_eq
	node.k_value, pos = getw(ln,pos)
	node.names[ "value" ] = node.k_value
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_set(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpSet{}
	node.fline = lc
	node.k_attr, pos = getw(ln,pos)
	node.names[ "attr" ] = node.k_attr
	node.k_eq, pos = getw(ln,pos)
	node.names[ "eq" ] = node.k_eq
	node.k_value, pos = getws(ln,pos)
	node.names[ "value" ] = node.k_value
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_its(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpIts{}
	node.fline = lc
	node.k_what, pos = getw(ln,pos)
	node.names[ "what" ] = node.k_what
	node.k_actor, pos = getw(ln,pos)
	node.names[ "actor" ] = node.k_actor
	node.k_args, pos = getws(ln,pos)
	node.names[ "args" ] = node.k_args
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_c(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpC{}
	node.fline = lc
	node.k_desc, pos = getws(ln,pos)
	node.names[ "desc" ] = node.k_desc
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_cs(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpCs{}
	node.fline = lc
	node.k_desc, pos = getws(ln,pos)
	node.names[ "desc" ] = node.k_desc
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_out(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpOut{}
	node.fline = lc
	node.k_what, pos = getw(ln,pos)
	node.names[ "what" ] = node.k_what
	node.k_pad, pos = getw(ln,pos)
	node.names[ "pad" ] = node.k_pad
	node.k_desc, pos = getws(ln,pos)
	node.names[ "desc" ] = node.k_desc
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_break(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpBreak{}
	node.fline = lc
	node.k_what, pos = getw(ln,pos)
	node.names[ "what" ] = node.k_what
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_unique(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpUnique{}
	node.fline = lc
	node.k_cmd, pos = getw(ln,pos)
	node.names[ "cmd" ] = node.k_cmd
	node.k_key, pos = getw(ln,pos)
	node.names[ "key" ] = node.k_key
	node.k_cc, pos = getws(ln,pos)
	node.names[ "cc" ] = node.k_cc
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_collect(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpCollect{}
	node.fline = lc
	node.k_cmd, pos = getw(ln,pos)
	node.names[ "cmd" ] = node.k_cmd
	node.k_pocket, pos = getw(ln,pos)
	node.names[ "pocket" ] = node.k_pocket
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


pub fn ld_group(ln string, opos int, mut kp_all Kall, lc string) {
	mut pos := opos
	mut node := KpGroup{}
	node.fline = lc
	node.k_cmd, pos = getw(ln,pos)
	node.names[ "cmd" ] = node.k_cmd
	node.k_pocket, pos = getw(ln,pos)
	node.names[ "pocket" ] = node.k_pocket
	node.k_key, pos = getw(ln,pos)
	node.names[ "key" ] = node.k_key
	node.k_value, pos = getws(ln,pos)
	node.names[ "value" ] = node.k_value
	node.parentp = kp_all.ap_actor.len-1
	if node.parentp < 0 { 
		println(lc + " has no parent") 
		return
	}
	kp_all.ap_actor[node.parentp].kchilds << node
}


