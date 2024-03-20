
import structs,run

from inputs import StringKey, Input

#fn load(inout act: Act, inout ff: Input, tok: String, ln: Int)


fn main() raises :

    var act = structs.ActT()

    var  f = open("gen.unit", "r")
    var ff = Input( f.read() )
    for ln in range( len( ff.lines ) ):
        var tok = ff.getw( ff.lines[ln], 0 )
        run.load(act, ff, tok, ln)
    print( len( ff.lines ) )
    f.close()
    print( act.index[ "Comp_Element" ] )
    print( act.names[ "Comp_1_parent" ] )
    run.refs(act)






