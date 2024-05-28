# The src2/* goes to ../gen
# Need to have a backup of the presious version
# This will not work if the ../gen is broken.

python ../gen/main.py p_struct.act gen.unit,act.unit >src2/structs.py
if [ $? != 0 ]; then echo p_struct.act gen.unit,act.unit has errors; fi

python ../gen/main.py p_run.act gen.unit,act.unit >src2/run.py
if [ $? != 0 ]; then echo p_run.act gen.unit,act.unit has errors; fi


