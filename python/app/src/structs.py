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
        self.ap_actor = []
        self.ap_dbcreate = []
        self.ap_dbload = []
        self.ap_dbselect = []
        self.ap_all = []
        self.ap_du = []
        self.ap_new = []
        self.ap_refs = []
        self.ap_var = []
        self.ap_its = []
        self.ap_c = []
        self.ap_cs = []
        self.ap_cf = []
        self.ap_include = []
        self.ap_out = []
        self.ap_break = []
        self.ap_unique = []
        self.ap_collect = []
        self.ap_hash = []
        self.ap_group = []
        self.ap_add = []
        self.ap_clear = []
        self.ap_check = []
        self.ap_json = []
        self.ap_yaml = []
        self.ap_xml = []

class GlobT:
    def __init__(self):
        self.load_errs = False
        self.run_errs = False
        self.acts = ActT()
        self.dats = ActT()
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
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_node)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Node";
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
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Node?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Link":
            for i in range( self.link_from, self.link_to ):
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
                    ret = go_act(glob.dats.ap_link[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpLink(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_link)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Link";
        self.k_top = -1
        self.names[ "to" ] = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_node )
        if i > 0:
            act.ap_node[i-1].all_to = self.me2 + 1
            act.ap_node[i-1].link_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Node parent for Link" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "to" and len(na) > 1 and self.k_top >= 0:
            return( act.ap_node[ self.k_top ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_node[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Link?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_node[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_node[ self.parentp ], glob, act) )
        if what[0] == "to" and self.k_top >= 0:
            if len(what) > 1:
                return( glob.dats.ap_node[ self.k_top ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_node[ self.k_top ], glob, act) )
        return(0)

class KpGraph(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_graph)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Graph";
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        act.index[ "Graph_" + na ] = self.me
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "search" ] = ff.getws( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Graph?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpMatrix(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_matrix)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Matrix";
        self.names[ "a" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "b" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "c" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "search" ] = ff.getw( ff.lines[ln], 1 )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Matrix?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpTable(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_table)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Table";
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
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Table?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Field":
            for i in range( self.field_from, self.field_to ):
                ret = go_act(glob.dats.ap_field[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Of":
            for i in range( self.of_from, self.of_to ):
                ret = go_act(glob.dats.ap_of[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Join":
            for i in range( self.join_from, self.join_to ):
                ret = go_act(glob.dats.ap_join[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Join2":
            for i in range( self.join2_from, self.join2_to ):
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
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpField(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_field)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Field";
        self.k_typep = -1
        self.attrs_from = len( act.ap_attrs )
        self.attrs_to = len( act.ap_attrs )
        self.names[ "type" ] = ff.getw( ff.lines[ln], 1 )
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "dt" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "use" ] = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].field_to = self.me + 1
            self.parentp = i-1
            s = str(self.parentp) + "_Field_" + na
            act.index[ s ] = self.me
        else:
            print( "No Table parent for Field" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "type" and len(na) > 1 and self.k_typep >= 0:
            return( act.ap_type[ self.k_typep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_table[ self.parentp ].get_var(act, na[1:], lno) )
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
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Field?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Attrs":
            for i in range( self.attrs_from, self.attrs_to ):
                ret = go_act(glob.dats.ap_attrs[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.parentp ], glob, act) )
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
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpAttrs(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_attrs)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Attrs";
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.parentp = -1
        i = len( act.ap_field )
        if i > 0:
            act.ap_field[i-1].all_to = self.me2 + 1
            act.ap_field[i-1].attrs_to = self.me + 1
            self.parentp = i-1
            s = str(self.parentp) + "_Attrs_" + na
            act.index[ s ] = self.me
        else:
            print( "No Field parent for Attrs" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_field[ self.parentp ].get_var(act, na[1:], lno) )
        if na[0] == "Join2_attr2":
            for i in range( len(act.ap_join2) ):
                if act.ap_join2[i].k_attr2p == self.me:
                    return( act.ap_join2[i].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Attrs?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_field[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_field[ self.parentp ], glob, act) )
        if what[0] == "Join2_attr2":
            for i in range( len( glob.dats.ap_join2 ) ):
                if glob.dats.ap_join2[i].k_attr2p == self.me:
                    if len(what) > 1:
                        ret = glob.dats.ap_join2[i].do_its(glob, what[1:], act)
                        if ret != 0:
                            return(ret)
                    ret = go_act(glob.dats.ap_join2[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpOf(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_of)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Of";
        self.k_fieldp = -1
        self.k_attrp = -1
        self.k_fromp = -1
        self.names[ "field" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "attr" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "from" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].of_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Table parent for Of" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "field" and len(na) > 1 and self.k_fieldp >= 0:
            return( act.ap_field[ self.k_fieldp ].get_var(act, na[1:], lno) )
        if na[0] == "attr" and len(na) > 1 and self.k_attrp >= 0:
            return( act.ap_attr[ self.k_attrp ].get_var(act, na[1:], lno) )
        if na[0] == "from" and len(na) > 1 and self.k_fromp >= 0:
            return( act.ap_attr[ self.k_fromp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_table[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Of?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.parentp ], glob, act) )
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
        return(0)

class KpJoin(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_join)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Join";
        self.k_field1p = -1
        self.k_table2p = -1
        self.k_field2p = -1
        self.names[ "field1" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "table2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "field2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "pad" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "use" ] = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].join_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Table parent for Join" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "field1" and len(na) > 1 and self.k_field1p >= 0:
            return( act.ap_field[ self.k_field1p ].get_var(act, na[1:], lno) )
        if na[0] == "table2" and len(na) > 1 and self.k_table2p >= 0:
            return( act.ap_table[ self.k_table2p ].get_var(act, na[1:], lno) )
        if na[0] == "field2" and len(na) > 1 and self.k_field2p >= 0:
            return( act.ap_field[ self.k_field2p ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_table[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Join?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.parentp ], glob, act) )
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
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_join2)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Join2";
        self.k_field1p = -1
        self.k_table2p = -1
        self.k_field2p = -1
        self.k_attr2p = -1
        self.names[ "field1" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "table2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "field2" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "attr2" ] = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_table )
        if i > 0:
            act.ap_table[i-1].all_to = self.me2 + 1
            act.ap_table[i-1].join2_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Table parent for Join2" )

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
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_table[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Join2?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_table[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_table[ self.parentp ], glob, act) )
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
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_type)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Type";
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
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Type?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "Data":
            for i in range( self.data_from, self.data_to ):
                ret = go_act(glob.dats.ap_data[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Attr":
            for i in range( self.attr_from, self.attr_to ):
                ret = go_act(glob.dats.ap_attr[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Where":
            for i in range( self.where_from, self.where_to ):
                ret = go_act(glob.dats.ap_where[i], glob, act)
                if ret != 0:
                    return(ret)
        if what[0] == "Logic":
            for i in range( self.logic_from, self.logic_to ):
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
                    ret = go_act(glob.dats.ap_attr[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpData(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_data)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Data";
        na = ff.getw( ff.lines[ln], 1 )
        self.names[ "name" ] = na
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].data_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Type parent for Data" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_type[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Data?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.parentp ], glob, act) )
        return(0)

class KpAttr(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_attr)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Attr";
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
        self.parentp = -1
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].attr_to = self.me + 1
            self.parentp = i-1
            s = str(self.parentp) + "_Attr_" + na
            act.index[ s ] = self.me
        else:
            print( "No Type parent for Attr" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "table" and len(na) > 1 and self.k_tablep >= 0:
            return( act.ap_type[ self.k_tablep ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_type[ self.parentp ].get_var(act, na[1:], lno) )
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
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Attr?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.parentp ], glob, act) )
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
                    ret = go_act(glob.dats.ap_where[i], glob, act)
                    if ret != 0:
                        return(ret)
        return(0)

class KpWhere(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_where)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Where";
        self.k_attrp = -1
        self.k_from_idp = -1
        self.k_idp = -1
        self.names[ "attr" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "from_id" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "eq" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "id" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "value" ] = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].where_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Type parent for Where" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "attr" and len(na) > 1 and self.k_attrp >= 0:
            return( act.ap_attr[ self.k_attrp ].get_var(act, na[1:], lno) )
        if na[0] == "id" and len(na) > 1 and self.k_idp >= 0:
            return( act.ap_attr[ self.k_idp ].get_var(act, na[1:], lno) )
        if na[0] == "from_id" and len(na) > 1 and self.k_from_idp >= 0:
            return( act.ap_attr[ self.k_from_idp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_type[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Where?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.parentp ], glob, act) )
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
        return(0)

class KpLogic(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_logic)
        self.all_from = len( act.kp_all )
        self.all_to = len( act.kp_all )
        self.names = {}
        self.names["k_comp"] = "Logic";
        self.k_attrp = -1
        self.names[ "attr" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "op" ] = ff.getw( ff.lines[ln], 1 )
        self.names[ "code" ] = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_type )
        if i > 0:
            act.ap_type[i-1].all_to = self.me2 + 1
            act.ap_type[i-1].logic_to = self.me + 1
            self.parentp = i-1
        else:
            print( "No Type parent for Logic" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        if na[0] == "attr" and len(na) > 1 and self.k_attrp >= 0:
            return( act.ap_attr[ self.k_attrp ].get_var(act, na[1:], lno) )
        if na[0] == "parent" and len(na) > 1 and self.parentp >= 0:
            return( act.ap_type[ self.parentp ].get_var(act, na[1:], lno) )
        try:
            return( self.names[ na[0] ], False )
        except:
            return("?" + na[0] + "?" + self.line_no + "," + lno + ",Logic?", True );

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        if what[0] == "parent" and self.parentp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_type[ self.parentp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_type[ self.parentp ], glob, act) )
        if what[0] == "attr" and self.k_attrp >= 0:
            if len(what) > 1:
                return( glob.dats.ap_attr[ self.k_attrp ].do_its(glob, what[1:], act) )
            return( go_act(glob.dats.ap_attr[ self.k_attrp ], glob, act) )
        return(0)

class KpActor(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
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

class KpDbcreate(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_dbcreate)
        self.k_where = ff.getw( ff.lines[ln], 1 )
        self.k_tbl = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Dbcreate" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpDbload(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_dbload)
        self.k_where = ff.getw( ff.lines[ln], 1 )
        self.k_tbl = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Dbload" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpDbselect(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_dbselect)
        self.k_actorp = -1
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.k_where = ff.getw( ff.lines[ln], 1 )
        self.k_what = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Dbselect" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpAll(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
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
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for All" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpDu(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
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
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Du" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpNew(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_new)
        self.k_where = ff.getw( ff.lines[ln], 1 )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_line = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for New" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpRefs(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_refs)
        self.k_where = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Refs" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpVar(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_var)
        self.k_attr = ff.getw( ff.lines[ln], 1 )
        self.k_eq = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Var" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpIts(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
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
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Its" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpC(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_c)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for C" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCs(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_cs)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Cs" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCf(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_cf)
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Cf" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpInclude(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_include)
        self.k_opt = ff.getw( ff.lines[ln], 1 )
        self.k_file = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Include" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpOut(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_out)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_desc = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Out" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpBreak(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_break)
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_pad = ff.getw( ff.lines[ln], 1 )
        self.k_actor = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Break" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpUnique(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_unique)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_key = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Unique" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCollect(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_collect)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Collect" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpHash(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_hash)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_key = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Hash" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpGroup(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_group)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_key = ff.getw( ff.lines[ln], 1 )
        self.k_value = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Group" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpAdd(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_add)
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_item = ff.getw( ff.lines[ln], 1 )
        self.k_data = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Add" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpClear(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_clear)
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_item = ff.getw( ff.lines[ln], 1 )
        self.k_data = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Clear" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpCheck(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_check)
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_what = ff.getw( ff.lines[ln], 1 )
        self.k_item = ff.getw( ff.lines[ln], 1 )
        self.k_data = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Check" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpJson(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_json)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_file = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Json" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpYaml(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_yaml)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_file = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Yaml" )

    def get_me2(self) -> int:
        return(self.me2)

    def get_var(self, act: ActT, na: List[str], lno: str) -> (str, bool):
        return("??", True)

    def do_its(self, glob: GlobT, what: List[str], act: int) -> int:
        return(0)

class KpXml(Kp):
    def __init__(self, ff: Input, ln: int, act: ActT, lno: str):
        self.line_no = lno
        self.me2 = len(act.kp_all)
        self.me = len(act.ap_xml)
        self.k_cmd = ff.getw( ff.lines[ln], 1 )
        self.k_pocket = ff.getw( ff.lines[ln], 1 )
        self.k_file = ff.getws( ff.lines[ln], 1 )
        self.parentp = -1
        i = len( act.ap_actor )
        if i > 0:
            act.ap_actor[i-1].all_to = self.me2 + 1
            self.parentp = i-1
        else:
            print( "No Actor parent for Xml" )

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
    if what[0] == "Actor":
        for i in range(len(glob.dats.ap_actor)):
            ret = go_act(glob.dats.ap_actor[i], glob, act)
            if ret != 0:
                return ret
        return 0
    return 0
