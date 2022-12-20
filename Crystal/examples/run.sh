echo dag2.act:
./gen dag2.act tst.def
echo dag.act:
./gen dag.act tst.def
echo json2.act:
./gen json2.act tst.def
echo json.act:
./gen json.act tst.def
echo node.act:
./gen node.act tst.def
echo tbl.act:
./gen tbl.act tst.def tb2
echo tbl2.act:
./gen tbl2.act tst.def tb2
echo tst2.act:
./gen tst2.act tst.def
echo group.act:
./gen group.act tst.def
echo hash2.act:
./gen hash2.act tst.def
echo hash.act:
./gen hash.act tst.def
echo s_check.act:
./gen s_check.act app.unit,sample.unit
echo tst3.act:
./gen tst3.act tst.def
echo tst4.act:
./gen tst4.act tst.def
echo tst5.act:
./gen tst5.act tst.def check
echo tst6.act:
./gen tst6.act tst.def 2,3,4 check
echo json3.act:
./gen json3.act tst.def
echo json.act:
./gen json4.act tst.def
echo json5.act:

./gen json5.act tst.def
if [ $? != 0 ]; then echo json5.act has errors; fi

echo yaml.act:
./gen yaml.act tst.def
echo var.act:
./gen var.act tst.def
echo xml.act:
./gen xml.act tst.def
echo def2json.act
./gen def2json.act app.unit,sample.unit,tst.def >tst_def.json
echo def2json2.act
./gen def2json2.act app.unit,sample.unit,tst.def,sample.def >tst_sample_def.json
echo def2json3.act
./gen def2json3.act gen.unit,app.unit,sample.unit >tst_sample_unit.json
echo ref.act
./gen ref.act tst.def,sample.def
echo act.act:
./gen act.act tst.def
echo cre_tbl.act: note.unit,gen.unit
./gen cre_tbl.act note.unit,gen.unit


