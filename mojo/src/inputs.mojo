from collections import KeyElement
from collections.list import List
from collections import Dict


struct Input:
    var lines: List[String]
    var pos: Int
    
    fn __init__(inout self, owned s: String):
        self.lines = List[String]()
        self.pos = 0
        self.get_lines(s)

    fn get_lines(inout self, s: String):
        var b = 0
        var p = 0
        while p < len(s):
            var c = s[p]
            if c == '\n' or c == '\r':
                self.lines.append( s[b:p] )
                b = p + 1
            p += 1

    fn getws(inout self, ln: String, p: Int) -> String:
        var l = len(ln)
        var pos = self.pos
        if p == 0:
            pos = 0
        if pos+1 > l:
            return("")
        self.pos = l
        return( ln[pos+1:l] )

    fn getw(inout self, ln: String, p: Int) -> String:
        var l = len(ln)
        var pos = self.pos
        if p == 0:
            pos = 0
        var f = pos
        var i = pos
        if pos+1 > l:
            return("E_O_L")
        while (i < l) :
            f = i + 1;
            if (ln[i] == ' ' or ln[i] == '\t'):
                i = i+1
                continue
            f = i
            break
        if f+1 > l:
            return("E_O_L")
        var to = f;
        i = f;	
        while (i < l) :
            if (ln[i] == ' ' or ln[i] == '\t'):
                break
            to = i
            i = i + 1
        self.pos = to+1
        return( ln[f:to+1] )

    fn getwsw(inout self, ln: String, p: Int) -> String:
        var l = len(ln)
        var pos = self.pos
        if p == 0:
            pos = 0
        var f = pos
        var i = pos
        if pos+1 > l:
            return("E_O_L")
        while (i < l) :
            f = i + 1;
            if (ln[i] == ' ' or ln[i] == '\t'):
                i = i+1
                continue
            f = i
            break
        if f+1 > l:
            return("E_O_L")
        var to = f;
        i = f;	
        var is_s = 0	
        while (i < l) :
            if (ln[i] == ' ' or ln[i] == '\t'):
                break
            if (ln[i] == ':'):
                is_s = 1
                break
            to = i
            i = i + 1
        if is_s == 1:
            self.pos = to+2
            return( ln[f:to+1] )
        self.pos = to+1
        return( ln[f:to+1] )





