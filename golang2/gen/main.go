package main

import (
	"fmt"
	"os"
	"strings"
)

// GlobT represents global state
type GlobT struct {
	LoadErrs  bool
	RunErrs   bool
	Acts      ActT
	Dats      ActT
	Winp      int
	Wins      []WinT
	Collect   map[string]interface{}
	OutOn     bool
	InOn      bool
	Ins       strings.Builder
}


// KpExtra represents extra key-value pairs
type KpExtra struct {
	Names map[string]string
}
func (me KpExtra) GetVar(glob *GlobT, s []string, ln string) (bool, string) {
	r,ok := me.Names[s[0]]
	if !ok { r = fmt.Sprintf("?%s?:%s", s[0], ln) }
	return !ok,r
}

func main() {
	args := os.Args[1:] // Skip the program name
	if len(args) < 2 {
		fmt.Println(args)
		return
	}

	glob := new(GlobT)
	glob.Winp = -1
	// Load files and check for errors
	glob.LoadErrs = loadFiles(args[0], &glob.Acts)
	glob.LoadErrs = glob.LoadErrs || loadFiles(args[1], &glob.Dats)

//		fmt.Println(glob.Acts.ApActor[0])
//		fmt.Println(glob.Acts.ApActor[0].Kchilds[0])
	if len(glob.Acts.ApActor) > 0 {
		kp := &KpExtra{
			Names: make(map[string]string),
		}
		
		// Store args in kp.Names
		for i, arg := range args {
			kp.Names[fmt.Sprint(i)] = arg
		}
//fmt.Println("HERE")
		NewAct(glob, glob.Acts.ApActor[0].Kname, "", "run:1")
		GoAct(glob, kp)
	}

	if glob.LoadErrs || glob.RunErrs {
		fmt.Println("Errors")
		os.Exit(1)
	}
}

func loadFiles(files string, act *ActT) bool {
	act.index = make(map[string]int) 
	errs := false
	fileList := strings.Split(files, ",")
	
	for _, file := range fileList {
		content, err := os.ReadFile(file)
		if err != nil {
			fmt.Printf("Error reading file %s: %v\n", file, err)
			errs = true
			continue
		}
//			fmt.Println(string(content))

		lines := strings.Split(string(content), "\n")
//		fmt.Println(lines)
		errs = errs || LoadData(lines, act, file)
	}
	
	errs = errs || refs(act)
	return errs
}

// LoadData loads data from lines into an actor
func LoadData(lns []string, act *ActT, file string) bool {
	errs := false
	for i := 0; i < len(lns); i++ {
		lno := fmt.Sprintf("%s:%d", file, i+1)
		pos,tok := getw(lns[i], 0)
		if tok == "E_O_F" {
			break
		}
		errs = errs || Load(act, tok, lns[i], pos, lno)
	}
	return errs
}
/*
// fnd finds a value in the index
func fnd(act interface{}, s string, f string, chk string, lno string) (bool, interface{}) {
	if a, ok := act.(Acts); ok {
		if v, exists := a.Index[s]; exists {
			return true, v
		}
	}
	
	if chk == "?" {
		return true, -1
	}
	if f == chk {
		return true, -1
	}
	
	fmt.Printf("%s not found %s\n", s, lno)
	return false, -1
}
*/
// getName gets a value from a map by name
func getName(m map[string]string, n string) string {
	if v, ok := m[n]; ok {
		return v
	}
	return ""
}

// getws gets the rest of the line after position
func getws(line string, pos int) (int, string) {
	if pos+1 > len(line) {
		return pos, ""
	}
	return len(line), line[pos+1:]
}

// getw gets the next word
func getw(line string, pos int) (int, string) {
	if pos+1 > len(line) {
		return pos, "E_O_L"
	}

	// Skip whitespace
	from := pos
	for i := pos; i < len(line); i++ {
		if line[i] != ' ' && line[i] != '\t' {
			from = i
			break
		}
	}

	if from+1 > len(line) {
		return pos, "E_O_L"
	}

	// Find word end
	to := from
	for i := from; i < len(line); i++ {
		if line[i] == ' ' || line[i] == '\t' {
			break
		}
		to = i
	}

	return to + 1, line[from : to+1]
}

// getsw gets the next word that might be followed by a colon
func getsw(line string, pos int) (int, string) {
	if pos+1 > len(line) {
		return pos, "E_O_L"
	}

	// Skip whitespace
	from := pos
	for i := pos; i < len(line); i++ {
		if line[i] != ' ' && line[i] != '\t' {
			from = i
			break
		}
	}

	if from+1 > len(line) {
		return pos, "E_O_L"
	}

	// Find word end
	to := from
	isS := false
	for i := from; i < len(line); i++ {
		if line[i] == ' ' || line[i] == '\t' {
			break
		}
		if line[i] == ':' {
			isS = true
			break
		}
		to = i
	}

	if isS {
		return to + 2, line[from : to+1]
	}
	return to + 1, line[from : to+1]
}

func refs(act interface{}) bool {
	// Implementation needed
	return false
}

func newAct(glob *GlobT, kname string, s1 string, s2 string) {
	// Implementation needed
}

func goAct(glob *GlobT, kp *KpExtra) {
	// Implementation needed
}

