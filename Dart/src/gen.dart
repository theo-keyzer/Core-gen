part of gen;


class GlobT
{
	final buffer = StringBuffer();
	bool load_errs = false;
	bool run_errs = false;
	ActT acts = new ActT();
	ActT dats = new ActT();
	List<WinT> wins = [];
	int winp = -1;
}

class WinT {
	String name = "";
	int cnt = -1;
	Kp dat = new Kp();
	String attr = "";
	String eq = "";
	String value = "";
	String arg = "";
	String flno = "";
	int cur_act = 0;
}

bool load_data(lns, act, file)
{
	var errs = false;
	for(var i = 0; i < lns.length; i++) {
		var lno = file + ":" + (i+1).toString();
		var tok = getw(lns[i], 0);
		if (tok[1].compareTo("E_O_F") == 0) {
			break;
		}
		errs |= load(act, tok[1], lns[i], tok[0], lno);
	}
	return(errs);
}

void new_act(glob, actn, arg, flno, attr, eq, value)
{
	var winp = glob.winp+1;
	if (glob.wins.length <= winp) {
		glob.wins.add(new WinT());
	}
	glob.wins[winp].name = actn;
	glob.wins[winp].cnt = -1;
	glob.wins[winp].arg = arg;
	glob.wins[winp].flno = flno;
	glob.wins[winp].attr = attr;
	glob.wins[winp].eq = eq;
	glob.wins[winp].value = value;
}

int go_act(glob, dat)
{
	var winp = glob.winp+1;
	glob.winp = winp;
	glob.wins[winp].dat = dat;
	var name = glob.wins[winp].name;
	var prev = false;
	for(var i = 0; i < glob.acts.ap_actor.length; i++) {
		if (glob.acts.ap_actor[i].k_name != name) {
			continue;
		}
		var act = glob.acts.ap_actor[i];
		if (act.k_attr.compareTo("E_O_L") != 0) {
			var va = act.k_attr.split(".");
			var v = dat.get_var(glob, va, act.line_no);
			if (chk( act.k_eq, v[1], act.k_value) == false ) {
				continue;
			}
			if (act.k_cc.compareTo( "" ) != 0) {
				var res = strs(glob, winp, act.k_cc, act.line_no, true,true);
				glob.buffer.writeln(res[1]);
//				print(res[1]);
			}
		}
		prev = true;
		glob.wins[winp].cur_act = i;
		glob.wins[winp].cnt += 1;
		var ret = go_cmds(glob, i, winp);
		if (ret == 0) {
			continue;
		}
		glob.winp = winp-1;
		if (ret == 1) {
			return(ret);
		}
		return(0);
	}
	glob.winp = winp-1;
	return(0);
}

int go_cmds(glob, ca, winp)
{
	var a = glob.acts.ap_actor[ca];
	for(var i = 0; i < a.childs.length; i++) {
		var cmd = a.childs[i];
		if (cmd is KpC) {
			var res = strs(glob, winp, cmd.k_desc, cmd.line_no, false,true);
			glob.buffer.writeln(res[1]);
//			print(res[1]);
		}
		if (cmd is KpCs) {
			var res = strs(glob, winp, cmd.k_desc, cmd.line_no, false,true);
			glob.buffer.write(res[1]);
//			print(res[1]);
		}
		if (cmd is KpAll) {
			new_act(glob, cmd.k_actor, "", "run:1", "", "", "");
			var va = cmd.k_what.split(".");
			var ret = do_all(glob, va, cmd.line_no);
			if (ret > 1) {
				return(ret);
			}
		}
		if (cmd is KpDu) {
			new_act(glob, cmd.k_actor, "", "run:1", "", "", "");
			var ret = go_act(glob,glob.wins[winp].dat);
			if (ret > 1) {
				return(ret);
			}
		}
		if (cmd is KpIts) {
			new_act(glob, cmd.k_actor, "", "run:1", "", "", "");
			var va = cmd.k_what.split(".");
			var ret = glob.wins[winp].dat.do_its(glob, va, cmd.line_no);
			if (ret > 1) {
				return(ret);
			}
		}
		if (cmd is KpBreak) {
			if ( cmd.k_what.compareTo( "E_O_L" ) == 0 || cmd.k_what.compareTo( "actor" ) == 0 ) {
				return(2);
			}
			if (cmd.k_what.compareTo( "loop" ) == 0) {
				return(1);
			}
			if (cmd.k_what.compareTo( "cmd" ) == 0) {
				break;
			}
		}
	}
	return(0);
}

List s_get_var(glob, winp, va, lno)
{
	if (va.length == 1 && va[0].length > 0 ) {
		if (va[0][0] == ' ' || va[0][0] == '	') {
			var ret = "";
			for(var i = 0; i < winp; i++) {
				ret += va[0];
			}
			return( [true, ret] );
		}
	}
	if (va[0].length > 0) {
		return( glob.wins[winp].dat.get_var(glob, va, lno) );
	}
	if (va.length == 1) {
		return( [true, glob.wins[winp].dat.line_no + ", " + lno] );
	}
	for(var i = winp-1; i >= 0; i--) {
		if ( glob.wins[i].name.compareTo( va[1] ) == 0 ) {
			return( s_get_var(glob, i , va.sublist(2), lno) );
		}
	}
	return( var_all(glob, va.sublist(1), lno) );
//	return( [false, "?"] );
}

List strs(glob, winp, ss, lno, pr_err, is_err)
{
	var s = ss.split('');
	var ok = true;
	var l = s.length;
	var ret = "";
	var pos = 0;
	var dp = -3;
	var bp = -3;
	for(var i = 0; i < l; i++)
	{
		if (s[i] == '\$') {
			if (i == dp+1) {
//				if (i > 1 ) {
					ret += s.sublist(pos,i).join();
//				}
				pos = i+1;
				continue;
			}
			dp = i;
		}
		if (s[i] == '{') {
			if (i == (dp+1)) {
				if (i > 1) {
					ret += s.sublist(pos,i-1).join();
				}
				pos = i;
				bp = i;
			}
		}
		if (s[i] == '}') {
			if (bp > 0) {
				var va = s.sublist(bp+1,i).join().split(".");
//				r,v = s_get_var(glob, winp, va, lno );
				var res = s_get_var(glob, winp, va, lno );
				if (res[0] == false) {
					ok = false;
					if (pr_err == true) {
						print(res[1]);
					}
					if (is_err) {
						glob.run_errs = true;
					}
				}
				if (l > i+1) {
					i += 1;
					if (res[0] != false) {
						if (s[i] == '\$') {
//							sr,v = strs(glob, winp, v, lno, pr_err, is_err);
						} else {
							res[1] = tocase(res[1], s[i]);
						}
					}
				}
				ret += res[1];
				pos = i+1;
				dp = -3;
				bp = -3;
			}
		}
	}
	if (pos < l) {
		ret += s.sublist(pos,l).join();
	}
	return( [ok, ret] );
}

String tocase(s, c)
{
	if (c == 'u') {
		return( s.toUpperCase() );
	}
	if (c == 'd' || c == 'l') {
		return( s.toLowerCase() );
	}
	if (c == 'c') {
		return( s[0].toUpperCase() + s.substring(1) );
	}
	return(s);
}

bool chk( eq, v, ss )
{
	if (eq.compareTo('=') == 0)
	{
		if(v.compareTo(ss) == 0) { return(true); }
		return(false);
	}
	if (eq.compareTo('!=') == 0)
	{
		if(v.compareTo(ss) != 0) { return(true); }
		return(false);
	}
	if (eq.compareTo('in') == 0)
	{
		var s = ss.split(",");
		if( s.contains(v) ) { return(true); }
		return(false);
	}
	if (eq.compareTo('!in') == 0)
	{
		var s = ss.split(",");
		if( s.contains(v) ) { return(false); }
		return(true);
	}
	if (eq.compareTo('has') == 0)
	{
		var vv = v.split(",");
		if( vv.contains(ss) ) { return(true); }
		return(false);
	}
	return(false);
}

List fnd(act, s, f, chk, lno)
{
	var v = act.index[s];
	if (v != null) {
//		return( [ true, int.parse(v) ] );
		return( [ true, v ] );
	}
	if (chk == "?") {
		return( [true, -1] );
	}
	if (f == chk) {
		return( [true, -1] );
	}
	print( s + " not found " + lno);
	return( [false, -1] );
}

String get_name(m,n)
{
	var v = m[n];
	if (v == null) { return(''); }
	return(v);
}

List getws(line, pos)
{
	var ln = line.split('');
	if (pos+1 > ln.length) {
		return( [pos, ""] );
	}
	return( [ ln.length, ln.sublist(pos+1).join() ] );
}

List getw(line, pos)
{
	var ln = line.split('');
	var l = ln.length;
	if (pos+1 > l) {
		return( [pos, "E_O_L"] );
	}
	var from = pos;
	var i = pos;
	while (i < l) {
		from = i + 1;
		if (ln[i] == ' ' || ln[i] == '\t') {
			i = i+1;
			continue;
		}
		from = i;
		break;
	}
	if (from+1 > l) {
		return( [pos, "E_O_L"] );
	}
	var to = from;
	i = from;	
	while (i < l) {
		if (ln[i] == ' ' || ln[i] == '\t') {
			break;
		}
		to = i;
		i = i + 1;
	}
	return( [to+1, ln.sublist(from,to+1).join() ] );
}

List getsw(line, pos)
{
	var ln = line.split('');
	var l = ln.length;
	if (pos+1 > l) {
		return( [pos, "E_O_L"] );
	}
	var from = pos;
	var i = pos;
	while (i < l) {
		from = i + 1;
		if (ln[i] == ' ' || ln[i] == '\t') {
			i = i+1;
			continue;
		}
		from = i;
		break;
	}
	if (from+1 > l) {
		return( [pos, "E_O_L"] );
	}
	var to = from;
	i = from;
	var is_s = false;	
	while (i < l) {
		if (ln[i] == ' ' || ln[i] == '\t') {
			break;
		}
		if (ln[i] == ':') {
			is_s = true;
			break;
		}
		to = i;
		i = i + 1;
	}
	if (is_s == true) {
		return( [to+2, ln.sublist(from,to+1).join() ] );
	}
	return( [to+1, ln.sublist(from,to+1).join() ] );
}

