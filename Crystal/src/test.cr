require "./*"

class WinT

	property name : String = ""
	property cnt : Int32 = -1
	property dat : Kp = Kp.new
	property arg : String = ""
	property flno : String = ""
end

class GlobT
	property acts : ActT = ActT.new
	property dats : ActT = ActT.new
	property wins : Array(WinT) = Array(WinT).new
	property winp : Int32 = -1
end

#print "xx"

glob = GlobT.new

load_files("tst2.act", glob.acts)
load_files("tst.def", glob.dats)


def load_files(file, act)

	lns = File.read_lines(file)

	lns.each_with_index do |ln,i|
		lno = file + ":" + (i+1).to_s
		p, s = getw(ln, 0)
		if s == "E_O_F"
			break
		end
		load(act, s, ln, p, lno)
	end
	refs(act)
end

def new_act(glob, actn, arg, flno)

	winp = glob.winp+1
	if glob.wins.size <= winp
		glob.wins << WinT.new
	end
	glob.wins[winp].name = actn
	glob.wins[winp].cnt = -1
	glob.wins[winp].arg = arg
	glob.wins[winp].flno = flno
end

if glob.acts.ap_actor.size > 0
	new_act(glob, glob.acts.ap_actor[0].k_name, "", "run:1")
	kp = Kp.new
	go_act(glob, kp)
end

def go_act(glob, dat)
	winp = glob.winp+1
	glob.winp = winp
	glob.wins[winp].dat = dat
	name = glob.wins[winp].name
	glob.acts.ap_actor.each_with_index do |act,i|
		if act.k_name != name
			next
		end
		glob.wins[winp].cnt += 1
		go(glob, i, dat)
	end
	glob.winp = winp-1
end

def go(glob,ca, dat)

	a = glob.acts.ap_actor[ca]
	a.childs.each_with_index do |cmd,i|
	
		if cmd.is_a?(KpC)
			puts strs(glob, cmd.k_desc, dat, cmd.line_no)
		end
		
		if cmd.is_a?(KpCs)
			print strs(glob, cmd.k_desc, dat, cmd.line_no)
		end
		
		if cmd.is_a?(KpIts)
			arg = strs(glob, cmd.k_args, dat, cmd.line_no )
			new_act(glob, cmd.k_actor, arg, cmd.line_no)
			va = cmd.k_what.split(".")
			dat.do_its(glob, va, cmd.line_no)
		end
		
		if cmd.is_a?(KpAll)
			arg = strs(glob, cmd.k_args, dat, cmd.line_no )
			new_act(glob, cmd.k_actor, arg, cmd.line_no)
			do_all(glob, cmd.k_what, cmd.line_no)
		end
	end
end


def s_get_var(glob, s, dat, lno)
	va = s.split(".")
#	puts vs
	if va[0] == "" && va.size > 1
		if va[1] == "arg"
			return( glob.wins[glob.winp].arg )
		end
		if va[1] == "+"
			return( (glob.wins[glob.winp].cnt+1).to_s )
		end
		if va[1] == "-"
			return( (glob.wins[glob.winp].cnt).to_s )
		end
		if va.size < 3
			return( "?" + va[1] + "?")
		end
		if va[1] == "0"
			if glob.wins[glob.winp].cnt != 0
				return("")
			end
			return( va[2] )
		end
		if va[1] == "1"
			if glob.wins[glob.winp].cnt == 0
				return("")
			end
			return( va[2] )
		end
		return( "?" + va[1] + "?")
	end
	return( dat.get_var(glob, va, lno) )
end

def strs(glob, s, dat, lno)
	l = s.size
	ret = ""
	pos = 0
	dp = -3
	bp = -3
	i = 0
	while i < l
		if s[i] == '$'
			if i == dp+1
#				if i > 1 
					ret += s[pos..i-1]
#				end
				pos = i+1
				i += 1
				next
			end
			dp = i
		end
		if s[i] == '{'
			if i == (dp+1)
				if i > 1
					ret += s[pos..i-2]
				end
				pos = i
				bp = i
			end
		end
		if s[i] == '}'
			if bp > 0
				v = s_get_var(glob, s[bp+1..i-1], dat, lno )
				if l > i+1
					i += 1
					v = tocase(v, s[i])
				end
				ret += v
				pos = i+1
				dp = -3
				bp = -3
			end
		end
		i += 1
	end
	if pos < l
		ret += s[pos..l]
	end
	return(ret)
end

def tocase(s, c)
	if c == 'u'
		return( s.upcase() )
	end
	if c == 'd' || c == 'l'
		return( s.downcase() )
	end
	if c == 'c'
		return( s.capitalize() )
	end
	if c == 'z'
		return( s.capitalize() )
	end
	return(s)
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

