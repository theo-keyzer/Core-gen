# The src/* goes to ../src

dart run ~/dart/Dart2/gen/main.dart  g_run.act sample.unit,app.unit,note.unit,act.unit,gen.unit >src/run.dart
if [ $? != 0 ]; then echo g_run.act sample.unit,app.unit,note.unit,act.unit,gen.unit has errors; fi

dart run ~/dart/Dart2/gen/main.dart  g_struct.act sample.unit,app.unit,note.unit,act.unit,gen.unit >src/structs.dart
if [ $? != 0 ]; then echo g_struct.act sample.unit,app.unit,note.unit,act.unit,gen.unit has errors; fi


