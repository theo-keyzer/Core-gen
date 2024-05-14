python ../src/main.py mtst.act note.def
if [ $? != 0 ]; then echo mtst.act note.def has errors; fi

python ../src/main.py match1.act note.def thinking,frame,group,join,layout
if [ $? != 0 ]; then echo match1.act note.def has errors; fi

python ../src/main.py match2.act note.def thinking,frame group,join,layout
if [ $? != 0 ]; then echo match2.act note.def has errors; fi

python ../src/main.py match3.act note.def thinking,frame group,join layout
if [ $? != 0 ]; then echo match3.act note.def has errors; fi

python ../src/main.py daoimpl.act sample.def >user.java
if [ $? != 0 ]; then echo daoimpl.act sample.def has errors; fi

python ../src/main.py view.act sample.def >user.sql
if [ $? != 0 ]; then echo view.act sample.def has errors; fi

python ../src/main.py  dag.act tst.def
if [ $? != 0 ]; then echo dag.act tst.def has errors; fi

python ../src/main.py tst2.act tst.def,sample.def a b c d
if [ $? != 0 ]; then echo tst2.act tst.def,sample.def has errors; fi

python ../src/main.py md.act gen.def >gen.md
if [ $? != 0 ]; then echo md.act gen.def has errors; fi

python ../src/main.py latex.act gen.def >gen.tex
if [ $? != 0 ]; then echo latex.act gen.def has errors; fi

python ../src/main.py grid.act grid.def
if [ $? != 0 ]; then echo grid.act grid.def has errors; fi

