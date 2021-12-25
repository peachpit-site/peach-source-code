import os
import io
import sys
import random
import types
import traceback

brackets = {}
_fetched = []
_notes = ""
_note_count = 0

def note(s):
    global _notes, _note_count
    _note_count = _note_count + 1
    _notes = _notes + "("+str(_note_count)+") "+str(s)+"   "

def ends_with(*args):
    flag = False
    for i in range(1,len(args)):
        if type(args[i]) == list:
           for j in range(0,len(args[i])):
               flag = flag or args[0].endswith(args[i][j])
        else:
            flag = flag or args[0].endswith(args[i])
    return flag


def starts_with(*args):
    flag = False
    for i in range(1,len(args)):
        if type(args[i]) == list:
           for j in range(0,len(args[i])):
               flag = flag or args[0].startswith(args[i][j])
        else:
            flag = flag or args[0].startswith(args[i])
    return flag

def sequence(*args):
    if type(args[0]) == list:
        S = args[0]
    else:
        S = [args[0]]
    if len(args) == 1:
        return S
    L = []
    for i in S:
        for k in sequence(*args[1:]):
            L.append(i + k)
    return L

def merge_dictionaries(D1, D2):
    for i in D2.keys():
        if i in D1.keys():
            D1[i] = D1[i] + D2[i]
        else:
            D1[i] = D2[i]
    return D1

class Entry:
    def __init__(self,dir,E,L):
        global brackets
        self.directive = dir
        self._semicolon=[-1,-1]
        self.words = ["",""]
        self.brackets = []
        for i in range(0,2):
            T = _strip_brackets(E[i])
            self.words[i] = T[0]
            self._semicolon[i] = T[1]
            self.brackets = self.brackets + T[2]
            brackets = merge_dictionaries(brackets,T[3])
        if dir != "":
            self.brackets = self.brackets + [dir[1:-1]]

def has(s,t):
    for x in brackets[s]:
        if x[:len(t)+1] == t+" ":
            return True
    return False

def what_is(s,t):
    for x in brackets[s]:
        if x[:len(t)+1] == t+" ":
            return x[len(t)+1:]
    raise LookupError("what_is("+s+","+t+") : word "+s+" has no "+t)

def fetch(s):
    global _fetched, _selected
    if not _topic:
        raise LookupError("fetch("+s+") : topic is empty or unselected.")
    possible = [x for x in range(0,len(_topic)) if s in _topic[x].brackets]
    if not possible:
        raise LookupError("fetch("+s+") : topic does not contain entry of type "+s)
    if _selected in possible and not _selected in _fetched:
        _fetched.append(_selected)
        return _topic[_selected]
    for x in possible:
        if x in _fetched:
            possible.remove(x)
    if not possible:
        raise LookupError("fetch("+s+") : you have used all the things of type "+s)
    temp = random.choice(possible)
    _fetched.append(temp) 
    return _topic[temp]

def there_is(s, n = 1):
    if not _topic:
        raise LookupError("there_is("+s+") : topic is empty or unselected")
    possible = [x for x in range(0,len(_topic)) if s in _topic[x].brackets]
    for x in possible:
        if x in _fetched:
            possible.remove(x)    
    return len(possible) >= n

def from_table(r,c,T):
    if T[0].count(c) == 0:
        raise LookupError("from_table : "+c+" does not identify a column.")
    x = T[0].index(c)
    for row in T:
        if row[0] == r:
            return row[x+1]
    raise LookupError("from_table : "+r+" does not identify a row.")

def make_index(Y):
    ix = set()
    for y in Y:
        if type(y) is list and not isinstance(y[0], types.FunctionType):
            ix.add(y[0])
        ix = ix | make_index(y[2:])
    return ix

def standard_format(prefix, capitalize, postfix):
    def the_format(s):
        if prefix or capitalize:
            first_space = s.find(" ")
            if first_space == -1:
                first_space = len(s)
            r = ""
            for i in range(first_space):
                t = s[i:i+1]
                if i == 0 or (s[i-1:i] == '/'):
                   if capitalize:
                        t = t.capitalize()
                   t = prefix+t
                r = r + t
            s = r + s[first_space:]
        if postfix:
            last_space = s.rfind(" ")
            r = ""
            for i in range(last_space,len(s)+1):
                t = s[i:i+1]
                if i == len(s) or (t == '/'):
                    t = postfix + t
                r = r + t
            s = s[:last_space] + r
        return s
    return the_format

def grammar(lang,*X):
    ix = list(make_index(X))
    n = [0] * len(ix)
    if not n:
       return "".join(list(X)) 

    def evaluate(L):
        for i in range(0,len(L)):
            if type(L[i]) is list:
                if isinstance(L[i][0], types.FunctionType):
                    L[i] = L[i][0](*evaluate(L[i][1:]))
                else:
                    if len(L[i]) == 1:
                        L[i] = L[i][0].words[lang][n[ix.index(L[i][0])]]
                    else:
                        L[i] = L[i][1](L[i][0].words[lang][n[ix.index(L[i][0])]],*evaluate(L[i][2:]))
        return L

    s = ""
    h = ""
    while n[len(n)-1]<len(ix[len(n)-1].words[lang]):
        T = list(X)
        t = "".join(evaluate(T))
        t = format[lang](t)
        if all([ix[i]._semicolon[lang] == -1 or
                n[i] <= ix[i]._semicolon[lang]
                for i in range(0,len(n))]):
            if s:
                s = s + ", "
            s = s + t
        else:
            if h:
                h = h + ", "
            h = h + t
        p = 0
        flag = True
        while flag:
            n[p] = n[p] + 1
            flag = (n[p] == len(ix[p].words[lang]))
            if flag and p < len(n)-1:
                n[p] = 0
                p = p + 1
    if h:
        s = s + "; " + h
    result[lang] = s

def _strip_brackets(s):
    bs = ["(","[","{"]
    bf = [")","]","}"]
    bc = [0] * len(bs)
    sc = -1
    ic = 0
    t = ""
    u = ""
    L = []
    B = []
    D = {}
    H = []
    for i in range(0,len(s)):
        c = s[i]
        if c in bs:
            bc[bs.index(c)] = bc[bs.index(c)] + 1
        if sum(bc) == 0:
            if c == ";":
                if sc == -1:
                    sc = ic
                c = ","
            if c != "," and not (c in bs) and not (c in bf):
                t = t + c
            if c == "," or i == len(s)-1:
                ic = ic + 1
                t = t.rstrip().lstrip()
                L.append(t)
                D[t] = B
                H = H + B
                B = []
                t = ""
        else:
            if c in bf and bc[bf.index(c)] > 0:
                bc[bf.index(c)] = bc[bf.index(c)] - 1
            if sum(bc) == 0:
                B.extend(u.split(", "))
                u = ""
                if i == len(s)-1:
                    t = t.rstrip().lstrip()
                    L.append(t)
                    H = H + B
                    D[t] = B
            else:
                if not c in bs:
                    u = u + c
    return L, sc, H, D

def unchanged(s):
    return s

current_directory = os.getcwd()
try:
    os.chdir(current_directory+"\Resources\File transfer")
except(FileNotFoundError):
    current_directory = current_directory + '\Peach'
    os.chdir(current_directory+"\Resources\File transfer")

with io.open("patopy.rsc", "r", encoding="utf-8") as file:
    _data_in = file.readlines()

_data_in = [item.rstrip() for item in _data_in]

if _data_in[1] ==_data_in[2]:
  _data_in[2] = _data_in[2] +"B"
if _data_in[1] == "":
   _data_in[1] = "A"

question_language = int(_data_in[3])
questions = _data_in[4]
answers = _data_in[5]

_selected = int(_data_in[6])

entry = Entry(_data_in[7+_selected*3],[_data_in[8+_selected*3],_data_in[9+_selected*3]],[_data_in[1],_data_in[2]])

_topic = []
for i in range(0,(len(_data_in) - 7)//3):
        _topic = _topic + [Entry(_data_in[3*i+7],[_data_in[3*i+8],_data_in[3*i+9]],[_data_in[1],_data_in[2]])]

topic_directive = _data_in[0]
exec(_data_in[1].replace(' ', '_') + " = 0")
exec(_data_in[2].replace(' ', '_') + " = 1")
result = ["",""]
result[0] = _data_in[8+_selected*3]
result[1] = _data_in[9+_selected*3]
directive = ""
_error_report = ""
_error_line = '-1'
format = [unchanged,unchanged]

try:
    vowels = ["a","e","i","o","u"]
    French_vowels = ["a","e","i","o","u","à", "è", "ù", "é"]
    
    def gender(word):
        if word[-1] == "e":
            g = "f."
        else:
            g = "m."
        if "m." in brackets[word]:
            g = "m."
        if "f." in brackets[word]:
            g = "f."
        return g
    
    def English_noun(w,num):
        if num == "pl.":
             if has(w,"pl."):
                  w = what_is(w,"pl.")
             else:
                  if w[-1:] == "y" and not w[-2] in vowels:
                       w = w[:-1] + "ies"
                  elif ends_with(w, "s", "x","z","sh","ch"):
                      w = w + "es"
                  else:
                      w = w + "s"
        return w
        
    def French_noun(w,number,gender):
        article = "unassigned"
        if number == "pl.":
            if w[-3:] == "eau":
                w = w + "x"
            else:
                w = w + "s"
        if number == "sg.":
            if gender == "m.":
                article = "le "
            if gender == "f.":
                article = "la "
            if w[0] in French_vowels:
                article = "l'"
        else:
            article = "les "
        w = article + w
        return w
        
    def French_adjective(w,num,gen):
        if (gen == "f."):
            if has(w,"f."):
                w=what_is(w,"f.")
            elif (w[-1] != "e"):
                w=w+"e"
        if num == "pl.":
            w = w + "s"
        return w
    
    noun = fetch("n")
    adjective = fetch("a")
    number = random.choice(["sg.", "pl."])  
    grammar(English, "the ", [adjective], " ", [noun, English_noun, number])
    grammar(French, [noun, French_noun, number, [noun, gender]], " ", [adjective,French_adjective, number, [noun, gender]])
    pass

except Exception as err:
    _error_report = str(err)
    _error_line = ''
    for tuple in traceback.walk_tb(sys.exc_info()[-1]):
        _error_line = str(tuple[1]) + ', ' + _error_line

finally:

    with io.open("pytopa.rsc", "w", encoding="utf-8") as file:
        file.write(directive+"\n")
        file.write(result[0]+"\n")
        file.write(result[1]+"\n")
        file.write(_error_report+"\n")
        file.write(_error_line+"\n")
        file.write(_notes+"\n")
        file.write(', '.join([str(i) for i in _fetched])+"\n")
