library gen;
import 'dart:io';
part 'structs.dart';
part 'run.dart';

class GlobT
{
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

void main(List<String> args) 
{
	if (args.length < 2) {
		print(args);
		return;
	}
	var glob = new GlobT();
	glob.load_errs |= load_files(args[0], glob.acts);
	glob.load_errs |= load_files(args[1], glob.dats);
	if (glob.acts.ap_actor.length > 0) {
//		kp = KpExtra.new
		var kp = new Kp();
		for(var i = 0; i < args.length; i++) {
			kp.names[ i.toString() ] = args[i];
		}
		new_act(glob, glob.acts.ap_actor[0].k_name, "", "run:1", "", "", "");
		go_act(glob, kp);
	}
	if (glob.load_errs == true || glob.run_errs == true) {
//		puts "Load error = " + glob.load_errs.to_s
//		puts "Run error = " + glob.run_errs.to_s
		print("Errors");
		exit(1);
	}

//  print( glob.dats.ap_comp[0].names["k_comp"] );
//  print( glob.dats.ap_comp[0].names["doc"] );
//  print( glob.dats.index["Comp_Element"] );
//  print(false|true|false);
}

bool load_files(files, act)
{
	var errs = false;
	var fa = files.split(",");
	for(var file in fa) {
		List<String> lns = new File(file).readAsLinesSync();
		for(var i = 0; i < lns.length; i++) {
			var lno = file + ":" + (i+1).toString();
			var tok = getw(lns[i], 0);
			if (tok[1].compareTo("E_O_F") == 0) {
				break;
			}
			errs |= load(act, tok[1], lns[i], tok[0], lno);
		}
	}
	errs |= refs(act);
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
			var v = dat.get_var(glob, act.k_attr, act.line_no);
			if (chk( act.k_eq, v[1], act.k_value) == false ) {
				continue;
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
			print(cmd.k_desc);
		}
		if (cmd is KpAll) {
			new_act(glob, cmd.k_actor, "", "run:1", "", "", "");
			var va = cmd.k_what.split(".");
			var ret = do_all(glob, va, cmd.line_no);
			if (ret > 1) {
				return(ret);
			}
//			go_act(glob, new Kp() );
		}
		if (cmd is KpIts) {
			new_act(glob, cmd.k_actor, "", "run:1", "", "", "");
			var va = cmd.k_what.split(".");
			var ret = glob.wins[winp].dat.do_its(glob, va, cmd.line_no);
			if (ret > 1) {
				return(ret);
			}
//			go_act(glob, new Kp() );
		}
	}
	return(0);
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


