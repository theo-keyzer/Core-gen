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
}

void main(List<String> args) 
{
	print(args);
	if (args.length < 2) {
		return;
	}
	var glob = new GlobT();
	glob.load_errs |= load_files(args[0], glob.acts);
	glob.load_errs |= load_files(args[1], glob.dats);

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

int go_act(glob, st)
{
	return(0);
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


