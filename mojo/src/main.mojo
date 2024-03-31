
import structs,run,gen

from inputs import Input

fn main() raises :

    var glob = gen.GlobT()
    var  f = open("c_struct.act", "r")
    var ff = Input( f.read() )
    f.close()
    for ln in range( len( ff.lines ) ):
        var tok = ff.getw( ff.lines[ln], 0 )
        run.load(glob.acts, ff, tok, ln)
    run.refs(glob.acts)

    f = open("gen.unit", "r")
    ff = Input( f.read() )
    f.close()
    for ln in range( len( ff.lines ) ):
        var tok = ff.getw( ff.lines[ln], 0 )
        run.load(glob.dats, ff, tok, ln)
    run.refs(glob.dats)
    var dat = structs.KpArgs()
    gen.new_act(glob)
    gen.go_act(dat,glob, 0)


