from typing import Dict, List

from inputs import Input
from gen import GlobT, go_act

class ActT:
    def __init__(self):
        self.names = {}
        self.index = {}
        self.ap_comp = []
        self.ap_element = []
        self.ap_ref = []
        self.ap_cmds = []
        self.ap_actor = []
        self.ap_all = []
        self.ap_du = []
        self.ap_its = []
        self.ap_c = []
        self.ap_cs = []
        self.ap_cf = []
        self.ap_out = []
        self.ap_break = []
        self.ap_unique = []

class CmdT:
    def __init__(self, cmd: str, ind: int):
        self.cmd = cmd
        self.ind = ind

class Kp:
    def get_me2(self) -> int:
        pass

    def get_var(self, act: ActT, na: List[str]) -> str:
        pass

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        pass

class KpArgs(Kp):
    def __init__(self):
        self.me = 1
        self.me2 = 1

    def get_me2(self) -> int:
        return self.me2

    def get_var(self, act: ActT, na: List[str]) -> str:
        return "?"

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return 0

class KpComp(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_comp)
        self.names = {}
        self.k_parentp = -1
        self.element_from = len( act.ap_element )
        self.element_to = len( act.ap_element )
        self.ref_from = len( act.ap_ref )
        self.ref_to = len( act.ap_ref )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Comp_" + na ] = self.me
        self.names[ "nop" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "parent" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "find" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
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
            return( self.names[ na[0] ] )
        except:
            return("? Comp_" + str(self.me) + "_" + na[0] + " ?")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        if what == "Element":
            for i in range( self.element_from, self.element_to ):
                ret = go_act(glob.dats.ap_element[i], glob, act)
                if ret != 0:
                    return(ret)
        if what == "Ref":
            for i in range( self.ref_from, self.ref_to ):
                ret = go_act(glob.dats.ap_ref[i], glob, act)
                if ret != 0:
                    return(ret)
        if what == "parent" and self.k_parentp >= 0:
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what == "Comp_parent":
            for i in range( len( glob.dats.ap_comp ) ):
                if glob.dats.ap_comp[i].k_parentp == self.me:
                    ret = go_act(glob.dats.ap_comp[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what == "Ref_comp":
            for i in range( len( glob.dats.ap_ref ) ):
                if glob.dats.ap_ref[i].k_compp == self.me:
                    ret = go_act(glob.dats.ap_ref[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpElement(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_element)
        self.names = {}
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "mw" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "mw2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].element_to = self.me + 1
            self.parentp = i-1
            s = str(self.parentp) + "_Element_" + na
            act.index[ s ] = self.me

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_comp[ self.parentp ].get_var(act, na[1:]) )
        if na[0] == "Ref_element":
            for i in range( len(act.ap_ref) ):
                if act.ap_ref[i].k_elementp == self.me:
                    return( act.ap_ref[i].get_var(act, na[1:]) )
        try:
            return( self.names[ na[0] ] )
        except:
            return("? Element_" + str(self.me) + "_" + na[0] + " ?")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        if what == "parent" and self.parentp >= 0:
            return( go_act(glob.dats.ap_comp[ self.parentp ], glob, act) )
        if what == "Ref_element":
            for i in range( len( glob.dats.ap_ref ) ):
                if glob.dats.ap_ref[i].k_elementp == self.me:
                    ret = go_act(glob.dats.ap_ref[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpRef(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_ref)
        self.names = {}
        self.k_elementp = -1
        self.k_compp = -1
        self.names[ "element" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "opt" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "var" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].ref_to = self.me + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        if na[0] == "element" and len(na) > 1 and self.k_elementp >= 0:
            return( act.ap_element[ self.k_elementp ].get_var(act, na[1:]) )
        if na[0] == "comp" and len(na) > 1 and self.k_compp >= 0:
            return( act.ap_comp[ self.k_compp ].get_var(act, na[1:]) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_comp[ self.parentp ].get_var(act, na[1:]) )
        try:
            return( self.names[ na[0] ] )
        except:
            return("? Ref_" + str(self.me) + "_" + na[0] + " ?")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        if what == "parent" and self.parentp >= 0:
            return( go_act(glob.dats.ap_comp[ self.parentp ], glob, act) )
        if what == "element" and self.k_elementp >= 0:
            return( go_act(glob.dats.ap_element[ self.k_elementp ], glob, act) )
        if what == "comp" and self.k_compp >= 0:
            return( go_act(glob.dats.ap_comp[ self.k_compp ], glob, act) )
        return(0)

class KpActor(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
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

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpAll(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_all)
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpDu(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_du)
        self.k_actorp = -1
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpIts(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_its)
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpC(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_c)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpCs(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_cs)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpCf(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_cf)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpOut(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_out)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpBreak(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_break)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

class KpUnique(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT):
        self.me2 = len(act.ap_cmds)
        self.me = len(act.ap_unique)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_key = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].cmds_to = self.me2 + 1
            self.parentp = i-1

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str]) -> str:
        return("??")

    def do_its(self, glob: GlobT, what: str, act: int) -> int:
        return(0)

