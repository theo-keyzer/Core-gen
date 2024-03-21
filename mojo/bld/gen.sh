~/dart/test3/gen c_struct.act gen.unit,act.unit >src/structs.mojo
if [ $? != 0 ]; then echo c_struct.act has errors; fi

~/dart/test3/gen c_run.act gen.unit,act.unit >src/run.mojo
if [ $? != 0 ]; then echo c_run.act has errors; fi

