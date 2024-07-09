part of gen;


class GlobT
{
//	final buffer = StringBuffer();
	bool load_errs = false;
	bool run_errs = false;
	ActT acts = new ActT();
	ActT dats = new ActT();
	int winp = -1;
	List<WinT> wins = [];
	Map pocket = new Map();
	Map jsons = new Map();
	Map collect = new Map();
}

class WinT {
	String name = "";
	int cnt = -1;
	dynamic dat = "";
	String arg = "";
	String flno = "";
	int cur_act = 0;
	int cur_pos = 0;
	int on_pos = 0;
        bool brk_act = false;
	bool is_on = false;
	bool is_trig = false;
	bool is_prev = false;
	bool is_check = false;
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

void new_act(glob, actn, arg, flno)
{
	var winp = glob.winp+1;
	if (glob.wins.length <= winp) {
		glob.wins.add(new WinT());
	}
	glob.wins[winp].name = actn;
	glob.wins[winp].cnt = -1;
	glob.wins[winp].arg = arg;
	glob.wins[winp].flno = flno;
	glob.wins[winp].brk_act = false;
	if (winp == 0) {
		return;
	}
    	if (glob.wins[winp-1].is_on || glob.wins[winp-1].is_prev) {
        	if (glob.wins[winp-1].is_trig == false) { 
			glob.wins[winp].is_prev = true;
        	}
	}
}

int go_act(glob, dat)
{
	var winp = glob.winp+1;
	glob.winp = winp;
	glob.wins[winp].dat = dat;
	var name = glob.wins[winp].name;
	var prev = false;
	var inc_cnt = true;
	for(var i = 0; i < glob.acts.ap_actor.length; i++) {
		if (glob.acts.ap_actor[i].k_name != name) {
			continue;
		}
		var act = glob.acts.ap_actor[i];
		if (act.k_attr.compareTo("E_O_L") != 0) {
			var value = strs(glob, winp, act.k_value, act.line_no, true,true );
			var sc = act.k_attr.split(":");
			var va = sc[0].split(".");
			var v = s_get_var(glob, winp, sc, va, act.line_no);
			if (chk( act.k_eq, v[1], value[1]) == false ) {
				continue;
			}
		}
		prev = true;
		glob.wins[winp].cur_act = i;
		if( inc_cnt ) {
			inc_cnt = false;
			glob.wins[winp].cnt += 1;
		}
		var ret = go_cmds(glob, i, winp);
		if( ret == 0 || ret == 3 ) {
			continue;
		}
		var nret = ret;
		if( ret == 2 ) {
			nret = 0;
		}
		if( ret < 0 && glob.wins[glob.winp].brk_act ) {
			nret = -ret;
		}
		glob.winp -= 1;
		return( nret );
	}
	glob.winp = winp-1;
	return(0);
}

int go_cmds(glob, ca, winp)
{
    	glob.wins[winp].is_on   = false;
    	glob.wins[winp].is_trig = false;
	glob.wins[winp].is_check = false;
	var a = glob.acts.ap_actor[ca];
	for(var i = 0; i < a.childs.length; i++) {
		glob.wins[winp].cur_pos = i;
		var cmd = a.childs[i];
		if (cmd is KpC) {
			if (glob.wins[winp].is_on && glob.wins[winp].is_trig == false) {
				continue;
			}
			trig(glob,winp);
			var res = strs(glob, winp, cmd.k_desc, cmd.line_no, false,true);
			stdout.writeln(res[1]);
		}
		if (cmd is KpCs) {
			if (glob.wins[winp].is_on && glob.wins[winp].is_trig == false) {
				continue;
			}
			trig(glob,winp);
			var res = strs(glob, winp, cmd.k_desc, cmd.line_no, false,true);
			stdout.write(res[1]);
		}
		if (cmd is KpAll) {
			var args = strs(glob, winp, cmd.k_args, cmd.line_no, true,true );
			new_act(glob, cmd.k_actor, args[1], cmd.line_no);
			var what = strs(glob, winp, cmd.k_what, cmd.line_no, true,true );
			var va = what[1].split(".");
			var ret = do_all(glob, va, cmd.line_no);
			if (ret > 1) {
				return(ret);
			}
		}
		if (cmd is KpThis) {
			new_act(glob, cmd.k_actor, cmd.k_args, cmd.line_no);
			var ret = this_cmd(glob,winp,cmd);
			if (ret > 1 || ret < 0) {
				return(ret);
			}
		}
		if (cmd is KpAdd) {
			var ret = add_cmd(glob,winp,cmd);
			if( ret != 0 ) {
				return(ret);
			}
		}
		if (cmd is KpCheck) {
			var ret = check_cmd(glob,winp,cmd);
			if( ret != 0 ) {
				return(ret);
			}
		}
		if (cmd is KpDu) {
			var args = strs(glob, winp, cmd.k_args, cmd.line_no, true,true );
			new_act(glob, cmd.k_actor, args[1], cmd.line_no);
			var ret = go_act(glob,glob.wins[winp].dat);
			if (ret > 1) {
				return(ret);
			}
		}
		if (cmd is KpIts) {
			var args = strs(glob, winp, cmd.k_args, cmd.line_no, true,true );
			new_act(glob, cmd.k_actor, args[1], cmd.line_no);
			var va = cmd.k_what.split(".");
			if (va[0].length == 0 && va.length > 1) {
				for(var i = winp-1; i >= 0; i--) {
					if ( glob.wins[i].name.compareTo( va[1] ) == 0 ) {
						var ret = glob.wins[i].dat.do_its(glob, va.sublist(2), cmd.line_no);
						if (ret > 1) {
							return(ret);
						}
						break;
					}
				}
				continue;
			}
			var ret = glob.wins[winp].dat.do_its(glob, va, cmd.line_no);
			if (ret > 1 || ret < 0) {
				return(ret);
			}
		}
		if (cmd is KpBreak) 
		{
			if( cmd.k_check == "True" && glob.wins[winp].is_check == false ) {
				continue;
			}
			if( cmd.k_check == "False" && glob.wins[winp].is_check == true ) {
				continue;
			}
			var ret = 0;
			if ( cmd.k_what.compareTo( "E_O_L" ) == 0 || cmd.k_what.compareTo( "actor" ) == 0 ) {
				ret = 2;
			}
			if (cmd.k_what.compareTo( "loop" ) == 0) {
				ret = 1;
			}
			if (cmd.k_what.compareTo( "cmds" ) == 0) {
				ret = 3;
			}
            		if( cmd.k_actor != "E_O_L" && cmd.k_actor != "." ) 
            		{
				for(var i = winp-1; i >= 0; i--) 
				{
					if ( glob.wins[i].name == cmd.k_actor ) 
					{
                        			glob.wins[i + 1].brk_act = true;
                        			ret = -ret;
						break;
					}
				}
			}
			return(ret);
		}
		if (cmd is KpVar) {
			var res = strs(glob, winp, cmd.k_value, cmd.line_no, true,true );
			var va = cmd.k_attr.split(".");
			if (va[0] == "" && va.length > 2) {
				for(var i = winp-1; i >= 0; i--) {
					if ( glob.wins[i].name.compareTo( va[1] ) == 0 ) {
						glob.wins[i].dat.names[ va[2] ] = res[1];
						break;
					}
				}
				continue;
			}
			glob.wins[winp].dat.names[cmd.k_attr] = res[1];
		}
		if (cmd is KpOut) {
			if (cmd.k_what.compareTo( "delay" ) == 0) {
				glob.wins[winp].is_on = true;
				glob.wins[winp].on_pos = i;
			}
			if (cmd.k_what.compareTo( "normal" ) == 0) {
				glob.wins[winp].is_on = false;
				glob.wins[winp].is_trig = false;
			}
		}
		if (cmd is KpNew) {
			if (glob.wins[winp].is_on && glob.wins[winp].is_trig == false) {
				continue;
			}
			trig(glob,winp);
			var line = strs(glob, winp, " " + cmd.k_line, cmd.line_no, true,true );
			glob.load_errs |= load(glob.dats, cmd.k_what, line[1], 0, "23");
		}
		if (cmd is KpRefs) {
			glob.load_errs |= refs(glob.dats);
		}
	}
	return(0);
}

void trig(glob, winp)
{
	if (glob.wins[winp].is_prev == false || winp == 0) {
		return;
	}
	glob.wins[winp].is_prev = false;
	var prev = winp - 1;
    	if (glob.wins[ prev ].is_on == false && glob.wins[ prev ].is_prev == false) {
		return;
	}
	if (glob.wins[ prev ].is_trig == true ) {
		return;
	}
	glob.wins[ prev ].is_trig = true;
	
	re_go_cmds(glob, prev );
}

void re_go_cmds(glob,winp)
{
	trig(glob,winp);
	var a = glob.acts.ap_actor[ glob.wins[winp].cur_act ];
	for(var i = glob.wins[winp].on_pos; i < glob.wins[winp].cur_pos; i++) {
		var cmd = a.childs[i];
		if (cmd is KpC) {
			var res = strs(glob, winp, cmd.k_desc, cmd.line_no, false,true);
			stdout.writeln(res[1]);
		}
		if (cmd is KpCs) {
			var res = strs(glob, winp, cmd.k_desc, cmd.line_no, false,true);
			stdout.write(res[1]);
		}
		if (cmd is KpNew) {
			var line = strs(glob, winp, " " + cmd.k_line, cmd.line_no, true,true );
			glob.load_errs |= load(glob.dats, cmd.k_what, line[1], 0, "23");
		}
	}
}

List cmd_var(glob, sc, varv, lcnt)
{
	dynamic dat = varv;
	for(var i = 1; i < sc.length; i++) 
	{
		if( dat is! String ) { continue; } // strings after this

		if (sc[i] == 'u') {
			dat = dat.toUpperCase();
		}
		if (sc[i] == 'l') {
			dat = dat.toLowerCase();
		}
		if (sc[i] == 'c') {
			dat = dat[0].toUpperCase() + dat.substring(1);
		}
	}
	return( [ true, dat.toString() ] );
}

List s_get_var(glob, winp, sc, va, lno)
{
	var path = va;
	var rec = get_path(glob, winp, path, lno);
//	print(rec);
	dynamic dat = rec.dat;
	if(dat is Kp && rec.path.length > 0 && rec.path[0] != ".")
	{
		var res = dat.get_var(glob, rec.path, lno);
		if( res[0] == false ) {
			return(res);
		}
		dat = res[1];
	}
	return( cmd_var(glob, sc, dat, 3) );
//	return( [true, dat.toString()] );
}

List s_get_varx(glob, winp, va, lno)
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
	if (va[1].compareTo( "arg" ) == 0) {
		return( [true, glob.wins[winp].arg] );
	}
	if (va[1].compareTo( "depth" ) == 0) {
		return( [true, winp.toString()] );
	}
	if (va[1].compareTo( "+" ) == 0) {
		return( [true, (glob.wins[winp].cnt+1).toString() ] );
	}
	if (va[1].compareTo( "-" ) == 0) {
		return( [true, (glob.wins[winp].cnt).toString() ] );
	}
	if (va.length < 3) {
		return( [false, "?" + va[1] + "?" + glob.wins[winp].dat.line_no + ", " + lno] );
	}
	if (va[1].compareTo( "0" ) == 0) {
		if (glob.wins[winp].cnt != 0) {
			return( [true, ""] );
		}
		return( [true, va[2]] );
	}
	if (va[1].compareTo( "1" ) == 0) {
		if (glob.wins[winp].cnt == 0) {
			return( [true, ""]);
		}
		return( [true,  va[2]] );
	}
	for(var i = winp-1; i >= 0; i--) {
		if ( glob.wins[i].name.compareTo( va[1] ) == 0 ) {
			return( s_get_var(glob, i , [], va.sublist(2), lno) );
		}
	}
	var st = glob.pocket[ va[1] ];
	if(st != null) {
		return( st.get_var( glob, va.sublist(2), lno ) );
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
				var sc = s.sublist(bp+1,i).join().split(":");
				var va = sc[0].split(".");
//				r,v = s_get_var(glob, winp, va, lno );
				var res = s_get_var(glob, winp, sc, va, lno );
				if (res[0] == false) {
					ok = false;
					if (pr_err == true) {
						print(res[1]);
					}
					if (is_err) {
						glob.run_errs = true;
					}
				}
//				if (l > i+1) {
//					i += 1;
//					if (res[0] != false) {
//						if (s[i] == '\$') {
//							res = strs(glob, winp, res[1], lno, pr_err, is_err);
//						} else {
//							res[1] = tocase(res[1], s[i]);
//						}
//					}
//				}
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
	if (eq.compareTo('regex') == 0)
	{
		var rx = new RegExp(ss);
		if (rx.hasMatch(v) ) {
			return( true );
		}
		return( false );
	}
	return(false);
}


