package main

import (
//	"database/sql"
	"fmt"
//	"os"
	"regexp"
	"strconv"
	"strings"
	"slices"
)
/*
type GlobT struct {
	LoadErrs bool
	RunErrs  bool
	Acts     *ActT
	Dats     *ActT
	Winp     int
	Wins     []*WinT
	Collect  map[string]interface{}
	OutOn    bool
	InOn     bool
	Ins      strings.Builder
	Conn     *sql.DB
	IsConn   bool
}
*/
type WinT struct {
	Name     string
	Cnt      int
	Dat      interface{}
	Arg      string
	Flno     string
	DataKeys []string
	DataKey  string
	DataType string
	CurAct   int
	CurPos   int
	OnPos    int
	BrkAct   bool
	IsOn     bool
	IsTrig   bool
	IsPrev   bool
	IsCheck  bool
}

func NewAct(glob *GlobT, actn, arg, flno string) {
	winp := glob.Winp + 1
	if len(glob.Wins) <= winp {
		glob.Wins = append(glob.Wins, WinT{})
	}
	
	glob.Wins[winp].Name = actn
	glob.Wins[winp].DataKeys = []string{}
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

func GoAct(glob *GlobT, dat interface{}) (int) {
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
			valOk, val := strs(glob, winp, act.Kvalue, act.LineNo, false, false)
			_, kAttr := strs(glob, winp, act.Kattr, act.LineNo, true, true)
			sc := strings.Split(kAttr, ":")
			va := strings.Split(sc[0], ".")
			varOk, varv := sGetVar(glob, winp, sc, va, act.LineNo)
			
			if !chk(glob, act.Keq, varv, val, prev, varOk, valOk, act.LineNo) {
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
		
		ret := goCmds(glob, i, winp)
		
		if ret == -4 {
			return ret
		}
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

func goCmds(glob *GlobT, ca, winp int) (int) {
	glob.Wins[winp].IsOn = false
	glob.Wins[winp].IsTrig = false
	glob.Wins[winp].IsCheck = false
	
	a := glob.Acts.ApActor[ca]
	for i := 0; i < len(a.Childs); i++ {
		glob.Wins[winp].CurPos = i
		cmd := a.Childs[i]
		
		// Handle different command types
		switch c := cmd.(type) {
		case *KpIn:
			if c.Kflag == "on" {
				glob.InOn = true
			}
			if c.Kflag == "off" {
				glob.InOn = false
			}
			if slices.Contains(c.Flags, "clear") {
				glob.Ins.Reset()
			}
			
		case *KpC:
//			fmt.Println(c.Kdesc)
			if !glob.OutOn {
				continue
			}
			if glob.Wins[winp].IsOn && !glob.Wins[winp].IsTrig {
				continue
			}
			trig(glob, winp)
			
			kDesc := c.Kdesc
			if !slices.Contains(c.Flags, "r") {
				_, res := strs(glob, winp, c.Kdesc, c.LineNo, false, true)
				kDesc = res
			}
//			fmt.Println(kDesc)
			
			if glob.InOn {
				glob.Ins.WriteString(kDesc + "\n")
			} else {
				fmt.Println(kDesc)
			}
			
		case *KpCs:
			if !glob.OutOn {
				continue
			}
			if glob.Wins[winp].IsOn && !glob.Wins[winp].IsTrig {
				continue
			}
			trig(glob, winp)
			
			_, res := strs(glob, winp, c.Kdesc, c.LineNo, false, true)
				if glob.InOn {
					glob.Ins.WriteString(res)
				} else {
					fmt.Print(res)
				}
			
			
		case *KpAll:
			_, args := strs(glob, winp, c.Kargs, c.LineNo, true, true)
			NewAct(glob, c.Kactor, args, c.LineNo)
			
			_, what := strs(glob, winp, c.Kwhat, c.LineNo, true, true)
			va := strings.Split(what, ".")
			ret := DoAll(glob, va, c.LineNo)
			if  ret > 1 || ret < 0 {
				return ret
			}
			
		case *KpThis:
			_, args := strs(glob, winp, c.Kargs, c.LineNo, true, true)
			NewAct(glob, c.Kactor, args, c.LineNo)
			ret := thisCmd(glob, winp, c, c.LineNo)
			if  ret > 1 || ret < 0 {
				return ret
			}
			
		case *KpAdd:
			ret := addCmd(glob, winp, c, c.LineNo, "")
			if  ret != 0 {
				return ret
			}
/*			
		case *KpHttp:
			ret, err := httpCmd(glob, winp, c, c.LineNo)
			if  ret != 0 {
				return ret
			}
			
		case *KpDbconn:
			ret := dbconnCmd(glob, winp, c, c.LineNo)
			if  ret != 0 {
				return ret
			}
*/			
		case *KpReplace:
			ret := replaceCmd(glob, winp, c, c.LineNo)
			if ret != 0 {
				return ret
			}
			
		case *KpDu:
			_, args := strs(glob, winp, c.Kargs, c.LineNo, true, true)
			NewAct(glob, c.Kactor, args, c.LineNo)
			glob.Wins[winp+1].Cnt = glob.Wins[winp].Cnt
			glob.Wins[winp+1].DataKey = glob.Wins[winp].DataKey
			glob.Wins[winp+1].DataType = glob.Wins[winp].DataType
			glob.Wins[winp+1].DataKeys = glob.Wins[winp].DataKeys
			ret := GoAct(glob, glob.Wins[winp].Dat)
			if ret != 0 {
				return ret
			}
			
		case *KpIts:
			_, args := strs(glob, winp, c.Kargs, c.LineNo, true, true)
			NewAct(glob, c.Kactor, args, c.LineNo)
			va := strings.Split(c.Kwhat, ".")
			
			if len(va[0]) == 0 && len(va) > 1 {
				for i := winp - 1; i >= 0; i-- {
					if glob.Wins[i].Name == va[1] {
						if kp, ok := glob.Wins[i].Dat.(Kp); ok {
							ret := kp.DoIts(glob, va[2:], c.LineNo)
							if  ret > 1 || ret < 0 {
								return ret
							}
						}
						break
					}
				}
				continue
			}
			
			if kp, ok := glob.Wins[winp].Dat.(Kp); ok {
				ret := kp.DoIts(glob, va, c.LineNo)
				if  ret > 1 || ret < 0 {
					return ret
				}
			}
			
		case *KpBreak:
			if c.Kcheck == "True" && !glob.Wins[winp].IsCheck {
				continue
			}
			if c.Kcheck == "False" && glob.Wins[winp].IsCheck {
				continue
			}
			
			ret := 0
			if c.Kwhat == "E_O_L" || c.Kwhat == "actor" {
				ret = 2
			}
			if c.Kwhat == "loop" {
				ret = 1
			}
			if c.Kwhat == "cmds" {
				ret = 3
			}
			if c.Kwhat == "exit" {
				if glob.LoadErrs > 0 || glob.RunErrs > 0 {
					return -4
				}
			}
			
			if c.Kactor != "E_O_L" && c.Kactor != "." {
				for i := winp - 1; i >= 0; i-- {
					if glob.Wins[i].Name == c.Kactor {
						glob.Wins[i+1].BrkAct = true
						ret = -ret
						break
					}
				}
			}
			return ret
/*			
		case *KpVar:
			_, res := strs(glob, winp, c.Kvalue, c.LineNo, true, true)
			va := strings.Split(c.Kattr, ".")
			if va[0] == "" && len(va) > 2 {
				for i := winp - 1; i >= 0; i-- {
					if glob.Wins[i].Name == va[1] {
						if kp, ok := glob.Wins[i].Dat.(Kp); ok {
							kp.SetName(va[2], res[1].(string))
						}
						break
					}
				}
				continue
			}
			if kp, ok := glob.Wins[winp].Dat.(Kp); ok {
				kp.SetName(c.KAttr, res[1].(string))
			}
*/			
		case *KpOut:
			_, res := strs(glob, winp, c.Kwhat, c.LineNo, true, true)
			kwhat := res
			
			if kwhat == "on" {
				glob.OutOn = true
			}
			if kwhat == "off" {
				glob.OutOn = false
			}
			if kwhat == "delay" {
				glob.Wins[winp].IsOn = true
				glob.Wins[winp].OnPos = i
			}
			if kwhat == "normal" {
				glob.Wins[winp].IsOn = false
				glob.Wins[winp].IsTrig = false
			}
/*			
		case *KpNew:
			if !glob.OutOn {
				continue
			}
			if glob.Wins[winp].IsOn && !glob.Wins[winp].IsTrig {
				continue
			}
			trig(glob, winp)
			
			_, line := strs(glob, winp, " "+c.KLine, c.LineNo, true, true)
			if err == nil {
				glob.LoadErrs = glob.LoadErrs || load(glob.Dats, c.KWhat, line[1].(string), 0, "23")
			}
			
		case *KpRefs:
			glob.LoadErrs = glob.LoadErrs || refs(glob.Dats)
*/
		}
		
	}
	
	return 0
}

func trig(glob *GlobT, winp int) {
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
	
	reGoCmds(glob, prev)
}

func reGoCmds(glob *GlobT, winp int) {
	trig(glob, winp)
	a := glob.Acts.ApActor[glob.Wins[winp].CurAct]
	
	for i := glob.Wins[winp].OnPos; i < glob.Wins[winp].CurPos; i++ {
		cmd := a.Childs[i]
		
		switch c := cmd.(type) {
		case *KpC:
			_, res := strs(glob, winp, c.Kdesc, c.LineNo, false, true)
				fmt.Println(res)
		case *KpCs:
			_, res := strs(glob, winp, c.Kdesc, c.LineNo, false, true)
				fmt.Print(res)
/*
		case *KpNew:
			_, line := strs(glob, winp, " "+c.KLine, c.LineNo, true, true)
			if err == nil {
				glob.LoadErrs = glob.LoadErrs || load(glob.Dats, c.KWhat, line[1].(string), 0, "23")
			}
*/
		}
	}
}

func cmdVar(glob *GlobT, sc []string, varv interface{}, lcnt int) (bool, string) {
	dat := varv
	
	for i := 1; i < len(sc); i++ {
		if sc[i] == "join" {
			if slice, ok := dat.([]interface{}); ok {
				if len(slice) == 0 {
					dat = ""
					continue
				}
				result := fmt.Sprintf("%v", slice[0])
				for j := 1; j < len(slice); j++ {
					result += "," + fmt.Sprintf("%v", slice[j])
				}
				dat = result
				continue
			}
		}
		
		if slice, ok := dat.([]interface{}); ok {
			if idx, err := strconv.Atoi(sc[i]); err == nil {
				if idx >= 0 && idx < len(slice) {
					dat = slice[idx]
				}
			}
		}
		
		if str, ok := dat.(string); ok {
			switch sc[i] {
			case "u":
				dat = strings.ToUpper(str)
			case "l":
				dat = strings.ToLower(str)
			case "c":
				if len(str) > 0 {
					dat = strings.ToUpper(str[:1]) + strings.ToLower(str[1:])
				}
			case "eol":
				if str == "E_O_L" {
					dat = ""
				}
			}
		}
	}
	
	return true, fmt.Sprintf("%v", dat)
}

func sGetVar(glob *GlobT, winp int, sc []string, va []string, lno string) (bool, string) {
	path := va
	rec := getPath(glob, winp, path, lno)
	if !rec.Ok {
		return false, rec.Dat.(string)
	}
	
	dat := rec.Dat
//	kp3, ok3 := dat.(Kp)
//	fmt.Println(ok3,kp3,dat,glob.Wins[winp].Dat)
	if _, ok := dat.(Kp); !ok && len(rec.Path) > 0 && rec.Path[0] != "." && rec.Path[0] != "" {
//	fmt.Println("xx")
		return false, fmt.Sprintf("?%s?%s?", rec.Path[0], lno)
	}
	
	if kp, ok := dat.(Kp); ok && len(rec.Path) > 0 && rec.Path[0] != "." {
		resOk, res := kp.GetVar(glob, rec.Path, lno)
		if !resOk {
			return resOk, res
		}
		dat = res
	}
	
	return cmdVar(glob, sc, dat, 3)
}

func strs(glob *GlobT, winp int, ss interface{}, lno string, prErr, isErr bool) (bool,string) {
	s := fmt.Sprintf("%v", ss)
	ok := true
	ret := ""
	pos := 0
	dp := -3
	bp := -3
	
	runes := []rune(s)
	l := len(runes)
	
	for i := 0; i < l; i++ {
		if runes[i] == '$' {
			if i == dp+1 {
				ret += string(runes[pos:i])
				pos = i + 1
				continue
			}
			dp = i
		}
		
		if runes[i] == '{' {
			if i == (dp + 1) {
				if i > 1 {
					ret += string(runes[pos : i-1])
				}
				pos = i
				bp = i
			}
		}
		
		if runes[i] == '}' {
			if bp > 0 {
				sc := strings.Split(string(runes[bp+1:i]), ":")
				va := strings.Split(sc[0], ".")
				resOk, res := sGetVar(glob, winp, sc, va, lno)
				if !resOk {
					ok = false
					if prErr {
						fmt.Println(res)
					}
					if isErr {
						glob.RunErrs += 1
					}
				}
				ret += fmt.Sprintf("%v", res)
				pos = i + 1
				dp = -3
				bp = -3
			}
		}
	}
	
	if pos < l {
		ret += string(runes[pos:l])
	}
	
	return ok, ret
}

func chk(glob *GlobT, eqa string, v, ss interface{}, prev, attrOk, valOk bool, lno string) bool {
	eq := eqa
	
	if eq == "??" {
		if !attrOk {
			return true
		}
		if !valOk {
			return true
		}
		return false
	}
	
	if len(eq) > 0 && eq[0] == '?' {
		if !attrOk || !valOk {
			return false
		}
		if len(eq) == 1 {
			return true
		}
		eq = eq[1:]
	}
	
	if len(eq) > 0 && eq[0] == '&' {
		if !prev {
			return false
		}
		eq = eq[1:]
	}
	
	if len(eq) > 0 && eq[0] == '|' {
		if prev {
			return true
		}
		eq = eq[1:]
	}
	
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
	
	vStr := fmt.Sprintf("%v", v)
	ssStr := fmt.Sprintf("%v", ss)
	
	switch eq {
	case "=":
		return vStr == ssStr
	case "!=":
		return vStr != ssStr
	case "in":
		parts := strings.Split(ssStr, ",")
		for _, part := range parts {
			if strings.TrimSpace(part) == vStr {
				return true
			}
		}
		return false
	case "!in":
		parts := strings.Split(ssStr, ",")
		for _, part := range parts {
			if strings.TrimSpace(part) == vStr {
				return false
			}
		}
		return true
	case "has":
		parts := strings.Split(vStr, ",")
		for _, part := range parts {
			if strings.TrimSpace(part) == ssStr {
				return true
			}
		}
		return false
	case "regex":
		rx, err := regexp.Compile(ssStr)
		if err != nil {
    			return false
		}
		return rx.MatchString(vStr)
		// Implementation would require regexp package
		//return false
	}
	
	return false
}

