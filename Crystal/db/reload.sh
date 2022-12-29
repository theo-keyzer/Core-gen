DB=postgres://postgres:zolwaq@localhost:5432/postgres

./gen delete2.act note.def $DB
./gen load3.act note.def $DB
./gen update_ref2.act note.def $DB


