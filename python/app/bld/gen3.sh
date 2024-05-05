python ../../src/main.py p_struct2.act app.unit,sample.unit,note.unit,act.unit >src3/structs.py
if [ $? != 0 ]; then echo p_struct.act gen.unit,note.unit,act.unit has errors; fi

python ../../src/main.py p_run.act app.unit,sample.unit,note.unit,act.unit >src3/run.py
if [ $? != 0 ]; then echo p_run.act gen.unit,note.unit,act.unit has errors; fi


