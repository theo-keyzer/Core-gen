echo note.act
./gen note.act note.def
echo m.act
./gen m.act note.def info name
echo m2.act
./gen m2.act note.def info name
echo m3.act
./gen m3.act note.def info name
echo m4.act
./gen m4.act note.def info model
echo m5.act
./gen m5.act note.def pos todo
echo m6.act
./gen m6.act note.def todo pos
echo m7.act
./gen m7.act note.def pad info
echo m8.act
./gen m8.act map.def a1a a2a
echo m9.act
./gen m9.act map.def a1a x
echo m10.act
./gen m10.act map.def a1a b1a
echo m11.act
./gen m11.act map.def r z
echo m12.act note.def pos idea
./gen m12.act note.def pos idea
echo m12.act note.def idea pos
./gen m12.act note.def idea pos
echo m13.act note.def info pad
./gen m13.act note.def info pad
echo m14 note.def thinking idea pos
./gen m14.act note.def thinking idea pos
echo m15.act note.def,map.def design,a1a pos,b1a
./gen m15.act note.def,map.def design,a1a pos,b1a
echo m16.act note.def,map.def idea,thinking,design
./gen m16.act note.def,map.def idea,thinking,design
echo m17.act note.def,map.def idea,thinking,desig
./gen m17.act note.def,map.def idea,thinking,desig
echo m18.act note.def
./gen m18.act note.def
echo grid.act grid.def
./gen grid.act grid.def
echo m19.act note.def todo,ref
./gen m19.act note.def todo,ref
echo m20.act note.def todo,ref
./gen m20.act note.def todo,ref >generated.def
cat generated.def
echo m21.act note.def,generated.def
./gen m21.act note.def,generated.def
echo m22.act note.def todo,ref
./gen m22.act note.def todo,ref
echo m23.act map.def a1,q z,y,z
./gen m23.act map.def a1,q z,y,z
echo m24.act note.def,map.def
./gen m24.act note.def,map.def
echo latex.act gen.def
./gen latex.act gen.def >gen.tex
echo load.act: note.def,note.unit
./gen load.act note.def,note.unit


