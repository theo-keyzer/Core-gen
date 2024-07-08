# The gen/* goes to ../gen

dart run ../gen/main.dart d_run.act gen.unit,act.unit >gen/run.dart
if [ $? != 0 ]; then echo d_run.act gen.unit,act.unit has errors; fi

dart run ../gen/main.dart d_struct.act gen.unit,act.unit >gen/structs.dart
if [ $? != 0 ]; then echo d_run.act d_struct.act gen.unit,act.unit has errors; fi



