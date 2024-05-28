python ../gen/main.py p_struct2.act app.unit,sample.unit,note.unit,act.unit >src3/structs.py
if [ $? != 0 ]; then echo p_struct2.act app.unit,sample.unit,note.unit,act.unit has errors; fi

python ../gen/main.py p_run.act app.unit,sample.unit,note.unit,act.unit >src3/run.py
if [ $? != 0 ]; then echo p_run.act app.unit,sample.unit,note.unit,act.unit has errors; fi

python ../gen/main.py p_grammer.act app.unit,sample.unit,act.unit >src3/units.lark
if [ $? != 0 ]; then echo p_grammer.act app.unit,sample.unit,act.unit has errors; fi

python ../gen/main.py p_parser.act app.unit,sample.unit,act.unit >src3/units.py
if [ $? != 0 ]; then echo p_parser.act app.unit,sample.unit,act.unit has errors; fi

python ../gen/main.py p_gram_tree.act app.unit,sample.unit,act.unit >src3/units_tree.lark
if [ $? != 0 ]; then echo p_gram_tree.act app.unit,sample.unit,act.unit has errors; fi

python ../gen/main.py p_parser_tree.act app.unit,sample.unit,act.unit >src3/units_tree.py
if [ $? != 0 ]; then echo p_parser_tree.act app.unit,sample.unit,act.unit has errors; fi

