require "db"
require "pg"

def db_load(where, dat, tbl)
	i = 0
#	ins = "Insert into kp.\"model\" ("
	ins = "Insert into " + tbl + " ("
	
	dat.names.each do |key,val|
#		if key.size > 2 && key[0..1] == "k_"
#			next
#		end
		if i != 0
			ins += ", "
		end
		ins += "\"" + key + "\""
		i += 1
	end
	ins += ") values ("
	i = 0
	args = [] of DB::Any
	dat.names.each do |key,val|
#		if key.size > 2 && key[0..1] == "k_"
#			next
#		end
		if i != 0
			ins += ", "
		end
		ins += "$" + (i+1).to_s  # "?" for some dbs
		args << val
#		val = val.sub("'", " ")
#		ins += "'" + val + "'"
		i += 1
	end
	ins += ") RETURNING pk_id;"
	puts ins
	id = -1
	DB.open(where) do |db|
		db.query ins, args: args do |rs|
  			rs.each do
  				id = rs.read(Int32)
  			end
  		end
#		er = db.exec ins
#		puts er
#		db.exec "commit;"
	end
	dat.names[ "pk_id" ] = id.to_s
end

def db_select(where, what)
	rows : Array(KpExtra) = Array(KpExtra).new
	DB.open(where) do |db|
		db.query what do |rs|
  			rs.each do
				kp = KpExtra.new()
  				rs.column_names.each_with_index do |cn,i|
#  					puts cn
#  					puts rs.column_type(i)
  					begin
	  					case rs.column_type(i)
  						when String.class
  							kp.names[cn] = rs.read(String)
  						when Int32.class
  							kp.names[cn] = rs.read(Int32).to_s
  						else
  							puts cn, rs.column_type(i)
						end
					rescue
  					end
				end
				rows << kp
  			end
  		end
  	end
  	return rows
end

def db_create(where, dat, tbl)
	i = 0
	cre = "Create table " + tbl + " ("
	cre += "pk_id  serial PRIMARY KEY, parent_id  integer"
	puts cre
	dat.names.each do |key,val|
		cre += ", \"" + key + "\" text"
	end
	cre += ");"
	puts cre
	DB.open(where) do |db|
		db.exec cre
	end
end



