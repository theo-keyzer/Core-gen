require "./*"

class Kp
	property me : Int32 = -1
	property comp : String = "Kp"
	property line_no : String = ""
	property names : Hash(String, String) = Hash(String, String).new
	def do_its(glob, va, lno)
		puts("?No its " + va[0] + " cmd for Kp," + lno + "?");
		return(0)
	end

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Kp?");
	end
end

class KpNode < Kp 
	property k_parentp : Int32 = -1
	property itslink : Array(KpLink) = Array(KpLink).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Node"
		@line_no = lno
		@me = act.ap_node.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Node"
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["parent"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["eq"] = getw(ln, p)
		p, @names["value"] = getw(ln, p)
		act.index["Node_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # app.unit:12, c_struct.act:624
			if k_parentp >= 0 && va.size > 1
				return( glob.dats.ap_node[ k_parentp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "Node_parent" && va.size > 1 # app.unit:12, c_struct.act:719
			glob.dats.ap_node.each do |st|
				if st.k_parentp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Link_to" && va.size > 1 # app.unit:20, c_struct.act:719
			glob.dats.ap_link.each do |st|
				if st.k_top == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Link"  && va.size > 2 && itslink.size > 0 # app.unit:15, c_struct.act:439
			return (itslink[0].get_var(glob, va[1..], lno))
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Node?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Link" # app.unit:15, c_struct.act:698
			itslink.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "parent"
			if k_parentp >= 0
				st = glob.dats.ap_node[ k_parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Node_parent" # app.unit:12, c_struct.act:532
			glob.dats.ap_node.each do |st|
				if st.k_parentp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Link_to" # app.unit:20, c_struct.act:532
			glob.dats.ap_link.each do |st|
				if st.k_top == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:2, c_struct.act:149
			childs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Node," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpLink < Kp 
	property parentp : Int32 = -1
	property k_top : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Link"
		@line_no = lno
		@me = act.ap_link.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Link"
		p, @names["to"] = getw(ln, p)
		@parentp = act.ap_node.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Link has no Node parent" 
			return false
		end
		act.ap_node[ @parentp ].itslink << self
		act.ap_node[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "to" # app.unit:20, c_struct.act:624
			if k_top >= 0 && va.size > 1
				return( glob.dats.ap_node[ k_top ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_node[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Link?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # app.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_node[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "to"
			if k_top >= 0
				st = glob.dats.ap_node[ k_top ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:15, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Link," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpGraph < Kp 

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Graph"
		@line_no = lno
		@me = act.ap_graph.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Graph"
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["search"] = getws(ln, p)
		act.index["Graph_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Graph?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Child" # app.unit:23, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Graph," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpMatrix < Kp 

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Matrix"
		@line_no = lno
		@me = act.ap_matrix.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Matrix"
		p, @names["a"] = getw(ln, p)
		p, @names["b"] = getw(ln, p)
		p, @names["c"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["search"] = getw(ln, p)
		return true
	end

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Matrix?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Child" # app.unit:31, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Matrix," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpTable < Kp 
	property itsfield : Array(KpField) = Array(KpField).new
	property itsof : Array(KpOf) = Array(KpOf).new
	property itsjoin : Array(KpJoin) = Array(KpJoin).new
	property itsjoin2 : Array(KpJoin2) = Array(KpJoin2).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Table"
		@line_no = lno
		@me = act.ap_table.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Table"
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["value"] = getw(ln, p)
		act.index["Table_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "Join_table2" && va.size > 1 # app.unit:97, c_struct.act:719
			glob.dats.ap_join.each do |st|
				if st.k_table2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join2_table2" && va.size > 1 # app.unit:112, c_struct.act:719
			glob.dats.ap_join2.each do |st|
				if st.k_table2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Field"  && va.size > 2 # app.unit:53, c_struct.act:428
			if en = glob.dats.index[me.to_s + "_Field_" + va[1] ]?
				return (glob.dats.ap_field[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if va[0] == "Of"  && va.size > 2 && itsof.size > 0 # app.unit:71, c_struct.act:439
			return (itsof[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Join"  && va.size > 2 && itsjoin.size > 0 # app.unit:85, c_struct.act:439
			return (itsjoin[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Join2"  && va.size > 2 && itsjoin2.size > 0 # app.unit:101, c_struct.act:439
			return (itsjoin2[0].get_var(glob, va[1..], lno))
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Table?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Field" # app.unit:49, c_struct.act:698
			itsfield.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Of" # app.unit:71, c_struct.act:698
			itsof.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Join" # app.unit:85, c_struct.act:698
			itsjoin.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Join2" # app.unit:101, c_struct.act:698
			itsjoin2.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Join_table2" # app.unit:97, c_struct.act:532
			glob.dats.ap_join.each do |st|
				if st.k_table2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join2_table2" # app.unit:112, c_struct.act:532
			glob.dats.ap_join2.each do |st|
				if st.k_table2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:41, c_struct.act:149
			childs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Table," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpField < Kp 
	property parentp : Int32 = -1
	property k_typep : Int32 = -1
	property itsattrs : Array(KpAttrs) = Array(KpAttrs).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Field"
		@line_no = lno
		@me = act.ap_field.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Field"
		p, @names["type"] = getw(ln, p)
		p, @names["name"] = getw(ln, p)
		p, @names["dt"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["use"] = getw(ln, p)
		@parentp = act.ap_table.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Field has no Table parent" 
			return false
		end
		act.ap_table[ @parentp ].itsfield << self
		act.ap_table[ @parentp ].childs << self
		s = @parentp.to_s + "_Field_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "type" # app.unit:62, c_struct.act:624
			if k_typep >= 0 && va.size > 1
				return( glob.dats.ap_type[ k_typep ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_table[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Of_field" && va.size > 1 # app.unit:80, c_struct.act:719
			glob.dats.ap_of.each do |st|
				if st.k_fieldp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join_field1" && va.size > 1 # app.unit:96, c_struct.act:719
			glob.dats.ap_join.each do |st|
				if st.k_field1p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join2_field1" && va.size > 1 # app.unit:111, c_struct.act:719
			glob.dats.ap_join2.each do |st|
				if st.k_field1p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join_field2" && va.size > 1 # app.unit:98, c_struct.act:731
			glob.dats.ap_join.each do |st|
				if st.k_field2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join2_field2" && va.size > 1 # app.unit:113, c_struct.act:731
			glob.dats.ap_join2.each do |st|
				if st.k_field2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Attrs"  && va.size > 2 # app.unit:68, c_struct.act:428
			if en = glob.dats.index[me.to_s + "_Attrs_" + va[1] ]?
				return (glob.dats.ap_attrs[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Field?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Attrs" # app.unit:65, c_struct.act:698
			itsattrs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_table[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "type"
			if k_typep >= 0
				st = glob.dats.ap_type[ k_typep ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Of_field" # app.unit:80, c_struct.act:532
			glob.dats.ap_of.each do |st|
				if st.k_fieldp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join_field1" # app.unit:96, c_struct.act:532
			glob.dats.ap_join.each do |st|
				if st.k_field1p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join2_field1" # app.unit:111, c_struct.act:532
			glob.dats.ap_join2.each do |st|
				if st.k_field1p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join_field2" # app.unit:98, c_struct.act:555
			glob.dats.ap_join.each do |st|
				if st.k_field2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join2_field2" # app.unit:113, c_struct.act:555
			glob.dats.ap_join2.each do |st|
				if st.k_field2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:49, c_struct.act:149
			childs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Field," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpAttrs < Kp 
	property parentp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Attrs"
		@line_no = lno
		@me = act.ap_attrs.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Attrs"
		p, @names["name"] = getw(ln, p)
		@parentp = act.ap_field.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Attrs has no Field parent" 
			return false
		end
		act.ap_field[ @parentp ].itsattrs << self
		act.ap_field[ @parentp ].childs << self
		s = @parentp.to_s + "_Attrs_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # app.unit:49, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_field[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Join2_attr2" && va.size > 1 # app.unit:114, c_struct.act:731
			glob.dats.ap_join2.each do |st|
				if st.k_attr2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Attrs?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # app.unit:49, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_field[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Join2_attr2" # app.unit:114, c_struct.act:555
			glob.dats.ap_join2.each do |st|
				if st.k_attr2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:65, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Attrs," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpOf < Kp 
	property parentp : Int32 = -1
	property k_fieldp : Int32 = -1
	property k_attrp : Int32 = -1
	property k_fromp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Of"
		@line_no = lno
		@me = act.ap_of.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Of"
		p, @names["field"] = getw(ln, p)
		p, @names["attr"] = getw(ln, p)
		p, @names["from"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["value"] = getws(ln, p)
		@parentp = act.ap_table.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Of has no Table parent" 
			return false
		end
		act.ap_table[ @parentp ].itsof << self
		act.ap_table[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "field" # app.unit:80, c_struct.act:624
			if k_fieldp >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_fieldp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "attr" # app.unit:81, c_struct.act:644
			if k_attrp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "from" # app.unit:82, c_struct.act:644
			if k_fromp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_fromp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_table[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Of?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # app.unit:41, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_table[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "field"
			if k_fieldp >= 0
				st = glob.dats.ap_field[ k_fieldp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "attr"
			if k_attrp >= 0
				st = glob.dats.ap_attr[ k_attrp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "from"
			if k_fromp >= 0
				st = glob.dats.ap_attr[ k_fromp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:71, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Of," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpJoin < Kp 
	property parentp : Int32 = -1
	property k_field1p : Int32 = -1
	property k_table2p : Int32 = -1
	property k_field2p : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Join"
		@line_no = lno
		@me = act.ap_join.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Join"
		p, @names["field1"] = getw(ln, p)
		p, @names["table2"] = getw(ln, p)
		p, @names["field2"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["use"] = getw(ln, p)
		@parentp = act.ap_table.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Join has no Table parent" 
			return false
		end
		act.ap_table[ @parentp ].itsjoin << self
		act.ap_table[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "field1" # app.unit:96, c_struct.act:624
			if k_field1p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field1p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "table2" # app.unit:97, c_struct.act:624
			if k_table2p >= 0 && va.size > 1
				return( glob.dats.ap_table[ k_table2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "field2" # app.unit:98, c_struct.act:634
			if k_field2p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_table[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Join?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # app.unit:41, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_table[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "field1"
			if k_field1p >= 0
				st = glob.dats.ap_field[ k_field1p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "table2"
			if k_table2p >= 0
				st = glob.dats.ap_table[ k_table2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "field2"
			if k_field2p >= 0
				st = glob.dats.ap_field[ k_field2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:85, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Join," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
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
		@comp = "Join2"
		@line_no = lno
		@me = act.ap_join2.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Join2"
		p, @names["field1"] = getw(ln, p)
		p, @names["table2"] = getw(ln, p)
		p, @names["field2"] = getw(ln, p)
		p, @names["attr2"] = getw(ln, p)
		@parentp = act.ap_table.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Join2 has no Table parent" 
			return false
		end
		act.ap_table[ @parentp ].itsjoin2 << self
		act.ap_table[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "field1" # app.unit:111, c_struct.act:624
			if k_field1p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field1p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "table2" # app.unit:112, c_struct.act:624
			if k_table2p >= 0 && va.size > 1
				return( glob.dats.ap_table[ k_table2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "field2" # app.unit:113, c_struct.act:634
			if k_field2p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "attr2" # app.unit:114, c_struct.act:634
			if k_attr2p >= 0 && va.size > 1
				return( glob.dats.ap_attrs[ k_attr2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_table[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Join2?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # app.unit:41, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_table[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "field1"
			if k_field1p >= 0
				st = glob.dats.ap_field[ k_field1p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "table2"
			if k_table2p >= 0
				st = glob.dats.ap_table[ k_table2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "field2"
			if k_field2p >= 0
				st = glob.dats.ap_field[ k_field2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "attr2"
			if k_attr2p >= 0
				st = glob.dats.ap_attrs[ k_attr2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # app.unit:101, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Join2," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpType < Kp 
	property itsdata : Array(KpData) = Array(KpData).new
	property itsattr : Array(KpAttr) = Array(KpAttr).new
	property itswhere : Array(KpWhere) = Array(KpWhere).new
	property itslogic : Array(KpLogic) = Array(KpLogic).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Type"
		@line_no = lno
		@me = act.ap_type.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Type"
		p, @names["name"] = getw(ln, p)
		p, @names["desc"] = getws(ln, p)
		act.index["Type_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "Field_type" && va.size > 1 # app.unit:62, c_struct.act:719
			glob.dats.ap_field.each do |st|
				if st.k_typep == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Attr_table" && va.size > 1 # sample.unit:58, c_struct.act:719
			glob.dats.ap_attr.each do |st|
				if st.k_tablep == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Data"  && va.size > 2 && itsdata.size > 0 # sample.unit:13, c_struct.act:439
			return (itsdata[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Attr"  && va.size > 2 # sample.unit:51, c_struct.act:428
			if en = glob.dats.index[me.to_s + "_Attr_" + va[1] ]?
				return (glob.dats.ap_attr[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if va[0] == "Where"  && va.size > 2 && itswhere.size > 0 # sample.unit:61, c_struct.act:439
			return (itswhere[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Logic"  && va.size > 2 && itslogic.size > 0 # sample.unit:79, c_struct.act:439
			return (itslogic[0].get_var(glob, va[1..], lno))
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Type?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Data" # sample.unit:13, c_struct.act:698
			itsdata.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Attr" # sample.unit:24, c_struct.act:698
			itsattr.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Where" # sample.unit:61, c_struct.act:698
			itswhere.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Logic" # sample.unit:79, c_struct.act:698
			itslogic.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Field_type" # app.unit:62, c_struct.act:532
			glob.dats.ap_field.each do |st|
				if st.k_typep == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Attr_table" # sample.unit:58, c_struct.act:532
			glob.dats.ap_attr.each do |st|
				if st.k_tablep == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # sample.unit:2, c_struct.act:149
			childs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Type," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpData < Kp 
	property parentp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Data"
		@line_no = lno
		@me = act.ap_data.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Data"
		p, @names["name"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["value"] = getws(ln, p)
		@parentp = act.ap_type.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Data has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itsdata << self
		act.ap_type[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Data?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_type[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # sample.unit:13, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Data," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpAttr < Kp 
	property parentp : Int32 = -1
	property k_tablep : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Attr"
		@line_no = lno
		@me = act.ap_attr.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Attr"
		p, @names["table"] = getw(ln, p)
		p, @names["relation"] = getw(ln, p)
		p, @names["name"] = getw(ln, p)
		p, @names["mytype"] = getw(ln, p)
		p, @names["len"] = getw(ln, p)
		p, @names["null"] = getw(ln, p)
		p, @names["flags"] = getw(ln, p)
		p, @names["desc"] = getws(ln, p)
		@parentp = act.ap_type.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Attr has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itsattr << self
		act.ap_type[ @parentp ].childs << self
		s = @parentp.to_s + "_Attr_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "table" # sample.unit:58, c_struct.act:624
			if k_tablep >= 0 && va.size > 1
				return( glob.dats.ap_type[ k_tablep ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # sample.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Where_attr" && va.size > 1 # sample.unit:74, c_struct.act:719
			glob.dats.ap_where.each do |st|
				if st.k_attrp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Where_id" && va.size > 1 # sample.unit:75, c_struct.act:719
			glob.dats.ap_where.each do |st|
				if st.k_idp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Logic_attr" && va.size > 1 # sample.unit:92, c_struct.act:719
			glob.dats.ap_logic.each do |st|
				if st.k_attrp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Of_attr" && va.size > 1 # app.unit:81, c_struct.act:743
			glob.dats.ap_of.each do |st|
				if st.k_attrp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Of_from" && va.size > 1 # app.unit:82, c_struct.act:743
			glob.dats.ap_of.each do |st|
				if st.k_fromp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Where_from_id" && va.size > 1 # sample.unit:76, c_struct.act:743
			glob.dats.ap_where.each do |st|
				if st.k_from_idp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Attr?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_type[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "table"
			if k_tablep >= 0
				st = glob.dats.ap_type[ k_tablep ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Where_attr" # sample.unit:74, c_struct.act:532
			glob.dats.ap_where.each do |st|
				if st.k_attrp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Where_id" # sample.unit:75, c_struct.act:532
			glob.dats.ap_where.each do |st|
				if st.k_idp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Logic_attr" # sample.unit:92, c_struct.act:532
			glob.dats.ap_logic.each do |st|
				if st.k_attrp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Of_attr" # app.unit:81, c_struct.act:578
			glob.dats.ap_of.each do |st|
				if st.k_attrp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Of_from" # app.unit:82, c_struct.act:578
			glob.dats.ap_of.each do |st|
				if st.k_fromp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Where_from_id" # sample.unit:76, c_struct.act:578
			glob.dats.ap_where.each do |st|
				if st.k_from_idp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # sample.unit:24, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Attr," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpWhere < Kp 
	property parentp : Int32 = -1
	property k_attrp : Int32 = -1
	property k_from_idp : Int32 = -1
	property k_idp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Where"
		@line_no = lno
		@me = act.ap_where.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Where"
		p, @names["attr"] = getw(ln, p)
		p, @names["from_id"] = getw(ln, p)
		p, @names["eq"] = getw(ln, p)
		p, @names["id"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["value"] = getws(ln, p)
		@parentp = act.ap_type.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Where has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itswhere << self
		act.ap_type[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "attr" # sample.unit:74, c_struct.act:624
			if k_attrp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "id" # sample.unit:75, c_struct.act:624
			if k_idp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_idp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "from_id" # sample.unit:76, c_struct.act:644
			if k_from_idp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_from_idp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # sample.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Where?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_type[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "attr"
			if k_attrp >= 0
				st = glob.dats.ap_attr[ k_attrp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "id"
			if k_idp >= 0
				st = glob.dats.ap_attr[ k_idp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "from_id"
			if k_from_idp >= 0
				st = glob.dats.ap_attr[ k_from_idp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # sample.unit:61, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Where," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpLogic < Kp 
	property parentp : Int32 = -1
	property k_attrp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Logic"
		@line_no = lno
		@me = act.ap_logic.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Logic"
		p, @names["attr"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["code"] = getw(ln, p)
		@parentp = act.ap_type.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Logic has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itslogic << self
		act.ap_type[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "attr" # sample.unit:92, c_struct.act:624
			if k_attrp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # sample.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Logic?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_type[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "attr"
			if k_attrp >= 0
				st = glob.dats.ap_attr[ k_attrp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # sample.unit:79, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Logic," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpComp < Kp 
	property k_parentp : Int32 = -1
	property itstoken : Array(KpToken) = Array(KpToken).new
	property itselement : Array(KpElement) = Array(KpElement).new
	property itsref : Array(KpRef) = Array(KpRef).new
	property itsref2 : Array(KpRef2) = Array(KpRef2).new
	property itsref3 : Array(KpRef3) = Array(KpRef3).new
	property itsrefq : Array(KpRefq) = Array(KpRefq).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Comp"
		@line_no = lno
		@me = act.ap_comp.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Comp"
		p, @names["name"] = getw(ln, p)
		p, @names["nop"] = getw(ln, p)
		p, @names["parent"] = getw(ln, p)
		p, @names["find"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		act.index["Comp_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:16, c_struct.act:624
			if k_parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "Comp_parent" && va.size > 1 # gen.unit:16, c_struct.act:719
			glob.dats.ap_comp.each do |st|
				if st.k_parentp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref_comp" && va.size > 1 # gen.unit:83, c_struct.act:719
			glob.dats.ap_ref.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_comp" && va.size > 1 # gen.unit:101, c_struct.act:719
			glob.dats.ap_ref2.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_comp" && va.size > 1 # gen.unit:122, c_struct.act:719
			glob.dats.ap_ref3.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_comp_ref" && va.size > 1 # gen.unit:123, c_struct.act:719
			glob.dats.ap_ref3.each do |st|
				if st.k_comp_refp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Refq_comp" && va.size > 1 # gen.unit:144, c_struct.act:719
			glob.dats.ap_refq.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Refq_comp_ref" && va.size > 1 # gen.unit:145, c_struct.act:719
			glob.dats.ap_refq.each do |st|
				if st.k_comp_refp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Token"  && va.size > 2 && itstoken.size > 0 # gen.unit:19, c_struct.act:439
			return (itstoken[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Element"  && va.size > 2 # gen.unit:42, c_struct.act:428
			if en = glob.dats.index[me.to_s + "_Element_" + va[1] ]?
				return (glob.dats.ap_element[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if va[0] == "Ref"  && va.size > 2 && itsref.size > 0 # gen.unit:68, c_struct.act:439
			return (itsref[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Ref2"  && va.size > 2 && itsref2.size > 0 # gen.unit:86, c_struct.act:439
			return (itsref2[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Ref3"  && va.size > 2 && itsref3.size > 0 # gen.unit:105, c_struct.act:439
			return (itsref3[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Refq"  && va.size > 2 && itsrefq.size > 0 # gen.unit:127, c_struct.act:439
			return (itsrefq[0].get_var(glob, va[1..], lno))
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Token" # gen.unit:19, c_struct.act:698
			itstoken.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Element" # gen.unit:37, c_struct.act:698
			itselement.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Ref" # gen.unit:68, c_struct.act:698
			itsref.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Ref2" # gen.unit:86, c_struct.act:698
			itsref2.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Ref3" # gen.unit:105, c_struct.act:698
			itsref3.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Refq" # gen.unit:127, c_struct.act:698
			itsrefq.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "parent"
			if k_parentp >= 0
				st = glob.dats.ap_comp[ k_parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Comp_parent" # gen.unit:16, c_struct.act:532
			glob.dats.ap_comp.each do |st|
				if st.k_parentp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref_comp" # gen.unit:83, c_struct.act:532
			glob.dats.ap_ref.each do |st|
				if st.k_compp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref2_comp" # gen.unit:101, c_struct.act:532
			glob.dats.ap_ref2.each do |st|
				if st.k_compp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref3_comp" # gen.unit:122, c_struct.act:532
			glob.dats.ap_ref3.each do |st|
				if st.k_compp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref3_comp_ref" # gen.unit:123, c_struct.act:532
			glob.dats.ap_ref3.each do |st|
				if st.k_comp_refp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Refq_comp" # gen.unit:144, c_struct.act:532
			glob.dats.ap_refq.each do |st|
				if st.k_compp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Refq_comp_ref" # gen.unit:145, c_struct.act:532
			glob.dats.ap_refq.each do |st|
				if st.k_comp_refp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:2, c_struct.act:149
			childs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Comp," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpToken < Kp 
	property parentp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Token"
		@line_no = lno
		@me = act.ap_token.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Token"
		p, @names["token"] = getw(ln, p)
		@parentp = act.ap_comp.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Token has no Comp parent" 
			return false
		end
		act.ap_comp[ @parentp ].itstoken << self
		act.ap_comp[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Token?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:19, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Token," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpStar < Kp 

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Star"
		@line_no = lno
		@me = act.ap_star.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Star"
		p, @names["doc"] = getws(ln, p)
		return true
	end

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Star?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Child" # gen.unit:27, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Star," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpElement < Kp 
	property parentp : Int32 = -1
	property itsopt : Array(KpOpt) = Array(KpOpt).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Element"
		@line_no = lno
		@me = act.ap_element.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Element"
		p, @names["name"] = getw(ln, p)
		p, @names["mw"] = getw(ln, p)
		p, @names["mw2"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Element has no Comp parent" 
			return false
		end
		act.ap_comp[ @parentp ].itselement << self
		act.ap_comp[ @parentp ].childs << self
		s = @parentp.to_s + "_Element_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Ref_element" && va.size > 1 # gen.unit:82, c_struct.act:719
			glob.dats.ap_ref.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_element" && va.size > 1 # gen.unit:100, c_struct.act:719
			glob.dats.ap_ref2.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_element2" && va.size > 1 # gen.unit:102, c_struct.act:719
			glob.dats.ap_ref2.each do |st|
				if st.k_element2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_element" && va.size > 1 # gen.unit:121, c_struct.act:719
			glob.dats.ap_ref3.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_element2" && va.size > 1 # gen.unit:124, c_struct.act:719
			glob.dats.ap_ref3.each do |st|
				if st.k_element2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Refq_element" && va.size > 1 # gen.unit:143, c_struct.act:719
			glob.dats.ap_refq.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Opt"  && va.size > 2 # gen.unit:63, c_struct.act:428
			if en = glob.dats.index[me.to_s + "_Opt_" + va[1] ]?
				return (glob.dats.ap_opt[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Element?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Opt" # gen.unit:57, c_struct.act:698
			itsopt.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Ref_element" # gen.unit:82, c_struct.act:532
			glob.dats.ap_ref.each do |st|
				if st.k_elementp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref2_element" # gen.unit:100, c_struct.act:532
			glob.dats.ap_ref2.each do |st|
				if st.k_elementp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref2_element2" # gen.unit:102, c_struct.act:532
			glob.dats.ap_ref2.each do |st|
				if st.k_element2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref3_element" # gen.unit:121, c_struct.act:532
			glob.dats.ap_ref3.each do |st|
				if st.k_elementp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref3_element2" # gen.unit:124, c_struct.act:532
			glob.dats.ap_ref3.each do |st|
				if st.k_element2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Refq_element" # gen.unit:143, c_struct.act:532
			glob.dats.ap_refq.each do |st|
				if st.k_elementp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret != 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret != 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:37, c_struct.act:149
			childs.each do |st|
				if va.size > 1
					ret = st.do_its(glob, va[1..], lno)
					if ret != 0
						return(ret)
					end
					next
				end
				ret = go_act(glob, st)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Element," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpOpt < Kp 
	property parentp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Opt"
		@line_no = lno
		@me = act.ap_opt.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Opt"
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_element.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Opt has no Element parent" 
			return false
		end
		act.ap_element[ @parentp ].itsopt << self
		act.ap_element[ @parentp ].childs << self
		s = @parentp.to_s + "_Opt_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:37, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_element[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Opt?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # gen.unit:37, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_element[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:57, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Opt," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpRef < Kp 
	property parentp : Int32 = -1
	property k_elementp : Int32 = -1
	property k_compp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Ref"
		@line_no = lno
		@me = act.ap_ref.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Ref"
		p, @names["element"] = getw(ln, p)
		p, @names["comp"] = getw(ln, p)
		p, @names["opt"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Ref has no Comp parent" 
			return false
		end
		act.ap_comp[ @parentp ].itsref << self
		act.ap_comp[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "element" # gen.unit:82, c_struct.act:624
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:83, c_struct.act:624
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "element"
			if k_elementp >= 0
				st = glob.dats.ap_element[ k_elementp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "comp"
			if k_compp >= 0
				st = glob.dats.ap_comp[ k_compp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:68, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Ref," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpRef2 < Kp 
	property parentp : Int32 = -1
	property k_elementp : Int32 = -1
	property k_compp : Int32 = -1
	property k_element2p : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Ref2"
		@line_no = lno
		@me = act.ap_ref2.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Ref2"
		p, @names["element"] = getw(ln, p)
		p, @names["comp"] = getw(ln, p)
		p, @names["element2"] = getw(ln, p)
		p, @names["opt"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Ref2 has no Comp parent" 
			return false
		end
		act.ap_comp[ @parentp ].itsref2 << self
		act.ap_comp[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "element" # gen.unit:100, c_struct.act:624
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:101, c_struct.act:624
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "element2" # gen.unit:102, c_struct.act:624
			if k_element2p >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref2?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "element"
			if k_elementp >= 0
				st = glob.dats.ap_element[ k_elementp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "comp"
			if k_compp >= 0
				st = glob.dats.ap_comp[ k_compp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "element2"
			if k_element2p >= 0
				st = glob.dats.ap_element[ k_element2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:86, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Ref2," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpRef3 < Kp 
	property parentp : Int32 = -1
	property k_elementp : Int32 = -1
	property k_compp : Int32 = -1
	property k_element2p : Int32 = -1
	property k_comp_refp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Ref3"
		@line_no = lno
		@me = act.ap_ref3.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Ref3"
		p, @names["element"] = getw(ln, p)
		p, @names["comp"] = getw(ln, p)
		p, @names["element2"] = getw(ln, p)
		p, @names["comp_ref"] = getw(ln, p)
		p, @names["element3"] = getw(ln, p)
		p, @names["opt"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Ref3 has no Comp parent" 
			return false
		end
		act.ap_comp[ @parentp ].itsref3 << self
		act.ap_comp[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "element" # gen.unit:121, c_struct.act:624
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:122, c_struct.act:624
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp_ref" # gen.unit:123, c_struct.act:624
			if k_comp_refp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "element2" # gen.unit:124, c_struct.act:624
			if k_element2p >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Ref3?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "element"
			if k_elementp >= 0
				st = glob.dats.ap_element[ k_elementp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "comp"
			if k_compp >= 0
				st = glob.dats.ap_comp[ k_compp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "comp_ref"
			if k_comp_refp >= 0
				st = glob.dats.ap_comp[ k_comp_refp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "element2"
			if k_element2p >= 0
				st = glob.dats.ap_element[ k_element2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:105, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Ref3," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpRefq < Kp 
	property parentp : Int32 = -1
	property k_elementp : Int32 = -1
	property k_compp : Int32 = -1
	property k_comp_refp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Refq"
		@line_no = lno
		@me = act.ap_refq.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Refq"
		p, @names["element"] = getw(ln, p)
		p, @names["comp"] = getw(ln, p)
		p, @names["element2"] = getw(ln, p)
		p, @names["comp_ref"] = getw(ln, p)
		p, @names["opt"] = getw(ln, p)
		p, @names["var"] = getw(ln, p)
		p, @names["doc"] = getws(ln, p)
		@parentp = act.ap_comp.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Refq has no Comp parent" 
			return false
		end
		act.ap_comp[ @parentp ].itsrefq << self
		act.ap_comp[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "element" # gen.unit:143, c_struct.act:624
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:144, c_struct.act:624
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp_ref" # gen.unit:145, c_struct.act:624
			if k_comp_refp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:522
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Refq?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:507
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "element"
			if k_elementp >= 0
				st = glob.dats.ap_element[ k_elementp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "comp"
			if k_compp >= 0
				st = glob.dats.ap_comp[ k_compp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "comp_ref"
			if k_comp_refp >= 0
				st = glob.dats.ap_comp[ k_comp_refp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:127, c_struct.act:149
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Refq," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
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
		@comp = "Actor"
		@line_no = lno
		@me = act.ap_actor.size
		p, @k_name = getw(ln, p)
		p, @k_comp = getw(ln, p)
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getw(ln, p)
		p, @k_cc = getws(ln, p)
		act.index["Actor_" + @k_name] = @me
		return true
	end
end

class KpDbcreate < Kp 
	property parentp : Int32 = -1
	property k_where : String = ""
	property k_tbl : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Dbcreate"
		@line_no = lno
		@me = act.ap_dbcreate.size
		p, @k_where = getw(ln, p)
		p, @k_tbl = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Dbcreate has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpDbload < Kp 
	property parentp : Int32 = -1
	property k_where : String = ""
	property k_tbl : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Dbload"
		@line_no = lno
		@me = act.ap_dbload.size
		p, @k_where = getw(ln, p)
		p, @k_tbl = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Dbload has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpDbselect < Kp 
	property parentp : Int32 = -1
	property k_actor : String = ""
	property k_where : String = ""
	property k_what : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Dbselect"
		@line_no = lno
		@me = act.ap_dbselect.size
		p, @k_actor = getw(ln, p)
		p, @k_where = getw(ln, p)
		p, @k_what = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Dbselect has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpAll < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property k_actor : String = ""
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property k_args : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "All"
		@line_no = lno
		@me = act.ap_all.size
		p, @k_what = getw(ln, p)
		p, @k_actor = getw(ln, p)
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getw(ln, p)
		p, @k_args = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " All has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpDu < Kp 
	property parentp : Int32 = -1
	property k_actor : String = ""
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property k_args : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Du"
		@line_no = lno
		@me = act.ap_du.size
		p, @k_actor = getw(ln, p)
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getw(ln, p)
		p, @k_args = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Du has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpNew < Kp 
	property parentp : Int32 = -1
	property k_where : String = ""
	property k_what : String = ""
	property k_line : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "New"
		@line_no = lno
		@me = act.ap_new.size
		p, @k_where = getw(ln, p)
		p, @k_what = getw(ln, p)
		p, @k_line = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " New has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpRefs < Kp 
	property parentp : Int32 = -1
	property k_where : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Refs"
		@line_no = lno
		@me = act.ap_refs.size
		p, @k_where = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Refs has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpVar < Kp 
	property parentp : Int32 = -1
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Var"
		@line_no = lno
		@me = act.ap_var.size
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Var has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpIts < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property k_actor : String = ""
	property k_attr : String = ""
	property k_eq : String = ""
	property k_value : String = ""
	property k_args : String = ""
	property k_actorp : Int32 = -1
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Its"
		@line_no = lno
		@me = act.ap_its.size
		p, @k_what = getw(ln, p)
		p, @k_actor = getw(ln, p)
		p, @k_attr = getw(ln, p)
		p, @k_eq = getw(ln, p)
		p, @k_value = getw(ln, p)
		p, @k_args = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Its has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpC < Kp 
	property parentp : Int32 = -1
	property k_desc : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "C"
		@line_no = lno
		@me = act.ap_c.size
		p, @k_desc = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " C has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpCs < Kp 
	property parentp : Int32 = -1
	property k_desc : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Cs"
		@line_no = lno
		@me = act.ap_cs.size
		p, @k_desc = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Cs has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpInclude < Kp 
	property parentp : Int32 = -1
	property k_opt : String = ""
	property k_file : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Include"
		@line_no = lno
		@me = act.ap_include.size
		p, @k_opt = getw(ln, p)
		p, @k_file = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Include has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
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
		@comp = "Out"
		@line_no = lno
		@me = act.ap_out.size
		p, @k_what = getw(ln, p)
		p, @k_pad = getw(ln, p)
		p, @k_desc = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Out has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpBreak < Kp 
	property parentp : Int32 = -1
	property k_what : String = ""
	property k_on : String = ""
	property k_vars : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Break"
		@line_no = lno
		@me = act.ap_break.size
		p, @k_what = getw(ln, p)
		p, @k_on = getw(ln, p)
		p, @k_vars = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Break has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
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
		@comp = "Unique"
		@line_no = lno
		@me = act.ap_unique.size
		p, @k_cmd = getw(ln, p)
		p, @k_key = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Unique has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpCollect < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Collect"
		@line_no = lno
		@me = act.ap_collect.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Collect has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpHash < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property k_key : String = ""
	property k_value : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Hash"
		@line_no = lno
		@me = act.ap_hash.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_key = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Hash has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
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
		@comp = "Group"
		@line_no = lno
		@me = act.ap_group.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_key = getw(ln, p)
		p, @k_value = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Group has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
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
		@comp = "Json"
		@line_no = lno
		@me = act.ap_json.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_file = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Json has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpYaml < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property k_file : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Yaml"
		@line_no = lno
		@me = act.ap_yaml.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_file = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Yaml has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

class KpXml < Kp 
	property parentp : Int32 = -1
	property k_cmd : String = ""
	property k_pocket : String = ""
	property k_file : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Xml"
		@line_no = lno
		@me = act.ap_xml.size
		p, @k_cmd = getw(ln, p)
		p, @k_pocket = getw(ln, p)
		p, @k_file = getws(ln, p)
		@parentp = act.ap_actor.size-1;
		if @parentp < 0  
			puts lno + " Xml has no Actor parent" 
			return false
		end
		act.ap_actor[ @parentp ].childs << self
		return true
	end
end

