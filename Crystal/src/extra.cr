require "./*"
require "json"

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
				go_act(glob, ijson)
			end
		end

#		if va.size < 1
#			return(0)
#		end
#		x = json.raw
#		if x.is_a?(Hash)
#			if j = json[ va[0] ]?
#				ijson = KpIjson.new(j)
#				go_act(glob, ijson)
#			end
#		end
		return(0)
	end
	
	def get_var(glob, va, lno)
		js, va2 = json_eval(json,va)
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
		go_act(glob, value)
#		puts key
	end
end

