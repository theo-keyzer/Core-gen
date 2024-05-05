import structs
import run
#import gen
import sys

from inputs import Input

def main():
    if len(sys.argv) < 1:
        print('Missing args')
        return
    glob = structs.GlobT()
    

    fa = sys.argv[1].split(",")
    for i in range(0, len(fa) ):
        with open(fa[i], "r") as f:
            ff = Input(f.read())
    
        for ln in range(len(ff.lines)):
            lno = fa[i] + ":" + str(ln+1)
            tok = ff.getw(ff.lines[ln], 0)
            if tok == "E_O_F":
                break
            run.load(glob.dats, ff, tok, ln, lno)

    err = run.refs(glob.dats)
    if err:
        glob.load_errs = True

    dat = structs.KpArgs()
    for i in range(0, len(sys.argv) ):
        dat.names[ str(i) ] = sys.argv[i]

#    gen.new_act(glob, "")
#    ret = gen.go_act(dat, glob, 0)

    domains = structs.do_all(glob, ["Domain"], 0)
    for domain in domains:
        models = domain.get_list(glob, ["Model", "Frame", "A"], 0)
        for model in models:
            for frame in model:
                for k_a in frame:
                    vname = k_a.get_var(glob.dats, ["name"], lno)
                    vmodel = k_a.get_var(glob.dats, ["model", "name"], lno)
                    vdomain = k_a.get_var(glob.dats, ["domain","name"], lno)
                    vinfo = k_a.get_var(glob.dats, ["model", "info"], str( sys._getframe().f_lineno ) )
                    if vmodel[1] == True:
                        continue
                    print( vname[0] + " " + vdomain[0] + " " + vmodel[0] + " - " + vinfo[0] )
    if glob.load_errs or glob.run_errs:
        print('Errors')
        sys.exit(1)
try:
    main()
except Exception as e:
    print("An error occurred:", e)




