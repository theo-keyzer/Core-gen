import structs
import run
import gen
import sys

from inputs import Input

def main():
    if len(sys.argv) < 2:
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
            run.load(glob.acts, ff, tok, ln, lno)
    
    err = run.refs(glob.acts)
    if err:
        glob.load_errs = True

    if len( glob.acts.ap_actor ) == 0:
        print("No actor to run")
        return

    fa = sys.argv[2].split(",")
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
    gen.new_act(glob)
    ret = gen.go_act(dat, glob, 0)
    if glob.load_errs or glob.run_errs:
        print('Errors')
        sys.exit(1)
try:
    main()
except Exception as e:
    print("An error occurred:", e)


