from lark import Lark, Transformer

class LoaderTransformer(Transformer):
    def node_def(self, items):
        names = {}
        names[ "me" ] = "Node"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pad" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "parent" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "var" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "eq" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "value" ] = items[5].value.lstrip()
        except:
            pass
        return(names)
    def link_def(self, items):
        names = {}
        names[ "me" ] = "Link"
        try:
            if len(items) > 1: names[ "to" ] = items[0].value.lstrip()
        except:
            pass
        return(names)
    def graph_def(self, items):
        names = {}
        names[ "me" ] = "Graph"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pad" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "search" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def matrix_def(self, items):
        names = {}
        names[ "me" ] = "Matrix"
        try:
            if len(items) > 1: names[ "a" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "b" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "c" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "pad" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "search" ] = items[4].value.lstrip()
        except:
            pass
        return(names)
    def table_def(self, items):
        names = {}
        names[ "me" ] = "Table"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pad" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "value" ] = items[2].value.lstrip()
        except:
            pass
        return(names)
    def field_def(self, items):
        names = {}
        names[ "me" ] = "Field"
        try:
            if len(items) > 1: names[ "type" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "name" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "dt" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "pad" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "use" ] = items[4].value.lstrip()
        except:
            pass
        return(names)
    def attrs_def(self, items):
        names = {}
        names[ "me" ] = "Attrs"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
        except:
            pass
        return(names)
    def of_def(self, items):
        names = {}
        names[ "me" ] = "Of"
        try:
            if len(items) > 1: names[ "field" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "attr" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "from" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "op" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "value" ] = items[4].value[1:]
        except:
            pass
        return(names)
    def join_def(self, items):
        names = {}
        names[ "me" ] = "Join"
        try:
            if len(items) > 1: names[ "field1" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "table2" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "field2" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "pad" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "use" ] = items[4].value.lstrip()
        except:
            pass
        return(names)
    def join2_def(self, items):
        names = {}
        names[ "me" ] = "Join2"
        try:
            if len(items) > 1: names[ "field1" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "table2" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "field2" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "attr2" ] = items[3].value.lstrip()
        except:
            pass
        return(names)
    def type_def(self, items):
        names = {}
        names[ "me" ] = "Type"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "desc" ] = items[1].value[1:]
        except:
            pass
        return(names)
    def data_def(self, items):
        names = {}
        names[ "me" ] = "Data"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "op" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "value" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def attr_def(self, items):
        names = {}
        names[ "me" ] = "Attr"
        try:
            if len(items) > 1: names[ "table" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "relation" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "name" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "mytype" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "len" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "null" ] = items[5].value.lstrip()
            if len(items) > 7: names[ "flags" ] = items[6].value.lstrip()
            if len(items) > 8: names[ "desc" ] = items[7].value[1:]
        except:
            pass
        return(names)
    def where_def(self, items):
        names = {}
        names[ "me" ] = "Where"
        try:
            if len(items) > 1: names[ "attr" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "from_id" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "eq" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "id" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "op" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "value" ] = items[5].value[1:]
        except:
            pass
        return(names)
    def logic_def(self, items):
        names = {}
        names[ "me" ] = "Logic"
        try:
            if len(items) > 1: names[ "attr" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "op" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "code" ] = items[2].value.lstrip()
        except:
            pass
        return(names)
    def actor_def(self, items):
        names = {}
        names[ "me" ] = "Actor"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "comp" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "attr" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "eq" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "value" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "cc" ] = items[5].value[1:]
        except:
            pass
        return(names)
    def dbcreate_def(self, items):
        names = {}
        names[ "me" ] = "Dbcreate"
        try:
            if len(items) > 1: names[ "where" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "tbl" ] = items[1].value.lstrip()
        except:
            pass
        return(names)
    def dbload_def(self, items):
        names = {}
        names[ "me" ] = "Dbload"
        try:
            if len(items) > 1: names[ "where" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "tbl" ] = items[1].value.lstrip()
        except:
            pass
        return(names)
    def dbselect_def(self, items):
        names = {}
        names[ "me" ] = "Dbselect"
        try:
            if len(items) > 1: names[ "actor" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "where" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "what" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def all_def(self, items):
        names = {}
        names[ "me" ] = "All"
        try:
            if len(items) > 1: names[ "what" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "actor" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "attr" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "eq" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "value" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "args" ] = items[5].value[1:]
        except:
            pass
        return(names)
    def du_def(self, items):
        names = {}
        names[ "me" ] = "Du"
        try:
            if len(items) > 1: names[ "actor" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "attr" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "eq" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "value" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "args" ] = items[4].value[1:]
        except:
            pass
        return(names)
    def new_def(self, items):
        names = {}
        names[ "me" ] = "New"
        try:
            if len(items) > 1: names[ "where" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "what" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "line" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def refs_def(self, items):
        names = {}
        names[ "me" ] = "Refs"
        try:
            if len(items) > 1: names[ "where" ] = items[0].value.lstrip()
        except:
            pass
        return(names)
    def var_def(self, items):
        names = {}
        names[ "me" ] = "Var"
        try:
            if len(items) > 1: names[ "attr" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "eq" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "value" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def its_def(self, items):
        names = {}
        names[ "me" ] = "Its"
        try:
            if len(items) > 1: names[ "what" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "actor" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "attr" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "eq" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "value" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "args" ] = items[5].value[1:]
        except:
            pass
        return(names)
    def c_def(self, items):
        names = {}
        names[ "me" ] = "C"
        try:
            if len(items) > 1: names[ "desc" ] = items[0].value[1:]
        except:
            pass
        return(names)
    def cs_def(self, items):
        names = {}
        names[ "me" ] = "Cs"
        try:
            if len(items) > 1: names[ "desc" ] = items[0].value[1:]
        except:
            pass
        return(names)
    def cf_def(self, items):
        names = {}
        names[ "me" ] = "Cf"
        try:
            if len(items) > 1: names[ "desc" ] = items[0].value[1:]
        except:
            pass
        return(names)
    def include_def(self, items):
        names = {}
        names[ "me" ] = "Include"
        try:
            if len(items) > 1: names[ "opt" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "file" ] = items[1].value[1:]
        except:
            pass
        return(names)
    def out_def(self, items):
        names = {}
        names[ "me" ] = "Out"
        try:
            if len(items) > 1: names[ "what" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pad" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "desc" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def break_def(self, items):
        names = {}
        names[ "me" ] = "Break"
        try:
            if len(items) > 1: names[ "what" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pad" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "actor" ] = items[2].value.lstrip()
        except:
            pass
        return(names)
    def unique_def(self, items):
        names = {}
        names[ "me" ] = "Unique"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "key" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "value" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def collect_def(self, items):
        names = {}
        names[ "me" ] = "Collect"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pocket" ] = items[1].value.lstrip()
        except:
            pass
        return(names)
    def hash_def(self, items):
        names = {}
        names[ "me" ] = "Hash"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pocket" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "key" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "value" ] = items[3].value[1:]
        except:
            pass
        return(names)
    def group_def(self, items):
        names = {}
        names[ "me" ] = "Group"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pocket" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "key" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "value" ] = items[3].value[1:]
        except:
            pass
        return(names)
    def add_def(self, items):
        names = {}
        names[ "me" ] = "Add"
        try:
            if len(items) > 1: names[ "pocket" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "what" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "item" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "data" ] = items[3].value[1:]
        except:
            pass
        return(names)
    def clear_def(self, items):
        names = {}
        names[ "me" ] = "Clear"
        try:
            if len(items) > 1: names[ "pocket" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "what" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "item" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "data" ] = items[3].value[1:]
        except:
            pass
        return(names)
    def check_def(self, items):
        names = {}
        names[ "me" ] = "Check"
        try:
            if len(items) > 1: names[ "pocket" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "what" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "item" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "data" ] = items[3].value[1:]
        except:
            pass
        return(names)
    def json_def(self, items):
        names = {}
        names[ "me" ] = "Json"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pocket" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "file" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def yaml_def(self, items):
        names = {}
        names[ "me" ] = "Yaml"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pocket" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "file" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def xml_def(self, items):
        names = {}
        names[ "me" ] = "Xml"
        try:
            if len(items) > 1: names[ "cmd" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pocket" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "file" ] = items[2].value[1:]
        except:
            pass
        return(names)

parser = Lark(loader_grammar, parser='lalr', transformer=LoaderTransformer())

