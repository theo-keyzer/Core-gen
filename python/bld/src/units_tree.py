from lark import Lark, Transformer

loader_grammar = r"""
"""

input_text = """
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
       
    def comp_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Comp"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "nop" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "parent" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "find" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "doc" ] = toks[4].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def element_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Element"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "mw" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "mw2" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "pad" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "doc" ] = toks[4].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def opt_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Opt"
        try:
            if len(toks) > 0: names[ "name" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "pad" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "doc" ] = toks[2].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def ref_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Ref"
        try:
            if len(toks) > 0: names[ "element" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "comp" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "opt" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "var" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "doc" ] = toks[4].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def ref2_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Ref2"
        try:
            if len(toks) > 0: names[ "element" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "comp" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "element2" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "opt" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "var" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "doc" ] = toks[5].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def ref3_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Ref3"
        try:
            if len(toks) > 0: names[ "element" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "comp" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "element2" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "comp_ref" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "element3" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "opt" ] = toks[5].value.lstrip()
            if len(toks) > 6: names[ "var" ] = toks[6].value.lstrip()
            if len(toks) > 7: names[ "doc" ] = toks[7].value[1:]
        except:
            pass
        new_items.append(names)
        for i in range(0, len(items) ):
            if isinstance(items[i], dict) or isinstance(items[i], list):
                new_items.append( items[i])
        return(new_items)

    def refq_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Refq"
        try:
            if len(toks) > 0: names[ "element" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "comp" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "element2" ] = toks[2].value.lstrip()
            if len(toks) > 3: names[ "comp_ref" ] = toks[3].value.lstrip()
            if len(toks) > 4: names[ "opt" ] = toks[4].value.lstrip()
            if len(toks) > 5: names[ "var" ] = toks[5].value.lstrip()
            if len(toks) > 6: names[ "doc" ] = toks[6].value[1:]
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

    def all_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "All"
        try:
            if len(toks) > 0: names[ "what" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "actor" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "args" ] = toks[2].value[1:]
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

    def its_def(self, items):
        toks = self.get_toks(items)
        new_items = []
        names = {}
        names[ "me" ] = "Its"
        try:
            if len(toks) > 0: names[ "what" ] = toks[0].value.lstrip()
            if len(toks) > 1: names[ "actor" ] = toks[1].value.lstrip()
            if len(toks) > 2: names[ "args" ] = toks[2].value[1:]
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

parser = Lark(loader_grammar, parser='lalr', transformer=LoaderTransformer())
tree = parser.parse(input_text)
print(tree)

