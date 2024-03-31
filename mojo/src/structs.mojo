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
    fn get_var(self, act: ActT, na: String) -> String:
        ...
    fn do_its(self, inout glob: GlobT, what: String, act: Int):
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

    fn get_var(self, act: ActT, na: String) -> String:
        return("?")
    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            var ss = na.split(".")
            if ss[0] == "Comp_parent":
                for i in range( len(act.ap_comp) ):
                    if act.ap_comp[i].k_parentp == self.me:
                        return( act.ap_comp[i].get_var(act, ss[1]) )
        except:
           print("except Parent_" + String(self.me) + "_" + na  )
        try:
            var ss = na.split(".")
            if ss[0] == "Ref_comp":
                for i in range( len(act.ap_ref) ):
                    if act.ap_ref[i].k_compp == self.me:
                        return( act.ap_ref[i].get_var(act, ss[1]) )
        except:
           print("except Comp_" + String(self.me) + "_" + na  )
        try:
            return( act.names["Comp_" + String(self.me) + "_" + na ] )
        except:
           print("except Comp_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            var ss = na.split(".")
            if ss[0] == "parent":
                return( act.ap_comp[ self.parentp ].get_var(act, ss[1]) )
        except:
           print("except Comp_" + String(self.me) + "_" + na  )
        try:
            var ss = na.split(".")
            if ss[0] == "Ref_element":
                for i in range( len(act.ap_ref) ):
                    if act.ap_ref[i].k_elementp == self.me:
                        return( act.ap_ref[i].get_var(act, ss[1]) )
        except:
           print("except Element_" + String(self.me) + "_" + na  )
        try:
            return( act.names["Element_" + String(self.me) + "_" + na ] )
        except:
           print("except Element_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            var ss = na.split(".")
            if ss[0] == "parent":
                return( act.ap_comp[ self.parentp ].get_var(act, ss[1]) )
        except:
           print("except Comp_" + String(self.me) + "_" + na  )
        try:
            return( act.names["Ref_" + String(self.me) + "_" + na ] )
        except:
           print("except Ref_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Actor_" + String(self.me) + "_" + na ] )
        except:
           print("except Actor_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["All_" + String(self.me) + "_" + na ] )
        except:
           print("except All_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Du_" + String(self.me) + "_" + na ] )
        except:
           print("except Du_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Its_" + String(self.me) + "_" + na ] )
        except:
           print("except Its_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["C_" + String(self.me) + "_" + na ] )
        except:
           print("except C_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Cs_" + String(self.me) + "_" + na ] )
        except:
           print("except Cs_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Out_" + String(self.me) + "_" + na ] )
        except:
           print("except Out_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

@value
struct KpBreak(Kp,CollectionElement):
    var me: Int
    var me2: Int
    var parentp : Int
    var k_what: String
    var k_on: String
    var k_vars: String

    fn __init__(inout self, inout ff: Input, ln: Int, inout act: ActT): 
        self.me2 = len( act.ap_cmds )
        self.me = len( act.ap_break )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_on = ff.getw( ff.lines[ln], 1 )
        self.k_vars = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        var i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    fn get_me2(self) -> Int:
        return(self.me2)

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Break_" + String(self.me) + "_" + na ] )
        except:
           print("except Break_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

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

    fn get_var(self, act: ActT, na: String) -> String:
        try:
            return( act.names["Unique_" + String(self.me) + "_" + na ] )
        except:
           print("except Unique_" + String(self.me) + "_" + na  )
        return("??")

    fn do_its(self, inout glob: GlobT, what: String, act: Int):
        return

