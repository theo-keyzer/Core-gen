

pub fn fnd(kp_all Kall, s string, v string, opt string, lc string) int
{
	if val := kp_all.dict[s] 
	{
//		println(s + " " + val.str() )
		return val
	}
	if opt != v
	{
		println(s + " not found " + lc) 
		println(opt + " != " + v)
	}
	return -1
}

pub fn split(s string) (string, string)
{
	mut i:= 0
	for i < s.len
	{
		if s[i] == `.` 
		{
			return s[0..i], s[i+1..s.len]
		}
		i++
	}
	return s[0..s.len], ''
}

pub fn chk(a string, eq string, c string, prev_stat bool) bool
{
	if eq == '&='
	{
		if prev_stat == false { return false }
		if a == c { return true }
		return false
	}
	if eq == '='
	{
		if a == c { return true }
		return false
	}
	if eq == '!='
	{
		if a != c { return true }
		return false
	}
	if eq == 'in'
	{
		for v in c.split(',')
		{
			if v == a { return true }
		}
		return false
	}
	if eq == 'has'
	{
		for v in a.split(',')
		{
			if v == c { return true }
		}
		return false
	}
	return true
}
pub fn str_join(val []string, order string ) string
{
	mut co := ""
	mut sval := val.clone()
	if order == 'sort' { sval.sort() }
	for i in 0 .. val.len
	{
		if i != 0 { co = co + "," }
		co = co + sval[i]
	}
	return co
}

pub fn s_get_var(vars string, sact int, lc string) (bool, string)
{
	if vars == ''
	{
		return true, acts[sact].def.fline + ', ' + lc
//		return lc
	}
	a,b := split(vars)
	if a != '' 
	{
		return acts[sact].def.get_var(a,b,lc )
	}
	if b == 'arg'
	{
		return true, acts[sact].arg
	}
	if b == '+'
	{
		return true, ( acts[sact].cnt+1 ).str()
	}
	if b == '-'
	{
		return true, ( acts[sact].cnt ).str()
	}
	c,d := split(b)
	
	if c == ''
	{
		return true, sact.str()
	}
	if c == 'next'
	{
		if sact+1 < acts.len
		{
			return s_get_var(d, sact+1,lc)
		}
	}
	if c == 'prev'
	{
		if sact > 0
		{
			return s_get_var(d, sact-1,lc)
		}
	}
	if c == '1'
	{
		if acts[sact].cnt > 0 { return true, d }
		return true, ''
	}
	if c == '0'
	{
		if acts[sact].cnt == 0 { return true, d }
		return true, ''
	}
	mut i := -1
	for sa in acts
	{
		i++
		if c == sa.name
		{
			return s_get_var(d, i,lc)
		}
	}
//	c2,d2 := split(d)
	return var_all(c,d,lc)
//	return '?' + vars + '?' + lc + '?'
}

pub fn strs(s string, chk bool, sact int, lc string) (bool, string)
{
	mut ret := ''
	mut dp := -3
	mut bp := -3
	mut pos := 0
	mut i:= 0
	for i < s.len
	{
		if s[i] == `$` 
		{
			if i == dp+1
			{
				ret += s[pos..i]
				pos = i
				i++
				continue
			}
			dp = i
		}
		if s[i] == `{`
		{
			if i == dp+1
			{
				ret += s[pos..i-1]
				pos = i
				bp = i
			}
		}
		if s[i] == `}`
		{
			if bp > 0 
			{
				vars := s[bp+1..i]
				ok, mut var := s_get_var(vars,sact,lc)
				if ok == false && chk == true
				{
					println(var)
				}
				if i+1 < s.len
				{
					var = str_case(var, s[i+1])
					i++
				}
				ret += var
				dp = -3
				bp = -3
//					if i+1 < s.len { i++ }
				pos = i+1
			}
		}
		i++
	}
	ret += s[pos..s.len]
	return true, ret
}

pub fn str_case(s string, c rune) string
{
	if s.len == 0 { return s }
	if c == `l` { return s.to_lower() }
	if c == `c` { return s[0..1].to_upper() + s[1..s.len] }
	return s
		
}

pub fn getws(ln string, pos int) (string, int)
{
	if (pos+1) > ln.len {
		return "", pos
	}
	return ln[pos+1..ln.len], ln.len
}

pub fn getw(ln string, pos int) (string, int)
{
	if (pos+1) > ln.len {
		return "E_O_L", pos
	}
	mut from := pos
	mut i := pos
	for i < ln.len
	{
		from = i+1
		if ln[i] == ` ` || ln[i] == `\t`
		{
			i++
			continue
		}
		from = i
		break
	}
	if from >= ln.len {
		return "E_O_L", from
	}
	mut to := from
	for i < ln.len
	{
		if ln[i] == ` ` || ln[i] == `\t` 
		{
			break
		}
		to = i
		i++
	}
	return ln[from..to+1], to+1
}
