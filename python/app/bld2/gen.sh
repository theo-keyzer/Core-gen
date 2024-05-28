# The src/* goes to ../src

python ../gen/main.py p_struct.act app.unit,sample.unit,note.unit,act.unit >src/structs.py
if [ $? != 0 ]; then echo p_struct.act app.unit,sample.unit,note.unit,act.unit has errors; fi

python ../gen/main.py p_run.act app.unit,sample.unit,note.unit,act.unit >src/run.py
if [ $? != 0 ]; then echo p_run.act app.unit,sample.unit,note.unit,act.unit has errors; fi


