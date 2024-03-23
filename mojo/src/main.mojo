
import structs,run

from inputs import StringKey, Input

#fn load(inout act: Act, inout ff: Input, tok: String, ln: Int)


fn main() raises :

    var acts = structs.ActT()
    var dats = structs.ActT()

    var  f = open("c_run.act", "r")
    var ff = Input( f.read() )
    for ln in range( len( ff.lines ) ):
        var tok = ff.getw( ff.lines[ln], 0 )
        run.load(acts, ff, tok, ln)
    f.close()
    run.refs(acts)

    f = open("gen.unit", "r")
    ff = Input( f.read() )
    for ln in range( len( ff.lines ) ):
        var tok = ff.getw( ff.lines[ln], 0 )
        run.load(dats, ff, tok, ln)
    f.close()
    run.refs(dats)




