DB=postgres://postgres:zolwaq@localhost:5432/postgres

./gen match1.act note.def thinking,frame
./gen match2.act empty.def $DB "'thinking','frame'"
./gen match3.act note.def moving,frame
./gen match4.act empty.def $DB "'moving','frame'"

