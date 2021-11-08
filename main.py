# -*- coding: utf-8 -*-
"""
Created on Sun Oct 24 18:30:27 2021

@author: Sindre
"""

import sys
from enum import IntEnum

from CodeIterator import CodeIterator, CodeException

from Parser import Parser

import stabs
       
class Registerx64(IntEnum):
    RAX = 0
    RBX = 1
    RCX = 2
    RDX = 3
    RSI = 4
    RDI = 5
    RBP = 6
    RSP = 7
    R8  = 8
    R9  = 9
    R10 = 10
    R11 = 11
    R12 = 12
    R13 = 13
    R14 = 14
    R15 = 15
       
class Valx64:
    REGISTER = 1
    STACK = 2
    CONST = 4
    ANY = REGISTER|STACK|CONST
    
    def __init__(self, kind, val):
        self.kind = kind
        self.val = val
        

            

class Compilerx64(Parser): 
    def __init__(self, path):
        super().__init__(path)
        
        self.intsize = 8

        self.asm = """default rel

global main

section .data

section .bss
call_stack: resq 500
end_call_stack:

section .text

   

"""

        self.make_main()
        
        self.while_labels = []
        self.while_label_ct = 0
        self.if_labels = []
        self.if_label_ct = 0
        
        self.has_else = []
        

    def add(self):
        self.pop(2)
        self.asm += "ADD RAX, RBX\n"
        
    def sub(self):
        self.pop(2)
        self.asm += "SUB RAX, RBX\n"
    
    def mult(self):
        self.pop(2)
        self.asm += "MUL RBX\n"
    
    def div(self):
        self.pop(2)
        self.asm += "XOR RDX, RDX\n"
        self.asm += "DIV RBX\n"
    
    def mod(self):
        self.pop(2)
        self.asm += "XOR RDX, RDX\n"
        self.asm += "DIV RBX\n"
        self.asm += "MOV RAX, RDX\n"
    
    def divmod(self):
        self.pop(2)
        self.asm += "XOR RDX, RDX\n"
        self.asm += "DIV RBX\n"
        self.push(Registerx64.RAX.name)
        self.push(Registerx64.RDX.name)
        
    
    def eq(self):
        self.asm += "POP RBX\n"
        self.asm += "POP RCX\n"
        self.asm += "XOR RAX, RAX\n"
        
        self.asm += "CMP RBX, RCX\n"
        self.asm += "SETE AL\n"
    
    def neq(self):
        self.asm += "POP RBX\n"
        self.asm += "POP RCX\n"
        self.asm += "XOR RAX, RAX\n"
        
        self.asm += "CMP RBX, RCX\n"
        self.asm += "SETNE AL\n"
    
    def lt(self):
        self.asm += "POP RBX\n"
        self.asm += "POP RCX\n"
        self.asm += "XOR RAX, RAX\n"
        
        self.asm += "CMP RCX, RBX\n"
        self.asm += "SETL AL\n"
    
    def gt(self):
        self.asm += "POP RBX\n"
        self.asm += "POP RCX\n"
        self.asm += "XOR RAX, RAX\n"
        
        self.asm += "CMP RCX, RBX\n"
        self.asm += "SETG AL\n"
    
    def le(self):
        self.asm += "POP RBX\n"
        self.asm += "POP RCX\n"
        self.asm += "XOR RAX, RAX\n"
        
        self.asm += "CMP RCX, RBX\n"
        self.asm += "SETLE AL\n"
    
    def ge(self):
        self.asm += "POP RBX\n"
        self.asm += "POP RCX\n"
        self.asm += "XOR RAX, RAX\n"
        
        self.asm += "CMP RCX, RBX\n"
        self.asm += "SETGE AL\n"
        
    def make_main(self):
        self.asm += "main:\n"
        self.asm += "PUSH R12\n"
        self.asm += "ENTER 0x20, 0\n"
        self.asm += "LEA R12, [call_stack]\n"
        
        self.callfunc("entry")
        
        self.asm += "LEAVE\n"
        self.asm += "POP R12\n"
        self.asm += "RET\n"
    
    def copy(self, i = 0, ct = 1):
        if i < 0:
            raise CodeException("Invalid copy < 0", self)
            
        self.asm += f"MOV RAX, [RSP+{i*self.intsize}]\n"
        for i in range(ct):
            self.asm += "PUSH RAX\n"
        
    def _while(self):
        self.while_labels.append(self.while_label_ct)
        self.while_label_ct += 1
        self.asm += f"\nwhile_{self.while_labels[-1]}:\n"
        
    def do(self):
        self.pop(1)
        self.asm += "CMP RAX, 0\n"
        self.asm += f"JE endwhile_{self.while_labels[-1]}\n"
            
    def endwhile(self):
        self.asm += f"JMP while_{self.while_labels[-1]}\n"
        self.asm += f"\nendwhile_{self.while_labels[-1]}:\n"
        self.while_labels.pop()
        
    def _if(self):
        self.pop(1)
        self.if_labels.append(self.if_label_ct)
        self.if_label_ct += 1
        self.has_else.append(False)
        
        self.asm += "CMP RAX, 0\n"
        self.asm += f"JE endif_{self.if_labels[-1]}\n"
        
            
    def _else(self):
        self.asm += f"JMP endelse_{self.if_labels[-1]}\n"
        self.asm += f"\nendif_{self.if_labels[-1]}:\n"
        self.has_else[-1] = True
    
    def endif(self):
        if self.has_else.pop():
            self.asm += f"\nendelse_{self.if_labels[-1]}:\n"
        else:
            self.asm += f"\nendif_{self.if_labels[-1]}:\n"
            
        self.if_labels.pop()
            
    def memalloc(self, name, size):
        self.asm += "section .bss\n"
        self.asm += f"{name}: resb {size}\n"
        self.asm += f"{name}_end:\n"
        self.asm += "section .text\n"
        
    def push_memory_address(self, name):
        self.memory_segments_used.add(name)
        
        self.asm += f"LEA RAX, [{name}]\n"
        self.push("RAX")
        
    def mem_write(self, size):
        self.asm += "POP RAX\n"
        self.asm += "POP RBX\n"
        regs = {1: "AL", 2: "AX", 4: "EAX", 8: "RAX"}
        if not size in regs:
            raise CodeException("Invalid size for mem_write", self.it)
        self.asm += f"MOV [RBX], {regs[size]}\n"
        
    def mem_read(self, size):
        self.asm += "POP RBX\n"
        regs = {1: "AL", 2: "AX", 4: "EAX", 8: "RAX"}
        if not size in regs:
            raise CodeException("Invalid size for mem_read", self.it)
        if size != 8:
            self.asm += "XOR RAX, RAX\n"
        self.asm += f"MOV {regs[size]}, [RBX]\n"
        self.push("RAX")
       
    def funcdef(self, name):
        self.asm += f"func_{name}:\n"
        self.asm += "POP RCX\n"
        self.asm += "MOV [R12], RCX\n"
        self.asm += "ADD R12, 8\n"
         
       
    def endfunc(self):
        self.asm += "SUB R12, 8\n"
        self.asm += "MOV RCX, [R12]\n"
        self.asm += "PUSH RCX\n"
        self.asm += "RET\n"
        
    def callfunc(self, name):
        self.asm += f"CALL func_{name}\n"
        
        self.functions_called.add(name)
        
        
    def push(self, val = None, *vals):
        
        if val is None:
            val = "RAX"
        self.asm += f"PUSH {val}\n"
        for v in vals:
            self.asm += f"PUSH {v}\n"
        
    def pop(self, ct = 1):
        
        if ct > 3:
            raise Exception("Too many pops")
            
        regs = ["RAX", "RBX", "RCX"]
        
        for i in reversed(range(ct)):
            self.asm += f"POP {regs[i]}\n"
        
            
    def swap(self, i = 1, j = 0):
        self.asm += f"; swap:{i}:{j}\n"
        self.asm += f"MOV RAX, [RSP+{i*self.intsize}]\n"
        self.asm += f"MOV RBX, [RSP+{j*self.intsize}]\n"
        self.asm += f"MOV [RSP+{i*self.intsize}], RBX\n"
        self.asm += f"MOV [RSP+{j*self.intsize}], RAX\n"
    
    def syscall(self, arg_ct):
        ArgOrder = [Registerx64.RAX, Registerx64.RDI, Registerx64.RSI, Registerx64.RDX, Registerx64.RCX, Registerx64.R8, Registerx64.R9]
        for i in range(arg_ct+1):
            self.asm += f"POP {ArgOrder[i].name}\n"
        self.asm += "SYSCALL\n"
        
    def get_string(self, string):
        if not string in self.strings:
            self.strings[string] = f"string_{len(self.strings)}"
            
        self.asm += f"LEA RAX, [{self.strings[string]}]\n"
        
        self.push()
        
        
    def escape_nasm_string(self, string):
        res = ""
        in_string = False;        
        
        for c in string:
            n = ord(c)
            if n < 0x20 or n > 0x7E or n == 0x22:
                if in_string:
                    res += '"'
                    in_string = False;
                if res:
                    res += ", "
                res += hex(n)
            else:
                if not in_string:
                    if res:
                        res += ", "
                    res += '"'
                    in_string = True
                res += c
                
        if in_string:
            res += '"'
            
        return res
    
    def debug_word(self, path, line_num, op_num, word):
        self.asm += f"; {word.encode('unicode_escape').decode('utf-8')}\n"
        self.asm += f"%line {line_num}+{op_num} {path}\n"
        
    
    def run(self):
        super().run()
        self.asm += "\nsection .data\n"
        for x in self.strings.items():
            s = self.escape_nasm_string(x[0])
            self.asm += f"{x[1]} dq {len(x[0])}\n{x[1]}_ptr db {s}\n"


input_path = "test.stacksy"
ouput_path = "test.asm"

it = iter(sys.argv[1:])
for arg in it:
    arg = arg.lower()
    if arg == "-i":
        input_path = next(it)
    elif arg == "-o":
        ouput_path = next(it)
    else:
        raise Exception("Unknown argument", arg)
        
    

a = Compilerx64(input_path)
#nasm -f win64 test.asm && link test.obj /subsystem:console /out:test.exe kernel32.lib legacy_stdio_definitions.lib msvcrt.lib && test
a.run()

with open(ouput_path, "w") as fp:
    fp.write(a.asm)
