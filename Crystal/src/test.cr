require "./*"

class WinT

	property name : String = ""
	property cnt : Int32 = -1
	property dat : Kp = Kp.new
	property arg : String = ""
	property flno : String = ""
	property is_on : Bool = false
	property is_trig : Bool = false
	property is_prev : Bool = false
	property on_pos : Int32 = 0
	property cur_pos : Int32 = 0
	property cur_act : Int32 = 0
end

class GlobT
	property acts : ActT = ActT.new
	property dats : ActT = ActT.new
	property wins : Array(WinT) = Array(WinT).new
	property winp : Int32 = -1
end

glob = GlobT.new

#load_files("tst2.act", glob.acts)
#load_files("tst.def", glob.dats)
load_files("c_struct.act", glob.acts)
#load_files("c_run.act", glob.acts)
load_files("app.unit", glob.dats)


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
	glob.wins[winp].is_prev = false
	if winp == 0
		return
	end
    	if glob.wins[winp-1].is_on || glob.wins[winp-1].is_prev
        	if glob.wins[winp-1].is_trig == false 
			glob.wins[winp].is_prev = true
        	end
	end
end

def set_act(glob, winp)
    glob.wins[winp].is_on   = false
    glob.wins[winp].is_trig = false
#    glob.wins[winp].is_prev = false
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
	prev = false
	glob.acts.ap_actor.each_with_index do |act,i|
		if act.k_name != name
			next
		end
		if act.k_attr != "E_O_L"
			va = act.k_attr.split(".")
			r,v = s_get_var(glob, winp, va, act.line_no )
			r,ss = strs(glob, winp, act.k_value, act.line_no)
			if chk( act.k_eq, v, ss, prev) == false 
				prev = false
				next
			end
			if act.k_cc != ""
				r,s = strs(glob, winp, act.k_cc, act.line_no)
				puts s 
			end
		end
		prev = true
		glob.wins[winp].cur_act = i;
		glob.wins[winp].cnt += 1
		ret = go_cmds(glob, i, winp)
		if ret > 0
			return(ret-1)
		end
	end
	glob.winp = winp-1
	return(0)
end

def go_cmds(glob, ca, winp)

	set_act(glob,winp)
	a = glob.acts.ap_actor[ca]
	a.childs.each_with_index do |cmd,i|
	
		glob.wins[winp].cur_pos = i
		
		if cmd.is_a?(KpC)
			if glob.wins[winp].is_on && glob.wins[winp].is_trig == false
				next
			end
			trig(glob,winp)
			r,s = strs(glob, winp, cmd.k_desc, cmd.line_no)
			puts s
		end
		
		if cmd.is_a?(KpCs)
			if glob.wins[winp].is_on && glob.wins[winp].is_trig == false
				next
			end
			trig(glob,winp)
			r,s = strs(glob, winp, cmd.k_desc, cmd.line_no)
			print s
		end
		
		if cmd.is_a?(KpIts)
			r,arg = strs(glob, winp, cmd.k_args, cmd.line_no )
			new_act(glob, cmd.k_actor, arg, cmd.line_no)
			va = cmd.k_what.split(".")
			glob.wins[winp].dat.do_its(glob, va, cmd.line_no)
		end
		
		if cmd.is_a?(KpDu)
			new_act(glob, cmd.k_actor, "", cmd.line_no)
			go_act(glob,glob.wins[winp].dat)
		end
		
		if cmd.is_a?(KpAll)
			r,arg = strs(glob, winp, cmd.k_args, cmd.line_no )
			new_act(glob, cmd.k_actor, arg, cmd.line_no)
			do_all(glob, cmd.k_what, cmd.line_no)
		end
		
		if cmd.is_a?(KpBreak)
			if cmd.k_what == "E_O_L"
				return(1)
			end
			if cmd.k_what == "actor"
				return(1)
			end
			if cmd.k_what == "loop"
				return(2)
			end
			if cmd.k_what == "loop_actor"
				return(3)
			end
		end
		if cmd.is_a?(KpOut)
			if cmd.k_what == "delay"
				glob.wins[winp].is_on = true
				glob.wins[winp].on_pos = i
			end
			if cmd.k_what == "normal"
				glob.wins[winp].is_on = false
				glob.wins[winp].is_trig = false
			end
		end
	end
	return(0)
end

def trig(glob, winp)
	if glob.wins[winp].is_prev == false
		return
	end
	glob.wins[winp].is_prev = false
	prev = winp - 1
	if prev < 0
		return
	end
	if glob.wins[ prev ].is_trig == true 
		return
	end
	glob.wins[ prev ].is_trig = true
	
	goo_re(glob, prev )
end

def goo_re(glob,winp)
	trig(glob,winp)
	a = glob.acts.ap_actor[ glob.wins[winp].cur_act ]
	i = glob.wins[winp].on_pos
	while i < glob.wins[winp].cur_pos
		cmd = a.childs[i]
		if cmd.is_a?(KpC)
			r,s = strs(glob, winp, cmd.k_desc, cmd.line_no)
			puts s
		end
		
		if cmd.is_a?(KpCs)
			r,s = strs(glob, winp, cmd.k_desc, cmd.line_no)
			print s
		end
		i += 1
	end
end

def chk( eq, v, ss, prev )
	if eq == "has" || eq == "in"
		u = v.split(",") & ss.split(",")
		if u.size > 0
			return true
		end
		return false
	end
	if eq == "="
		if v == ss
			return true
		end
		return false
	end
	if eq == "!="
		if v == ss
			return false
		end
		return true
	end
	return( true )
end

def s_get_var(glob, winp, va, lno)
	if va[0] != ""
		return( glob.wins[winp].dat.get_var(glob, va, lno) )
	end
	if va.size == 1
		return(true, glob.wins[winp].dat.line_no + ", " + lno)
	end
	if va[1] == "arg"
		return(true, glob.wins[glob.winp].arg )
	end
	if va[1] == "+"
		return(true, (glob.wins[glob.winp].cnt+1).to_s )
	end
	if va[1] == "-"
		return(true, (glob.wins[glob.winp].cnt).to_s )
	end
	if va.size < 3
		return(false, "?" + va[1] + "?" + glob.wins[winp].dat.line_no + ", " + lno)
	end
	if va[1] == "0"
		if glob.wins[glob.winp].cnt != 0
			return(true, "")
		end
		return(true, va[2] )
	end
	if va[1] == "1"
		if glob.wins[glob.winp].cnt == 0
			return(true, "")
		end
		return(true,  va[2] )
	end
	i = glob.winp-1
	while i >= 0 
		if glob.wins[i].name == va[1]
			return( s_get_var(glob, i , va[2..], lno) )
		end
		i = i-1
	end
	return( var_all(glob, va[1..], lno) )
#	return(false, "?" + va[1] + "?" + glob.wins[winp].dat.line_no + ", " + lno)
end

def strs(glob, winp, s, lno)
	ok = true
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
				va = s[bp+1..i-1].split(".")
				r,v = s_get_var(glob, winp, va, lno )
				if r == false
					ok = false
				end
				if l > i+1
					i += 1
					if r != false
						v = tocase(v, s[i])
					end
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
	return(ok, ret)
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
