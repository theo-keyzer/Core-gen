./gen c_struct.act app.unit,sample.unit,gen.unit,act.unit >ss
if [ $? != 0 ]; then echo c_struct.act has errors; fi

./gen c_run.act app.unit,sample.unit,gen.unit,act.unit >rr
if [ $? != 0 ]; then echo c_run.act has errors; fi


