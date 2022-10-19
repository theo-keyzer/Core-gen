module main
	
import os

__global 
(

 acts []Sact
 k_all  = Kall{}
 groups  map[string]map[string][]string
 collects  map[string][]Kp
 uniques  map[string][]string
)



interface Kp {
	fline string
//	mut: names map[string]string
	get_var(string, string, string) (bool, string)
	doo(string, string, string, string, string, int,int) int
}


fn goo(a int, sact int, def Kp, cnt int, arg string) int
{
	acts[sact].cur_act = a
	mut kkme := -1
	for st in k_all.ap_actor[a].kchilds
	{
		kkme++
		acts[sact].cur_pos = kkme
//		println( st.type_name() )
		if st.type_name() == 'KpUnique'
		{
			cmd := st as KpUnique
//			sa,sb := split(cmd.k_cmd)
			_, keyv := strs(cmd.k_key, true, sact, cmd.fline)
			_, valv := strs(cmd.k_cc, true, sact, cmd.fline)
			if cmd.k_cmd == 'check'
			{
				if valv in uniques[keyv] { break }
			}
			if cmd.k_cmd == 'add'
			{
				if valv in uniques[keyv] { break }
				uniques[keyv] << valv
			}
			if cmd.k_cmd == 'clear'
			{
				if keyv != 'E_O_L'
				{
					uniques.delete(keyv)
				}
				else
				{
					uniques = map[string][]string{}
				}
			}
		}
/*		
		if st.type_name() == 'KpSet'
		{
			cmd := st as KpSet
			_, valv := strs(cmd.k_value, sact, cmd.fline)
			def.names[ cmd.k_attr ] = valv
		}
*/		
		if st.type_name() == 'KpCollect'
		{
			cmd := st as KpCollect
//			sa,sb := split(cmd.k_cmd)
			if cmd.k_cmd == 'add'
			{
				_, pocv := strs(cmd.k_pocket, true, sact, cmd.fline)
				collects[pocv] << def
			}
		}
		
		if st.type_name() == 'KpGroup'
		{
			cmd := st as KpGroup
			sa,sb := split(cmd.k_cmd)
			
			if sa == 'add' || sa == 'break'
			{
				_, pocv := strs(cmd.k_pocket, true, sact, cmd.fline)
				_, keyv := strs(cmd.k_key, true, sact, cmd.fline)
				_, valv := strs(cmd.k_value, true, sact, cmd.fline)
				if sa == 'break' || sb == 'break'
				{
					if valv in groups[pocv][keyv]
					{
						return 0
					}
				}
				if sa == 'add'
				{
					if valv !in groups[pocv][keyv]
					{
						groups[pocv][keyv] << valv
					}
				}
			}
			
			if cmd.k_cmd == 'pr' 
			{
				if cmd.k_pocket != "E_O_L"
				{
					println(groups[cmd.k_pocket])
				}
				else
				{
					println(groups)
				}
			}
		}
		
		if st.type_name() == 'KpDu'
		{
			cmd := st as KpDu
			ret := actor(cmd.k_actor, def, 0, '', sact)
			if ret != 0 { return ret }
		}
		
		if st.type_name() == 'KpAll'
		{
			cmd := st as KpAll
			_, cas := strs(cmd.k_args, true, sact, cmd.fline)
			_, what := strs(cmd.k_what, true, sact, cmd.fline)
			sa,sb := split(what)
//			println(sa + ' ' + sb)
			a2,b2 := split(sb)
//			println(a2 + ' ' + b2)
			
			if sa == 'Collect'
			{
				mut i := -1
				for key,val in collects
				{
					if a2 != '' && a2 != key { continue }
					if b2 == 'reverse'
					{
						for j := val.len-1; j >= 0; j--
						{
							i++
							ret := actor( cmd.k_actor, val[j], i, cas, sact )
							if ret != 0 { return ret-1 }
						}
						continue
					}
					for node in val
					{
						i++
						ret := actor( cmd.k_actor, node, i, cas, sact )
						if ret != 0 { return ret-1 }
					}
				}
				continue
			}
			
			if sa == 'Group'
			{
				a3,b3 := split(b2)
//			println(a3 + ' ' + b3)
				mut node := KpArg{}
				mut i := -1
				for key,val in groups
				{
					if a2 != '' && a2 != key { continue }
					for key2,val2 in val
					{
						if a3 != '' && a3 != key2 { continue }
						i++
						node.names[ 'pocket' ] = key
						node.names[ 'key' ] = key2
						node.names[ 'value' ] = str_join(val2, b3)
						node.kme = i
						node.fline = '1'
						ret := actor( cmd.k_actor, node, i, cas, sact )
						if ret != 0 { return ret-1 }
					}
				}
				continue
			}
			
			if sa == 'Unique'
			{
				mut node := KpArg{}
				for key,val in uniques
				{
					if a2 != '' && a2 != key { continue }
					for i in 0 .. val.len
					{
						node.names[ 'key' ] = key
						node.names[ 'value' ] = val[i]
						node.kme = i
						node.fline = 'Arg:1'
						ret := actor( cmd.k_actor, node, i, cas, sact )
						if ret != 0 { return ret-1 }
					}
				}
				continue
			}
			ret := do_all(sa,a2,b2,cmd.k_actor,cas, cmd.fline, sact)
			if ret != 0 { return ret }
		}
		
		if st.type_name() == 'KpIts'
		{
			cmd := st as KpIts
			_, what := strs(cmd.k_what, true, sact, cmd.fline)
			_, cas := strs(cmd.k_args, true, sact, cmd.fline)
//			sa,sb := split(cmd.k_what)
			sa,sb := split(what)
			ret := def.doo(sa,sb, cmd.k_actor, cas, cmd.fline, sact,0)
			if ret < 0 { continue }
			if ret != 0 { return ret }
		}
		
		if st.type_name() == 'KpOut'
		{
			cmd := st as KpOut
			if cmd.k_what == 'delay'
			{
				acts[sact].is_on = true
				acts[sact].on_pos = kkme
			}
			if cmd.k_what == 'normal'
			{
				acts[sact].is_on = false
				acts[sact].is_trig = false
			}
		}
		
		if st.type_name() == 'KpBreak'
		{
			if acts[sact].is_on && acts[sact].is_trig == false { continue }
			cmd := st as KpBreak
			if cmd.k_what == 'E_O_L' { return 1 }
			if cmd.k_what == 'actor' { return 1 }
			if cmd.k_what == 'loop' { return 2 }
			if cmd.k_what == 'loop_actor' { return 3 }
			return cmd.k_what.int()
		}
		
		if st.type_name() == 'KpC'
		{
			cmd := st as KpC
			if acts[sact].is_on && acts[sact].is_trig == false { continue }
			trig(sact)
			_, stv := strs(cmd.k_desc, false, sact, cmd.fline)
			println( stv )
		}
		
		if st.type_name() == 'KpCs'
		{
			cmd := st as KpCs
			_, stv := strs(cmd.k_desc, false, sact, cmd.fline)
			print( stv )
		}
		
	}
	return 0
}
pub struct Sact
{
	mut:
	name string
	cnt int
	def Kp
	arg string
	prev int
	is_on bool
	is_trig bool
	is_prev bool
	on_pos int
	cur_pos int
	cur_act int
}

fn actor(act string, def Kp, cnt int, arg string, prev int) int
{
	ca := prev+1
	if ca >= acts.len
	{
		acts << Sact{act,0,def,arg,prev,false,false,false,0,0,0 }
	}
	acts[ca].name = act
	acts[ca].def = def
	acts[ca].arg = arg
	acts[ca].prev = prev
	chk_trig( ca )
	if cnt == 0 
	{ 
		acts[ca].cnt = -1 
	} 
	mut stat := false
	mut found := false
	for a in k_all.ap_actor
	{
		if a.k_name != act { continue }
		found = true
		if a.k_attr != "E_O_L"
		{
			ok, v := s_get_var( a.k_attr, ca, a.fline )
			if ok == false
			{
				println(v)
				continue
			}
			_, val := strs(a.k_value, true, ca, a.fline)
			if chk(v,a.k_eq, val,stat) == false { continue }
			stat = true
			if a.k_cc != '' 
			{
				_, stv := strs(a.k_cc, false, ca, a.fline)
				println( stv )
			}
		}
		acts[ca].cnt++ 
		ret := goo(a.kme, ca, def, acts[ca].cnt, arg)
		if ret > 0 { return ret-1 }
	}
	if found == false
	{
		println('Actor ' + act + ' not found')
	}
	return 0
}

pub fn chk_trig(sact int)
{
	acts[ sact ].is_trig = false
	acts[sact].is_prev = false
	acts[sact].is_on = false
	
	prev := acts[sact].prev
	if prev < 0 { return }
	if acts[prev].is_on || acts[prev].is_prev
	{
		if acts[prev].is_trig == false
		{
				acts[sact].is_prev = true
		}
	}
}

pub fn trig(sact int)
{
	if acts[sact].is_prev == false { return }
	acts[sact].is_prev = false
	prev := acts[sact].prev
	if prev < 0 { return }
	if acts[ prev ].is_trig == true { return }
	acts[ prev ].is_trig = true
	
	goo_re( prev )
}

fn goo_re(sact int) 
{
	trig(sact)
	mut i := acts[sact].on_pos
	for i < acts[sact].cur_pos
	{
		st := k_all.ap_actor[ acts[sact].cur_act ].kchilds[i]
		if st.type_name() == 'KpC'
		{
			cmd := st as KpC
			_, stv := strs(cmd.k_desc, false, sact, cmd.fline)
			println( stv )
		}
		if st.type_name() == 'KpCs'
		{
			cmd := st as KpCs
			_, stv := strs(cmd.k_desc, false, sact, cmd.fline)
			print( stv )
		}
		i++
	}
}

fn main() {
	
	mut kp_all := Kall{}
	for path in os.args[1].split(',')
	{
		mut contents := os.read_file(path.trim_space()) or 
		{
			println('failed to open $path')
			return
		}
		lines(mut kp_all, contents,path )
	}
	refs(mut kp_all)
	k_all = kp_all
	groups = map[string]map[string][]string{}
	collects = map[string][]Kp{}
	uniques = map[string][]string{}

	mut i := 0
	mut node := KpArg{}
    for arg in os.args 
    {
    	i++
        node.names[ i.str() ] = arg
        node.kme = i
        node.fline = '1'
    }
	actor(k_all.ap_actor[0].k_name, node, 0, '',-1)
	
}

fn lines(mut kp_all Kall, dat string, path string)
{
	mut lc := 1
	for ln in dat.split_into_lines()
	{
		mut fl := path + ":" + lc.str()
		wrd, pos := getw(ln, 0)
		if wrd == 'E_O_F' { break }  // add docs after it, or wait for B_O_F
		load(wrd, ln,pos, mut kp_all, fl)
		lc += 1
	}
}

pub struct KpArg {
	mut:
	kme int
	names map[string]string
	fline string
}
pub fn (def KpArg) doo(a string, b string, act string, arg string, lc string, sact int, pact int) int
{
	_, val := def.get_var(a,b,lc)
	mut node := KpArg{}
	mut i := -1
	for v in val.split(',')
	{
		if b != ''
		{
//			bs := strs(b, sact, lc)
			a2,b2 := split(b)
//			ret := do_all(a2,b2,act,arg,lc,sact)
			ret := do_all(a2,b2,v,act,arg,lc,sact)
			if ret != 0 { return ret-1 }
			continue
		}
		i++
//		node.names[ 'pocket' ] = sb
		node.names[ 'name' ] = (i+1).str()
		node.names[ 'value' ] = v
		node.kme = i
		node.fline = 'arg:1'
		ret := actor( act, node, i, arg, sact )
		if ret != 0 { return ret-1 }
//		return 0
	}
//	println("?No its " + a + " cmd for " + def.fline + "," + lc + ', ' + @FILE_LINE + "?")
	return 0
}
pub fn (def KpArg) get_var(a string, b string, lc string) (bool, string)
{
	if val := def.names[ a ]
	{
		return true, val
	}
	return false, "?" + a + "?" + def.fline + ", " + lc + ', ' + @FILE_LINE + "?"
}

