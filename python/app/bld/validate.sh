python ../../src/main.py p_check.act app.unit,sample.unit,note.unit,act.unit 
if [ $? != 0 ]; then echo p_check.act gen.unit,note.unit,act.unit has errors; fi

