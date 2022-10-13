import Foundation

var Pos: Int = 0;
var Dict: [String: Int] = [:];
var Lno: String = "";

func readFile(_ path: String) -> ActT
{
	let act = ActT.init();
	errno = 0
	let files = path.split(separator: ",")
	for i in 0..<files.count 
	{
		var lineNo = 1;
		if freopen( String( files[i] ), "r", stdin) == nil 
		{
			perror( String( files[i] ) )
			return act
		}
		while let line = readLine() 
		{
			Lno = String( files[i] ) + ":" + String( lineNo );
			let ln = Array(line);
			Pos = 0;
    			let tok = getw(ln);
    			if tok == "E_O_F" { break; }
    			load(tok, act,  ln); 
    			lineNo += 1;
		}
	}
	refs(act);
	return act;
}

func fnd(_ s: String, _ v: String, _ opt: String, _ ln: String) -> Int
{
	if let a = Dict[s] 
	{
		return a; 
	} 
	else 
	{ 
		if opt != v { 
			print(s + " not found " + ln); 
			print(opt,v);
		}
	}
	return -1;
}

func s_get_var(_ s: String, _ ln: String, _ gact: Int) -> (ok: Bool, val: String)
	{
		if let v = Acts[gact].def.names[ s ] { return(true, v) }
		if s == "" 
		{
 			return(true, Acts[gact].def.kline + ", " + ln);
		}
		let s2 = split(s);    // {.cmd.act.var}
		if s2.a != ""
		{
			return( Acts[gact].def.get_var(s2.a, s2.b, ln) );
		}
		if s2.b == "arg" 
		{
 			return(true, Acts[gact].arg );
		}
		if s2.b == "+" 
		{
 			return(true, String( Acts[gact].cnt+1 ) );
		}
		if s2.b == "-" 
		{
 			return( true, String( Acts[gact].cnt ) );
		}
		let s3 = split(s2.b);
		if s3.a == "0" 
		{
			if Acts[Cact].cnt != 0 { return(true, ""); }
 			return(true, s3.b );
		}
		if s3.a == "1" 
		{
			if Acts[Cact].cnt == 0 { return(true, ""); }
 			return(true, s3.b );
		}
		var i = gact-1
		while (i >= 0 )
		{
		    if Acts[i].name == s3.a
		    {
		        return( s_get_var(s3.b, ln, i) );
		    }
		    i = i-1;
		}
		return( var_all(s3.a, s3.b, ln) );
//		return("?" + s3.a + "?" + Acts[gact].def.kline + "," + ln + ", s_get_var?");
	}

	
func strs(_ s: String, _ chk: Bool, _ gact: Int, _ ln: String) -> String // s string, me Kp, pos int, ln string, st Kp, isfile bool) 
{
    let sa = Array(s);
	let l = sa.count;
	var ret = "";
	var dp = -3;
	var bp = -3;
	var pos = 0;
	for i in 0..<l 
	{
		if sa[i] == "$" 
		{
			if i == dp+1
			{
				ret += sa[pos..<i];
				pos = i;
				continue;
			}
			dp = i; 
		}
		if sa[i] == "{" 
		{
			if i == dp+1
			{
				ret += sa[pos..<i-1];
				pos = i;
				bp = i;
			}
		}
		if sa[i] == "}"
		{
			if bp > 0 
			{
				let vars = String( sa[bp+1..<i] );
				let vas = s_get_var( vars, ln, gact );
				if vas.ok == false && chk == true { print(vas.val) }
				var va = vas.val
				if l > i+1
				{
					va = tocase(va, sa[i+1]);
					pos = i+2;
				} else { pos = i+1; }
				ret += va;
				dp = -3;
				bp = -3;
			}
		}
	}
	ret += sa[pos..<l];
	return ret;
}

func chk(_ eq: String, _ n: String, _ v: String, _ prev: Bool) -> Bool
{
	if eq == "&=" 
	{
		if prev == false { return false; }
		if n == v { return true; }
		return false;
	}
	if eq == "=" 
	{
		if n == v { return true; }
		return false;
	}
	if eq == "!=" 
	{
		if n != v { return true; }
		return false;
	}
	if eq == "&!=" 
	{
		if prev == false { return false; }
		if n != v { return true; }
		return false;
	}
	if eq == "in"
	{
		let vals = v.split(separator: ",")
		for i in 0..<vals.count
		{
			if n == vals[i] { return true; }
		}
		return false;
	}
	if eq == "&in"
	{
		if prev == false { return false; }
		let vals = v.split(separator: ",")
		for i in 0..<vals.count
		{
			if n == vals[i] { return true; }
		}
		return false;
	}
	if eq == "has"
	{
		let vals = n.split(separator: ",")
		for i in 0..<vals.count
		{
			if v == vals[i] { return true; }
		}
		return false;
	}
	if eq == "&has"
	{
		if prev == false { return false; }
		let vals = n.split(separator: ",")
		for i in 0..<vals.count
		{
			if v == vals[i] { return true; }
		}
		return false;
	}
	return false;

}

func tocase(_ s: String, _ what: Character) -> String
{
	if s == "" { return ""; }
	if what == "l" { return s.lowercased; }
	if what == "L" { return s.lowercased; }
	if what == "c" { return s.prefix(1).capitalized + s.dropFirst(); }
	return s;
}

func split(_ s: String) -> (a: String, b: String)
{
    	let sa = Array(s);
	let l = sa.count;
	for i in 0..<l 
	{
		if sa[i] == "." 
		{
			return( String( sa[0..<i] ), String( sa[i+1..<l] ) );
		}
	}
	return(s, "");
}
func splitc(_ s: String) -> (a: String, b: String)
{
    	let sa = Array(s);
	let l = sa.count;
	for i in 0..<l 
	{
		if sa[i] == ":" 
		{
			return( String( sa[0..<i] ), String( sa[i+1..<l] ) );
		}
	}
	return(s, "");
}


func getw(_ s: Array<Character> ) -> String
{
	let l = s.count;
	if (Pos+1) > l {
		return("E_O_L");
	}
	var from = Pos;
	for i in Pos..<l {
		from = i + 1;
		if s[i] == " " || s[i] == "\t" {
			continue;
		}
		from = i;
		break;
	}
	if from >= l { return "E_O_L" }
	var to = from;
	for j in from..<l {
		if s[j] == " " || s[j] == "\t" {
			break
		}
		to = j	;	
	}
	Pos = to+1;
	let string = String(s[from...to])

	return(string);
}

func getws(_ s: Array<Character> ) -> String
{
	let l = s.count;
	if (Pos+1) > l {
		return("");
	}
	return( String( s[Pos+1..<l] ) )
}

func str_join(_ val: [String] ) -> String
{
	var co = "";
	var i = 0;
	for (name) in val.sorted()
	{
		if i != 0 { co = co + ","; }
		co = co + name;
		i += 1;
	}
	return co;
}


