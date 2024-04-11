import structs
import run
import gen
import sys

from inputs import Input

def main():
    if len(sys.argv) < 2:
        print('Missing args')
        return
    glob = gen.GlobT()
    
    fa = sys.argv[1].split(",")
    for i in range(0, len(fa) ):
        with open(fa[i], "r") as f:
            ff = Input(f.read())
    
        for ln in range(len(ff.lines)):
            tok = ff.getw(ff.lines[ln], 0)
            run.load(glob.acts, ff, tok, ln)
    
    run.refs(glob.acts)

    fa = sys.argv[2].split(",")
    for i in range(0, len(fa) ):
        with open(fa[i], "r") as f:
            ff = Input(f.read())
    
        for ln in range(len(ff.lines)):
            tok = ff.getw(ff.lines[ln], 0)
            run.load(glob.dats, ff, tok, ln)

    run.refs(glob.dats)
    dat = structs.KpArgs()
    gen.new_act(glob)
    ret = gen.go_act(dat, glob, 0)

try:
    main()
except Exception as e:
    print("An error occurred:", e)


