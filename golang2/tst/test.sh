run="go run ../src/main.go ../src/gen.go ../src/run.go ../src/structs.go  ../src/collect.go"

echo ::::::::::::::
echo concept_md.act "*"
echo ::::::::::::::

$run  concept_md.act concept.def "*" import >concept.md
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi

echo ::::::::::::::
echo concept.act "*"
echo ::::::::::::::

$run  concept.act concept.def cmd import >concept.html
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo concept2.act "*"
echo ::::::::::::::

$run  concept2.act generator3.def syntax import >generator.html
if [ $? != 0 ]; then echo concept2.act generator2.def has errors; fi

echo ::::::::::::::
echo collect.act
echo ::::::::::::::

$run  collect.act concept.def 
if [ $? != 0 ]; then echo collect.act concept.def has errors; fi

echo ::::::::::::::
echo daoimpl.act
echo ::::::::::::::

$run  daoimpl.act sample.def >user.java
if [ $? != 0 ]; then echo daoimpl.act sample.def has errors; fi

echo ::::::::::::::
echo add_jsp.act
echo ::::::::::::::

$run  add_jsp.act sample.def >user.jsp
if [ $? != 0 ]; then echo add_jsp.act sample.def has errors; fi

echo ::::::::::::::
echo view.act
echo ::::::::::::::

$run  view.act sample.def >user.sql
if [ $? != 0 ]; then echo view.act sample.def has errors; fi

echo ::::::::::::::
echo tst2.act
echo ::::::::::::::

$run  tst2.act tst.def,sample.def a b c d
if [ $? != 0 ]; then echo tst2.act tst.def,sample.def has errors; fi

echo ::::::::::::::
echo p_check.act sample.unit
echo ::::::::::::::

$run  p_check.act ../bld/sample.unit,../bld/app.unit
if [ $? != 0 ]; then echo p_check.act sample.unit has errors; fi

echo ::::::::::::::
echo dag.act
echo ::::::::::::::

$run   dag.act tst.def
if [ $? != 0 ]; then echo dag.act tst.def has errors; fi

echo ::::::::::::::
echo tst5b.act
echo ::::::::::::::

$run   tst5b.act tst.def check
if [ $? != 0 ]; then echo tst5b.act tst.def has errors; fi

echo ::::::::::::::
echo tst5c.act
echo ::::::::::::::

$run   tst5c.act tst.def check
if [ $? != 0 ]; then echo tst5c.act tst.def has errors; fi

echo ::::::::::::::
echo json5.act
echo ::::::::::::::

$run   json5.act tst.def check
if [ $? != 0 ]; then echo json5.act tst.def has errors; fi

echo ::::::::::::::
echo copy.act 
echo ::::::::::::::

$run   copy.act tst.def
if [ $? != 0 ]; then echo copy.act tst.def has errors; fi

echo ::::::::::::::
echo grid.act 
echo ::::::::::::::

$run   grid.act grid.def
if [ $? != 0 ]; then echo grid.act grid.def has errors; fi

echo ::::::::::::::
echo re_sub.act 
echo ::::::::::::::

$run   re_sub.act tst.def
if [ $? != 0 ]; then echo re_sub.act tst.def has errors; fi

echo ::::::::::::::
echo def_unit.act
echo ::::::::::::::

$run  def_unit.act sample.def_unit >sample.tst_unit
if [ $? != 0 ]; then echo def_unit.act sample.def_unit has errors; fi

echo ::::::::::::::
echo def_unit.act
echo ::::::::::::::

$run  def_unit.act note.def_unit >note.tst_unit
if [ $? != 0 ]; then echo def_unit.act note.def_unit has errors; fi

echo ::::::::::::::
echo p_check.act sample.tst_unit
echo ::::::::::::::

$run  p_check.act sample.tst_unit
if [ $? != 0 ]; then echo p_check.act sample.tst_unit has errors; fi

echo ::::::::::::::
echo p_check.act note.tst_unit
echo ::::::::::::::

$run  p_check.act note.tst_unit
if [ $? != 0 ]; then echo p_check.act note.tst_unit has errors; fi

echo ::::::::::::::
echo toggle.act doc
echo ::::::::::::::

$run  toggle.act sample.def on off
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi

echo ::::::::::::::
echo toggle.act code
echo ::::::::::::::

$run  toggle.act sample.def off on
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi




