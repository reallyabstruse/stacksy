# -*- coding: utf-8 -*-
"""
Created on Sun Oct 24 18:30:27 2021

@author: Sindre
"""

import sys
from enum import IntEnum

from CodeIterator import CodeException

from Parser import Parser

from StacksyFunction import StacksyFunctionX64

       
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
    
    AL = 16
    AX = 17
    EAX = 18
    
    RIP = 19
    
    def getGASFormat(self):
        return f"%{self.name}"
    
class StackValueX64():
    def __init__(self, offset):
        self.offset = offset
        
    def getGASFormat(self):
        return f"{self.offset}({Registerx64.RSP.getGASFormat()})"
       
class ImmediateX64():
    def __init__(self, val):
        self.val = val
        
    def getGASFormat(self):
        return f"${self.val}"
      
class PtrX64():
    def __init__(self, var, offset=None):
        self.var = var
        self.offset = offset
        
    def getGASFormat(self):
        if self.offset is None:
            return f"({self.var.getGASFormat()})"
        return f"{self.offset}({self.var.getGASFormat()})"
      
class LabelX64():
    def __init__(self, name, extra=None):
        self.name = name
        if not extra is None:
            self.name += f"_{extra}"
        
    def getGASFormat(self):
        return f"{self.name}"
    
      
class Valx64:
    REGISTER = 1
    STACK = 2
    IMMEDIATE = 4
    ANY = REGISTER|STACK|IMMEDIATE
    
    def __init__(self, kind, val):
        self.kind = kind
        self.val = val
        

            

class Compilerx64(Parser): 
    def __init__(self, path):
        super().__init__(path, StacksyFunctionX64)
        
        self.intsize = 8
        
        self.compile_unit = None

        self.asm = """.global _start

.section .data

.section .bss
.lcomm call_stack, 4000
.lcomm call_stack_end, 0
.section .text

   

"""

        self.debug_add_file(self.it.get_file_num(), path)
        
        self.while_labels = []
        self.while_label_ct = 0
        self.if_labels = []
        self.if_label_ct = 0
        
        self.has_else = []
        
        self.in_prologue = False
        
        
    def _or(self):
        self.pop(2)
        self.make_instruction("OR", Registerx64.RAX, Registerx64.RBX)
    
    def band(self):
        self.pop(2)
        self.make_instruction("AND", Registerx64.RAX, Registerx64.RBX)

    def add(self):
        self.pop(2)
        self.make_instruction("ADD", Registerx64.RAX, Registerx64.RBX)
        
        
    def sub(self):
        self.pop(2)
        self.make_instruction("SUB", Registerx64.RAX, Registerx64.RBX)
    
    def mult(self):
        self.pop(2)
        self.make_instruction("MUL", Registerx64.RBX)
    
    def div(self):
        self.pop(2)
        self.make_instruction("XOR", Registerx64.RDX, Registerx64.RDX)
        self.make_instruction("DIV", Registerx64.RBX)
    
    def mod(self):
        self.pop(2)
        self.make_instruction("XOR", Registerx64.RDX, Registerx64.RDX)
        self.make_instruction("DIV", Registerx64.RBX)
        self.make_instruction("MOV", Registerx64.RAX, Registerx64.RDX)
    
    def divmod(self):
        self.pop(2)
        self.make_instruction("XOR", Registerx64.RDX, Registerx64.RDX)
        self.make_instruction("DIV", Registerx64.RBX)
        self.push(Registerx64.RAX)
        self.push(Registerx64.RDX)
       
    def cmp(self):
        self.make_instruction("POP", Registerx64.RBX)
        self.make_instruction("POP", Registerx64.RCX)
        self.make_instruction("XOR", Registerx64.RAX, Registerx64.RAX)
        self.make_instruction("CMP", Registerx64.RCX, Registerx64.RBX)
       
    
    def eq(self):
        self.cmp()
        self.make_instruction("SETE", Registerx64.AL)
    
    def neq(self):
        self.cmp()
        self.make_instruction("SETNE", Registerx64.AL)
    
    def lt(self):
        self.cmp()
        self.make_instruction("SETL", Registerx64.AL)
    
    def gt(self):
        self.cmp()
        self.make_instruction("SETG", Registerx64.AL)
    
    def le(self):
        self.cmp()
        self.make_instruction("SETLE", Registerx64.AL)
    
    def ge(self):
        self.cmp()
        self.make_instruction("SETGE", Registerx64.AL)
        
    def make_main(self):
        self.asm += "_start:\n"
        self.asm += "PUSH %R12\n"
        self.asm += "MOV %RSP, %RBP\n"
        self.asm += "ADD $0x20, %RSP\n"
        self.asm += "LEA call_stack(%rip), %R12\n"
        
        self.asm += "CALL func_entry\n"
        
        self.asm += "LEAVE\n"
        self.asm += "POP %R12\n"
        self.asm += "mov $60, %rax\n"
        self.asm += "xor %rdi, %rdi\n"
        self.asm += "syscall\n"
        
        self.functions_called.add("entry")
    
    def copy(self, i = 0, ct = 1):
        if i < 0:
            raise CodeException("Invalid copy < 0", self)
            
        self.make_instruction("MOV", Registerx64.RAX, StackValueX64(i*self.intsize))
        for i in range(ct):
            self.make_instruction("PUSH", Registerx64.RAX)
        
    def _while(self):
        self.while_labels.append(self.while_label_ct)
        self.while_label_ct += 1
        self.define_label(LabelX64("while", self.while_labels[-1]))
        
    def do(self):
        self.pop(1)
        self.make_instruction("CMP", Registerx64.RAX, ImmediateX64(0))
        self.make_instruction("JE", LabelX64("endwhile", self.while_labels[-1]))
            
    def endwhile(self):
        self.make_instruction("JMP", LabelX64("while", self.while_labels[-1]))
        self.define_label(LabelX64("endwhile", self.while_labels[-1]))
        self.while_labels.pop()
        
    def _if(self):
        self.pop(1)
        self.if_labels.append(self.if_label_ct)
        self.if_label_ct += 1
        self.has_else.append(False)
        
        self.make_instruction("CMP", Registerx64.RAX, ImmediateX64(0))
        self.make_instruction("JE", LabelX64("endif", self.if_labels[-1]))
        
            
    def _else(self):
        self.make_instruction("JMP", LabelX64("endelse", self.if_labels[-1]))
        self.define_label(LabelX64("endif", self.if_labels[-1]))
        self.has_else[-1] = True
    
    def endif(self):
        if self.has_else.pop():
            self.define_label(LabelX64("endelse", self.if_labels[-1]))
        else:
            self.define_label(LabelX64("endif", self.if_labels[-1]))
            
        self.if_labels.pop()
            
    def memalloc(self, name, size):
        self.asm += ".section .bss\n"
        self.asm += f".lcomm {name}, {size}\n"
        self.asm += f".lcomm {name}_end, 0\n"
        self.asm += ".section .text\n"
        
    def declare_const(self, name, val):
        self.const_labels[name] = ImmediateX64(val)
        
    def push_memory_address(self, name):
        self.memory_segments_used.add(name)
        self.make_instruction("LEA", Registerx64.RAX, LabelX64(name), Registerx64.RIP)
        self.push(Registerx64.RAX)
        
    def push_const(self, name):
        self.push(self.const_labels[name])
        
    def mem_write(self, size):
        self.make_instruction("POP", Registerx64.RAX)
        self.make_instruction("POP", Registerx64.RBX)
        regs = {1: Registerx64.AL, 2: Registerx64.AX, 4: Registerx64.EAX, 8: Registerx64.RAX}
        if not size in regs:
            raise CodeException("Invalid size for mem_write", self.it)
        self.make_instruction("MOV", PtrX64(Registerx64.RBX), regs[size], size=size)
        
    def mem_read(self, size):
        self.make_instruction("POP", Registerx64.RBX)
        regs = {1: Registerx64.AL, 2: Registerx64.AX, 4: Registerx64.EAX, 8: Registerx64.RAX}
        if not size in regs:
            raise CodeException("Invalid size for mem_read", self.it)
        if size != 8:
            self.make_instruction("XOR", Registerx64.RAX, Registerx64.RAX)
        self.make_instruction("MOV", regs[size], PtrX64(Registerx64.RBX), size=size)
        self.push(Registerx64.RAX)
       
    def funcdef(self, name):
        if not self.compile_unit is None:
            raise CodeException("Compile unit should be none when opening function", self.it)
        self.compile_unit = self.functions[name]
    
        self.make_instruction("POP", Registerx64.RCX)
        self.make_instruction("MOV", PtrX64(Registerx64.R12), Registerx64.RCX)
        self.make_instruction("ADD", Registerx64.R12, ImmediateX64(8))
         
       
    def endfunc(self):
        if self.compile_unit is None:
            raise CodeException("Compile unit should not be none when closing function", self.it)
    
        self.make_instruction("SUB", Registerx64.R12, ImmediateX64(8))
        self.make_instruction("MOV", Registerx64.RCX, PtrX64(Registerx64.R12))
        self.make_instruction("PUSH", Registerx64.RCX)
        self.make_instruction("RET")
        
        self.compile_unit = None
        
        
    def callfunc(self, name):
        self.make_instruction("CALL", LabelX64("func", name))
        
        self.functions_called.add(name)
        
        
    def push(self, val = None, *vals):
        
        if val is None:
            val = Registerx64.RAX
        self.make_instruction("PUSH", val)
        for v in vals:
            self.make_instruction("PUSH", v)
            
    def push_int(self, val):
        self.push(ImmediateX64(val))
        
    def pop(self, ct = 1):
        
        if ct > 3:
            raise Exception("Too many pops")
            
        regs = [Registerx64.RAX, Registerx64.RBX, Registerx64.RCX]
        
        for i in reversed(range(ct)):
            self.make_instruction("POP", regs[i])
        
            
    def swap(self, i = 1, j = 0):
        self.make_instruction("MOV", Registerx64.RAX, PtrX64(Registerx64.RSP, i*8))
        self.make_instruction("MOV", Registerx64.RBX, PtrX64(Registerx64.RSP, j*8))
        self.make_instruction("MOV", PtrX64(Registerx64.RSP, i*8), Registerx64.RBX)
        self.make_instruction("MOV", PtrX64(Registerx64.RSP, j*8), Registerx64.RAX)
    
    def syscall(self, arg_ct):
        ArgOrder = [Registerx64.RAX, Registerx64.RDI, Registerx64.RSI, Registerx64.RDX, Registerx64.R10, Registerx64.R8, Registerx64.R9]
        if arg_ct >= len(ArgOrder):
            raise CodeException("Too many args for syscall", self)
        for i in range(arg_ct+1):
            self.make_instruction("POP", ArgOrder[i])
        self.make_instruction("SYSCALL")
        self.make_instruction("PUSH", Registerx64.RAX);
        
    def get_string(self, string):
        if not string in self.strings:
            self.strings[string] = f"string_{len(self.strings)}"
            
        self.make_instruction("LEA", Registerx64.RAX, LabelX64(self.strings[string]), Registerx64.RIP)
        
        self.push(Registerx64.RAX)
        
    def get_char(self, string):
        if len(string) == 0:
            raise CodeException("Empty char literal", self.it)
            
        if string[0] == '\\':
            if len(string) < 2:
                raise CodeException("Invalid char literal", self.it)
            if string[1].isdigit():
                if len(string) > 4:
                    raise CodeException("Invalid char literal", self.it)
                try:
                    return int(string[1:], base=8)
                except ValueError:
                    raise CodeException("Invalid char literal", self.it)
                    
            elif len(string) > 2:
                raise CodeException("Invalid char literal", self.it)
            elif string[1] == 'n':
                return ord('\n')
            elif string[1] == 'r':
                return ord('\r')
            elif string[1] == 't':
                return ord('\t')
            elif string[1] == '\\':
                return ord('\\')
            elif string[1] == '\'':
                return ord('\'')
            else:
                raise CodeException("Unknown escape sequence in char literal", self.it)
                
        if len(string) > 1:
            raise CodeException("Invalid char literal", self.it)
         
         
        return ord(string)
            
        
    def escape_gas_string(self, string):
        res = '"'
        
        for c in string:
            n = ord(c)
            if n < 0x20 or n > 0x7E or n == 0x22:
                res += f"\\{oct(n)[2:].zfill(3)}"
            else:
                res += c
                
            
        return res + '"'
    
    def debug_word(self, file_num, line_num, op_num, word):
        # outside of functions only add debug info for function declarations
        if not self.in_function:
            if word[0] != '#':
                return
        # don't add debug info for function epilogue
        elif word[0] == '#':
            return
        
        prologue_end = "prologue_end" if self.in_prologue else ""
        
        # if function declaration then next instuction marks end of prologue
        self.in_prologue = word[0] == '#'
            
        self.add_comment(word.encode('unicode_escape').decode('utf-8'))
        self.append_asm(f".loc {file_num} {line_num} {op_num} {prologue_end}")
        
    def debug_add_file(self, num, file):
        self.append_asm(f".file {num} \"{file}\"")
        
    def make_instruction(self, name, dest=None, src=None, ext=None, size=None):
        if not size is None:
            suffixes = {1: "b", 2: "w", 4: "l", 8:"q"}
            if not size in suffixes:
                raise CodeException(f"Invalid size passed to make_instruction: {size}", self.it)
            name += suffixes[size]
        
        if dest is None:
            inst = f"{name}"
        elif src is None:
            if ext is None:
                inst = f"{name} {dest.getGASFormat()}"
            else:
                inst = f"{name} {dest.getGASFormat()}({ext.getGASFormat()})"
        else:
            if ext is None:
                inst = f"{name} {src.getGASFormat()}, {dest.getGASFormat()}"
            else:
                inst = f"{name} {src.getGASFormat()}({ext.getGASFormat()}), {dest.getGASFormat()}"
            
        self.compile_unit.append_asm(inst)
            
    
    def append_asm(self, asm):
        if not self.compile_unit is None:
            self.compile_unit.append_asm(asm)
        else:
            self.asm += asm + "\n"
        
    def define_label(self, label):
        self.append_asm(f"{label.getGASFormat()}:")
        
    def add_comment(self, text):
        self.append_asm(f"// {text}")
    
    def run(self):
        super().run()
        self.append_asm(".section .data")
        for x in self.strings.items():
            s = self.escape_gas_string(x[0])
            self.append_asm(f"{x[1]}: .quad {len(x[0])}\n{x[1]}_ptr: .ascii {s}")
           

        self.append_asm(".section .text")
        self.make_main()
            
        for name in self.functions_called:
            self.append_asm(self.functions[name].get_asm())


input_path = "test.stacksy"
ouput_path = "test.s"

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
# gcc test.s -nostdlib && ./a.out
a.run()

with open(ouput_path, "w") as fp:
    fp.write(a.asm)
