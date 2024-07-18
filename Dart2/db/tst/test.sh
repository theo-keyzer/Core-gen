echo ::::::::::::::
echo concept_md.act "*"
echo ::::::::::::::

dart run ../src/main.dart concept_md.act concept.def "*" import >concept.md
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi

echo ::::::::::::::
echo select.act
echo ::::::::::::::

dart run ../src/main.dart select.act concept.def $PASS
if [ $? != 0 ]; then echo select.act concept.def has errors; fi

