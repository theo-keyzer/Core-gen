echo ::::::::::::::
echo mtst.act
echo ::::::::::::::

python ../src/main.py mtst.act note.def
if [ $? != 0 ]; then echo mtst.act note.def has errors; fi

echo ::::::::::::::
echo match1.act
echo ::::::::::::::

python ../src/main.py match1.act note.def thinking,frame,group,join,layout
if [ $? != 0 ]; then echo match1.act note.def has errors; fi

echo ::::::::::::::
echo match2.act
echo ::::::::::::::

python ../src/main.py match2.act note.def thinking,frame group,join,layout
if [ $? != 0 ]; then echo match2.act note.def has errors; fi

echo ::::::::::::::
echo match3.act
echo ::::::::::::::

python ../src/main.py match3.act note.def thinking,frame group,join layout
if [ $? != 0 ]; then echo match3.act note.def has errors; fi

echo ::::::::::::::
echo daoimpl.act
echo ::::::::::::::

python ../src/main.py daoimpl.act sample.def >user.java
if [ $? != 0 ]; then echo daoimpl.act sample.def has errors; fi

echo ::::::::::::::
echo add_jsp.act
echo ::::::::::::::

python ../src/main.py add_jsp.act sample.def >user.jsp
if [ $? != 0 ]; then echo add_jsp.act sample.def has errors; fi

echo ::::::::::::::
echo view.act
echo ::::::::::::::

python ../src/main.py view.act sample.def >user.sql
if [ $? != 0 ]; then echo view.act sample.def has errors; fi

echo ::::::::::::::
echo dag.act
echo ::::::::::::::

python ../src/main.py  dag.act tst.def
if [ $? != 0 ]; then echo dag.act tst.def has errors; fi

echo ::::::::::::::
echo dag2.act
echo ::::::::::::::

python ../src/main.py  dag2.act tst.def
if [ $? != 0 ]; then echo dag2.act tst.def has errors; fi

echo ::::::::::::::
echo tst2.act
echo ::::::::::::::

python ../src/main.py tst2.act tst.def,sample.def a b c d
if [ $? != 0 ]; then echo tst2.act tst.def,sample.def has errors; fi

echo ::::::::::::::
echo md.act
echo ::::::::::::::

python ../src/main.py md.act gen.def >gen.md
if [ $? != 0 ]; then echo md.act gen.def has errors; fi

echo ::::::::::::::
echo latex.act
echo ::::::::::::::

python ../src/main.py latex.act gen.def >gen.tex
if [ $? != 0 ]; then echo latex.act gen.def has errors; fi

echo ::::::::::::::
echo grid.act
echo ::::::::::::::

python ../src/main.py grid.act grid.def
if [ $? != 0 ]; then echo grid.act grid.def has errors; fi

echo ::::::::::::::
echo tst5b.act
echo ::::::::::::::

python ../src/main.py  tst5b.act tst.def check
if [ $? != 0 ]; then echo tst5b.act tst.def has errors; fi

echo ::::::::::::::
echo tst5c.act
echo ::::::::::::::

python ../src/main.py  tst5c.act tst.def check
if [ $? != 0 ]; then echo tst5c.act tst.def has errors; fi

echo ::::::::::::::
echo json.act
echo ::::::::::::::

python ../src/main.py  json.act tst.def
if [ $? != 0 ]; then echo json.act tst.def has errors; fi

echo ::::::::::::::
echo json2.act
echo ::::::::::::::

python ../src/main.py  json2.act tst.def
if [ $? != 0 ]; then echo json2.act tst.def has errors; fi

echo ::::::::::::::
echo db.act
echo ::::::::::::::

python ../src/main.py db.act note.def 
if [ $? != 0 ]; then echo db.act note.def has errors; fi

echo ::::::::::::::
echo web.act
echo ::::::::::::::

python ../src/main.py web.act note.def 
if [ $? != 0 ]; then echo web.act note.def has errors; fi

echo ::::::::::::::
echo json3.act
echo ::::::::::::::

python ../src/main.py json3.act note.def 
if [ $? != 0 ]; then echo json3.act note.def has errors; fi

echo ::::::::::::::
echo regx.act
echo ::::::::::::::

python ../src/main.py regx.act note.def 
if [ $? != 0 ]; then echo regx.act note.def has errors; fi

echo ::::::::::::::
echo json5.act
echo ::::::::::::::

python ../src/main.py json5.act note.def 
if [ $? != 0 ]; then echo json5.act note.def has errors; fi

echo ::::::::::::::
echo re_sub.act
echo ::::::::::::::

python ../src/main.py re_sub.act note.def 
if [ $? != 0 ]; then echo re_sub.act note.def has errors; fi

echo ::::::::::::::
echo toggle.act doc
echo ::::::::::::::

python ../src/main.py toggle.act sample.def on off
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi

echo ::::::::::::::
echo toggle.act code
echo ::::::::::::::

python ../src/main.py toggle.act sample.def off on
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi

echo ::::::::::::::
echo toggle.act both
echo ::::::::::::::

python ../src/main.py toggle.act sample.def on on
if [ $? != 0 ]; then echo toggle.act sample.def has errors; fi

echo ::::::::::::::
echo def_unit.act
echo ::::::::::::::

python ../gen/main.py def_unit.act sample.def_unit >sample.tst_unit
if [ $? != 0 ]; then echo def_unit.act sample.def_unit has errors; fi

echo ::::::::::::::
echo def_unit.act
echo ::::::::::::::

python ../gen/main.py def_unit.act note.def_unit >note.tst_unit
if [ $? != 0 ]; then echo def_unit.act note.def_unit has errors; fi

echo ::::::::::::::
echo p_check.act sample.tst_unit
echo ::::::::::::::

python ../gen/main.py p_check.act sample.tst_unit
if [ $? != 0 ]; then echo p_check.act sample.tst_unit has errors; fi

echo ::::::::::::::
echo p_check.act note.tst_unit
echo ::::::::::::::

python ../gen/main.py p_check.act note.tst_unit
if [ $? != 0 ]; then echo p_check.act note.tst_unit has errors; fi

echo ::::::::::::::
echo doc.act concept
echo ::::::::::::::

python ../src/main.py doc.act doc.def concept
if [ $? != 0 ]; then echo doc.act doc.def has errors; fi


echo ::::::::::::::
echo concept.act index
echo ::::::::::::::

python ../src/main.py concept.act concept.def index import
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo concept.act "*"
echo ::::::::::::::

python ../src/main.py concept.act concept.def "*"
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo concept.act var,flow,cmd
echo ::::::::::::::

python ../src/main.py concept.act concept.def var,flow,cmd import
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo concept_md.act cmd
echo ::::::::::::::


python ../src/main.py concept_md.act concept.def cmd import
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi


echo ::::::::::::::
echo dot.act
echo ::::::::::::::

python ../gen/main.py dot.act ../bld2/note.unit,../bld2/app.unit,../bld2/sample.unit >unit.gv
if [ $? != 0 ]; then echo dot.act ../bld2/note.unit,../bld2/app.unit,../bld2/sample.unit has errors; fi
dot -Tjpg unit.gv >unit.jpg



