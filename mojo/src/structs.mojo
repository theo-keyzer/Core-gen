from collections import Dict, DynamicVector

from inputs import StringKey, Input
from gen import GlobT, go_act

struct ActT():
    var names : Dict[StringKey, String]
    var index : Dict[StringKey, Int]
    var ap_comp : DynamicVector[KpComp]
    var ap_element : DynamicVector[KpElement]
    var ap_ref : DynamicVector[KpRef]
    var ap_cmds : DynamicVector[CmdT]
    var ap_actor : DynamicVector[KpActor]
    var ap_all : DynamicVector[KpAll]
    var ap_du : DynamicVector[KpDu]
    var ap_its : DynamicVector[KpIts]
    var ap_c : DynamicVector[KpC]
    var ap_cs : DynamicVector[KpCs]
    var ap_out : DynamicVector[KpOut]
    var ap_break : DynamicVector[KpBreak]
    var ap_unique : DynamicVector[KpUnique]

    fn __init__(inout self):
        self.names = Dict[StringKey, String]()
        self.index = Dict[StringKey, Int]()
        self.ap_comp = DynamicVector[KpComp]()
        self.ap_element = DynamicVector[KpElement]()
        self.ap_ref = DynamicVector[KpRef]()
        self.ap_cmds = DynamicVector[CmdT]()
        self.ap_actor = DynamicVector[KpActor]()
        self.ap_all = DynamicVector[KpAll]()
        self.ap_du = DynamicVector[KpDu]()
        self.ap_its = DynamicVector[KpIts]()
        self.ap_c = DynamicVector[KpC]()
        self.ap_cs = DynamicVector[KpCs]()
        self.ap_out = DynamicVector[KpOut]()
        self.ap_break = DynamicVector[KpBreak]()
        self.ap_unique = DynamicVector[KpUnique]()

@register_passable("trivial")
struct CmdT(CollectionElement):
    var cmd: StringLiteral
    var ind: Int

    fn __init__(inout self, cmd:StringLiteral, ind:Int):
        self.cmd = cmd
        self.ind = ind

trait Kp():

    fn get_var(self, act: ActT, na: String) -> String:
        ...
    fn do_its(self, glob: GlobT, what: String, act: Int):
        ...

@register_passable("trivial")
struct KpArgs(Kp):
    var me: Int

    fn __init__(inout self): 
        self.me = 1

    fn get_var(self, act: ActT, na: String) -> String:
        return("?")
    fn do_its(self, glob: GlobT, what: String, act: Int):
        return
@register_passable("trivial")
struct KpComp(Kp,CollectionElement):
    var me: Int
    var k_parentp: Int
    var element_from: Int
    var element_to: Int
    var ref_from: Int
    var ref_to: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Comp_" + String(self.me) + "_" + na ] )
        except:
           print("except Comp_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        if what == "Element":
            for i in range( self.element_from, self.element_to ):
                go_act(glob.dats.ap_element[i], glob, act)
        if what == "Ref":
            for i in range( self.ref_from, self.ref_to ):
                go_act(glob.dats.ap_ref[i], glob, act)
        return

@register_passable("trivial")
struct KpElement(Kp,CollectionElement):
    var me: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_element )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_name" ] = na
        act.names[ "Element_" + String(self.me) + "_mw" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_mw2" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_pad" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Element_" + String(self.me) + "_doc" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].element_to = self.me + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Element_" + String(self.me) + "_" + na ] )
        except:
           print("except Element_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpRef(Kp,CollectionElement):
    var me: Int
    var k_elementp: Int
    var k_compp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_ref )
        self.k_elementp = -1
        self.k_compp = -1
        act.names[ "Ref_" + String(self.me) + "_element" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_opt" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_var" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Ref_" + String(self.me) + "_doc" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].ref_to = self.me + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Ref_" + String(self.me) + "_" + na ] )
        except:
           print("except Ref_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpActor(Kp,CollectionElement):
    var me: Int
    var cmds_from: Int
    var cmds_to: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me = len( act.ap_actor )
        self.cmds_from = len( act.ap_cmds )
        self.cmds_to = len( act.ap_cmds )
        var na = ff.getw( ff.lines[ln], 1 )
        act.names[ "Actor_" + String(self.me) + "_name" ] = na
        act.index[ "Actor_" + na ] = self.me
        act.names[ "Actor_" + String(self.me) + "_comp" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Actor_" + String(self.me) + "_attr" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Actor_" + String(self.me) + "_eq" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Actor_" + String(self.me) + "_value" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Actor_" + String(self.me) + "_cc" ] = ff.getws( ff.lines[ln], 1 )

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Actor_" + String(self.me) + "_" + na ] )
        except:
           print("except Actor_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpAll(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var k_actorp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_all )
        self.k_actorp = -1
        act.names[ "All_" + String(self.me) + "_what" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "All_" + String(self.me) + "_actor" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "All_" + String(self.me) + "_attr" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "All_" + String(self.me) + "_eq" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "All_" + String(self.me) + "_value" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "All_" + String(self.me) + "_args" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["All_" + String(self.me) + "_" + na ] )
        except:
           print("except All_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpDu(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var k_actorp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_du )
        self.k_actorp = -1
        act.names[ "Du_" + String(self.me) + "_actor" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Du_" + String(self.me) + "_attr" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Du_" + String(self.me) + "_eq" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Du_" + String(self.me) + "_value" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Du_" + String(self.me) + "_args" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Du_" + String(self.me) + "_" + na ] )
        except:
           print("except Du_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpIts(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var k_actorp: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_its )
        self.k_actorp = -1
        act.names[ "Its_" + String(self.me) + "_what" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Its_" + String(self.me) + "_actor" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Its_" + String(self.me) + "_attr" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Its_" + String(self.me) + "_eq" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Its_" + String(self.me) + "_value" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Its_" + String(self.me) + "_args" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Its_" + String(self.me) + "_" + na ] )
        except:
           print("except Its_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpC(Kp,CollectionElement):
    var me: Int
    var me2: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_c )
        act.names[ "C_" + String(self.me) + "_desc" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["C_" + String(self.me) + "_" + na ] )
        except:
           print("except C_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpCs(Kp,CollectionElement):
    var me: Int
    var me2: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_cs )
        act.names[ "Cs_" + String(self.me) + "_desc" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Cs_" + String(self.me) + "_" + na ] )
        except:
           print("except Cs_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpOut(Kp,CollectionElement):
    var me: Int
    var me2: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_out )
        act.names[ "Out_" + String(self.me) + "_what" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Out_" + String(self.me) + "_pad" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Out_" + String(self.me) + "_desc" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Out_" + String(self.me) + "_" + na ] )
        except:
           print("except Out_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpBreak(Kp,CollectionElement):
    var me: Int
    var me2: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_break )
        act.names[ "Break_" + String(self.me) + "_what" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Break_" + String(self.me) + "_on" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Break_" + String(self.me) + "_vars" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Break_" + String(self.me) + "_" + na ] )
        except:
           print("except Break_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

@register_passable("trivial")
struct KpUnique(Kp,CollectionElement):
    var me: Int
    var me2: Int

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_unique )
        act.names[ "Unique_" + String(self.me) + "_cmd" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Unique_" + String(self.me) + "_key" ] = ff.getw( ff.lines[ln], 1 )
        act.names[ "Unique_" + String(self.me) + "_value" ] = ff.getws( ff.lines[ln], 1 )
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Unique_" + String(self.me) + "_" + na ] )
        except:
           print("except Unique_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, glob: GlobT, what: String, act: Int):
        return

