~/dart/test3/gen p_struct.act gen.unit,act.unit >src2/structs.py
if [ $? != 0 ]; then echo c_struct.act has errors; fi

~/dart/test3/gen p_run.act gen.unit,act.unit >src2/run.py
if [ $? != 0 ]; then echo c_run.act has errors; fi

