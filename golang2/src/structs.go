package main

type Kp interface {
	DoIts(glob *GlobT, va []string, lno string) int
	GetVar(glob *GlobT, va []string, lno string) (bool, string)
	GetLineNo() string
}

type KpActor struct {
	Kp
	Kme int
	LineNo string
	Kname string
	Kparent string
	Kattr string
	Keq string
	Kvalue string
	Kcc string
	Kchilds [] Kp
}

