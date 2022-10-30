require "./*"

class Kp
	property me : Int32 = -1
	property line_no : String = ""
	property names : Hash(String, String) = Hash(String, String).new
	def do_its(glob, va, lno)
		puts "Its kp"
		return(0)
	end
	def get_var(glob, va, lno)
		return(false, "Var Kp")
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # app.unit:12, c_struct.act:348
			if k_parentp >= 0 && va.size > 1
				return( glob.dats.ap_node[ k_parentp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "Node_parent" && va.size > 1 # app.unit:12, c_struct.act:417
			glob.dats.ap_node.each do |st|
				if st.k_parentp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Link_to" && va.size > 1 # app.unit:20, c_struct.act:417
			glob.dats.ap_link.each do |st|
				if st.k_top == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Node?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Link" # app.unit:15, c_struct.act:403
			itslink.each do |st|
				ret = go_act(glob, st)
				if ret > 0
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
		if va[0] == "Node_parent" # app.unit:12, c_struct.act:302
			glob.dats.ap_node.each do |st|
				if st.k_parentp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Link_to" # app.unit:20, c_struct.act:302
			glob.dats.ap_link.each do |st|
				if st.k_top == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Node," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "to" # app.unit:20, c_struct.act:348
			if k_top >= 0 && va.size > 1
				return( glob.dats.ap_node[ k_top ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:2, c_struct.act:292
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
		if va[0] == "parent" # app.unit:2, c_struct.act:277
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
		puts("?No its " + va[0] + " cmd for Link," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Graph?");
	end

	def do_its(glob, va, lno)
		puts("?No its " + va[0] + " cmd for Graph," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Matrix?");
	end

	def do_its(glob, va, lno)
		puts("?No its " + va[0] + " cmd for Matrix," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "Join_table2" && va.size > 1 # app.unit:80, c_struct.act:417
			glob.dats.ap_join.each do |st|
				if st.k_table2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join2_table2" && va.size > 1 # app.unit:95, c_struct.act:417
			glob.dats.ap_join2.each do |st|
				if st.k_table2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Field"  && va.size > 2 # app.unit:52, c_struct.act:236
			if en = glob.dats.index[me.to_s + "_Field_" + va[1] ]?
				return (glob.dats.ap_field[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Table?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Field" # app.unit:49, c_struct.act:403
			itsfield.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Join" # app.unit:68, c_struct.act:403
			itsjoin.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Join2" # app.unit:84, c_struct.act:403
			itsjoin2.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Join_table2" # app.unit:80, c_struct.act:302
			glob.dats.ap_join.each do |st|
				if st.k_table2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join2_table2" # app.unit:95, c_struct.act:302
			glob.dats.ap_join2.each do |st|
				if st.k_table2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Table," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # app.unit:41, c_struct.act:292
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_table[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Join_field1" && va.size > 1 # app.unit:79, c_struct.act:417
			glob.dats.ap_join.each do |st|
				if st.k_field1p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join2_field1" && va.size > 1 # app.unit:94, c_struct.act:417
			glob.dats.ap_join2.each do |st|
				if st.k_field1p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join_field2" && va.size > 1 # app.unit:81, c_struct.act:429
			glob.dats.ap_join.each do |st|
				if st.k_field2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Join2_field2" && va.size > 1 # app.unit:96, c_struct.act:429
			glob.dats.ap_join2.each do |st|
				if st.k_field2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Attr"  && va.size > 2 # app.unit:65, c_struct.act:236
			if en = glob.dats.index[me.to_s + "_Attr_" + va[1] ]?
				return (glob.dats.ap_attr[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Field?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Attr" # app.unit:62, c_struct.act:403
			itsattr.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:277
			if parentp >= 0
				st = glob.dats.ap_table[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Join_field1" # app.unit:79, c_struct.act:302
			glob.dats.ap_join.each do |st|
				if st.k_field1p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join2_field1" # app.unit:94, c_struct.act:302
			glob.dats.ap_join2.each do |st|
				if st.k_field1p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join_field2" # app.unit:81, c_struct.act:325
			glob.dats.ap_join.each do |st|
				if st.k_field2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Join2_field2" # app.unit:96, c_struct.act:325
			glob.dats.ap_join2.each do |st|
				if st.k_field2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Field," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # app.unit:49, c_struct.act:292
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_field[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Join2_attr2" && va.size > 1 # app.unit:97, c_struct.act:429
			glob.dats.ap_join2.each do |st|
				if st.k_attr2p == me
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
		if va[0] == "parent" # app.unit:49, c_struct.act:277
			if parentp >= 0
				st = glob.dats.ap_field[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Join2_attr2" # app.unit:97, c_struct.act:325
			glob.dats.ap_join2.each do |st|
				if st.k_attr2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Attr," + line_no + "," + lno + "?");
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

	def get_var(glob, va, lno)
		if va[0] == "field1" # app.unit:79, c_struct.act:348
			if k_field1p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field1p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "table2" # app.unit:80, c_struct.act:348
			if k_table2p >= 0 && va.size > 1
				return( glob.dats.ap_table[ k_table2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "field2" # app.unit:81, c_struct.act:358
			if k_field2p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:292
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
		if va[0] == "parent" # app.unit:41, c_struct.act:277
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
		puts("?No its " + va[0] + " cmd for Join," + line_no + "," + lno + "?");
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

	def get_var(glob, va, lno)
		if va[0] == "field1" # app.unit:94, c_struct.act:348
			if k_field1p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field1p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "table2" # app.unit:95, c_struct.act:348
			if k_table2p >= 0 && va.size > 1
				return( glob.dats.ap_table[ k_table2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "field2" # app.unit:96, c_struct.act:358
			if k_field2p >= 0 && va.size > 1
				return( glob.dats.ap_field[ k_field2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "attr2" # app.unit:97, c_struct.act:358
			if k_attr2p >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_attr2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # app.unit:41, c_struct.act:292
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
		if va[0] == "parent" # app.unit:41, c_struct.act:277
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
				st = glob.dats.ap_attr[ k_attr2p ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Join2," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:16, c_struct.act:348
			if k_parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "Comp_parent" && va.size > 1 # gen.unit:16, c_struct.act:417
			glob.dats.ap_comp.each do |st|
				if st.k_parentp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref_comp" && va.size > 1 # gen.unit:79, c_struct.act:417
			glob.dats.ap_ref.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_comp" && va.size > 1 # gen.unit:97, c_struct.act:417
			glob.dats.ap_ref2.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Element"  && va.size > 2 # gen.unit:42, c_struct.act:236
			if en = glob.dats.index[me.to_s + "_Element_" + va[1] ]?
				return (glob.dats.ap_element[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Token" # gen.unit:19, c_struct.act:403
			itstoken.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Element" # gen.unit:37, c_struct.act:403
			itselement.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Ref" # gen.unit:65, c_struct.act:403
			itsref.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "Ref2" # gen.unit:82, c_struct.act:403
			itsref2.each do |st|
				ret = go_act(glob, st)
				if ret > 0
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
		if va[0] == "Comp_parent" # gen.unit:16, c_struct.act:302
			glob.dats.ap_comp.each do |st|
				if st.k_parentp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref_comp" # gen.unit:79, c_struct.act:302
			glob.dats.ap_ref.each do |st|
				if st.k_compp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref2_comp" # gen.unit:97, c_struct.act:302
			glob.dats.ap_ref2.each do |st|
				if st.k_compp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Comp," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:292
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
		if va[0] == "parent" # gen.unit:2, c_struct.act:277
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Token," + line_no + "," + lno + "?");
		return(0)
	end
end

class KpStar < Kp 

	def load(act, ln, pos, lno)
		p = pos
		@line_no = lno
		@me = act.ap_star.size
		p, @names["doc"] = getws(ln, p)
	end

	def get_var(glob, va, lno)
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Star?");
	end

	def do_its(glob, va, lno)
		puts("?No its " + va[0] + " cmd for Star," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:2, c_struct.act:292
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Ref_element" && va.size > 1 # gen.unit:78, c_struct.act:417
			glob.dats.ap_ref.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_element" && va.size > 1 # gen.unit:96, c_struct.act:417
			glob.dats.ap_ref2.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_element2" && va.size > 1 # gen.unit:98, c_struct.act:417
			glob.dats.ap_ref2.each do |st|
				if st.k_element2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Opt"  && va.size > 2 # gen.unit:60, c_struct.act:236
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
		if va[0] == "Opt" # gen.unit:54, c_struct.act:403
			itsopt.each do |st|
				ret = go_act(glob, st)
				if ret > 0
					return(ret)
				end
			end
			return(0)
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:277
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Ref_element" # gen.unit:78, c_struct.act:302
			glob.dats.ap_ref.each do |st|
				if st.k_elementp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref2_element" # gen.unit:96, c_struct.act:302
			glob.dats.ap_ref2.each do |st|
				if st.k_elementp == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		if va[0] == "Ref2_element2" # gen.unit:98, c_struct.act:302
			glob.dats.ap_ref2.each do |st|
				if st.k_element2p == me
					if va.size > 1
						ret = st.do_its(glob, va[1..], lno)
						if ret > 0
							return(ret)
						end
						next
					end
					ret = go_act(glob, st)
					if ret > 0
						return(ret)
					end
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Element," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "parent" # gen.unit:37, c_struct.act:292
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
		if va[0] == "parent" # gen.unit:37, c_struct.act:277
			if parentp >= 0
				st = glob.dats.ap_element[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Opt," + line_no + "," + lno + "?");
		return(0)
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

	def get_var(glob, va, lno)
		if va[0] == "element" # gen.unit:78, c_struct.act:348
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:79, c_struct.act:348
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:292
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
		if va[0] == "parent" # gen.unit:2, c_struct.act:277
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
		puts("?No its " + va[0] + " cmd for Ref," + line_no + "," + lno + "?");
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

	def get_var(glob, va, lno)
		if va[0] == "element" # gen.unit:96, c_struct.act:348
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:97, c_struct.act:348
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "element2" # gen.unit:98, c_struct.act:348
			if k_element2p >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, c_struct.act:292
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
		if va[0] == "parent" # gen.unit:2, c_struct.act:277
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
		puts("?No its " + va[0] + " cmd for Ref2," + line_no + "," + lno + "?");
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

