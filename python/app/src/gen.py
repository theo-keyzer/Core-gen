import structs
import json
import re

import sqlite3 
import requests

class WinT:
    def __init__(self):
        self.dat = structs.Kp()
        self.name = ""
        self.item = ""
        self.arg = ""
        self.lcnt = 0
        self.brk_act = False
        self.cur_act = 0
        self.cur_pos = 0
        self.on_pos = 0
        self.is_on = False
        self.is_trig = False
        self.is_prev = False
        self.is_check = False

def new_act(glob, arg):
    winp = glob.winp + 1
    if len(glob.wins) <= winp:
        glob.wins.append(WinT())
    glob.wins[winp].arg = arg
    glob.wins[winp].lcnt = -1
    glob.wins[winp].brk_act = False
    if winp == 0:
        return
    if glob.wins[winp - 1].is_on or glob.wins[winp - 1].is_prev:
        if not glob.wins[winp - 1].is_trig:
            glob.wins[winp].is_prev = True

def go_act(dat, glob, act):
    if act < 0:
        return(0)
    name = glob.acts.ap_actor[act].k_name
    glob.winp += 1
    glob.wins[glob.winp].dat = dat;
    glob.wins[glob.winp].name = name
    prev = False
    for a in range(len(glob.acts.ap_actor)):
        if name != glob.acts.ap_actor[a].k_name:
            continue
        attr = glob.acts.ap_actor[a].k_attr
        val = glob.acts.ap_actor[a].k_value
        cc = glob.acts.ap_actor[a].k_cc
        eq = glob.acts.ap_actor[a].k_eq
        lno = glob.acts.ap_actor[a].line_no
        if attr != "E_O_L":
            sc = attr.split(":")
            ss = sc[0].split(".")
            if glob.acts.ap_actor[a].flag == "r":
                val = val
            else:
                val,err = strs(glob, val, glob.winp, lno, False, False)
            aval,aerr = s_get_var(glob, sc, ss, glob.winp, lno)
            prev = chk(glob, eq, aval, val, prev, aerr, err, lno)
            if not prev:
                continue
        if cc != "":
            ps,err = strs(glob, cc, glob.winp, lno, True, True)
            print(ps)
        glob.wins[glob.winp].cur_act = a
        glob.wins[glob.winp].lcnt += 1
        ret = go_cmds(dat, glob, a)
        if ret == 0 or ret == 3:
            continue
        nret = ret
        if ret == 2:
            nret = 0
        if ret < 0 and glob.wins[glob.winp].brk_act:
            nret = -ret
        glob.winp -= 1
        return nret
    glob.winp -= 1
    return 0

def go_cmds(dat, glob, act: int) -> int:
    glob.wins[glob.winp].is_on = False
    glob.wins[glob.winp].is_trig = False
    glob.wins[glob.winp].on_pos = -1
    glob.wins[glob.winp].is_check = False
    for c in range(glob.acts.ap_actor[act].all_from, glob.acts.ap_actor[act].all_to):
        glob.wins[glob.winp].cur_pos = c
        cmd = glob.acts.kp_all[c]
        if isinstance(cmd,structs.KpIn):
            if cmd.k_flag == "on":
                glob.is_in = True
            if cmd.k_flag == "off":
                glob.is_in = False
            if cmd.k_flag == "clear":
                glob.ins = ""
        if isinstance(cmd,structs.KpC):
            if glob.wins[glob.winp].is_on and not glob.wins[glob.winp].is_trig:
                continue
            trig(glob, glob.winp)
            cc = cmd
            if cmd.flag == "r":
                st = cmd.k_desc
            else:
                st,err = strs(glob, cc.k_desc, glob.winp, cc.line_no, False, True)
            if glob.is_in:
                glob.ins += st + "\n"
            else:
                print( st )
        if isinstance(cmd,structs.KpCs):
            if glob.wins[glob.winp].is_on and not glob.wins[glob.winp].is_trig:
                continue
            trig(glob, glob.winp)
            cc = cmd
            if cmd.flag == "r":
                st = cmd.k_desc
            else:
                st,err = strs(glob, cc.k_desc, glob.winp, cc.line_no, False, True)
            if glob.is_in:
                glob.ins += st
            else:
                print( st, end="" )
        elif isinstance(cmd,structs.KpCf):
            if glob.wins[glob.winp].lcnt == 0:
                cf = cmd
                st,err = strs(glob, cf.k_desc, glob.winp, cf.line_no, False, True)
                if glob.is_in:
                    glob.ins += st + "\n"
                else:
                    print(st)
        elif isinstance(cmd,structs.KpAll):
            all = cmd
            val,err = strs(glob, all.k_args, glob.winp, cmd.line_no, True, True)
            what = all.k_what.split(".")
            new_act(glob,val)
            ret = structs.do_all(glob, what, all.k_actorp)
            if ret > 1 or ret < 0:
                return ret
        elif isinstance(cmd,structs.KpThat):
            its = cmd
            what,err = strs(glob, its.k_what, glob.winp, cmd.line_no, True, True)
            what = what.split(".")
            if cmd.flag == "r":
                val = cmd.k_args
            else:
                val,err = strs(glob, its.k_args, glob.winp, cmd.line_no, True, True)
            filen,err = strs(glob, its.k_file, glob.winp, cmd.line_no, True, True)
            pad,err = strs(glob, its.k_pad, glob.winp, cmd.line_no, True, True)
            new_act(glob, val)
            col = ""
            if len(what) > 1 and what[0] == "url" and what[1] == "get":
                url = filen
                if val == "":
                    response = requests.get(url)
                else:
                    payload = json.loads(val)
                    response = requests.get(url, params=payload)
                glob.wins[glob.winp+1].item = str( response.status_code )
                response_json = response.json()
                if isinstance(response_json, list):
                    ret = go_act(response_json, glob, its.k_actorp)
                else:
                    ret = go_act( [response_json], glob, its.k_actorp)
                if ret > 1 or ret < 0:
                    return ret
                continue
            if len(what) > 1 and what[0] == "url" and what[1] == "post":
                url = filen
                payload = json.loads(val)
                response = requests.post(url, json=payload)
                glob.wins[glob.winp+1].item = str( response.status_code )
                response_json = response.json()
                if isinstance(response_json, list):
                    ret = go_act(response_json, glob, its.k_actorp)
                else:
                    ret = go_act( [response_json], glob, its.k_actorp)
                if ret > 1 or ret < 0:
                    return ret
                continue
            if what[0] == "db":
                conn = sqlite3.connect(filen) 
                cur = conn.cursor() 
                cur.execute(val)
                key = ""
                for keyb in cur.description:
                    if key == "":
                        key = keyb[0]
                    else:
                        key = key + "," + keyb[0]
                glob.wins[glob.winp+1].item = key
                result = cur.fetchall() 
                if isinstance(result, list):
                    ret = go_act(result, glob, its.k_actorp)
                else:
                    ret = go_act( [result], glob, its.k_actorp)
                if ret > 1 or ret < 0:
                    return ret
                continue
            if what[0] == "file":
                try:
                    with open(filen, "r") as f:
                        ff = f.read()
                        ret = go_act(ff, glob, its.k_actorp)
                        if ret > 1 or ret < 0:
                            return ret
                except:
                    if its.k_pad != "if":
                        print("File (" + filen + ") error")
                        glob.run_errs = True
                continue
            if what[0] == "regx":
                match = re.match(val,filen)
                if match:
                    grps = match.groups()
                    ret = go_act(grps, glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
                continue
            if what[0] == "re_sub":
                out_string = re.sub(val, pad, filen)
                ret = go_act(out_string, glob, its.k_actorp)
                if ret > 1 or ret < 0:
                    return ret
                continue
            if what[0] == "json":
                if its.k_pad == "string":
                    json_data = json.loads(filen)
                else:
                    with open(filen) as fd:
                        json_data = json.load(fd)
                key = ""
                if len(what) == 1:
                    glob.wins[glob.winp+1].item = its.k_file
                    ret = go_act(json_data, glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
                    continue
                ret = its_cmd(glob, cmd, json_data, what[1:], "", its.k_actorp)
                if ret > 1 or ret < 0:
                    return ret
                continue
            continue
        elif isinstance(cmd,structs.KpThis):
            its = cmd
            what,err = strs(glob, its.k_what, glob.winp, cmd.line_no, True, True)
            what = what.split(".")
            val,err = strs(glob, its.k_args, glob.winp, cmd.line_no, True, True)
            new_act(glob, val)
            col = ""
            if what[0] == "set":
                col = glob.sets
            elif what[0] == "list":
                col = glob.lists
            elif what[0] == "var":
                col = glob.vars
            else:
                continue
            if len(what) > 1 and what[1] != "":
                if what[1] in col:
                    glob.wins[glob.winp+1].item = what[1]
                    poc = col[ what[1] ]
                    if what[0] == "var":
                        if len(what) > 2:
                            ret = its_cmd(glob, cmd, poc, what[2:], what[1], its.k_actorp)
                            if ret > 1 or ret < 0:
                                return ret
                            continue
                        ret = go_act(poc, glob, its.k_actorp)
                        if ret > 1 or ret < 0:
                            return ret
                        continue
                    for sts in poc:
                        if len(what) > 2:
                            ret = its_cmd(glob, cmd, sts, what[2:], what[1], its.k_actorp)
                            if ret > 1 or ret < 0:
                                return ret
                            continue
                        ret = go_act(sts, glob, its.k_actorp)
                        if ret > 1 or ret < 0:
                            return ret
                continue
            keys = list(col.keys())
            for key in keys:
                glob.wins[glob.winp+1].item = key
                if len(what) == 1:
                    ret = go_act(col[ key ], glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
                    continue
                poc = col[ key ]
                if what[0] == "var":
                    ret = go_act(poc, glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
                    continue
                for sts in poc:
                    ret = go_act(sts,glob, its.k_actorp)
                    if ret > 1 or ret < 0:
                        return ret
            continue
        elif isinstance(cmd,structs.KpIts):
            its = cmd
            what = its.k_what.split(".")
            val,err = strs(glob, its.k_args, glob.winp, cmd.line_no, True, True)
            new_act(glob, val)
            ret = its_cmd(glob, cmd, dat, what, "", its.k_actorp)
            if ret > 1 or ret < 0:
                return ret
            continue
        elif isinstance(cmd,structs.KpDu):
            du = cmd
            st,err = strs(glob, du.k_args, glob.winp, du.line_no, True, True)
            new_act(glob, st)
            ret = go_act(dat, glob, du.k_actorp)
            if ret != 0:
                return ret
        elif isinstance(cmd,structs.KpAdd):
            add_cmd(cmd,glob,dat)
        elif isinstance(cmd,structs.KpCheck):
            check_cmd(cmd,glob,dat)
        elif isinstance(cmd,structs.KpClear):
            clear_cmd(cmd,glob,dat)
        elif isinstance(cmd,structs.KpOut):
            out = cmd
            if out.k_what == "delay":
                glob.wins[glob.winp].is_on = True
                glob.wins[glob.winp].on_pos = c
            elif out.k_what == "normal":
                glob.wins[glob.winp].is_on = False
                glob.wins[glob.winp].is_trig = False
        elif isinstance(cmd,structs.KpBreak):
            brk = cmd
            if brk.k_check == "True" and glob.wins[glob.winp].is_check == False:
                continue
            if brk.k_check == "False" and glob.wins[glob.winp].is_check == True:
                continue
            ret = 0
            if brk.k_what == "E_O_L" or brk.k_what == "actor":
                ret = 2
            elif brk.k_what == "loop":
                ret = 1
            elif brk.k_what == "cmds":
                ret = 3
            if brk.k_actor != "E_O_L" and brk.k_actor != ".":
                for i in range(glob.winp - 1, -1, -1):
                    if brk.k_actor == glob.wins[i].name:
                        glob.wins[i + 1].brk_act = True
                        ret = -ret
            return ret
    return 0

def its_cmd(glob, cmd, dat, what, pkey, act) -> int:
    if len(what) > 1 and what[0] == "" and what[1] == "names":
        keys = list(dat.names.keys())
        for keyb in keys:
            glob.wins[glob.winp+1].item = keyb
            poc = dat.names[ keyb ]
            ret = go_act(poc, glob, act)
            if ret > 1 or ret < 0:
                return ret
        return(0)
    if isinstance(dat, list) or isinstance(dat, tuple):
        for poc in dat:
            glob.wins[glob.winp+1].item = pkey
            ret = go_act(poc, glob, act)
            if ret > 1 or ret < 0:
                return ret
        return(0)
    if isinstance(dat, dict):
        poc = dat
        dot = False
        key = pkey
        glob.wins[glob.winp+1].item = key
        for ji in range(0, len(what)):
            if len( what[ji] ) == 0:
                dot = True
                break
            poc = poc[ what[ji] ]
            if key == "":
                key = what[ji]
            else:
                key = key + "," + what[ji]
        glob.wins[glob.winp+1].item = key
        if dot and isinstance(poc,list):
            for item in poc:
                ret = go_act(item, glob, act)
                if ret > 1 or ret < 0:
                    return ret
            return(0)
        if dot and isinstance(poc,dict):
            keys = list(poc.keys())
            for keyb in keys:
                if key == "":
                    glob.wins[glob.winp+1].item = keyb
                else:
                    glob.wins[glob.winp+1].item = key + "," + keyb
                poc2 = poc[ keyb ]
                ret = go_act(poc2, glob, act)
                if ret > 1 or ret < 0:
                    return ret
            return(0)
        ret = go_act(poc, glob, act)
        if ret > 1 or ret < 0:
            return ret
        return(0)
    ret = dat.do_its(glob, what, act)
    if ret > 1 or ret < 0:
        return ret
    return(0)

def add_cmd(cmd,glob,dat):
    glob.wins[glob.winp].is_check = False
    k_item,err = strs(glob, cmd.k_item, glob.winp, cmd.line_no, True, True)
    if cmd.flag == "r":
        val = cmd.k_data
    else:
        val,err = strs(glob, cmd.k_data, glob.winp, cmd.line_no, True, True)
    if cmd.flag != "r" and val == "":
        val = dat
    if cmd.k_what == "var":
        glob.vars[ k_item ] = val
    if cmd.k_what == "set":
        if k_item in glob.sets:
            if val in glob.sets[ k_item ]:
                glob.wins[glob.winp].is_check = True
            else:
                glob.sets[ k_item ].add(val)
        else:
            glob.sets[ k_item ] = {val}
        return
    if cmd.k_what == "list":
        if k_item in glob.lists:
            glob.lists[ k_item ].append(val)
        else:
            glob.lists[ k_item ] = [val]
        return
    sw = cmd.k_what.split('.')
    if len(sw) > 1 and sw[0] == "set" and sw[1] == "split":
        sc = '.'
        if len(sw) > 2:
            sc = sw[2]
        svs = val.split( sc )
        for sv in svs:
            if k_item in glob.sets:
                glob.sets[ k_item ].add(sv)
            else:
                glob.sets[ k_item ] = {sv}
        return



def clear_cmd(cmd,glob,dat):
    k_item,err = strs(glob, cmd.k_item, glob.winp, cmd.line_no, True, True)
    if cmd.k_what == "set":
        if k_item in glob.sets:
            glob.sets[ k_item ].clear()
    if cmd.k_what == "list":
        if k_item in glob.lists:
            glob.lists[ k_item ].clear()

def check_cmd(cmd,glob,dat):
    k_item,err = strs(glob, cmd.k_item, glob.winp, cmd.line_no, True, True)
    if cmd.k_data != "E_O_L":
        val,err = strs(glob, cmd.k_data, glob.winp, cmd.line_no, True, True)
#       val = cmd.k_data
    else:
        val = dat
    if cmd.k_what == "set":
        if k_item in glob.sets:
            if val in glob.sets[ k_item ]:
                glob.wins[glob.winp].is_check = True
    if cmd.k_what == "list":
        if k_item in glob.lists:
            if val in glob.lists[ k_item ]:
                glob.wins[glob.winp].is_check = True

def trig(glob, winp):
    if not glob.wins[winp].is_prev or winp == 0:
        return
    glob.wins[winp].is_prev = False
    prev = winp - 1
    if not glob.wins[prev].is_on and not glob.wins[prev].is_prev:
        return
    if glob.wins[prev].is_trig:
        return
    glob.wins[prev].is_trig = True
    re_go_cmds(glob, prev)

def re_go_cmds(glob, winp):
    trig(glob, winp)
    if glob.wins[winp].on_pos < 0:
        return
    a = glob.acts.ap_actor[glob.wins[winp].cur_act]
    for c in range(glob.wins[winp].on_pos, glob.wins[winp].cur_pos):
        cmd = glob.acts.kp_all[c]
        if isinstance(cmd,structs.KpC):
            cc = cmd
            st,err = strs(glob, cc.k_desc, winp, cc.line_no, False, True)
            if glob.is_in:
                glob.ins += st + "\n"
            else:
                print(st)
        if isinstance(cmd,structs.KpCs):
            cc = cmd
            st,err = strs(glob, cc.k_desc, winp, cc.line_no, False, True)
            if glob.is_in:
                glob.ins += st
            else:
                print(st, end="")


def chk(glob, eqa: str, aval: str, val: str, prev: bool, attr_err: bool, val_err: bool, lno: str) -> bool:
    eq = eqa
    if eq == "??":
        return attr_err or val_err
    if eq[0] == "?":
        if attr_err or val_err:
            return False
        if len(eq) == 1:
            return True
        eq = eq[1:]
    if eq[0] == "&":
        if not prev:
            return False
        if len(eq) == 1:
            return True
        eq = eq[1:]
    if eq[0] == "|":
        if prev:
            return True
        if len(eq) == 1:
            return True
        eq = eq[1:]
    if val_err:
        glob.run_errs = True
        print(val)
        return False
    if attr_err:
        glob.run_errs = True
        print(aval)
        return False
    if eq == "=":
        return aval == val
    elif eq == "!=":
        return aval != val
    elif eq == "in":
        try:
            ss = val.split(",")
            for i in range(len(ss)):
                if aval == ss[i]:
                    return True
            return False
        except:
            return False
    elif eq == "!in":
        try:
            ss = val.split(",")
            for i in range(len(ss)):
                if aval == ss[i]:
                    return False
            return True
        except:
            return False
    elif eq == "has":
        try:
            ss = aval.split(",")
            for i in range(len(ss)):
                if val == ss[i]:
                    return True
            return False
        except:
            return False
    elif eq == "is":
        try:
            a = val.split(",")
            b = aval.split(",")
            a.sort()
            b.sort()
            if a == b:
                return True
            return False
        except:
            return False
    elif eq == "regex":
        match = re.match(val,aval)
        if match:
            return True
        return False
    elif eq == "exreg":
        match = re.match(aval,val)
        if match:
            return True
        return False
    print("?No actor match (" + eqa + ") " + lno + "?")
    glob.run_errs = True
    return False

def cmd_var(glob, sc: list[str], varv, lcnt) -> (str, bool):
    var = varv
    if isinstance(var, structs.Kp):
        return( type( var ).__name__, False )
    for i in range(1, len(sc)):
        ss = sc[i].split('.')
        if ss[0] == "l":
            var = var.lower()
        if ss[0] == "u":
            var = var.upper()
        if ss[0] == "c":
            var = var[0].upper() + var[1:].lower()
        if ss[0] == "sort" and not isinstance(var, str):
            nvar = ""
            try:
                a = list(var)
                a.sort()
                var = a
            except Exception as e:
                var = type( var ).__name__
        if ss[0] == "join" and not isinstance(var, str):
            nvar = ""
            try:
                for sts in var:
                    stv = sts
                    if not isinstance(sts, str) and not isinstance(sts, bool) and not isinstance(sts, int) and sts is not None:
                        stv = type( sts ).__name__
                    if nvar == "":
                        nvar = str(stv)
                    else:
                        nvar = nvar + "," + str(stv)
                var = nvar
            except Exception as e:
                print(e)
                var = type( var ).__name__
        if ss[0] == "keys":
            keys = list(var.keys())
            j = ","
            var = j.join(keys)
        if ss[0] == "split":
            var = var.split(",")
        if ss[0].isdigit() :
            pos = int( sc[i] )
            if len(var) > pos:
                var = var[pos]
            else:
                var = ""
        if ss[0] == "-" :
            if len(var) > lcnt:
                var = var[lcnt]
            else:
                var = ""
    return( str(var), False)

def s_get_var(glob, sc: list[str], ss: list[str], winp: int, lno: str) -> (str, bool):
    try:
        if len( ss[0] ) != 0:
            dat = glob.wins[winp].dat
            if isinstance(dat, dict):
                for ji in range(0, len(ss)):
                    dat = dat[ ss[ji] ]
            else:
                dat,er = glob.wins[winp].dat.get_var(glob.dats, ss, lno)
                if er:
                    return( dat, True )
            if len(sc) > 1:
                return( cmd_var(glob, sc, dat, glob.wins[winp].lcnt) )
            return( dat, False )
        if len(ss) == 1 or (ss[1] == "" and len(ss) == 2):
            if len(sc) > 1:
                return( cmd_var(glob, sc, glob.wins[winp].dat, glob.wins[winp].lcnt) )
            if isinstance(glob.wins[winp].dat, structs.Kp):
                return( type( glob.wins[winp].dat ).__name__, False )
            return( str( glob.wins[winp].dat ), False )
        if ss[1] == "_lno":
            if isinstance(glob.wins[winp].dat, structs.Kp):
                return( glob.wins[winp].dat.line_no + ", " + lno, False )
            return( lno, False )
        if ss[1] == "_ins":
            if len(sc) > 1:
                return( cmd_var(glob, sc, glob.ins, glob.wins[winp].lcnt) )
            return( glob.ins, False )
        if ss[1] == "_arg":
            if len(sc) > 1:
                return( cmd_var(glob, sc, glob.wins[winp].arg, glob.wins[winp].lcnt) )
            return( glob.wins[winp].arg, False )
        if ss[1] == "_type":
            return( type( glob.wins[winp].dat ).__name__, False )
        if ss[1] == "_key":
            if len(sc) > 1:
                return( cmd_var(glob, sc, glob.wins[winp].item, glob.wins[winp].lcnt) )
            return( glob.wins[winp].item, False )
        if ss[1] == "+":
            return( str( glob.wins[winp].lcnt+1 ), False )
        if ss[1] == '-':
            return( str( glob.wins[winp].lcnt ), False )
        if ss[1] == '_depth':
            return( str( winp ), False )
        if ss[1] == "_set" or ss[1] == "_list" or ss[1] == "_var":
            if ss[1] == "_set": col = glob.sets
            if ss[1] == "_list": col = glob.lists
            if ss[1] == "_var": col = glob.vars
            if len(ss) > 2:
                col = col[ ss[2] ]
            if len(ss) > 3 and ss[1] == "_var": 
                if isinstance(col, dict):
                    for ji in range(3, len(ss)):
                        col = col[ ss[ji] ]
                else:
                    col,er = col.get_var(glob.dats, ss[3:], lno)
                    if er:
                        return( col, True )
            if len(sc) > 1:
                return( cmd_var(glob, sc, col, glob.wins[winp].lcnt) )
            if isinstance(col, structs.Kp):
                return( type( col ).__name__, False )
            return( str( col ), False )
        if len(ss) < 3:
            return ("?len var?" + str(ss) + "?" + lno + "?", True)
        if ss[1] == '':
            return( ss[2], False )
        if ss[1] == "0":
            if glob.wins[winp].lcnt != 0:
                return( "", False )
            return( ss[2], False )
        if ss[1] == "1":
            if glob.wins[winp].lcnt == 0:
                return( "", False )
            return( ss[2], False )
        for i in range(winp-1, -1, -1):
            if ss[1] == glob.wins[i].name:
                return( s_get_var(glob, sc, ss[2:], i, lno) )
        return ("?var?" + str(ss) + "?" + lno + "?", True)
    except Exception as e:
        return ("?" + str(e) + " var?" + str(ss) + "?" + lno + "?", True)

def get_data(col,what,lno) -> (str, bool):
    if len(what) > 1:
        if what[1] in col:
            poc = col[ what[1] ]
            if what[0] == "_var" or what[0] == "var":
                if isinstance(poc,str):
                    return( poc, False )
                return( "", False )
            ret = ""
            cma = True
            for sts in poc:
                if not isinstance(sts,str):
                    continue
                if cma:
                    ret = sts
                    cma = False
                    continue
                ret = ret + "," + sts
            return(ret, False)
        return( "?key?" + what[1] + "?" + lno + "?", True)
    ret = ""
    cma = True
    keys = list(col.keys())
    for key in keys:
        if cma:
            ret = key
            cma = False
            continue
        ret = ret + "," + key
    return(ret, False)

def strs(glob, s: str, winp: int, lno: str, pr_err, is_err) -> (str, bool):
    err = False
    ret = ""
    pos = 0
    dp = -3
    bp = -3
    for i in range(len(s)):
        if s[i] == '$':
            if i == dp + 1:
                dp = -3
                ret += s[pos:i - 1]
                pos = i
                continue
            dp = i
        if s[i] == '{':
            if i == dp + 1:
                ret += s[pos:i - 1]
                pos = i
                bp = i
        if s[i] == '}':
            if bp > 0:
                va = s[bp + 1:i]
                sc = va.split(":")
                ss = sc[0].split(".")
                va, er = s_get_var(glob, sc, ss, winp, lno)
                if er:
#                    if len(s) > i + 1:
#                        i += 1
                    err = True
                    if is_err:
                        glob.run_errs = True
                    if pr_err:
                        print(va)
#                else:
#                    if len(s) > i + 1:
#                        i += 1
#                        va = tocase(va, s[i], glob.wins[winp].lcnt)
                ret += va
                pos = i + 1
                bp = -3
                dp = -3
    if pos < len(s):
        ret += s[pos:len(s)]
    return(ret, err)

def tocase(s: str, c: str, cnt: int) -> str:
    if c == "n":
        return s
    if c == "l":
        return s.lower()
    elif c == "c":
        return s[0].upper() + s[1:].lower()
    if c == "-":
        ss = s.split(",")
        if len(ss) > cnt:
            return( ss[cnt] )
        return("")
    if c.isdigit() :
        val = int(c)
        ss = s.split(",")
        if len(ss) > val:
            return( ss[val] )
        return("")
    return s

def sub_list(s: str, pos: int) -> str:
    try:
        ss = s.split(".")
        if pos >= len(ss):
            return ""
        ret = ""
        for i in range(pos, len(ss)):
            ret += ss[i]
        return ret
    except:
        return ""

