library gen;
import 'dart:io';

part 'structs.dart';
part 'run.dart';
part 'gen.dart';

void main(List<String> args) 
{
	if (args.length < 2) {
		print(args);
		return;
	}
	var glob = new GlobT();
	glob.load_errs |= load_files(args[0], glob.acts);
	glob.load_errs |= load_files(args[1], glob.dats);
	if (glob.acts.ap_actor.length > 0) {
		var kp = new Kp();
		for(var i = 0; i < args.length; i++) {
			kp.names[ i.toString() ] = args[i];
		}
		new_act(glob, glob.acts.ap_actor[0].k_name, "", "run:1", "", "", "");
		go_act(glob, kp);
	}
	print(glob.buffer);
	if (glob.load_errs == true || glob.run_errs == true) {
		print("Errors");
		exit(1);
	}

}

bool load_files(files, act)
{
	var errs = false;
	var fa = files.split(",");
	for(var file in fa) {
		List<String> lns = new File(file).readAsLinesSync();
		errs |= load_data(lns, act,file);
	}
	errs |= refs(act);
	return(errs);
}


