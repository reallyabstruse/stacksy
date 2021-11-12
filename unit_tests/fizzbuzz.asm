default rel

global main

section .data

section .bss
temp_buffer: resb 100
temp_buffer_end:
call_stack: resq 500
end_call_stack:

section .text

   

main:
PUSH R12
ENTER 0x20, 0
LEA R12, [call_stack]
CALL func_entry
LEAVE
POP R12
RET
section .bss
temp: resb 100
temp_end:
section .text
func_to_string:
POP RCX
MOV [R12], RCX
ADD R12, 8
PUSH 0
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX
LEA RAX, [temp_end]
PUSH RAX
PUSH 1
POP RBX
POP RAX
SUB RAX, RBX
PUSH RAX
MOV RAX, [RSP+8]
PUSH RAX
PUSH 0
POP RBX
POP RCX
XOR RAX, RAX
CMP RCX, RBX
SETL AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endif_0
PUSH 1
; swap:3:0
MOV RAX, [RSP+24]
MOV RBX, [RSP+0]
MOV [RSP+24], RBX
MOV [RSP+0], RAX
POP RAX
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX
PUSH -1
POP RBX
POP RAX
MUL RBX
PUSH RAX
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX

endif_0:

while_0:
MOV RAX, [RSP+0]
PUSH RAX
; swap:2:0
MOV RAX, [RSP+16]
MOV RBX, [RSP+0]
MOV [RSP+16], RBX
MOV [RSP+0], RAX
PUSH 10
POP RBX
POP RAX
XOR RDX, RDX
DIV RBX
PUSH RAX
PUSH RDX
PUSH 48
POP RBX
POP RAX
ADD RAX, RBX
PUSH RAX
; swap:2:1
MOV RAX, [RSP+16]
MOV RBX, [RSP+8]
MOV [RSP+16], RBX
MOV [RSP+8], RAX
CALL func_setbyte
MOV RAX, [RSP+0]
PUSH RAX
PUSH 0
POP RBX
POP RCX
XOR RAX, RAX
CMP RBX, RCX
SETNE AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endwhile_0
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX
PUSH 1
POP RBX
POP RAX
SUB RAX, RBX
PUSH RAX
JMP while_0

endwhile_0:
POP RAX
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX
PUSH 1
POP RBX
POP RCX
XOR RAX, RAX
CMP RBX, RCX
SETE AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endif_1
PUSH 1
POP RBX
POP RAX
SUB RAX, RBX
PUSH RAX
MOV RAX, [RSP+0]
PUSH RAX
PUSH 45
CALL func_setbyte

endif_1:
MOV RAX, [RSP+0]
PUSH RAX
PUSH 8
POP RBX
POP RAX
SUB RAX, RBX
PUSH RAX
MOV RAX, [RSP+0]
PUSH RAX
; swap:2:0
MOV RAX, [RSP+16]
MOV RBX, [RSP+0]
MOV [RSP+16], RBX
MOV [RSP+0], RAX
LEA RAX, [temp_end]
PUSH RAX
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX
POP RBX
POP RAX
SUB RAX, RBX
PUSH RAX
POP RAX
POP RBX
MOV [RBX], RAX
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_clear:
POP RCX
MOV [R12], RCX
ADD R12, 8
LEA RAX, [string_0]
PUSH RAX
CALL func_print
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_print:
POP RCX
MOV [R12], RCX
ADD R12, 8
MOV RAX, [RSP+0]
PUSH RAX
POP RBX
MOV RAX, [RBX]
PUSH RAX
; swap:1:0
MOV RAX, [RSP+8]
MOV RBX, [RSP+0]
MOV [RSP+8], RBX
MOV [RSP+0], RAX
PUSH 8
POP RBX
POP RAX
ADD RAX, RBX
PUSH RAX
PUSH 1
PUSH 1
POP RAX
POP RDI
POP RSI
POP RDX
SYSCALL
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_printint:
POP RCX
MOV [R12], RCX
ADD R12, 8
CALL func_to_string
CALL func_print
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_getbyte:
POP RCX
MOV [R12], RCX
ADD R12, 8
POP RBX
XOR RAX, RAX
MOV AL, [RBX]
PUSH RAX
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_setbyte:
POP RCX
MOV [R12], RCX
ADD R12, 8
POP RAX
POP RBX
MOV [RBX], AL
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_readbyte:
POP RCX
MOV [R12], RCX
ADD R12, 8
PUSH 1
LEA RAX, [temp]
PUSH RAX
PUSH 1
PUSH 0
POP RAX
POP RDI
POP RSI
POP RDX
SYSCALL
LEA RAX, [temp]
PUSH RAX
CALL func_getbyte
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET
func_entry:
POP RCX
MOV [R12], RCX
ADD R12, 8
PUSH 1

while_1:
MOV RAX, [RSP+0]
PUSH RAX
PUSH 100
POP RBX
POP RCX
XOR RAX, RAX
CMP RCX, RBX
SETL AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endwhile_1
MOV RAX, [RSP+0]
PUSH RAX
PUSH 15
POP RBX
POP RAX
XOR RDX, RDX
DIV RBX
MOV RAX, RDX
PUSH RAX
PUSH 0
POP RBX
POP RCX
XOR RAX, RAX
CMP RBX, RCX
SETE AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endif_2
LEA RAX, [string_1]
PUSH RAX
CALL func_print
JMP endelse_2

endif_2:
MOV RAX, [RSP+0]
PUSH RAX
PUSH 3
POP RBX
POP RAX
XOR RDX, RDX
DIV RBX
MOV RAX, RDX
PUSH RAX
PUSH 0
POP RBX
POP RCX
XOR RAX, RAX
CMP RBX, RCX
SETE AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endif_3
LEA RAX, [string_2]
PUSH RAX
CALL func_print
JMP endelse_3

endif_3:
MOV RAX, [RSP+0]
PUSH RAX
PUSH 5
POP RBX
POP RAX
XOR RDX, RDX
DIV RBX
MOV RAX, RDX
PUSH RAX
PUSH 0
POP RBX
POP RCX
XOR RAX, RAX
CMP RBX, RCX
SETE AL
PUSH RAX
POP RAX
CMP RAX, 0
JE endif_4
LEA RAX, [string_3]
PUSH RAX
CALL func_print
JMP endelse_4

endif_4:
MOV RAX, [RSP+0]
PUSH RAX
CALL func_printint
LEA RAX, [string_4]
PUSH RAX
CALL func_print

endelse_4:

endelse_3:

endelse_2:
PUSH 1
POP RBX
POP RAX
ADD RAX, RBX
PUSH RAX
JMP while_1

endwhile_1:
SUB R12, 8
MOV RCX, [R12]
PUSH RCX
RET

section .data
string_0 dq 6
string_0_ptr db 0x1b, "[H", 0x1b, "[J"
string_1 dq 9
string_1_ptr db "FizzBuzz", 0xa
string_2 dq 5
string_2_ptr db "Fizz", 0xa
string_3 dq 5
string_3_ptr db "Buzz", 0xa
string_4 dq 1
string_4_ptr db 0xa
