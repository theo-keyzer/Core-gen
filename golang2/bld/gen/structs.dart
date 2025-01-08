package main

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
	ItsElement [] KpElement 
	ItsRef [] KpRef 
	ItsRef2 [] KpRef2 
	ItsRef3 [] KpRef3 
	ItsRefq [] KpRefq 
	ItsRefu [] KpRefu 
	ItsJoin [] KpJoin 
	Childs [] Kp
}

func loadComp(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpComp)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApComp)
	st.LineNo = lno
	st.Comp = "Comp";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kname"] = getw(ln,p)
	p,st.Names["Knop"] = getw(ln,p)
	p,st.Names["Kparent"] = getw(ln,p)
	p,st.Names["Kfind"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	act.index["Comp_" + st.Kname] = st.Me;
	act.ApComp = append(act.ApComp, st)
	return true;
}

func (me KpComp) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpComp) DoIts(glob *GlobT, va []string, lno string) int {
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
	ItsOpt [] KpOpt 
	Childs [] Kp
}

func loadElement(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpElement)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApElement)
	st.LineNo = lno
	st.Comp = "Element";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kname"] = getw(ln,p)
	p,st.Names["Kmw"] = getw(ln,p)
	p,st.Names["Kmw2"] = getw(ln,p)
	p,st.Names["Kpad"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Element has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsElement = append(act.ApComp[ len( act.ApComp )-1 ].ItsElement, st)
	s := strconv.Itoa(st.Kparentp) + "_Element_" + Kname
	act.index[s] = st.Me;
	act.ApElement = append(act.ApElement, st)
	return true;
}

func (me KpElement) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpElement) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadOpt(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpOpt)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApOpt)
	st.LineNo = lno
	st.Comp = "Opt";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kname"] = getw(ln,p)
	p,st.Names["Kpad"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApElement.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Opt has no Element parent") ;
		return false;
	}
	act.ApElement[ len( act.ApElement )-1 ].Childs = append(act.ApElement[ len( act.ApElement )-1 ].Childs, st)
	act.ApElement[ len( act.ApElement )-1 ].ItsOpt = append(act.ApElement[ len( act.ApElement )-1 ].ItsOpt, st)
	s := strconv.Itoa(st.Kparentp) + "_Opt_" + Kname
	act.index[s] = st.Me;
	act.ApOpt = append(act.ApOpt, st)
	return true;
}

func (me KpOpt) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpOpt) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadRef(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpRef)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRef)
	st.LineNo = lno
	st.Comp = "Ref";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kelement"] = getw(ln,p)
	p,st.Names["Kcomp"] = getw(ln,p)
	p,st.Names["Kopt"] = getw(ln,p)
	p,st.Names["Kvar"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Ref has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRef = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef, st)
	act.ApRef = append(act.ApRef, st)
	return true;
}

func (me KpRef) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpRef) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadRef2(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpRef2)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRef2)
	st.LineNo = lno
	st.Comp = "Ref2";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kelement"] = getw(ln,p)
	p,st.Names["Kcomp"] = getw(ln,p)
	p,st.Names["Kelement2"] = getw(ln,p)
	p,st.Names["Kopt"] = getw(ln,p)
	p,st.Names["Kvar"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Ref2 has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRef2 = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef2, st)
	act.ApRef2 = append(act.ApRef2, st)
	return true;
}

func (me KpRef2) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpRef2) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadRef3(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpRef3)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRef3)
	st.LineNo = lno
	st.Comp = "Ref3";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kelement"] = getw(ln,p)
	p,st.Names["Kcomp"] = getw(ln,p)
	p,st.Names["Kelement2"] = getw(ln,p)
	p,st.Names["Kcomp_ref"] = getw(ln,p)
	p,st.Names["Kelement3"] = getw(ln,p)
	p,st.Names["Kopt"] = getw(ln,p)
	p,st.Names["Kvar"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Ref3 has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRef3 = append(act.ApComp[ len( act.ApComp )-1 ].ItsRef3, st)
	act.ApRef3 = append(act.ApRef3, st)
	return true;
}

func (me KpRef3) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpRef3) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadRefq(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpRefq)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRefq)
	st.LineNo = lno
	st.Comp = "Refq";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kelement"] = getw(ln,p)
	p,st.Names["Kcomp"] = getw(ln,p)
	p,st.Names["Kelement2"] = getw(ln,p)
	p,st.Names["Kcomp_ref"] = getw(ln,p)
	p,st.Names["Kopt"] = getw(ln,p)
	p,st.Names["Kvar"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Refq has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRefq = append(act.ApComp[ len( act.ApComp )-1 ].ItsRefq, st)
	act.ApRefq = append(act.ApRefq, st)
	return true;
}

func (me KpRefq) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpRefq) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadRefu(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpRefu)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApRefu)
	st.LineNo = lno
	st.Comp = "Refu";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kelement"] = getw(ln,p)
	p,st.Names["Kcomp"] = getw(ln,p)
	p,st.Names["Kelement2"] = getw(ln,p)
	p,st.Names["Kcomp_ref"] = getw(ln,p)
	p,st.Names["Kelement3"] = getw(ln,p)
	p,st.Names["Kopt"] = getw(ln,p)
	p,st.Names["Kvar"] = getw(ln,p)
	p,st.Names["Kdoc"] = getws(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Refu has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsRefu = append(act.ApComp[ len( act.ApComp )-1 ].ItsRefu, st)
	act.ApRefu = append(act.ApRefu, st)
	return true;
}

func (me KpRefu) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpRefu) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadJoin(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpJoin)
	st.Names = make(map[string]string) 
	st.Me = len(act.ApJoin)
	st.LineNo = lno
	st.Comp = "Join";
	st.Flags = flag;
	st.Names["Comp"] = st.Comp
	st.Names["Me"] = st.Me
	p,st.Names["Kelement"] = getw(ln,p)
	p,st.Names["Kdir"] = getw(ln,p)
	p,st.Names["Kcomp"] = getw(ln,p)
	p,st.Names["Kusing"] = getw(ln,p)
	p,st.Names["Kelement2"] = getw(ln,p)
	p,st.Names["Kcomp2"] = getw(ln,p)
	p,st.Names["Kelement3"] = getw(ln,p)
	st.Kparentp = act.ApComp.length-1;
	st.Names["Kparent"] = strconv.Itoa(st.Kparentp)
	if (st.Kparentp < 0 ) { 
		print(lno + " Join has no Comp parent") ;
		return false;
	}
	act.ApComp[ len( act.ApComp )-1 ].Childs = append(act.ApComp[ len( act.ApComp )-1 ].Childs, st)
	act.ApComp[ len( act.ApComp )-1 ].ItsJoin = append(act.ApComp[ len( act.ApComp )-1 ].ItsJoin, st)
	act.ApJoin = append(act.ApJoin, st)
	return true;
}

func (me KpJoin) GetVar(glob *GlobT, va []string, lno string) (bool, string) {
	return false, "?"
}

func (me KpJoin) DoIts(glob *GlobT, va []string, lno string) int {
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

func loadActor(act *ActT, ln string, pos int, lno string, flag []string) bool {
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
	return true;
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

func loadAll(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpAll)
	st.Me = len(act.ApAll)
	st.LineNo = lno
	st.Comp = "All";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " All has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApAll = append(act.ApAll, st)
	return true;
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

func loadDu(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpDu)
	st.Me = len(act.ApDu)
	st.LineNo = lno
	st.Comp = "Du";
	st.Flags = flag;
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Du has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApDu = append(act.ApDu, st)
	return true;
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

func loadNew(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpNew)
	st.Me = len(act.ApNew)
	st.LineNo = lno
	st.Comp = "New";
	st.Flags = flag;
	p,st.Kwhere = getw(ln,p)
	p,st.Kwhat = getw(ln,p)
	p,st.Kline = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " New has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApNew = append(act.ApNew, st)
	return true;
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

func loadRefs(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpRefs)
	st.Me = len(act.ApRefs)
	st.LineNo = lno
	st.Comp = "Refs";
	st.Flags = flag;
	p,st.Kwhere = getw(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Refs has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApRefs = append(act.ApRefs, st)
	return true;
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

func loadVar(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpVar)
	st.Me = len(act.ApVar)
	st.LineNo = lno
	st.Comp = "Var";
	st.Flags = flag;
	p,st.Kattr = getw(ln,p)
	p,st.Keq = getw(ln,p)
	p,st.Kvalue = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Var has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApVar = append(act.ApVar, st)
	return true;
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

func loadIts(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpIts)
	st.Me = len(act.ApIts)
	st.LineNo = lno
	st.Comp = "Its";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Its has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApIts = append(act.ApIts, st)
	return true;
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

func loadC(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpC)
	st.Me = len(act.ApC)
	st.LineNo = lno
	st.Comp = "C";
	st.Flags = flag;
	p,st.Kdesc = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " C has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApC = append(act.ApC, st)
	return true;
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

func loadCs(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpCs)
	st.Me = len(act.ApCs)
	st.LineNo = lno
	st.Comp = "Cs";
	st.Flags = flag;
	p,st.Kdesc = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Cs has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApCs = append(act.ApCs, st)
	return true;
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

func loadOut(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpOut)
	st.Me = len(act.ApOut)
	st.LineNo = lno
	st.Comp = "Out";
	st.Flags = flag;
	p,st.Kwhat = getw(ln,p)
	p,st.Kpad = getw(ln,p)
	p,st.Kdesc = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Out has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApOut = append(act.ApOut, st)
	return true;
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

func loadIn(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpIn)
	st.Me = len(act.ApIn)
	st.LineNo = lno
	st.Comp = "In";
	st.Flags = flag;
	p,st.Kflag = getw(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " In has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApIn = append(act.ApIn, st)
	return true;
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

func loadBreak(act *ActT, ln string, pos int, lno string, flag []string) bool {
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
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Break has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApBreak = append(act.ApBreak, st)
	return true;
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

func loadAdd(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpAdd)
	st.Me = len(act.ApAdd)
	st.LineNo = lno
	st.Comp = "Add";
	st.Flags = flag;
	p,st.Kpath = getw(ln,p)
	p,st.Kdata = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Add has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApAdd = append(act.ApAdd, st)
	return true;
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

func loadThis(act *ActT, ln string, pos int, lno string, flag []string) bool {
	p := pos
	st := new(KpThis)
	st.Me = len(act.ApThis)
	st.LineNo = lno
	st.Comp = "This";
	st.Flags = flag;
	p,st.Kpath = getw(ln,p)
	p,st.Kactor = getw(ln,p)
	p,st.Kargs = getws(ln,p)
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " This has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApThis = append(act.ApThis, st)
	return true;
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

func loadReplace(act *ActT, ln string, pos int, lno string, flag []string) bool {
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
	Kparentp = act.ApActor.length-1;
	if (Kparentp < 0 ) { 
		print(lno + " Replace has no Actor parent") ;
		return false;
	}
	act.ApActor[ len( act.ApActor )-1 ].Childs = append(act.ApActor[ len( act.ApActor )-1 ].Childs, st)
	act.ApReplace = append(act.ApReplace, st)
	return true;
}

