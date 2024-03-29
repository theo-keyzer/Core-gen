part of gen;

class KpExtra extends Kp 
{
	dynamic parsedJson;

	List get_var(glob, va, lno) {
		var v = names[ va[0] ];
		if(v != null) {
			return( [true, v] );
		}
		if ( parsedJson is String ) { 
			return( [true, parsedJson] );
		}
		if ( parsedJson is Set && va[0] == '*' ) { 
			var l = parsedJson.toList();
			l.sort();
			return( [true, l.join(",") ] );
		}
		if ( parsedJson is Map ) { 
			var v = parsedJson[ va[0] ];
			if(v != null) {
				return( get_var2(glob, va.sublist(1), lno, v) );
			}
			if (parsedJson.containsKey(va[0]) ) {
				return( [true, 'null'] );
			}
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Kp?"] );			
	}
		
	List get_var2(glob, va, lno, std) {
		if ( std is String ) { 
			return( [true, std] );
		}
		if ( std is Set  ) { 
			var l = std.toList();
			l.sort();
			return( [true, l.join(",") ] );
		}
		if( va.length < 1) {
			return( [false, "??" + line_no + "," + lno + ",Kp?"] );			
		}
		if( std is Kp ) {
			return( std.get_var(glob, va, line_no) );
		}
		if ( std is Map ) { 
			var v = std[ va[0] ];
			if(v != null) {
				return( get_var2(glob, va.sublist(1), lno, v) );
			}
			if (std.containsKey(va[0]) ) {
				return( [true, 'null'] );
			}
		}
		return( [false, "?" + va[0] + "?" + line_no + "," + lno + ",Kp?"] );			
	}
	
	int do_its(glob, va, lno) {
		var v = names[ va[0] ];
		if(v != null) {
			if (va.length < 3) {
				var extra = new KpExtra();
				extra.names["value"] = v;
				return( go_act(glob, extra) );
			}
			var vas = v.split( va[2] );
//			List newList = List.from(vas);
			for(var val in vas) {
//				newList.remove(val);
				var extra = new KpExtra();
				extra.names["value"] = val;
//				extra.parsedJson = newList;
				var ret = go_act(glob, extra);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if ( parsedJson is List || parsedJson is Set) { 
			for(var std in parsedJson) {
				if(std is! Kp) { 
					var extra = new KpExtra();
					extra.parsedJson = std;
					std = extra;
				}
				if (va.length > 1) {
					var ret = std.do_its(glob, va.sublist(1), lno);
					if (ret != 0) {
						return(ret);
					}
					continue;
				}
				var ret = go_act(glob, std);
				if (ret != 0) {
					return(ret);
				}
			}
			return(0);
		}
		if ( parsedJson is Map ) { 
			if( va[0] == "*" ) {
				for (var key in parsedJson.keys) {
					var extra = new KpExtra();
					extra.parsedJson = parsedJson[key];
					extra.names[ "parent_key" ] = key;
					var ret = go_act(glob, extra);
					if (ret != 0) {
						return(ret);
					}
				}
				return(0);
			}
			var v = parsedJson[ va[0] ];
			if( v == null ) {
				if (parsedJson.containsKey(va[0]) ) {
					return( 0 );
				}
				print("?No its " + va[0] + " cmd for KpExtra," + lno + "?");
				return(0);
			}
			if ( v is Map ) { 
				var extra = new KpExtra();
				extra.parsedJson = v;
				if (va.length > 1) {
					return( extra.do_its(glob, va.sublist(1), lno) );
				}
				return( go_act(glob, extra) );
			}
			if ( v is List  || v is Set) { 
				for(var std in v) {
					var extra = new KpExtra();
					extra.parsedJson = std;
					if (va.length > 1) {
						var ret = extra.do_its(glob, va.sublist(1), lno);
						if (ret != 0) {
							return(ret);
						}
						continue;
					}
					var ret = go_act(glob, extra);
					if (ret != 0) {
						return(ret);
					}
				}
			}
			return(0);
		}
		if( va[0] == "*" ) {
			return(0);
		}
		print("?No its " + va[0] + " cmd for KpExtra," + lno + "?");
		return(0);
	}
}

void clear_cmd(glob,winp,cmd) 
{
	var item = strs(glob, winp, cmd.k_item, cmd.line_no, true,true );
	var pocket = strs(glob, winp, cmd.k_pocket, cmd.line_no, true,true );
	var data = strs(glob, winp, cmd.k_data, cmd.line_no, true,true );
	if(item == "E_O_L") {
		glob.pocket.remove( pocket[1] );
		return;
	}
	var v = glob.pocket[ pocket[1] ].parsedJson;
	if(v == null) {
		return;
	}
	if(v is Map) {
		if(data == "") {
			glob.pocket[ pocket[1] ].parsedJson.remove( item[1] );
			return;
		}
		if( v[ item[1] ] is Set ) {
			glob.pocket[ pocket[1] ].parsedJson[ item[1] ].remove( data[1] );
		}
	}
}

int all_cmd(glob,winp,va) 
{
	for (var key in glob.pocket.keys) {
		var std = glob.pocket[ key ].parsedJson;
		if( std is Map ) {
			for (var key2 in std.keys) {
				var extra = new KpExtra();
				extra.names['pocket'] = key;
				extra.names['key'] = key2;
				extra.parsedJson = std[key2];
				var l = extra.parsedJson.toList();
				l.sort();
				extra.names['value'] = l.join(",");
				var ret = go_act(glob, extra);
				if (ret != 0) {
					return(ret);
				}
			}
		}
	}
	return(0);
}

int add_cmd(glob,winp,cmd) 
{
	var item = strs(glob, winp, cmd.k_item, cmd.line_no, true,true );
	var pocket = strs(glob, winp, cmd.k_pocket, cmd.line_no, true,true );
	if (cmd.k_what.compareTo( "json" ) == 0) {
		var extra = new KpExtra();
		var jsonData = File( item[1] ).readAsStringSync();
		extra.parsedJson = jsonDecode(jsonData);
		glob.pocket[ pocket[1] ] = extra;
	}
	if (cmd.k_what.compareTo( "list" ) == 0) {
		var v = glob.pocket[ pocket[1] ];
		if( v != null)
		{
			v.parsedJson.add( item[1] );
			return(0);
		}
		var extra = new KpExtra();
		extra.parsedJson = [ item[1] ];
		glob.pocket[ pocket[1] ] = extra;
	}
	if (cmd.k_what.compareTo( "collect" ) == 0) {
		var v = glob.pocket[ pocket[1] ];
		if( v != null)
		{
			v.parsedJson.add( glob.wins[winp].dat );
			return(0);
		}
		var extra = new KpExtra();
		extra.parsedJson = [ glob.wins[winp].dat ];
		glob.pocket[ pocket[1] ] = extra;
	}
	if (cmd.k_what.compareTo( "unique" ) == 0) {
		var v = glob.pocket[ pocket[1] ];
		if( v != null)
		{
			if( v.parsedJson.contains( item[1] ) ) {
				return(1);
			}
			v.parsedJson.add( item[1] );
			return(0);
		}
		var extra = new KpExtra();
		extra.parsedJson = { item[1] };
		glob.pocket[ pocket[1] ] = extra;
	}
	if (cmd.k_what.compareTo( "map" ) == 0) {
		var data = strs(glob, winp, cmd.k_data, cmd.line_no, true,true );
		var v = glob.pocket[ pocket[1] ];
		if( v != null)
		{
			v.parsedJson[ item[1] ] = data[1];
			return(0);
		}
		var extra = new KpExtra();
		extra.parsedJson = new Map();
		extra.parsedJson[ item[1] ] = data[1];
		glob.pocket[ pocket[1] ] = extra;
	}
	if (cmd.k_what.compareTo( "hash" ) == 0) {
		var data = strs(glob, winp, cmd.k_data, cmd.line_no, true,true );
		var v = glob.pocket[ pocket[1] ];
		if( v != null)
		{
			v.parsedJson[ item[1] ] = glob.wins[winp].dat;
			return(0);
		}
		var extra = new KpExtra();
		extra.parsedJson = new Map();
		extra.parsedJson[ item[1] ] = glob.wins[winp].dat;
		glob.pocket[ pocket[1] ] = extra;
	}
	if (cmd.k_what.compareTo( "group" ) == 0) {
		var data = strs(glob, winp, cmd.k_data, cmd.line_no, true,true );
		var v = glob.pocket[ pocket[1] ];
		if( v != null)
		{
			var vd = v.parsedJson[ item[1] ];
			if(vd != null) {
				v.parsedJson[ item[1] ].add( data[1] );
				return(0);
			}
			v.parsedJson[ item[1] ] = { data[1] };
			return(0);
		}
		var extra = new KpExtra();
		extra.parsedJson = new Map();
		extra.parsedJson[ item[1] ] = { data[1] };
		glob.pocket[ pocket[1] ] = extra;
	}
	return(0);
}



