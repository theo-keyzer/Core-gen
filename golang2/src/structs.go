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

type KpType struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	ItsData [] *KpData 
	ItsAttr [] *KpAttr 
	ItsWhere [] *KpWhere 
	ItsLogic [] *KpLogic 
	Childs [] Kp
}

func loadType(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpType)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApType)
	st.LineNo = lno
	st.Comp = "Type";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["desc"] = getws(ln,p)
	name,_ := st.Names["name"]
	act.index["Type_" + name] = st.Me;
	act.ApType = append(act.ApType, st)
	return 0
}

func (me KpType) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "Attr_table" && len(va) > 1) { // sample.unit:58, g_struct.act:633
		for _, st := range glob.Dats.ApAttr {
			if (st.Ktablep == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Field_type" && len(va) > 1) { // app.unit:62, g_struct.act:633
		for _, st := range glob.Dats.ApField {
			if (st.Ktypep == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Type?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpType) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Data" { // sample.unit:13, g_struct.act:612
		for _, st := range me.ItsData {
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
	if va[0] == "Attr" { // sample.unit:24, g_struct.act:612
		for _, st := range me.ItsAttr {
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
	if va[0] == "Where" { // sample.unit:61, g_struct.act:612
		for _, st := range me.ItsWhere {
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
	if va[0] == "Logic" { // sample.unit:83, g_struct.act:612
		for _, st := range me.ItsLogic {
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
	if (va[0] == "Attr_table") { // sample.unit:58, g_struct.act:443
		for _, st := range glob.Dats.ApAttr {
			if (st.Ktablep == me.Me) {
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
	if (va[0] == "Field_type") { // app.unit:62, g_struct.act:443
		for _, st := range glob.Dats.ApField {
			if (st.Ktypep == me.Me) {
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

type KpData struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
}

func loadData(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpData)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApData)
	st.LineNo = lno
	st.Comp = "Data";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["op"] = getw(ln,p)
	p,st.Names["value"] = getws(ln,p)
	st.Kparentp = len( act.ApType ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Data has no Type parent") ;
		return 1
	}
	act.ApType[ len( act.ApType )-1 ].Childs = append(act.ApType[ len( act.ApType )-1 ].Childs, st)
	act.ApType[ len( act.ApType )-1 ].ItsData = append(act.ApType[ len( act.ApType )-1 ].ItsData, st)	// sample.unit:2, g_struct.act:248
	act.ApData = append(act.ApData, st)
	return 0
}

func (me KpData) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // sample.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApType[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Data?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpData) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // sample.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApType[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpAttr struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Ktablep int
}

func loadAttr(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpAttr)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApAttr)
	st.LineNo = lno
	st.Comp = "Attr";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["table"] = getw(ln,p)
	p,st.Names["relation"] = getw(ln,p)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["mytype"] = getw(ln,p)
	p,st.Names["len"] = getw(ln,p)
	p,st.Names["null"] = getw(ln,p)
	p,st.Names["flags"] = getw(ln,p)
	p,st.Names["desc"] = getws(ln,p)
	st.Ktablep = -1
	st.Kparentp = len( act.ApType ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Attr has no Type parent") ;
		return 1
	}
	act.ApType[ len( act.ApType )-1 ].Childs = append(act.ApType[ len( act.ApType )-1 ].Childs, st)
	act.ApType[ len( act.ApType )-1 ].ItsAttr = append(act.ApType[ len( act.ApType )-1 ].ItsAttr, st)	// sample.unit:2, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Attr_" + name	// sample.unit:51, g_struct.act:286
	act.index[s] = st.Me;
	act.ApAttr = append(act.ApAttr, st)
	return 0
}

func (me KpAttr) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // sample.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApType[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	if (va[0] == "Where_attr" && len(va) > 1) { // sample.unit:75, g_struct.act:633
		for _, st := range glob.Dats.ApWhere {
			if (st.Kattrp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Where_id" && len(va) > 1) { // sample.unit:76, g_struct.act:633
		for _, st := range glob.Dats.ApWhere {
			if (st.Kidp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Logic_attr" && len(va) > 1) { // sample.unit:96, g_struct.act:633
		for _, st := range glob.Dats.ApLogic {
			if (st.Kattrp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Attr?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpAttr) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // sample.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApType[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "table" {
		if me.Ktablep >= 0 {
			st := glob.Dats.ApType[ me.Ktablep ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Where_attr") { // sample.unit:75, g_struct.act:443
		for _, st := range glob.Dats.ApWhere {
			if (st.Kattrp == me.Me) {
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
	if (va[0] == "Where_id") { // sample.unit:76, g_struct.act:443
		for _, st := range glob.Dats.ApWhere {
			if (st.Kidp == me.Me) {
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
	if (va[0] == "Logic_attr") { // sample.unit:96, g_struct.act:443
		for _, st := range glob.Dats.ApLogic {
			if (st.Kattrp == me.Me) {
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

type KpWhere struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kattrp int
	Ktablep int
	Kfrom_idp int
	Kidp int
}

func loadWhere(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpWhere)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApWhere)
	st.LineNo = lno
	st.Comp = "Where";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["attr"] = getw(ln,p)
	p,st.Names["from_id"] = getw(ln,p)
	p,st.Names["eq"] = getw(ln,p)
	p,st.Names["id"] = getw(ln,p)
	p,st.Names["op"] = getw(ln,p)
	p,st.Names["value"] = getws(ln,p)
	st.Kattrp = -1
	st.Ktablep = -1
	st.Kfrom_idp = -1
	st.Kidp = -1
	st.Kparentp = len( act.ApType ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Where has no Type parent") ;
		return 1
	}
	act.ApType[ len( act.ApType )-1 ].Childs = append(act.ApType[ len( act.ApType )-1 ].Childs, st)
	act.ApType[ len( act.ApType )-1 ].ItsWhere = append(act.ApType[ len( act.ApType )-1 ].ItsWhere, st)	// sample.unit:2, g_struct.act:248
	act.ApWhere = append(act.ApWhere, st)
	return 0
}

func (me KpWhere) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // sample.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApType[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Where?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpWhere) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // sample.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApType[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "attr" {
		if me.Kattrp >= 0 {
			st := glob.Dats.ApAttr[ me.Kattrp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "id" {
		if me.Kidp >= 0 {
			st := glob.Dats.ApAttr[ me.Kidp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpLogic struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kattrp int
}

func loadLogic(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpLogic)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApLogic)
	st.LineNo = lno
	st.Comp = "Logic";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["attr"] = getw(ln,p)
	p,st.Names["op"] = getw(ln,p)
	p,st.Names["code"] = getw(ln,p)
	st.Kattrp = -1
	st.Kparentp = len( act.ApType ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Logic has no Type parent") ;
		return 1
	}
	act.ApType[ len( act.ApType )-1 ].Childs = append(act.ApType[ len( act.ApType )-1 ].Childs, st)
	act.ApType[ len( act.ApType )-1 ].ItsLogic = append(act.ApType[ len( act.ApType )-1 ].ItsLogic, st)	// sample.unit:2, g_struct.act:248
	act.ApLogic = append(act.ApLogic, st)
	return 0
}

func (me KpLogic) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // sample.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApType[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Logic?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpLogic) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // sample.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApType[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "attr" {
		if me.Kattrp >= 0 {
			st := glob.Dats.ApAttr[ me.Kattrp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpNode struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	ItsLink [] *KpLink 
	Childs [] Kp
}

func loadNode(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpNode)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApNode)
	st.LineNo = lno
	st.Comp = "Node";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["parent"] = getw(ln,p)
	p,st.Names["var"] = getw(ln,p)
	p,st.Names["eq"] = getw(ln,p)
	p,st.Names["value"] = getw(ln,p)
	st.Kparentp = -1
	name,_ := st.Names["name"]
	act.index["Node_" + name] = st.Me;
	act.ApNode = append(act.ApNode, st)
	return 0
}

func (me KpNode) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "Node_parent" && len(va) > 1) { // app.unit:12, g_struct.act:633
		for _, st := range glob.Dats.ApNode {
			if (st.Kparentp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Link_to" && len(va) > 1) { // app.unit:20, g_struct.act:633
		for _, st := range glob.Dats.ApLink {
			if (st.Ktop == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Node?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpNode) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Link" { // app.unit:15, g_struct.act:612
		for _, st := range me.ItsLink {
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
			st := glob.Dats.ApNode[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Node_parent") { // app.unit:12, g_struct.act:443
		for _, st := range glob.Dats.ApNode {
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
	if (va[0] == "Link_to") { // app.unit:20, g_struct.act:443
		for _, st := range glob.Dats.ApLink {
			if (st.Ktop == me.Me) {
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

type KpLink struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Ktop int
}

func loadLink(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpLink)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApLink)
	st.LineNo = lno
	st.Comp = "Link";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["to"] = getw(ln,p)
	st.Ktop = -1
	st.Kparentp = len( act.ApNode ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Link has no Node parent") ;
		return 1
	}
	act.ApNode[ len( act.ApNode )-1 ].Childs = append(act.ApNode[ len( act.ApNode )-1 ].Childs, st)
	act.ApNode[ len( act.ApNode )-1 ].ItsLink = append(act.ApNode[ len( act.ApNode )-1 ].ItsLink, st)	// app.unit:2, g_struct.act:248
	act.ApLink = append(act.ApLink, st)
	return 0
}

func (me KpLink) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // app.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApNode[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Link?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpLink) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // app.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApNode[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "to" {
		if me.Ktop >= 0 {
			st := glob.Dats.ApNode[ me.Ktop ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpGraph struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
}

func loadGraph(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpGraph)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApGraph)
	st.LineNo = lno
	st.Comp = "Graph";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["search"] = getws(ln,p)
	name,_ := st.Names["name"]
	act.index["Graph_" + name] = st.Me;
	act.ApGraph = append(act.ApGraph, st)
	return 0
}

func (me KpGraph) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Graph?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpGraph) DoIts(glob *GlobT, va []string, lno string) int {
	return(0)
}

type KpMatrix struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
}

func loadMatrix(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpMatrix)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApMatrix)
	st.LineNo = lno
	st.Comp = "Matrix";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["a"] = getw(ln,p)
	p,st.Names["b"] = getw(ln,p)
	p,st.Names["c"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["search"] = getw(ln,p)
	act.ApMatrix = append(act.ApMatrix, st)
	return 0
}

func (me KpMatrix) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Matrix?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpMatrix) DoIts(glob *GlobT, va []string, lno string) int {
	return(0)
}

type KpTable struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	ItsField [] *KpField 
	ItsOf [] *KpOf 
	ItsJoin1 [] *KpJoin1 
	ItsJoin2 [] *KpJoin2 
	Childs [] Kp
}

func loadTable(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpTable)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApTable)
	st.LineNo = lno
	st.Comp = "Table";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["value"] = getw(ln,p)
	name,_ := st.Names["name"]
	act.index["Table_" + name] = st.Me;
	act.ApTable = append(act.ApTable, st)
	return 0
}

func (me KpTable) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "Join1_table2" && len(va) > 1) { // app.unit:104, g_struct.act:633
		for _, st := range glob.Dats.ApJoin1 {
			if (st.Ktable2p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Join2_table2" && len(va) > 1) { // app.unit:119, g_struct.act:633
		for _, st := range glob.Dats.ApJoin2 {
			if (st.Ktable2p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Table?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpTable) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Field" { // app.unit:49, g_struct.act:612
		for _, st := range me.ItsField {
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
	if va[0] == "Of" { // app.unit:71, g_struct.act:612
		for _, st := range me.ItsOf {
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
	if va[0] == "Join1" { // app.unit:92, g_struct.act:612
		for _, st := range me.ItsJoin1 {
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
	if va[0] == "Join2" { // app.unit:108, g_struct.act:612
		for _, st := range me.ItsJoin2 {
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
	if (va[0] == "Join1_table2") { // app.unit:104, g_struct.act:443
		for _, st := range glob.Dats.ApJoin1 {
			if (st.Ktable2p == me.Me) {
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
	if (va[0] == "Join2_table2") { // app.unit:119, g_struct.act:443
		for _, st := range glob.Dats.ApJoin2 {
			if (st.Ktable2p == me.Me) {
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

type KpField struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Ktypep int
	ItsAttrs [] *KpAttrs 
	Childs [] Kp
}

func loadField(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpField)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApField)
	st.LineNo = lno
	st.Comp = "Field";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["type"] = getw(ln,p)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["dt"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["use"] = getw(ln,p)
	st.Ktypep = -1
	st.Kparentp = len( act.ApTable ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Field has no Table parent") ;
		return 1
	}
	act.ApTable[ len( act.ApTable )-1 ].Childs = append(act.ApTable[ len( act.ApTable )-1 ].Childs, st)
	act.ApTable[ len( act.ApTable )-1 ].ItsField = append(act.ApTable[ len( act.ApTable )-1 ].ItsField, st)	// app.unit:41, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Field_" + name	// app.unit:53, g_struct.act:286
	act.index[s] = st.Me;
	act.ApField = append(act.ApField, st)
	return 0
}

func (me KpField) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // app.unit:41, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApTable[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	if (va[0] == "Of_field" && len(va) > 1) { // app.unit:82, g_struct.act:633
		for _, st := range glob.Dats.ApOf {
			if (st.Kfieldp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Join1_field1" && len(va) > 1) { // app.unit:103, g_struct.act:633
		for _, st := range glob.Dats.ApJoin1 {
			if (st.Kfield1p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Join2_field1" && len(va) > 1) { // app.unit:118, g_struct.act:633
		for _, st := range glob.Dats.ApJoin2 {
			if (st.Kfield1p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Field?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpField) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Attrs" { // app.unit:65, g_struct.act:612
		for _, st := range me.ItsAttrs {
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
	if va[0] == "parent" { // app.unit:41, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApTable[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "type" {
		if me.Ktypep >= 0 {
			st := glob.Dats.ApType[ me.Ktypep ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Of_field") { // app.unit:82, g_struct.act:443
		for _, st := range glob.Dats.ApOf {
			if (st.Kfieldp == me.Me) {
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
	if (va[0] == "Join1_field1") { // app.unit:103, g_struct.act:443
		for _, st := range glob.Dats.ApJoin1 {
			if (st.Kfield1p == me.Me) {
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
	if (va[0] == "Join2_field1") { // app.unit:118, g_struct.act:443
		for _, st := range glob.Dats.ApJoin2 {
			if (st.Kfield1p == me.Me) {
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

type KpAttrs struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
}

func loadAttrs(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpAttrs)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApAttrs)
	st.LineNo = lno
	st.Comp = "Attrs";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	st.Kparentp = len( act.ApField ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Attrs has no Field parent") ;
		return 1
	}
	act.ApField[ len( act.ApField )-1 ].Childs = append(act.ApField[ len( act.ApField )-1 ].Childs, st)
	act.ApField[ len( act.ApField )-1 ].ItsAttrs = append(act.ApField[ len( act.ApField )-1 ].ItsAttrs, st)	// app.unit:49, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Attrs_" + name	// app.unit:68, g_struct.act:286
	act.index[s] = st.Me;
	act.ApAttrs = append(act.ApAttrs, st)
	return 0
}

func (me KpAttrs) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // app.unit:49, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApField[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Attrs?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpAttrs) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // app.unit:49, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApField[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpOf struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kfieldp int
	Ktypep int
	Kattrp int
	Kfromp int
}

func loadOf(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpOf)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApOf)
	st.LineNo = lno
	st.Comp = "Of";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["field"] = getw(ln,p)
	p,st.Names["attr"] = getw(ln,p)
	p,st.Names["from"] = getw(ln,p)
	p,st.Names["op"] = getw(ln,p)
	p,st.Names["value"] = getws(ln,p)
	st.Kfieldp = -1
	st.Ktypep = -1
	st.Kattrp = -1
	st.Kfromp = -1
	st.Kparentp = len( act.ApTable ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Of has no Table parent") ;
		return 1
	}
	act.ApTable[ len( act.ApTable )-1 ].Childs = append(act.ApTable[ len( act.ApTable )-1 ].Childs, st)
	act.ApTable[ len( act.ApTable )-1 ].ItsOf = append(act.ApTable[ len( act.ApTable )-1 ].ItsOf, st)	// app.unit:41, g_struct.act:248
	act.ApOf = append(act.ApOf, st)
	return 0
}

func (me KpOf) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // app.unit:41, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApTable[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Of?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpOf) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // app.unit:41, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApTable[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "field" {
		if me.Kfieldp >= 0 {
			st := glob.Dats.ApField[ me.Kfieldp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpJoin1 struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kfield1p int
	Ktable2p int
	Kfield2p int
}

func loadJoin1(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpJoin1)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApJoin1)
	st.LineNo = lno
	st.Comp = "Join1";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["field1"] = getw(ln,p)
	p,st.Names["table2"] = getw(ln,p)
	p,st.Names["field2"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["use"] = getw(ln,p)
	st.Kfield1p = -1
	st.Ktable2p = -1
	st.Kfield2p = -1
	st.Kparentp = len( act.ApTable ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Join1 has no Table parent") ;
		return 1
	}
	act.ApTable[ len( act.ApTable )-1 ].Childs = append(act.ApTable[ len( act.ApTable )-1 ].Childs, st)
	act.ApTable[ len( act.ApTable )-1 ].ItsJoin1 = append(act.ApTable[ len( act.ApTable )-1 ].ItsJoin1, st)	// app.unit:41, g_struct.act:248
	act.ApJoin1 = append(act.ApJoin1, st)
	return 0
}

func (me KpJoin1) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // app.unit:41, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApTable[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Join1?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpJoin1) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // app.unit:41, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApTable[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "field1" {
		if me.Kfield1p >= 0 {
			st := glob.Dats.ApField[ me.Kfield1p ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "table2" {
		if me.Ktable2p >= 0 {
			st := glob.Dats.ApTable[ me.Ktable2p ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpJoin2 struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kfield1p int
	Ktable2p int
	Kfield2p int
	Kattr2p int
}

func loadJoin2(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpJoin2)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApJoin2)
	st.LineNo = lno
	st.Comp = "Join2";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["field1"] = getw(ln,p)
	p,st.Names["table2"] = getw(ln,p)
	p,st.Names["field2"] = getw(ln,p)
	p,st.Names["attr2"] = getw(ln,p)
	st.Kfield1p = -1
	st.Ktable2p = -1
	st.Kfield2p = -1
	st.Kattr2p = -1
	st.Kparentp = len( act.ApTable ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Join2 has no Table parent") ;
		return 1
	}
	act.ApTable[ len( act.ApTable )-1 ].Childs = append(act.ApTable[ len( act.ApTable )-1 ].Childs, st)
	act.ApTable[ len( act.ApTable )-1 ].ItsJoin2 = append(act.ApTable[ len( act.ApTable )-1 ].ItsJoin2, st)	// app.unit:41, g_struct.act:248
	act.ApJoin2 = append(act.ApJoin2, st)
	return 0
}

func (me KpJoin2) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // app.unit:41, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApTable[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Join2?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpJoin2) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // app.unit:41, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApTable[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "field1" {
		if me.Kfield1p >= 0 {
			st := glob.Dats.ApField[ me.Kfield1p ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "table2" {
		if me.Ktable2p >= 0 {
			st := glob.Dats.ApTable[ me.Ktable2p ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpDomain struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	ItsModel [] *KpModel 
	Childs [] Kp
}

func loadDomain(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpDomain)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApDomain)
	st.LineNo = lno
	st.Comp = "Domain";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	name,_ := st.Names["name"]
	act.index["Domain_" + name] = st.Me;
	act.ApDomain = append(act.ApDomain, st)
	return 0
}

func (me KpDomain) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "Frame_domain" && len(va) > 1) { // note.unit:27, g_struct.act:633
		for _, st := range glob.Dats.ApFrame {
			if (st.Kdomainp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Domain?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpDomain) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Model" { // note.unit:10, g_struct.act:612
		for _, st := range me.ItsModel {
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
	if (va[0] == "Frame_domain") { // note.unit:27, g_struct.act:443
		for _, st := range glob.Dats.ApFrame {
			if (st.Kdomainp == me.Me) {
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

type KpModel struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	ItsFrame [] *KpFrame 
	Childs [] Kp
}

func loadModel(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpModel)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApModel)
	st.LineNo = lno
	st.Comp = "Model";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	st.Kparentp = len( act.ApDomain ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Model has no Domain parent") ;
		return 1
	}
	act.ApDomain[ len( act.ApDomain )-1 ].Childs = append(act.ApDomain[ len( act.ApDomain )-1 ].Childs, st)
	act.ApDomain[ len( act.ApDomain )-1 ].ItsModel = append(act.ApDomain[ len( act.ApDomain )-1 ].ItsModel, st)	// note.unit:2, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Model_" + name	// note.unit:13, g_struct.act:286
	act.index[s] = st.Me;
	act.ApModel = append(act.ApModel, st)
	return 0
}

func (me KpModel) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApDomain[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Model?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpModel) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Frame" { // note.unit:18, g_struct.act:612
		for _, st := range me.ItsFrame {
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
	if va[0] == "parent" { // note.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApDomain[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpFrame struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kdomainp int
	ItsA [] *KpA 
	Childs [] Kp
}

func loadFrame(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpFrame)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApFrame)
	st.LineNo = lno
	st.Comp = "Frame";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["group"] = getw(ln,p)
	p,st.Names["domain"] = getsw(ln,p)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	st.Kdomainp = -1
	st.Kparentp = len( act.ApModel ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Frame has no Model parent") ;
		return 1
	}
	act.ApModel[ len( act.ApModel )-1 ].Childs = append(act.ApModel[ len( act.ApModel )-1 ].Childs, st)
	act.ApModel[ len( act.ApModel )-1 ].ItsFrame = append(act.ApModel[ len( act.ApModel )-1 ].ItsFrame, st)	// note.unit:10, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Frame_" + name	// note.unit:23, g_struct.act:286
	act.index[s] = st.Me;
	act.ApFrame = append(act.ApFrame, st)
	return 0
}

func (me KpFrame) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:10, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApModel[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Frame?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpFrame) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "A" { // note.unit:30, g_struct.act:612
		for _, st := range me.ItsA {
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
	if va[0] == "parent" { // note.unit:10, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApModel[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "domain" {
		if me.Kdomainp >= 0 {
			st := glob.Dats.ApDomain[ me.Kdomainp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpA struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kdomainp int
	Kmodelp int
	ItsUse [] *KpUse 
	Childs [] Kp
}

func loadA(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpA)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApA)
	st.LineNo = lno
	st.Comp = "A";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["model"] = getsw(ln,p)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	st.Kdomainp = -1
	st.Kmodelp = -1
	st.Kparentp = len( act.ApFrame ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " A has no Frame parent") ;
		return 1
	}
	act.ApFrame[ len( act.ApFrame )-1 ].Childs = append(act.ApFrame[ len( act.ApFrame )-1 ].Childs, st)
	act.ApFrame[ len( act.ApFrame )-1 ].ItsA = append(act.ApFrame[ len( act.ApFrame )-1 ].ItsA, st)	// note.unit:18, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_A_" + name	// note.unit:38, g_struct.act:286
	act.index[s] = st.Me;
	act.ApA = append(act.ApA, st)
	return 0
}

func (me KpA) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:18, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApFrame[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,A?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpA) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Use" { // note.unit:47, g_struct.act:612
		for _, st := range me.ItsUse {
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
	if va[0] == "parent" { // note.unit:18, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApFrame[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpUse struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Kmodelp int
	Kframep int
	Kap int
}

func loadUse(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpUse)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApUse)
	st.LineNo = lno
	st.Comp = "Use";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["frame"] = getsw(ln,p)
	p,st.Names["a"] = getw(ln,p)
	p,st.Names["pad"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	st.Kmodelp = -1
	st.Kframep = -1
	st.Kap = -1
	st.Kparentp = len( act.ApA ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Use has no A parent") ;
		return 1
	}
	act.ApA[ len( act.ApA )-1 ].Childs = append(act.ApA[ len( act.ApA )-1 ].Childs, st)
	act.ApA[ len( act.ApA )-1 ].ItsUse = append(act.ApA[ len( act.ApA )-1 ].ItsUse, st)	// note.unit:30, g_struct.act:248
	act.ApUse = append(act.ApUse, st)
	return 0
}

func (me KpUse) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:30, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApA[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Use?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpUse) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // note.unit:30, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApA[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpCol struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	Knamep int
}

func loadCol(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpCol)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApCol)
	st.LineNo = lno
	st.Comp = "Col";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["index"] = getw(ln,p)
	p,st.Names["group"] = getw(ln,p)
	p,st.Names["file"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	st.Knamep = -1
	st.Kparentp = len( act.ApGrid ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Col has no Grid parent") ;
		return 1
	}
	act.ApGrid[ len( act.ApGrid )-1 ].Childs = append(act.ApGrid[ len( act.ApGrid )-1 ].Childs, st)
	act.ApGrid[ len( act.ApGrid )-1 ].ItsCol = append(act.ApGrid[ len( act.ApGrid )-1 ].ItsCol, st)	// note.unit:74, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Col_" + name	// note.unit:65, g_struct.act:286
	act.index[s] = st.Me;
	act.ApCol = append(act.ApCol, st)
	return 0
}

func (me KpCol) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:74, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApGrid[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Col?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpCol) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // note.unit:74, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApGrid[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if va[0] == "name" {
		if me.Knamep >= 0 {
			st := glob.Dats.ApGrid[ me.Knamep ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpGrid struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Knamep int
	ItsCol [] *KpCol 
	Childs [] Kp
}

func loadGrid(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpGrid)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApGrid)
	st.LineNo = lno
	st.Comp = "Grid";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["file"] = getw(ln,p)
	p,st.Names["info"] = getws(ln,p)
	st.Knamep = -1
	name,_ := st.Names["name"]
	act.index["Grid_" + name] = st.Me;
	act.ApGrid = append(act.ApGrid, st)
	return 0
}

func (me KpGrid) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "Col_name" && len(va) > 1) { // note.unit:71, g_struct.act:633
		for _, st := range glob.Dats.ApCol {
			if (st.Knamep == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Grid_name" && len(va) > 1) { // note.unit:81, g_struct.act:633
		for _, st := range glob.Dats.ApGrid {
			if (st.Knamep == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Grid?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpGrid) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Col" { // note.unit:62, g_struct.act:612
		for _, st := range me.ItsCol {
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
	if va[0] == "name" {
		if me.Knamep >= 0 {
			st := glob.Dats.ApGrid[ me.Knamep ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], me.LineNo) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Col_name") { // note.unit:71, g_struct.act:443
		for _, st := range glob.Dats.ApCol {
			if (st.Knamep == me.Me) {
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
	if (va[0] == "Grid_name") { // note.unit:81, g_struct.act:443
		for _, st := range glob.Dats.ApGrid {
			if (st.Knamep == me.Me) {
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

type KpConcept struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	ItsTopic [] *KpTopic 
	Childs [] Kp
}

func loadConcept(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpConcept)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApConcept)
	st.LineNo = lno
	st.Comp = "Concept";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	act.ApConcept = append(act.ApConcept, st)
	return 0
}

func (me KpConcept) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Concept?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpConcept) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "Topic" { // note.unit:91, g_struct.act:612
		for _, st := range me.ItsTopic {
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
	return(0)
}

type KpTopic struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
	ItsT [] *KpT 
	Childs [] Kp
}

func loadTopic(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpTopic)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApTopic)
	st.LineNo = lno
	st.Comp = "Topic";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["name"] = getw(ln,p)
	p,st.Names["level"] = getw(ln,p)
	p,st.Names["tag"] = getw(ln,p)
	p,st.Names["desc"] = getws(ln,p)
	st.Kparentp = len( act.ApConcept ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Topic has no Concept parent") ;
		return 1
	}
	act.ApConcept[ len( act.ApConcept )-1 ].Childs = append(act.ApConcept[ len( act.ApConcept )-1 ].Childs, st)
	act.ApConcept[ len( act.ApConcept )-1 ].ItsTopic = append(act.ApConcept[ len( act.ApConcept )-1 ].ItsTopic, st)	// note.unit:85, g_struct.act:248
	act.ApTopic = append(act.ApTopic, st)
	return 0
}

func (me KpTopic) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:85, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApConcept[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Topic?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpTopic) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "T" { // note.unit:100, g_struct.act:612
		for _, st := range me.ItsT {
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
	if va[0] == "parent" { // note.unit:85, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApConcept[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	return(0)
}

type KpT struct {
	Kp
	Me int
	LineNo string
	Comp string
	Flags [] string
	Names map[string]string
	Kparentp int
}

func loadT(act *ActT, ln string, pos int, lno string, flag []string) int {
	p := pos
	st := new(KpT)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApT)
	st.LineNo = lno
	st.Comp = "T";
	st.Flags = flag;
	st.Names["kComp"] = st.Comp
	st.Names["kMe"] = strconv.Itoa(st.Me)
	p,st.Names["file"] = getw(ln,p)
	p,st.Names["desc"] = getws(ln,p)
	st.Kparentp = len( act.ApTopic ) - 1;
	st.Names["kParentp"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " T has no Topic parent") ;
		return 1
	}
	act.ApTopic[ len( act.ApTopic )-1 ].Childs = append(act.ApTopic[ len( act.ApTopic )-1 ].Childs, st)
	act.ApTopic[ len( act.ApTopic )-1 ].ItsT = append(act.ApTopic[ len( act.ApTopic )-1 ].ItsT, st)	// note.unit:91, g_struct.act:248
	act.ApT = append(act.ApT, st)
	return 0
}

func (me KpT) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // note.unit:91, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApTopic[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,T?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpT) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // note.unit:91, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApTopic[ me.Kparentp ]
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
	if (va[0] == "Comp_parent" && len(va) > 1) { // gen.unit:16, g_struct.act:633
		for _, st := range glob.Dats.ApComp {
			if (st.Kparentp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref_comp" && len(va) > 1) { // gen.unit:65, g_struct.act:633
		for _, st := range glob.Dats.ApRef {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref2_comp" && len(va) > 1) { // gen.unit:83, g_struct.act:633
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_comp" && len(va) > 1) { // gen.unit:104, g_struct.act:633
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_comp_ref" && len(va) > 1) { // gen.unit:105, g_struct.act:633
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kcomp_refp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refq_comp" && len(va) > 1) { // gen.unit:126, g_struct.act:633
		for _, st := range glob.Dats.ApRefq {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refq_comp_ref" && len(va) > 1) { // gen.unit:127, g_struct.act:633
		for _, st := range glob.Dats.ApRefq {
			if (st.Kcomp_refp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refu_comp" && len(va) > 1) { // gen.unit:147, g_struct.act:633
		for _, st := range glob.Dats.ApRefu {
			if (st.Kcompp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refu_comp_ref" && len(va) > 1) { // gen.unit:148, g_struct.act:633
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
	if va[0] == "Element" { // gen.unit:19, g_struct.act:612
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
	if va[0] == "Ref" { // gen.unit:50, g_struct.act:612
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
	if va[0] == "Ref2" { // gen.unit:68, g_struct.act:612
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
	if va[0] == "Ref3" { // gen.unit:87, g_struct.act:612
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
	if va[0] == "Refq" { // gen.unit:109, g_struct.act:612
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
	if va[0] == "Refu" { // gen.unit:130, g_struct.act:612
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
	if va[0] == "Join" { // gen.unit:151, g_struct.act:612
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
	if (va[0] == "Comp_parent") { // gen.unit:16, g_struct.act:443
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
	if (va[0] == "Ref_comp") { // gen.unit:65, g_struct.act:443
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
	if (va[0] == "Ref2_comp") { // gen.unit:83, g_struct.act:443
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
	if (va[0] == "Ref3_comp") { // gen.unit:104, g_struct.act:443
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
	if (va[0] == "Ref3_comp_ref") { // gen.unit:105, g_struct.act:443
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
	if (va[0] == "Refq_comp") { // gen.unit:126, g_struct.act:443
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
	if (va[0] == "Refq_comp_ref") { // gen.unit:127, g_struct.act:443
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
	if (va[0] == "Refu_comp") { // gen.unit:147, g_struct.act:443
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
	if (va[0] == "Refu_comp_ref") { // gen.unit:148, g_struct.act:443
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
	act.ApComp[ len( act.ApComp )-1 ].ItsElement = append(act.ApComp[ len( act.ApComp )-1 ].ItsElement, st)	// gen.unit:2, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Element_" + name	// gen.unit:24, g_struct.act:286
	act.index[s] = st.Me;
	act.ApElement = append(act.ApElement, st)
	return 0
}

func (me KpElement) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	if (va[0] == "Ref_element" && len(va) > 1) { // gen.unit:64, g_struct.act:633
		for _, st := range glob.Dats.ApRef {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref2_element" && len(va) > 1) { // gen.unit:82, g_struct.act:633
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref2_element2" && len(va) > 1) { // gen.unit:84, g_struct.act:633
		for _, st := range glob.Dats.ApRef2 {
			if (st.Kelement2p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_element" && len(va) > 1) { // gen.unit:103, g_struct.act:633
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Ref3_element2" && len(va) > 1) { // gen.unit:106, g_struct.act:633
		for _, st := range glob.Dats.ApRef3 {
			if (st.Kelement2p == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refq_element" && len(va) > 1) { // gen.unit:125, g_struct.act:633
		for _, st := range glob.Dats.ApRefq {
			if (st.Kelementp == me.Me) {
				return (st.GetVar(glob, va[1:], lno) )
			}
		}
	}
	if (va[0] == "Refu_element" && len(va) > 1) { // gen.unit:146, g_struct.act:633
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
	if va[0] == "Opt" { // gen.unit:39, g_struct.act:612
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
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
		if me.Kparentp >= 0 {
			st := glob.Dats.ApComp[ me.Kparentp ]
			if len(va) > 1 {
				return( st.DoIts(glob, va[1:], lno) )
			}
			return( GoAct(glob, st) )
		}
		return(0)
	}
	if (va[0] == "Ref_element") { // gen.unit:64, g_struct.act:443
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
	if (va[0] == "Ref2_element") { // gen.unit:82, g_struct.act:443
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
	if (va[0] == "Ref2_element2") { // gen.unit:84, g_struct.act:443
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
	if (va[0] == "Ref3_element") { // gen.unit:103, g_struct.act:443
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
	if (va[0] == "Ref3_element2") { // gen.unit:106, g_struct.act:443
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
	if (va[0] == "Refq_element") { // gen.unit:125, g_struct.act:443
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
	if (va[0] == "Refu_element") { // gen.unit:146, g_struct.act:443
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
	act.ApElement[ len( act.ApElement )-1 ].ItsOpt = append(act.ApElement[ len( act.ApElement )-1 ].ItsOpt, st)	// gen.unit:19, g_struct.act:248
	name,_ := st.Names["name"]
	s := strconv.Itoa(st.Kparentp) + "_Opt_" + name	// gen.unit:45, g_struct.act:286
	act.index[s] = st.Me;
	act.ApOpt = append(act.ApOpt, st)
	return 0
}

func (me KpOpt) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:19, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApElement[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Opt?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpOpt) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:19, g_struct.act:418
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
	act.ApComp[ len( act.ApComp )-1 ].ItsRef = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef, st)	// gen.unit:2, g_struct.act:248
	act.ApRef = append(act.ApRef, st)
	return 0
}

func (me KpRef) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Ref?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRef) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
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
	act.ApComp[ len( act.ApComp )-1 ].ItsRef2 = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef2, st)	// gen.unit:2, g_struct.act:248
	act.ApRef2 = append(act.ApRef2, st)
	return 0
}

func (me KpRef2) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Ref2?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRef2) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
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
	act.ApComp[ len( act.ApComp )-1 ].ItsRef3 = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef3, st)	// gen.unit:2, g_struct.act:248
	act.ApRef3 = append(act.ApRef3, st)
	return 0
}

func (me KpRef3) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Ref3?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRef3) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
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
	act.ApComp[ len( act.ApComp )-1 ].ItsRefq = append(act.ApComp[ len( act.ApComp )-1 ].ItsRefq, st)	// gen.unit:2, g_struct.act:248
	act.ApRefq = append(act.ApRefq, st)
	return 0
}

func (me KpRefq) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Refq?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRefq) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
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
	act.ApComp[ len( act.ApComp )-1 ].ItsRefu = append(act.ApComp[ len( act.ApComp )-1 ].ItsRefu, st)	// gen.unit:2, g_struct.act:248
	act.ApRefu = append(act.ApRefu, st)
	return 0
}

func (me KpRefu) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Refu?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpRefu) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
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
	act.ApComp[ len( act.ApComp )-1 ].ItsJoin = append(act.ApComp[ len( act.ApComp )-1 ].ItsJoin, st)	// gen.unit:2, g_struct.act:248
	act.ApJoin = append(act.ApJoin, st)
	return 0
}

func (me KpJoin) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	if (va[0] == "parent") { // gen.unit:2, g_struct.act:433
		if (me.Kparentp >= 0 && len(va) > 1) {
			return( glob.Dats.ApComp[ me.Kparentp ].GetVar(glob, va[1:], me.LineNo) );
		}
	}
	r,ok := me.Names[va[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s,%s,Join?", va[0], lno, me.LineNo) }
	return ok,r
}

func (me KpJoin) DoIts(glob *GlobT, va []string, lno string) int {
	if va[0] == "parent" { // gen.unit:2, g_struct.act:418
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

