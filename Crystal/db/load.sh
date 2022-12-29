DB=postgres://postgres:abwsos@localhost:5432/postgres

./gen drop.act empty.def $DB
./gen cre_tbl3.act note.def $DB
./gen load3.act note.def $DB
./gen select2.act empty.def $DB
./gen update_ref.act empty.def $DB

#./gen delete.act empty.def

