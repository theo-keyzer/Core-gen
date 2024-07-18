# The src/* goes to ../src

dart run ../gen/main.dart d_run.act sample.unit,app.unit,note.unit,act.unit,gen.unit >src/run.dart
if [ $? != 0 ]; then echo d_run.act sample.unit,app.unit,note.unit,act.unit,gen.unit has errors; fi

dart run ../gen/main.dart d_struct.act sample.unit,app.unit,note.unit,act.unit,gen.unit >src/structs.dart
if [ $? != 0 ]; then echo d_struct.act sample.unit,app.unit,note.unit,act.unit,gen.unit has errors; fi

