~/crystal/test3/gen d_struct.act gen.unit,act.unit,app.unit,sample.unit,note.unit >gen1/bin/structs.dart
if [ $? != 0 ]; then echo c_struct.act has errors; fi

~/crystal/test3/gen d_run.act gen.unit,act.unit,app.unit,sample.unit,note.unit >gen1/bin/run.dart
if [ $? != 0 ]; then echo c_run.act has errors; fi


