from lark import Lark, Transformer

input_text = """
----------------------------------------------------------------
Table tb1 as a
----------------------------------------------------------------

Field . t1f1 NUM   display dropdown
Field . t1f2 FLOAT display normal,grid

Join2 t1f2 tb2 t2f1 t2f1a1

"""
output_text = """
[
 {'me': 'Table', 'name': 'tb1', 'pad': 'as', 'value': 'a'}, 
  [ {'me': 'Field', 'type': '.', 'name': 't1f1', 'dt': 'NUM', 'pad': 'display', 'use': 'dropdown'}], 
  [ {'me': 'Field', 'type': '.', 'name': 't1f2', 'dt': 'FLOAT', 'pad': 'display', 'use': 'normal,grid'}], 
  [ {'me': 'Join2', 'field1': 't1f2', 'table2': 'tb2', 'field2': 't2f1', 'attr2': 't2f1a1'}
 ]
]
"""

loader_grammar = r"""
?start: _line*

_line: COMMENT | NLS  | node_def | graph_def | matrix_def | table_def | type_def | actor_def
  node_def: WS? "Node" WORD? WORD? WORD? WORD? WORD? WORD? NL (COMMENT | NL | link_def)*
  link_def: WS? "Link" WORD? NL
  graph_def: WS? "Graph" WORD? WORD? TEXT? NL
  matrix_def: WS? "Matrix" WORD? WORD? WORD? WORD? WORD? NL
  table_def: WS? "Table" WORD? WORD? WORD? NL (COMMENT | NL | field_def | of_def | join_def | join2_def)*
  field_def: WS? "Field" WORD? WORD? WORD? WORD? WORD? NL (COMMENT | NL | attrs_def)*
  attrs_def: WS? "Attrs" WORD? NL
  of_def: WS? "Of" WORD? WORD? WORD? WORD? TEXT? NL
  join_def: WS? "Join" WORD? WORD? WORD? WORD? WORD? NL
  join2_def: WS? "Join2" WORD? WORD? WORD? WORD? NL
  type_def: WS? "Type" WORD? TEXT? NL (COMMENT | NL | data_def | attr_def | where_def | logic_def)*
  data_def: WS? "Data" WORD? WORD? TEXT? NL
  attr_def: WS? "Attr" WORD? WORD? WORD? WORD? WORD? WORD? WORD? TEXT? NL
  where_def: WS? "Where" WORD? WORD? WORD? WORD? WORD? TEXT? NL
  logic_def: WS? "Logic" WORD? WORD? WORD? NL
  actor_def: WS? "Actor" WORD? WORD? WORD? WORD? WORD? TEXT? NL (COMMENT | NL | dbcreate_def | dbload_def | dbselect_def | all_def | du_def | new_def | refs_def | var_def | its_def | c_def | cs_def | cf_def | include_def | out_def | break_def | unique_def | collect_def | hash_def | group_def | add_def | clear_def | check_def | json_def | yaml_def | xml_def)*
  dbcreate_def: WS? "Dbcreate" WORD? WORD? NL
  dbload_def: WS? "Dbload" WORD? WORD? NL
  dbselect_def: WS? "Dbselect" WORD? WORD? TEXT? NL
  all_def: WS? "All" WORD? WORD? WORD? WORD? WORD? TEXT? NL
  du_def: WS? "Du" WORD? WORD? WORD? WORD? TEXT? NL
  new_def: WS? "New" WORD? WORD? TEXT? NL
  refs_def: WS? "Refs" WORD? NL
  var_def: WS? "Var" WORD? WORD? TEXT? NL
  its_def: WS? "Its" WORD? WORD? WORD? WORD? WORD? TEXT? NL
  c_def: WS? "C" TEXT? NL
  cs_def: WS? "Cs" TEXT? NL
  cf_def: WS? "Cf" TEXT? NL
  include_def: WS? "Include" WORD? TEXT? NL
  out_def: WS? "Out" WORD? WORD? TEXT? NL
  break_def: WS? "Break" WORD? WORD? WORD? NL
  unique_def: WS? "Unique" WORD? WORD? TEXT? NL
  collect_def: WS? "Collect" WORD? WORD? NL
  hash_def: WS? "Hash" WORD? WORD? WORD? TEXT? NL
  group_def: WS? "Group" WORD? WORD? WORD? TEXT? NL
  add_def: WS? "Add" WORD? WORD? WORD? TEXT? NL
  clear_def: WS? "Clear" WORD? WORD? WORD? TEXT? NL
  check_def: WS? "Check" WORD? WORD? WORD? TEXT? NL
  json_def: WS? "Json" WORD? WORD? TEXT? NL
  yaml_def: WS? "Yaml" WORD? WORD? TEXT? NL
  xml_def: WS? "Xml" WORD? WORD? TEXT? NL

NAME: /[ \t]*//[a-zA-Z_][a-zA-Z0-9_]*/
TAG: NAME COL?
COL: /[:]/
WORDS: QUOTED_WORD | WORD
QUOTED_WORD: /"[^"]*"/
WORD: /[ \t]*//[^\s]+/
TEXT: /[ \t]//[^\n\r]+/
COMMENT: /[-*][^\n\r]+/
NL: /[\n\r]/
WS: /[ \t]+/
NLS: /[\n\r]/

%ignore WS
%ignore NLS
%ignore COMMENT
"""


class LoaderTransformer(Transformer):
    def start(self, items):
        new_items = []
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def get_toks(self, items):
        toks = []
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                continue;
            if items[i].type != 'NL':
                toks.append( items[i])
        return(toks)
       
    def node_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Node"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pad" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "parent" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "var" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "eq" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "value" ] = toks[5].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def link_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Link"
        try:
            if len(toks) > 0: names[ "to" ] = toks[0].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def graph_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Graph"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pad" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "search" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def matrix_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Matrix"
        try:
            if len(toks) > 0: names[ "a" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "b" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "c" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "pad" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "search" ] = toks[4].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def table_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Table"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pad" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "value" ] = toks[2].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def field_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Field"
        try:
            if len(toks) > 0: names[ "type" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "name" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "dt" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "pad" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "use" ] = toks[4].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def attrs_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Attrs"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def of_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Of"
        try:
            if len(toks) > 0: names[ "field" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "attr" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "from" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "op" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "value" ] = toks[4].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def join_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Join"
        try:
            if len(toks) > 0: names[ "field1" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "table2" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "field2" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "pad" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "use" ] = toks[4].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def join2_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Join2"
        try:
            if len(toks) > 0: names[ "field1" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "table2" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "field2" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "attr2" ] = toks[3].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def type_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Type"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "desc" ] = toks[1].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def data_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Data"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "op" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "value" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def attr_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Attr"
        try:
            if len(toks) > 0: names[ "table" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "relation" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "name" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "mytype" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "len" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "null" ] = toks[5].value.lstrip()
            if len(toks) > 6: names[ "flags" ] = toks[6].value.lstrip()
            if len(toks) > 7: names[ "desc" ] = toks[7].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def where_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Where"
        try:
            if len(toks) > 0: names[ "attr" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "from_id" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "eq" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "id" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "op" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "value" ] = toks[5].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def logic_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Logic"
        try:
            if len(toks) > 0: names[ "attr" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "op" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "code" ] = toks[2].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def actor_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Actor"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "comp" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "attr" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "eq" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "value" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "cc" ] = toks[5].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def dbcreate_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Dbcreate"
        try:
            if len(toks) > 0: names[ "where" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "tbl" ] = toks[1].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def dbload_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Dbload"
        try:
            if len(toks) > 0: names[ "where" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "tbl" ] = toks[1].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def dbselect_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Dbselect"
        try:
            if len(toks) > 0: names[ "actor" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "where" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "what" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def all_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "All"
        try:
            if len(toks) > 0: names[ "what" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "actor" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "attr" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "eq" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "value" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "args" ] = toks[5].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def du_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Du"
        try:
            if len(toks) > 0: names[ "actor" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "attr" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "eq" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "value" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "args" ] = toks[4].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def new_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "New"
        try:
            if len(toks) > 0: names[ "where" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "what" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "line" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def refs_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Refs"
        try:
            if len(toks) > 0: names[ "where" ] = toks[0].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def var_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Var"
        try:
            if len(toks) > 0: names[ "attr" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "eq" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "value" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def its_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Its"
        try:
            if len(toks) > 0: names[ "what" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "actor" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "attr" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "eq" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "value" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "args" ] = toks[5].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def c_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "C"
        try:
            if len(toks) > 0: names[ "desc" ] = toks[0].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def cs_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Cs"
        try:
            if len(toks) > 0: names[ "desc" ] = toks[0].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def cf_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Cf"
        try:
            if len(toks) > 0: names[ "desc" ] = toks[0].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def include_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Include"
        try:
            if len(toks) > 0: names[ "opt" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "file" ] = toks[1].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def out_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Out"
        try:
            if len(toks) > 0: names[ "what" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pad" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "desc" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def break_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Break"
        try:
            if len(toks) > 0: names[ "what" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pad" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "actor" ] = toks[2].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def unique_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Unique"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "key" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "value" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def collect_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Collect"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pocket" ] = toks[1].value.lstrip()
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def hash_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Hash"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pocket" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "key" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "value" ] = toks[3].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def group_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Group"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pocket" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "key" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "value" ] = toks[3].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def add_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Add"
        try:
            if len(toks) > 0: names[ "pocket" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "what" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "item" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "data" ] = toks[3].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def clear_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Clear"
        try:
            if len(toks) > 0: names[ "pocket" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "what" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "item" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "data" ] = toks[3].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def check_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Check"
        try:
            if len(toks) > 0: names[ "pocket" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "what" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "item" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "data" ] = toks[3].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def json_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Json"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pocket" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "file" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def yaml_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Yaml"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pocket" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "file" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def xml_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Xml"
        try:
            if len(toks) > 0: names[ "cmd" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pocket" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "file" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

parser = Lark(loader_grammar, parser='lalr', transformer=LoaderTransformer())
tree = parser.parse(input_text)
print(tree)

