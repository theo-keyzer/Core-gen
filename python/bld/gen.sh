python ../src/main.py p_struct.act gen.unit,act.unit >src/structs.py
if [ $? != 0 ]; then echo p_struct.act gen.unit,act.unit has errors; fi

python ../src/main.py p_run.act gen.unit,act.unit >src/run.py
if [ $? != 0 ]; then echo p_run.act gen.unit,act.unit has errors; fi

python ../src/main.py p_grammer.act gen.unit,act.unit >src/units.lark
if [ $? != 0 ]; then echo p_grammer.act gen.unit,act.unit has errors; fi

python ../src/main.py p_gram_tree.act gen.unit,act.unit >src/units_tree.lark
if [ $? != 0 ]; then echo p_gram_tree.act gen.unit,act.unit has errors; fi

python ../src/main.py p_parser.act gen.unit,act.unit >src/units.py
if [ $? != 0 ]; then echo p_parser.act gen.unit,act.unit has errors; fi

python ../src/main.py p_parser_tree.act gen.unit,act.unit >src/units_tree.py
if [ $? != 0 ]; then echo p_parser_tree.act gen.unit,act.unit has errors; fi

