library gen;
import 'dart:io';
import 'dart:convert';

part 'structs.dart';
part 'run.dart';
part 'gen.dart';
part 'extra.dart';

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
		var kp = new Kp();
		for(var i = 0; i < args.length; i++) {
			kp.names[ i.toString() ] = args[i];
		}
		new_act(glob, glob.acts.ap_actor[0].k_name, "", "run:1", "", "", "");
		go_act(glob, kp);
	}
//	print(glob.buffer);
//	stdout.write( glob.buffer.toString() );
	if (glob.load_errs == true || glob.run_errs == true) {
		print("Errors");
		exit(1);
	}

}

bool load_files(files, act)
{
	var errs = false;
	var fa = files.split(",");
	for(var file in fa) {
		List<String> lns = new File(file).readAsLinesSync();
		errs |= load_data(lns, act,file);
	}
	errs |= refs(act);
	return(errs);
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

