echo ::::::::::::::
echo concept_md.act "*"
echo ::::::::::::::

../src/main.exe concept_md.act concept.def "*" import >concept.md
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi

echo ::::::::::::::
echo concept.act "*"
echo ::::::::::::::

../src/main.exe concept.act concept.def cmd import >concept.html
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo collect.act
echo ::::::::::::::

../src/main.exe collect.act concept.def 
if [ $? != 0 ]; then echo collect.act concept.def has errors; fi

echo ::::::::::::::
echo daoimpl.act
echo ::::::::::::::

../src/main.exe daoimpl.act sample.def >user.java
if [ $? != 0 ]; then echo daoimpl.act sample.def has errors; fi

echo ::::::::::::::
echo add_jsp.act
echo ::::::::::::::

../src/main.exe add_jsp.act sample.def >user.jsp
if [ $? != 0 ]; then echo add_jsp.act sample.def has errors; fi

echo ::::::::::::::
echo view.act
echo ::::::::::::::

../src/main.exe view.act sample.def >user.sql
if [ $? != 0 ]; then echo view.act sample.def has errors; fi

echo ::::::::::::::
echo tst2.act
echo ::::::::::::::

../src/main.exe tst2.act tst.def,sample.def a b c d
if [ $? != 0 ]; then echo tst2.act tst.def,sample.def has errors; fi

echo ::::::::::::::
echo p_check.act sample.unit
echo ::::::::::::::

../src/main.exe p_check.act ../bld/sample.unit,../bld/app.unit
if [ $? != 0 ]; then echo p_check.act sample.unit has errors; fi

echo ::::::::::::::
echo dag.act
echo ::::::::::::::

../src/main.exe  dag.act tst.def
if [ $? != 0 ]; then echo dag.act tst.def has errors; fi

echo ::::::::::::::
echo tst5b.act
echo ::::::::::::::

../src/main.exe  tst5b.act tst.def check
if [ $? != 0 ]; then echo tst5b.act tst.def has errors; fi

echo ::::::::::::::
echo tst5c.act
echo ::::::::::::::

../src/main.exe  tst5c.act tst.def check
if [ $? != 0 ]; then echo tst5c.act tst.def has errors; fi

echo ::::::::::::::
echo json5.act
echo ::::::::::::::

../src/main.exe  json5.act tst.def check
if [ $? != 0 ]; then echo json5.act tst.def has errors; fi

echo ::::::::::::::
echo copy.act 
echo ::::::::::::::

../src/main.exe  copy.act tst.def
if [ $? != 0 ]; then echo copy.act tst.def has errors; fi

echo ::::::::::::::
echo grid.act 
echo ::::::::::::::

../src/main.exe  grid.act grid.def
if [ $? != 0 ]; then echo grid.act grid.def has errors; fi

echo ::::::::::::::
echo re_sub.act 
echo ::::::::::::::

../src/main.exe  re_sub.act tst.def
if [ $? != 0 ]; then echo re_sub.act tst.def has errors; fi

echo ::::::::::::::
echo def_unit.act
echo ::::::::::::::

../src/main.exe def_unit.act sample.def_unit >sample.tst_unit
if [ $? != 0 ]; then echo def_unit.act sample.def_unit has errors; fi

echo ::::::::::::::
echo def_unit.act
echo ::::::::::::::

../src/main.exe def_unit.act note.def_unit >note.tst_unit
if [ $? != 0 ]; then echo def_unit.act note.def_unit has errors; fi

echo ::::::::::::::
echo p_check.act sample.tst_unit
echo ::::::::::::::

../src/main.exe p_check.act sample.tst_unit
if [ $? != 0 ]; then echo p_check.act sample.tst_unit has errors; fi

echo ::::::::::::::
echo p_check.act note.tst_unit
echo ::::::::::::::

../src/main.exe p_check.act note.tst_unit
if [ $? != 0 ]; then echo p_check.act note.tst_unit has errors; fi

echo ::::::::::::::
echo toggle.act doc
echo ::::::::::::::

../src/main.exe toggle.act sample.def on off
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi

echo ::::::::::::::
echo toggle.act code
echo ::::::::::::::

../src/main.exe toggle.act sample.def off on
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi




