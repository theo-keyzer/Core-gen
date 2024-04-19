class Input:
    def __init__(self, s: str):
        self.lines = []
        self.pos = 0
        self.get_lines(s)

    def get_lines(self, s: str):
        b = 0
        p = 0
        while p < len(s):
            c = s[p]
            if c == '\n' or c == '\r':
                self.lines.append(s[b:p])
                b = p + 1
            p += 1

    def getws(self, ln: str, p: int) -> str:
        l = len(ln)
        pos = self.pos
        if p == 0:
            pos = 0
        if pos + 1 > l:
            return ""
        self.pos = l
        return ln[pos + 1:l]

    def getw(self, ln: str, p: int) -> str:
        l = len(ln)
        pos = self.pos
        if p == 0:
            pos = 0
        f = pos
        i = pos
        if pos + 1 > l:
            return "E_O_L"
        while i < l:
            f = i + 1
            if ln[i] == ' ' or ln[i] == '\t':
                i += 1
                continue
            f = i
            break
        if f + 1 > l:
            return "E_O_L"
        to = f
        i = f
        while i < l:
            if ln[i] == ' ' or ln[i] == '\t':
                break
            to = i
            i += 1
        self.pos = to + 1
        return ln[f:to + 1]

    def getwsw(self, ln: str, p: int) -> str:
        l = len(ln)
        pos = self.pos
        if p == 0:
            pos = 0
        f = pos
        i = pos
        if pos + 1 > l:
            return "E_O_L"
        while i < l:
            f = i + 1
            if ln[i] == ' ' or ln[i] == '\t':
                i += 1
                continue
            f = i
            break
        if f + 1 > l:
            return "E_O_L"
        to = f
        i = f
        is_s = 0
        while i < l:
            if ln[i] == ' ' or ln[i] == '\t':
                break
            if ln[i] == ':':
                is_s = 1
                break
            to = i
            i += 1
        if is_s == 1:
            self.pos = to + 2
            return ln[f:to + 1]
        self.pos = to + 1
        return ln[f:to + 1]

