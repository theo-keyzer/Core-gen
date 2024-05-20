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



