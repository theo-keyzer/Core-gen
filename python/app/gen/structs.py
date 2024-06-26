from typing import Dict, List

from inputs import Input
from gen import go_act

class ActT:
    def __init__(self):
        self.index = {}
        self.kp_all = []
        self.ap_comp = []
        self.ap_element = []
        self.ap_opt = []
        self.ap_ref = []
        self.ap_ref2 = []
        self.ap_refu = []
        self.ap_join = []
        self.ap_actor = []
        self.ap_all = []
        self.ap_du = []
        self.ap_its = []
        self.ap_this = []
        self.ap_that = []
        self.ap_in = []
        self.ap_c = []
        self.ap_cs = []
        self.ap_cf = []
        self.ap_out = []
        self.ap_break = []
        self.ap_add = []
        self.ap_clear = []
        self.ap_check = []

class GlobT:
    def __init__(self):
        self.load_errs = False
        self.run_errs = False
        self.lno = "near line 1"
        self.acts = ActT()
        self.dats = ActT()
        self.vars = {}
        self.sets = {}
        self.lists = {}
        self.arg = ""
        self.wins = []
        self.winp = -1
        self.is_in = False
        self.is_out = True
        self.ins = ""

class Kp:
    def get_me2(self) -> int:
        pass

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        pass

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        pass

class KpArgs(Kp):
    def __init__(self):
        self.me = 1
        self.me2 = 1
        self.names = {}
        self.line_no = "cmd.arg:1"

    def get_me2(self) -> int:
        return self.me2

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + "?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return 0

class KpComp(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_comp)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Comp"
        self.names["k_me"] = str( self.me )
        self.k_parentp = -1
        self.element_from = len( act.ap_element )
        self.element_to = len( act.ap_element )
        self.ref_from = len( act.ap_ref )
        self.ref_to = len( act.ap_ref )
        self.ref2_from = len( act.ap_ref2 )
        self.ref2_to = len( act.ap_ref2 )
        self.refu_from = len( act.ap_refu )
        self.refu_to = len( act.ap_refu )
        self.join_from = len( act.ap_join )
        self.join_to = len( act.ap_join )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Comp_" + na ] = self.me
        self.names[ "nop" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "parent" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "find" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Comp_parent":
            for i in range( len(act.ap_comp) ):
                if act.ap_comp[i].k_parentp == self.me:
                    return( act.ap_comp[i].get_var(act, na[1:], lno) )
        if na[0] == "Ref_comp":
            for i in range( len(act.ap_ref) ):
                if act.ap_ref[i].k_compp == self.me:
                    return( act.ap_ref[i].get_var(act, na[1:], lno) )
        if na[0] == "Ref2_comp":
            for i in range( len(act.ap_ref2) ):
                if act.ap_ref2[i].k_compp == self.me:
                    return( act.ap_ref2[i].get_var(act, na[1:], lno) )
        if na[0] == "Refu_comp":
            for i in range( len(act.ap_refu) ):
                if act.ap_refu[i].k_compp == self.me:
                    return( act.ap_refu[i].get_var(act, na[1:], lno) )
        if na[0] == "Refu_comp_ref":
            for i in range( len(act.ap_refu) ):
                if act.ap_refu[i].k_comp_refp == self.me:
                    return( act.ap_refu[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Comp?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Comp?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Element":
            for i in range( self.element_from, self.element_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_element[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_element[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Ref":
            for i in range( self.ref_from, self.ref_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_ref[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_ref[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Ref2":
            for i in range( self.ref2_from, self.ref2_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_ref2[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_ref2[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Refu":
            for i in range( self.refu_from, self.refu_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_refu[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_refu[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Join":
            for i in range( self.join_from, self.join_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_join[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_join[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what[0] == "Comp_parent":
            for i in range( len( glob.dats.ap_comp ) ):
                if glob.dats.ap_comp[i].k_parentp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_comp[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_comp[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Ref_comp":
            for i in range( len( glob.dats.ap_ref ) ):
                if glob.dats.ap_ref[i].k_compp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_ref[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_ref[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Ref2_comp":
            for i in range( len( glob.dats.ap_ref2 ) ):
                if glob.dats.ap_ref2[i].k_compp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_ref2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_ref2[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Refu_comp":
            for i in range( len( glob.dats.ap_refu ) ):
                if glob.dats.ap_refu[i].k_compp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_refu[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_refu[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Refu_comp_ref":
            for i in range( len( glob.dats.ap_refu ) ):
                if glob.dats.ap_refu[i].k_comp_refp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_refu[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_refu[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpElement(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_element)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Element"
        self.names["k_me"] = str( self.me )
        self.opt_from = len( act.ap_opt )
        self.opt_to = len( act.ap_opt )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "mw" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "mw2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].all_to = self.me2 + 1
            act.ap_comp[i-1].element_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Element_" + na
            act.index[ s ] = self.me
        else:
            print( "No Comp parent for Element" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Ref_element":
            for i in range( len(act.ap_ref) ):
                if act.ap_ref[i].k_elementp == self.me:
                    return( act.ap_ref[i].get_var(act, na[1:], lno) )
        if na[0] == "Ref2_element":
            for i in range( len(act.ap_ref2) ):
                if act.ap_ref2[i].k_elementp == self.me:
                    return( act.ap_ref2[i].get_var(act, na[1:], lno) )
        if na[0] == "Ref2_element2":
            for i in range( len(act.ap_ref2) ):
                if act.ap_ref2[i].k_element2p == self.me:
                    return( act.ap_ref2[i].get_var(act, na[1:], lno) )
        if na[0] == "Refu_element":
            for i in range( len(act.ap_refu) ):
                if act.ap_refu[i].k_elementp == self.me:
                    return( act.ap_refu[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Element?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Element?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Opt":
            for i in range( self.opt_from, self.opt_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_opt[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_opt[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what[0] == "Ref_element":
            for i in range( len( glob.dats.ap_ref ) ):
                if glob.dats.ap_ref[i].k_elementp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_ref[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_ref[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Ref2_element":
            for i in range( len( glob.dats.ap_ref2 ) ):
                if glob.dats.ap_ref2[i].k_elementp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_ref2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_ref2[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Ref2_element2":
            for i in range( len( glob.dats.ap_ref2 ) ):
                if glob.dats.ap_ref2[i].k_element2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_ref2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_ref2[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Refu_element":
            for i in range( len( glob.dats.ap_refu ) ):
                if glob.dats.ap_refu[i].k_elementp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_refu[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_refu[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpOpt(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_opt)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Opt"
        self.names["k_me"] = str( self.me )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_element )
        if i > 0:
            act.ap_element[i-1].all_to = self.me2 + 1
            act.ap_element[i-1].opt_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Opt_" + na
            act.index[ s ] = self.me
        else:
            print( "No Element parent for Opt" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_element[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Opt?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Opt?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_element[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_element[ self.k_parentp ], glob, act) )
        return(0)

class KpRef(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_ref)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Ref"
        self.names["k_me"] = str( self.me )
        self.k_elementp = -1
        self.k_compp = -1
        self.names[ "element" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "opt" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "var" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].all_to = self.me2 + 1
            act.ap_comp[i-1].ref_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Comp parent for Ref" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "element" and len(na) > 1 and self.k_elementp >= 0:
            return( act.ap_element[ self.k_elementp ].get_var(act, na[1:], lno) )
        if na[0] == "comp" and len(na) > 1 and self.k_compp >= 0:
            return( act.ap_comp[ self.k_compp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Ref?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Ref?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what[0] == "element" and self.k_elementp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_element[ self.k_elementp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_element[ self.k_elementp ], glob, act) )
        if what[0] == "comp" and self.k_compp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_compp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_compp ], glob, act) )
        return(0)

class KpRef2(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_ref2)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Ref2"
        self.names["k_me"] = str( self.me )
        self.k_elementp = -1
        self.k_compp = -1
        self.k_element2p = -1
        self.names[ "element" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "element2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "opt" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "var" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].all_to = self.me2 + 1
            act.ap_comp[i-1].ref2_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Comp parent for Ref2" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "element" and len(na) > 1 and self.k_elementp >= 0:
            return( act.ap_element[ self.k_elementp ].get_var(act, na[1:], lno) )
        if na[0] == "comp" and len(na) > 1 and self.k_compp >= 0:
            return( act.ap_comp[ self.k_compp ].get_var(act, na[1:], lno) )
        if na[0] == "element2" and len(na) > 1 and self.k_element2p >= 0:
            return( act.ap_element[ self.k_element2p ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Ref2?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Ref2?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what[0] == "element" and self.k_elementp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_element[ self.k_elementp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_element[ self.k_elementp ], glob, act) )
        if what[0] == "comp" and self.k_compp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_compp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_compp ], glob, act) )
        if what[0] == "element2" and self.k_element2p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_element[ self.k_element2p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_element[ self.k_element2p ], glob, act) )
        return(0)

class KpRefu(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_refu)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Refu"
        self.names["k_me"] = str( self.me )
        self.k_elementp = -1
        self.k_compp = -1
        self.k_comp_refp = -1
        self.names[ "element" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "element2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp_ref" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "element3" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "opt" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "var" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "doc" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].all_to = self.me2 + 1
            act.ap_comp[i-1].refu_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Comp parent for Refu" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "element" and len(na) > 1 and self.k_elementp >= 0:
            return( act.ap_element[ self.k_elementp ].get_var(act, na[1:], lno) )
        if na[0] == "comp" and len(na) > 1 and self.k_compp >= 0:
            return( act.ap_comp[ self.k_compp ].get_var(act, na[1:], lno) )
        if na[0] == "comp_ref" and len(na) > 1 and self.k_comp_refp >= 0:
            return( act.ap_comp[ self.k_comp_refp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Refu?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Refu?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        if what[0] == "element" and self.k_elementp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_element[ self.k_elementp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_element[ self.k_elementp ], glob, act) )
        if what[0] == "comp" and self.k_compp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_compp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_compp ], glob, act) )
        if what[0] == "comp_ref" and self.k_comp_refp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_comp_refp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_comp_refp ], glob, act) )
        return(0)

class KpJoin(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_join)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Join"
        self.names["k_me"] = str( self.me )
        self.names[ "element" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "dir" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "using" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "element2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "comp2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "element3" ] = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_comp )
        if i > 0:
            act.ap_comp[i-1].all_to = self.me2 + 1
            act.ap_comp[i-1].join_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Comp parent for Join" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_comp[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Join?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Join?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_comp[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_comp[ self.k_parentp ], glob, act) )
        return(0)

class KpActor(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len( act.kp_all )
        self.me = len( act.ap_actor )
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.k_name = ff.getw( ff.lines[ln], 1 )
        act.index[ "Actor_" + self.k_name ] = self.me
        self.k_comp = ff.getw( ff.lines[ln], 1 )
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getw( ff.lines[ln], 1 )
        self.k_cc = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpAll(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_all)
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for All" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpDu(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_du)
        self.k_actorp = -1
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Du" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpIts(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_its)
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Its" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpThis(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_this)
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for This" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpThat(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_that)
        self.k_actorp = -1
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_file = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_args = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for That" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpIn(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_in)
        self.k_flag = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for In" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpC(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_c)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for C" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCs(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_cs)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Cs" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCf(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_cf)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Cf" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpOut(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_out)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Out" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpBreak(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_break)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_check = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Break" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpAdd(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_add)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_item = ff.getw( ff.lines[ln], 1 )
        self.k_data = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Add" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpClear(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_clear)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_item = ff.getw( ff.lines[ln], 1 )
        self.k_data = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Clear" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCheck(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str, flag):
        self.err = False
        self.flag = flag
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_check)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_item = ff.getw( ff.lines[ln], 1 )
        self.k_data = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.k_parentp = i-1
        else:
            print( "No Actor parent for Check" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)


def do_all(glob, what: List[str], act: int) -> int:
    if what[0] == "Comp":
        for i in range(len(glob.dats.ap_comp)):
            ret = go_act(glob.dats.ap_comp[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Element":
        for i in range(len(glob.dats.ap_element)):
            ret = go_act(glob.dats.ap_element[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Opt":
        for i in range(len(glob.dats.ap_opt)):
            ret = go_act(glob.dats.ap_opt[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Ref":
        for i in range(len(glob.dats.ap_ref)):
            ret = go_act(glob.dats.ap_ref[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Ref2":
        for i in range(len(glob.dats.ap_ref2)):
            ret = go_act(glob.dats.ap_ref2[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Refu":
        for i in range(len(glob.dats.ap_refu)):
            ret = go_act(glob.dats.ap_refu[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Join":
        for i in range(len(glob.dats.ap_join)):
            ret = go_act(glob.dats.ap_join[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Actor":
        for i in range(len(glob.dats.ap_actor)):
            ret = go_act(glob.dats.ap_actor[i], glob, act)
            if ret != 0:
                return ret
        return 0
    return 0
