package main

import (
	"fmt"
	"os"
	"strings"
)


// Acts represents the actions structure
type Acts struct {
	ApActor []Actor
	Index   map[string]interface{}
}

// Actor represents an actor in the system
type Actor struct {
	KName string
}

// KpExtra represents extra key-value pairs
type KpExtra struct {
	Names map[string]string
}

func main() {
	args := os.Args[1:] // Skip the program name
	if len(args) < 2 {
		fmt.Println(args)
		return
	}

//	glob := &GlobT{
//		Acts: Acts{
//			Index: make(map[string]interface{}),
//		},
//	}

	var globs  GlobT;
	glob := &globs;
	// Load files and check for errors
	glob.LoadErrs = loadFiles(args[0], &glob.Acts)
	glob.LoadErrs = glob.LoadErrs || loadFiles(args[1], &glob.Dats)

	if len(glob.Acts.ApActor) > 0 {
		kp := &KpExtra{
			Names: make(map[string]string),
		}
		
		// Store args in kp.Names
		for i, arg := range args {
			kp.Names[fmt.Sprint(i)] = arg
		}

		newAct(glob, glob.Acts.ApActor[0].Kname, "", "run:1")
		goAct(glob, kp)
	}

	if glob.LoadErrs || glob.RunErrs {
		fmt.Println("Errors")
		os.Exit(1)
	}
}

func loadFiles(files string, act interface{}) bool {
	errs := false
	fileList := strings.Split(files, ",")
	
	for _, file := range fileList {
		content, err := os.ReadFile(file)
		if err != nil {
			fmt.Printf("Error reading file %s: %v\n", file, err)
			errs = true
			continue
		}
		
		lines := strings.Split(string(content), "\n")
		errs = errs || loadData(lines, act, file)
	}
	
	errs = errs || refs(act)
	return errs
}

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

// Placeholder functions that would need to be implemented
func loadData(lines []string, act interface{}, file string) bool {
	// Implementation needed
	return false
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

