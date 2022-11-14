require "./*"

class ActT 
	property index : Hash(String, Int32) = Hash(String, Int32).new
	property ap_type : Array(KpType) = Array(KpType).new
	property ap_data : Array(KpData) = Array(KpData).new
	property ap_where : Array(KpWhere) = Array(KpWhere).new
	property ap_attr : Array(KpAttr) = Array(KpAttr).new
	property ap_actor : Array(KpActor) = Array(KpActor).new
	property ap_all : Array(KpAll) = Array(KpAll).new
	property ap_du : Array(KpDu) = Array(KpDu).new
	property ap_var : Array(KpVar) = Array(KpVar).new
	property ap_its : Array(KpIts) = Array(KpIts).new
	property ap_c : Array(KpC) = Array(KpC).new
	property ap_cs : Array(KpCs) = Array(KpCs).new
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
	act.ap_where.each_with_index do |st,i|
		r, st.k_namep = fnd(act, st.parentp.to_s + "_Attr_" + st.names["name"] , st.names["name"],  "check", st.line_no )
		if r == false
			errs = true
		end
	end
	act.ap_attr.each_with_index do |st,i|
		r, st.k_tablep = fnd(act, "Type_" + st.names["table"] , st.names["table"],  ".", st.line_no )
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
	if va[0] == "Type" # sample.unit:2, c_run.act:137
		if en = glob.dats.index["Type_" + va[1] ]?
			return (glob.dats.ap_type[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	if va[0] == "Actor" # act.unit:2, c_run.act:137
		if en = glob.dats.index["Actor_" + va[1] ]?
			return (glob.dats.ap_actor[en].get_var(glob, va[2..], lno))
		end
		return(false, "?" + va[0] + "=" + va[1] + "?" + lno + "?")
	end
	return(false, "?" + va[0] + "?" + lno + "?")
end

def do_all(glob, va, lno)
	if va[0] == "Type" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Type_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_type[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_type[en]) )
			end
			return(0)
		end
		glob.dats.ap_type.each do |st|
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
	if va[0] == "Data" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Data_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_data[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_data[en]) )
			end
			return(0)
		end
		glob.dats.ap_data.each do |st|
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
	if va[0] == "Where" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Where_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_where[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_where[en]) )
			end
			return(0)
		end
		glob.dats.ap_where.each do |st|
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
	if va[0] == "Attr" 
		if va.size > 1 && va[1] != ""
			if en = glob.dats.index["Attr_" + va[1] ]?
				if va.size > 2
					return( glob.dats.ap_attr[en].do_its(glob, va[2..], lno) )
				end
				return( go_act(glob, glob.dats.ap_attr[en]) )
			end
			return(0)
		end
		glob.dats.ap_attr.each do |st|
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
	if tok == "Type"
		comp = KpType.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_type << comp
	end
	if tok == "Data"
		comp = KpData.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_data << comp
	end
	if tok == "Where"
		comp = KpWhere.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_where << comp
	end
	if tok == "Attr"
		comp = KpAttr.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_attr << comp
	end
	if tok == "Actor"
		comp = KpActor.new
		r = comp.load(act, ln, pos, lno)
		if r == false
			errs = true
		end
		act.ap_actor << comp
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
