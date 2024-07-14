part of gen;

typedef Record = ( {bool ok, dynamic dat, List path} );

int this_cmd(glob,winp,cmd)
{
	var va = cmd.k_path.split(".");
	var rec = get_path(glob, glob.winp, va, cmd.line_no);
	var dat = rec.dat;
	var data_type = dat.runtimeType.toString();
	if(dat is List) data_type = "List";
	if(dat is Map) data_type = "Map";
	glob.wins[winp+1].data_type = data_type;
	glob.wins[winp+1].data_key = "";
	if( rec.path.length == 0 )
	{
		var ret = go_act(glob,dat);
		if (ret > 1) {
			return(ret);
		}
		return(0);
	}
	if(dat is Kp)
	{
		if( rec.path[0].length == 0 || rec.path[0] == ".")
		{
			var ret = go_act(glob,dat);
			if (ret > 1) {
				return(ret);
			}
			return(0);
		}
		var ret = rec.dat.do_its(glob, rec.path, cmd.line_no);
		if (ret > 1) {
			return(ret);
		}
		return(0);
	}
	if(dat is List)
	{
		for(var std in dat) {
			var ret = go_act(glob,std);
			if (ret > 1) {
				return(ret);
			}
		}
		return(0);
	}
	if(dat is Map)
	{
		for(var key in dat.keys) {
			glob.wins[winp+1].data_key = key;
			var ret = go_act(glob,dat[key]);
			if (ret > 1) {
				return(ret);
			}
		}
		return(0);
	}
	return(0);
}

int replace_cmd(glob,winp,cmd)
{
	var st = strs(glob, winp, cmd.k_match, cmd.line_no, true,true );
	var k_match = st[1];
	st = strs(glob, winp, cmd.k_with, cmd.line_no, true,true );
	var k_with = st[1];
	st = strs(glob, winp, cmd.k_path, cmd.line_no, true,true );
	var va = st[1].split(":");
	var path = va[0].split(".");
	var rec = get_path(glob, glob.winp, path, cmd.line_no);
	var dat = rec.dat;
//	print(k_match);
	if(dat is Map)
	{
		var val = dat[ va[1] ];
		if( val is! String ) { return(0); }
		if( cmd.flags.contains("group") ) {
			val = replaceMapped(val, RegExp(k_match), k_with);
		} else {
			val = val.replaceAll( RegExp(k_match), k_with);
		}
		dat[ va[1] ] = val;
	}
	return(0);
}

String replaceMapped(String originalString, RegExp regex, String replacement) {
	final buffer = StringBuffer();
	int start = 0;

	for (final match in regex.allMatches(originalString)) {
		final capturedGroups = match.groups;

		if (capturedGroups == null) {
		buffer.write(originalString.substring(start, match.start));
		start = match.end;
		continue;
		}
		buffer.write(originalString.substring(start, match.start));
		start = match.end;
		buffer.write(replacement.replaceAllMapped(RegExp(r'\\(\d+)'), (m) {
			final groupIndex = int.tryParse(m.group(1)!) ?? 0;
			var gg = match.group(groupIndex);
			if(gg is String) return(gg);
			return "-";
		}));
		start = match.end;
	}
	buffer.write(originalString.substring(start));
	return buffer.toString();
}

int add_cmd(glob,winp,cmd)
{
	dynamic k_data = cmd.k_data;
	if( cmd.flags.contains("me") ) {
		k_data = glob.wins[winp].dat;
	} else {
			var st = strs(glob, winp, cmd.k_data, cmd.line_no, true,true );
			k_data = st[1];
	}
	if( cmd.flags.contains("node") ) {
		var va = k_data.split(":");
		var path = va[0].split(".");
		var rec = get_path(glob, glob.winp, path, cmd.line_no);
		k_data = rec.dat;
	}
	if( cmd.flags.contains("file") ) {
		try {
			var file = File(k_data);
			k_data = file.readAsStringSync();
		} catch(e) {
			print(e);
			return(0);
		}
	}
	if( cmd.flags.contains("json") ) {
		try {
			k_data = json.decode(k_data);
		} catch(e) {
			print(e);
			return(0);
		}
	}
	var st = strs(glob, winp, cmd.k_path, cmd.line_no, true,true );
	var va = st[1].split(":");
	var path = va[0].split(".");
	var rec = get_path(glob, glob.winp, path, cmd.line_no);
	var dat = rec.dat;
	if(dat is List)
	{
		if( cmd.flags.contains("check") || cmd.flags.contains("break") ) {
			if( dat.contains( k_data ) ) {
				if( cmd.flags.contains("break") ) {
					return(2);
				}
                		glob.wins[winp].is_check = true;
				return(0);
			}
		}
		if( cmd.flags.contains("no_add") ) {
			return(0);
		}
		dat.add( k_data );
	}
	if(dat is Map)
	{
		if( cmd.flags.contains("map") ) {
			if( dat[ va[1] ] is! Map || cmd.flags.contains("clear") ) {
				dat[ va[1] ] = new Map();
			}
			return(0);
		}
		if( cmd.flags.contains("list") ) {
			if( dat[ va[1] ] is! List || cmd.flags.contains("clear") ) {
				dat[ va[1] ] = [];
			}
			return(0);
		}
		if( cmd.flags.contains("check") || cmd.flags.contains("break") ) {
			if( dat[ va[1] ] == k_data ) {
				if( cmd.flags.contains("break") ) {
					return(2);
				}
                		glob.wins[winp].is_check = true;
				return(0);
			}
		}
		if( cmd.flags.contains("no_add") ) {
			return(0);
		}
		dat[ va[1] ] = k_data;
	}
//	print(glob.collect);
	return(0);
}

Record get_path(glob, winp, va, lno)
{
	dynamic dat;
	if( va.length == 0 )
	{
		return(ok: true, dat: glob.wins[winp].dat, path: []);
//		return(ok: false, dat: "err2", path: va);
	}
	if( va[0] == "_" )
	{
		dat = glob.collect;
		return( get_node( glob, dat, va.sublist(1), lno ) );
	}
	if (va[0].length > 0 || va.length == 1) 
	{
		dat = glob.wins[winp].dat;
		return( get_node( glob, dat, va, lno ) );
	}
	if( va[1].length == 0 )
	{
		return(ok: true, dat: glob.wins[winp].dat, path: va.sublist(1));
	}
	if (va[1].compareTo( "+" ) == 0) {
		return(ok: true, dat: (glob.wins[winp].cnt+1).toString(), path: [] );
	}
	if (va[1].compareTo( "0" ) == 0) {
		if (glob.wins[winp].cnt != 0) {
			return(ok: true, dat: "", path: [] );
		}
		return(ok: true, dat: va[2], path: [] );
	}
	if (va[1].compareTo( "1" ) == 0) {
		if (glob.wins[winp].cnt == 0) {
			return(ok: true, dat: "", path: []);
		}
		return(ok: true, dat: va[2], path: [] );
	}
	if (va[1].compareTo( "_arg" ) == 0) {
		return(ok: true, dat: glob.wins[winp].arg, path: [] );
	}
	if (va[1].compareTo( "_depth" ) == 0) {
		return(ok: true, dat: winp.toString(), path: [] );
	}
	if (va[1].compareTo( "_type" ) == 0) {
		dat = glob.wins[winp].dat;
		var data_type = dat.runtimeType.toString();
		if(dat is List) data_type = "List";
		if(dat is Map) data_type = "Map";
		return(ok: true, dat: data_type, path: [] );
	}
	if (va[1].compareTo( "_key" ) == 0) {
		return(ok: true, dat: glob.wins[winp].data_key, path: [] );
	}
	for(var i = winp-1; i >= 0; i--) 
	{
		if ( glob.wins[i].name == va[1] ) 
		{
			return( get_path(glob, i , va.sublist(2), lno) );
		}
	}
	return(ok: false, dat: "?" + va[1] + "?" + lno + "?", path: va);
}

Record get_node(glob, dat, va, lno)
{
	if( va.length == 0 )
	{
		return(ok: true, dat: dat, path: va);
	}
	if( va[0].length == 0 )
	{
		return(ok: true, dat: dat, path: ["."]);
	}
	if(dat is Map)
	{
		if( dat.containsKey(va[0]) ) {
			return( get_node( glob, dat[ va[0] ], va.sublist(1), lno ) );
		}
		return(ok: true, dat: dat, path: va);
	}
	return(ok: true, dat: dat, path: va);
}


