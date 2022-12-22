require "./*"

class ActT 
	property index : Hash(String, Int32) = Hash(String, Int32).new
	property ap_comp : Array(KpComp) = Array(KpComp).new
	property ap_token : Array(KpToken) = Array(KpToken).new
	property ap_star : Array(KpStar) = Array(KpStar).new
	property ap_element : Array(KpElement) = Array(KpElement).new
	property ap_opt : Array(KpOpt) = Array(KpOpt).new
	property ap_ref : Array(KpRef) = Array(KpRef).new
	property ap_ref2 : Array(KpRef2) = Array(KpRef2).new
	property ap_ref3 : Array(KpRef3) = Array(KpRef3).new
	property ap_model : Array(KpModel) = Array(KpModel).new
	property ap_frame : Array(KpFrame) = Array(KpFrame).new
	property ap_a : Array(KpA) = Array(KpA).new
	property ap_grid : Array(KpGrid) = Array(KpGrid).new
	property ap_col : Array(KpCol) = Array(KpCol).new
	property ap_r : Array(KpR) = Array(KpR).new
	property ap_actor : Array(KpActor) = Array(KpActor).new
	property ap_dbcreate : Array(KpDbcreate) = Array(KpDbcreate).new
	property ap_dbload : Array(KpDbload) = Array(KpDbload).new
	property ap_dbselect : Array(KpDbselect) = Array(KpDbselect).new
	property ap_all : Array(KpAll) = Array(KpAll).new
	property ap_du : Array(KpDu) = Array(KpDu).new
	property ap_new : Array(KpNew) = Array(KpNew).new
	property ap_refs : Array(KpRefs) = Array(KpRefs).new
	property ap_var : Array(KpVar) = Array(KpVar).new
	property ap_its : Array(KpIts) = Array(KpIts).new
	property ap_c : Array(KpC) = Array(KpC).new
	property ap_cs : Array(KpCs) = Array(KpCs).new
	property ap_include : Array(KpInclude) = Array(KpInclude).new
	property ap_out : Array(KpOut) = Array(KpOut).new
	property ap_break : Array(KpBreak) = Array(KpBreak).new
	property ap_unique : Array(KpUnique) = Array(KpUnique).new
	property ap_collect : Array(KpCollect) = Array(KpCollect).new
	property ap_hash : Array(KpHash) = Array(KpHash).new
	property ap_group : Array(KpGroup) = Array(KpGroup).new
	property ap_json : Array(KpJson) = Array(KpJson).new
	property ap_yaml : Array(KpYaml) = Array(KpYaml).new
	property ap_xml : Array(KpXml) = Array(KpXml).new
end

def refs(act)
	errs = false
	act.ap_comp.each_with_index do |st,i|
		r, st.k_parentp = fnd(act, "Comp_" + st.names["parent"] , st.names["parent"],  ".", st.line_no )
		st.names["k_parentp"] = st.k_parentp.to_s
		if r == false
			errs = true
		end
	end
	act.ap_ref.each_with_index do |st,i|
		r, st.k_elementp = fnd(act, st.parentp.to_s + "_Element_" + st.names["element"] , st.names["element"],  "check", st.line_no )
		st.names["k_elementp"] = st.k_elementp.to_s
		if r == false
			errs = true
		end
		r, st.k_compp = fnd(act, "Comp_" + st.names["comp"] , st.names["comp"],  "check", st.line_no )
		st.names["k_compp"] = st.k_compp.to_s
		if r == false
			errs = true
		end
	end
	act.ap_ref2.each_with_index do |st,i|
		r, st.k_elementp = fnd(act, st.parentp.to_s + "_Element_" + st.names["element"] , st.names["element"],  "check", st.line_no )
		st.names["k_elementp"] = st.k_elementp.to_s
		if r == false
			errs = true
		end
		r, st.k_compp = fnd(act, "Comp_" + st.names["comp"] , st.names["comp"],  "check", st.line_no )
		st.names["k_compp"] = st.k_compp.to_s
		if r == false
			errs = true
		end
		r, st.k_element2p = fnd(act, st.parentp.to_s + "_Element_" + st.names["element2"] , st.names["element2"],  "check", st.line_no )
		st.names["k_element2p"] = st.k_element2p.to_s
		if r == false
			errs = true
		end
	end
	act.ap_ref3.each_with_index do |st,i|
		r, st.k_elementp = fnd(act, st.parentp.to_s + "_Element_" + st.names["element"] , st.names["element"],  "check", st.line_no )
		st.names["k_elementp"] = st.k_elementp.to_s
		if r == false
			errs = true
		end
		r, st.k_compp = fnd(act, "Comp_" + st.names["comp"] , st.names["comp"],  "check", st.line_no )
		st.names["k_compp"] = st.k_compp.to_s
		if r == false
			errs = true
		end
		r, st.k_element2p = fnd(act, st.parentp.to_s + "_Element_" + st.names["element2"] , st.names["element2"],  "check", st.line_no )
		st.names["k_element2p"] = st.k_element2p.to_s
		if r == false
			errs = true
		end
		r, st.k_comp_refp = fnd(act, "Comp_" + st.names["comp_ref"] , st.names["comp_ref"],  "check", st.line_no )
		st.names["k_comp_refp"] = st.k_comp_refp.to_s
		if r == false
			errs = true
		end
	end
	act.ap_frame.each_with_index do |st,i|
		r, st.k_namep = fnd(act, "Model_" + st.names["name"] , st.names["name"],  "?", st.line_no )
		st.names["k_namep"] = st.k_namep.to_s
		if r == false
			errs = true
		end
	end
	act.ap_a.each_with_index do |st,i|
		r, st.k_modelp = fnd(act, "Model_" + st.names["model"] , st.names["model"],  "?", st.line_no )
		st.names["k_modelp"] = st.k_modelp.to_s
		if r == false
			errs = true
		end
	end
	act.ap_col.each_with_index do |st,i|
		r, st.k_namep = fnd(act, "Grid_" + st.names["name"] , st.names["name"],  "?", st.line_no )
		st.names["k_namep"] = st.k_namep.to_s
		if r == false
			errs = true
		end
	end
	act.ap_r.each_with_index do |st,i|
		r, st.k_namep = fnd(act, "Grid_" + st.names["name"] , st.names["name"],  "?", st.line_no )
		st.names["k_namep"] = st.k_namep.to_s
		if r == false
			errs = true
		end
	end
	act.ap_dbselect.each_with_index do |st,i|
		r, st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
		if r == false
			errs = true
		end
	end
	act.ap_all.each_with_index do |st,i|
		r, st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
		if r == false
			errs = true
		end
	end
	act.ap_du.each_with_index do |st,i|
		r, st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
		if r == false
			errs = true
		end
	end
	act.ap_its.each_with_index do |st,i|
		r, st.k_actorp = fnd(act, "Actor_" + st.k_actor , st.k_actor,  ".", st.line_no )
		if r == false
			errs = true
		end
	end
	return(errs)
end

def var_all(glob, va, lno) 
	if va.size < 3
		return(false, "?" + va.size.to_s + "<3?" + lno + "?")
	end
	if va[0] == "Comp" # gen.unit:2, ../../test3/c_run.act:173
		if en = glob.dats.index["Comp_" + va[1] ]?
			return (glob.dats.ap_comp[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Model" # note.unit:2, ../../test3/c_run.act:173
		if en = glob.dats.index["Model_" + va[1] ]?
			return (glob.dats.ap_model[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Grid" # note.unit:31, ../../test3/c_run.act:173
		if en = glob.dats.index["Grid_" + va[1] ]?
			return (glob.dats.ap_grid[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Actor" # act.unit:2, ../../test3/c_run.act:173
		if en = glob.dats.index["Actor_" + va[1] ]?
			return (glob.dats.ap_actor[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	return(false, "?" + va[0] + "?" + lno + "?")
end

def do_all(glob, va, lno)
	if va[0] == "Comp" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Comp_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_comp[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_comp[en]) )
			end
			return(0)
		end
		glob.dats.ap_comp.each do |st|
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
		return(0)
	end
	if va[0] == "Token" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Token_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_token[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_token[en]) )
			end
			return(0)
		end
		glob.dats.ap_token.each do |st|
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
		return(0)
	end
	if va[0] == "Star" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Star_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_star[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_star[en]) )
			end
			return(0)
		end
		glob.dats.ap_star.each do |st|
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
		return(0)
	end
	if va[0] == "Element" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Element_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_element[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_element[en]) )
			end
			return(0)
		end
		glob.dats.ap_element.each do |st|
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
		return(0)
	end
	if va[0] == "Opt" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Opt_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_opt[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_opt[en]) )
			end
			return(0)
		end
		glob.dats.ap_opt.each do |st|
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
		return(0)
	end
	if va[0] == "Ref" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Ref_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_ref[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_ref[en]) )
			end
			return(0)
		end
		glob.dats.ap_ref.each do |st|
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
		return(0)
	end
	if va[0] == "Ref2" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Ref2_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_ref2[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_ref2[en]) )
			end
			return(0)
		end
		glob.dats.ap_ref2.each do |st|
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
		return(0)
	end
	if va[0] == "Ref3" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Ref3_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_ref3[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_ref3[en]) )
			end
			return(0)
		end
		glob.dats.ap_ref3.each do |st|
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
		return(0)
	end
	if va[0] == "Model" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Model_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_model[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_model[en]) )
			end
			return(0)
		end
		glob.dats.ap_model.each do |st|
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
		return(0)
	end
	if va[0] == "Frame" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Frame_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_frame[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_frame[en]) )
			end
			return(0)
		end
		glob.dats.ap_frame.each do |st|
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
		return(0)
	end
	if va[0] == "A" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["A_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_a[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_a[en]) )
			end
			return(0)
		end
		glob.dats.ap_a.each do |st|
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
		return(0)
	end
	if va[0] == "Grid" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Grid_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_grid[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_grid[en]) )
			end
			return(0)
		end
		glob.dats.ap_grid.each do |st|
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
		return(0)
	end
	if va[0] == "Col" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Col_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_col[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_col[en]) )
			end
			return(0)
		end
		glob.dats.ap_col.each do |st|
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
		return(0)
	end
	if va[0] == "R" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["R_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_r[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_r[en]) )
			end
			return(0)
		end
		glob.dats.ap_r.each do |st|
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
		return(0)
	end
	if va[0] == "Actor" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Actor_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_actor[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_actor[en]) )
			end
			return(0)
		end
		glob.dats.ap_actor.each do |st|
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
		return(0)
	end
	puts "?No all " + va[0] + " cmd " + "," + lno + "?"
	return 0
end

def load(act, tok, ln, pos, lno)
	errs = false
	if tok == "Comp"
		comp = KpComp.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_comp << comp
	end
	if tok == "Token"
		comp = KpToken.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_token << comp
	end
	if tok == "Star"
		comp = KpStar.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_star << comp
	end
	if tok == "Element"
		comp = KpElement.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_element << comp
	end
	if tok == "Opt"
		comp = KpOpt.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_opt << comp
	end
	if tok == "Ref"
		comp = KpRef.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_ref << comp
	end
	if tok == "Ref2"
		comp = KpRef2.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_ref2 << comp
	end
	if tok == "Ref3"
		comp = KpRef3.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_ref3 << comp
	end
	if tok == "Model"
		comp = KpModel.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_model << comp
	end
	if tok == "Frame"
		comp = KpFrame.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_frame << comp
	end
	if tok == "A"
		comp = KpA.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_a << comp
	end
	if tok == "Grid"
		comp = KpGrid.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_grid << comp
	end
	if tok == "Col"
		comp = KpCol.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_col << comp
	end
	if tok == "R"
		comp = KpR.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_r << comp
	end
	if tok == "Actor"
		comp = KpActor.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_actor << comp
	end
	if tok == "Dbcreate"
		comp = KpDbcreate.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_dbcreate << comp
	end
	if tok == "Dbload"
		comp = KpDbload.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_dbload << comp
	end
	if tok == "Dbselect"
		comp = KpDbselect.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_dbselect << comp
	end
	if tok == "All"
		comp = KpAll.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_all << comp
	end
	if tok == "Du"
		comp = KpDu.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_du << comp
	end
	if tok == "New"
		comp = KpNew.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_new << comp
	end
	if tok == "Refs"
		comp = KpRefs.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_refs << comp
	end
	if tok == "Var"
		comp = KpVar.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_var << comp
	end
	if tok == "Its"
		comp = KpIts.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_its << comp
	end
	if tok == "C"
		comp = KpC.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_c << comp
	end
	if tok == "Cs"
		comp = KpCs.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_cs << comp
	end
	if tok == "Include"
		comp = KpInclude.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_include << comp
	end
	if tok == "Out"
		comp = KpOut.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_out << comp
	end
	if tok == "Break"
		comp = KpBreak.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_break << comp
	end
	if tok == "Unique"
		comp = KpUnique.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_unique << comp
	end
	if tok == "Collect"
		comp = KpCollect.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_collect << comp
	end
	if tok == "Hash"
		comp = KpHash.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_hash << comp
	end
	if tok == "Group"
		comp = KpGroup.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_group << comp
	end
	if tok == "Json"
		comp = KpJson.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_json << comp
	end
	if tok == "Yaml"
		comp = KpYaml.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_yaml << comp
	end
	if tok == "Xml"
		comp = KpXml.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_xml << comp
	end
	return(errs)
end
