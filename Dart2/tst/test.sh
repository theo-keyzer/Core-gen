echo ::::::::::::::
echo concept_md.act "*"
echo ::::::::::::::


dart run ../src/main.dart concept_md.act concept.def "*" import >concept.md
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi


echo ::::::::::::::
echo collect.act
echo ::::::::::::::


dart run ../src/main.dart collect.act concept.def 
if [ $? != 0 ]; then echo collect.act concept.def has errors; fi


