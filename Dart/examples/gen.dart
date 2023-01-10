library gen;
import 'dart:io';
part 'structs.dart';
part 'run.dart';

void main(List<String> arguments) 
{
  var act = new ActT();
  var ln = 'Comp Element parent Comp FindIn  aa qq';
  var tok = getw(ln,0);
  print(tok);
  load(act,tok[1], ln, tok[0], "1");
  ln = 'Element name C1 NAME  * of element';
  tok = getw(ln,0);
  print(tok);
  load(act,tok[1], ln, tok[0], "1");
  print( act.ap_comp[0].names["k_comp"] );
  print( act.ap_comp[0].names["doc"] );
  print( act.index["Comp_Element"] );
}


List fnd(act, s, f, chk, lno)
{
	var v = act.index[s];
	if (v != null) {
		return( [ true, int.parse(v) ] );
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


