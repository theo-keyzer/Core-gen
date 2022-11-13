../gen s_check.act sample.unit,act.unit 
if [ $? != 0 ]; then echo s_check.act has errors; fi

../gen c_struct.act sample.unit,act.unit >src/struct.cr
if [ $? != 0 ]; then echo c_struct.act has errors; fi

../gen c_run.act sample.unit,act.unit >src/run.cr
if [ $? != 0 ]; then echo c_run.act has errors; fi

