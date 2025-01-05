# The gen/* goes to ../gen

dart run ~/dart/Dart2/gen/main.dart g_run.act gen.unit,act.unit >gen/run.dart
if [ $? != 0 ]; then echo g_run.act gen.unit,act.unit has errors; fi

dart run ~/dart/Dart2/gen/main.dart g_struct.act gen.unit,act.unit >gen/structs.dart
if [ $? != 0 ]; then echo d_run.act g_struct.act gen.unit,act.unit has errors; fi



