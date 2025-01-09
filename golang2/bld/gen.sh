# The gen/* goes to ../gen

dart run ~/dart/Dart2/gen/main.dart g_run.act gen.unit,act.unit >gen/run.go
if [ $? != 0 ]; then echo g_run.act gen.unit,act.unit has errors; fi

dart run ~/dart/Dart2/gen/main.dart g_struct.act gen.unit,act.unit >gen/structs.go
if [ $? != 0 ]; then echo d_run.act g_struct.act gen.unit,act.unit has errors; fi



