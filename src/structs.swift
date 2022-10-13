class ActT {
	var ap_node: [KpNode] = [];
	var ap_link: [KpLink] = [];
	var ap_graph: [KpGraph] = [];
	var ap_matrix: [KpMatrix] = [];
	var ap_table: [KpTable] = [];
	var ap_field: [KpField] = [];
	var ap_attr: [KpAttr] = [];
	var ap_join: [KpJoin] = [];
	var ap_join2: [KpJoin2] = [];
	var ap_comp: [KpComp] = [];
	var ap_token: [KpToken] = [];
	var ap_star: [KpStar] = [];
	var ap_element: [KpElement] = [];
	var ap_opt: [KpOpt] = [];
	var ap_ref: [KpRef] = [];
	var ap_ref2: [KpRef2] = [];
	var ap_actor: [KpActor] = [];
	var ap_all: [KpAll] = [];
	var ap_du: [KpDu] = [];
	var ap_set: [KpSet] = [];
	var ap_its: [KpIts] = [];
	var ap_c: [KpC] = [];
	var ap_cs: [KpCs] = [];
	var ap_out: [KpOut] = [];
	var ap_break: [KpBreak] = [];
	var ap_unique: [KpUnique] = [];
	var ap_collect: [KpCollect] = [];
	var ap_group: [KpGroup] = [];
	var ap_json: [KpJson] = [];
}

func var_all(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
	let ss = split(b);
	if a == "Node" { // app.unit:2, s_struct.act:44
		if let en = Dict[ "Node_" + ss.a ] {
			let ss2 = split(ss.b);
			return Def.ap_node[en].get_var(ss2.a, ss2.b, ln);
		}
		return(false, "?" + a + "=" + ss.a + "?" + "," + ln + "?");
	}
	if a == "Graph" { // app.unit:23, s_struct.act:44
		if let en = Dict[ "Graph_" + ss.a ] {
			let ss2 = split(ss.b);
			return Def.ap_graph[en].get_var(ss2.a, ss2.b, ln);
		}
		return(false, "?" + a + "=" + ss.a + "?" + "," + ln + "?");
	}
	if a == "Matrix" { // app.unit:31, s_struct.act:44
		if let en = Dict[ "Matrix_" + ss.a ] {
			let ss2 = split(ss.b);
			return Def.ap_matrix[en].get_var(ss2.a, ss2.b, ln);
		}
		return(false, "?" + a + "=" + ss.a + "?" + "," + ln + "?");
	}
	if a == "Table" { // app.unit:41, s_struct.act:44
		if let en = Dict[ "Table_" + ss.a ] {
			let ss2 = split(ss.b);
			return Def.ap_table[en].get_var(ss2.a, ss2.b, ln);
		}
		return(false, "?" + a + "=" + ss.a + "?" + "," + ln + "?");
	}
	if a == "Comp" { // gen.unit:2, s_struct.act:44
		if let en = Dict[ "Comp_" + ss.a ] {
			let ss2 = split(ss.b);
			return Def.ap_comp[en].get_var(ss2.a, ss2.b, ln);
		}
		return(false, "?" + a + "=" + ss.a + "?" + "," + ln + "?");
	}
	if a == "Actor" { // act.unit:2, s_struct.act:44
		if let en = Dict[ "Actor_" + ss.a ] {
			let ss2 = split(ss.b);
			return Def.ap_actor[en].get_var(ss2.a, ss2.b, ln);
		}
		return(false, "?" + a + "=" + ss.a + "?" + "," + ln + "?");
	}
	return(false, "?" + a + "?" + "," + ln + ", var_all?");
}

func do_all(_ a: String, _ b: String, _ c: String, _ act: String, _ args: String, _ ln: String) -> Int {
	if a == "Node" {  // app.unit:2, s_struct.act:56
		for st in Def.ap_node
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Link" {  // app.unit:15, s_struct.act:56
		for st in Def.ap_link
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Graph" {  // app.unit:23, s_struct.act:56
		for st in Def.ap_graph
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Matrix" {  // app.unit:31, s_struct.act:56
		for st in Def.ap_matrix
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Table" {  // app.unit:41, s_struct.act:56
		for st in Def.ap_table
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Field" {  // app.unit:49, s_struct.act:56
		for st in Def.ap_field
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Attr" {  // app.unit:62, s_struct.act:56
		for st in Def.ap_attr
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Join" {  // app.unit:68, s_struct.act:56
		for st in Def.ap_join
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Join2" {  // app.unit:84, s_struct.act:56
		for st in Def.ap_join2
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Comp" {  // gen.unit:2, s_struct.act:56
		for st in Def.ap_comp
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Token" {  // gen.unit:19, s_struct.act:56
		for st in Def.ap_token
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Star" {  // gen.unit:27, s_struct.act:56
		for st in Def.ap_star
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Element" {  // gen.unit:37, s_struct.act:56
		for st in Def.ap_element
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Opt" {  // gen.unit:54, s_struct.act:56
		for st in Def.ap_opt
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Ref" {  // gen.unit:65, s_struct.act:56
		for st in Def.ap_ref
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Ref2" {  // gen.unit:82, s_struct.act:56
		for st in Def.ap_ref2
		{
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	if a == "Actor" {  // act.unit:2, s_struct.act:56
		for st in Def.ap_actor
		{
			if b != "" { if st.kname != b { continue; } }
			let ret = actor( act, args, st );
			if ret != 0 { return ret-1; }
		}
		return 0;
	}
	print("? No all " + a + " cmd " + "," + ln + "?");
	return 0;
}

class KpNode : Kp {
	var kname: String = "";
	var kpad: String = "";
	var kparent: String = "";
	var kvar: String = "";
	var keq: String = "";
	var kvalue: String = "";
	var kparentp: Int = -1;
	var itslink: [KpLink] = [];
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Link" { // app.unit:15, s_struct.act:335
			for st in itslink {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // app.unit:12, s_struct.act:179
			if kparentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_node[kparentp]);
				}
				let ss = split(b);
				return Def.ap_node[kparentp].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "Node_parent" { // app.unit:12, s_struct.act:234
			for st in Def.ap_node {
				if st.kparentp != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Link_to" { // app.unit:20, s_struct.act:234
			for st in Def.ap_link {
				if st.ktop != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // app.unit:12, s_struct.act:273
			if kparentp >= 0 {
				let ss = split(b);
				return Def.ap_node[kparentp].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "Node_parent" { // app.unit:12, s_struct.act:352
			for st in Def.ap_node {
				if st.kparentp != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Link_to" { // app.unit:20, s_struct.act:352
			for st in Def.ap_link {
				if st.ktop != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Node?");
	}
}

class KpLink : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kto: String = "";
	var ktop: Int = -1;
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // app.unit:2, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_node[parentp]);
				}
				let ss = split(b);
				return Def.ap_node[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "to" { // app.unit:20, s_struct.act:179
			if ktop >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_node[ktop]);
				}
				let ss = split(b);
				return Def.ap_node[ktop].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "to" { // app.unit:20, s_struct.act:273
			if ktop >= 0 {
				let ss = split(b);
				return Def.ap_node[ktop].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "parent" { // app.unit:2, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_node[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Link?");
	}
}

class KpGraph : Kp {
	var kname: String = "";
	var kpad: String = "";
	var ksearch: String = "";
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Graph?");
	}
}

class KpMatrix : Kp {
	var ka: String = "";
	var kb: String = "";
	var kc: String = "";
	var kpad: String = "";
	var ksearch: String = "";
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Matrix?");
	}
}

class KpTable : Kp {
	var kname: String = "";
	var kpad: String = "";
	var kvalue: String = "";
	var itsfield: [KpField] = [];
	var itsjoin: [KpJoin] = [];
	var itsjoin2: [KpJoin2] = [];
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Field" { // app.unit:49, s_struct.act:335
			for st in itsfield {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join" { // app.unit:68, s_struct.act:335
			for st in itsjoin {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join2" { // app.unit:84, s_struct.act:335
			for st in itsjoin2 {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join_table2" { // app.unit:80, s_struct.act:234
			for st in Def.ap_join {
				if st.ktable2p != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join2_table2" { // app.unit:95, s_struct.act:234
			for st in Def.ap_join2 {
				if st.ktable2p != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "Join_table2" { // app.unit:80, s_struct.act:352
			for st in Def.ap_join {
				if st.ktable2p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Join2_table2" { // app.unit:95, s_struct.act:352
			for st in Def.ap_join2 {
				if st.ktable2p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Field" { // app.unit:52, s_struct.act:166
			let ss = split(b);
			if let en = Dict[ String(kid) + "_Field_" + ss.a ] {
				let ss2 = split(ss.b);
				return Def.ap_field[en].get_var(ss2.a, ss2.b, ln);
			}
			return(false, "?" + a + "=" + ss.a + "?" + kline + "," + ln + "?");
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Table?");
	}
}

class KpField : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kname: String = "";
	var kdt: String = "";
	var kpad: String = "";
	var kuse: String = "";
	var itsattr: [KpAttr] = [];
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Attr" { // app.unit:62, s_struct.act:335
			for st in itsattr {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // app.unit:41, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_table[parentp]);
				}
				let ss = split(b);
				return Def.ap_table[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "Join_field1" { // app.unit:79, s_struct.act:234
			for st in Def.ap_join {
				if st.kfield1p != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join2_field1" { // app.unit:94, s_struct.act:234
			for st in Def.ap_join2 {
				if st.kfield1p != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join_field2" { // app.unit:81, s_struct.act:252
			for st in Def.ap_join {
				if st.kfield2p != kid { continue }
				let ret = actor(act, args, st);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join_table2" { // app.unit:81, s_struct.act:260
			for st in Def.ap_join {
				if st.ktable2p != kid { continue }
				let ret = actor(act, args, st);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join2_field2" { // app.unit:96, s_struct.act:252
			for st in Def.ap_join2 {
				if st.kfield2p != kid { continue }
				let ret = actor(act, args, st);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join2_table2" { // app.unit:96, s_struct.act:260
			for st in Def.ap_join2 {
				if st.ktable2p != kid { continue }
				let ret = actor(act, args, st);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // app.unit:41, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_table[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Join_field1" { // app.unit:79, s_struct.act:352
			for st in Def.ap_join {
				if st.kfield1p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Join2_field1" { // app.unit:94, s_struct.act:352
			for st in Def.ap_join2 {
				if st.kfield1p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Join_field2" { // app.unit:81, s_struct.act:364
			for st in Def.ap_join {
				if st.kfield2p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Join2_field2" { // app.unit:96, s_struct.act:364
			for st in Def.ap_join2 {
				if st.kfield2p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Attr" { // app.unit:65, s_struct.act:166
			let ss = split(b);
			if let en = Dict[ String(kid) + "_Attr_" + ss.a ] {
				let ss2 = split(ss.b);
				return Def.ap_attr[en].get_var(ss2.a, ss2.b, ln);
			}
			return(false, "?" + a + "=" + ss.a + "?" + kline + "," + ln + "?");
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Field?");
	}
}

class KpAttr : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kname: String = "";
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // app.unit:49, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_field[parentp]);
				}
				let ss = split(b);
				return Def.ap_field[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "Join2_attr2" { // app.unit:97, s_struct.act:252
			for st in Def.ap_join2 {
				if st.kattr2p != kid { continue }
				let ret = actor(act, args, st);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Join2_field2" { // app.unit:97, s_struct.act:260
			for st in Def.ap_join2 {
				if st.kfield2p != kid { continue }
				let ret = actor(act, args, st);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // app.unit:49, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_field[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Join2_attr2" { // app.unit:97, s_struct.act:364
			for st in Def.ap_join2 {
				if st.kattr2p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Attr?");
	}
}

class KpJoin : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kfield1: String = "";
	var ktable2: String = "";
	var kfield2: String = "";
	var kpad: String = "";
	var kuse: String = "";
	var kfield1p: Int = -1;
	var ktable2p: Int = -1;
	var kfield2p: Int = -1;
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // app.unit:41, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_table[parentp]);
				}
				let ss = split(b);
				return Def.ap_table[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "field1" { // app.unit:79, s_struct.act:179
			if kfield1p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_field[kfield1p]);
				}
				let ss = split(b);
				return Def.ap_field[kfield1p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "table2" { // app.unit:80, s_struct.act:179
			if ktable2p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_table[ktable2p]);
				}
				let ss = split(b);
				return Def.ap_table[ktable2p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "field2" { // app.unit:81, s_struct.act:194
			if kfield2p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_field[kfield2p]);
				} 
				let ss = split(b);
				return Def.ap_field[kfield2p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "field1" { // app.unit:79, s_struct.act:273
			if kfield1p >= 0 {
				let ss = split(b);
				return Def.ap_field[kfield1p].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "table2" { // app.unit:80, s_struct.act:273
			if ktable2p >= 0 {
				let ss = split(b);
				return Def.ap_table[ktable2p].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "field2" { // app.unit:81, s_struct.act:284
			if kfield2p >= 0 {
				let ss = split(b);
				return Def.ap_field[kfield2p].get_var(ss.a,ss.b, ln);
			}
		}
		if a == "parent" { // app.unit:41, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_table[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Join?");
	}
}

class KpJoin2 : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kfield1: String = "";
	var ktable2: String = "";
	var kfield2: String = "";
	var kattr2: String = "";
	var kfield1p: Int = -1;
	var ktable2p: Int = -1;
	var kfield2p: Int = -1;
	var kattr2p: Int = -1;
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // app.unit:41, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_table[parentp]);
				}
				let ss = split(b);
				return Def.ap_table[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "field1" { // app.unit:94, s_struct.act:179
			if kfield1p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_field[kfield1p]);
				}
				let ss = split(b);
				return Def.ap_field[kfield1p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "table2" { // app.unit:95, s_struct.act:179
			if ktable2p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_table[ktable2p]);
				}
				let ss = split(b);
				return Def.ap_table[ktable2p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "field2" { // app.unit:96, s_struct.act:194
			if kfield2p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_field[kfield2p]);
				} 
				let ss = split(b);
				return Def.ap_field[kfield2p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "attr2" { // app.unit:97, s_struct.act:194
			if kattr2p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_attr[kattr2p]);
				} 
				let ss = split(b);
				return Def.ap_attr[kattr2p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "field1" { // app.unit:94, s_struct.act:273
			if kfield1p >= 0 {
				let ss = split(b);
				return Def.ap_field[kfield1p].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "table2" { // app.unit:95, s_struct.act:273
			if ktable2p >= 0 {
				let ss = split(b);
				return Def.ap_table[ktable2p].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "field2" { // app.unit:96, s_struct.act:284
			if kfield2p >= 0 {
				let ss = split(b);
				return Def.ap_field[kfield2p].get_var(ss.a,ss.b, ln);
			}
		}
		if a == "attr2" { // app.unit:97, s_struct.act:284
			if kattr2p >= 0 {
				let ss = split(b);
				return Def.ap_attr[kattr2p].get_var(ss.a,ss.b, ln);
			}
		}
		if a == "parent" { // app.unit:41, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_table[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Join2?");
	}
}

class KpComp : Kp {
	var kname: String = "";
	var knop: String = "";
	var kparent: String = "";
	var kfind: String = "";
	var kdoc: String = "";
	var kparentp: Int = -1;
	var itstoken: [KpToken] = [];
	var itselement: [KpElement] = [];
	var itsref: [KpRef] = [];
	var itsref2: [KpRef2] = [];
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Token" { // gen.unit:19, s_struct.act:335
			for st in itstoken {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Element" { // gen.unit:37, s_struct.act:335
			for st in itselement {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Ref" { // gen.unit:65, s_struct.act:335
			for st in itsref {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Ref2" { // gen.unit:82, s_struct.act:335
			for st in itsref2 {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // gen.unit:16, s_struct.act:179
			if kparentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[kparentp]);
				}
				let ss = split(b);
				return Def.ap_comp[kparentp].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "Comp_parent" { // gen.unit:16, s_struct.act:234
			for st in Def.ap_comp {
				if st.kparentp != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Ref_comp" { // gen.unit:79, s_struct.act:234
			for st in Def.ap_ref {
				if st.kcompp != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Ref2_comp" { // gen.unit:97, s_struct.act:234
			for st in Def.ap_ref2 {
				if st.kcompp != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // gen.unit:16, s_struct.act:273
			if kparentp >= 0 {
				let ss = split(b);
				return Def.ap_comp[kparentp].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "Comp_parent" { // gen.unit:16, s_struct.act:352
			for st in Def.ap_comp {
				if st.kparentp != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Ref_comp" { // gen.unit:79, s_struct.act:352
			for st in Def.ap_ref {
				if st.kcompp != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Ref2_comp" { // gen.unit:97, s_struct.act:352
			for st in Def.ap_ref2 {
				if st.kcompp != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Element" { // gen.unit:42, s_struct.act:166
			let ss = split(b);
			if let en = Dict[ String(kid) + "_Element_" + ss.a ] {
				let ss2 = split(ss.b);
				return Def.ap_element[en].get_var(ss2.a, ss2.b, ln);
			}
			return(false, "?" + a + "=" + ss.a + "?" + kline + "," + ln + "?");
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Comp?");
	}
}

class KpToken : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var ktoken: String = "";
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // gen.unit:2, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[parentp]);
				}
				let ss = split(b);
				return Def.ap_comp[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // gen.unit:2, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_comp[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Token?");
	}
}

class KpStar : Kp {
	var kdoc: String = "";
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Star?");
	}
}

class KpElement : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kname: String = "";
	var kmw: String = "";
	var kmw2: String = "";
	var kpad: String = "";
	var kdoc: String = "";
	var itsopt: [KpOpt] = [];
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Opt" { // gen.unit:54, s_struct.act:335
			for st in itsopt {
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // gen.unit:2, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[parentp]);
				}
				let ss = split(b);
				return Def.ap_comp[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "Ref_element" { // gen.unit:78, s_struct.act:234
			for st in Def.ap_ref {
				if st.kelementp != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Ref2_element" { // gen.unit:96, s_struct.act:234
			for st in Def.ap_ref2 {
				if st.kelementp != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "Ref2_element2" { // gen.unit:98, s_struct.act:234
			for st in Def.ap_ref2 {
				if st.kelement2p != kid { continue }
				if b == "" {
					let ret = actor(act, args, st);
					if ret != 0 { return ret-1; }
					continue;
				}
				let ret = st.doo(ss.a, ss.b, act, args, ln);
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // gen.unit:2, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_comp[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Ref_element" { // gen.unit:78, s_struct.act:352
			for st in Def.ap_ref {
				if st.kelementp != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Ref2_element" { // gen.unit:96, s_struct.act:352
			for st in Def.ap_ref2 {
				if st.kelementp != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Ref2_element2" { // gen.unit:98, s_struct.act:352
			for st in Def.ap_ref2 {
				if st.kelement2p != kid { continue }
				let ss = split(b);
				return st.get_var(ss.a, ss.b, ln );
			}
		}
		if a == "Opt" { // gen.unit:60, s_struct.act:166
			let ss = split(b);
			if let en = Dict[ String(kid) + "_Opt_" + ss.a ] {
				let ss2 = split(ss.b);
				return Def.ap_opt[en].get_var(ss2.a, ss2.b, ln);
			}
			return(false, "?" + a + "=" + ss.a + "?" + kline + "," + ln + "?");
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Element?");
	}
}

class KpOpt : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kname: String = "";
	var kpad: String = "";
	var kdoc: String = "";
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // gen.unit:37, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_element[parentp]);
				}
				let ss = split(b);
				return Def.ap_element[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "parent" { // gen.unit:37, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_element[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Opt?");
	}
}

class KpRef : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kelement: String = "";
	var kcomp: String = "";
	var kopt: String = "";
	var kvar: String = "";
	var kdoc: String = "";
	var kelementp: Int = -1;
	var kcompp: Int = -1;
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // gen.unit:2, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[parentp]);
				}
				let ss = split(b);
				return Def.ap_comp[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "element" { // gen.unit:78, s_struct.act:179
			if kelementp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_element[kelementp]);
				}
				let ss = split(b);
				return Def.ap_element[kelementp].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "comp" { // gen.unit:79, s_struct.act:179
			if kcompp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[kcompp]);
				}
				let ss = split(b);
				return Def.ap_comp[kcompp].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "element" { // gen.unit:78, s_struct.act:273
			if kelementp >= 0 {
				let ss = split(b);
				return Def.ap_element[kelementp].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "comp" { // gen.unit:79, s_struct.act:273
			if kcompp >= 0 {
				let ss = split(b);
				return Def.ap_comp[kcompp].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "parent" { // gen.unit:2, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_comp[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Ref?");
	}
}

class KpRef2 : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kelement: String = "";
	var kcomp: String = "";
	var kelement2: String = "";
	var kopt: String = "";
	var kvar: String = "";
	var kdoc: String = "";
	var kelementp: Int = -1;
	var kcompp: Int = -1;
	var kelement2p: Int = -1;
	var kchilds: [Kp] = [];
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int {
		let ss = split(b);
		if a == "Child" {
			for st in kchilds {
				let ret = actor( act, args, st );
				if ret != 0 { return ret-1; }
			}
			return 0;
		}
		if a == "parent" { // gen.unit:2, s_struct.act:209
			if parentp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[parentp]);
				}
				let ss = split(b);
				return Def.ap_comp[parentp].doo(ss.a, ss.b, act, args, ln );
			}
		}
		if a == "element" { // gen.unit:96, s_struct.act:179
			if kelementp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_element[kelementp]);
				}
				let ss = split(b);
				return Def.ap_element[kelementp].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "comp" { // gen.unit:97, s_struct.act:179
			if kcompp >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_comp[kcompp]);
				}
				let ss = split(b);
				return Def.ap_comp[kcompp].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == "element2" { // gen.unit:98, s_struct.act:179
			if kelement2p >= 0 {
				if b == "" {
					return actor(act, args, Def.ap_element[kelement2p]);
				}
				let ss = split(b);
				return Def.ap_element[kelement2p].doo(ss.a, ss.b, act, args, ln);
			}
			return 0;
		}
		if a == ss.a {
			print("?No its " + a + " cmd for " + kline + "," + ln + "?");
		} else {
			print("?No its " + ss.a + " or " + a + " cmd for " + kline + "," + ln + "?");
		}
		return 0;
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) {
		if a == "element" { // gen.unit:96, s_struct.act:273
			if kelementp >= 0 {
				let ss = split(b);
				return Def.ap_element[kelementp].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "comp" { // gen.unit:97, s_struct.act:273
			if kcompp >= 0 {
				let ss = split(b);
				return Def.ap_comp[kcompp].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "element2" { // gen.unit:98, s_struct.act:273
			if kelement2p >= 0 {
				let ss = split(b);
				return Def.ap_element[kelement2p].get_var(ss.a, ss.b, ln);
			}
		}
		if a == "parent" { // gen.unit:2, s_struct.act:223
			if parentp >= 0 {
				let ss = split(b);
				return Def.ap_comp[parentp].get_var(ss.a, ss.b, ln );
			}
		}
		if let v = names[ a ] { return (true, v) }
		return(false, "?" + a + "?" + kline + "," + ln + ",Ref2?");
	}
}

class KpActor : Kp {
	var kname: String = "";
	var kcomp: String = "";
	var kattr: String = "";
	var keq: String = "";
	var kvalue: String = "";
	var kcc: String = "";
	var kchilds: [Kp] = [];
}

class KpAll : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kwhat: String = "";
	var kactor: String = "";
	var kargs: String = "";
	var kactorp: Int = -1;
	var kchilds: [Kp] = [];
}

class KpDu : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kactor: String = "";
	var kattr: String = "";
	var keq: String = "";
	var kvalue: String = "";
	var kactorp: Int = -1;
	var kchilds: [Kp] = [];
}

class KpSet : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kattr: String = "";
	var keq: String = "";
	var kvalue: String = "";
	var kchilds: [Kp] = [];
}

class KpIts : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kwhat: String = "";
	var kactor: String = "";
	var kargs: String = "";
	var kactorp: Int = -1;
	var kchilds: [Kp] = [];
}

class KpC : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kdesc: String = "";
	var kchilds: [Kp] = [];
}

class KpCs : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kdesc: String = "";
	var kchilds: [Kp] = [];
}

class KpOut : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kwhat: String = "";
	var kpad: String = "";
	var kdesc: String = "";
	var kchilds: [Kp] = [];
}

class KpBreak : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kwhat: String = "";
	var kchilds: [Kp] = [];
}

class KpUnique : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kcmd: String = "";
	var kkey: String = "";
	var kvalue: String = "";
	var kchilds: [Kp] = [];
}

class KpCollect : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kcmd: String = "";
	var kpocket: String = "";
	var kchilds: [Kp] = [];
}

class KpGroup : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kcmd: String = "";
	var kpocket: String = "";
	var kkey: String = "";
	var kvalue: String = "";
	var kchilds: [Kp] = [];
}

class KpJson : Kp {
	var parent: String = "";
	var parentp: Int = -1;
	var kcmd: String = "";
	var kpocket: String = "";
	var kfile: String = "";
	var kchilds: [Kp] = [];
}

