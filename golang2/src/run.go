package main

import (
//	"fmt"
//	"os"
	"strings"
)
type ActT struct {
	index       map[string]int
	ApActor [] *KpActor
	ApC [] *KpC
}

func Load(act *ActT, toks string, ln string, pos int, lno string) bool {
//	fmt.Println(toks)
	ss := strings.Split(toks,".")
	tok := ss[0]
	flag := ss[1:]
	if tok == "Actor" { doActor(act,ln,pos,lno,flag) }
	if tok == "C" { doC(act,ln,pos,lno,flag) }
	return false
}

func doActor(act *ActT, ln string, pos int, lno string, flag []string) {
	p := pos
	st := new(KpActor)
	st.Kme = len(act.ApActor)
	st.LineNo = lno
	act.ApActor = append(act.ApActor, st)
	p,st.Kname = getw(ln,p)
	p,st.Kparent = getw(ln,p)
	p,st.Kattr = getw(ln,p)
	p,st.Keq = getw(ln,p)
	p,st.Kvalue = getw(ln,p)
	p,st.Kcc = getws(ln,p)
}
func doC(act *ActT, ln string, pos int, lno string, flag []string) {
	p := pos
	st := new(KpC)
	st.Kme = len(act.ApC)
	st.LineNo = lno
	act.ApC = append(act.ApC, st)
	p,st.Kdesc = getws(ln,p)
	act.ApActor[ len( act.ApActor)-1 ].Kchilds = append(act.ApActor[ len( act.ApActor)-1 ].Kchilds, st)
//	Acts.ApActor[ len( Acts.ApActor)-1 ].itsC = append(Acts.ApActor[ len( Acts.ApActor)-1 ].itsC, st)
//	st.up = Acts.ApActor[ len(Acts.ApActor)-1]
}

