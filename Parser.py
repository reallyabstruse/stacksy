# -*- coding: utf-8 -*-
"""
Created on Sun Nov  7 11:08:52 2021

@author: Sindre
"""

from CodeIterator import CodeIterator, CodeException

class Parser:
    def __init__(self, path, functionClass):
        self.it = CodeIterator(path)
        self.stack = []
        self.in_function = False
        self.functions = {}
        self.functions_called = {} # dict of functionname => string where called from
        self.memory_segments = set()
        self.memory_segments_used = set()
        self.const_labels = {}
        self.strings = {}
        
        self.functionClass = functionClass

    def memint(self, string):
        if string[-1].lower() == "k":
            res = 1000*int(string[:-1], 0)
        else:
            res = int(string, 0)
            
        if res <= 0:
            raise CodeException("Size of memory allocation must be > 0", self.it)
            
        return res

    # Parse an operator outside function
    def op_outside(self, o):
        if o[0][0] == "#":
            if len(o) != 1:
                raise CodeException("Invalid : in function declaration", self.it)
            name = o[0][1:]
            if name in self.functions:
                raise CodeException("Identifier already used", self.it)
            self.in_function = name
            self.functions[name] = self.functionClass(name)
            self.funcdef(name)
        elif o[0][0] == "@":
            if len(o) != 2:
                raise CodeException("Invalid memory allocation", self.it)
                
            name = o[0][1:]
            if name in self.memory_segments:
                raise CodeException("Identifier already used", self.it)
                
            self.memalloc(name, self.memint(o[1]))
            self.memory_segments.add(name)
        elif o[0][0] == "$":
            if len(o) != 2:
                raise CodeException("Invalid memory allocation", self.it)
                
            name = o[0][1:]
            if name in self.const_labels:
                raise CodeException(f"Redefenition of constant {name}", self.it)

            self.declare_const(name, o[1])
        elif o[0] == "import":
            if len(o) != 2:
                raise CodeException("Invalid import", self.it)
                
            self.it.add_import(o[1])
            self.debug_add_file(self.it.get_file_num(), o[1])
        else:
            raise CodeException("Expected function declaration (#name) or memory allocation (@name:size)", self.it)
            
    
    def op(self, o):
        # operators that can take compile time arguments
        if o[0] == "copy":
            if len(o) == 1:
                self.copy()
            elif len(o) == 2:
                self.copy(int(o[1]))
            elif len(o) == 3:
                self.copy(int(o[1]), int(o[2]))
            else:
                raise CodeException("Invalid amount of parameters to copy", self.it)
        elif o[0] == "swap":
            if len(o) == 1:
                self.swap()
            elif len(o) == 2:
                self.swap(int(o[1]))
            elif len(o) == 3:
                self.swap(int(o[1]), int(o[2]))
            else:
                raise CodeException("Invalid amount of parameters to swap", self.it)
        elif o[0] == "syscall":
            if len(o) != 2:
                raise CodeException("parameter count to syscall required (syscall:N)", self.it)
                
            self.syscall(int(o[1]))
        elif o[0] == "get":
            if len(o) != 2:
                raise CodeException("one compile time parameter expected for get", self.it)
            self.mem_read(int(o[1]))
        elif o[0] == "set":
            if len(o) != 2:
                raise CodeException("one compile time parameter expected for set", self.it)
            self.mem_write(int(o[1]))
            
        
        # remaining operators take no compile time arguments
        elif len(o) > 1:
            raise CodeException(f"Unexpected compile time parameters for op {o[0]}", self.it)
            
        elif o[0] == "+":
            self.push(self.add())
        elif o[0] == "-":
            self.push(self.sub())
        elif o[0] == "*":
            self.push(self.mult())
        elif o[0] == "/":
            self.push(self.div())
        elif o[0] == "%":
            self.push(self.mod())
        elif o[0] == "divmod":
            self.divmod()
        elif o[0] == "=":
            self.push(self.eq())
        elif o[0] == "!=":
            self.push(self.neq())
        elif o[0] == "<":
            self.push(self.lt())
        elif o[0] == ">":
            self.push(self.gt())
        elif o[0] == "<=":
            self.push(self.le())
        elif o[0] == ">=":
            self.push(self.ge())
        elif o[0] == "or":
            self.push(self._or())
        elif o[0] == "&":
            self.push(self.band())
        elif o[0] == "pop":
            self.pop()     
        elif o[0] == "while":
            self._while()
        elif o[0] == "if":
            self._if()
        elif o[0] == "else":
            self._else()
        elif o[0] == "fi":
            self.endif()
        elif o[0] == "do":
            self.do()
        elif o[0] == "elihw":
            self.endwhile()
        elif o[0] == "#":
            self.endfunc()
            self.in_function = False  
        elif o[0][0] == "@":
            self.push_memory_address(o[0][1:])
        elif o[0][0] == "$":
            name = o[0][1:]
            if not name in self.const_labels:
                raise CodeException(f"Undeclared const {name}", self.it)
            self.push_const(o[0][1:])
        else:
            self.callfunc(o[0])
            
    def run(self):
        for word in self.it:
            if word:
                if word[0] == ";":
                    self.it.skip_line()
                else:
                    if self.in_function:
                        self.debug_word(self.it.get_file_num(), self.it.get_line_number(), self.it.get_op_number(), word)
                        if word[0].isnumeric() or (word[0] == "-" and word[1:2].isnumeric()):
                            self.push_int(int(word, 0))
                        elif word[0] == '"' and word[-1] == '"':
                            self.get_string(word[1:-1])
                        elif word[0] == "'" and word[-1] == "'":
                            self.push_int(self.get_char(word[1:-1]))
                        elif '"' in word:
                            raise CodeException("Unexpected \" character", self.it)
                        else:
                            self.op(word.lower().split(":"))
                    else:
                        self.op_outside(word.lower().split(":"))

            
        for f in self.functions_called:
            if not f in self.functions:
                raise CodeException(f"Undeclared function {f}", self.functions_called[f])