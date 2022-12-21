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

class KpComp < Kp 
	property k_parentp : Int32 = -1
	property itstoken : Array(KpToken) = Array(KpToken).new
	property itselement : Array(KpElement) = Array(KpElement).new
	property itsref : Array(KpRef) = Array(KpRef).new
	property itsref2 : Array(KpRef2) = Array(KpRef2).new
	property itsref3 : Array(KpRef3) = Array(KpRef3).new
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
		if va[0] == "parent" # gen.unit:16, ../../test3/c_struct.act:578
			if k_parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_parentp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "Comp_parent" && va.size > 1 # gen.unit:16, ../../test3/c_struct.act:666
			glob.dats.ap_comp.each do |st|
				if st.k_parentp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref_comp" && va.size > 1 # gen.unit:82, ../../test3/c_struct.act:666
			glob.dats.ap_ref.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_comp" && va.size > 1 # gen.unit:100, ../../test3/c_struct.act:666
			glob.dats.ap_ref2.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_comp" && va.size > 1 # gen.unit:121, ../../test3/c_struct.act:666
			glob.dats.ap_ref3.each do |st|
				if st.k_compp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_comp_ref" && va.size > 1 # gen.unit:122, ../../test3/c_struct.act:666
			glob.dats.ap_ref3.each do |st|
				if st.k_comp_refp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Token"  && va.size > 2 && itstoken.size > 0 # gen.unit:19, ../../test3/c_struct.act:431
			return (itstoken[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Element"  && va.size > 2 # gen.unit:42, ../../test3/c_struct.act:420
			if en = glob.dats.index[me.to_s + "_Element_" + va[1] ]?
				return (glob.dats.ap_element[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if va[0] == "Ref"  && va.size > 2 && itsref.size > 0 # gen.unit:67, ../../test3/c_struct.act:431
			return (itsref[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Ref2"  && va.size > 2 && itsref2.size > 0 # gen.unit:85, ../../test3/c_struct.act:431
			return (itsref2[0].get_var(glob, va[1..], lno))
		end
		if va[0] == "Ref3"  && va.size > 2 && itsref3.size > 0 # gen.unit:104, ../../test3/c_struct.act:431
			return (itsref3[0].get_var(glob, va[1..], lno))
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Comp?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Token" # gen.unit:19, ../../test3/c_struct.act:645
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
		if va[0] == "Element" # gen.unit:37, ../../test3/c_struct.act:645
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
		if va[0] == "Ref" # gen.unit:67, ../../test3/c_struct.act:645
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
		if va[0] == "Ref2" # gen.unit:85, ../../test3/c_struct.act:645
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
		if va[0] == "Ref3" # gen.unit:104, ../../test3/c_struct.act:645
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
		if va[0] == "Comp_parent" # gen.unit:16, ../../test3/c_struct.act:509
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
		if va[0] == "Ref_comp" # gen.unit:82, ../../test3/c_struct.act:509
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
		if va[0] == "Ref2_comp" # gen.unit:100, ../../test3/c_struct.act:509
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
		if va[0] == "Ref3_comp" # gen.unit:121, ../../test3/c_struct.act:509
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
		if va[0] == "Ref3_comp_ref" # gen.unit:122, ../../test3/c_struct.act:509
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
		if va[0] == "Child" # gen.unit:2, ../../test3/c_struct.act:147
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:499
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:19, ../../test3/c_struct.act:147
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
		if va[0] == "Child" # gen.unit:27, ../../test3/c_struct.act:147
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:499
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "Ref_element" && va.size > 1 # gen.unit:81, ../../test3/c_struct.act:666
			glob.dats.ap_ref.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_element" && va.size > 1 # gen.unit:99, ../../test3/c_struct.act:666
			glob.dats.ap_ref2.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref2_element2" && va.size > 1 # gen.unit:101, ../../test3/c_struct.act:666
			glob.dats.ap_ref2.each do |st|
				if st.k_element2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_element" && va.size > 1 # gen.unit:120, ../../test3/c_struct.act:666
			glob.dats.ap_ref3.each do |st|
				if st.k_elementp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Ref3_element2" && va.size > 1 # gen.unit:123, ../../test3/c_struct.act:666
			glob.dats.ap_ref3.each do |st|
				if st.k_element2p == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Opt"  && va.size > 2 # gen.unit:62, ../../test3/c_struct.act:420
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
		if va[0] == "Opt" # gen.unit:56, ../../test3/c_struct.act:645
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_comp[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Ref_element" # gen.unit:81, ../../test3/c_struct.act:509
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
		if va[0] == "Ref2_element" # gen.unit:99, ../../test3/c_struct.act:509
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
		if va[0] == "Ref2_element2" # gen.unit:101, ../../test3/c_struct.act:509
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
		if va[0] == "Ref3_element" # gen.unit:120, ../../test3/c_struct.act:509
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
		if va[0] == "Ref3_element2" # gen.unit:123, ../../test3/c_struct.act:509
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
		if va[0] == "Child" # gen.unit:37, ../../test3/c_struct.act:147
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
		if va[0] == "parent" # gen.unit:37, ../../test3/c_struct.act:499
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
		if va[0] == "parent" # gen.unit:37, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_element[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # gen.unit:56, ../../test3/c_struct.act:147
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
		if va[0] == "element" # gen.unit:81, ../../test3/c_struct.act:578
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:82, ../../test3/c_struct.act:578
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:499
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:484
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
		if va[0] == "Child" # gen.unit:67, ../../test3/c_struct.act:147
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
		if va[0] == "element" # gen.unit:99, ../../test3/c_struct.act:578
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:100, ../../test3/c_struct.act:578
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "element2" # gen.unit:101, ../../test3/c_struct.act:578
			if k_element2p >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:499
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:484
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
		if va[0] == "Child" # gen.unit:85, ../../test3/c_struct.act:147
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
		if va[0] == "element" # gen.unit:120, ../../test3/c_struct.act:578
			if k_elementp >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_elementp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp" # gen.unit:121, ../../test3/c_struct.act:578
			if k_compp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_compp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "comp_ref" # gen.unit:122, ../../test3/c_struct.act:578
			if k_comp_refp >= 0 && va.size > 1
				return( glob.dats.ap_comp[ k_comp_refp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "element2" # gen.unit:123, ../../test3/c_struct.act:578
			if k_element2p >= 0 && va.size > 1
				return( glob.dats.ap_element[ k_element2p ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:499
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
		if va[0] == "parent" # gen.unit:2, ../../test3/c_struct.act:484
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
		if va[0] == "Child" # gen.unit:104, ../../test3/c_struct.act:147
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Ref3," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpModel < Kp 
	property itsframe : Array(KpFrame) = Array(KpFrame).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Model"
		@line_no = lno
		@me = act.ap_model.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Model"
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["info"] = getws(ln, p)
		act.index["Model_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "Frame_name" && va.size > 1 # note.unit:18, ../../test3/c_struct.act:666
			glob.dats.ap_frame.each do |st|
				if st.k_namep == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "A_model" && va.size > 1 # note.unit:28, ../../test3/c_struct.act:666
			glob.dats.ap_a.each do |st|
				if st.k_modelp == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Frame"  && va.size > 2 # note.unit:14, ../../test3/c_struct.act:420
			if en = glob.dats.index[me.to_s + "_Frame_" + va[1] ]?
				return (glob.dats.ap_frame[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Model?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Frame" # note.unit:10, ../../test3/c_struct.act:645
			itsframe.each do |st|
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
		if va[0] == "Frame_name" # note.unit:18, ../../test3/c_struct.act:509
			glob.dats.ap_frame.each do |st|
				if st.k_namep == me
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
		if va[0] == "A_model" # note.unit:28, ../../test3/c_struct.act:509
			glob.dats.ap_a.each do |st|
				if st.k_modelp == me
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
		if va[0] == "Child" # note.unit:2, ../../test3/c_struct.act:147
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
		puts("?No its " + va[0] + " cmd for Model," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpFrame < Kp 
	property parentp : Int32 = -1
	property k_namep : Int32 = -1
	property itsa : Array(KpA) = Array(KpA).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Frame"
		@line_no = lno
		@me = act.ap_frame.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Frame"
		p, @names["group"] = getw(ln, p)
		p, @names["name"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["info"] = getws(ln, p)
		@parentp = act.ap_model.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Frame has no Model parent" 
			return false
		end
		act.ap_model[ @parentp ].itsframe << self
		act.ap_model[ @parentp ].childs << self
		s = @parentp.to_s + "_Frame_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "name" # note.unit:18, ../../test3/c_struct.act:578
			if k_namep >= 0 && va.size > 1
				return( glob.dats.ap_model[ k_namep ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # note.unit:2, ../../test3/c_struct.act:499
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_model[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "A"  && va.size > 2 && itsa.size > 0 # note.unit:21, ../../test3/c_struct.act:431
			return (itsa[0].get_var(glob, va[1..], lno))
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Frame?");
	end

	def do_its(glob, va, lno)
		if va[0] == "A" # note.unit:21, ../../test3/c_struct.act:645
			itsa.each do |st|
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
		if va[0] == "parent" # note.unit:2, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_model[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "name"
			if k_namep >= 0
				st = glob.dats.ap_model[ k_namep ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "group" && va.size > 1 && parentp >= 0 # note.unit:13, ../../test3/c_struct.act:165
			pos = 0
			if v = names[ "group" ]?
				pos = v.to_i
			end
			if va[1] == "down" && pos > 0
				pst = glob.dats.ap_model[ parentp ]
				isin = false
				pst.itsframe.each do |st|
					if st.me == me
						isin = true
						next
					end
					if isin == false
						next
					end
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == (pos-1)
						break
					end
					if pos2 == pos 
						if va.size > 2
							return( st.do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, st) )
					end
				end
				return(0)
			end
			if va[1] == "up" && pos > 0
				pst = glob.dats.ap_model[ parentp ]
				isin = false
				prev = 0
				pst.itsframe.each do |st|
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == pos && st.me != me
						prev = st.me
						isin = true
						next
					end
					if pos2 == (pos-1)
						isin = false
					end
					if st.me == me && isin == true
						if va.size > 2
							return( glob.dats.ap_frame[prev].do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, glob.dats.ap_frame[prev] ) )
					end
				end
				return(0)
			end
			if va[1] == "left" && pos > 0
				pst = glob.dats.ap_model[ parentp ]
				isin = false
				prev = 0
				pst.itsframe.each do |st|
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == (pos-1)
						prev = st.me
						isin = true
						next
					end
					if st.me == me && isin == true
						if va.size > 2
							return( glob.dats.ap_frame[prev].do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, glob.dats.ap_frame[prev] ) )
					end
				end
				return(0)
			end
			if va[1] == "right" && pos > 0
				pst = glob.dats.ap_model[ parentp ]
				isin = false
				pst.itsframe.each do |st|
					if st.me == me
						isin = true
						next
					end
					if isin == false
						next
					end
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 <= pos
						break
					end
					if pos2 == (pos+1)
						if va.size > 2
							ret = st.do_its(glob, va[2..], lno)
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
		end
		if va[0] == "Child" # note.unit:10, ../../test3/c_struct.act:147
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
		puts("?No its " + va[0] + " cmd for Frame," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpA < Kp 
	property parentp : Int32 = -1
	property k_modelp : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "A"
		@line_no = lno
		@me = act.ap_a.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "A"
		p, @names["model"] = getw(ln, p)
		p, @names["pad"] = getw(ln, p)
		p, @names["info"] = getws(ln, p)
		@parentp = act.ap_frame.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " A has no Frame parent" 
			return false
		end
		act.ap_frame[ @parentp ].itsa << self
		act.ap_frame[ @parentp ].childs << self
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "model" # note.unit:28, ../../test3/c_struct.act:578
			if k_modelp >= 0 && va.size > 1
				return( glob.dats.ap_model[ k_modelp ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # note.unit:10, ../../test3/c_struct.act:499
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_frame[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",A?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # note.unit:10, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_frame[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "model"
			if k_modelp >= 0
				st = glob.dats.ap_model[ k_modelp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # note.unit:21, ../../test3/c_struct.act:147
			return(0)
		end
		puts("?No its " + va[0] + " cmd for A," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpGrid < Kp 
	property itscol : Array(KpCol) = Array(KpCol).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Grid"
		@line_no = lno
		@me = act.ap_grid.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Grid"
		p, @names["name"] = getw(ln, p)
		p, @names["file"] = getw(ln, p)
		p, @names["info"] = getws(ln, p)
		act.index["Grid_" + @names["name"]] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "Col_name" && va.size > 1 # note.unit:48, ../../test3/c_struct.act:666
			glob.dats.ap_col.each do |st|
				if st.k_namep == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "R_name" && va.size > 1 # note.unit:58, ../../test3/c_struct.act:666
			glob.dats.ap_r.each do |st|
				if st.k_namep == me
					return (st.get_var(glob, va[1..], lno) )
				end
			end
		end
		if va[0] == "Col"  && va.size > 2 # note.unit:42, ../../test3/c_struct.act:420
			if en = glob.dats.index[me.to_s + "_Col_" + va[1] ]?
				return (glob.dats.ap_col[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Grid?");
	end

	def do_its(glob, va, lno)
		if va[0] == "Col" # note.unit:39, ../../test3/c_struct.act:645
			itscol.each do |st|
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
		if va[0] == "Col_name" # note.unit:48, ../../test3/c_struct.act:509
			glob.dats.ap_col.each do |st|
				if st.k_namep == me
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
		if va[0] == "R_name" # note.unit:58, ../../test3/c_struct.act:509
			glob.dats.ap_r.each do |st|
				if st.k_namep == me
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
		if va[0] == "Child" # note.unit:31, ../../test3/c_struct.act:147
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
		puts("?No its " + va[0] + " cmd for Grid," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpCol < Kp 
	property parentp : Int32 = -1
	property k_namep : Int32 = -1
	property itsr : Array(KpR) = Array(KpR).new
	property childs : Array(Kp) = Array(Kp).new

	def load(act, ln, pos, lno)
		p = pos
		@comp = "Col"
		@line_no = lno
		@me = act.ap_col.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "Col"
		p, @names["name"] = getw(ln, p)
		p, @names["index"] = getw(ln, p)
		p, @names["group"] = getw(ln, p)
		p, @names["file"] = getw(ln, p)
		p, @names["info"] = getws(ln, p)
		@parentp = act.ap_grid.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " Col has no Grid parent" 
			return false
		end
		act.ap_grid[ @parentp ].itscol << self
		act.ap_grid[ @parentp ].childs << self
		s = @parentp.to_s + "_Col_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "name" # note.unit:48, ../../test3/c_struct.act:578
			if k_namep >= 0 && va.size > 1
				return( glob.dats.ap_grid[ k_namep ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # note.unit:31, ../../test3/c_struct.act:499
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_grid[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if va[0] == "R"  && va.size > 2 # note.unit:54, ../../test3/c_struct.act:420
			if en = glob.dats.index[me.to_s + "_R_" + va[1] ]?
				return (glob.dats.ap_r[en].get_var(glob, va[2..], lno))
			end
			return(false, "?" + va[0] + "=" + va[1] + "?" + line_no + "," + lno + "?")
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",Col?");
	end

	def do_its(glob, va, lno)
		if va[0] == "R" # note.unit:51, ../../test3/c_struct.act:645
			itsr.each do |st|
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
		if va[0] == "parent" # note.unit:31, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_grid[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "name"
			if k_namep >= 0
				st = glob.dats.ap_grid[ k_namep ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "index" && va.size > 1 && parentp >= 0 # note.unit:43, ../../test3/c_struct.act:165
			pos = 0
			if v = names[ "index" ]?
				pos = v.to_i
			end
			if va[1] == "down" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				pst.itscol.each do |st|
					if st.me == me
						isin = true
						next
					end
					if isin == false
						next
					end
					pos2 = 0
					if v = st.names[ "index" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == (pos-1)
						break
					end
					if pos2 == pos 
						if va.size > 2
							return( st.do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, st) )
					end
				end
				return(0)
			end
			if va[1] == "up" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				prev = 0
				pst.itscol.each do |st|
					pos2 = 0
					if v = st.names[ "index" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == pos && st.me != me
						prev = st.me
						isin = true
						next
					end
					if pos2 == (pos-1)
						isin = false
					end
					if st.me == me && isin == true
						if va.size > 2
							return( glob.dats.ap_col[prev].do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, glob.dats.ap_col[prev] ) )
					end
				end
				return(0)
			end
			if va[1] == "left" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				prev = 0
				pst.itscol.each do |st|
					pos2 = 0
					if v = st.names[ "index" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == (pos-1)
						prev = st.me
						isin = true
						next
					end
					if st.me == me && isin == true
						if va.size > 2
							return( glob.dats.ap_col[prev].do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, glob.dats.ap_col[prev] ) )
					end
				end
				return(0)
			end
			if va[1] == "right" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				pst.itscol.each do |st|
					if st.me == me
						isin = true
						next
					end
					if isin == false
						next
					end
					pos2 = 0
					if v = st.names[ "index" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 <= pos
						break
					end
					if pos2 == (pos+1)
						if va.size > 2
							ret = st.do_its(glob, va[2..], lno)
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
		end
		if va[0] == "group" && va.size > 1 && parentp >= 0 # note.unit:44, ../../test3/c_struct.act:165
			pos = 0
			if v = names[ "group" ]?
				pos = v.to_i
			end
			if va[1] == "down" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				pst.itscol.each do |st|
					if st.me == me
						isin = true
						next
					end
					if isin == false
						next
					end
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == (pos-1)
						break
					end
					if pos2 == pos 
						if va.size > 2
							return( st.do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, st) )
					end
				end
				return(0)
			end
			if va[1] == "up" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				prev = 0
				pst.itscol.each do |st|
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == pos && st.me != me
						prev = st.me
						isin = true
						next
					end
					if pos2 == (pos-1)
						isin = false
					end
					if st.me == me && isin == true
						if va.size > 2
							return( glob.dats.ap_col[prev].do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, glob.dats.ap_col[prev] ) )
					end
				end
				return(0)
			end
			if va[1] == "left" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				prev = 0
				pst.itscol.each do |st|
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 == (pos-1)
						prev = st.me
						isin = true
						next
					end
					if st.me == me && isin == true
						if va.size > 2
							return( glob.dats.ap_col[prev].do_its(glob, va[2..], lno) )
						end
						return( go_act(glob, glob.dats.ap_col[prev] ) )
					end
				end
				return(0)
			end
			if va[1] == "right" && pos > 0
				pst = glob.dats.ap_grid[ parentp ]
				isin = false
				pst.itscol.each do |st|
					if st.me == me
						isin = true
						next
					end
					if isin == false
						next
					end
					pos2 = 0
					if v = st.names[ "group" ]?
						pos2 = v.to_i
					end
					if pos2 == 0
						next
					end
					if pos2 <= pos
						break
					end
					if pos2 == (pos+1)
						if va.size > 2
							ret = st.do_its(glob, va[2..], lno)
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
		end
		if va[0] == "Child" # note.unit:39, ../../test3/c_struct.act:147
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
		puts("?No its " + va[0] + " cmd for Col," + line_no + "," + lno + "?");
		glob.run_errs = true
		return(0)
	end
end

class KpR < Kp 
	property parentp : Int32 = -1
	property k_namep : Int32 = -1

	def load(act, ln, pos, lno)
		p = pos
		@comp = "R"
		@line_no = lno
		@me = act.ap_r.size
		@names["k_me"] = @me.to_s
		@names["k_parent"] = "-1"
		@names["k_comp"] = "R"
		p, @names["name"] = getw(ln, p)
		p, @names["file"] = getw(ln, p)
		p, @names["info"] = getws(ln, p)
		@parentp = act.ap_col.size-1;
		@names["k_parent"] = @parentp.to_s
		if @parentp < 0  
			puts lno + " R has no Col parent" 
			return false
		end
		act.ap_col[ @parentp ].itsr << self
		act.ap_col[ @parentp ].childs << self
		s = @parentp.to_s + "_R_" + @names["name"]
		act.index[s] = @me
		return true
	end

	def get_var(glob, va, lno)
		if va[0] == "name" # note.unit:58, ../../test3/c_struct.act:578
			if k_namep >= 0 && va.size > 1
				return( glob.dats.ap_grid[ k_namep ].get_var(glob, va[1..], lno) )
			end
		end
		if va[0] == "parent" # note.unit:39, ../../test3/c_struct.act:499
			if parentp >= 0 && va.size > 1
				return( glob.dats.ap_col[ parentp ].get_var(glob, va[1..],lno) )
			end
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?" + line_no + "," + lno + ",R?");
	end

	def do_its(glob, va, lno)
		if va[0] == "parent" # note.unit:39, ../../test3/c_struct.act:484
			if parentp >= 0
				st = glob.dats.ap_col[ parentp ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "name"
			if k_namep >= 0
				st = glob.dats.ap_grid[ k_namep ]
				if va.size > 1
					return( st.do_its(glob, va[1..], lno) )
				end
				return( go_act(glob, st) )
			end
			return(0)
		end
		if va[0] == "Child" # note.unit:51, ../../test3/c_struct.act:147
			return(0)
		end
		puts("?No its " + va[0] + " cmd for R," + line_no + "," + lno + "?");
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

class KpDbload < Kp 
	property parentp : Int32 = -1
	property k_where : String = ""
	property childs : Array(Kp) = Array(Kp).new
	def load(act, ln, pos, lno)
		p = pos
		@comp = "Dbload"
		@line_no = lno
		@me = act.ap_dbload.size
		p, @k_where = getw(ln, p)
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

