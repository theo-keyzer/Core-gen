require "./*"

class Kp
	property me : Int32 = -1
	property line_no : String = ""
	property names : Hash(String, String) = Hash(String, String).new
end

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



class KpNode < Kp 
	property k_parentp : Int32 = -1
	property itslink : Array(KpLink) = Array(KpLink).new
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_node.size
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["parent"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["eq"] = getw(ln, p)
		p, @names["value"] = getw(ln, p)
		act.index["Node_" + @names["name"]] = @me
	end

end

class KpLink < Kp 
	property parentp : Int32 = -1
	property k_top : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_link.size
		p, @names["to"] = getw(ln, p)
		@parentp = act.ap_node.size-1;
		if @parentp < 0  
			puts lno + " Link has no Node parent" 
			return
		end
		act.ap_node[ @parentp ].itslink << self
		act.ap_node[ @parentp ].childs << self
	end

end

class KpGraph < Kp 
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_graph.size
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["search"] = getws(ln, p)
		act.index["Graph_" + @names["name"]] = @me
	end

end

class KpMatrix < Kp 
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_matrix.size
		p, @names["a"] = getw(ln, p)
		p, @names["b"] = getw(ln, p)
		p, @names["c"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["search"] = getw(ln, p)
	end

end

class KpTable < Kp 
	property itsfield : Array(KpField) = Array(KpField).new
	property itsjoin : Array(KpJoin) = Array(KpJoin).new
	property itsjoin2 : Array(KpJoin2) = Array(KpJoin2).new
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_table.size
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["value"] = getw(ln, p)
		act.index["Table_" + @names["name"]] = @me
	end

end

class KpField < Kp 
	property parentp : Int32 = -1
	property itsattr : Array(KpAttr) = Array(KpAttr).new
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_field.size
		p, @names["name"] = getw(ln, p)
		p, @names["dt"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["use"] = getw(ln, p)
		@parentp = act.ap_table.size-1;
		if @parentp < 0  
			puts lno + " Field has no Table parent" 
			return
		end
		act.ap_table[ @parentp ].itsfield << self
		act.ap_table[ @parentp ].childs << self
		s = @parentp.to_s + "_Field_" + @names["name"]
		act.index[s] = @me
	end

end

class KpAttr < Kp 
	property parentp : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_attr.size
		p, @names["name"] = getw(ln, p)
		@parentp = act.ap_field.size-1;
		if @parentp < 0  
			puts lno + " Attr has no Field parent" 
			return
		end
		act.ap_field[ @parentp ].itsattr << self
		act.ap_field[ @parentp ].childs << self
		s = @parentp.to_s + "_Attr_" + @names["name"]
		act.index[s] = @me
	end

end

class KpJoin < Kp 
	property parentp : Int32 = -1
	property k_field1p : Int32 = -1
	property k_table2p : Int32 = -1
	property k_field2p : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_join.size
		p, @names["field1"] = getw(ln, p)
		p, @names["table2"] = getw(ln, p)
		p, @names["field2"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["use"] = getw(ln, p)
		@parentp = act.ap_table.size-1;
		if @parentp < 0  
			puts lno + " Join has no Table parent" 
			return
		end
		act.ap_table[ @parentp ].itsjoin << self
		act.ap_table[ @parentp ].childs << self
	end

end

class KpJoin2 < Kp 
	property parentp : Int32 = -1
	property k_field1p : Int32 = -1
	property k_table2p : Int32 = -1
	property k_field2p : Int32 = -1
	property k_attr2p : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_join2.size
		p, @names["field1"] = getw(ln, p)
		p, @names["table2"] = getw(ln, p)
		p, @names["field2"] = getw(ln, p)
		p, @names["attr2"] = getw(ln, p)
		@parentp = act.ap_table.size-1;
		if @parentp < 0  
			puts lno + " Join2 has no Table parent" 
			return
		end
		act.ap_table[ @parentp ].itsjoin2 << self
		act.ap_table[ @parentp ].childs << self
	end

end

class KpComp < Kp 
	property k_parentp : Int32 = -1
	property itstoken : Array(KpToken) = Array(KpToken).new
	property itselement : Array(KpElement) = Array(KpElement).new
	property itsref : Array(KpRef) = Array(KpRef).new
	property itsref2 : Array(KpRef2) = Array(KpRef2).new
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_comp.size
		p, @names["name"] = getw(ln, p)
		p, @names["nop"] = getw(ln, p)
		p, @names["parent"] = getw(ln, p)
		p, @names["find"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		act.index["Comp_" + @names["name"]] = @me
	end

end

class KpToken < Kp 
	property parentp : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_token.size
		p, @names["token"] = getw(ln, p)
		@parentp = act.ap_comp.size-1;
		if @parentp < 0  
			puts lno + " Token has no Comp parent" 
			return
		end
		act.ap_comp[ @parentp ].itstoken << self
		act.ap_comp[ @parentp ].childs << self
	end

end

class KpStar < Kp 
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_star.size
		p, @names["doc"] = getws(ln, p)
	end

end

class KpElement < Kp 
	property parentp : Int32 = -1
	property itsopt : Array(KpOpt) = Array(KpOpt).new
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_element.size
		p, @names["name"] = getw(ln, p)
		p, @names["mw"] = getw(ln, p)
		p, @names["mw2"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		if @parentp < 0  
			puts lno + " Element has no Comp parent" 
			return
		end
		act.ap_comp[ @parentp ].itselement << self
		act.ap_comp[ @parentp ].childs << self
		s = @parentp.to_s + "_Element_" + @names["name"]
		act.index[s] = @me
	end

end

class KpOpt < Kp 
	property parentp : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_opt.size
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_element.size-1;
		if @parentp < 0  
			puts lno + " Opt has no Element parent" 
			return
		end
		act.ap_element[ @parentp ].itsopt << self
		act.ap_element[ @parentp ].childs << self
		s = @parentp.to_s + "_Opt_" + @names["name"]
		act.index[s] = @me
	end

end

class KpRef < Kp 
	property parentp : Int32 = -1
	property k_elementp : Int32 = -1
	property k_compp : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_ref.size
		p, @names["element"] = getw(ln, p)
		p, @names["comp"] = getw(ln, p)
		p, @names["opt"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		if @parentp < 0  
			puts lno + " Ref has no Comp parent" 
			return
		end
		act.ap_comp[ @parentp ].itsref << self
		act.ap_comp[ @parentp ].childs << self
	end

end

class KpRef2 < Kp 
	property parentp : Int32 = -1
	property k_elementp : Int32 = -1
	property k_compp : Int32 = -1
	property k_element2p : Int32 = -1
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_ref2.size
		p, @names["element"] = getw(ln, p)
		p, @names["comp"] = getw(ln, p)
		p, @names["element2"] = getw(ln, p)
		p, @names["opt"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		if @parentp < 0  
			puts lno + " Ref2 has no Comp parent" 
			return
		end
		act.ap_comp[ @parentp ].itsref2 << self
		act.ap_comp[ @parentp ].childs << self
	end

end

class KpActor < Kp 
	property k_name : String = ""
	property k_comp : String = ""
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property k_cc : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_actor.size
		p, @k_name = getw(ln, p)
		p, @k_comp = getw(ln, p)
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getw(ln, p)
		p, @k_cc = getws(ln, p)
		act.index["Actor_" + @k_name] = @me
	end
end

class KpAll < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property k_actor : String = ""
	property k_args : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_all.size
		p, @k_what = getw(ln, p)
		p, @k_actor = getw(ln, p)
		p, @k_args = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " All has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpDu < Kp 
	property parentp : Int32 = -1
	property k_actor : String = ""
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_du.size
		p, @k_actor = getw(ln, p)
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Du has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpSet < Kp 
	property parentp : Int32 = -1
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_set.size
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Set has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpIts < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property k_actor : String = ""
	property k_args : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_its.size
		p, @k_what = getw(ln, p)
		p, @k_actor = getw(ln, p)
		p, @k_args = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Its has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpC < Kp 
	property parentp : Int32 = -1
	property k_desc : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_c.size
		p, @k_desc = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " C has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpCs < Kp 
	property parentp : Int32 = -1
	property k_desc : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_cs.size
		p, @k_desc = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Cs has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpOut < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property k_pad : String = ""
	property k_desc : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_out.size
		p, @k_what = getw(ln, p)
		p, @k_pad = getw(ln, p)
		p, @k_desc = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Out has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpBreak < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_break.size
		p, @k_what = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Break has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpUnique < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_key : String = ""
	property k_value : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_unique.size
		p, @k_cmd = getw(ln, p)
		p, @k_key = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Unique has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpCollect < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_collect.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Collect has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpGroup < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property k_key : String = ""
	property k_value : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_group.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_key = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Group has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

class KpJson < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property k_file : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_json.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_file = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Json has no Actor parent" 
			return
		end
		act.ap_actor[ @parentp ].childs << self
	end
end

