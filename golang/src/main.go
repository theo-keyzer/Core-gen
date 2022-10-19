
package main

import (
	"bufio"
	"fmt"
	"log"
	"os"

	"strings"
	"strconv"
)

var Act Act_t
var Def Act_t
var outfile *os.File

func main() {
	
    f, err := os.Create(os.Args[3])
    if err != nil {
        fmt.Println(err)
        f.Close()
        return
    }
    outfile = f
    
    Acts = Act
	file, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
    }
    defer file.Close()

    scanner := bufio.NewScanner(file)
    line := 1
    for scanner.Scan() {
    	Pos = 0
    	Run(scanner.Text(), os.Args[1] + ":" + strconv.Itoa(line))
    	line = line+1
    }
    Run2()
    Act = Acts
    
	Acts = Def
	files := strings.Split(os.Args[2], ",")
	for i := 0; i < len(files); i++ {
		file, err = os.Open(files[i])
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()

		scanner = bufio.NewScanner(file)
		line = 1
		for scanner.Scan() {
			Pos = 0
			Run(scanner.Text(), files[i] + ":" + strconv.Itoa(line))
			line = line+1
		}
    }
    Run2()
    Def = Acts
	uniM = make( map[string]int )
    Goo(0, nil, 0 )
}

var RunStack [] Kp
var Pocket [] Kp
var uniM map[string]int

var act_pos int
var prev_pos int

func Goo(a int, me Kp, pos int) int {
	if pos == 0 {
		act_pos = -1;
		prev_pos = -1;
	}
	name := Act.ApActor[a].Kname
	RunStack = append(RunStack, me)
	for i:= a; i < len(Act.ApActor); i++ {
		st := Act.ApActor[i]
		if name != st.Kname { continue }
		if st.Kattr != "E_O_L" {
			at := me.GetVar( st.Kattr, "" )
			if st.Keq == "=" {
				if at != st.Kvalue { continue }
			}
			if st.Keq == "!=" {
				if at == st.Kvalue { continue }
			}
			if st.Keq == "in" {
				if cin(at, st.Kvalue) { continue }
			}
			if st.Keq == "notin" {
				if cin(at, st.Kvalue) == false { continue }
			}
			if st.Keq == "has" {
				if cin(st.Kvalue, at) { continue }
			}
		}
		if pos != prev_pos {
			prev_pos = pos
			act_pos++			// for first or counter if pos is not usefull
		}
		if len(st.Kcc) > 0 {
			strs(st.Kcc, me, pos, st.Fline, st, true)
		}
		for i := 0; i < len( st.Kchilds ); i++ {
			v := st.Kchilds[i].RunAct(me, pos)
			if v == 0 { continue }
			if v > 0 { 
				RunStack = RunStack[: len( RunStack ) - 1] // defer on return
				return(v-1) 
			}
			RunStack = RunStack[: len( RunStack ) - 1] // defer on return
			return(v)
		}
	}
	RunStack = RunStack[: len( RunStack ) - 1]
	return(0)
}

func (st KpAll) RunAct(me Kp, pos int) int {
/*
	if st.Kwhat == "type" {
		for i := 0; i < len(Def.ApType); i++ {
			v := Goo(st.KactorP, Def.ApType[i], i )
 			if v == 0 { continue }
 			if v > 0 { return(v) } // return
 			return(v+1) // break
		}
	}
	if st.Kwhat == "arg_type" {
		for i := 0; i < len(Def.ApType); i++ {
			if os.Args[4] != Def.ApType[i].Kname { continue }
			v := Goo(st.KactorP, Def.ApType[i], i )
 			if v == 0 { continue }
 			if v > 0 { return(v) } // return
 			return(v+1) // break
		}
	}
*/
	if st.Kwhat == "comp" {
		for i := 0; i < len(Def.ApComp); i++ {
			v := Goo(st.KactorP, Def.ApComp[i], i )
			if v != 0 { return(v) }
		}
	}
	if st.Kwhat == "pocket" {
		for i := 0; i < len(Pocket); i++ {
			v := Goo(st.KactorP, Pocket[i], i )
			if v != 0 { return(v) }
		}
	}
	if st.Kwhat == "ref" {
		mee := me.(*KpComp)
		for i := 0; i < len(Def.ApRef); i++ {
			if mee.Kme != Def.ApRef[i].KcompP { continue }
			v := Goo(st.KactorP, Def.ApRef[i], i )
 			if v == 0 { continue }
 			if v > 0 { return(v) } // return
 			return(v+1) // break
		}
	}
	return(0)
}

func (st KpD) RunAct(me Kp, pos int) int {
	strs(st.Kds, me, pos, st.Fline, st, false)
	return( 0 )
}
func (st KpIts) RunAct(me Kp, pos int) int {
	return( me.Doo(st, "", pos) )
}

func (st KpC) RunAct(me Kp, pos int) int {
	strs(st.Kdesc, me, pos, st.Fline, st, true)
	return(0)
}

func (st KpDu) RunAct(me Kp, pos int) int {
	if st.Kattr != "E_O_L" {
		at := me.GetVar( st.Kattr, "" )
		if st.Keq == "=" {
			if at != st.Kvalue { return(0) }
		}
		if st.Keq == "!=" {
			if at == st.Kvalue { return(0) }
		}
		if st.Keq == "in" {
			if cin(at, st.Kvalue) { return(0) }
		}
		if st.Keq == "has" {
			if cin(st.Kvalue, at) { return(0) }
		}
	}
	rs := RunStack
	RunStack = RunStack[: len( RunStack ) - 1]
	v:= Goo(st.KactorP, me, pos)
	RunStack = rs
	return(v)
}

func (st KpIdu) RunAct(me Kp, pos int) int {
	if st.Kattr != "E_O_L" {
		at := ""
		if st.Kattr == "pos" {
			at = strconv.Itoa(pos)
		} else if st.Kattr == "act_pos" {
			at = strconv.Itoa(act_pos)
		} else {
			at = me.GetVar( st.Kattr, "" )
//			fmt.Print(at + "~" + st.Kattr)
		}
		if st.Keq == "=" {
			if at != st.Kvalue { return(0) }
		}
		if st.Keq == "!=" {
			if at == st.Kvalue { return(0) }
		}
		if st.Keq == "in" {
			if cin(at, st.Kvalue) { return(0) }
		}
		if st.Keq == "has" {
			if cin(st.Kvalue, at) { return(0) }
		}
		if len(st.Kcc) > 0 {
			strs(st.Kcc, me, pos, st.Fline, st, true)
		}
	}
	return(0)
}

func (st KpBreak) RunAct(me Kp, pos int) int {
	return(-st.Klevel);
}

func (st KpReturn) RunAct(me Kp, pos int) int {
	return(st.Klevel);
}

func (st KpCollect) RunAct(me Kp, pos int) int {
	if st.Kcmd == "add" {
		Pocket = append(Pocket, me)
	}
	return(0)
}

func (st KpUnique) RunAct(me Kp, pos int) int {
	if st.Kcmd == "add" {
		_, ok := uniM[ st.Kkey ]
		if ok { return(1) }
		uniM[ st.Kkey ] = 1
	}
	if st.Kcmd == "has" {
		_, ok := uniM[ st.Kkey ]
		if ok { return(0) }
		return(1)
	}
	if st.Kcmd == "delete" {
		_, ok := uniM[ st.Kkey ]
		if ok { delete(uniM, st.Kkey) }
	}
	if st.Kcmd == "clear" {
		uniM = make( map[string]int )
	}
	return(0)
}

func cin(s string, v string) bool {
	a := strings.Split(v, ",")
	for i := 0; i < len(a); i++ {
		if s == a[i] { return false }
	}
	return true
}

func strs(s string, me Kp, pos int, ln string, st Kp, isfile bool) {
	if s == "" {
		if isfile {
			fmt.Fprintln(outfile)	
		} else {
			fmt.Println()
		}
		return
	}
	me2 := me
	from := 0
	for i := 0; i < len(s); i++ {
		if s[i] != '$' { continue }
		j := i + 1
		if s[j] == '$' { 
			if isfile {
				fmt.Fprint(outfile, s[from:i])	
			} else {
				fmt.Print(s[from:i])
			}
			from = j
			i++
			continue 
		}
		if s[j] == ',' {
			v := ","
			if pos == 0 { v = "" }
			if isfile {
				fmt.Fprint(outfile, s[from:i] + v)	
			} else {
				fmt.Print(s[from:i] + v)
			}
			from = j+1
			i++
			continue 
		}
		if s[j] == 'p' {
			v := strconv.Itoa(pos)
			if isfile {
				fmt.Fprint(outfile, s[from:i] + v)	
			} else {
				fmt.Print(s[from:i] + v)
			}
			from = j+3
			i = from - 1
			continue
		}
		if s[j] == 'q' {
			v := strconv.Itoa(pos+1)
			if isfile {
				fmt.Fprint(outfile, s[from:i] + v)	
			} else {
				fmt.Print(s[from:i] + v)
			}
			from = j+3
			i = from - 1
			continue
		}
		if s[j] == 'A' {
			ss := ""
			if s[j+2] == '1' { ss = os.Args[3] }
			if s[j+2] == '2' { ss = os.Args[4] }
			if s[j+2] == '3' { ss = os.Args[5] }
			if s[j+2] == '4' { ss = os.Args[6] }
			ss = cap(ss, s[j+3])
			if isfile {
				fmt.Fprint(outfile, s[from:i] + ss)	
			} else {
				fmt.Print(s[from:i] + ss)
			}
			from = j+4
			i = from - 1
			continue
		}
		if s[j] == 'P' {
			me2 = RunStack[ len( RunStack )-2 ]
			j = j+1
		} else if s[j] == 'G' {
			me2 = RunStack[ len( RunStack )-3 ]
			j = j+1
		} else if s[j] == '&' {
			me2 = st
			j = j+1
		} else {
			me2 = me
		}
		if s[j] == '{' {
			kk := j+1
			ll := kk
			for l := kk; l < len(s); l++ {
				if s[l] == '}' { break }
				ll = l
			}
			c := s[ll+2]
			ss := me2.GetVar( s[kk:ll+1], ln )
			ss = cap(ss,c)
			if isfile {
				fmt.Fprint(outfile, s[from:i] + ss)	
			} else {
				fmt.Print(s[from:i] + ss)
			}
			from = ll+3
		}
	}
	if from <= len(s) {
		if s[ len(s)-1 ] == '\\' {
			if isfile {
				fmt.Fprint(outfile, s[from:len(s)-1])	
			} else {
				fmt.Print(s[from:len(s)-1])
			}
//			fmt.Print( s[from:len(s)-1] )
		} else {
			if isfile {
				fmt.Fprintln(outfile, s[from:len(s)])	
			} else {
				fmt.Println(s[from:len(s)])
			}
		}
	} else {
		if isfile {
			fmt.Fprintln(outfile, "")	
		} else {
			fmt.Println("")
		}
	}
}

func sub(what string, s string) string {
	n := 0
	for i := 0; i < len(s); i++ {
		if s[i] == '_' { n = i+1 } 
	}
	return s[n:len(s)]
}

func cap(s string, c byte) string {
	if c == 'l' { return lower(s) }
	if c == 'L' { return strings.ToLower(s) }
	if c == 's' { return cap_space(s) }
	if c == 'c' { return cap2(s) }
	if c == 'u' { return strings.ToUpper(s) }
	return s
}

func cap_space(s string) string {
	n := 1
	v := ""
	for i := 0; i < len(s); i++ {
		c := s[i]
		if (n == 0 && c >= 'A' && c <= 'Z') { c += 32 }
		if (n == 1 && c >= 'a' && c <= 'z') { c -= 32 }
		if (c == '_') {
			n = 1 
			v += string(' ')
			continue
		}
		n = 0
		v += string(c)
	}
	return v
}

func cap2(s string) string {
	n := 1
	v := ""
	for i := 0; i < len(s); i++ {
		c := s[i]
		if (n == 0 && c >= 'A' && c <= 'Z') { c += 32 }
		if (n == 1 && c >= 'a' && c <= 'z') { c -= 32 }
		if (c == '_' || c == '.') {
			n = 1 
			continue 
		}
		n = 0
		v += string(c)
	}
	return v
}

func lower(s string) string {
	n := 0
	v := ""
	for i := 0; i < len(s); i++ {
		c := s[i]
		if (n == 0 && c >= 'A' && c <= 'Z') { c += 32 }
		if (n == 1 && c >= 'a' && c <= 'z') { c -= 32 }
		if (c == '_') {
			n = 1 
			continue 
		}
		n = 0
		v += string(c)
	}
	return v
}


func mysplit3(s string) (string, string, string) {
	for i := 0; i < len(s); i++ {
		if s[i] == '=' { 
			a,b := mysplit2( s[i+1:len(s)] )
			return s[0:i], a,b
		}
	}
	return s, "", ""
}
func mysplit2(s string) (string, string) {
	for i := 0; i < len(s); i++ {
		if s[i] == '.' { 
			return s[0:i], s[i+1:len(s)]
		}
	}
	return s, ""
}

func mysplit(s string) (string, string) {
	a := "oioioioi"
	p := 0
	for i := 0; i < len(s); i++ {
		if s[i] == '.' { 
			a = s[0:i]
			break
		}
		p = i
	}
	return a, s[p:len(s)]
}

var Pos int
var from int
var to int

func getw(s string) string {
	l := len(s)
	if (Pos+1) > l {
		return("E_O_L")
	}
	from = Pos
	for i := Pos; i < l; i++ {
		if s[i] == ' ' || s[i] == '\t' {
			continue
		}
		from = i
		break
	}
	to = from
	for j := from; j < l; j++ {
		if s[j] == ' ' || s[j] == '\t' {
			break
		}
		to = j		
	}
	Pos = to+1
	if to < l { to = to + 1 }
	return( s[from:to] )
}

func getws(s string) string {
	l := len(s)
	if (Pos+1) > l {
		return("")
	}
	return( s[Pos+1:l] )
}

// pass type as index
/*
func find_type_attr(s string, opt string, typs string, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	t := find_type(typs, opt, ln)
	if t < 0 { return(-1) }
	typ := Acts.ApType[t]
	for i:= 0; i < len( typ.itsAttr ); i++ {
		if s == typ.itsAttr[i].Kname { 
			return( typ.itsAttr[i].Kme ) 
		}
	}
 	if opt == "check" {
 		fmt.Println(s + " not found " + ln)
 	}
 	return(-1)
}
func find__attr(s string, opt string, typ *KpType, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	for i:= 0; i < len( typ.itsAttr ); i++ {
		if s == typ.itsAttr[i].Kname { 
			return( typ.itsAttr[i].Kme ) 
		}
	}
 	if opt == "check" {
 		fmt.Println(s + " not found " + ln)
 	}
 	return(-1)
}
*/
func find__element(s string, opt string, comp *KpComp, ln string) int {
	if s == "." {
		 	if opt != "check" { return(-1) }
	}
	for i:= 0; i < len( comp.itsElement ); i++ {
		if s == comp.itsElement[i].Kname { 
			return( comp.itsElement[i].Kme ) 
		}
	}
 	if opt == "check" {
 		fmt.Println(s + " not found " + ln)
 	}
	return(-1)
}

