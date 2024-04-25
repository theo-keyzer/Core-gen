python ../../src/main.py p_struct.act app.unit,sample.unit,note.unit,act.unit >src/structs.py
if [ $? != 0 ]; then echo p_struct.act gen.unit,note.unit,act.unit has errors; fi

python ../../src/main.py p_run.act app.unit,sample.unit,note.unit,act.unit >src/run.py
if [ $? != 0 ]; then echo p_run.act gen.unit,note.unit,act.unit has errors; fi

python ../../src/main.py p_grammer.act app.unit,sample.unit,act.unit >src/units.lark
if [ $? != 0 ]; then echo p_grammer.act app.unit,sample.unit,act.unit has errors; fi

python ../../src/main.py p_parser.act app.unit,sample.unit,act.unit >src/units.py
if [ $? != 0 ]; then echo p_parser.act app.unit,sample.unit,act.unit has errors; fi

python ../../src/main.py p_gram_tree.act app.unit,sample.unit,act.unit >src/units_tree.lark
if [ $? != 0 ]; then echo p_gram_tree.act app.unit,sample.unit,act.unit has errors; fi

python ../../src/main.py p_parser_tree.act app.unit,sample.unit,act.unit >src/units_tree.py
if [ $? != 0 ]; then echo p_parser_tree.act app.unit,sample.unit,act.unit has errors; fi

