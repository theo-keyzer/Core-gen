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

    domains = structs.do_all(glob, ["Domain"], 0)
    for domain in domains:
        k_as = domain.get_list(glob, ["Model", "Frame", "A"], 0)
        for k_a in k_as:
            vmodel = k_a.get_var(glob.dats, ["model", "name"], lno)
            if vmodel[1] == True:
                continue
            vname = v(glob, k_a, "name")
            vdomain = v(glob, k_a, "domain.name")
            vinfo = v(glob, k_a, "model.info")
            print( vname + " " + vdomain + " " + vmodel[0] + " - " + vinfo )

    if glob.load_errs or glob.run_errs:
        print('Errors')
        sys.exit(1)

def v(glob,kp,name) -> str:
    lno = str( sys._getframe().f_back.f_lineno )
    names = name.split('.')
    val = kp.get_var(glob.dats, names, lno)
    return( val[0] )

try:
    main()
except Exception as e:
    print("An error occurred:", e)


# str( sys._getframe().f_lineno )
# str( sys._getframe().f_back.f_lineno )


