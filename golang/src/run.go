package main

import (
	"strconv"
)

func (me KpComp) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	if s == "star" {
		for c := 0; c < len( me.itsStar ); c++ {
			v := Goo(st.KactorP, me.itsStar[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "element" {
		for c := 0; c < len( me.itsElement ); c++ {
			v := Goo(st.KactorP, me.itsElement[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "ref" {
		for c := 0; c < len( me.itsRef ); c++ {
			v := Goo(st.KactorP, me.itsRef[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if me.KparentP >= 0 {
			if len(s2) > 0 {
				v := Def.ApComp[me.KparentP].Doo(st, s2, pos)
				return(v)
			} else {
				v := Goo(st.KactorP, Def.ApComp[me.KparentP], pos )
				return(v)
			}
		}
	}
	if s == "comp_parent" {
		for i := 0; i < len(Def.ApComp); i++ {
			if Def.ApComp[i].KparentP != me.Kme { continue }
			v := Goo( st.KactorP, Def.ApComp[i], pos )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "ref_comp" {
		for i := 0; i < len(Def.ApRef); i++ {
			if Def.ApRef[i].KcompP != me.Kme { continue }
			v := Goo( st.KactorP, Def.ApRef[i], pos )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	return(0)
}

func (me KpComp) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Comp:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Comp" ) }
	if s == "name" { return( me.Kname ) }
	if s == "nop" { return( me.Knop ) }
	if s == "parent" { return( me.Kparent ) }
	if s == "find" { return( me.Kfind ) }
	if s == "doc" { return( me.Kdoc ) }
	s1,s2 := mysplit2(s)
	if s1 == "comp_parent" {
		for i := 0; i < len(Def.ApComp); i++ {
			if Def.ApComp[i].KparentP != me.Kme { continue }
			return( Def.ApComp[i].GetVar(s2, ln) )
		}
	}
	if s1 == "ref_comp" {
		for i := 0; i < len(Def.ApRef); i++ {
			if Def.ApRef[i].KcompP != me.Kme { continue }
			return( Def.ApRef[i].GetVar(s2, ln) )
		}
	}
	if s1 == "comp_parent_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len(Def.ApComp); i++ {
			if Def.ApComp[i].KparentP != me.Kme { continue }
			v := Def.ApComp[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( Def.ApComp[i].GetVar(s5, ln) )
		}
	}
	if s1 == "ref_comp_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len(Def.ApRef); i++ {
			if Def.ApRef[i].KcompP != me.Kme { continue }
			v := Def.ApRef[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( Def.ApRef[i].GetVar(s5, ln) )
		}
	}
	if s1 == "parent" {
		if me.KparentP >= 0 {
			return( Def.ApComp[me.KparentP].GetVar(s2, ln) )
		}
	}
	if s1 == "star_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsStar); i++ {
			v:= me.itsStar[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsStar[i].GetVar(s5, ln) )
		}
	}
	if s1 == "element_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsElement); i++ {
			v:= me.itsElement[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsElement[i].GetVar(s5, ln) )
		}
	}
	if s1 == "ref_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsRef); i++ {
			v:= me.itsRef[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsRef[i].GetVar(s5, ln) )
		}
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpStar) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpStar) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Star:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Star" ) }
	if s == "doc" { return( me.Kdoc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpElement) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	if s == "ref_element" {
		for i := 0; i < len(Def.ApRef); i++ {
			if Def.ApRef[i].KelementP != me.Kme { continue }
			v := Goo( st.KactorP, Def.ApRef[i], pos )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	return(0)
}

func (me KpElement) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Element:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Element" ) }
	if s == "name" { return( me.Kname ) }
	if s == "mw" { return( me.Kmw ) }
	if s == "mw2" { return( me.Kmw2 ) }
	if s == "pad" { return( me.Kpad ) }
	if s == "doc" { return( me.Kdoc ) }
	s1,s2 := mysplit2(s)
	if s1 == "ref_element" {
		for i := 0; i < len(Def.ApRef); i++ {
			if Def.ApRef[i].KelementP != me.Kme { continue }
			return( Def.ApRef[i].GetVar(s2, ln) )
		}
	}
	if s1 == "ref_element_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len(Def.ApRef); i++ {
			if Def.ApRef[i].KelementP != me.Kme { continue }
			v := Def.ApRef[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( Def.ApRef[i].GetVar(s5, ln) )
		}
	}
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpRef) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	if s1 == "element" {
		if me.KelementP >= 0 {
			if len(s2) > 0 {
				v := Def.ApElement[me.KelementP].Doo(st, s2, pos)
				return(v)
			} else {
				v := Goo(st.KactorP, Def.ApElement[me.KelementP], pos )
				return(v)
			}
		}
	}
	if s1 == "comp" {
		if me.KcompP >= 0 {
			if len(s2) > 0 {
				v := Def.ApComp[me.KcompP].Doo(st, s2, pos)
				return(v)
			} else {
				v := Goo(st.KactorP, Def.ApComp[me.KcompP], pos )
				return(v)
			}
		}
	}
	return(0)
}

func (me KpRef) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Ref:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Ref" ) }
	if s == "element" { return( me.Kelement ) }
	if s == "comp" { return( me.Kcomp ) }
	if s == "opt" { return( me.Kopt ) }
	if s == "var" { return( me.Kvar ) }
	if s == "doc" { return( me.Kdoc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	if s1 == "element" {
		if me.KelementP >= 0 {
			return( Def.ApElement[me.KelementP].GetVar(s2, ln) )
		}
	}
	if s1 == "comp" {
		if me.KcompP >= 0 {
			return( Def.ApComp[me.KcompP].GetVar(s2, ln) )
		}
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpActor) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	if s == "d" {
		for c := 0; c < len( me.itsD ); c++ {
			v := Goo(st.KactorP, me.itsD[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "all" {
		for c := 0; c < len( me.itsAll ); c++ {
			v := Goo(st.KactorP, me.itsAll[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "du" {
		for c := 0; c < len( me.itsDu ); c++ {
			v := Goo(st.KactorP, me.itsDu[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "idu" {
		for c := 0; c < len( me.itsIdu ); c++ {
			v := Goo(st.KactorP, me.itsIdu[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "its" {
		for c := 0; c < len( me.itsIts ); c++ {
			v := Goo(st.KactorP, me.itsIts[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "iits" {
		for c := 0; c < len( me.itsIits ); c++ {
			v := Goo(st.KactorP, me.itsIits[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "c" {
		for c := 0; c < len( me.itsC ); c++ {
			v := Goo(st.KactorP, me.itsC[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "break" {
		for c := 0; c < len( me.itsBreak ); c++ {
			v := Goo(st.KactorP, me.itsBreak[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "return" {
		for c := 0; c < len( me.itsReturn ); c++ {
			v := Goo(st.KactorP, me.itsReturn[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "unique" {
		for c := 0; c < len( me.itsUnique ); c++ {
			v := Goo(st.KactorP, me.itsUnique[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "collect" {
		for c := 0; c < len( me.itsCollect ); c++ {
			v := Goo(st.KactorP, me.itsCollect[c], c )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "all_actor" {
		for i := 0; i < len(Def.ApAll); i++ {
			if Def.ApAll[i].KactorP != me.Kme { continue }
			v := Goo( st.KactorP, Def.ApAll[i], pos )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "du_actor" {
		for i := 0; i < len(Def.ApDu); i++ {
			if Def.ApDu[i].KactorP != me.Kme { continue }
			v := Goo( st.KactorP, Def.ApDu[i], pos )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	if s == "its_actor" {
		for i := 0; i < len(Def.ApIts); i++ {
			if Def.ApIts[i].KactorP != me.Kme { continue }
			v := Goo( st.KactorP, Def.ApIts[i], pos )
			if v == 0 { continue }
			if v > 0 { return(v) } // return
			return(v+1) // break
		}
	}
	return(0)
}

func (me KpActor) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Actor:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Actor" ) }
	if s == "name" { return( me.Kname ) }
	if s == "parent" { return( me.Kparent ) }
	if s == "attr" { return( me.Kattr ) }
	if s == "eq" { return( me.Keq ) }
	if s == "value" { return( me.Kvalue ) }
	if s == "cc" { return( me.Kcc ) }
	s1,s2 := mysplit2(s)
	if s1 == "all_actor" {
		for i := 0; i < len(Def.ApAll); i++ {
			if Def.ApAll[i].KactorP != me.Kme { continue }
			return( Def.ApAll[i].GetVar(s2, ln) )
		}
	}
	if s1 == "du_actor" {
		for i := 0; i < len(Def.ApDu); i++ {
			if Def.ApDu[i].KactorP != me.Kme { continue }
			return( Def.ApDu[i].GetVar(s2, ln) )
		}
	}
	if s1 == "its_actor" {
		for i := 0; i < len(Def.ApIts); i++ {
			if Def.ApIts[i].KactorP != me.Kme { continue }
			return( Def.ApIts[i].GetVar(s2, ln) )
		}
	}
	if s1 == "all_actor_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len(Def.ApAll); i++ {
			if Def.ApAll[i].KactorP != me.Kme { continue }
			v := Def.ApAll[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( Def.ApAll[i].GetVar(s5, ln) )
		}
	}
	if s1 == "du_actor_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len(Def.ApDu); i++ {
			if Def.ApDu[i].KactorP != me.Kme { continue }
			v := Def.ApDu[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( Def.ApDu[i].GetVar(s5, ln) )
		}
	}
	if s1 == "its_actor_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len(Def.ApIts); i++ {
			if Def.ApIts[i].KactorP != me.Kme { continue }
			v := Def.ApIts[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( Def.ApIts[i].GetVar(s5, ln) )
		}
	}
	if s1 == "d_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsD); i++ {
			v:= me.itsD[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsD[i].GetVar(s5, ln) )
		}
	}
	if s1 == "all_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsAll); i++ {
			v:= me.itsAll[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsAll[i].GetVar(s5, ln) )
		}
	}
	if s1 == "du_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsDu); i++ {
			v:= me.itsDu[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsDu[i].GetVar(s5, ln) )
		}
	}
	if s1 == "idu_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsIdu); i++ {
			v:= me.itsIdu[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsIdu[i].GetVar(s5, ln) )
		}
	}
	if s1 == "its_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsIts); i++ {
			v:= me.itsIts[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsIts[i].GetVar(s5, ln) )
		}
	}
	if s1 == "iits_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsIits); i++ {
			v:= me.itsIits[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsIits[i].GetVar(s5, ln) )
		}
	}
	if s1 == "c_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsC); i++ {
			v:= me.itsC[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsC[i].GetVar(s5, ln) )
		}
	}
	if s1 == "break_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsBreak); i++ {
			v:= me.itsBreak[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsBreak[i].GetVar(s5, ln) )
		}
	}
	if s1 == "return_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsReturn); i++ {
			v:= me.itsReturn[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsReturn[i].GetVar(s5, ln) )
		}
	}
	if s1 == "unique_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsUnique); i++ {
			v:= me.itsUnique[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsUnique[i].GetVar(s5, ln) )
		}
	}
	if s1 == "collect_" {
		s3,s4,s5 := mysplit3(s2)
		for i := 0; i < len( me.itsCollect); i++ {
			v:= me.itsCollect[i].GetVar(s3, ln)
			if s4 != v { continue }
			return( me.itsCollect[i].GetVar(s5, ln) )
		}
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpD) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpD) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "D:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "D" ) }
	if s == "ds" { return( me.Kds ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpAll) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	if s1 == "actor" {
		if me.KactorP >= 0 {
			if len(s2) > 0 {
				v := Def.ApActor[me.KactorP].Doo(st, s2, pos)
				return(v)
			} else {
				v := Goo(st.KactorP, Def.ApActor[me.KactorP], pos )
				return(v)
			}
		}
	}
	return(0)
}

func (me KpAll) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "All:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "All" ) }
	if s == "what" { return( me.Kwhat ) }
	if s == "actor" { return( me.Kactor ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	if s1 == "actor" {
		if me.KactorP >= 0 {
			return( Def.ApActor[me.KactorP].GetVar(s2, ln) )
		}
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpDu) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	if s1 == "actor" {
		if me.KactorP >= 0 {
			if len(s2) > 0 {
				v := Def.ApActor[me.KactorP].Doo(st, s2, pos)
				return(v)
			} else {
				v := Goo(st.KactorP, Def.ApActor[me.KactorP], pos )
				return(v)
			}
		}
	}
	return(0)
}

func (me KpDu) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Du:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Du" ) }
	if s == "actor" { return( me.Kactor ) }
	if s == "attr" { return( me.Kattr ) }
	if s == "eq" { return( me.Keq ) }
	if s == "value" { return( me.Kvalue ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	if s1 == "actor" {
		if me.KactorP >= 0 {
			return( Def.ApActor[me.KactorP].GetVar(s2, ln) )
		}
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpIdu) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpIdu) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Idu:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Idu" ) }
	if s == "attr" { return( me.Kattr ) }
	if s == "eq" { return( me.Keq ) }
	if s == "value" { return( me.Kvalue ) }
	if s == "cc" { return( me.Kcc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpIts) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	if s1 == "actor" {
		if me.KactorP >= 0 {
			if len(s2) > 0 {
				v := Def.ApActor[me.KactorP].Doo(st, s2, pos)
				return(v)
			} else {
				v := Goo(st.KactorP, Def.ApActor[me.KactorP], pos )
				return(v)
			}
		}
	}
	return(0)
}

func (me KpIts) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Its:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Its" ) }
	if s == "what" { return( me.Kwhat ) }
	if s == "actor" { return( me.Kactor ) }
	if s == "name" { return( me.Kname ) }
	if s == "op" { return( me.Kop ) }
	if s == "value" { return( me.Kvalue ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	if s1 == "actor" {
		if me.KactorP >= 0 {
			return( Def.ApActor[me.KactorP].GetVar(s2, ln) )
		}
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpIits) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpIits) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Iits:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Iits" ) }
	if s == "what" { return( me.Kwhat ) }
	if s == "cc" { return( me.Kcc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpC) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpC) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "C:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "C" ) }
	if s == "desc" { return( me.Kdesc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpBreak) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpBreak) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Break:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Break" ) }
	if s == "level" { return( strconv.Itoa(me.Klevel) ) }
	if s == "desc" { return( me.Kdesc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpReturn) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpReturn) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Return:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Return" ) }
	if s == "level" { return( strconv.Itoa(me.Klevel) ) }
	if s == "desc" { return( me.Kdesc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpUnique) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpUnique) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Unique:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Unique" ) }
	if s == "cmd" { return( me.Kcmd ) }
	if s == "key" { return( me.Kkey ) }
	if s == "cc" { return( me.Kcc ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

func (me KpCollect) Doo(st KpIts, what string, pos int) int {
	s := st.Kwhat
	if len(what) > 0 { s = what }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		if len(s2) > 0 {
			v := me.up.Doo(st, s2, pos)
			return(v)
		} else {
			v := Goo(st.KactorP, me.up, pos )
			return(v)
		}
	}
	return(0)
}

func (me KpCollect) GetVar(s string, ln string) string {
	if s == "me" { return( strconv.Itoa(me.Kme) ) }
	if s == "me_id" { return( "Collect:" + strconv.Itoa(me.Kme) ) }
	if s == "me_name" { return( "Collect" ) }
	if s == "cmd" { return( me.Kcmd ) }
	if s == "pocket" { return( me.Kpocket ) }
	if s == "key" { return( me.Kkey ) }
	s1,s2 := mysplit2(s)
	if s1 == "parent" {
		return( me.up.GetVar(s2, ln) )
	}
	return("?"+s+"?"+me.Fline+"?"+ln+"?")
}

