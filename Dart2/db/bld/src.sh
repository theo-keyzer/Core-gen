# The src/* goes to ../src

dart run ../../gen/main.dart d_run.act concept.unit,act.unit,act_db.unit,gen.unit >src/run.dart
if [ $? != 0 ]; then echo d_run.act concept.unit,act.unit,act_db.unit,gen.unit has errors; fi

dart run ../../gen/main.dart d_struct.act concept.unit,act.unit,act_db.unit,gen.unit >src/structs.dart
if [ $? != 0 ]; then echo d_struct.act concept.unit,act.unit,act_db.unit,gen.unit has errors; fi


