package main

import (
	"strings"
	"fmt"
	"strconv"
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

func refs(act *ActT) int {
	errs := 0
	v := ""
	res := 0
	err := false
	for _, st := range act.ApComp {
		v, _ = st.Names["parent"]
		err, res = fnd(act, "Comp_" + v , "parent",  ".", st.LineNo );
		st.Kparentp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRef {
		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element",  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v , "comp",  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRef2 {
		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element",  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v , "comp",  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["element2"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element2",  "check", st.LineNo );
		st.Kelement2p = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRef3 {
		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element",  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v , "comp",  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["element2"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element2",  "check", st.LineNo );
		st.Kelement2p = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp_ref"]
		err, res = fnd(act, "Comp_" + v , "comp_ref",  "check", st.LineNo );
		st.Kcomp_refp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRefq {
		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element",  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v , "comp",  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp_ref"]
		err, res = fnd(act, "Comp_" + v , "comp_ref",  "check", st.LineNo );
		st.Kcomp_refp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApRefu {
		v, _ = st.Names["element"]
		err, res = fnd(act, strconv.Itoa(st.Kparentp) + "_Element_" + v , "element",  "check", st.LineNo );
		st.Kelementp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp"]
		err, res = fnd(act, "Comp_" + v , "comp",  "check", st.LineNo );
		st.Kcompp = res
		if (err == false) {
			errs += 1
		}
		v, _ = st.Names["comp_ref"]
		err, res = fnd(act, "Comp_" + v , "comp_ref",  "check", st.LineNo );
		st.Kcomp_refp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApAll {
		err, res = fnd(act, "Actor_" + st.Kactor , "actor",  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApDu {
		err, res = fnd(act, "Actor_" + st.Kactor , "actor",  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApIts {
		err, res = fnd(act, "Actor_" + st.Kactor , "actor",  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	for _, st := range act.ApThis {
		err, res = fnd(act, "Actor_" + st.Kactor , "actor",  ".", st.LineNo );
		st.Kactorp = res
		if (err == false) {
			errs += 1
		}
	}
	return(errs)
}

func DoAll(glob *GlobT, va []string, lno string) int {
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
	fmt.Sprintf("?No all %s cmd ?%s?", va[0], lno);
	return 0;
}

func Load(act *ActT, toks string, ln string, pos int, lno string) int {
	errs := 0
	ss := strings.Split(toks,".")
	tok := ss[0]
	flag := ss[1:]
	if tok == "Comp" { errs += loadComp(act,ln,pos,lno,flag) }
	if tok == "Element" { errs += loadElement(act,ln,pos,lno,flag) }
	if tok == "Opt" { errs += loadOpt(act,ln,pos,lno,flag) }
	if tok == "Ref" { errs += loadRef(act,ln,pos,lno,flag) }
	if tok == "Ref2" { errs += loadRef2(act,ln,pos,lno,flag) }
	if tok == "Ref3" { errs += loadRef3(act,ln,pos,lno,flag) }
	if tok == "Refq" { errs += loadRefq(act,ln,pos,lno,flag) }
	if tok == "Refu" { errs += loadRefu(act,ln,pos,lno,flag) }
	if tok == "Join" { errs += loadJoin(act,ln,pos,lno,flag) }
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
	return errs
}

