from lark import Lark, Transformer

# check for optional values

class LoaderTransformer(Transformer):
    def comp_def(self, items):
        names = {}
        names[ "name" = items[0].value
        names[ "nop" = items[1].value
        names[ "parent" = items[2].value
        names[ "find" = items[3].value
        names[ "doc" = items[4].value
        return(names)
    def element_def(self, items):
        names = {}
        names[ "name" = items[0].value
        names[ "mw" = items[1].value
        names[ "mw2" = items[2].value
        names[ "pad" = items[3].value
        names[ "doc" = items[4].value
        return(names)
    def opt_def(self, items):
        names = {}
        names[ "name" = items[0].value
        names[ "pad" = items[1].value
        names[ "doc" = items[2].value
        return(names)
    def ref_def(self, items):
        names = {}
        names[ "element" = items[0].value
        names[ "comp" = items[1].value
        names[ "opt" = items[2].value
        names[ "var" = items[3].value
        names[ "doc" = items[4].value
        return(names)
    def ref2_def(self, items):
        names = {}
        names[ "element" = items[0].value
        names[ "comp" = items[1].value
        names[ "element2" = items[2].value
        names[ "opt" = items[3].value
        names[ "var" = items[4].value
        names[ "doc" = items[5].value
        return(names)
    def ref3_def(self, items):
        names = {}
        names[ "element" = items[0].value
        names[ "comp" = items[1].value
        names[ "element2" = items[2].value
        names[ "comp_ref" = items[3].value
        names[ "element3" = items[4].value
        names[ "opt" = items[5].value
        names[ "var" = items[6].value
        names[ "doc" = items[7].value
        return(names)
    def refq_def(self, items):
        names = {}
        names[ "element" = items[0].value
        names[ "comp" = items[1].value
        names[ "element2" = items[2].value
        names[ "comp_ref" = items[3].value
        names[ "opt" = items[4].value
        names[ "var" = items[5].value
        names[ "doc" = items[6].value
        return(names)
    def actor_def(self, items):
        names = {}
        names[ "name" = items[0].value
        names[ "comp" = items[1].value
        names[ "attr" = items[2].value
        names[ "eq" = items[3].value
        names[ "value" = items[4].value
        names[ "cc" = items[5].value
        return(names)
    def all_def(self, items):
        names = {}
        names[ "what" = items[0].value
        names[ "actor" = items[1].value
        names[ "attr" = items[2].value
        names[ "eq" = items[3].value
        names[ "value" = items[4].value
        names[ "args" = items[5].value
        return(names)
    def du_def(self, items):
        names = {}
        names[ "actor" = items[0].value
        names[ "attr" = items[1].value
        names[ "eq" = items[2].value
        names[ "value" = items[3].value
        names[ "args" = items[4].value
        return(names)
    def its_def(self, items):
        names = {}
        names[ "what" = items[0].value
        names[ "actor" = items[1].value
        names[ "attr" = items[2].value
        names[ "eq" = items[3].value
        names[ "value" = items[4].value
        names[ "args" = items[5].value
        return(names)
    def c_def(self, items):
        names = {}
        names[ "desc" = items[0].value
        return(names)
    def cs_def(self, items):
        names = {}
        names[ "desc" = items[0].value
        return(names)
    def cf_def(self, items):
        names = {}
        names[ "desc" = items[0].value
        return(names)
    def out_def(self, items):
        names = {}
        names[ "what" = items[0].value
        names[ "pad" = items[1].value
        names[ "desc" = items[2].value
        return(names)
    def break_def(self, items):
        names = {}
        names[ "what" = items[0].value
        names[ "pad" = items[1].value
        names[ "actor" = items[2].value
        return(names)
    def unique_def(self, items):
        names = {}
        names[ "cmd" = items[0].value
        names[ "key" = items[1].value
        names[ "value" = items[2].value
        return(names)

parser = Lark(loader_grammar, parser='lalr', transformer=LoaderTransformer())

