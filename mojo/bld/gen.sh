~/dart/test3/gen c_struct.act gen.unit >src/structs.mojo
if [ $? != 0 ]; then echo c_struct.act has errors; fi

