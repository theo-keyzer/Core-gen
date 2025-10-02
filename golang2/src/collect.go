package main

import (
//	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
//	"os"
	"regexp"
//	"github.com/dlclark/regexp2"
	"strconv"
	"strings"
    "path/filepath"
    "runtime"
)

// Record represents the tuple returned by path operations
type Record struct {
	Ok   bool
	Dat  interface{}
	Path []string
}

func thisCmd(glob *GlobT, winp int, cmd *KpThis, lno string) (int) {
	_, st := strs(glob, winp, cmd.Kpath, cmd.LineNo, true, true)
	kPath := st
	va := strings.Split(kPath, ".")
	
	rec := getPath(glob, glob.Winp, va, cmd.LineNo)
	dat := rec.Dat
	
	dataType := getDataType(dat)
	glob.Wins[winp+1].DataType = dataType
	glob.Wins[winp+1].DataKey = ""
	
	if len(rec.Path) == 0 {
		ret := GoAct(glob, dat)
		if ret > 1 {
			return ret
		}
		return 0
	}
	
	if kp, ok := dat.(Kp); ok {
		if len(rec.Path[0]) == 0 || rec.Path[0] == "." {
			ret := GoAct(glob, dat)
			if ret > 1 {
				return ret
			}
			return 0
		}
		ret := kp.DoIts(glob, rec.Path, cmd.LineNo)
		if ret > 1 {
			return ret
		}
		return 0
	}
	
	if len(rec.Path) > 0 && rec.Path[0] != "." && rec.Path[0] != "" {
		glob.RunErrs += 1
		fmt.Printf("?%s?%s?\n", rec.Path[0], lno)
		return 0
	}
	
	if slice, ok := dat.([]interface{}); ok {
		for _, std := range slice {
			ret := GoAct(glob, std)
			if ret > 1 {
				return ret
			}
		}
		return 0
	}
	
	if mapData, ok := dat.(map[string]interface{}); ok {
		for key, value := range mapData {
			glob.Wins[winp+1].DataKey = key
			ret := GoAct(glob, value)
			if ret > 1 {
				return ret
			}
		}
		return 0
	}
	
	return 0
}
/*
func httpCmd(glob *GlobT, winp int, cmd *KpHttp, lno string) (int, error) {
	kData := cmd.KBody
	st, err := strs(glob, winp, kData, cmd.LineNo, true, true)
	if err != nil {
		return 0, err
	}
	kData = st[1].(string)
	
	if contains(cmd.Flags, "body_node") {
		va := strings.Split(kData, ":")
		path := strings.Split(va[0], ".")
		rec := getPath(glob, glob.Winp, path, cmd.LineNo)
		kData = rec.Dat
		if !rec.Ok {
			glob.RunErrs = true
			fmt.Println(rec.Dat)
			return 0, nil
		}
		if len(rec.Path) > 0 {
			glob.RunErrs = true
			fmt.Printf("?%s?%s?\n", rec.Path[0], lno)
			return 0, nil
		}
	}
	
	return addCmd(glob, winp, &KpAdd{
		KPath: cmd.KPath,
		KData: cmd.KData,
		Flags: cmd.Flags,
		LineNo: cmd.LineNo,
	}, lno, kData)
}
*/
func addCmd(glob *GlobT, winp int, cmd *KpAdd, lno string, body interface{}) (int) {
	var kData interface{} = cmd.Kdata
	
	if contains(cmd.Flags, "me") {
		kData = glob.Wins[winp].Dat
	} else {
		if contains(cmd.Flags, "r") {
			kData = cmd.Kdata
		} else {
			_, st := strs(glob, winp, cmd.Kdata, cmd.LineNo, true, true)
			kData = st
		}
	}
	
	if contains(cmd.Flags, "node") {
		kDataStr := kData.(string)
		va := strings.Split(kDataStr, ":")
		path := strings.Split(va[0], ".")
		rec := getPath(glob, glob.Winp, path, cmd.LineNo)
		kData = rec.Dat
		if !rec.Ok {
			printDebug("node")
			glob.RunErrs += 1
			fmt.Println(rec.Dat)
			return 0
		}
		if len(rec.Path) > 0 {
			printDebug("len")
			glob.RunErrs += 1
			fmt.Printf("?%s?%s?\n", rec.Path[0], lno)
			return 0
		}
	}
	
	if contains(cmd.Flags, "post") {
		bodyStr, _ := json.Marshal(body)
		resp, err := http.Post(kData.(string), "application/json", strings.NewReader(string(bodyStr)))
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		defer resp.Body.Close()
		
		responseBody, err := ioutil.ReadAll(resp.Body)
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		kData = string(responseBody)
	}
	
	if contains(cmd.Flags, "get") {
		if body != "" {
			parsedURL, err := url.Parse(kData.(string))
			if err != nil {
				glob.RunErrs += 1
				fmt.Println(err)
				fmt.Println(lno)
				return 0
			}
			
			var queryParams map[string]interface{}
			if bodyStr, ok := body.(string); ok {
				json.Unmarshal([]byte(bodyStr), &queryParams)
			}
			
			values := url.Values{}
			for k, v := range queryParams {
				values.Add(k, fmt.Sprintf("%v", v))
			}
			parsedURL.RawQuery = values.Encode()
			
			resp, err := http.Get(parsedURL.String())
			if err != nil {
				glob.RunErrs += 1
				fmt.Println(err)
				fmt.Println(lno)
				return 0
			}
			defer resp.Body.Close()
			
			responseBody, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				glob.RunErrs += 1
				fmt.Println(err)
				fmt.Println(lno)
				return 0
			}
			kData = string(responseBody)
		} else {
			resp, err := http.Get(kData.(string))
			if err != nil {
				glob.RunErrs += 1
				fmt.Println(err)
				fmt.Println(lno)
				return 0
			}
			defer resp.Body.Close()
			
			responseBody, err := ioutil.ReadAll(resp.Body)
			if err != nil {
				glob.RunErrs += 1
				fmt.Println(err)
				fmt.Println(lno)
				return 0
			}
			kData = string(responseBody)
		}
	}
	
	if contains(cmd.Flags, "eval") {
		// Note: Go doesn't have built-in eval. You'd need to implement or use a library
		// For now, treating as a no-op
		glob.RunErrs += 1
		fmt.Println("eval not implemented")
		fmt.Println(lno)
		return 0
	}
	
	if contains(cmd.Flags, "file") {
		content, err := ioutil.ReadFile(kData.(string))
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		kData = string(content)
	}
	
	if contains(cmd.Flags, "json") {
		var jsonData interface{}
		err := json.Unmarshal([]byte(kData.(string)), &jsonData)
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		kData = jsonData
	}
/*	
	if contains(cmd.Flags, "execute") {
		if !glob.IsConn {
			return 0
		}
		rows, err := glob.Conn.Query(kData.(string))
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		defer rows.Close()
		
		columns, err := rows.Columns()
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		
		if len(columns) > 0 {
			glob.Wins[winp].DataKeys = columns
		}
		
		var results []map[string]interface{}
		for rows.Next() {
			values := make([]interface{}, len(columns))
			pointers := make([]interface{}, len(columns))
			for i := range values {
				pointers[i] = &values[i]
			}
			
			if err := rows.Scan(pointers...); err != nil {
				glob.RunErrs += 1
				fmt.Println(err)
				fmt.Println(lno)
				return 0
			}
			
			row := make(map[string]interface{})
			for i, column := range columns {
				row[column] = values[i]
			}
			results = append(results, row)
		}
		kData = results
	}
*/	
	_, st := strs(glob, winp, cmd.Kpath, cmd.LineNo, true, true)
	va := strings.Split(st, ":")
	path := strings.Split(va[0], ".")
	rec := getPath(glob, glob.Winp, path, cmd.LineNo)
	
	if !rec.Ok {
			printDebug("node")
		glob.RunErrs += 1
		fmt.Println(rec.Dat)
		return 0
	}
	
	dat := rec.Dat
	if slice, ok := dat.([]interface{}); ok {
		if contains(cmd.Flags, "check") || contains(cmd.Flags, "break") {
			if containsValue(slice, kData) {
				if contains(cmd.Flags, "break") {
					return 2
				}
				glob.Wins[winp].IsCheck = true
				return 0
			}
		}
		if contains(cmd.Flags, "no_add") {
			return 0
		}
		
		// Add to slice (need to update the original reference)
		
		newSlice := append(slice, kData)
//		fmt.Println(newSlice)
		updPath(glob, glob.Winp, path, cmd.LineNo, newSlice)
//		updatePath(glob, glob.Winp, path, newSlice)
		return 0
	}
	
	if mapData, ok := dat.(map[string]interface{}); ok {
		if len(va) < 2 {
			printDebug("run")
			glob.RunErrs += 1
			fmt.Printf("?no key?%s?\n", lno)
			return 0
		}
		
		if contains(cmd.Flags, "map") {
			if _, exists := mapData[va[1]]; !exists || contains(cmd.Flags, "clear") {
				mapData[va[1]] = make(map[string]interface{})
			}
			return 0
		}
		
		if contains(cmd.Flags, "list") {
			if _, exists := mapData[va[1]]; !exists || contains(cmd.Flags, "clear") {
				mapData[va[1]] = make([]interface{}, 0)
			}
			return 0
		}
		
		if contains(cmd.Flags, "check") || contains(cmd.Flags, "break") {
			if mvar, exists := mapData[va[1]]; exists {
			
				if mvar == kData {
//			printDebug("node")
					if contains(cmd.Flags, "break") {
						return 2
					}
					glob.Wins[winp].IsCheck = true
					return 0
				}
			}
		}
		
		if contains(cmd.Flags, "no_add") {
			return 0
		}
		
		mapData[va[1]] = kData
		return 0
	}
	
			printDebug("node")
	glob.RunErrs += 1
	fmt.Printf("?%s?%s?\n", cmd.Kpath, lno)
	return 0
}
/*
func dbconnCmd(glob *GlobT, winp int, cmd *KpDbconn, lno string) (int, error) {
	st, err := strs(glob, winp, cmd.KPassword, cmd.LineNo, true, true)
	if err != nil {
		return 0, err
	}
	password := st[1].(string)
	
	// Construct connection string (example for PostgreSQL)
	connStr := fmt.Sprintf("host=%s dbname=%s user=%s password=%s sslmode=disable",
		cmd.KHost, cmd.KDatabase, cmd.KUsername, password)
	
	conn, err := sql.Open("postgres", connStr)
	if err != nil {
		glob.RunErrs = true
		fmt.Println(err)
		return 0, nil
	}
	
	glob.Conn = conn
	glob.IsConn = true
	return 0, nil
}

func dbClose(glob *GlobT) error {
	if !glob.IsConn {
		return nil
	}
	
	err := glob.Conn.Close()
	if err != nil {
		fmt.Println(err)
		glob.RunErrs = true
		return err
	}
	glob.IsConn = false
	return nil
}
*/

func updPath(glob *GlobT, winp int, va []string, lno string, newdat []interface{})  {
	if va[0] == "_" {
		dat := glob.Collect
		updNode(glob, dat, va[1:], lno, newdat)
	}
}

func getPath(glob *GlobT, winp int, va []string, lno string) Record {
	if len(va) == 0 {
		return Record{Ok: true, Dat: glob.Wins[winp].Dat, Path: []string{}}
	}
	
	if va[0] == "_" {
		dat := glob.Collect
		return getNode(glob, dat, va[1:], lno)
	}
	
	if len(va[0]) > 0 || len(va) == 1 {
		dat := glob.Wins[winp].Dat
		return getNode(glob, dat, va, lno)
	}
	
	if len(va[1]) == 0 {
		return Record{Ok: true, Dat: glob.Wins[winp].Dat, Path: va[1:]}
	}
	
	if va[1] == "+" {
		return Record{Ok: true, Dat: strconv.Itoa(glob.Wins[winp].Cnt + 1), Path: []string{}}
	}
	
	if va[1] == "0" {
		if glob.Wins[winp].Cnt != 0 {
			return Record{Ok: true, Dat: "", Path: []string{}}
		}
		return Record{Ok: true, Dat: va[2], Path: []string{}}
	}
	
	if va[1] == "1" {
		if glob.Wins[winp].Cnt == 0 {
			return Record{Ok: true, Dat: "", Path: []string{}}
		}
		return Record{Ok: true, Dat: va[2], Path: []string{}}
	}
/*	
	if va[1] == "_options" {
		if kp, ok := glob.Wins[winp].Dat.(Kp); ok {
			flags := kp.GetFlags()
			if len(flags) == 0 {
				return Record{Ok: true, Dat: "", Path: []string{}}
			}
			result := flags[0]
			for i := 1; i < len(flags); i++ {
				result += "," + flags[i]
			}
			return Record{Ok: true, Dat: result, Path: []string{}}
		}
		return Record{Ok: false, Dat: fmt.Sprintf("?_options?%s?", lno), Path: []string{}}
	}
*/	
	if va[1] == "_lno" {
		if kp, ok := glob.Wins[winp].Dat.(Kp); ok {
			return Record{Ok: true, Dat: kp.GetLineNo() + ", " + lno, Path: []string{}}
		}
		return Record{Ok: true, Dat: lno, Path: []string{}}
	}
	
	if va[1] == "_arg" {
		return Record{Ok: true, Dat: glob.Wins[winp].Arg, Path: []string{}}
	}
	
	if va[1] == "_ins" {
		return Record{Ok: true, Dat: glob.Ins.String(), Path: []string{}}
	}
	
	if va[1] == "_depth" {
		return Record{Ok: true, Dat: strconv.Itoa(winp), Path: []string{}}
	}
	
	if va[1] == "_type" {
		dat := glob.Wins[winp].Dat
		dataType := getDataType(dat)
		return Record{Ok: true, Dat: dataType, Path: []string{}}
	}
	
	if va[1] == "_key" {
		return Record{Ok: true, Dat: glob.Wins[winp].DataKey, Path: []string{}}
	}
	
	if va[1] == "_keys" {
		return Record{Ok: true, Dat: glob.Wins[winp].DataKeys, Path: []string{}}
	}
	
	for i := winp - 1; i >= 0; i-- {
		if glob.Wins[i].Name == va[1] {
			return getPath(glob, i, va[2:], lno)
		}
	}
	return Record{Ok: false, Dat: fmt.Sprintf("?%s?%s?", va[1], lno), Path: va}
}

func updNode(glob *GlobT, dat interface{}, va []string, lno string, newdat []interface{})  {
	if len(va) == 0 {
		return
	}
	if mapData, ok := dat.(map[string]interface{}); ok {
		if value, exists := mapData[va[0]]; exists {
			if len(va) == 1 {
				mapData[va[0]] = newdat
				return
			}
			updNode(glob, value, va[1:], lno, newdat)
		}
	}
}

func getNode(glob *GlobT, dat interface{}, va []string, lno string) Record {
	if len(va) == 0 {
		return Record{Ok: true, Dat: dat, Path: va}
	}
	
	if len(va[0]) == 0 {
		return Record{Ok: true, Dat: dat, Path: []string{"."}}
	}
	
	if mapData, ok := dat.(map[string]interface{}); ok {
		if value, exists := mapData[va[0]]; exists {
			return getNode(glob, value, va[1:], lno)
		}
		return Record{Ok: true, Dat: dat, Path: va}
	}
	
	return Record{Ok: true, Dat: dat, Path: va}
}

func replaceCmd(glob *GlobT, winp int, cmd *KpReplace, lno string) int {
	_, st := strs(glob, winp, cmd.Kmatch, cmd.LineNo, true, true)
	kMatch := st
	
	_, st = strs(glob, winp, cmd.Kwith, cmd.LineNo, true, true)
	kWith := st
	
	_, st = strs(glob, winp, cmd.Kpath, cmd.LineNo, true, true)
	va := strings.Split(st, ":")
	path := strings.Split(va[0], ".")
	rec := getPath(glob, glob.Winp, path, cmd.LineNo)
	
	if !rec.Ok {
		glob.RunErrs += 1
		fmt.Println(rec.Dat)
		return 0
	}
	
	dat := rec.Dat
	
	if mapData, ok := dat.(map[string]interface{}); ok {
		if len(va) < 2 {
			glob.RunErrs += 1
			fmt.Printf("?no key?%s?\n", lno)
			return 0
		}
		
		val, exists := mapData[va[1]]
		if !exists {
			glob.RunErrs += 1
			fmt.Printf("?%s?%s?\n", cmd.Kpath, lno)
			return 0
		}
		
		valStr, ok := val.(string)
		if !ok {
			glob.RunErrs += 1
			fmt.Printf("?%s?%s?\n", cmd.Kpath, lno)
			return 0
		}
		
		re, err := regexp.Compile(kMatch)
		if err != nil {
			glob.RunErrs += 1
			fmt.Println(err)
			fmt.Println(lno)
			return 0
		}
		
		if contains(cmd.Flags, "group") {
			valStr = replaceMapped(valStr, re, kWith)
		} else {
			valStr = re.ReplaceAllString(valStr, kWith)
		}
		
		mapData[va[1]] = valStr
		return 0
	}
	
	glob.RunErrs += 1
	fmt.Printf("?%s?%s?\n", cmd.Kpath, lno)
	return 0
}

func replaceMapped(originalString string, regex *regexp.Regexp, replacement string) string {
	return regex.ReplaceAllStringFunc(originalString, func(match string) string {
		submatches := regex.FindStringSubmatch(match)
		result := replacement
		
		// Replace \1, \2, etc. with captured groups
		groupRe := regexp.MustCompile(`\\(\d+)`)
		result = groupRe.ReplaceAllStringFunc(result, func(groupMatch string) string {
			groupNum, err := strconv.Atoi(groupMatch[1:])
			if err != nil || groupNum >= len(submatches) {
				return "-"
			}
			if groupNum == 0 {
				return submatches[0] // Full match
			}
			return submatches[groupNum]
		})
		
		return result
	})
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

func containsValue(slice []interface{}, item interface{}) bool {
	for _, s := range slice {
		if s == item {
			return true
		}
	}
	return false
}

func getDataType(dat interface{}) string {
	switch dat.(type) {
	case []interface{}:
		return "List"
	case map[string]interface{}:
		return "Map"
	default:
		return fmt.Sprintf("%T", dat)
	}
}

func updatePath(glob *GlobT, winp int, path []string, newValue interface{}) {
	// Implementation to update the value at the given path
	// This would need to traverse the path and update the final value
}

func printDebug(msg string) {
    _, file, line, ok := runtime.Caller(1)
    if ok {
        fmt.Printf("%s:%d: %s\n", filepath.Base(file), line, msg)
    }
}

