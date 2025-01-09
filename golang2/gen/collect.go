package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"regexp"
	"strconv"
	"strings"
)

// Record represents a tuple-like structure for path operations
type Record struct {
	Ok   bool
	Dat  interface{}
	Path []string
}

// Window represents the window state
type Window struct {
	Dat      interface{}
	DataType string
	DataKey  string
	Name     string
	Cnt      int
	Arg      string
	IsCheck  bool
}

// Command represents a command structure
type Command struct {
	KPath   string
	KMatch  string
	KWith   string
	KData   interface{}
	Flags   []string
	LineNo  string
}

// Kp represents a key-path structure
type Kp struct {
	LineNo string
}

func thisCmd(glob *GlobT, winp int, cmd *Command, lno string) int {
	va := strings.Split(cmd.KPath, ".")
	rec := getPath(glob, glob.winp, va, cmd.LineNo)
	dat := rec.Dat

	// Determine data type
	dataType := fmt.Sprintf("%T", dat)
	switch dat.(type) {
	case []interface{}:
		dataType = "List"
	case map[string]interface{}:
		dataType = "Map"
	}

	glob.wins[winp+1].DataType = dataType
	glob.wins[winp+1].DataKey = ""

	if len(rec.Path) == 0 {
		ret := goAct(glob, dat)
		if ret > 1 {
			return ret
		}
		return 0
	}

	if kp, ok := dat.(*Kp); ok {
		if len(rec.Path[0]) == 0 || rec.Path[0] == "." {
			ret := goAct(glob, kp)
			if ret > 1 {
				return ret
			}
			return 0
		}
		ret := kp.doIts(glob, rec.Path, cmd.LineNo)
		if ret > 1 {
			return ret
		}
		return 0
	}

	if len(rec.Path) > 0 && rec.Path[0] != "." && rec.Path[0] != "" {
		glob.RunErrs = true
		fmt.Printf("?%s?%s?\n", rec.Path[0], lno)
		return 0
	}

	switch v := dat.(type) {
	case []interface{}:
		for _, std := range v {
			ret := goAct(glob, std)
			if ret > 1 {
				return ret
			}
		}
	case map[string]interface{}:
		for key, val := range v {
			glob.wins[winp+1].DataKey = key
			ret := goAct(glob, val)
			if ret > 1 {
				return ret
			}
		}
	}
	return 0
}

func replaceCmd(glob *GlobT, winp int, cmd *Command, lno string) int {
	st := strs(glob, winp, cmd.KMatch, cmd.LineNo, true, true)
	kMatch := st[1]
	st = strs(glob, winp, cmd.KWith, cmd.LineNo, true, true)
	kWith := st[1]
	st = strs(glob, winp, cmd.KPath, cmd.LineNo, true, true)
	
	va := strings.Split(st[1], ":")
	path := strings.Split(va[0], ".")
	rec := getPath(glob, glob.winp, path, cmd.LineNo)
	
	if !rec.Ok {
		glob.RunErrs = true
		fmt.Println(rec.Dat)
		return 0
	}

	if m, ok := rec.Dat.(map[string]interface{}); ok {
		if len(va) < 2 {
			glob.RunErrs = true
			fmt.Printf("?no key?%s?\n", lno)
			return 0
		}
		
		val, ok := m[va[1]].(string)
		if !ok {
			glob.RunErrs = true
			fmt.Printf("?%s?%s?\n", cmd.KPath, lno)
			return 0
		}

		re, err := regexp.Compile(kMatch)
		if err != nil {
			glob.RunErrs = true
			fmt.Printf("Invalid regex: %v\n", err)
			return 0
		}

		if contains(cmd.Flags, "group") {
			val = replaceMapped(val, re, kWith)
		} else {
			val = re.ReplaceAllString(val, kWith)
		}
		
		m[va[1]] = val
		return 0
	}

	glob.RunErrs = true
	fmt.Printf("?%s?%s?\n", cmd.KPath, lno)
	return 0
}

func replaceMapped(originalString string, regex *regexp.Regexp, replacement string) string {
	var buffer strings.Builder
	start := 0

	for _, match := range regex.FindAllStringSubmatchIndex(originalString, -1) {
		// Write the part before the match
		buffer.WriteString(originalString[start:match[0]])
		
		// Get the full match
		fullMatch := originalString[match[0]:match[1]]
		
		// Replace the groups in the replacement string
		result := regexp.MustCompile(`\\(\d+)`).ReplaceAllStringFunc(replacement, func(s string) string {
			groupNum, _ := strconv.Atoi(s[1:])
			if groupNum*2+1 < len(match) && match[groupNum*2] != -1 {
				return originalString[match[groupNum*2]:match[groupNum*2+1]]
			}
			return "-"
		})
		
		buffer.WriteString(result)
		start = match[1]
	}
	
	buffer.WriteString(originalString[start:])
	return buffer.String()
}

func addCmd(glob *GlobT, winp int, cmd *Command, lno string) int {
	var kData interface{} = cmd.KData

	if contains(cmd.Flags, "me") {
		kData = glob.wins[winp].Dat
	} else if contains(cmd.Flags, "r") {
		kData = cmd.KData
	} else {
		st := strs(glob, winp, fmt.Sprint(cmd.KData), cmd.LineNo, true, true)
		kData = st[1]
	}

	if contains(cmd.Flags, "node") {
		strData := fmt.Sprint(kData)
		va := strings.Split(strData, ":")
		path := strings.Split(va[0], ".")
		rec := getPath(glob, glob.winp, path, cmd.LineNo)
		kData = rec.Dat
		
		if !rec.Ok {
			glob.RunErrs = true
			fmt.Println(rec.Dat)
			return 0
		}
		
		if len(rec.Path) > 0 {
			glob.RunErrs = true
			fmt.Printf("?%s?%s?\n", rec.Path[0], lno)
			return 0
		}
	}

	if contains(cmd.Flags, "file") {
		content, err := ioutil.ReadFile(fmt.Sprint(kData))
		if err != nil {
			fmt.Println(err)
			return 0
		}
		kData = string(content)
	}

	if contains(cmd.Flags, "json") {
		var jsonData interface{}
		if err := json.Unmarshal([]byte(fmt.Sprint(kData)), &jsonData); err != nil {
			fmt.Println(err)
			return 0
		}
		kData = jsonData
	}

	st := strs(glob, winp, cmd.KPath, cmd.LineNo, true, true)
	va := strings.Split(st[1], ":")
	path := strings.Split(va[0], ".")
	rec := getPath(glob, glob.winp, path, cmd.LineNo)

	if !rec.Ok {
		glob.RunErrs = true
		fmt.Println(rec.Dat)
		return 0
	}

	switch dat := rec.Dat.(type) {
	case []interface{}:
		if contains(cmd.Flags, "check") || contains(cmd.Flags, "break") {
			if contains(dat, kData) {
				if contains(cmd.Flags, "break") {
					return 2
				}
				glob.wins[winp].IsCheck = true
				return 0
			}
		}
		if !contains(cmd.Flags, "no_add") {
			dat = append(dat, kData)
		}
		return 0

	case map[string]interface{}:
		if len(va) < 2 {
			glob.RunErrs = true
			fmt.Printf("?no key?%s?\n", lno)
			return 0
		}

		if contains(cmd.Flags, "map") {
			if _, ok := dat[va[1]].(map[string]interface{}); !ok || contains(cmd.Flags, "clear") {
				dat[va[1]] = make(map[string]interface{})
			}
			return 0
		}

		if contains(cmd.Flags, "list") {
			if _, ok := dat[va[1]].([]interface{}); !ok || contains(cmd.Flags, "clear") {
				dat[va[1]] = make([]interface{}, 0)
			}
			return 0
		}

		if contains(cmd.Flags, "check") || contains(cmd.Flags, "break") {
			if dat[va[1]] == kData {
				if contains(cmd.Flags, "break") {
					return 2
				}
				glob.wins[winp].IsCheck = true
				return 0
			}
		}

		if !contains(cmd.Flags, "no_add") {
			dat[va[1]] = kData
		}
		return 0
	}

	glob.RunErrs = true
	fmt.Printf("?%s?%s?\n", cmd.KPath, lno)
	return 0
}

func getPath(glob *GlobT, winp int, va []string, lno string) Record {
	if len(va) == 0 {
		return Record{
			Ok:   true,
			Dat:  glob.wins[winp].Dat,
			Path: []string{},
		}
	}

	if va[0] == "_" {
		return getNode(glob, glob.collect, va[1:], lno)
	}

	if len(va[0]) > 0 || len(va) == 1 {
		return getNode(glob, glob.wins[winp].Dat, va, lno)
	}

	if len(va[1]) == 0 {
		return Record{
			Ok:   true,
			Dat:  glob.wins[winp].Dat,
			Path: va[1:],
		}
	}

	switch va[1] {
	case "+":
		return Record{
			Ok:   true,
			Dat:  strconv.Itoa(glob.wins[winp].Cnt + 1),
			Path: []string{},
		}
	case "0":
		if glob.wins[winp].Cnt != 0 {
			return Record{Ok: true, Dat: "", Path: []string{}}
		}
		return Record{Ok: true, Dat: va[2], Path: []string{}}
	case "1":
		if glob.wins[winp].Cnt == 0 {
			return Record{Ok: true, Dat: "", Path: []string{}}
		}
		return Record{Ok: true, Dat: va[2], Path: []string{}}
	case "_lno":
		if kp, ok := glob.wins[winp].Dat.(*Kp); ok {
			return Record{
				Ok:   true,
				Dat:  fmt.Sprintf("%s, %s", kp.LineNo, lno),
				Path: []string{},
			}
		}
		return Record{Ok: true, Dat: lno, Path: []string{}}
	case "_arg":
		return Record{Ok: true, Dat: glob.wins[winp].Arg, Path: []string{}}
	case "_ins":
		return Record{Ok: true, Dat: fmt.Sprint(glob.ins), Path: []string{}}
	case "_depth":
		return Record{Ok: true, Dat: strconv.Itoa(winp), Path: []string{}}
	case "_type":
		dat := glob.wins[winp].Dat
		dataType := fmt.Sprintf("%T", dat)
		switch dat.(type) {
		case []interface{}:
			dataType = "List"
		case map[string]interface{}:
			dataType = "Map"
		}
		return Record{Ok: true, Dat: dataType, Path: []string{}}
	case "_key":
		return Record{Ok: true, Dat: glob.wins[winp].DataKey, Path: []string{}}
	}

	for i := winp - 1; i >= 0; i-- {
		if glob.wins[i].Name == va[1] {
			return getPath(glob, i, va[2:], lno)
		}
	}

	return Record{
		Ok:   false,
		Dat:  fmt.Sprintf("?%s?%s?", va[1], lno),
		Path: va,
	}
}

func getNode(glob *GlobT, dat interface{}, va []string, lno string) Record {
	if len(va) == 0 {
		return Record{Ok: true, Dat: dat, Path: va}
	}

	if len(va[0]) == 0 {
		return Record{Ok: true, Dat: dat, Path: []string{"."}}
	}

	if m, ok := dat.(map[string]interface{}); ok {
		if val, exists := m[va[0]]; exists {
			return getNode(glob, val, va[1:], lno)
		}
		return Record{Ok: true, Dat: dat, Path: va}
	}

	return Record{Ok: true, Dat: dat, Path: va}
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

