package main


type Kp interface {
	GetVar(string, string) string
	Doo(KpIts, string, int) int
	RunAct(Kp, int) int
}

type KpComp struct {
	Kp
	Kme int
	Fline string
	Kname string
	Knop string
	Kparent string
	Kfind string
	Kdoc string
	KparentP int
	itsStar [] *KpStar
	itsElement [] *KpElement
	itsRef [] *KpRef
}

type KpStar struct {
	Kp
	Kme int
	Fline string
	up *KpComp
	parent string
	parentP int
	Kdoc string
}

type KpElement struct {
	Kp
	Kme int
	Fline string
	up *KpComp
	parent string
	parentP int
	Kname string
	Kmw string
	Kmw2 string
	Kpad string
	Kdoc string
}

type KpRef struct {
	Kp
	Kme int
	Fline string
	up *KpComp
	parent string
	parentP int
	Kelement string
	Kcomp string
	Kopt string
	Kvar string
	Kdoc string
	KelementP int
	KcompP int
}

type KpActor struct {
	Kp
	Kme int
	Fline string
	Kname string
	Kparent string
	Kattr string
	Keq string
	Kvalue string
	Kcc string
	itsD [] *KpD
	itsAll [] *KpAll
	itsDu [] *KpDu
	itsIdu [] *KpIdu
	itsIts [] *KpIts
	itsIits [] *KpIits
	itsC [] *KpC
	itsBreak [] *KpBreak
	itsReturn [] *KpReturn
	itsUnique [] *KpUnique
	itsCollect [] *KpCollect
	Kchilds [] Kp
}

type KpD struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kds string
}

type KpAll struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kwhat string
	Kactor string
	KactorP int
}

type KpDu struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kactor string
	Kattr string
	Keq string
	Kvalue string
	KactorP int
}

type KpIdu struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kattr string
	Keq string
	Kvalue string
	Kcc string
}

type KpIts struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kwhat string
	Kactor string
	Kname string
	Kop string
	Kvalue string
	KactorP int
}

type KpIits struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kwhat string
	Kcc string
}

type KpC struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kdesc string
}

type KpBreak struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Klevel int
	Kdesc string
}

type KpReturn struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Klevel int
	Kdesc string
}

type KpUnique struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kcmd string
	Kkey string
	Kcc string
}

type KpCollect struct {
	Kp
	Kme int
	Fline string
	up *KpActor
	parent string
	parentP int
	Kcmd string
	Kpocket string
	Kkey string
}

