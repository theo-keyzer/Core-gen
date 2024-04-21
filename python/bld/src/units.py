from lark import Lark, Transformer

class LoaderTransformer(Transformer):
    def comp_def(self, items):
        names = {}
        names[ "me" ] = "Comp"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "nop" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "parent" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "find" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "doc" ] = items[4].value[1:]
        except:
            pass
        return(names)
    def element_def(self, items):
        names = {}
        names[ "me" ] = "Element"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "mw" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "mw2" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "pad" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "doc" ] = items[4].value[1:]
        except:
            pass
        return(names)
    def opt_def(self, items):
        names = {}
        names[ "me" ] = "Opt"
        try:
            if len(items) > 1: names[ "name" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "pad" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "doc" ] = items[2].value[1:]
        except:
            pass
        return(names)
    def ref_def(self, items):
        names = {}
        names[ "me" ] = "Ref"
        try:
            if len(items) > 1: names[ "element" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "comp" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "opt" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "var" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "doc" ] = items[4].value[1:]
        except:
            pass
        return(names)
    def ref2_def(self, items):
        names = {}
        names[ "me" ] = "Ref2"
        try:
            if len(items) > 1: names[ "element" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "comp" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "element2" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "opt" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "var" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "doc" ] = items[5].value[1:]
        except:
            pass
        return(names)
    def ref3_def(self, items):
        names = {}
        names[ "me" ] = "Ref3"
        try:
            if len(items) > 1: names[ "element" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "comp" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "element2" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "comp_ref" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "element3" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "opt" ] = items[5].value.lstrip()
            if len(items) > 7: names[ "var" ] = items[6].value.lstrip()
            if len(items) > 8: names[ "doc" ] = items[7].value[1:]
        except:
            pass
        return(names)
    def refq_def(self, items):
        names = {}
        names[ "me" ] = "Refq"
        try:
            if len(items) > 1: names[ "element" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "comp" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "element2" ] = items[2].value.lstrip()
            if len(items) > 4: names[ "comp_ref" ] = items[3].value.lstrip()
            if len(items) > 5: names[ "opt" ] = items[4].value.lstrip()
            if len(items) > 6: names[ "var" ] = items[5].value.lstrip()
            if len(items) > 7: names[ "doc" ] = items[6].value[1:]
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
    def all_def(self, items):
        names = {}
        names[ "me" ] = "All"
        try:
            if len(items) > 1: names[ "what" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "actor" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "args" ] = items[2].value[1:]
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
    def its_def(self, items):
        names = {}
        names[ "me" ] = "Its"
        try:
            if len(items) > 1: names[ "what" ] = items[0].value.lstrip()
            if len(items) > 2: names[ "actor" ] = items[1].value.lstrip()
            if len(items) > 3: names[ "args" ] = items[2].value[1:]
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

parser = Lark(loader_grammar, parser='lalr', transformer=LoaderTransformer())

