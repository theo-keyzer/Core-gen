part of gen;

typedef Record = ( {bool ok, dynamic dat, List path} );

int this_cmd(glob,winp,cmd)
{
	var va = cmd.k_path.split(".");
	var rec = get_path(glob, glob.winp, va, cmd.line_no);
	var dat = rec.dat;
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
			var ret = go_act(glob,dat[key]);
			if (ret > 1) {
				return(ret);
			}
		}
		return(0);
	}
	return(0);
}

int check_cmd(glob,winp,cmd)
{
	var va = cmd.k_path.split(":");
	var path = va[0].split(".");
	var rec = get_path(glob, glob.winp, path, cmd.line_no);
	var dat = rec.dat;
	if(dat is List)
	{
		if( cmd.flags.contains("check") || cmd.flags.contains("break") ) {
			if( dat.contains( cmd.k_data ) ) {
				if( cmd.flags.contains("break") ) {
					return(2);
				}
                		glob.wins[winp].is_check = true;
				return(0);
			}
		}
	}
	if(dat is Map)
	{
		if( cmd.flags.contains("check") || cmd.flags.contains("break") ) {
			if( dat[ va[1] ] == cmd.k_data ) {
				if( cmd.flags.contains("break") ) {
					return(2);
				}
                		glob.wins[winp].is_check = true;
				return(0);
			}
		}
	}
	return(0);
}

int add_cmd(glob,winp,cmd)
{
	var va = cmd.k_path.split(":");
	var path = va[0].split(".");
	var rec = get_path(glob, glob.winp, path, cmd.line_no);
	var dat = rec.dat;
	if(dat is List)
	{
		if( cmd.flags.contains("check") || cmd.flags.contains("break") ) {
			if( dat.contains( cmd.k_data ) ) {
				if( cmd.flags.contains("break") ) {
					return(2);
				}
                		glob.wins[winp].is_check = true;
				return(0);
			}
		}
		dat.add( cmd.k_data );
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
			if( dat[ va[1] ] == cmd.k_data ) {
				if( cmd.flags.contains("break") ) {
					return(2);
				}
                		glob.wins[winp].is_check = true;
				return(0);
			}
		}
		dat[ va[1] ] = cmd.k_data;
	}
	print(glob.collect);
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
		return(ok: true, dat: glob.wins[winp].dat, path: []);
	}
	for(var i = winp-1; i >= 0; i--) 
	{
		if ( glob.wins[i].name == va[1] ) 
		{
			return( get_path(glob, i , va.sublist(2), lno) );
		}
	}
	return(ok: false, dat: "err", path: va);
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


