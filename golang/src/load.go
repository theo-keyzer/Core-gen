package main

import (
	"strconv"
	"fmt"
)

type Act_t struct {
	ApComp [] *KpComp
	ApStar [] *KpStar
	ApElement [] *KpElement
	ApRef [] *KpRef
	ApActor [] *KpActor
	ApD [] *KpD
	ApAll [] *KpAll
	ApDu [] *KpDu
	ApIdu [] *KpIdu
	ApIts [] *KpIts
	ApIits [] *KpIits
	ApC [] *KpC
	ApBreak [] *KpBreak
	ApReturn [] *KpReturn
	ApUnique [] *KpUnique
	ApCollect [] *KpCollect
}

var Acts Act_t

func Run(l string, ln string) {
	s := getw(l)
	if s == "*" { s = "Star" }
	if s == "Comp" { doComp(l, ln) }
	if s == "Star" { doStar(l, ln) }
	if s == "Element" { doElement(l, ln) }
	if s == "Ref" { doRef(l, ln) }
	if s == "Actor" { doActor(l, ln) }
	if s == "D" { doD(l, ln) }
	if s == "All" { doAll(l, ln) }
	if s == "Du" { doDu(l, ln) }
	if s == "Idu" { doIdu(l, ln) }
	if s == "Its" { doIts(l, ln) }
	if s == "Iits" { doIits(l, ln) }
	if s == "C" { doC(l, ln) }
	if s == "Break" { doBreak(l, ln) }
	if s == "Return" { doReturn(l, ln) }
	if s == "Unique" { doUnique(l, ln) }
	if s == "Collect" { doCollect(l, ln) }
}

func Run2() {
	do2Comp()
	do2Star()
	do2Element()
	do2Ref()
	do2Actor()
	do2D()
	do2All()
	do2Du()
	do2Idu()
	do2Its()
	do2Iits()
	do2C()
	do2Break()
	do2Return()
	do2Unique()
	do2Collect()
}

func doComp(l string, ln string) {
	st := new(KpComp)
	st.Kme = len(Acts.ApComp)
	st.Fline = ln
	Acts.ApComp = append(Acts.ApComp, st)
	st.Kname = getw(l)
	st.Knop = getw(l)
	st.Kparent = getw(l)
	st.Kfind = getw(l)
	st.Kdoc = getws(l)
}

func doStar(l string, ln string) {
	st := new(KpStar)
	st.Kme = len(Acts.ApStar)
	st.Fline = ln
	Acts.ApStar = append(Acts.ApStar, st)
	st.Kdoc = getws(l)
	Acts.ApComp[ len( Acts.ApComp)-1 ].itsStar = append(Acts.ApComp[ len( Acts.ApComp)-1 ].itsStar, st)
	st.up = Acts.ApComp[ len(Acts.ApComp)-1]
}

func doElement(l string, ln string) {
	st := new(KpElement)
	st.Kme = len(Acts.ApElement)
	st.Fline = ln
	Acts.ApElement = append(Acts.ApElement, st)
	st.Kname = getw(l)
	st.Kmw = getw(l)
	st.Kmw2 = getw(l)
	st.Kpad = getw(l)
	st.Kdoc = getws(l)
	Acts.ApComp[ len( Acts.ApComp)-1 ].itsElement = append(Acts.ApComp[ len( Acts.ApComp)-1 ].itsElement, st)
	st.up = Acts.ApComp[ len(Acts.ApComp)-1]
}

func doRef(l string, ln string) {
	st := new(KpRef)
	st.Kme = len(Acts.ApRef)
	st.Fline = ln
	Acts.ApRef = append(Acts.ApRef, st)
	st.Kelement = getw(l)
	st.Kcomp = getw(l)
	st.Kopt = getw(l)
	st.Kvar = getw(l)
	st.Kdoc = getws(l)
	Acts.ApComp[ len( Acts.ApComp)-1 ].itsRef = append(Acts.ApComp[ len( Acts.ApComp)-1 ].itsRef, st)
	st.up = Acts.ApComp[ len(Acts.ApComp)-1]
}

func doActor(l string, ln string) {
	st := new(KpActor)
	st.Kme = len(Acts.ApActor)
	st.Fline = ln
	Acts.ApActor = append(Acts.ApActor, st)
	st.Kname = getw(l)
	st.Kparent = getw(l)
	st.Kattr = getw(l)
	st.Keq = getw(l)
	st.Kvalue = getw(l)
	st.Kcc = getws(l)
}

func doD(l string, ln string) {
	st := new(KpD)
	st.Kme = len(Acts.ApD)
	st.Fline = ln
	Acts.ApD = append(Acts.ApD, st)
	st.Kds = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsD = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsD, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doAll(l string, ln string) {
	st := new(KpAll)
	st.Kme = len(Acts.ApAll)
	st.Fline = ln
	Acts.ApAll = append(Acts.ApAll, st)
	st.Kwhat = getw(l)
	st.Kactor = getw(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsAll = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsAll, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doDu(l string, ln string) {
	st := new(KpDu)
	st.Kme = len(Acts.ApDu)
	st.Fline = ln
	Acts.ApDu = append(Acts.ApDu, st)
	st.Kactor = getw(l)
	st.Kattr = getw(l)
	st.Keq = getw(l)
	st.Kvalue = getw(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsDu = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsDu, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doIdu(l string, ln string) {
	st := new(KpIdu)
	st.Kme = len(Acts.ApIdu)
	st.Fline = ln
	Acts.ApIdu = append(Acts.ApIdu, st)
	st.Kattr = getw(l)
	st.Keq = getw(l)
	st.Kvalue = getw(l)
	st.Kcc = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsIdu = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsIdu, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doIts(l string, ln string) {
	st := new(KpIts)
	st.Kme = len(Acts.ApIts)
	st.Fline = ln
	Acts.ApIts = append(Acts.ApIts, st)
	st.Kwhat = getw(l)
	st.Kactor = getw(l)
	st.Kname = getw(l)
	st.Kop = getw(l)
	st.Kvalue = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsIts = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsIts, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doIits(l string, ln string) {
	st := new(KpIits)
	st.Kme = len(Acts.ApIits)
	st.Fline = ln
	Acts.ApIits = append(Acts.ApIits, st)
	st.Kwhat = getw(l)
	st.Kcc = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsIits = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsIits, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doC(l string, ln string) {
	st := new(KpC)
	st.Kme = len(Acts.ApC)
	st.Fline = ln
	Acts.ApC = append(Acts.ApC, st)
	st.Kdesc = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsC = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsC, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doBreak(l string, ln string) {
	st := new(KpBreak)
	st.Kme = len(Acts.ApBreak)
	st.Fline = ln
	Acts.ApBreak = append(Acts.ApBreak, st)
	i, err := strconv.Atoi( getw(l) )
	if err != nil { i = 1 }
	st.Klevel = i
	st.Kdesc = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsBreak = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsBreak, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doReturn(l string, ln string) {
	st := new(KpReturn)
	st.Kme = len(Acts.ApReturn)
	st.Fline = ln
	Acts.ApReturn = append(Acts.ApReturn, st)
	i, err := strconv.Atoi( getw(l) )
	if err != nil { i = 1 }
	st.Klevel = i
	st.Kdesc = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsReturn = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsReturn, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doUnique(l string, ln string) {
	st := new(KpUnique)
	st.Kme = len(Acts.ApUnique)
	st.Fline = ln
	Acts.ApUnique = append(Acts.ApUnique, st)
	st.Kcmd = getw(l)
	st.Kkey = getw(l)
	st.Kcc = getws(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsUnique = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsUnique, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func doCollect(l string, ln string) {
	st := new(KpCollect)
	st.Kme = len(Acts.ApCollect)
	st.Fline = ln
	Acts.ApCollect = append(Acts.ApCollect, st)
	st.Kcmd = getw(l)
	st.Kpocket = getw(l)
	st.Kkey = getw(l)
	Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds = append(Acts.ApActor[ len( Acts.ApActor)-1 ].Kchilds, st)
	Acts.ApActor[ len( Acts.ApActor)-1 ].itsCollect = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsCollect, st)
	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

func find_comp(s string, opt string, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	for i := 0; i < len(Acts.ApComp); i++ {
		if s == Acts.ApComp[i].Kname { return(i) }
	}
	if opt == "check" {
		fmt.Println(s + " not found " + ln)
	}
	return(-1)
}
func find_element(s string, opt string, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	for i := 0; i < len(Acts.ApElement); i++ {
		if s == Acts.ApElement[i].Kname { return(i) }
	}
	if opt == "check" {
		fmt.Println(s + " not found " + ln)
	}
	return(-1)
}
func find_actor(s string, opt string, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	for i := 0; i < len(Acts.ApActor); i++ {
		if s == Acts.ApActor[i].Kname { return(i) }
	}
	if opt == "check" {
		fmt.Println(s + " not found " + ln)
	}
	return(-1)
}
func find_its(s string, opt string, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	for i := 0; i < len(Acts.ApIts); i++ {
		if s == Acts.ApIts[i].Kname { return(i) }
	}
	if opt == "check" {
		fmt.Println(s + " not found " + ln)
	}
	return(-1)
}
func do2Comp() {
	for i := 0; i < len( Acts.ApComp ); i++ {
		st := Acts.ApComp[i]
		st.Kme = i
		st.KparentP = find_comp( st.Kparent, "opt", st.Fline );
	}
}

func do2Star() {
	for i := 0; i < len( Acts.ApStar ); i++ {
		st := Acts.ApStar[i]
		st.Kme = i
	}
}

func do2Element() {
	for i := 0; i < len( Acts.ApElement ); i++ {
		st := Acts.ApElement[i]
		st.Kme = i
	}
}

func do2Ref() {
	for i := 0; i < len( Acts.ApRef ); i++ {
		st := Acts.ApRef[i]
		st.Kme = i
		st.KelementP = find__element( st.Kelement, "check", st.up, st.Fline );
		st.KcompP = find_comp( st.Kcomp, "check", st.Fline );
	}
}

func do2Actor() {
	for i := 0; i < len( Acts.ApActor ); i++ {
		st := Acts.ApActor[i]
		st.Kme = i
	}
}

func do2D() {
	for i := 0; i < len( Acts.ApD ); i++ {
		st := Acts.ApD[i]
		st.Kme = i
	}
}

func do2All() {
	for i := 0; i < len( Acts.ApAll ); i++ {
		st := Acts.ApAll[i]
		st.Kme = i
		st.KactorP = find_actor( st.Kactor, "check", st.Fline );
	}
}

func do2Du() {
	for i := 0; i < len( Acts.ApDu ); i++ {
		st := Acts.ApDu[i]
		st.Kme = i
		st.KactorP = find_actor( st.Kactor, "check", st.Fline );
	}
}

func do2Idu() {
	for i := 0; i < len( Acts.ApIdu ); i++ {
		st := Acts.ApIdu[i]
		st.Kme = i
	}
}

func do2Its() {
	for i := 0; i < len( Acts.ApIts ); i++ {
		st := Acts.ApIts[i]
		st.Kme = i
		st.KactorP = find_actor( st.Kactor, "check", st.Fline );
	}
}

func do2Iits() {
	for i := 0; i < len( Acts.ApIits ); i++ {
		st := Acts.ApIits[i]
		st.Kme = i
	}
}

func do2C() {
	for i := 0; i < len( Acts.ApC ); i++ {
		st := Acts.ApC[i]
		st.Kme = i
	}
}

func do2Break() {
	for i := 0; i < len( Acts.ApBreak ); i++ {
		st := Acts.ApBreak[i]
		st.Kme = i
	}
}

func do2Return() {
	for i := 0; i < len( Acts.ApReturn ); i++ {
		st := Acts.ApReturn[i]
		st.Kme = i
	}
}

func do2Unique() {
	for i := 0; i < len( Acts.ApUnique ); i++ {
		st := Acts.ApUnique[i]
		st.Kme = i
	}
}

func do2Collect() {
	for i := 0; i < len( Acts.ApCollect ); i++ {
		st := Acts.ApCollect[i]
		st.Kme = i
	}
}

