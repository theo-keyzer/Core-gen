import Foundation

class Kp
{
	var kid: Int = 0;
	var kme: String = "";
	var kline: String = "";
	var names: [String: String] = [:];
	
	func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String)
	{
 		return(false, "?" + a + "?" + kline + "," + ln + "," + kme + "?");
	}
	func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int
	{
		if let v = names[ a ]
		{
			let vals = v.split(separator: ",")
			for i in 0..<vals.count
			{
				let col: Kp = Kp();
				col.kme = "Ikp";
				col.kline = "I:1";
				col.names[ "name" ] = String(i);
				col.names[ "value" ] = String( vals[i] );
				let ret = actor( act, args, col );
				if ret != 0 { return ret; }
			}
		}
		return 0;
	}
}

class KpIjson : Kp
{
    var json: JSON = JSON("");
	override func doo(_ a: String, _ b: String, _ act: String, _ args: String, _ ln: String) -> Int 
	{
//	    print(json.type)
        let sk = json_eval(json,a,b);
//	    print(sk.type)
	    if sk.type == .array 
	    { 
            for js in sk.arrayValue
            {
                let kjs: KpIjson = KpIjson();
                kjs.json = js;
                let _ = actor(act, args, kjs);
            }
	    }
	    if sk.type == .dictionary 
	    { 
	        let kjs: KpIjson = KpIjson();
	        kjs.json = sk;
	        kjs.kme = "Ijson"
			kjs.kline = "I:1";
	        let _ = actor(act, args, kjs);
	    }
	    return 0
	}
	override func get_var(_ a: String, _ b:String, _ ln: String) -> (ok: Bool, val: String) 
	{
        let sk = json_eval(json,a,b);
//        print(sk.type)
	    if sk.type == .string 
	    { 
	        return(true,  sk.stringValue )
	    }
	    if sk.type == .null 
	    { 
	        return(true,  "null" )
	    }
 		return(false, "?" + a + "?" + kline + "," + ln + "," + kme + "?");
	}
}

func json_eval(_ js: JSON, _ a: String, _ b: String) -> JSON
{
    if js.type == .string 
    { 
        return( js )
    }
    if js.type == .dictionary 
    { 
        let sc = splitc(a)
        if sc.b == ""
        {
            let sk = js[a]
            if b == ""
            {
                return( sk )
            }
            let ss = split(b);
            return( json_eval(sk, ss.a,ss.b) )
        }
    }
    return(js);
}

func json_all(_ st: KpAll, _ what: String, _ vargs: String)
{
    for (_, js) in Json
    {
        let kjs: KpIjson = KpIjson();
        kjs.json = js;
        let _ = actor(st.kactor, vargs, kjs);
    }
}

func json_cmd(_ st: KpJson)
{
	if st.kcmd == "add" 
	{
		let jf = read_file(st.kfile);
		Json[ st.kpocket ] = JSON(parseJSON: jf)
//		print (jf)
	}
}

func read_file(_ fn: String) -> String
{
    do 
    {
        let url = URL(fileURLWithPath: fn);
        let text = try String(contentsOf: url, encoding: .utf8)
        return( text );
    }
    catch 
    {
        print("error read file ", fn);
    }
    return("");
}

func group_all(_ st: KpAll, _ what: String, _ vargs: String) -> Int
{
				var j = 0;
				if what != ""
				{
				
					if let poc = Group[ what ] 
					{
						for (key, vals) in poc
						{
							let co = str_join(vals);
							let col: Kp = Kp();
							col.kme = "Igroup";
							col.kline = "I:1";
							col.names[ "pocket" ] = what;
							col.names[ "key" ] = key;
							col.names[ "value" ] = co;
							let ret = actor( st.kactor, vargs, col);
			            if ret < 0 { continue }
			            if ret != 0 { return ret; }
							j += 1;
						}
					}
					return 0;
				}
				
				for (grp, keys) in Group
				{
					for (key,vals) in keys
					{
						let co = str_join(vals);
						let col: Kp = Kp();
						col.kme = "Igroup";
						col.kline = "I:1";
						col.names[ "pocket" ] = grp;
						col.names[ "key" ] = key;
						col.names[ "value" ] = co;
						let ret = actor( st.kactor, vargs, col );
			            if ret < 0 { continue }
			            if ret != 0 { return ret; }
						j += 1;
					}
				}
				return 0;
				
}

//swift_dictionary.removeValue(forKey:4)

func group_cmd(_ st: KpGroup, _ args: String)
{
			let vs = strs(st.kvalue, true, Cact, st.kline);
			let ks = strs(st.kkey, true, Cact, st.kline);
			let ps = strs(st.kpocket, true, Cact, st.kline);
			if st.kcmd == "add" 
			{
				if var poc = Group[ ps ]
				{
					if var key = poc[ ks ]
					{
						if key.contains(vs)
						{
							return
						}
						key.append(vs);
						poc[ ks ] = key;
						Group[ ps ] = poc;
						return;
					}
					poc[ ks ] = [vs];
					Group[ ps ] = poc;
					return;
				}
				var poc: [String: [String]] = [:];
				poc[ ks ] = [vs];
				Group[ ps ] = poc
			}
			if st.kcmd == "pr" 
			{
				if ps != "E_O_L"
				{
					if let poc = Group[ ps ]
					{
						for (key,val) in poc
						{
							let co = str_join(val);
							print (ps, key, co);
						}
					}
					return;
				}
				for (pk, poc) in Group
				{
					for (key,val) in poc
					{
						let co = str_join(val);
						print (pk, key, co);
					}
					continue;
				}
			}
			if st.kcmd == "clear" 
			{
				if ps != "E_O_L"
				{
					if ks != "E_O_L"
					{
						if var poc = Group[ ps ]
						{
							poc[ ks ] = []; 	// key still there
							Group[ ps ] = poc;
						}
						return;
					}
					Group[ ps ] = [:];
					return;
				}
				Group = [:];
			}
			if st.kcmd == "remove" 
			{
				if ps != "E_O_L"
				{
					if ks != "E_O_L"
					{
						if var poc = Group[ ps ]
						{
							poc.removeValue(forKey:ks);
							Group[ ps ] = poc;
						}
						return
					}
					Group.removeValue(forKey:ps);
					return;
				}
				Group.removeAll();
			}
}

