from typing import Dict, List

from inputs import Input
from gen import go_act

class ActT:
    def __init__(self):
        self.index = {}
        self.kp_all = []
        self.ap_node = []
        self.ap_link = []
        self.ap_graph = []
        self.ap_matrix = []
        self.ap_table = []
        self.ap_field = []
        self.ap_attrs = []
        self.ap_of = []
        self.ap_join = []
        self.ap_join2 = []
        self.ap_type = []
        self.ap_data = []
        self.ap_attr = []
        self.ap_where = []
        self.ap_logic = []
        self.ap_domain = []
        self.ap_model = []
        self.ap_frame = []
        self.ap_a = []
        self.ap_use = []
        self.ap_grid = []
        self.ap_col = []
        self.ap_r = []
        self.ap_actor = []
        self.ap_all = []
        self.ap_du = []
        self.ap_its = []
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
        self.acts = ActT()
        self.dats = ActT()
        self.vars = {}
        self.sets = {}
        self.lists = {}
        self.arg = ""
        self.wins = []
        self.winp = -1

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

    def get_me2(self) -> int:
        return self.me2

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + "?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return 0

class KpNode(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_node)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Node"
        self.names["k_me"] = str( self.me )
        self.k_parentp = -1
        self.link_from = len( act.ap_link )
        self.link_to = len( act.ap_link )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Node_" + na ] = self.me
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "parent" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "var" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "eq" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getw( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_node[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Node_parent":
            for i in range( len(act.ap_node) ):
                if act.ap_node[i].k_parentp == self.me:
                    return( act.ap_node[i].get_var(act, na[1:], lno) )
        if na[0] == "Link_to":
            for i in range( len(act.ap_link) ):
                if act.ap_link[i].k_top == self.me:
                    return( act.ap_link[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Node?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Node?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Link":
            for i in range( self.link_from, self.link_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_link[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_link[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_node[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_node[ self.k_parentp ], glob, act) )
        if what[0] == "Node_parent":
            for i in range( len( glob.dats.ap_node ) ):
                if glob.dats.ap_node[i].k_parentp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_node[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_node[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Link_to":
            for i in range( len( glob.dats.ap_link ) ):
                if glob.dats.ap_link[i].k_top == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_link[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_link[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpLink(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_link)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Link"
        self.names["k_me"] = str( self.me )
        self.k_top = -1
        self.names[ "to" ] = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_node )
        if i > 0:
            act.ap_node[i-1].all_to = self.me2 + 1
            act.ap_node[i-1].link_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Node parent for Link" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "to" and len(na) > 1 and self.k_top >= 0:
            return( act.ap_node[ self.k_top ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_node[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Link?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Link?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_node[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_node[ self.k_parentp ], glob, act) )
        if what[0] == "to" and self.k_top >= 0:
            if len(what) > 1:
                return( glob.dats.ap_node[ self.k_top ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_node[ self.k_top ], glob, act) )
        return(0)

class KpGraph(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_graph)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Graph"
        self.names["k_me"] = str( self.me )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Graph_" + na ] = self.me
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "search" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Graph?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Graph?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpMatrix(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_matrix)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Matrix"
        self.names["k_me"] = str( self.me )
        self.names[ "a" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "b" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "c" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "search" ] = ff.getw( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Matrix?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Matrix?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpTable(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_table)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Table"
        self.names["k_me"] = str( self.me )
        self.field_from = len( act.ap_field )
        self.field_to = len( act.ap_field )
        self.of_from = len( act.ap_of )
        self.of_to = len( act.ap_of )
        self.join_from = len( act.ap_join )
        self.join_to = len( act.ap_join )
        self.join2_from = len( act.ap_join2 )
        self.join2_to = len( act.ap_join2 )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Table_" + na ] = self.me
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getw( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "Join_table2":
            for i in range( len(act.ap_join) ):
                if act.ap_join[i].k_table2p == self.me:
                    return( act.ap_join[i].get_var(act, na[1:], lno) )
        if na[0] == "Join2_table2":
            for i in range( len(act.ap_join2) ):
                if act.ap_join2[i].k_table2p == self.me:
                    return( act.ap_join2[i].get_var(act, na[1:], lno) )
        if na[0] == "Where_table":
            for i in range( len(act.ap_where) ):
                if act.ap_where[i].k_tablep == self.me:
                    return( act.ap_where[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Table?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Table?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Field":
            for i in range( self.field_from, self.field_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_field[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_field[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Of":
            for i in range( self.of_from, self.of_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_of[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_of[i], glob, act)
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
        if what[0] == "Join2":
            for i in range( self.join2_from, self.join2_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_join2[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_join2[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Join_table2":
            for i in range( len( glob.dats.ap_join ) ):
                if glob.dats.ap_join[i].k_table2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Join2_table2":
            for i in range( len( glob.dats.ap_join2 ) ):
                if glob.dats.ap_join2[i].k_table2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Where_table":
            for i in range( len( glob.dats.ap_where ) ):
                if glob.dats.ap_where[i].k_tablep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_where[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_where[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpField(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_field)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Field"
        self.names["k_me"] = str( self.me )
        self.k_typep = -1
        self.attrs_from = len( act.ap_attrs )
        self.attrs_to = len( act.ap_attrs )
        self.names[ "type" ] = ff.getw( ff.lines[ln], 1 )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "dt" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "use" ] = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].field_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Field_" + na
            act.index[ s ] = self.me
        else:
            print( "No Table parent for Field" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "type" and len(na) > 1 and self.k_typep >= 0:
            return( act.ap_type[ self.k_typep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_table[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Of_field":
            for i in range( len(act.ap_of) ):
                if act.ap_of[i].k_fieldp == self.me:
                    return( act.ap_of[i].get_var(act, na[1:], lno) )
        if na[0] == "Join_field1":
            for i in range( len(act.ap_join) ):
                if act.ap_join[i].k_field1p == self.me:
                    return( act.ap_join[i].get_var(act, na[1:], lno) )
        if na[0] == "Join2_field1":
            for i in range( len(act.ap_join2) ):
                if act.ap_join2[i].k_field1p == self.me:
                    return( act.ap_join2[i].get_var(act, na[1:], lno) )
        if na[0] == "Join_field2":
            for i in range( len(act.ap_join) ):
                if act.ap_join[i].k_field2p == self.me:
                    return( act.ap_join[i].get_var(act, na[1:], lno) )
        if na[0] == "Join2_field2":
            for i in range( len(act.ap_join2) ):
                if act.ap_join2[i].k_field2p == self.me:
                    return( act.ap_join2[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Field?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Field?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Attrs":
            for i in range( self.attrs_from, self.attrs_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_attrs[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_attrs[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_parentp ], glob, act) )
        if what[0] == "type" and self.k_typep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_typep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_typep ], glob, act) )
        if what[0] == "Of_field":
            for i in range( len( glob.dats.ap_of ) ):
                if glob.dats.ap_of[i].k_fieldp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_of[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_of[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Join_field1":
            for i in range( len( glob.dats.ap_join ) ):
                if glob.dats.ap_join[i].k_field1p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Join2_field1":
            for i in range( len( glob.dats.ap_join2 ) ):
                if glob.dats.ap_join2[i].k_field1p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Join_field2":
            for i in range( len( glob.dats.ap_join ) ):
                if glob.dats.ap_join[i].k_field2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Join2_field2":
            for i in range( len( glob.dats.ap_join2 ) ):
                if glob.dats.ap_join2[i].k_field2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpAttrs(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_attrs)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Attrs"
        self.names["k_me"] = str( self.me )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.k_parentp = -2
        i = len( act.ap_field )
        if i > 0:
            act.ap_field[i-1].all_to = self.me2 + 1
            act.ap_field[i-1].attrs_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Attrs_" + na
            act.index[ s ] = self.me
        else:
            print( "No Field parent for Attrs" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_field[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Join2_attr2":
            for i in range( len(act.ap_join2) ):
                if act.ap_join2[i].k_attr2p == self.me:
                    return( act.ap_join2[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Attrs?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Attrs?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.k_parentp ], glob, act) )
        if what[0] == "Join2_attr2":
            for i in range( len( glob.dats.ap_join2 ) ):
                if glob.dats.ap_join2[i].k_attr2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpOf(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_of)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Of"
        self.names["k_me"] = str( self.me )
        self.k_fieldp = -1
        self.k_typep = -1
        self.k_attrp = -1
        self.k_fromp = -1
        self.names[ "field" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "attr" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "from" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].of_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Table parent for Of" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "field" and len(na) > 1 and self.k_fieldp >= 0:
            return( act.ap_field[ self.k_fieldp ].get_var(act, na[1:], lno) )
        if na[0] == "attr" and len(na) > 1 and self.k_attrp >= 0:
            return( act.ap_attr[ self.k_attrp ].get_var(act, na[1:], lno) )
        if na[0] == "from" and len(na) > 1 and self.k_fromp >= 0:
            return( act.ap_attr[ self.k_fromp ].get_var(act, na[1:], lno) )
        if na[0] == "type" and len(na) > 1 and self.k_typep >= 0:
            return( act.ap_type[ self.k_typep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_table[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Of?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Of?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_parentp ], glob, act) )
        if what[0] == "field" and self.k_fieldp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.k_fieldp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.k_fieldp ], glob, act) )
        if what[0] == "attr" and self.k_attrp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_attrp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_attrp ], glob, act) )
        if what[0] == "from" and self.k_fromp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_fromp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_fromp ], glob, act) )
        if what[0] == "type" and self.k_typep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_typep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_typep ], glob, act) )
        return(0)

class KpJoin(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_join)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Join"
        self.names["k_me"] = str( self.me )
        self.k_field1p = -1
        self.k_table2p = -1
        self.k_field2p = -1
        self.names[ "field1" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "table2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "field2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "use" ] = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].join_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Table parent for Join" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "field1" and len(na) > 1 and self.k_field1p >= 0:
            return( act.ap_field[ self.k_field1p ].get_var(act, na[1:], lno) )
        if na[0] == "table2" and len(na) > 1 and self.k_table2p >= 0:
            return( act.ap_table[ self.k_table2p ].get_var(act, na[1:], lno) )
        if na[0] == "field2" and len(na) > 1 and self.k_field2p >= 0:
            return( act.ap_field[ self.k_field2p ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_table[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Join?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Join?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_parentp ], glob, act) )
        if what[0] == "field1" and self.k_field1p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.k_field1p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.k_field1p ], glob, act) )
        if what[0] == "table2" and self.k_table2p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_table2p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_table2p ], glob, act) )
        if what[0] == "field2" and self.k_field2p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.k_field2p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.k_field2p ], glob, act) )
        return(0)

class KpJoin2(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_join2)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Join2"
        self.names["k_me"] = str( self.me )
        self.k_field1p = -1
        self.k_table2p = -1
        self.k_field2p = -1
        self.k_attr2p = -1
        self.names[ "field1" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "table2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "field2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "attr2" ] = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].join2_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Table parent for Join2" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "field1" and len(na) > 1 and self.k_field1p >= 0:
            return( act.ap_field[ self.k_field1p ].get_var(act, na[1:], lno) )
        if na[0] == "table2" and len(na) > 1 and self.k_table2p >= 0:
            return( act.ap_table[ self.k_table2p ].get_var(act, na[1:], lno) )
        if na[0] == "field2" and len(na) > 1 and self.k_field2p >= 0:
            return( act.ap_field[ self.k_field2p ].get_var(act, na[1:], lno) )
        if na[0] == "attr2" and len(na) > 1 and self.k_attr2p >= 0:
            return( act.ap_attrs[ self.k_attr2p ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_table[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Join2?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Join2?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_parentp ], glob, act) )
        if what[0] == "field1" and self.k_field1p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.k_field1p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.k_field1p ], glob, act) )
        if what[0] == "table2" and self.k_table2p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_table2p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_table2p ], glob, act) )
        if what[0] == "field2" and self.k_field2p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.k_field2p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.k_field2p ], glob, act) )
        if what[0] == "attr2" and self.k_attr2p >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attrs[ self.k_attr2p ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attrs[ self.k_attr2p ], glob, act) )
        return(0)

class KpType(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_type)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Type"
        self.names["k_me"] = str( self.me )
        self.data_from = len( act.ap_data )
        self.data_to = len( act.ap_data )
        self.attr_from = len( act.ap_attr )
        self.attr_to = len( act.ap_attr )
        self.where_from = len( act.ap_where )
        self.where_to = len( act.ap_where )
        self.logic_from = len( act.ap_logic )
        self.logic_to = len( act.ap_logic )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Type_" + na ] = self.me
        self.names[ "desc" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "Field_type":
            for i in range( len(act.ap_field) ):
                if act.ap_field[i].k_typep == self.me:
                    return( act.ap_field[i].get_var(act, na[1:], lno) )
        if na[0] == "Attr_table":
            for i in range( len(act.ap_attr) ):
                if act.ap_attr[i].k_tablep == self.me:
                    return( act.ap_attr[i].get_var(act, na[1:], lno) )
        if na[0] == "Of_type":
            for i in range( len(act.ap_of) ):
                if act.ap_of[i].k_typep == self.me:
                    return( act.ap_of[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Type?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Type?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Data":
            for i in range( self.data_from, self.data_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_data[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_data[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Attr":
            for i in range( self.attr_from, self.attr_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_attr[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_attr[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Where":
            for i in range( self.where_from, self.where_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_where[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_where[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Logic":
            for i in range( self.logic_from, self.logic_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_logic[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_logic[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Field_type":
            for i in range( len( glob.dats.ap_field ) ):
                if glob.dats.ap_field[i].k_typep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_field[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_field[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Attr_table":
            for i in range( len( glob.dats.ap_attr ) ):
                if glob.dats.ap_attr[i].k_tablep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_attr[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_attr[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Of_type":
            for i in range( len( glob.dats.ap_of ) ):
                if glob.dats.ap_of[i].k_typep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_of[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_of[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpData(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_data)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Data"
        self.names["k_me"] = str( self.me )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].data_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Type parent for Data" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_type[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Data?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Data?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_parentp ], glob, act) )
        return(0)

class KpAttr(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_attr)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Attr"
        self.names["k_me"] = str( self.me )
        self.k_tablep = -1
        self.names[ "table" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "relation" ] = ff.getw( ff.lines[ln], 1 )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "mytype" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "len" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "null" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "flags" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "desc" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].attr_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Attr_" + na
            act.index[ s ] = self.me
        else:
            print( "No Type parent for Attr" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "table" and len(na) > 1 and self.k_tablep >= 0:
            return( act.ap_type[ self.k_tablep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_type[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Where_attr":
            for i in range( len(act.ap_where) ):
                if act.ap_where[i].k_attrp == self.me:
                    return( act.ap_where[i].get_var(act, na[1:], lno) )
        if na[0] == "Where_id":
            for i in range( len(act.ap_where) ):
                if act.ap_where[i].k_idp == self.me:
                    return( act.ap_where[i].get_var(act, na[1:], lno) )
        if na[0] == "Logic_attr":
            for i in range( len(act.ap_logic) ):
                if act.ap_logic[i].k_attrp == self.me:
                    return( act.ap_logic[i].get_var(act, na[1:], lno) )
        if na[0] == "Of_attr":
            for i in range( len(act.ap_of) ):
                if act.ap_of[i].k_attrp == self.me:
                    return( act.ap_of[i].get_var(act, na[1:], lno) )
        if na[0] == "Of_from":
            for i in range( len(act.ap_of) ):
                if act.ap_of[i].k_fromp == self.me:
                    return( act.ap_of[i].get_var(act, na[1:], lno) )
        if na[0] == "Where_from_id":
            for i in range( len(act.ap_where) ):
                if act.ap_where[i].k_from_idp == self.me:
                    return( act.ap_where[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Attr?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Attr?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_parentp ], glob, act) )
        if what[0] == "table" and self.k_tablep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_tablep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_tablep ], glob, act) )
        if what[0] == "Where_attr":
            for i in range( len( glob.dats.ap_where ) ):
                if glob.dats.ap_where[i].k_attrp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_where[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_where[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Where_id":
            for i in range( len( glob.dats.ap_where ) ):
                if glob.dats.ap_where[i].k_idp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_where[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_where[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Logic_attr":
            for i in range( len( glob.dats.ap_logic ) ):
                if glob.dats.ap_logic[i].k_attrp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_logic[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_logic[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Of_attr":
            for i in range( len( glob.dats.ap_of ) ):
                if glob.dats.ap_of[i].k_attrp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_of[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_of[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Of_from":
            for i in range( len( glob.dats.ap_of ) ):
                if glob.dats.ap_of[i].k_fromp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_of[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_of[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Where_from_id":
            for i in range( len( glob.dats.ap_where ) ):
                if glob.dats.ap_where[i].k_from_idp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_where[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_where[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpWhere(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_where)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Where"
        self.names["k_me"] = str( self.me )
        self.k_attrp = -1
        self.k_tablep = -1
        self.k_from_idp = -1
        self.k_idp = -1
        self.names[ "attr" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "from_id" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "eq" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "id" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].where_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Type parent for Where" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "attr" and len(na) > 1 and self.k_attrp >= 0:
            return( act.ap_attr[ self.k_attrp ].get_var(act, na[1:], lno) )
        if na[0] == "id" and len(na) > 1 and self.k_idp >= 0:
            return( act.ap_attr[ self.k_idp ].get_var(act, na[1:], lno) )
        if na[0] == "from_id" and len(na) > 1 and self.k_from_idp >= 0:
            return( act.ap_attr[ self.k_from_idp ].get_var(act, na[1:], lno) )
        if na[0] == "table" and len(na) > 1 and self.k_tablep >= 0:
            return( act.ap_table[ self.k_tablep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_type[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Where?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Where?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_parentp ], glob, act) )
        if what[0] == "attr" and self.k_attrp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_attrp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_attrp ], glob, act) )
        if what[0] == "id" and self.k_idp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_idp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_idp ], glob, act) )
        if what[0] == "from_id" and self.k_from_idp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_from_idp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_from_idp ], glob, act) )
        if what[0] == "table" and self.k_tablep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.k_tablep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.k_tablep ], glob, act) )
        return(0)

class KpLogic(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_logic)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Logic"
        self.names["k_me"] = str( self.me )
        self.k_attrp = -1
        self.names[ "attr" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "code" ] = ff.getw( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].logic_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No Type parent for Logic" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "attr" and len(na) > 1 and self.k_attrp >= 0:
            return( act.ap_attr[ self.k_attrp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_type[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Logic?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Logic?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.k_parentp ], glob, act) )
        if what[0] == "attr" and self.k_attrp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_attrp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_attrp ], glob, act) )
        return(0)

class KpDomain(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_domain)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Domain"
        self.names["k_me"] = str( self.me )
        self.model_from = len( act.ap_model )
        self.model_to = len( act.ap_model )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Domain_" + na ] = self.me
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "Frame_domain":
            for i in range( len(act.ap_frame) ):
                if act.ap_frame[i].k_domainp == self.me:
                    return( act.ap_frame[i].get_var(act, na[1:], lno) )
        if na[0] == "A_domain":
            for i in range( len(act.ap_a) ):
                if act.ap_a[i].k_domainp == self.me:
                    return( act.ap_a[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Domain?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Domain?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Model":
            for i in range( self.model_from, self.model_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_model[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_model[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Frame_domain":
            for i in range( len( glob.dats.ap_frame ) ):
                if glob.dats.ap_frame[i].k_domainp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_frame[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_frame[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "A_domain":
            for i in range( len( glob.dats.ap_a ) ):
                if glob.dats.ap_a[i].k_domainp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_a[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_a[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpModel(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_model)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Model"
        self.names["k_me"] = str( self.me )
        self.frame_from = len( act.ap_frame )
        self.frame_to = len( act.ap_frame )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_domain )
        if i > 0:
            act.ap_domain[i-1].all_to = self.me2 + 1
            act.ap_domain[i-1].model_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Model_" + na
            act.index[ s ] = self.me
        else:
            print( "No Domain parent for Model" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_domain[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "A_model":
            for i in range( len(act.ap_a) ):
                if act.ap_a[i].k_modelp == self.me:
                    return( act.ap_a[i].get_var(act, na[1:], lno) )
        if na[0] == "Use_model":
            for i in range( len(act.ap_use) ):
                if act.ap_use[i].k_modelp == self.me:
                    return( act.ap_use[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Model?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Model?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Frame":
            for i in range( self.frame_from, self.frame_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_frame[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_frame[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_domain[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_domain[ self.k_parentp ], glob, act) )
        if what[0] == "A_model":
            for i in range( len( glob.dats.ap_a ) ):
                if glob.dats.ap_a[i].k_modelp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_a[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_a[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "Use_model":
            for i in range( len( glob.dats.ap_use ) ):
                if glob.dats.ap_use[i].k_modelp == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_use[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_use[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpFrame(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_frame)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Frame"
        self.names["k_me"] = str( self.me )
        self.k_domainp = -1
        self.a_from = len( act.ap_a )
        self.a_to = len( act.ap_a )
        self.names[ "group" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "domain" ] = ff.getwsw( ff.lines[ln], 1 )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_model )
        if i > 0:
            act.ap_model[i-1].all_to = self.me2 + 1
            act.ap_model[i-1].frame_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Frame_" + na
            act.index[ s ] = self.me
        else:
            print( "No Model parent for Frame" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "domain" and len(na) > 1 and self.k_domainp >= 0:
            return( act.ap_domain[ self.k_domainp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_model[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Use_frame":
            for i in range( len(act.ap_use) ):
                if act.ap_use[i].k_framep == self.me:
                    return( act.ap_use[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Frame?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Frame?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "A":
            for i in range( self.a_from, self.a_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_a[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_a[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_model[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_model[ self.k_parentp ], glob, act) )
        if what[0] == "domain" and self.k_domainp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_domain[ self.k_domainp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_domain[ self.k_domainp ], glob, act) )
        if what[0] == "Use_frame":
            for i in range( len( glob.dats.ap_use ) ):
                if glob.dats.ap_use[i].k_framep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_use[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_use[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpA(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_a)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "A"
        self.names["k_me"] = str( self.me )
        self.k_domainp = -1
        self.k_modelp = -1
        self.use_from = len( act.ap_use )
        self.use_to = len( act.ap_use )
        self.names[ "model" ] = ff.getwsw( ff.lines[ln], 1 )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_frame )
        if i > 0:
            act.ap_frame[i-1].all_to = self.me2 + 1
            act.ap_frame[i-1].a_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_A_" + na
            act.index[ s ] = self.me
        else:
            print( "No Frame parent for A" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "model" and len(na) > 1 and self.k_modelp >= 0:
            return( act.ap_model[ self.k_modelp ].get_var(act, na[1:], lno) )
        if na[0] == "domain" and len(na) > 1 and self.k_domainp >= 0:
            return( act.ap_domain[ self.k_domainp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_frame[ self.k_parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Use_a":
            for i in range( len(act.ap_use) ):
                if act.ap_use[i].k_ap == self.me:
                    return( act.ap_use[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",A?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",A?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Use":
            for i in range( self.use_from, self.use_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_use[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_use[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_frame[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_frame[ self.k_parentp ], glob, act) )
        if what[0] == "model" and self.k_modelp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_model[ self.k_modelp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_model[ self.k_modelp ], glob, act) )
        if what[0] == "domain" and self.k_domainp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_domain[ self.k_domainp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_domain[ self.k_domainp ], glob, act) )
        if what[0] == "Use_a":
            for i in range( len( glob.dats.ap_use ) ):
                if glob.dats.ap_use[i].k_ap == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_use[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_use[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpUse(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_use)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Use"
        self.names["k_me"] = str( self.me )
        self.k_modelp = -1
        self.k_framep = -1
        self.k_ap = -1
        self.names[ "frame" ] = ff.getwsw( ff.lines[ln], 1 )
        self.names[ "a" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_a )
        if i > 0:
            act.ap_a[i-1].all_to = self.me2 + 1
            act.ap_a[i-1].use_to = self.me + 1
            self.k_parentp = i-1
        else:
            print( "No A parent for Use" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "frame" and len(na) > 1 and self.k_framep >= 0:
            return( act.ap_frame[ self.k_framep ].get_var(act, na[1:], lno) )
        if na[0] == "a" and len(na) > 1 and self.k_ap >= 0:
            return( act.ap_a[ self.k_ap ].get_var(act, na[1:], lno) )
        if na[0] == "model" and len(na) > 1 and self.k_modelp >= 0:
            return( act.ap_model[ self.k_modelp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_a[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Use?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Use?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_a[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_a[ self.k_parentp ], glob, act) )
        if what[0] == "frame" and self.k_framep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_frame[ self.k_framep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_frame[ self.k_framep ], glob, act) )
        if what[0] == "a" and self.k_ap >= 0:
            if len(what) > 1:
                return( glob.dats.ap_a[ self.k_ap ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_a[ self.k_ap ], glob, act) )
        if what[0] == "model" and self.k_modelp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_model[ self.k_modelp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_model[ self.k_modelp ], glob, act) )
        return(0)

class KpGrid(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_grid)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Grid"
        self.names["k_me"] = str( self.me )
        self.col_from = len( act.ap_col )
        self.col_to = len( act.ap_col )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Grid_" + na ] = self.me
        self.names[ "file" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "Col_name":
            for i in range( len(act.ap_col) ):
                if act.ap_col[i].k_namep == self.me:
                    return( act.ap_col[i].get_var(act, na[1:], lno) )
        if na[0] == "R_name":
            for i in range( len(act.ap_r) ):
                if act.ap_r[i].k_namep == self.me:
                    return( act.ap_r[i].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Grid?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Grid?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Col":
            for i in range( self.col_from, self.col_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_col[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_col[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Col_name":
            for i in range( len( glob.dats.ap_col ) ):
                if glob.dats.ap_col[i].k_namep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_col[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_col[i], glob, act)
                    if ret != 0:
                        return(ret)
        if what[0] == "R_name":
            for i in range( len( glob.dats.ap_r ) ):
                if glob.dats.ap_r[i].k_namep == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_r[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                        continue
                    ret = go_act(glob.dats.ap_r[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpCol(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_col)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Col"
        self.names["k_me"] = str( self.me )
        self.k_namep = -1
        self.r_from = len( act.ap_r )
        self.r_to = len( act.ap_r )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "index" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "group" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "file" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_grid )
        if i > 0:
            act.ap_grid[i-1].all_to = self.me2 + 1
            act.ap_grid[i-1].col_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_Col_" + na
            act.index[ s ] = self.me
        else:
            print( "No Grid parent for Col" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "name" and len(na) > 1 and self.k_namep >= 0:
            return( act.ap_grid[ self.k_namep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_grid[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",Col?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Col?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "R":
            for i in range( self.r_from, self.r_to ):
                if len(what) > 1:
                    ret = glob.dats.ap_r[i].do_its(glob, what[1:], act)
                    if ret != 0:
                        return(ret)
                    continue
                ret = go_act(glob.dats.ap_r[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_grid[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_grid[ self.k_parentp ], glob, act) )
        if what[0] == "name" and self.k_namep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_grid[ self.k_namep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_grid[ self.k_namep ], glob, act) )
        return(0)

class KpR(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_r)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "R"
        self.names["k_me"] = str( self.me )
        self.k_namep = -1
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "file" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "info" ] = ff.getws( ff.lines[ln], 1 )
        self.k_parentp = -2
        i = len( act.ap_col )
        if i > 0:
            act.ap_col[i-1].all_to = self.me2 + 1
            act.ap_col[i-1].r_to = self.me + 1
            self.k_parentp = i-1
            s = str(self.k_parentp) + "_R_" + na
            act.index[ s ] = self.me
        else:
            print( "No Col parent for R" )
            self.err = True

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "name" and len(na) > 1 and self.k_namep >= 0:
            return( act.ap_grid[ self.k_namep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.k_parentp >= 0:
            return( act.ap_col[ self.k_parentp ].get_var(act, na[1:], lno) )
        try:
            if len(na) > 1:
                return("?" + na[0] + ".?" + self.line_no + "," + lno + ",R?", True );
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",R?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.k_parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_col[ self.k_parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_col[ self.k_parentp ], glob, act) )
        if what[0] == "name" and self.k_namep >= 0:
            if len(what) > 1:
                return( glob.dats.ap_grid[ self.k_namep ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_grid[ self.k_namep ], glob, act) )
        return(0)

class KpActor(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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

class KpC(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.err = False
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
    if what[0] == "Node":
        for i in range(len(glob.dats.ap_node)):
            ret = go_act(glob.dats.ap_node[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Link":
        for i in range(len(glob.dats.ap_link)):
            ret = go_act(glob.dats.ap_link[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Graph":
        for i in range(len(glob.dats.ap_graph)):
            ret = go_act(glob.dats.ap_graph[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Matrix":
        for i in range(len(glob.dats.ap_matrix)):
            ret = go_act(glob.dats.ap_matrix[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Table":
        for i in range(len(glob.dats.ap_table)):
            ret = go_act(glob.dats.ap_table[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Field":
        for i in range(len(glob.dats.ap_field)):
            ret = go_act(glob.dats.ap_field[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Attrs":
        for i in range(len(glob.dats.ap_attrs)):
            ret = go_act(glob.dats.ap_attrs[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Of":
        for i in range(len(glob.dats.ap_of)):
            ret = go_act(glob.dats.ap_of[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Join":
        for i in range(len(glob.dats.ap_join)):
            ret = go_act(glob.dats.ap_join[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Join2":
        for i in range(len(glob.dats.ap_join2)):
            ret = go_act(glob.dats.ap_join2[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Type":
        for i in range(len(glob.dats.ap_type)):
            ret = go_act(glob.dats.ap_type[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Data":
        for i in range(len(glob.dats.ap_data)):
            ret = go_act(glob.dats.ap_data[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Attr":
        for i in range(len(glob.dats.ap_attr)):
            ret = go_act(glob.dats.ap_attr[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Where":
        for i in range(len(glob.dats.ap_where)):
            ret = go_act(glob.dats.ap_where[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Logic":
        for i in range(len(glob.dats.ap_logic)):
            ret = go_act(glob.dats.ap_logic[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Domain":
        for i in range(len(glob.dats.ap_domain)):
            ret = go_act(glob.dats.ap_domain[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Model":
        for i in range(len(glob.dats.ap_model)):
            ret = go_act(glob.dats.ap_model[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Frame":
        for i in range(len(glob.dats.ap_frame)):
            ret = go_act(glob.dats.ap_frame[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "A":
        for i in range(len(glob.dats.ap_a)):
            ret = go_act(glob.dats.ap_a[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Use":
        for i in range(len(glob.dats.ap_use)):
            ret = go_act(glob.dats.ap_use[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Grid":
        for i in range(len(glob.dats.ap_grid)):
            ret = go_act(glob.dats.ap_grid[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "Col":
        for i in range(len(glob.dats.ap_col)):
            ret = go_act(glob.dats.ap_col[i], glob, act)
            if ret != 0:
                return ret
        return 0
    if what[0] == "R":
        for i in range(len(glob.dats.ap_r)):
            ret = go_act(glob.dats.ap_r[i], glob, act)
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
