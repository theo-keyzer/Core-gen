package main

import (
	"strings"
	"fmt"
	"strconv"
)

type ActT struct {
	index       map[string]int
	ApType [] *KpType
	ApData [] *KpData
	ApAttr [] *KpAttr
	ApWhere [] *KpWhere
	ApLogic [] *KpLogic
	ApNode [] *KpNode
	ApLink [] *KpLink
	ApGraph [] *KpGraph
	ApMatrix [] *KpMatrix
	ApTable [] *KpTable
	ApField [] *KpField
	ApAttrs [] *KpAttrs
	ApOf [] *KpOf
	ApJoin1 [] *KpJoin1
	ApJoin2 [] *KpJoin2
	ApDomain [] *KpDomain
	ApModel [] *KpModel
	ApFrame [] *KpFrame
	ApA [] *KpA
	ApUse [] *KpUse
	ApCol [] *KpCol
	ApGrid [] *KpGrid
	ApConcept [] *KpConcept
	ApTopic [] *KpTopic
	ApT [] *KpT
	ApActor [] *KpActor
	ApAll [] *KpAll
	ApDu [] *KpDu
	ApNew [] *KpNew
	ApRefs [] *KpRefs
	ApVar [] *KpVar
	ApIts [] *KpIts
	ApC [] *KpC
	ApCs [] *KpCs
	ApOut [] *KpOut
	ApIn [] *KpIn
	ApBreak [] *KpBreak
	ApAdd [] *KpAdd
	ApThis [] *KpThis
	ApReplace [] *KpReplace
	ApComp [] *KpComp
	ApElement [] *KpElement
	ApOpt [] *KpOpt
	ApRef [] *KpRef
	ApRef2 [] *KpRef2
	ApRef3 [] *KpRef3
	ApRefq [] *KpRefq
	ApRefu [] *KpRefu
	ApJoin [] *KpJoin
}

func refs(act *ActT) int {
	errs := 0
	v := ""
	res := 0
	err := false
	for _, st := range act.ApAttr {

//  sample.unit:29, g_run.act:161

		v, _ = st.Names["table"]
		err, res = fnd(act, "Type_" + v, v,  ".", st.LineNo );
		st.Ktablep = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApWhere {

//  sample.unit:67, g_run.act:174

		v, _ = st.Names["attr"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Attr_" + v, v,  "check", st.LineNo );
		st.Kattrp = res
		if (err == false) {
			errs += 1
		}
//  sample.unit:71, g_run.act:174

		v, _ = st.Names["id"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Attr_" + v, v,  "check", st.LineNo );
		st.Kidp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApLogic {

//  sample.unit:92, g_run.act:174

		v, _ = st.Names["attr"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Attr_" + v, v,  ".", st.LineNo );
		st.Kattrp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApNode {

//  app.unit:7, g_run.act:161

		v, _ = st.Names["parent"]
		err, res = fnd(act, "Node_" + v, v,  ".", st.LineNo );
		st.Kparentp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApLink {

//  app.unit:18, g_run.act:161

		v, _ = st.Names["to"]
		err, res = fnd(act, "Node_" + v, v,  "check", st.LineNo );
		st.Ktop = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApField {

//  app.unit:52, g_run.act:161

		v, _ = st.Names["type"]
		err, res = fnd(act, "Type_" + v, v,  ".", st.LineNo );
		st.Ktypep = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApOf {

//  app.unit:74, g_run.act:174

		v, _ = st.Names["field"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Field_" + v, v,  "check", st.LineNo );
		st.Kfieldp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApJoin1 {

//  app.unit:96, g_run.act:174

		v, _ = st.Names["field1"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Field_" + v, v,  "check", st.LineNo );
		st.Kfield1p = res
		if (err == false) {
			errs += 1
		}
//  app.unit:97, g_run.act:161

		v, _ = st.Names["table2"]
		err, res = fnd(act, "Table_" + v, v,  "check", st.LineNo );
		st.Ktable2p = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApJoin2 {

//  app.unit:112, g_run.act:174

		v, _ = st.Names["field1"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Field_" + v, v,  "check", st.LineNo );
		st.Kfield1p = res
		if (err == false) {
			errs += 1
		}
//  app.unit:113, g_run.act:161

		v, _ = st.Names["table2"]
		err, res = fnd(act, "Table_" + v, v,  "check", st.LineNo );
		st.Ktable2p = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApFrame {

//  note.unit:22, g_run.act:161

		v, _ = st.Names["domain"]
		err, res = fnd(act, "Domain_" + v, v,  ".", st.LineNo );
		st.Kdomainp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApCol {

//  note.unit:65, g_run.act:161

		v, _ = st.Names["name"]
		err, res = fnd(act, "Grid_" + v, v,  "?", st.LineNo );
		st.Knamep = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApGrid {

//  note.unit:77, g_run.act:161

		v, _ = st.Names["name"]
		err, res = fnd(act, "Grid_" + v, v,  "?", st.LineNo );
		st.Knamep = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApAll {
//  act.unit:26, g_run.act:149

		err, res = fnd(act, "Actor_" + st.Kactor, st.Kactor,  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApDu {
//  act.unit:41, g_run.act:149

		err, res = fnd(act, "Actor_" + st.Kactor, st.Kactor,  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApIts {
//  act.unit:87, g_run.act:149

		err, res = fnd(act, "Actor_" + st.Kactor, st.Kactor,  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApThis {
//  act.unit:177, g_run.act:149

		err, res = fnd(act, "Actor_" + st.Kactor, st.Kactor,  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApComp {

//  gen.unit:9, g_run.act:161

		v, _ = st.Names["parent"]
		err, res = fnd(act, "Comp_" + v, v,  ".", st.LineNo );
		st.Kparentp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRef {

//  gen.unit:55, g_run.act:174

		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:56, g_run.act:161

		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRef2 {

//  gen.unit:73, g_run.act:174

		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:74, g_run.act:161

		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:75, g_run.act:174

		v, _ = st.Names["element2"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelement2p = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRef3 {

//  gen.unit:92, g_run.act:174

		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:93, g_run.act:161

		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:94, g_run.act:174

		v, _ = st.Names["element2"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelement2p = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:95, g_run.act:161

		v, _ = st.Names["comp_ref"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcomp_refp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRefq {

//  gen.unit:114, g_run.act:174

		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:115, g_run.act:161

		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:117, g_run.act:161

		v, _ = st.Names["comp_ref"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcomp_refp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRefu {

//  gen.unit:135, g_run.act:174

		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v, v,  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:136, g_run.act:161

		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
//  gen.unit:138, g_run.act:161

		v, _ = st.Names["comp_ref"]
		err, res = fnd(act, "Comp_" + v, v,  "check", st.LineNo );
		st.Kcomp_refp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApWhere {

//  sample.unit:68, g_run.act:248

	t := st.Kattrp
	if t >= 0 {
		st.Ktablep = act.ApAttr[t].Ktablep
	} else if "E_O_L" != "?" {
		fmt.Printf("ref error Attr not resolved %d\n", st.LineNo)
		errs += 1
	}
//  sample.unit:69, g_run.act:228

	v, _ = st.Names["from_id"]
	err, res = fnd(act, strconv.Itoa(st.Ktablep) + "_Attr_" + v, v, "E_O_L", st.LineNo)
	st.Kfrom_idp = res
	if !err {
		errs += 1
	}
	}
	for _, st := range act.ApOf {

//  app.unit:75, g_run.act:248

	t := st.Kfieldp
	if t >= 0 {
		st.Ktypep = act.ApField[t].Ktypep
	} else if "E_O_L" != "?" {
		fmt.Printf("ref error Field not resolved %d\n", st.LineNo)
		errs += 1
	}
//  app.unit:76, g_run.act:228

	v, _ = st.Names["attr"]
	err, res = fnd(act, strconv.Itoa(st.Ktypep) + "_Attr_" + v, v, "E_O_L", st.LineNo)
	st.Kattrp = res
	if !err {
		errs += 1
	}
//  app.unit:77, g_run.act:228

	v, _ = st.Names["from"]
	err, res = fnd(act, strconv.Itoa(st.Ktypep) + "_Attr_" + v, v, "E_O_L", st.LineNo)
	st.Kfromp = res
	if !err {
		errs += 1
	}
	}
	for _, st := range act.ApJoin1 {

//  app.unit:98, g_run.act:228

	v, _ = st.Names["field2"]
	err, res = fnd(act, strconv.Itoa(st.Ktable2p) + "_Field_" + v, v, "check", st.LineNo)
	st.Kfield2p = res
	if !err {
		errs += 1
	}
	}
	for _, st := range act.ApJoin2 {

//  app.unit:114, g_run.act:228

	v, _ = st.Names["field2"]
	err, res = fnd(act, strconv.Itoa(st.Ktable2p) + "_Field_" + v, v, "check", st.LineNo)
	st.Kfield2p = res
	if !err {
		errs += 1
	}
//  app.unit:115, g_run.act:228

	v, _ = st.Names["attr2"]
	err, res = fnd(act, strconv.Itoa(st.Kfield2p) + "_Attrs_" + v, v, "check", st.LineNo)
	st.Kattr2p = res
	if !err {
		errs += 1
	}
	}
	for _, st := range act.ApA {

//  note.unit:36, g_run.act:248

	t := st.Kparentp
	if t >= 0 {
		st.Kdomainp = act.ApFrame[t].Kdomainp
	} else if "." != "?" {
		fmt.Printf("ref error Parent not resolved %d\n", st.LineNo)
		errs += 1
	}
//  note.unit:37, g_run.act:228

	v, _ = st.Names["model"]
	err, res = fnd(act, strconv.Itoa(st.Kdomainp) + "_Model_" + v, v, "?", st.LineNo)
	st.Kmodelp = res
	if !err {
		errs += 1
	}
	}
	for _, st := range act.ApUse {

//  note.unit:50, g_run.act:248

	t := st.Kparentp
	if t >= 0 {
		st.Kmodelp = act.ApA[t].Kmodelp
	} else if "." != "?" {
		fmt.Printf("ref error Parent not resolved %d\n", st.LineNo)
		errs += 1
	}
//  note.unit:51, g_run.act:228

	v, _ = st.Names["frame"]
	err, res = fnd(act, strconv.Itoa(st.Kmodelp) + "_Frame_" + v, v, ".", st.LineNo)
	st.Kframep = res
	if !err {
		errs += 1
	}
//  note.unit:52, g_run.act:228

	v, _ = st.Names["a"]
	err, res = fnd(act, strconv.Itoa(st.Kframep) + "_A_" + v, v, ".", st.LineNo)
	st.Kap = res
	if !err {
		errs += 1
	}
	}
	return(errs)
}

func DoAll(glob *GlobT, va []string, lno string) int {
	if va[0] == "Type" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Type_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApType[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApType[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApType {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Data" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Data_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApData[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApData[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApData {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Attr" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Attr_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApAttr[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApAttr[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApAttr {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Where" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Where_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApWhere[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApWhere[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApWhere {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Logic" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Logic_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApLogic[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApLogic[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApLogic {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Node" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Node_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApNode[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApNode[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApNode {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Link" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Link_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApLink[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApLink[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApLink {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Graph" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Graph_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApGraph[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApGraph[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApGraph {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Matrix" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Matrix_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApMatrix[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApMatrix[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApMatrix {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Table" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Table_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApTable[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApTable[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApTable {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Field" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Field_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApField[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApField[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApField {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Attrs" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Attrs_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApAttrs[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApAttrs[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApAttrs {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Of" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Of_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApOf[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApOf[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApOf {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Join1" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Join1_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApJoin1[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApJoin1[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApJoin1 {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Join2" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Join2_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApJoin2[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApJoin2[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApJoin2 {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Domain" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Domain_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApDomain[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApDomain[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApDomain {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Model" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Model_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApModel[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApModel[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApModel {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Frame" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Frame_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApFrame[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApFrame[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApFrame {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "A" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["A_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApA[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApA[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApA {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Use" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Use_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApUse[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApUse[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApUse {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Col" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Col_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApCol[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApCol[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApCol {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Grid" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Grid_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApGrid[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApGrid[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApGrid {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Concept" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Concept_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApConcept[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApConcept[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApConcept {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Topic" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Topic_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApTopic[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApTopic[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApTopic {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "T" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["T_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApT[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApT[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApT {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Actor" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Actor_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApActor[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApActor[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApActor {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Comp" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Comp_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApComp[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApComp[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApComp {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Element" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Element_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApElement[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApElement[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApElement {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Opt" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Opt_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApOpt[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApOpt[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApOpt {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Ref" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Ref_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApRef[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApRef[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApRef {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Ref2" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Ref2_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApRef2[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApRef2[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApRef2 {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Ref3" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Ref3_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApRef3[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApRef3[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApRef3 {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Refq" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Refq_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApRefq[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApRefq[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApRefq {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Refu" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Refu_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApRefu[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApRefu[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApRefu {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	if va[0] == "Join" {
		if (len(va) > 1 && len(va[1]) > 0) {
			en, er := glob.Dats.index["Join_" + va[1] ];
			if !er {
				if len(va) > 2 {
					return( glob.Dats.ApJoin[en].DoIts(glob, va[2:], lno) )
				}
				return( GoAct(glob, glob.Dats.ApJoin[en]) )
			}
			return(0)
		}
		for _, st := range glob.Dats.ApJoin {
			if len(va) > 2 {
				ret := st.DoIts(glob, va[2:], lno)
				if ret != 0 {
					return(ret)
				}
				continue
			}
			ret := GoAct(glob, st)
			if ret != 0 {
				return(ret)
			}
		}
		return(0)
	}
	fmt.Sprintf("?No all %s cmd ?%s?", va[0], lno);
	return 0;
}

func Load(act *ActT, toks string, ln string, pos int, lno string) int {
	errs := 0
	ss := strings.Split(toks,".")
	tok := ss[0]
	flag := ss[1:]
	if tok == "Type" { errs += loadType(act,ln,pos,lno,flag) }
	if tok == "Data" { errs += loadData(act,ln,pos,lno,flag) }
	if tok == "Attr" { errs += loadAttr(act,ln,pos,lno,flag) }
	if tok == "Where" { errs += loadWhere(act,ln,pos,lno,flag) }
	if tok == "Logic" { errs += loadLogic(act,ln,pos,lno,flag) }
	if tok == "Node" { errs += loadNode(act,ln,pos,lno,flag) }
	if tok == "Link" { errs += loadLink(act,ln,pos,lno,flag) }
	if tok == "Graph" { errs += loadGraph(act,ln,pos,lno,flag) }
	if tok == "Matrix" { errs += loadMatrix(act,ln,pos,lno,flag) }
	if tok == "Table" { errs += loadTable(act,ln,pos,lno,flag) }
	if tok == "Field" { errs += loadField(act,ln,pos,lno,flag) }
	if tok == "Attrs" { errs += loadAttrs(act,ln,pos,lno,flag) }
	if tok == "Of" { errs += loadOf(act,ln,pos,lno,flag) }
	if tok == "Join1" { errs += loadJoin1(act,ln,pos,lno,flag) }
	if tok == "Join2" { errs += loadJoin2(act,ln,pos,lno,flag) }
	if tok == "Domain" { errs += loadDomain(act,ln,pos,lno,flag) }
	if tok == "Model" { errs += loadModel(act,ln,pos,lno,flag) }
	if tok == "Frame" { errs += loadFrame(act,ln,pos,lno,flag) }
	if tok == "A" { errs += loadA(act,ln,pos,lno,flag) }
	if tok == "Use" { errs += loadUse(act,ln,pos,lno,flag) }
	if tok == "Col" { errs += loadCol(act,ln,pos,lno,flag) }
	if tok == "Grid" { errs += loadGrid(act,ln,pos,lno,flag) }
	if tok == "Concept" { errs += loadConcept(act,ln,pos,lno,flag) }
	if tok == "Topic" { errs += loadTopic(act,ln,pos,lno,flag) }
	if tok == "T" { errs += loadT(act,ln,pos,lno,flag) }
	if tok == "Actor" { errs += loadActor(act,ln,pos,lno,flag) }
	if tok == "All" { errs += loadAll(act,ln,pos,lno,flag) }
	if tok == "Du" { errs += loadDu(act,ln,pos,lno,flag) }
	if tok == "New" { errs += loadNew(act,ln,pos,lno,flag) }
	if tok == "Refs" { errs += loadRefs(act,ln,pos,lno,flag) }
	if tok == "Var" { errs += loadVar(act,ln,pos,lno,flag) }
	if tok == "Its" { errs += loadIts(act,ln,pos,lno,flag) }
	if tok == "C" { errs += loadC(act,ln,pos,lno,flag) }
	if tok == "Cs" { errs += loadCs(act,ln,pos,lno,flag) }
	if tok == "Out" { errs += loadOut(act,ln,pos,lno,flag) }
	if tok == "In" { errs += loadIn(act,ln,pos,lno,flag) }
	if tok == "Break" { errs += loadBreak(act,ln,pos,lno,flag) }
	if tok == "Add" { errs += loadAdd(act,ln,pos,lno,flag) }
	if tok == "This" { errs += loadThis(act,ln,pos,lno,flag) }
	if tok == "Replace" { errs += loadReplace(act,ln,pos,lno,flag) }
	if tok == "Comp" { errs += loadComp(act,ln,pos,lno,flag) }
	if tok == "Element" { errs += loadElement(act,ln,pos,lno,flag) }
	if tok == "Opt" { errs += loadOpt(act,ln,pos,lno,flag) }
	if tok == "Ref" { errs += loadRef(act,ln,pos,lno,flag) }
	if tok == "Ref2" { errs += loadRef2(act,ln,pos,lno,flag) }
	if tok == "Ref3" { errs += loadRef3(act,ln,pos,lno,flag) }
	if tok == "Refq" { errs += loadRefq(act,ln,pos,lno,flag) }
	if tok == "Refu" { errs += loadRefu(act,ln,pos,lno,flag) }
	if tok == "Join" { errs += loadJoin(act,ln,pos,lno,flag) }
	return errs
}

