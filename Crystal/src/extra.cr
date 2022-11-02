require "./*"
require "json"

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
		if x.is_a?(Hash)
			ijson = KpIjson.new(js)
			return( go_act(glob, ijson) )
		end
		if x.is_a?(Array)
			x.each do |value|
				ijson = KpIjson.new(value)
				ret = go_act(glob, ijson)
				if ret != 0
					return(ret)
				end
			end
		end

		return(0)
	end
	
	def get_var(glob, va, lno)
		js, va2 = json_eval(json,va)
		if va2.size > 0 && va2[va2.size-1] != "*"
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

