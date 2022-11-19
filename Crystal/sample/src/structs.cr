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
		p, @names["name"] = getw(ln, p)
		p, @names["desc"] = getws(ln, p)
		act.index["Type_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "Attr_table" && va.size > 1 # sample.unit:58, c_struct.act:523
			glob.dats.ap_attr.each do |st|
				if st.k_tablep == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Attr"  && va.size > 2 # sample.unit:51, c_struct.act:285
			if en = glob.dats.index[me.to_s + "_Attr_" + va[1] ]?
				return (glob.dats.ap_attr[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		if va[0] == "comp"
			return(true, comp )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Type?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Data" # sample.unit:13, c_struct.act:502
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
		if va[0] == "Attr" # sample.unit:24, c_struct.act:502
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
		if va[0] == "Where" # sample.unit:61, c_struct.act:502
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
		if va[0] == "Logic" # sample.unit:79, c_struct.act:502
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
		if va[0] == "Attr_table" # sample.unit:58, c_struct.act:366
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
		if va[0] == "Child" # sample.unit:2, c_struct.act:146
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
		p, @names["name"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["value"] = getws(ln, p)
		@parentp = act.ap_type.size-1;
		if @parentp < 0  
			puts lno + " Data has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itsdata << self
		act.ap_type[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:356
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		if va[0] == "comp"
			return(true, comp )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Data?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:341
			if parentp >= 0
				st = glob.dats.ap_type[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # sample.unit:13, c_struct.act:146
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
		p, @names["table"] = getw(ln, p)
		p, @names["relation"] = getw(ln, p)
		p, @names["name"] = getw(ln, p)
		p, @names["mytype"] = getw(ln, p)
		p, @names["len"] = getw(ln, p)
		p, @names["null"] = getw(ln, p)
		p, @names["flags"] = getw(ln, p)
		p, @names["desc"] = getws(ln, p)
		@parentp = act.ap_type.size-1;
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
		if va[0] == "table" # sample.unit:58, c_struct.act:435
			if k_tablep >= 0 && va.size > 1
				return( glob.dats.ap_type[ k_tablep ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # sample.unit:2, c_struct.act:356
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Where_attr" && va.size > 1 # sample.unit:74, c_struct.act:523
			glob.dats.ap_where.each do |st|
				if st.k_attrp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Where_id" && va.size > 1 # sample.unit:75, c_struct.act:523
			glob.dats.ap_where.each do |st|
				if st.k_idp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Logic_attr" && va.size > 1 # sample.unit:92, c_struct.act:523
			glob.dats.ap_logic.each do |st|
				if st.k_attrp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Where_from_id" && va.size > 1 # sample.unit:76, c_struct.act:547
			glob.dats.ap_where.each do |st|
				if st.k_from_idp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		if va[0] == "comp"
			return(true, comp )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Attr?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:341
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
		if va[0] == "Where_attr" # sample.unit:74, c_struct.act:366
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
		if va[0] == "Where_id" # sample.unit:75, c_struct.act:366
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
		if va[0] == "Logic_attr" # sample.unit:92, c_struct.act:366
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
		if va[0] == "Where_from_id" # sample.unit:76, c_struct.act:412
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
		if va[0] == "Child" # sample.unit:24, c_struct.act:146
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
		p, @names["attr"] = getw(ln, p)
		p, @names["from_id"] = getw(ln, p)
		p, @names["eq"] = getw(ln, p)
		p, @names["id"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["value"] = getws(ln, p)
		@parentp = act.ap_type.size-1;
		if @parentp < 0  
			puts lno + " Where has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itswhere << self
		act.ap_type[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "attr" # sample.unit:74, c_struct.act:435
			if k_attrp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "id" # sample.unit:75, c_struct.act:435
			if k_idp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_idp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "from_id" # sample.unit:76, c_struct.act:455
			if k_from_idp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_from_idp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # sample.unit:2, c_struct.act:356
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		if va[0] == "comp"
			return(true, comp )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Where?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:341
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
		if va[0] == "Child" # sample.unit:61, c_struct.act:146
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
		p, @names["attr"] = getw(ln, p)
		p, @names["op"] = getw(ln, p)
		p, @names["code"] = getw(ln, p)
		@parentp = act.ap_type.size-1;
		if @parentp < 0  
			puts lno + " Logic has no Type parent" 
			return false
		end
		act.ap_type[ @parentp ].itslogic << self
		act.ap_type[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "attr" # sample.unit:92, c_struct.act:435
			if k_attrp >= 0 && va.size > 1
				return( glob.dats.ap_attr[ k_attrp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # sample.unit:2, c_struct.act:356
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_type[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		if va[0] == "comp"
			return(true, comp )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Logic?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # sample.unit:2, c_struct.act:341
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
		if va[0] == "Child" # sample.unit:79, c_struct.act:146
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Logic," + line_no + "," + lno + "?");
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

