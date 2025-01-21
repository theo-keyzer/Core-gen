package main

import (
	"fmt"
	"strconv"
)

type Kp interface {
	DoIts(glob *GlobT, va []string, lno string) int
	GetVar(glob *GlobT, va []string, lno string) (bool, string)
	GetLineNo() string
}

type KpComp struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	ItsElement [] *KpElement 
	ItsRef [] *KpRef 
	ItsRef2 [] *KpRef2 
	ItsRef3 [] *KpRef3 
	ItsRefq [] *KpRefq 
	ItsRefu [] *KpRefu 
	ItsJoin [] *KpJoin 
	Childs [] Kp
}

func loadComp(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpComp)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApComp)
	st.LineNo = lno
	st.Comp = "Comp";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["nop"] = getw(ln,p)
	p,st.Names["parent"] = getw(ln,p)
	p,st.Names["find"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kparentp = -1
	name,_ := st.Names["name"]
	act.index["Comp_" + name] = st.Me;
	act.ApComp = append(act.ApComp, st)
	return 0
}

func (me KpComp) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if va[0] == "parent" { // gen.unit:16, g_struct.act:540
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], lno) )
		}
	}
	if (va[0] == "Comp_parent" && len(va) > 1) { // gen.unit:16, g_struct.act:634
		for _, st := range glob.Dats.ApComp {
			if (st.Kparentp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref_comp" && len(va) > 1) { // gen.unit:65, g_struct.act:634
		for _, st := range glob.Dats.ApRef {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref2_comp" && len(va) > 1) { // gen.unit:83, g_struct.act:634
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_comp" && len(va) > 1) { // gen.unit:104, g_struct.act:634
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_comp_ref" && len(va) > 1) { // gen.unit:105, g_struct.act:634
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kcomp_refp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refq_comp" && len(va) > 1) { // gen.unit:126, g_struct.act:634
		for _, st := range glob.Dats.ApRefq {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refq_comp_ref" && len(va) > 1) { // gen.unit:127, g_struct.act:634
		for _, st := range glob.Dats.ApRefq {
			if (st.Kcomp_refp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refu_comp" && len(va) > 1) { // gen.unit:147, g_struct.act:634
		for _, st := range glob.Dats.ApRefu {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refu_comp_ref" && len(va) > 1) { // gen.unit:148, g_struct.act:634
		for _, st := range glob.Dats.ApRefu {
			if (st.Kcomp_refp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Comp?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpComp) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Element" { // gen.unit:19, g_struct.act:613
		for _, st := range me.ItsElement {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Ref" { // gen.unit:50, g_struct.act:613
		for _, st := range me.ItsRef {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Ref2" { // gen.unit:68, g_struct.act:613
		for _, st := range me.ItsRef2 {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Ref3" { // gen.unit:87, g_struct.act:613
		for _, st := range me.ItsRef3 {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Refq" { // gen.unit:109, g_struct.act:613
		for _, st := range me.ItsRefq {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Refu" { // gen.unit:130, g_struct.act:613
		for _, st := range me.ItsRefu {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Join" { // gen.unit:151, g_struct.act:613
		for _, st := range me.ItsJoin {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "parent" {
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Comp_parent") { // gen.unit:16, g_struct.act:444
		for _, st := range glob.Dats.ApComp {
			if (st.Kparentp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref_comp") { // gen.unit:65, g_struct.act:444
		for _, st := range glob.Dats.ApRef {
			if (st.Kcompp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref2_comp") { // gen.unit:83, g_struct.act:444
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kcompp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref3_comp") { // gen.unit:104, g_struct.act:444
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kcompp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref3_comp_ref") { // gen.unit:105, g_struct.act:444
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kcomp_refp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Refq_comp") { // gen.unit:126, g_struct.act:444
		for _, st := range glob.Dats.ApRefq {
			if (st.Kcompp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Refq_comp_ref") { // gen.unit:127, g_struct.act:444
		for _, st := range glob.Dats.ApRefq {
			if (st.Kcomp_refp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Refu_comp") { // gen.unit:147, g_struct.act:444
		for _, st := range glob.Dats.ApRefu {
			if (st.Kcompp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Refu_comp_ref") { // gen.unit:148, g_struct.act:444
		for _, st := range glob.Dats.ApRefu {
			if (st.Kcomp_refp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	return(0)
}

type KpElement struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	ItsOpt [] *KpOpt 
	Childs [] Kp
}

func loadElement(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpElement)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApElement)
	st.LineNo = lno
	st.Comp = "Element";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["mw"] = getw(ln,p)
	p,st.Names["mw2"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Element has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsElement = append(act.ApComp[ len( act.ApComp )-1 ].ItsElement, st)	// gen.unit:2, g_struct.act:249
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Element_" + name	// gen.unit:24, g_struct.act:287
	act.index[s] = st.Me;
	act.ApElement = append(act.ApElement, st)
	return 0
}

func (me KpElement) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	if (va[0] == "Ref_element" && len(va) > 1) { // gen.unit:64, g_struct.act:634
		for _, st := range glob.Dats.ApRef {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref2_element" && len(va) > 1) { // gen.unit:82, g_struct.act:634
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref2_element2" && len(va) > 1) { // gen.unit:84, g_struct.act:634
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kelement2p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_element" && len(va) > 1) { // gen.unit:103, g_struct.act:634
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_element2" && len(va) > 1) { // gen.unit:106, g_struct.act:634
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kelement2p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refq_element" && len(va) > 1) { // gen.unit:125, g_struct.act:634
		for _, st := range glob.Dats.ApRefq {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refu_element" && len(va) > 1) { // gen.unit:146, g_struct.act:634
		for _, st := range glob.Dats.ApRefu {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Element?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpElement) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Opt" { // gen.unit:39, g_struct.act:613
		for _, st := range me.ItsOpt {
			if len(va) > 1 {
				ret := st.DoIts(glob, va[1:], lno)
				if (ret != 0) {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if (ret != 0) {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Ref_element") { // gen.unit:64, g_struct.act:444
		for _, st := range glob.Dats.ApRef {
			if (st.Kelementp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref2_element") { // gen.unit:82, g_struct.act:444
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kelementp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref2_element2") { // gen.unit:84, g_struct.act:444
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kelement2p == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref3_element") { // gen.unit:103, g_struct.act:444
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kelementp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Ref3_element2") { // gen.unit:106, g_struct.act:444
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kelement2p == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Refq_element") { // gen.unit:125, g_struct.act:444
		for _, st := range glob.Dats.ApRefq {
			if (st.Kelementp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	if (va[0] == "Refu_element") { // gen.unit:146, g_struct.act:444
		for _, st := range glob.Dats.ApRefu {
			if (st.Kelementp == me.Me) {
				if len(va) > 1 {
					ret := st.DoIts(glob, va[1:], lno)
					if (ret != 0) {
						return(ret)
					}
					continue
				}
				ret := GoAct(glob, st)
				if (ret != 0) {
					return(ret)
				}
			}
		}
		return(0)
	}
	return(0)
}

type KpOpt struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
}

func loadOpt(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpOpt)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApOpt)
	st.LineNo = lno
	st.Comp = "Opt";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kparentp = len( act.ApElement ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Opt has no Element parent") ;
		return 1
	}
	act.ApElement[ len( act.ApElement )-1 ].Childs = append(act.ApElement[ len( act.ApElement )-1 ].Childs, st)
	act.ApElement[ len( act.ApElement )-1 ].ItsOpt = append(act.ApElement[ len( act.ApElement )-1 ].ItsOpt, st)	// gen.unit:19, g_struct.act:249
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Opt_" + name	// gen.unit:45, g_struct.act:287
	act.index[s] = st.Me;
	act.ApOpt = append(act.ApOpt, st)
	return 0
}

func (me KpOpt) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:19, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Opt?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpOpt) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:19, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApElement[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpRef struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kelementp int
	Kcompp int
}

func loadRef(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpRef)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRef)
	st.LineNo = lno
	st.Comp = "Ref";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["element"] = getw(ln,p)
	p,st.Names["comp"] = getw(ln,p)
	p,st.Names["opt"] = getw(ln,p)
	p,st.Names["var"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kelementp = -1
	st.Kcompp = -1
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Ref has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRef = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef, st)	// gen.unit:2, g_struct.act:249
	act.ApRef = append(act.ApRef, st)
	return 0
}

func (me KpRef) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if va[0] == "element" { // gen.unit:64, g_struct.act:540
		if (me.Kelementp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelementp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp" { // gen.unit:65, g_struct.act:540
		if (me.Kcompp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcompp ].GetVar(glob, va[1:], lno) )
		}
	}
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Ref?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRef) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element" {
		if me.Kelementp >= 0 {
			st := glob.Dats.ApElement[ me.Kelementp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp" {
		if me.Kcompp >= 0 {
			st := glob.Dats.ApComp[ me.Kcompp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpRef2 struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kelementp int
	Kcompp int
	Kelement2p int
}

func loadRef2(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpRef2)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRef2)
	st.LineNo = lno
	st.Comp = "Ref2";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["element"] = getw(ln,p)
	p,st.Names["comp"] = getw(ln,p)
	p,st.Names["element2"] = getw(ln,p)
	p,st.Names["opt"] = getw(ln,p)
	p,st.Names["var"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kelementp = -1
	st.Kcompp = -1
	st.Kelement2p = -1
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Ref2 has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRef2 = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef2, st)	// gen.unit:2, g_struct.act:249
	act.ApRef2 = append(act.ApRef2, st)
	return 0
}

func (me KpRef2) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if va[0] == "element" { // gen.unit:82, g_struct.act:540
		if (me.Kelementp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelementp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp" { // gen.unit:83, g_struct.act:540
		if (me.Kcompp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcompp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "element2" { // gen.unit:84, g_struct.act:540
		if (me.Kelement2p >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelement2p ].GetVar(glob, va[1:], lno) )
		}
	}
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Ref2?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRef2) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element" {
		if me.Kelementp >= 0 {
			st := glob.Dats.ApElement[ me.Kelementp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp" {
		if me.Kcompp >= 0 {
			st := glob.Dats.ApComp[ me.Kcompp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element2" {
		if me.Kelement2p >= 0 {
			st := glob.Dats.ApElement[ me.Kelement2p ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpRef3 struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kelementp int
	Kcompp int
	Kelement2p int
	Kcomp_refp int
}

func loadRef3(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpRef3)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRef3)
	st.LineNo = lno
	st.Comp = "Ref3";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["element"] = getw(ln,p)
	p,st.Names["comp"] = getw(ln,p)
	p,st.Names["element2"] = getw(ln,p)
	p,st.Names["comp_ref"] = getw(ln,p)
	p,st.Names["element3"] = getw(ln,p)
	p,st.Names["opt"] = getw(ln,p)
	p,st.Names["var"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kelementp = -1
	st.Kcompp = -1
	st.Kelement2p = -1
	st.Kcomp_refp = -1
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Ref3 has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRef3 = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef3, st)	// gen.unit:2, g_struct.act:249
	act.ApRef3 = append(act.ApRef3, st)
	return 0
}

func (me KpRef3) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if va[0] == "element" { // gen.unit:103, g_struct.act:540
		if (me.Kelementp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelementp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp" { // gen.unit:104, g_struct.act:540
		if (me.Kcompp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcompp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp_ref" { // gen.unit:105, g_struct.act:540
		if (me.Kcomp_refp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcomp_refp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "element2" { // gen.unit:106, g_struct.act:540
		if (me.Kelement2p >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelement2p ].GetVar(glob, va[1:], lno) )
		}
	}
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Ref3?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRef3) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element" {
		if me.Kelementp >= 0 {
			st := glob.Dats.ApElement[ me.Kelementp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp" {
		if me.Kcompp >= 0 {
			st := glob.Dats.ApComp[ me.Kcompp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp_ref" {
		if me.Kcomp_refp >= 0 {
			st := glob.Dats.ApComp[ me.Kcomp_refp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element2" {
		if me.Kelement2p >= 0 {
			st := glob.Dats.ApElement[ me.Kelement2p ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpRefq struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kelementp int
	Kcompp int
	Kcomp_refp int
}

func loadRefq(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpRefq)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRefq)
	st.LineNo = lno
	st.Comp = "Refq";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["element"] = getw(ln,p)
	p,st.Names["comp"] = getw(ln,p)
	p,st.Names["element2"] = getw(ln,p)
	p,st.Names["comp_ref"] = getw(ln,p)
	p,st.Names["opt"] = getw(ln,p)
	p,st.Names["var"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kelementp = -1
	st.Kcompp = -1
	st.Kcomp_refp = -1
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Refq has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRefq = append(act.ApComp[ len( act.ApComp )-1 ].ItsRefq, st)	// gen.unit:2, g_struct.act:249
	act.ApRefq = append(act.ApRefq, st)
	return 0
}

func (me KpRefq) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if va[0] == "element" { // gen.unit:125, g_struct.act:540
		if (me.Kelementp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelementp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp" { // gen.unit:126, g_struct.act:540
		if (me.Kcompp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcompp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp_ref" { // gen.unit:127, g_struct.act:540
		if (me.Kcomp_refp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcomp_refp ].GetVar(glob, va[1:], lno) )
		}
	}
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Refq?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRefq) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element" {
		if me.Kelementp >= 0 {
			st := glob.Dats.ApElement[ me.Kelementp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp" {
		if me.Kcompp >= 0 {
			st := glob.Dats.ApComp[ me.Kcompp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp_ref" {
		if me.Kcomp_refp >= 0 {
			st := glob.Dats.ApComp[ me.Kcomp_refp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpRefu struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kelementp int
	Kcompp int
	Kcomp_refp int
}

func loadRefu(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpRefu)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRefu)
	st.LineNo = lno
	st.Comp = "Refu";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["element"] = getw(ln,p)
	p,st.Names["comp"] = getw(ln,p)
	p,st.Names["element2"] = getw(ln,p)
	p,st.Names["comp_ref"] = getw(ln,p)
	p,st.Names["element3"] = getw(ln,p)
	p,st.Names["opt"] = getw(ln,p)
	p,st.Names["var"] = getw(ln,p)
	p,st.Names["doc"] = getws(ln,p)
	st.Kelementp = -1
	st.Kcompp = -1
	st.Kcomp_refp = -1
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Refu has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRefu = append(act.ApComp[ len( act.ApComp )-1 ].ItsRefu, st)	// gen.unit:2, g_struct.act:249
	act.ApRefu = append(act.ApRefu, st)
	return 0
}

func (me KpRefu) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if va[0] == "element" { // gen.unit:146, g_struct.act:540
		if (me.Kelementp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kelementp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp" { // gen.unit:147, g_struct.act:540
		if (me.Kcompp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcompp ].GetVar(glob, va[1:], lno) )
		}
	}
	if va[0] == "comp_ref" { // gen.unit:148, g_struct.act:540
		if (me.Kcomp_refp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kcomp_refp ].GetVar(glob, va[1:], lno) )
		}
	}
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Refu?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRefu) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "element" {
		if me.Kelementp >= 0 {
			st := glob.Dats.ApElement[ me.Kelementp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp" {
		if me.Kcompp >= 0 {
			st := glob.Dats.ApComp[ me.Kcompp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "comp_ref" {
		if me.Kcomp_refp >= 0 {
			st := glob.Dats.ApComp[ me.Kcomp_refp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpJoin struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
}

func loadJoin(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpJoin)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApJoin)
	st.LineNo = lno
	st.Comp = "Join";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	st.Names["_lno"] = lno
	p,st.Names["element"] = getw(ln,p)
	p,st.Names["dir"] = getw(ln,p)
	p,st.Names["comp"] = getw(ln,p)
	p,st.Names["using"] = getw(ln,p)
	p,st.Names["element2"] = getw(ln,p)
	p,st.Names["comp2"] = getw(ln,p)
	p,st.Names["element3"] = getw(ln,p)
	st.Kparentp = len( act.ApComp ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Join has no Comp parent") ;
		return 1
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsJoin = append(act.ApComp[ len( act.ApComp )-1 ].ItsJoin, st)	// gen.unit:2, g_struct.act:249
	act.ApJoin = append(act.ApJoin, st)
	return 0
}

func (me KpJoin) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:434
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Join?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpJoin) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:419
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpActor struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kname string
	Kcomp string
	Kattr string
	Keq string
	Kvalue string
	Childs [] Kp
}

func loadActor(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpActor)
	st.Me = len(act.ApActor)
	st.LineNo = lno
	st.Comp = "Actor";
	st.Flags = flag;
	p,st.Kname = getw(ln,p)
	p,st.Kcomp = getw(ln,p)
	p,st.Kattr = getw(ln,p)
	p,st.Keq = getw(ln,p)
	p,st.Kvalue = getws(ln,p)
	act.index["Actor_" + st.Kname] = st.Me;
	act.ApActor = append(act.ApActor, st)
	return 0
}

type KpAll struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kwhat string
	Kactor string
	Kargs string
	Kactorp int
}

func loadAll(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpAll)
	st.Me = len(act.ApAll)
	st.LineNo = lno
	st.Comp = "All";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	st.Kactorp = -1
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " All has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApAll = append(act.ApAll, st)
	return 0
}

type KpDu struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kactor string
	Kargs string
	Kactorp int
}

func loadDu(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpDu)
	st.Me = len(act.ApDu)
	st.LineNo = lno
	st.Comp = "Du";
	st.Flags = flag;
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	st.Kactorp = -1
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Du has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApDu = append(act.ApDu, st)
	return 0
}

type KpNew struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kwhere string
	Kwhat string
	Kline string
}

func loadNew(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpNew)
	st.Me = len(act.ApNew)
	st.LineNo = lno
	st.Comp = "New";
	st.Flags = flag;
	p,st.Kwhere = getw(ln,p)
	p,st.Kwhat = getw(ln,p)
	p,st.Kline = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " New has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApNew = append(act.ApNew, st)
	return 0
}

type KpRefs struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kwhere string
}

func loadRefs(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpRefs)
	st.Me = len(act.ApRefs)
	st.LineNo = lno
	st.Comp = "Refs";
	st.Flags = flag;
	p,st.Kwhere = getw(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Refs has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApRefs = append(act.ApRefs, st)
	return 0
}

type KpVar struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kattr string
	Keq string
	Kvalue string
}

func loadVar(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpVar)
	st.Me = len(act.ApVar)
	st.LineNo = lno
	st.Comp = "Var";
	st.Flags = flag;
	p,st.Kattr = getw(ln,p)
	p,st.Keq = getw(ln,p)
	p,st.Kvalue = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Var has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApVar = append(act.ApVar, st)
	return 0
}

type KpIts struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kwhat string
	Kactor string
	Kargs string
	Kactorp int
}

func loadIts(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpIts)
	st.Me = len(act.ApIts)
	st.LineNo = lno
	st.Comp = "Its";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	st.Kactorp = -1
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Its has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApIts = append(act.ApIts, st)
	return 0
}

type KpC struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kdesc string
}

func loadC(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpC)
	st.Me = len(act.ApC)
	st.LineNo = lno
	st.Comp = "C";
	st.Flags = flag;
	p,st.Kdesc = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " C has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApC = append(act.ApC, st)
	return 0
}

type KpCs struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kdesc string
}

func loadCs(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpCs)
	st.Me = len(act.ApCs)
	st.LineNo = lno
	st.Comp = "Cs";
	st.Flags = flag;
	p,st.Kdesc = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Cs has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApCs = append(act.ApCs, st)
	return 0
}

type KpOut struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kwhat string
	Kpad string
	Kdesc string
}

func loadOut(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpOut)
	st.Me = len(act.ApOut)
	st.LineNo = lno
	st.Comp = "Out";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kpad = getw(ln,p)
	p,st.Kdesc = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Out has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApOut = append(act.ApOut, st)
	return 0
}

type KpIn struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kflag string
}

func loadIn(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpIn)
	st.Me = len(act.ApIn)
	st.LineNo = lno
	st.Comp = "In";
	st.Flags = flag;
	p,st.Kflag = getw(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " In has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApIn = append(act.ApIn, st)
	return 0
}

type KpBreak struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kwhat string
	Kpad string
	Kactor string
	Kcheck string
}

func loadBreak(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpBreak)
	st.Me = len(act.ApBreak)
	st.LineNo = lno
	st.Comp = "Break";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kpad = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kcheck = getw(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Break has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApBreak = append(act.ApBreak, st)
	return 0
}

type KpAdd struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kpath string
	Kdata string
}

func loadAdd(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpAdd)
	st.Me = len(act.ApAdd)
	st.LineNo = lno
	st.Comp = "Add";
	st.Flags = flag;
	p,st.Kpath = getw(ln,p)
	p,st.Kdata = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Add has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApAdd = append(act.ApAdd, st)
	return 0
}

type KpThis struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kpath string
	Kactor string
	Kargs string
	Kactorp int
}

func loadThis(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpThis)
	st.Me = len(act.ApThis)
	st.LineNo = lno
	st.Comp = "This";
	st.Flags = flag;
	p,st.Kpath = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	st.Kactorp = -1
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " This has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApThis = append(act.ApThis, st)
	return 0
}

type KpReplace struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Kparentp int
	Kpath string
	Kpad string
	Kwith string
	Kpad2 string
	Kmatch string
}

func loadReplace(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpReplace)
	st.Me = len(act.ApReplace)
	st.LineNo = lno
	st.Comp = "Replace";
	st.Flags = flag;
	p,st.Kpath = getw(ln,p)
	p,st.Kpad = getw(ln,p)
	p,st.Kwith = getw(ln,p)
	p,st.Kpad2 = getw(ln,p)
	p,st.Kmatch = getws(ln,p)
	st.Kparentp = len(act.ApActor)-1;
	if (st.Kparentp < 0 ) { 
		print(lno + " Replace has no Actor parent") ;
		return 1
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApReplace = append(act.ApReplace, st)
	return 0
}

