require "./*"
require "json"
require "yaml"
require "xml"

class KpExtra < Kp
	def do_its(glob, va, lno)
		if v = names[ va[0] ]?
			if va.size < 3
				kp = Kp.new()
				kp.names["value"] = v
				return( go_act(glob, kp) )
			end
			va = v.split( va[2] )
			va.each do |val|
				kp = Kp.new()
				kp.names["value"] = val
				ret = go_act(glob, kp)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		puts("?No its " + va[0] + " cmd for Kp," + lno + "?");
		return(0)
	end
end

def hash_cmd(glob,winp,cmd)
	if cmd.k_cmd == "clear"
		if cmd.k_pocket != "E_O_L"
			if glob.hash[cmd.k_pocket]?
				glob.hash[cmd.k_pocket] = Hash( String, Kp ).new
			end
			return
		end
		glob.hash = Hash( String, Hash( String, Kp ) ).new
	end
	if cmd.k_cmd == "add"
		r,ks = strs(glob, winp, cmd.k_key, cmd.line_no )
		r,ps = strs(glob, winp, cmd.k_pocket, cmd.line_no )
		if glob.hash[ps]?
			glob.hash[ps][ks] = glob.wins[winp].dat
		else
			ha = Hash( String, Kp ).new
			ha[ks] = glob.wins[winp].dat
			glob.hash[ps] = ha
		end
	end
end

def collect_cmd(glob,winp,cmd)
	if cmd.k_cmd == "clear"
		if cmd.k_pocket != "E_O_L"
			if glob.collect[cmd.k_pocket]?
				glob.collect[cmd.k_pocket] = Array(Kp).new
			end
			return
		end
		glob.collect = Hash( String, Array(Kp) ).new
	end
	if cmd.k_cmd == "add"
		if glob.collect[cmd.k_pocket]?
			glob.collect[cmd.k_pocket] << glob.wins[winp].dat
		else
			ar = Array(Kp).new
			ar << glob.wins[winp].dat
			glob.collect[cmd.k_pocket] = ar
		end
	end
end

def collect_all(glob, va, lno)
	glob.collect.each do |key, value|
		if va.size > 1 && va[1] != ""
			if key != va[1]
				next
			end
		end
		val = value
		if va.size > 2 && va[2] == "reverse"
			val = value.reverse
		end
		val.each do |kp|
			ret = go_act(glob, kp)
			if ret != 0
				return(ret)
			end
		end
	end
	return(0)
end


def group_cmd(glob,winp,cmd)
	if cmd.k_cmd == "clear" || cmd.k_cmd == "remove"
		if cmd.k_pocket != "E_O_L"
			if glob.group[cmd.k_pocket]?
				if cmd.k_key != "E_O_L"
					if glob.group[cmd.k_pocket][cmd.k_key]?
#						glob.group[cmd.k_pocket][cmd.k_key].clear()  # = Array(String).new
						glob.group[cmd.k_pocket].delete(cmd.k_key)
						return
					end
				end
				glob.group[cmd.k_pocket] = Hash( String, Array(String) ).new
				return
			end
		end
		glob.group = Hash( String, Hash( String, Array(String) ) ).new
	end
	if cmd.k_cmd == "add"
		r,vs = strs(glob, winp, cmd.k_value, cmd.line_no )
		r,ks = strs(glob, winp, cmd.k_key, cmd.line_no )
		r,ps = strs(glob, winp, cmd.k_pocket, cmd.line_no )
		if glob.group[ps]?
			if glob.group[ps][ks]?
				if glob.group[ps][ks].index(vs)
					return
				end
				glob.group[ps][ks] << vs
#				puts "a", glob.group[ps][ks]
				return
			end
			glob.group[ps][ks] = [vs]
#			puts "b", glob.group[ps][ks]
			return
		end
		x = Hash(String,Array(String)).new
		x[ks] = [vs]
		glob.group[ps] = x
#		puts "n", glob.group[ps][ks]
	end
end

def group_all(glob, va, lno)
	glob.group.each do |poc, value|
		if va.size > 1 && va[1] != ""
			if poc != va[1]
				next
			end
		end
		value.each do |key,val|
			if va.size > 2 && va[2] != ""
				if key != va[2]
					next
				end
			end
			kp = KpExtra.new()
			kp.names["pocket"] = poc
			kp.names["key"] = key
			kp.names["value"] = val.sort.join(",")
			ret = go_act(glob, kp)
			if ret != 0
				return(ret)
			end
		end
	end
	return(0)
end

def unique_cmd(glob,winp,cmd)
	r,arg = strs(glob, winp, cmd.k_value, cmd.line_no )
	if cmd.k_cmd == "check"
		if a = glob.unq[cmd.k_key]?
			if a.index(arg)
				return(1)
			end
		end
	end
	if cmd.k_cmd == "clear"
		if cmd.k_key != "E_O_L"
			if a = glob.unq[cmd.k_key]?
				glob.unq[cmd.k_key] = Array(String).new
			end
			return(0)
		end
		glob.unq = Hash( String, Array(String) ).new
	end
	if cmd.k_cmd == "add"
		if a = glob.unq[cmd.k_key]?
			if a.index(arg)
				return(1)
			end
			glob.unq[cmd.k_key] << arg
		else
			aru = Array(String).new
			aru << arg
			glob.unq[cmd.k_key] = aru
		end
	end
	return(0)
end

def unique_all(glob, va, lno)
	glob.unq.each do |key, value|
		if va.size > 1 && va[1] != ""
			if key != va[1]
				next
			end
		end
		val = value
		if va.size > 2 && va[2] == "reverse"
			val = value.reverse
		end
		val.each do |val|
			kp = Kp.new()
			kp.names["key"] = key
			kp.names["value"] = val
			ret = go_act(glob, kp)
			if ret != 0
				return(ret)
			end
		end
	end
	return(0)
end

class KpIjson < Kp
	property pocket : String = ""

	def initialize(json : JSON::Any)
		@json = json
	end

	def json
		@json
	end
	
	def do_its(glob, va, lno)
		js, va2 = json_eval(json,va)
		x = js.raw
		if x.is_a?(Array)
			x.each do |value|
				ijson = KpIjson.new(value)
				ret = go_act(glob, ijson)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if x.is_a?(Hash)
			if va2.size > 0 && va2[0] == "*"
				x.each do |key, value|
					ijson = KpIjson.new(value)
					ijson.names["parent_key"] = key
					ret = go_act(glob, ijson)
					if ret != 0
						return(ret)
					end
				end
				return(0)
			end

			ijson = KpIjson.new(js)
			return( go_act(glob, ijson) )
		end

		return(0)
	end
	
	def get_var(glob, va, lno)
		js, va2 = json_eval(json,va)
		if va2.size > 0 && va2[va2.size-1] != "*"
			if v = names[ va[0] ]?
				return(true, v )
			end
			return(false, "?" + va2[va2.size-1] + "?")
		end
		x = js.raw
		if x.is_a?(String)
			return(true, x.to_s )
		end
		if x.is_a?(Int64)
			return(true, x.to_s )
		end
		if x.is_a?(Float64)
			return(true, x.to_s )
		end
		if x.is_a?(Bool)
			return(true, x.to_s )
		end
		if x.is_a?(Nil)
			return(true, "Nil" )
		end
		if va2.size == 0
			return(false, "?  type  ?")
		end
		return(false, "?" + va2[0] + "?")
	end
	
	def json_eval(js, va)
		if va.size == 0
			return(js,va)
		end
		x = js.raw
		if x.is_a?(Hash)
			if j = js[ va[0] ]?
				return( json_eval(j, va[1..] ) )
			end
			return(js, va)
		end
		if x.is_a?(Hash)
			return(js,va)
		end
		return(js,va)
	end

end

def json_cmd(glob,winp,cmd)

	if cmd.k_cmd == "add" 
		lns = File.read( cmd.k_file )
		value = JSON.parse(lns)
		ijson = KpIjson.new(value)
		ijson.pocket = cmd.k_pocket
		glob.jsons[ cmd.k_pocket] = ijson
	end

end

def json_all(glob, va, lno)
	glob.jsons.each do |key, value|
		if va.size > 1 && va[1] != ""
			if key != va[1]
				next
			end
		end
		ret = go_act(glob, value)
		if ret != 0
			return(ret)
		end
#		puts key
	end
	return(0)
end

class KpIxml < Kp
	property pocket : String = ""

	def initialize(xml : XML::Node)
		@xml = xml
	end

	def xml
		@xml
	end

	def get_var(glob, va, lno)
		xs,va2 = xml_eval_var(xml, va)
		if xs.is_a?(String)
			return(true, xs )
		end
		if v = names[ va[0] ]?
			return(true, v )
		end
		return(false, "?" + va[0] + "?")
	end
	
	def xml_eval_var(xs, va)
		if va[0] == "*"
			return(xs.content, va[1..])
		end
		if v = xs[ va[0] ]?
			return( v, va[1..] )
		end
		xs.children.each do |child|
			if va[0] == child.name
				if va.size > 1
					return( xml_eval_var(child, va[1..] ) )
				end
				return(child.content, va[1..])
			end
		end
		return(xs,va)
	end
	
	def do_its(glob, va, lno)
#		xs,va2 = xml_eval_its(xml, va)
		xml.children.select(&.element?).each do |child|
			if va[0] == "*" || va[0] == child.name
				ixml = KpIxml.new(child)
				ixml.names["parent_key"] = child.name
				ret = go_act(glob, ixml)
				if ret != 0
					return(ret)
				end
		 	end
		end
		return(0)
	end
end
	
def xml_cmd(glob,winp,cmd)

	if cmd.k_cmd == "add" 
		lns = File.read( cmd.k_file )
		value = XML.parse(lns)
		xml = value.first_element_child
		if xml
			ixml = KpIxml.new(xml)
			ixml.pocket = cmd.k_pocket
			glob.xmls[ cmd.k_pocket] = ixml
		end
	end
end

def xml_all(glob, va, lno)
	glob.xmls.each do |key, value|
		if va.size > 1 && va[1] != ""
			if key != va[1]
				next
			end
		end
		ret = go_act(glob, value)
		if ret != 0
			return(ret)
		end
#		puts key
	end
	return(0)
end

class KpIyaml < Kp
	property pocket : String = ""

	def initialize(yaml : YAML::Any)
		@yaml = yaml
	end

	def yaml
		@yaml
	end
	def do_its(glob, va, lno)
		js, va2 = yaml_eval(yaml,va)
#		puts yaml,js
		x = js.raw
		if x.is_a?(Array)
			x.each do |value|
				iyaml = KpIyaml.new(value)
				ret = go_act(glob, iyaml)
				if ret != 0
					return(ret)
				end
			end
			return(0)
		end
		if x.is_a?(Hash)
			if va2.size > 0 && va2[0] == "*"
				x.each do |key, value|
					iyaml = KpIyaml.new(value)
#					puts key
#					puts key.to_s
					iyaml.names["parent_key"] = key.to_s
					ret = go_act(glob, iyaml)
					if ret != 0
						return(ret)
					end
				end
				return(0)
			end

			iyaml = KpIyaml.new(js)
			return( go_act(glob, iyaml) )
		end

		return(0)
	end
	
	def get_var(glob, va, lno)
		js, va2 = yaml_eval(yaml,va)
		if va2.size > 0 && va2[va2.size-1] != "*"
			if v = names[ va[0] ]?
				return(true, v )
			end
			return(false, "?" + va2[va2.size-1] + "?")
		end
		x = js.raw
		if x.is_a?(String)
			return(true, x.to_s )
		end
		if x.is_a?(Int64)
			return(true, x.to_s )
		end
		if x.is_a?(Float64)
			return(true, x.to_s )
		end
		if x.is_a?(Bool)
			return(true, x.to_s )
		end
		if x.is_a?(Nil)
			return(true, "Nil" )
		end
		if va2.size == 0
			return(false, "?  type  ?")
		end
		return(false, "?" + va2[0] + "?")
	end
	
	def yaml_eval(js, va)
		if va.size == 0
			return(js,va)
		end
		x = js.raw
		if x.is_a?(Hash)
			if j = js[ va[0] ]?
				return( yaml_eval(j, va[1..] ) )
			end
			return(js, va)
		end
		if x.is_a?(Hash)
			return(js,va)
		end
		return(js,va)
	end

end

def yaml_cmd(glob,winp,cmd)
	if cmd.k_cmd == "add" 
		lns = File.read( cmd.k_file )
		value = YAML.parse(lns)
#		puts value
		iyaml = KpIyaml.new(value)
		iyaml.pocket = cmd.k_pocket
		glob.yamls[ cmd.k_pocket] = iyaml
	end
end

def yaml_all(glob, va, lno)
	glob.yamls.each do |key, value|
		if va.size > 1 && va[1] != ""
			if key != va[1]
				next
			end
		end
		ret = go_act(glob, value)
		if ret != 0
			return(ret)
		end
#		puts key
	end
	return(0)
end


