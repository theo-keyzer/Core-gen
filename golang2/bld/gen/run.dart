package main

import (
	"strings"
)

type ActT struct {
	index       map[string]int
	ApComp [] *KpComp
	ApElement [] *KpElement
	ApOpt [] *KpOpt
	ApRef [] *KpRef
	ApRef2 [] *KpRef2
	ApRef3 [] *KpRef3
	ApRefq [] *KpRefq
	ApRefu [] *KpRefu
	ApJoin [] *KpJoin
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
}

func Load(act *ActT, toks string, ln string, pos int, lno string) bool {
	ss := strings.Split(toks,".")
	tok := ss[0]
	flag := ss[1:]
	if tok == "Comp" { _ := loadComp(act,ln,pos,lno,flag) }
	if tok == "Element" { _ := loadElement(act,ln,pos,lno,flag) }
	if tok == "Opt" { _ := loadOpt(act,ln,pos,lno,flag) }
	if tok == "Ref" { _ := loadRef(act,ln,pos,lno,flag) }
	if tok == "Ref2" { _ := loadRef2(act,ln,pos,lno,flag) }
	if tok == "Ref3" { _ := loadRef3(act,ln,pos,lno,flag) }
	if tok == "Refq" { _ := loadRefq(act,ln,pos,lno,flag) }
	if tok == "Refu" { _ := loadRefu(act,ln,pos,lno,flag) }
	if tok == "Join" { _ := loadJoin(act,ln,pos,lno,flag) }
	if tok == "Actor" { _ := loadActor(act,ln,pos,lno,flag) }
	if tok == "All" { _ := loadAll(act,ln,pos,lno,flag) }
	if tok == "Du" { _ := loadDu(act,ln,pos,lno,flag) }
	if tok == "New" { _ := loadNew(act,ln,pos,lno,flag) }
	if tok == "Refs" { _ := loadRefs(act,ln,pos,lno,flag) }
	if tok == "Var" { _ := loadVar(act,ln,pos,lno,flag) }
	if tok == "Its" { _ := loadIts(act,ln,pos,lno,flag) }
	if tok == "C" { _ := loadC(act,ln,pos,lno,flag) }
	if tok == "Cs" { _ := loadCs(act,ln,pos,lno,flag) }
	if tok == "Out" { _ := loadOut(act,ln,pos,lno,flag) }
	if tok == "In" { _ := loadIn(act,ln,pos,lno,flag) }
	if tok == "Break" { _ := loadBreak(act,ln,pos,lno,flag) }
	if tok == "Add" { _ := loadAdd(act,ln,pos,lno,flag) }
	if tok == "This" { _ := loadThis(act,ln,pos,lno,flag) }
	if tok == "Replace" { _ := loadReplace(act,ln,pos,lno,flag) }
	return false
}

