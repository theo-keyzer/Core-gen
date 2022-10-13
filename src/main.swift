
struct Sact
{
	var name: String = "";
	var cnt: Int = 0;
	var def: Kp;
	var arg: String = "";
	var is_on: Bool = false
	var is_trig: Bool = false
	var is_prev: Bool = false
	var on_pos: Int = 0
	var cur_pos: Int = 0
	var cur_act: Int = 0;
}

var Acts: [Sact] = [];
var Cact: Int = -1;

func new_act(_ actn: String)
{
    if Acts.count <= Cact+1
    {
        Acts.append( Sact.init(def: Kp()) );
    }
    Acts[Cact+1].name = actn
    Acts[Cact+1].cnt = -1
}

func set_act()
{
    Acts[Cact+1].is_on   = false
    Acts[Cact+1].is_trig = false
    Acts[Cact+1].is_prev = false
    if Cact < 0 { return; }
    if Acts[Cact].is_on || Acts[Cact].is_prev
    {
        if Acts[Cact].is_trig == false 
        {
            Acts[Cact+1].is_prev = true
        }
    }
}

func actor(_ actn: String, _ args: String, _ me: Kp) -> Int
{
    if Acts.count <= Cact+1
    {
        print("Missing new_act", Cact, Acts.count)
        return 0
    }
    set_act()
    Cact += 1
    Acts[Cact].arg = args
    Acts[Cact].def = me
	var prev: Bool = false;
	var found = false;
	for i in 0..<Act.ap_actor.count
	{
	    Acts[Cact].cur_act = i;
		let st = Act.ap_actor[i];
		if actn != st.kname { continue; }
		if st.kcomp != "E_O_L" && st.kcomp != "."
		{
		    if st.kcomp != me.kme
		    {
		        continue;
		    }
		}
		found = true
		if st.kattr != "E_O_L" // && st.kattr != " "
		{
			let v = s_get_var( st.kattr, st.kline, Cact ).val  // check for ??
			let ss = strs(st.kvalue, true, Cact, st.kline);
			if chk( st.keq, v, ss, prev) == false { prev = false; continue; }
			prev = true;
			if st.kcc != "" // v1 has no E_O_L
			{
				print( strs( st.kcc, false, Cact, st.kline ) );
			}
		}
        Acts[Cact].cnt += 1
		let ret = goo( i, args, me );
		if ret > 0
		{
		    Cact -= 1
		    return ret-1;
		}
	}
	if found == false
	{
		        print("No Actor " + actn + " for " + me.kme + " " + me.kline + ", main:", #line );
	}
	Cact -= 1
	return 0;
}

func trig(_ sact: Int)
{
	if Acts[sact].is_prev == false { return }
	Acts[sact].is_prev = false
	let prev = sact - 1
	if prev < 0 { return }
	if Acts[ prev ].is_trig == true { return }
	Acts[ prev ].is_trig = true
	
	goo_re( prev )
}

func goo_re(_ sact: Int) 
{
	trig(sact)
	for i in Acts[sact].on_pos..<Acts[sact].cur_pos
	{
		let ca = Act.ap_actor[ Acts[sact].cur_act ].kchilds[i]
		if let st = ca as? KpC
		{
			let stv = strs(st.kdesc, true, sact, st.kline)
			print( stv )
		}
		if let st = ca as? KpCs
		{
			let stv = strs(st.kdesc, true, sact, st.kline)
			print(stv, terminator: "");
		}
	}
}

var Unq: [String: [String] ] = [:];
var Group: [String: [String: [String] ] ] = [:];
var Collect: [String: [Kp] ] = [:];
var Json: [String: JSON ] = [:];

func goo(_ a: Int, _ args: String, _ me: Kp) -> Int
{
	for i in 0..<Act.ap_actor[a].kchilds.count
	{
		Acts[Cact].cur_pos = i
		let ca = Act.ap_actor[a].kchilds[i];
		
		if let st = ca as? KpC
		{
			if Acts[Cact].is_on && Acts[Cact].is_trig == false { continue }
			trig(Cact);
			let s = strs( st.kdesc, false, Cact, st.kline );
			print(s);
			continue;
		}
		
		if let st = ca as? KpCs
		{
			if Acts[Cact].is_on && Acts[Cact].is_trig == false { continue }
			trig(Cact);
			let s = strs( st.kdesc, false, Cact, st.kline );
			print(s, terminator: "");
			continue;
		}
		
		if let st = ca as? KpBreak
		{
			if Acts[Cact].is_on && Acts[Cact].is_trig == false { continue }
			if st.kwhat == "E_O_L" { return 1 }
			if st.kwhat == "actor" { return 1 }
			if st.kwhat == "loop" { return 2 }
			if st.kwhat == "loop_actor" { return 3 }
			if let val = Int( st.kwhat )
			{
			    return val;
			}
			print("Unknown break cmd ", st.kwhat, st.kline);
		}
		
		if let st = ca as? KpOut
		{
			if st.kwhat == "delay"
			{
				Acts[Cact].is_on = true
				Acts[Cact].on_pos = i
			}
			if st.kwhat == "normal"
			{
				Acts[Cact].is_on = false
				Acts[Cact].is_trig = false
			}
		}
		
		if let st = ca as? KpAll
		{
			new_act(st.kactor)
			let what = split( st.kwhat );
			var vargs = "";
			if st.kargs != "" 
			{ 
				vargs = strs(st.kargs, true, Cact, st.kline);
			}
			if what.a == "Json"
			{
			    json_all(st,what.b,vargs);
			    continue;
			}
			if what.a == "Collect"
			{
			    let ss = split(what.b)
				for (key,col) in Collect
				{
				    if ss.a != "" && ss.a != key { continue; }
				    var cols = col;
				    if ss.b == "reverse" { cols.reverse(); }
					for (comp) in cols
					{
						let ret = actor( st.kactor, vargs, comp);
						if ret < 0 { continue; }
						if ret != 0 { return ret-1; }
					}
				}
				continue;
			}
			if what.a == "Group"
			{
			    let ret = group_all(st,what.b,vargs);
			    if ret != 0 { return ret; }
				continue;
			}
			let wb = strs(what.b, true, Cact, st.kline);
			let ret = do_all( what.a, wb, "", st.kactor, vargs, st.kline);
			if ret < 0 { continue }
			if ret != 0 { return ret; }
			continue;
		}
		
		if let st = ca as? KpIts
		{
			var vargs = "";
			if st.kargs != ""  // v1 has no E_O_L
			{ 
				vargs = strs(st.kargs, true, Cact, st.kline);
			}
			new_act(st.kactor)
			let ss = split(st.kwhat);
			if ss.a == "" // Its .actor_name - use that actor insead.
			{
			    let s2 = split(ss.b)
			    var i = Cact-1
			    while (i >= 0 )
			    {
			        if Acts[i].name == s2.a
			        {
			            let s3 = split(s2.b)
			            let ret = Acts[i].def.doo(s3.a, s3.b, st.kactor, vargs, st.kline);
			            if ret != 0 { return ret; }
			            break;
			        }
			        i = i-1;
			    }
			    continue;
			}
			let ret = me.doo(ss.a, ss.b, st.kactor, vargs, st.kline);
			if ret < 0 { continue }
			if ret != 0 { return ret; }
			continue;
		}
		
		if let st = ca as? KpDu
		{
			new_act(st.kactor)
			let ret = actor( st.kactor, "", me);
			if ret != 0 { return ret; }
			continue;
		}
		
		if let st = ca as? KpCollect
		{
			let ps = strs(st.kpocket, true, Cact, st.kline);
			if st.kcmd == "add" 
			{
				if var poc = Collect[ ps ]
				{
					poc.append(me);
					Collect[ ps ] = poc;
					continue;
				}
				Collect[ ps ] = [me];
			}
			if st.kcmd == "clear" 
			{
				Collect = [:];
			}
			continue;
		}
		
		if let st = ca as? KpGroup
		{
		    group_cmd(st, args);
		}
		
		if let st = ca as? KpJson
		{
		    json_cmd(st);
		}
		
		if let st = ca as? KpUnique
		{
			let vs = strs(st.kvalue, true, Cact, st.kline);
			if st.kcmd == "add" 
			{
				if var poc = Unq[ st.kkey ]
				{
					if poc.contains( vs )
					{
						break
					}
					poc.append( vs )
					Unq[ st.kkey ] = poc
					continue;
				}
				Unq[ st.kkey ] = [vs]
			}
			if st.kcmd == "check" 
			{
				if let poc = Unq[ st.kkey ]
				{
					if poc.contains( vs )
					{
						break
					}
				}
			}
			if st.kcmd == "clear" 
			{
				Unq = [:];
			}
		}
	}
	return 0;
}

let Act = readFile( CommandLine.arguments[1] );
let Def = readFile( CommandLine.arguments[2] );
var xmain: Kp = Kp();
xmain.kme = "Ikp";
xmain.kline = "I:1";
for i in 0..<CommandLine.arguments.count
{
	xmain.names[ String(i) ] = CommandLine.arguments[i];
}

if Act.ap_actor.count > 0 
{
    new_act(Act.ap_actor[0].kname)
    _ = actor(Act.ap_actor[0].kname, "", xmain)
}


