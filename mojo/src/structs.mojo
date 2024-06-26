from collections import Dict
from collections.list import List

from inputs import StringKey, Input
from gen import GlobT, go_act

struct ActT():
    var names : Dict[String, String]
    var index : Dict[String, Int]
    var ap_comp : List[KpComp]
    var ap_element : List[KpElement]
    var ap_ref : List[KpRef]
    var ap_cmds : List[CmdT]
    var ap_actor : List[KpActor]
    var ap_all : List[KpAll]
    var ap_du : List[KpDu]
    var ap_its : List[KpIts]
    var ap_c : List[KpC]
    var ap_cs : List[KpCs]
    var ap_cf : List[KpCf]
    var ap_out : List[KpOut]
    var ap_break : List[KpBreak]
    var ap_unique : List[KpUnique]

    fn __init__(inout self):
        self.names = Dict[String, String]()
        self.index = Dict[String, Int]()
        self.ap_comp = List[KpComp]()
        self.ap_element = List[KpElement]()
        self.ap_ref = List[KpRef]()
        self.ap_cmds = List[CmdT]()
        self.ap_actor = List[KpActor]()
        self.ap_all = List[KpAll]()
        self.ap_du = List[KpDu]()
        self.ap_its = List[KpIts]()
        self.ap_c = List[KpC]()
        self.ap_cs = List[KpCs]()
        self.ap_cf = List[KpCf]()
        self.ap_out = List[KpOut]()
        self.ap_break = List[KpBreak]()
        self.ap_unique = List[KpUnique]()

@register_passable("trivial")
struct CmdT(CollectionElement):
    var cmd: StringLiteral
    var ind: Int

    fn __init__(inout self, cmd:StringLiteral, ind:Int):
        self.cmd = cmd
        self.ind = ind

trait Kp():

    fn get_me2(self) -> Int:
        ...
    fn get_var(self, act: ActT, na: List[String]) -> String:
        ...
    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        ...

@register_passable("trivial")
struct KpArgs(Kp):
    var me: Int
    var me2: Int

    fn __init__(inout self): 
        self.me = 1
        self.me2 = 1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("?")
    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@register_passable("trivial")
struct KpComp(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var k_parentp: Int
    var element_from: Int
    var element_to: Int
    var ref_from: Int
    var ref_to: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_comp )
        self.k_parentp = -1
        self.element_from = len( act.ap_element )
        self.element_to = len( act.ap_element )
        self.ref_from = len( act.ap_ref )
        self.ref_to = len( act.ap_ref )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_name" ] = na
        act.index[ "Comp_" + na ] = self.me
        act.names[ "Comp_" + String(self.me) + "_nop" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_parent" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_find" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Comp_" + String(self.me) + "_doc" ] = ff.getws( ff.lines[ln], 1 )

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:]) )
        if na[0] == "Comp_parent":
            for i in range( len(act.ap_comp) ):
                if act.ap_comp[i].k_parentp == self.me:
                    return( act.ap_comp[i].get_var(act, na[1:]) )
        if na[0] == "Ref_comp":
            for i in range( len(act.ap_ref) ):
                if act.ap_ref[i].k_compp == self.me:
                    return( act.ap_ref[i].get_var(act, na[1:]) )
        try:
            return( act.names["Comp_" + String(self.me) + "_" + na[0] ] )
        except:
            return("? Comp_" + String(self.me) + "_" + na[0] + " ?")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        if what == "Element":
            for i in range( self.element_from, self.element_to ):
                var ret = go_act(glob.dats.ap_element[i], glob, act)
                if ret != 0:
                    return(ret)
        if what == "Ref":
            for i in range( self.ref_from, self.ref_to ):
                var ret = go_act(glob.dats.ap_ref[i], glob, act)
                if ret != 0:
                    return(ret)
        if what == "parent" and self.k_parentp >= 0:
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what == "Comp_parent":
            for i in range( len( glob.dats.ap_comp ) ):
                if glob.dats.ap_comp[i].k_parentp == self.me:
                    var ret = go_act(glob.dats.ap_comp[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what == "Ref_comp":
            for i in range( len( glob.dats.ap_ref ) ):
                if glob.dats.ap_ref[i].k_compp == self.me:
                    var ret = go_act(glob.dats.ap_ref[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

@register_passable("trivial")
struct KpElement(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_element )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_name" ] = na
        act.names[ "Element_" + String(self.me) + "_mw" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_mw2" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_pad" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_doc" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].element_to = self.me + 1
            self.parentp = i-1
            var s = String(self.parentp) + "_Element_" + na
            act.index[ s ] = self.me

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_comp[ self.parentp ].get_var(act, na[1:]) )
        if na[0] == "Ref_element":
            for i in range( len(act.ap_ref) ):
                if act.ap_ref[i].k_elementp == self.me:
                    return( act.ap_ref[i].get_var(act, na[1:]) )
        try:
            return( act.names["Element_" + String(self.me) + "_" + na[0] ] )
        except:
            return("? Element_" + String(self.me) + "_" + na[0] + " ?")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        if what == "parent" and self.parentp >= 0:
            return( go_act(glob.dats.ap_comp[ self.parentp ], glob, act) )
        if what == "Ref_element":
            for i in range( len( glob.dats.ap_ref ) ):
                if glob.dats.ap_ref[i].k_elementp == self.me:
                    var ret = go_act(glob.dats.ap_ref[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

@register_passable("trivial")
struct KpRef(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_elementp: Int
    var k_compp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_ref )
        self.k_elementp = -1
        self.k_compp = -1
        act.names[ "Ref_" + String(self.me) + "_element" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_opt" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_var" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_doc" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].ref_to = self.me + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        if na[0] == "element" and len(na) > 1 and self.k_elementp >= 0:
            return( act.ap_element[ self.k_elementp ].get_var(act, na[1:]) )
        if na[0] == "comp" and len(na) > 1 and self.k_compp >= 0:
            return( act.ap_comp[ self.k_compp ].get_var(act, na[1:]) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_comp[ self.parentp ].get_var(act, na[1:]) )
        try:
            return( act.names["Ref_" + String(self.me) + "_" + na[0] ] )
        except:
            return("? Ref_" + String(self.me) + "_" + na[0] + " ?")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        if what == "parent" and self.parentp >= 0:
            return( go_act(glob.dats.ap_comp[ self.parentp ], glob, act) )
        if what == "element" and self.k_elementp >= 0:
            return( go_act(glob.dats.ap_element[ self.k_elementp ], glob, act) )
        if what == "comp" and self.k_compp >= 0:
            return( go_act(glob.dats.ap_comp[ self.k_compp ], glob, act) )
        return(0)

@value
struct KpActor(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var cmds_from: Int
    var cmds_to: Int
    var k_name: String
    var k_comp: String
    var k_attr: String
    var k_eq: String
    var k_value: String
    var k_cc: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_actor )
        self.cmds_from = len( act.ap_cmds )
        self.cmds_to = len( act.ap_cmds )
        self.k_name = ff.getw( ff.lines[ln], 1 )
        act.index[ "Actor_" + self.k_name ] = self.me
        self.k_comp = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_cc = ff.getws( ff.lines[ln], 1 )

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpAll(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_what: String
    var k_actor: String
    var k_attr: String
    var k_eq: String
    var k_value: String
    var k_args: String
    var k_actorp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_all )
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpDu(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_actor: String
    var k_attr: String
    var k_eq: String
    var k_value: String
    var k_args: String
    var k_actorp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_du )
        self.k_actorp = -1
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpIts(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_what: String
    var k_actor: String
    var k_attr: String
    var k_eq: String
    var k_value: String
    var k_args: String
    var k_actorp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_its )
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpC(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_desc: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_c )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpCs(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_desc: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_cs )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpCf(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_desc: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_cf )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpOut(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_what: String
    var k_pad: String
    var k_desc: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_out )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpBreak(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_what: String
    var k_pad: String
    var k_actor: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_break )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

@value
struct KpUnique(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_cmd: String
    var k_key: String
    var k_value: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_unique )
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_key = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: List[String]) -> String:
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int) -> Int:
        return(0)

