echo dag2.act:
dart run ../gen/gen1/bin/main.dart dag2.act tst.def
echo dag.act:
dart run ../gen/gen1/bin/main.dart dag.act tst.def
echo json2.act:
dart run ../gen/gen1/bin/main.dart json2.act tst.def
echo json.act:
dart run ../gen/gen1/bin/main.dart json.act tst.def
echo node.act:
dart run ../gen/gen1/bin/main.dart node.act tst.def
echo tbl.act:
dart run ../gen/gen1/bin/main.dart tbl.act tst.def tb2
echo tbl2.act:
dart run ../gen/gen1/bin/main.dart tbl2.act tst.def tb2
echo tst2.act:
dart run ../gen/gen1/bin/main.dart tst2.act tst.def
echo group.act:
dart run ../gen/gen1/bin/main.dart group.act tst.def
echo hash2.act:
dart run ../gen/gen1/bin/main.dart hash2.act tst.def
echo hash.act:
dart run ../gen/gen1/bin/main.dart hash.act tst.def
echo s_check.act:
dart run ../gen/gen1/bin/main.dart s_check.act app.unit,sample.unit
echo tst3.act:
dart run ../gen/gen1/bin/main.dart tst3.act tst.def
echo tst4.act:
dart run ../gen/gen1/bin/main.dart tst4.act tst.def
echo tst5.act:
dart run ../gen/gen1/bin/main.dart tst5.act tst.def check
echo tst6.act:
dart run ../gen/gen1/bin/main.dart tst6.act tst.def 2,3,4 check
echo json3.act:
dart run ../gen/gen1/bin/main.dart json3.act tst.def
echo json.act:
dart run ../gen/gen1/bin/main.dart json4.act tst.def
echo json5.act:

dart run ../gen/gen1/bin/main.dart json5.act tst.def
if [ $? != 0 ]; then echo json5.act has errors; fi

echo yaml.act:
dart run ../gen/gen1/bin/main.dart yaml.act tst.def
echo var.act:
dart run ../gen/gen1/bin/main.dart var.act tst.def
echo xml.act:
dart run ../gen/gen1/bin/main.dart xml.act tst.def
echo def2json.act
dart run ../gen/gen1/bin/main.dart def2json.act app.unit,sample.unit,tst.def >tst_def.json
echo def2json2.act
dart run ../gen/gen1/bin/main.dart def2json2.act app.unit,sample.unit,tst.def,sample.def >tst_sample_def.json
echo def2json3.act
dart run ../gen/gen1/bin/main.dart def2json3.act gen.unit,app.unit,sample.unit >tst_sample_unit.json
echo ref.act
dart run ../gen/gen1/bin/main.dart ref.act tst.def,sample.def
echo act.act:
dart run ../gen/gen1/bin/main.dart act.act tst.def
echo cre_tbl.act: note.unit,gen.unit
dart run ../gen/gen1/bin/main.dart cre_tbl.act note.unit,gen.unit



