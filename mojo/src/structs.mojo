from collections import Dict, DynamicVector

from inputs import StringKey, Input


struct ActT():
    var names : Dict[StringKey, String]
    var index : Dict[StringKey, Int]
    var ap_comp : DynamicVector[KpComp]
    var ap_token : DynamicVector[KpToken]
    var ap_star : DynamicVector[KpStar]
    var ap_element : DynamicVector[KpElement]
    var ap_opt : DynamicVector[KpOpt]
    var ap_ref : DynamicVector[KpRef]
    var ap_ref2 : DynamicVector[KpRef2]
    var ap_ref3 : DynamicVector[KpRef3]
    var ap_refq : DynamicVector[KpRefq]

    fn __init__(inout self):
        self.names = Dict[StringKey, String]()
        self.index = Dict[StringKey, Int]()
        self.ap_comp = DynamicVector[KpComp]()
        self.ap_token = DynamicVector[KpToken]()
        self.ap_star = DynamicVector[KpStar]()
        self.ap_element = DynamicVector[KpElement]()
        self.ap_opt = DynamicVector[KpOpt]()
        self.ap_ref = DynamicVector[KpRef]()
        self.ap_ref2 = DynamicVector[KpRef2]()
        self.ap_ref3 = DynamicVector[KpRef3]()
        self.ap_refq = DynamicVector[KpRefq]()


trait Kp():

   fn get_var(self):
       ...

@register_passable("trivial")
struct KpComp(Kp,CollectionElement):
    var me: Int
    var token_from: Int
    var token_to: Int
    var element_from: Int
    var element_to: Int
    var ref_from: Int
    var ref_to: Int
    var ref2_from: Int
    var ref2_to: Int
    var ref3_from: Int
    var ref3_to: Int
    var refq_from: Int
    var refq_to: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_comp )
        self.token_from = len( act.ap_token )
        self.token_to = len( act.ap_token )
        self.element_from = len( act.ap_element )
        self.element_to = len( act.ap_element )
        self.ref_from = len( act.ap_ref )
        self.ref_to = len( act.ap_ref )
        self.ref2_from = len( act.ap_ref2 )
        self.ref2_to = len( act.ap_ref2 )
        self.ref3_from = len( act.ap_ref3 )
        self.ref3_to = len( act.ap_ref3 )
        self.refq_from = len( act.ap_refq )
        self.refq_to = len( act.ap_refq )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_name" ] = na
        act.index[ "Comp_" + na ] = self.me
        act.names[ "Comp_" + String(self.me) + "_nop" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_parent" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_find" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )

    fn get_var(self):
       return

@register_passable("trivial")
struct KpToken(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_token )
        act.names[ "Token_" + String(self.me) + "_token" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].token_to = self.me + 1

    fn get_var(self):
       return

@register_passable("trivial")
struct KpStar(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_star )
        act.names[ "Star_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )

    fn get_var(self):
       return

@register_passable("trivial")
struct KpElement(Kp,CollectionElement):
    var me: Int
    var opt_from: Int
    var opt_to: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_element )
        self.opt_from = len( act.ap_opt )
        self.opt_to = len( act.ap_opt )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_name" ] = na
        act.names[ "Element_" + String(self.me) + "_mw" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_mw2" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_pad" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].element_to = self.me + 1

    fn get_var(self):
       return

@register_passable("trivial")
struct KpOpt(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_opt )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Opt_" + String(self.me) + "_name" ] = na
        act.names[ "Opt_" + String(self.me) + "_pad" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Opt_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_element )
        if i > 0:
            act.ap_element[i-1].opt_to = self.me + 1

    fn get_var(self):
       return

@register_passable("trivial")
struct KpRef(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_ref )
        act.names[ "Ref_" + String(self.me) + "_element" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_opt" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_var" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].ref_to = self.me + 1

    fn get_var(self):
       return

@register_passable("trivial")
struct KpRef2(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_ref2 )
        act.names[ "Ref2_" + String(self.me) + "_element" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref2_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref2_" + String(self.me) + "_element2" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref2_" + String(self.me) + "_opt" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref2_" + String(self.me) + "_var" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref2_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].ref2_to = self.me + 1

    fn get_var(self):
       return

@register_passable("trivial")
struct KpRef3(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_ref3 )
        act.names[ "Ref3_" + String(self.me) + "_element" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_element2" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_comp_ref" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_element3" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_opt" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_var" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref3_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].ref3_to = self.me + 1

    fn get_var(self):
       return

@register_passable("trivial")
struct KpRefq(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_refq )
        act.names[ "Refq_" + String(self.me) + "_element" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Refq_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Refq_" + String(self.me) + "_element2" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Refq_" + String(self.me) + "_comp_ref" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Refq_" + String(self.me) + "_opt" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Refq_" + String(self.me) + "_var" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Refq_" + String(self.me) + "_doc" ] = ff.getw( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].refq_to = self.me + 1

    fn get_var(self):
       return

