require "db"
require "pg"

def db_load(where, dat)
	i = 0
	ins = "Insert into kp.\"model\" ("
	
	dat.names.each do |key,val|
		if key.size > 2 && key[0..1] == "k_"
			next
		end
		if i != 0
			ins += ", "
		end
		ins += "\"" + key + "\""
		i += 1
	end
	ins += ") values ("
	i = 0
	dat.names.each do |key,val|
		if key.size > 2 && key[0..1] == "k_"
			next
		end
		if i != 0
			ins += ", "
		end
		ins += "'" + val + "'"
		i += 1
	end
	ins += ");"
	puts ins
	DB.open(where) do |db|
		db.exec ins
		db.exec "commit;"
	end
end

def db_select(where, what)
	rows : Array(KpExtra) = Array(KpExtra).new
	DB.open(where) do |db|
		db.query what do |rs|
  			rs.each do
				kp = KpExtra.new()
  				rs.column_names.each do |cn|
  					if cn == "pk_id"
  						kp.names[cn] = rs.read(Int32).to_s
  						next
  					end
					kp.names[cn] = rs.read(String)
				end
				rows << kp
  			end
  		end
  	end
  	return rows
end


