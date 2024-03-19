
import structs

from inputs import StringKey, Input



fn main() raises :

    var act = structs.ActT()

    var  f = open("gen.unit", "r")
    var ff = Input( f.read() )
    for ln in range( len( ff.lines ) ):
        var tok = ff.getw( ff.lines[ln], 0 )
        if tok == "Comp":
            var kp = structs.KpComp(ff, ln, act)
            act.ap_comp.push_back(kp)
        if tok == "Element":
            var kp = structs.KpElement(ff, ln, act)
            act.ap_element.push_back(kp)
    print( len( ff.lines ) )
    f.close()
    print( act.index[ "Comp_Element" ] )
    print( act.names[ "Comp_1_parent" ] )






