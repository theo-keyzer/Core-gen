echo ::::::::::::::
echo concept_md.act "*"
echo ::::::::::::::

dart run ../src/main.dart concept_md.act concept.def "*" import >concept.md
if [ $? != 0 ]; then echo concept_md.act concept.def has errors; fi

echo ::::::::::::::
echo concept.act cmd
echo ::::::::::::::

dart run ../src/main.dart concept.act concept.def cmd >cmd.html
if [ $? != 0 ]; then echo concept.act concept.def has errors; fi

echo ::::::::::::::
echo bld_doc.act
echo ::::::::::::::

dart run ../src/main.dart bld_doc.act ../bld/act.unit,../bld/act_db.unit,../bld/gen.unit,../bld/concept.unit >unit.def
if [ $? != 0 ]; then echo dart run ../src/main.dart bld_doc.act ../bld/act.unit,../bld/act_db.unit,../bld/gen.unit,../bld/concept.unit >unit.def has errors; fi

echo ::::::::::::::
echo concept.act "*"
echo ::::::::::::::

dart run ../src/main.dart concept.act concept.def,unit.def "*" >unit.html
if [ $? != 0 ]; then echo concept.act concept.def,unit.def has errors; fi

echo ::::::::::::::
echo select.act
echo ::::::::::::::

dart run ../src/main.dart select.act concept.def $PASS
if [ $? != 0 ]; then echo select.act concept.def has errors; fi

echo ::::::::::::::
echo def_unit_q.act
echo ::::::::::::::

dart run ../src/main.dart def_unit_rfl.act,def_unit_q.act note.def_unit >note.tst_unit
if [ $? != 0 ]; then echo def_unit_rfl.act,def_unit_q.act note.def_unit has errors; fi

echo ::::::::::::::
echo def_unit_m.act
echo ::::::::::::::

dart run ../src/main.dart def_unit_rfl.act sample.def_unit >sample.tst_unit
if [ $? != 0 ]; then echo def_unit_rfl.act sample.def_unit has errors; fi


#dart run ../src/main.dart gen_ins.act ../bld/concept.unit >db_ins.act
#dart run ../src/main.dart gen_sel.act ../bld/concept.unit >db_sel.act
#dart run ../src/main.dart cre_tbl.act ../bld/concept.unit $PASS
#dart run ../src/main.dart db_ins.act concept.def $PASS
#dart run ../src/main.dart db_sel.act empty.def $PASS

