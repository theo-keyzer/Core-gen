pub fn dict_val(s string) int
{
	if val := k_all.dict[s] 
	{
		return val
	}
	return -1
}

pub fn var_all(a string, b string, lc string) (bool, string) {
	a2,b2 := split(b)
	a3,b3 := split(b2)
	if a == "Node" {
		val := dict_val( "Node_" + a2 )
		if val >= 0 { return k_all.ap_node[val].get_var(a3, b3, lc) }
		return false, "?" + a + "=" + a2 + "?" + lc + ', ' + @FILE_LINE  + "?"
	}
	if a == "Graph" {
		val := dict_val( "Graph_" + a2 )
		if val >= 0 { return k_all.ap_graph[val].get_var(a3, b3, lc) }
		return false, "?" + a + "=" + a2 + "?" + lc + ', ' + @FILE_LINE  + "?"
	}
	if a == "Matrix" {
		val := dict_val( "Matrix_" + a2 )
		if val >= 0 { return k_all.ap_matrix[val].get_var(a3, b3, lc) }
		return false, "?" + a + "=" + a2 + "?" + lc + ', ' + @FILE_LINE  + "?"
	}
	if a == "Table" {
		val := dict_val( "Table_" + a2 )
		if val >= 0 { return k_all.ap_table[val].get_var(a3, b3, lc) }
		return false, "?" + a + "=" + a2 + "?" + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + lc + ', ' + @FILE_LINE  + "?"
}

pub fn do_all(a string, b string, c string, act string, arg string, lc string, sact int) int {
	mut cnt := 0
	if a == "Node" {  // app.u:2, v_struct2.a:64
		for i in 0 .. k_all.ap_node.len
		{
			if b != '' {
				ret := k_all.ap_node[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_node[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	if a == "Link" {  // app.u:15, v_struct2.a:64
		for i in 0 .. k_all.ap_link.len
		{
			if b != '' {
				ret := k_all.ap_link[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_link[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	if a == "Graph" {  // app.u:23, v_struct2.a:64
		for i in 0 .. k_all.ap_graph.len
		{
			if b != '' {
				ret := k_all.ap_graph[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_graph[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	if a == "Matrix" {  // app.u:31, v_struct2.a:64
		for i in 0 .. k_all.ap_matrix.len
		{
			if b != '' {
				ret := k_all.ap_matrix[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_matrix[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	if a == "Table" {  // app.u:41, v_struct2.a:64
		for i in 0 .. k_all.ap_table.len
		{
			if b != '' {
				ret := k_all.ap_table[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_table[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	if a == "Field" {  // app.u:49, v_struct2.a:64
		for i in 0 .. k_all.ap_field.len
		{
			if b != '' {
				ret := k_all.ap_field[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_field[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	if a == "Join" {  // app.u:61, v_struct2.a:64
		for i in 0 .. k_all.ap_join.len
		{
			if b != '' {
				ret := k_all.ap_join[i].doo(b, c, act, arg, lc, sact, cnt)
				if ret > 0 { return ret-1 }
				if ret == 0 { cnt++ }
				continue
			}
			ret := actor( act, k_all.ap_join[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	println("? No all " + a + " cmd " + lc + ', ' + @FILE_LINE  + "?")
	return 0
}

pub fn (def KpNode) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	if a == "Link" { // app.u:15, v_struct2.a:296
		mut cnt := -1
		for i in def.its_link {
			cnt++
			if b == "" {
				ret := actor(act, k_all.ap_link[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_link[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	if a == "parent" { // app.u:12, v_struct2.a:161
		if def.k_parentp >= 0 {
			if b == "" {
				return actor(act, k_all.ap_node[def.k_parentp], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_node[def.k_parentp].doo(a2,b2, act, arg,lc,sact,pcnt)
		}
		return 0
	}
	if a == "Node_parent" { // app.u:12, v_struct2.a:228
		mut cnt := -1
		for i in 0 .. k_all.ap_node.len {
			cnt++
			if k_all.ap_node[i].k_parentp != def.kme { continue }
			if b == "" {
				ret := actor(act, k_all.ap_node[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_node[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	if a == "Link_to" { // app.u:20, v_struct2.a:228
		mut cnt := -1
		for i in 0 .. k_all.ap_link.len {
			cnt++
			if k_all.ap_link[i].k_top != def.kme { continue }
			if b == "" {
				ret := actor(act, k_all.ap_link[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_link[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpNode) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if a == "parent" { // app.u:12, v_struct2.a:264
		if def.k_parentp >= 0 {
			a2,b2 := split(b)
			return k_all.ap_node[def.k_parentp].get_var(a2,b2, lc)
		}
	}
	if a == "Node_parent" { // app.u:12, v_struct2.a:316
		for i in 0 .. k_all.ap_node.len {
			if k_all.ap_node[i].k_parentp != def.kme { continue }
			a2,b2 := split(b)
			return k_all.ap_node[i].get_var(a2,b2, lc)
		}
	}
	if a == "Link_to" { // app.u:20, v_struct2.a:316
		for i in 0 .. k_all.ap_link.len {
			if k_all.ap_link[i].k_top != def.kme { continue }
			a2,b2 := split(b)
			return k_all.ap_link[i].get_var(a2,b2, lc)
		}
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

pub fn (def KpLink) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	if a == "parent" { // app.u:2, v_struct2.a:191
		if def.parentp >= 0 {
			if b == "" {
				return actor(act, k_all.ap_node[def.parentp], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_node[def.parentp].doo(a2,b2, act, arg, lc, sact,pcnt )
		}
		return 0
	}
	if a == "to" { // app.u:20, v_struct2.a:161
		if def.k_top >= 0 {
			if b == "" {
				return actor(act, k_all.ap_node[def.k_top], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_node[def.k_top].doo(a2,b2, act, arg,lc,sact,pcnt)
		}
		return 0
	}
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpLink) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if a == "to" { // app.u:20, v_struct2.a:264
		if def.k_top >= 0 {
			a2,b2 := split(b)
			return k_all.ap_node[def.k_top].get_var(a2,b2, lc)
		}
	}
	if a == "parent" { // app.u:2, v_struct2.a:206
		if def.parentp >= 0 {
			a2,b2 := split(b)
			return k_all.ap_node[def.parentp].get_var(a2,b2, lc )
		}
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

pub fn (def KpGraph) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpGraph) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

pub fn (def KpMatrix) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpMatrix) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

pub fn (def KpTable) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	if a == "Field" { // app.u:49, v_struct2.a:296
		mut cnt := -1
		for i in def.its_field {
			cnt++
			if b == "" {
				ret := actor(act, k_all.ap_field[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_field[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	if a == "Join" { // app.u:61, v_struct2.a:296
		mut cnt := -1
		for i in def.its_join {
			cnt++
			if b == "" {
				ret := actor(act, k_all.ap_join[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_join[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	if a == "Join_table2" { // app.u:73, v_struct2.a:228
		mut cnt := -1
		for i in 0 .. k_all.ap_join.len {
			cnt++
			if k_all.ap_join[i].k_table2p != def.kme { continue }
			if b == "" {
				ret := actor(act, k_all.ap_join[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_join[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpTable) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if a == "Join_table2" { // app.u:73, v_struct2.a:316
		for i in 0 .. k_all.ap_join.len {
			if k_all.ap_join[i].k_table2p != def.kme { continue }
			a2,b2 := split(b)
			return k_all.ap_join[i].get_var(a2,b2, lc)
		}
	}
	if a == "Field" { // app.u:52, v_struct2.a:148
		a2,b2 := split(b)
		if en := k_all.dict[ def.kme.str() + "_Field_" + a2 ] {
			a3,b3 := split(b2)
			return k_all.ap_field[en].get_var(a3, b3, lc)
		}
		return false, "?" + a + "=" + a2 + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

pub fn (def KpField) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	if a == "parent" { // app.u:41, v_struct2.a:191
		if def.parentp >= 0 {
			if b == "" {
				return actor(act, k_all.ap_table[def.parentp], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_table[def.parentp].doo(a2,b2, act, arg, lc, sact,pcnt )
		}
		return 0
	}
	if a == "Join_field1" { // app.u:72, v_struct2.a:228
		mut cnt := -1
		for i in 0 .. k_all.ap_join.len {
			cnt++
			if k_all.ap_join[i].k_field1p != def.kme { continue }
			if b == "" {
				ret := actor(act, k_all.ap_join[i], cnt, arg, sact )
				if ret != 0 { return ret-1 }
				continue
			}
			a2,b2 := split(b)
			ret := k_all.ap_join[i].doo(a2,b2, act, arg,lc,sact,cnt)
			if ret != 0 { return ret-1 }
		}
		return 0
	}
	if a == "Join_field2" { // app.u:74, v_struct2.a:249
		mut cnt := 0
		for i in 0 .. k_all.ap_join.len {
			if k_all.ap_join[i].k_field2p != def.kme { continue }
			ret := actor(act, k_all.ap_join[i], cnt, arg, sact )
			if ret != 0 { return ret-1 }
			cnt++
		}
		return 0
	}
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpField) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if a == "parent" { // app.u:41, v_struct2.a:206
		if def.parentp >= 0 {
			a2,b2 := split(b)
			return k_all.ap_table[def.parentp].get_var(a2,b2, lc )
		}
	}
	if a == "Join_field1" { // app.u:72, v_struct2.a:316
		for i in 0 .. k_all.ap_join.len {
			if k_all.ap_join[i].k_field1p != def.kme { continue }
			a2,b2 := split(b)
			return k_all.ap_join[i].get_var(a2,b2, lc)
		}
	}
	if a == "Join_field2" { // app.u:74, v_struct2.a:328
		for i in 0 .. k_all.ap_join.len {
			if k_all.ap_join[i].k_field2p != def.kme { continue }
			a2,b2 := split(b)
			return k_all.ap_join[i].get_var(a2,b2, lc )
		}
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

pub fn (def KpJoin) doo(a string, b string, act string, arg string, lc string, sact int, pcnt int) int
{
	if a == "parent" { // app.u:41, v_struct2.a:191
		if def.parentp >= 0 {
			if b == "" {
				return actor(act, k_all.ap_table[def.parentp], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_table[def.parentp].doo(a2,b2, act, arg, lc, sact,pcnt )
		}
		return 0
	}
	if a == "field1" { // app.u:72, v_struct2.a:161
		if def.k_field1p >= 0 {
			if b == "" {
				return actor(act, k_all.ap_field[def.k_field1p], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_field[def.k_field1p].doo(a2,b2, act, arg,lc,sact,pcnt)
		}
		return 0
	}
	if a == "table2" { // app.u:73, v_struct2.a:161
		if def.k_table2p >= 0 {
			if b == "" {
				return actor(act, k_all.ap_table[def.k_table2p], pcnt, arg, sact)
			}
			a2,b2 := split(b)
			return k_all.ap_table[def.k_table2p].doo(a2,b2, act, arg,lc,sact,pcnt)
		}
		return 0
	}
	if a == "field2" { // app.u:74, v_struct2.a:176
		if def.k_field2p >= 0 {
			if b == "" {
				return actor(act, k_all.ap_field[def.k_field2p], pcnt, arg, sact)
			} 
			a2,b2 := split(b)
			return k_all.ap_field[def.k_field2p].doo(a2,b2, act, arg,lc,sact,pcnt)
		}
		return 0
	}
	ok, val := def.get_var(a,'',lc)
	if ok == true {
		if val == b {
			return actor(act, def, pcnt, arg, sact)
		}
		return -1
	}
	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE  + "?")
	return 0
}
pub fn (def KpJoin) get_var(a string, b string, lc string) (bool, string)
{
	if b == '' {
		if val := def.names[ a ]
		{
			return true, val
		}
	}
	if a == "field1" { // app.u:72, v_struct2.a:264
		if def.k_field1p >= 0 {
			a2,b2 := split(b)
			return k_all.ap_field[def.k_field1p].get_var(a2,b2, lc)
		}
	}
	if a == "table2" { // app.u:73, v_struct2.a:264
		if def.k_table2p >= 0 {
			a2,b2 := split(b)
			return k_all.ap_table[def.k_table2p].get_var(a2,b2, lc)
		}
	}
	if a == "field2" { // app.u:74, v_struct2.a:275
		if def.k_field2p >= 0 {
			a2,b2 := split(b)
			return k_all.ap_field[def.k_field2p].get_var(a2,b2, lc)
		}
	}
	if a == "parent" { // app.u:41, v_struct2.a:206
		if def.parentp >= 0 {
			a2,b2 := split(b)
			return k_all.ap_table[def.parentp].get_var(a2,b2, lc )
		}
	}
	if b != '' {
		return false, "?" + a + '.' + b + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE  + "?"
}

