# test3 has the compiled code from src and the act's from examples

../test3/gen ../test3/c_struct.act note.unit,../test3/act.unit,../test3/gen.unit >src/structs.cr
if [ $? != 0 ]; then echo c_struct.act has errors; fi

../test3/gen ../test3/c_run.act note.unit,../test3/act.unit,../test3/gen.unit >src/run.cr
if [ $? != 0 ]; then echo c_run.act has errors; fi

# crystal build src/gen.cr

