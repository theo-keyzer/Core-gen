echo ::::::::::::::
echo concept_md.act "*"
echo ::::::::::::::

dart run ../src/main.dart concept_md.act concept.def "*" import >concept.md
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi

echo ::::::::::::::
echo concept.act "*"
echo ::::::::::::::

dart run ../src/main.dart concept.act concept.def cmd import >concept.html
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo collect.act
echo ::::::::::::::

dart run ../src/main.dart collect.act concept.def 
if [ $? != 0 ]; then echo collect.act concept.def has errors; fi

echo ::::::::::::::
echo daoimpl.act
echo ::::::::::::::

dart run ../src/main.dart daoimpl.act sample.def >user.java
if [ $? != 0 ]; then echo daoimpl.act sample.def has errors; fi

echo ::::::::::::::
echo add_jsp.act
echo ::::::::::::::

dart run ../src/main.dart add_jsp.act sample.def >user.jsp
if [ $? != 0 ]; then echo add_jsp.act sample.def has errors; fi

echo ::::::::::::::
echo view.act
echo ::::::::::::::

dart run ../src/main.dart view.act sample.def >user.sql
if [ $? != 0 ]; then echo view.act sample.def has errors; fi

echo ::::::::::::::
echo tst2.act
echo ::::::::::::::

dart run ../src/main.dart tst2.act tst.def,sample.def a b c d
if [ $? != 0 ]; then echo tst2.act tst.def,sample.def has errors; fi

echo ::::::::::::::
echo p_check.act sample.unit
echo ::::::::::::::

dart run ../src/main.dart p_check.act ../bld/sample.unit,../bld/app.unit
if [ $? != 0 ]; then echo p_check.act sample.unit has errors; fi

echo ::::::::::::::
echo dag.act
echo ::::::::::::::

dart run ../src/main.dart  dag.act tst.def
if [ $? != 0 ]; then echo dag.act tst.def has errors; fi

echo ::::::::::::::
echo tst5b.act
echo ::::::::::::::

dart run ../src/main.dart  tst5b.act tst.def check
if [ $? != 0 ]; then echo tst5b.act tst.def has errors; fi

echo ::::::::::::::
echo tst5c.act
echo ::::::::::::::

dart run ../src/main.dart  tst5c.act tst.def check
if [ $? != 0 ]; then echo tst5c.act tst.def has errors; fi

echo ::::::::::::::
echo json5.act
echo ::::::::::::::

dart run ../src/main.dart  json5.act tst.def check
if [ $? != 0 ]; then echo json5.act tst.def has errors; fi

echo ::::::::::::::
echo copy.act 
echo ::::::::::::::

dart run ../src/main.dart  copy.act tst.def
if [ $? != 0 ]; then echo copy.act tst.def has errors; fi

echo ::::::::::::::
echo grid.act 
echo ::::::::::::::

dart run ../src/main.dart  grid.act grid.def
if [ $? != 0 ]; then echo grid.act grid.def has errors; fi

echo ::::::::::::::
echo re_sub.act 
echo ::::::::::::::

dart run ../src/main.dart  re_sub.act tst.def
if [ $? != 0 ]; then echo re_sub.act tst.def has errors; fi



