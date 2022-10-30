require "./*"

class ActT 
	property index : Hash(String, Int32) = Hash(String, Int32).new
	property ap_node : Array(KpNode) = Array(KpNode).new
	property ap_link : Array(KpLink) = Array(KpLink).new
	property ap_graph : Array(KpGraph) = Array(KpGraph).new
	property ap_matrix : Array(KpMatrix) = Array(KpMatrix).new
	property ap_table : Array(KpTable) = Array(KpTable).new
	property ap_field : Array(KpField) = Array(KpField).new
	property ap_attr : Array(KpAttr) = Array(KpAttr).new
	property ap_join : Array(KpJoin) = Array(KpJoin).new
	property ap_join2 : Array(KpJoin2) = Array(KpJoin2).new
	property ap_comp : Array(KpComp) = Array(KpComp).new
	property ap_token : Array(KpToken) = Array(KpToken).new
	property ap_star : Array(KpStar) = Array(KpStar).new
	property ap_element : Array(KpElement) = Array(KpElement).new
	property ap_opt : Array(KpOpt) = Array(KpOpt).new
	property ap_ref : Array(KpRef) = Array(KpRef).new
	property ap_ref2 : Array(KpRef2) = Array(KpRef2).new
	property ap_actor : Array(KpActor) = Array(KpActor).new
	property ap_all : Array(KpAll) = Array(KpAll).new
	property ap_du : Array(KpDu) = Array(KpDu).new
	property ap_set : Array(KpSet) = Array(KpSet).new
	property ap_its : Array(KpIts) = Array(KpIts).new
	property ap_c : Array(KpC) = Array(KpC).new
	property ap_cs : Array(KpCs) = Array(KpCs).new
	property ap_out : Array(KpOut) = Array(KpOut).new
	property ap_break : Array(KpBreak) = Array(KpBreak).new
	property ap_unique : Array(KpUnique) = Array(KpUnique).new
	property ap_collect : Array(KpCollect) = Array(KpCollect).new
	property ap_group : Array(KpGroup) = Array(KpGroup).new
	property ap_json : Array(KpJson) = Array(KpJson).new
end

def refs(act)
	act.ap_node.each_with_index do |st,i|
		st.k_parentp = fnd(act, "Node_" + st.names["parent"] , st.names["parent"],  ".", st.line_no )
	end
	act.ap_link.each_with_index do |st,i|
		st.k_top = fnd(act, "Node_" + st.names["to"] , st.names["to"],  ".", st.line_no )
	end
	act.ap_join.each_with_index do |st,i|
		st.k_field1p = fnd(act, st.parentp.to_s + "_Field_" + st.names["field1"] , st.names["field1"],  "check", st.line_no )
		st.k_table2p = fnd(act, "Table_" + st.names["table2"] , st.names["table2"],  ".", st.line_no )
		st.k_field2p = fnd(act, st.k_table2p.to_s + "_Field_" + st.names["field2"] , st.names["field2"],  "check", st.line_no )
	end
	act.ap_join2.each_with_index do |st,i|
		st.k_field1p = fnd(act, st.parentp.to_s + "_Field_" + st.names["field1"] , st.names["field1"],  "check", st.line_no )
		st.k_table2p = fnd(act, "Table_" + st.names["table2"] , st.names["table2"],  ".", st.line_no )
		st.k_field2p = fnd(act, st.k_table2p.to_s + "_Field_" + st.names["field2"] , st.names["field2"],  "check", st.line_no )
		st.k_attr2p = fnd(act, st.k_field2p.to_s + "_Attr_" + st.names["attr2"] , st.names["attr2"],  "check", st.line_no )
	end
	act.ap_comp.each_with_index do |st,i|
		st.k_parentp = fnd(act, "Comp_" + st.names["parent"] , st.names["parent"],  ".", st.line_no )
	end
	act.ap_ref.each_with_index do |st,i|
		st.k_elementp = fnd(act, st.parentp.to_s + "_Element_" + st.names["element"] , st.names["element"],  "check", st.line_no )
		st.k_compp = fnd(act, "Comp_" + st.names["comp"] , st.names["comp"],  ".", st.line_no )
	end
	act.ap_ref2.each_with_index do |st,i|
		st.k_elementp = fnd(act, st.parentp.to_s + "_Element_" + st.names["element"] , st.names["element"],  "check", st.line_no )
		st.k_compp = fnd(act, "Comp_" + st.names["comp"] , st.names["comp"],  ".", st.line_no )
		st.k_element2p = fnd(act, st.parentp.to_s + "_Element_" + st.names["element2"] , st.names["element2"],  "check", st.line_no )
	end
	act.ap_all.each_with_index do |st,i|
		st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
	end
	act.ap_du.each_with_index do |st,i|
		st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
	end
	act.ap_its.each_with_index do |st,i|
		st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
	end
end

def var_all(glob, va, lno) 
	if va.size < 3
		return(false, "?" + va.size.to_s + "<3?" + lno + "?")
	end
	if va[0] == "Node" # app.unit:2, c_run.act:118
		if en = glob.dats.index["Node_" + va[1] ]?
			return (glob.dats.ap_node[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Graph" # app.unit:23, c_run.act:118
		if en = glob.dats.index["Graph_" + va[1] ]?
			return (glob.dats.ap_graph[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Matrix" # app.unit:31, c_run.act:118
		if en = glob.dats.index["Matrix_" + va[1] ]?
			return (glob.dats.ap_matrix[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Table" # app.unit:41, c_run.act:118
		if en = glob.dats.index["Table_" + va[1] ]?
			return (glob.dats.ap_table[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Comp" # gen.unit:2, c_run.act:118
		if en = glob.dats.index["Comp_" + va[1] ]?
			return (glob.dats.ap_comp[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Actor" # act.unit:2, c_run.act:118
		if en = glob.dats.index["Actor_" + va[1] ]?
			return (glob.dats.ap_actor[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	return(false, "?" + va[0] + "?" + lno + "?")
end

def do_all(glob, va, lno)
	if va[0] == "Node" 
		glob.dats.ap_node.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Link" 
		glob.dats.ap_link.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Graph" 
		glob.dats.ap_graph.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Matrix" 
		glob.dats.ap_matrix.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Table" 
		glob.dats.ap_table.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Field" 
		glob.dats.ap_field.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Attr" 
		glob.dats.ap_attr.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Join" 
		glob.dats.ap_join.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Join2" 
		glob.dats.ap_join2.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Comp" 
		glob.dats.ap_comp.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Token" 
		glob.dats.ap_token.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Star" 
		glob.dats.ap_star.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Element" 
		glob.dats.ap_element.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Opt" 
		glob.dats.ap_opt.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Ref" 
		glob.dats.ap_ref.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Ref2" 
		glob.dats.ap_ref2.each do |st|
			ret = go_act(glob, st)
			if ret != 0
				return(ret)
			end
		end
		return(0)
	end
	if va[0] == "Actor" 
		glob.dats.ap_actor.each do |st|
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

def load(act, tok, ln, pos, lno)
	if tok == "Node"
		comp = KpNode.new
		comp.load(act, ln, pos, lno)
		act.ap_node << comp
	end
	if tok == "Link"
		comp = KpLink.new
		comp.load(act, ln, pos, lno)
		act.ap_link << comp
	end
	if tok == "Graph"
		comp = KpGraph.new
		comp.load(act, ln, pos, lno)
		act.ap_graph << comp
	end
	if tok == "Matrix"
		comp = KpMatrix.new
		comp.load(act, ln, pos, lno)
		act.ap_matrix << comp
	end
	if tok == "Table"
		comp = KpTable.new
		comp.load(act, ln, pos, lno)
		act.ap_table << comp
	end
	if tok == "Field"
		comp = KpField.new
		comp.load(act, ln, pos, lno)
		act.ap_field << comp
	end
	if tok == "Attr"
		comp = KpAttr.new
		comp.load(act, ln, pos, lno)
		act.ap_attr << comp
	end
	if tok == "Join"
		comp = KpJoin.new
		comp.load(act, ln, pos, lno)
		act.ap_join << comp
	end
	if tok == "Join2"
		comp = KpJoin2.new
		comp.load(act, ln, pos, lno)
		act.ap_join2 << comp
	end
	if tok == "Comp"
		comp = KpComp.new
		comp.load(act, ln, pos, lno)
		act.ap_comp << comp
	end
	if tok == "Token"
		comp = KpToken.new
		comp.load(act, ln, pos, lno)
		act.ap_token << comp
	end
	if tok == "Star"
		comp = KpStar.new
		comp.load(act, ln, pos, lno)
		act.ap_star << comp
	end
	if tok == "Element"
		comp = KpElement.new
		comp.load(act, ln, pos, lno)
		act.ap_element << comp
	end
	if tok == "Opt"
		comp = KpOpt.new
		comp.load(act, ln, pos, lno)
		act.ap_opt << comp
	end
	if tok == "Ref"
		comp = KpRef.new
		comp.load(act, ln, pos, lno)
		act.ap_ref << comp
	end
	if tok == "Ref2"
		comp = KpRef2.new
		comp.load(act, ln, pos, lno)
		act.ap_ref2 << comp
	end
	if tok == "Actor"
		comp = KpActor.new
		comp.load(act, ln, pos, lno)
		act.ap_actor << comp
	end
	if tok == "All"
		comp = KpAll.new
		comp.load(act, ln, pos, lno)
		act.ap_all << comp
	end
	if tok == "Du"
		comp = KpDu.new
		comp.load(act, ln, pos, lno)
		act.ap_du << comp
	end
	if tok == "Set"
		comp = KpSet.new
		comp.load(act, ln, pos, lno)
		act.ap_set << comp
	end
	if tok == "Its"
		comp = KpIts.new
		comp.load(act, ln, pos, lno)
		act.ap_its << comp
	end
	if tok == "C"
		comp = KpC.new
		comp.load(act, ln, pos, lno)
		act.ap_c << comp
	end
	if tok == "Cs"
		comp = KpCs.new
		comp.load(act, ln, pos, lno)
		act.ap_cs << comp
	end
	if tok == "Out"
		comp = KpOut.new
		comp.load(act, ln, pos, lno)
		act.ap_out << comp
	end
	if tok == "Break"
		comp = KpBreak.new
		comp.load(act, ln, pos, lno)
		act.ap_break << comp
	end
	if tok == "Unique"
		comp = KpUnique.new
		comp.load(act, ln, pos, lno)
		act.ap_unique << comp
	end
	if tok == "Collect"
		comp = KpCollect.new
		comp.load(act, ln, pos, lno)
		act.ap_collect << comp
	end
	if tok == "Group"
		comp = KpGroup.new
		comp.load(act, ln, pos, lno)
		act.ap_group << comp
	end
	if tok == "Json"
		comp = KpJson.new
		comp.load(act, ln, pos, lno)
		act.ap_json << comp
	end
end
