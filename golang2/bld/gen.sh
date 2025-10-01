# The gen/* goes to ../gen

go run ../gen/main.go ../gen/gen.go ../gen/run.go ../gen/structs.go  ../gen/collect.go g_run.act gen.unit,act.unit >gen/run.go
if [ $? != 0 ]; then echo g_run.act gen.unit,act.unit has errors; fi

go run ../gen/main.go ../gen/gen.go ../gen/run.go ../gen/structs.go  ../gen/collect.go g_struct.act gen.unit,act.unit >gen/structs.go
if [ $? != 0 ]; then echo g_struct.act gen.unit,act.unit has errors; fi



