python ../src/main.py mtst.act note.def

python ../src/main.py match1.act note.def thinking,frame,group,join,layout

python ../src/main.py daoimpl.act sample.def >user.java
python ../src/main.py view.act sample.def >user.sql

python ../src/main.py  dag.act tst.def
python ../src/main.py tst2.act tst.def,sample.def a b c d

python ../src/main.py md.act gen.def >gen.md
python ../src/main.py latex.act gen.def >gen.tex
python ../src/main.py grid.act grid.def

