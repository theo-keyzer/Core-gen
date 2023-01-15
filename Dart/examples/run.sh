dart run gen1/bin/gen.dart d_run.act gen.unit,act.unit >rr
dart run gen1/bin/gen.dart d_struct.act gen.unit,act.unit >ss

diff ss gen1/bin/structs.dart

