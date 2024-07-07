part of gen;

typedef Record = ( {bool ok, dynamic dat, List path} );

int this_cmd(glob,winp,cmd)
{
	var va = cmd.k_path.split(".");
	var rec = get_path(glob, glob.winp, va, cmd.line_no);
	var dat = rec.dat;
	if(dat is Kp)
	{
		var ret = rec.dat.do_its(glob, rec.path, cmd.line_no);
		if (ret > 1) {
			return(ret);
		}
		return(0);
	}
	var ret = go_act(glob,dat);
	if (ret > 1) {
		return(ret);
	}
	return(0);
}

int append_cmd(glob,winp,cmd)
{
	var va = cmd.k_path.split(":");
	var path = va[0].split(".");
	var rec = get_path(glob, glob.winp, path, cmd.line_no);
//	print(cmd.flags);
	var dat = rec.dat;
	if(dat is List)
	{
		dat.add( cmd.k_data );
	}
	if(dat is Map)
	{
		if( cmd.flags.contains("map") ) {
			dat[ va[1] ] = new Map();
			return(0);
		}
		if( cmd.flags.contains("list") ) {
			dat[ va[1] ] = [];
			return(0);
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
		return(ok: false, dat: "err", path: va);
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
	if( va.length == 0 || va[0].length == 0 )
	{
		return(ok: true, dat: dat, path: va);
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


