# test3 has the compiled code from src and the act's from examples

./gen c_struct.act gen.unit,note.unit,act.unit >src/structs.cr
if [ $? != 0 ]; then echo c_struct.act has errors; fi

./gen c_run.act gen.unit,note.unit,act.unit >src/run.cr
if [ $? != 0 ]; then echo c_run.act has errors; fi

# crystal build src/gen.cr

