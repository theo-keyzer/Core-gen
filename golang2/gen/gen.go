package main

import (
	"fmt"
//	"os"
	"regexp"
	"strings"
)

//type ActT struct {
//	index       map[string]int
//}


// WinT represents window state
type WinT struct {
	Name      string
	Cnt       int
	Dat       interface{}
	Arg       string
	Flno      string
	DataKey   string
	DataType  string
	CurAct    int
	CurPos    int
	OnPos     int
	BrkAct    bool
	IsOn      bool
	IsTrig    bool
	IsPrev    bool
	IsCheck   bool
}


// NewAct creates a new action
func NewAct(glob *GlobT, actn string, arg string, flno string) {
//	fmt.Println("NEW")
	winp := glob.Winp + 1
	if len(glob.Wins) <= winp {
		glob.Wins = append(glob.Wins, WinT{})
	}
	glob.Wins[winp].Name = actn
	glob.Wins[winp].DataKey = ""
	glob.Wins[winp].DataType = ""
	glob.Wins[winp].Cnt = -1
	glob.Wins[winp].Arg = arg
	glob.Wins[winp].Flno = flno
	glob.Wins[winp].BrkAct = false

	if winp == 0 {
		return
	}

	if glob.Wins[winp-1].IsOn || glob.Wins[winp-1].IsPrev {
		if !glob.Wins[winp-1].IsTrig {
			glob.Wins[winp].IsPrev = true
		}
	}
}

// GoAct processes an action
func GoAct(glob *GlobT, dat interface{}) int {
	winp := glob.Winp + 1
	glob.Winp = winp
	glob.Wins[winp].Dat = dat
	name := glob.Wins[winp].Name
	prev := false
	incCnt := true

	for i := 0; i < len(glob.Acts.ApActor); i++ {
		if glob.Acts.ApActor[i].Kname != name {
			continue
		}

		act := glob.Acts.ApActor[i]
		if act.Kattr != "E_O_L" {
			valOk, val := Strs(glob, winp, act.Kvalue, act.LineNo, false, false)
			sc := strings.Split(act.Kattr, ":")
			va := strings.Split(sc[0], ".")
			varOk, varv := SGetVar(glob, winp, sc, va, act.LineNo)
			if !Chk(glob, act.Keq, varv, val, prev, varOk, valOk, act.LineNo) {
				prev = false
				continue
			}
		}

		prev = true
		glob.Wins[winp].CurAct = i
		if incCnt {
			incCnt = false
			glob.Wins[winp].Cnt++
		}

		ret := GoCmds(glob, i, winp)
		if ret == 0 || ret == 3 {
			continue
		}

		nret := ret
		if ret == 2 {
			nret = 0
		}
		if ret < 0 && glob.Wins[glob.Winp].BrkAct {
			nret = -ret
		}
		glob.Winp--
		return nret
	}

	glob.Winp = winp - 1
	return 0
}

// GoCmds processes commands
func GoCmds(glob *GlobT, ca int, winp int) int {
//	fmt.Println("cmd")
	glob.Wins[winp].IsOn = false
	glob.Wins[winp].IsTrig = false
	glob.Wins[winp].IsCheck = false
	a := glob.Acts.ApActor[ca]

	for i := 0; i < len(a.Childs); i++ {
		glob.Wins[winp].CurPos = i

		cmd := a.Childs[i]
		switch v := cmd.(type) {
/*		
		case *KpIn:
			if v.KFlag == "on" {
				glob.InOn = true
			}
			if v.KFlag == "off" {
				glob.InOn = false
			}
			if contains(v.Flags, "clear") {
				glob.Ins.Reset()
			}
*/
		case *KpC:
//			if !glob.OutOn {
//				continue
//			}
//			if glob.Wins[winp].IsOn && !glob.Wins[winp].IsTrig {
//				continue
//			}
//			Trig(glob, winp)

			kDesc := v.Kdesc
//			if contains(v.Flags, "r") {
//				kDesc = v.KDesc
//			} else {
				_, res := Strs(glob, winp, v.Kdesc, v.LineNo, false, true)
				kDesc = res
//			}
//	fmt.Println(kDesc)

			if glob.InOn {
				fmt.Fprintln(&glob.Ins, kDesc)
			} else {
				fmt.Println(kDesc)
			}
/*
		case *KpCs:
			if !glob.OutOn {
				continue
			}
			if glob.Wins[winp].IsOn && !glob.Wins[winp].IsTrig {
				continue
			}
			Trig(glob, winp)
			_, res := Strs(glob, winp, v.KDesc, v.LineNo, false, true)
			if glob.InOn {
				glob.Ins.WriteString(res)
			} else {
				fmt.Print(res)
			}
*/
		case *KpAll:
			_, args := Strs(glob, winp, v.Kargs, v.LineNo, true, true)
			NewAct(glob, v.Kactor, args, v.LineNo)
			_, what := Strs(glob, winp, v.Kwhat, v.LineNo, true, true)
			va := strings.Split(what, ".")
			ret := DoAll(glob, va, v.LineNo)
			if ret > 1 || ret < 0 {
				return ret
			}
/*
		case *KpThis:
			_, args := Strs(glob, winp, v.KArgs, v.LineNo, true, true)
			NewAct(glob, v.KActor, args, v.LineNo)
			ret := ThisCmd(glob, winp, v, v.LineNo)
			if ret > 1 || ret < 0 {
				return ret
			}

		case *KpAdd:
			ret := AddCmd(glob, winp, v, v.LineNo)
			if ret != 0 {
				return ret
			}

		case *KpReplace:
			ret := ReplaceCmd(glob, winp, v, v.LineNo)
			if ret != 0 {
				return ret
			}
*/
		case *KpDu:
			_, args := Strs(glob, winp, v.Kargs, v.LineNo, true, true)
			NewAct(glob, v.Kactor, args, v.LineNo)
			ret := GoAct(glob, glob.Wins[winp].Dat)
			if ret != 0 {
				return ret
			}

		case *KpIts:
			_, args := Strs(glob, winp, v.Kargs, v.LineNo, true, true)
			NewAct(glob, v.Kactor, args, v.LineNo)
			va := strings.Split(v.Kwhat, ".")
			if len(va[0]) == 0 && len(va) > 1 {
				for i := winp - 1; i >= 0; i-- {
					if glob.Wins[i].Name == va[1] {
						dat := glob.Wins[i].Dat.(Doer) // Using interface for do_its
						ret := dat.DoIts(glob, va[2:], v.LineNo)
						if ret > 1 || ret < 0 {
							return ret
						}
						break
					}
				}
				continue
			}
			dat := glob.Wins[winp].Dat.(Doer)
			ret := dat.DoIts(glob, va, v.LineNo)
			if ret > 1 || ret < 0 {
				return ret
			}

		case *KpBreak:
			if v.Kcheck == "True" && !glob.Wins[winp].IsCheck {
				continue
			}
			if v.Kcheck == "False" && glob.Wins[winp].IsCheck {
				continue
			}
			ret := 0
			if v.Kwhat == "E_O_L" || v.Kwhat == "actor" {
				ret = 2
			}
			if v.Kwhat == "loop" {
				ret = 1
			}
			if v.Kwhat == "cmds" {
				ret = 3
			}
			if v.Kactor != "E_O_L" && v.Kactor != "." {
				for i := winp - 1; i >= 0; i-- {
					if glob.Wins[i].Name == v.Kactor {
						glob.Wins[i+1].BrkAct = true
						ret = -ret
						break
					}
				}
			}
			return ret
/*
		case *KpVar:
			res := Strs(glob, winp, v.KValue, v.LineNo, true, true)
			va := strings.Split(v.KAttr, ".")
			if va[0] == "" && len(va) > 2 {
				for i := winp - 1; i >= 0; i-- {
					if glob.Wins[i].Name == va[1] {
						dat := glob.Wins[i].Dat.(NameSetter)
						dat.SetName(va[2], res[1])
						break
					}
				}
				continue
			}
			dat := glob.Wins[winp].Dat.(NameSetter)
			dat.SetName(v.KAttr, res[1])

		case *KpOut:
			res := Strs(glob, winp, v.KWhat, v.LineNo, true, true)
			kWhat := res[1]
			switch kWhat {
			case "on":
				glob.OutOn = true
			case "off":
				glob.OutOn = false
			case "delay":
				glob.Wins[winp].IsOn = true
				glob.Wins[winp].OnPos = i
			case "normal":
				glob.Wins[winp].IsOn = false
				glob.Wins[winp].IsTrig = false
			}

		case *KpNew:
			if !glob.OutOn {
				continue
			}
			if glob.Wins[winp].IsOn && !glob.Wins[winp].IsTrig {
				continue
			}
			Trig(glob, winp)
			line := Strs(glob, winp, " "+v.KLine, v.LineNo, true, true)
			glob.LoadErrs = glob.LoadErrs || Load(&glob.Dats, v.KWhat, line[1], 0, "23")

		case *KpRefs:
			glob.LoadErrs = glob.LoadErrs || Refs(&glob.Dats)
		*/	
		}
		
	}
	return 0
}

// Interfaces for type assertions
type Doer interface {
	DoIts(glob *GlobT, va []string, lineNo string) int
}

type NameSetter interface {
	SetName(key, value string)
}

// Helper functions
func contains(slice []string, item string) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}

// Trig handles trigger logic
func Trig(glob *GlobT, winp int) {
	if !glob.Wins[winp].IsPrev || winp == 0 {
		return
	}
	glob.Wins[winp].IsPrev = false
	prev := winp - 1
	if !glob.Wins[prev].IsOn && !glob.Wins[prev].IsPrev {
		return
	}
	if glob.Wins[prev].IsTrig {
		return
	}
	glob.Wins[prev].IsTrig = true

	ReGoCmds(glob, prev)
}
func ReGoCmds(glob *GlobT, winp int) {
}

// StrResult represents the result of string operations
type StrResult struct {
	Ok  bool
	Val string
}

// Strs handles string template processing and variable substitution
func Strs(glob *GlobT, winp int, ss string, lno string, prErr bool, isErr bool) (bool,string) {
	// Early return for empty string
	if ss == "" {
		return true, ""
	}

	var result strings.Builder
	runes := []rune(ss)
	l := len(runes)
	ok := true
	pos := 0
	dp := -3  // dollar position
	bp := -3  // brace position

	for i := 0; i < l; i++ {
		if runes[i] == '$' {
			if i == dp+1 {
				// Handle escaped dollar sign
				result.WriteString(string(runes[pos:i]))
				pos = i + 1
				continue
			}
			dp = i
		}

		if runes[i] == '{' {
			if i == dp+1 {
				if i > 1 {
					result.WriteString(string(runes[pos : i-1]))
				}
				pos = i
				bp = i
			}
		}

		if runes[i] == '}' {
			if bp > 0 {
				// Extract variable expression
				varExpr := string(runes[bp+1 : i])
				
				// Split into components
				sc := strings.Split(varExpr, ":")
				va := strings.Split(sc[0], ".")

				// Get variable value
				okr,res := SGetVar(glob, winp, sc, va, lno)
				
				if okr == false{
					ok = false
					if prErr {
						fmt.Println(res)
					}
					if isErr {
						glob.RunErrs += 1
					}
				}

				result.WriteString(res)
				pos = i + 1
				dp = -3
				bp = -3
			}
		}
	}

	// Append remaining string
	if pos < l {
		result.WriteString(string(runes[pos:]))
	}

	return ok, result.String()
}

// SGetVar gets a variable value, handling various special cases
func SGetVar(glob *GlobT, winp int, sc []string, va []string, lno string) (bool, string) {
	// Special case for whitespace indentation
	if len(va) == 1 && len(va[0]) > 0 {
		if firstChar := va[0][0]; firstChar == ' ' || firstChar == '\t' {
			var indent strings.Builder
			for i := 0; i < winp; i++ {
				indent.WriteString(va[0])
			}
			return true, indent.String()
		}
	}

	// Handle non-empty variable name
	if len(va[0]) > 0 {
		return GetVarFromData(glob.Wins[winp].Dat, glob, va, lno)
	}

	// Handle special variables
	if len(va) == 1 {
//		return true, fmt.Sprintf("%s, %s", glob.Wins[winp].Dat.GetLineNo(), lno)
		return true, fmt.Sprintf("%s, %s", "", lno)
	}

	switch va[1] {
	case "arg":
		return true, glob.Wins[winp].Arg
	case "depth":
		return true, fmt.Sprintf("%d", winp)
	case "+":
		return true, fmt.Sprintf("%d", glob.Wins[winp].Cnt+1)
	case "-":
		return true, fmt.Sprintf("%d", glob.Wins[winp].Cnt)
	case "0":
		if glob.Wins[winp].Cnt != 0 {
			return true, ""
		}
		if len(va) >= 3 {
			return true, va[2]
		}
	case "1":
		if glob.Wins[winp].Cnt == 0 {
			return true, ""
		}
		if len(va) >= 3 {
			return true, va[2]
		}
	}

	// Look up variable in previous windows
	for i := winp - 1; i >= 0; i-- {
		if glob.Wins[i].Name == va[1] {
			return SGetVar(glob, i, []string{}, va[2:], lno)
		}
	}

	// Check pocket variables
	if st, ok := glob.Collect[va[1]]; ok {
		return GetVarFromData(st, glob, va[2:], lno)
	}

	// Try variable alternatives
//	return VarAll(glob, va[1:], lno)
	return false, "var all"
}

// CmdVar handles variable transformations based on command modifiers
func CmdVar(glob *GlobT, sc []string, varv string, lcnt int) (bool, string) {
	result := varv

	// Apply modifiers in sequence
	for i := 1; i < len(sc); i++ {
		switch sc[i] {
		case "u":
			result = strings.ToUpper(result)
		case "l":
			result = strings.ToLower(result)
		case "c":
			if len(result) > 0 {
				result = strings.ToUpper(result[:1]) + result[1:]
			}
		}
	}

	return true, result
}

// GetVarFromData is a helper function to get variable from data object
func GetVarFromData(data interface{}, glob *GlobT, va []string, lno string) (bool, string) {
//	if getter, ok := data.(VariableGetter); ok {
	if getter, ok := data.(Kp); ok {
		return getter.GetVar(glob, va, lno)
	}
//fmt.Println(data)
	return false, fmt.Sprintf("?%s?%s?", va[0], lno)
}

// VariableGetter interface for objects that can provide variable values
type VariableGetter interface {
	GetVar(glob *GlobT, va []string, lno string) (bool,string)
}

// Previous code remains the same...

// chk performs various comparison operations based on the equality operator
func Chk(glob *GlobT, eqa string, v string, ss string, prev bool, attrOk bool, valOk bool, lno string) bool {
	eq := eqa
	// Special case for "??" operator
	if eq == "??" {
		if !attrOk || !valOk {
			return true
		}
		return false
	}

	// Handle "?" prefix
	if strings.HasPrefix(eq, "?") {
		if !attrOk || !valOk {
			return false
		}
		if len(eq) == 1 {
			return true
		}
		eq = eq[1:]
	}

	// Handle "&" prefix (AND operation)
	if strings.HasPrefix(eq, "&") {
		if !prev {
			return false
		}
		eq = eq[1:]
	}

	// Handle "|" prefix (OR operation)
	if strings.HasPrefix(eq, "|") {
		if prev {
			return true
		}
		eq = eq[1:]
	}

	// Check for attribute and value validity
	if !attrOk {
		glob.RunErrs += 1
		fmt.Println(v)
		return false
	}
	if !valOk {
		glob.RunErrs += 1
		fmt.Println(ss)
		return false
	}

	// Handle different comparison operators
	switch eq {
	case "=":
		return v == ss
	case "!=":
		return v != ss
	case "in":
		values := strings.Split(ss, ",")
		for _, val := range values {
			if val == v {
				return true
			}
		}
		return false
	case "!in":
		values := strings.Split(ss, ",")
		for _, val := range values {
			if val == v {
				return false
			}
		}
		return true
	case "has":
		values := strings.Split(v, ",")
		for _, val := range values {
			if val == ss {
				return true
			}
		}
		return false
	case "regex":
		rx, err := regexp.Compile(ss)
		if err != nil {
			glob.RunErrs += 1
			fmt.Printf("Invalid regex pattern: %v\n", err)
			return false
		}
		return rx.MatchString(v)
	}

	return false
}

// Additional utility functions would go here...
