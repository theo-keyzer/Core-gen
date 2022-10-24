require "./*"

acts = load_files("tst2.act")
defs = load_files("tst.def")

def load_files(file)

	actT = ActT.new
	lns = File.read_lines(file)

	lns.each_with_index do |ln,i|
		lno = "gen.unit:" + (i+1).to_s
		p, s = getw(ln, 0)
		if s == "E_O_F"
			break
		end
		load(actT, s, ln, p, lno)
	end
	refs(actT)
	return(actT)
end

def fnd(act, s, f, chk, lno)
	if f == chk
		return(-1)
	end
	if v = act.index[s]?
		return( v )
	end
	puts s + " not found " + lno
	return(-1)
end

go_act(acts, "arg")

def go_act(acts, an)
	acts.ap_actor.each_with_index do |act,i|
		if act.k_name != an
			next
		end
		go(acts, i)
	end
end

def go(acts,ca)

	a = acts.ap_actor[ca]
	a.childs.each_with_index do |cmd,i|
		if cmd.is_a?(KpC)
			puts cmd.k_desc
		end
		if cmd.is_a?(KpCs)
			puts cmd.k_desc
		end
		if cmd.is_a?(KpAll)
			puts cmd.k_what
			go_act(acts, cmd.k_actor)
		end
	end
end

def getws(ln, pos)
	if pos+1 > ln.size
		return(pos, "")
	end
	return(ln.size, ln[pos+1..] );
end

def getw(ln, pos)
	l = ln.size
	if pos+1 > l
		return(pos, "E_O_L")
	end
	from = pos
	i = pos
	while i < l
		from = i + 1
		if ln[i] == ' ' || ln[i] == '\t'
			i = i+1
			next
		end
		from = i
		break
	end
	if from+1 > l
		return(pos, "E_O_L")
	end
	to = from
	i = from	
	while i < l
		if ln[i] == ' ' || ln[i] == '\t'
			break
		end
		to = i
		i = i + 1
	end
	return(to+1, ln[from..to] );
end


