.global _start

.section .data

.section .bss
.lcomm call_stack 4000
end_call_stack:

.section .text

   

.file 1 "test.stacksy"
_start:
PUSH %R12
MOV %RSP, %RBP
ADD $0x20, %RSP
LEA call_stack(%rip), %R12
CALL func_entry
LEAVE
POP %R12
mov $60, %rax
xor %rdi, %rdi
syscall
.file 2 "std.stacksy"
.section .bss
.lcomm temp, 100
temp_end:
.section .text
func_to_string:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 0
.loc 2 4 1
PUSH $0
// swap
.loc 2 4 2
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// @temp_end
.loc 2 4 3
LEA temp_end(%rip), %RAX
PUSH %RAX
// 1
.loc 2 4 4
PUSH $1
// -
.loc 2 4 5
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// copy:1
.loc 2 5 1
MOV 8(%RSP), %RAX
PUSH %RAX
// 0
.loc 2 5 2
PUSH $0
// <
.loc 2 5 3
POP %RBX
POP %RCX
XOR %RAX, %RAX
CMP %RBX, %RCX
SETL %AL
PUSH %RAX
// if
.loc 2 5 4
POP %RAX
CMP $0, %RAX
JE endif_0
// 1
.loc 2 6 1
PUSH $1
// swap:3
.loc 2 6 2
MOV 24(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 24(%RSP)
MOV %RAX, 0(%RSP)
// pop
.loc 2 6 3
POP %RAX
// swap
.loc 2 7 1
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// -1
.loc 2 7 2
PUSH $-1
// *
.loc 2 7 3
POP %RBX
POP %RAX
MUL %RBX
PUSH %RAX
// swap
.loc 2 7 4
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// fi
.loc 2 8 1

endif_0:
// while
.loc 2 9 1

while_0:
// copy
.loc 2 10 1
MOV 0(%RSP), %RAX
PUSH %RAX
// swap:2
.loc 2 10 2
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// 10
.loc 2 10 3
PUSH $10
// divmod
.loc 2 10 4
POP %RBX
POP %RAX
XOR %RDX, %RDX
DIV %RBX
PUSH %RAX
PUSH %RDX
// '0'
.loc 2 11 1
PUSH $48
// +
.loc 2 11 2
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// swap:2:1
.loc 2 12 1
MOV 16(%RSP), %RAX
MOV 8(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 8(%RSP)
// setbyte
.loc 2 13 1
CALL func_setbyte
// copy
.loc 2 14 1
MOV 0(%RSP), %RAX
PUSH %RAX
// 0
.loc 2 15 1
PUSH $0
// !=
.loc 2 15 2
POP %RBX
POP %RCX
XOR %RAX, %RAX
CMP %RBX, %RCX
SETNE %AL
PUSH %RAX
// do
.loc 2 15 3
POP %RAX
CMP $0, %RAX
JE endwhile_0
// swap
.loc 2 16 1
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 1
.loc 2 16 2
PUSH $1
// -
.loc 2 16 3
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// elihw
.loc 2 17 1
JMP while_0

endwhile_0:
// pop
.loc 2 19 1
POP %RAX
// swap
.loc 2 20 1
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 1
.loc 2 20 2
PUSH $1
// =
.loc 2 20 3
POP %RBX
POP %RCX
XOR %RAX, %RAX
CMP %RBX, %RCX
SETE %AL
PUSH %RAX
// if
.loc 2 20 4
POP %RAX
CMP $0, %RAX
JE endif_1
// 1
.loc 2 21 1
PUSH $1
// -
.loc 2 21 2
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// copy
.loc 2 21 3
MOV 0(%RSP), %RAX
PUSH %RAX
// '-'
.loc 2 21 4
PUSH $45
// setbyte
.loc 2 21 5
CALL func_setbyte
// fi
.loc 2 22 1

endif_1:
// copy
.loc 2 24 1
MOV 0(%RSP), %RAX
PUSH %RAX
// 8
.loc 2 24 2
PUSH $8
// -
.loc 2 24 3
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// copy
.loc 2 24 4
MOV 0(%RSP), %RAX
PUSH %RAX
// swap:2
.loc 2 24 5
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// @temp_end
.loc 2 26 1
LEA temp_end(%rip), %RAX
PUSH %RAX
// swap
.loc 2 26 2
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// -
.loc 2 26 3
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// set:8
.loc 2 27 1
POP %RAX
POP %RBX
MOVq %RAX, (%RBX)
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_clear:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// "\x1b[H\x1b[J"
.loc 2 32 1
LEA string_0(%rip), %RAX
PUSH %RAX
// print
.loc 2 32 2
CALL func_print
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_print:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// copy
.loc 2 36 1
MOV 0(%RSP), %RAX
PUSH %RAX
// get:8
.loc 2 36 2
POP %RBX
MOVq (%RBX), %RAX
PUSH %RAX
// swap
.loc 2 36 3
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 8
.loc 2 36 4
PUSH $8
// +
.loc 2 36 5
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// 1
.loc 2 37 1
PUSH $1
// 1
.loc 2 37 2
PUSH $1
// syscall:3
.loc 2 37 3
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_printint:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// to_string
.loc 2 41 1
CALL func_to_string
// print
.loc 2 41 2
CALL func_print
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_getbyte:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// get:1
.loc 2 45 1
POP %RBX
XOR %RAX, %RAX
MOVb (%RBX), %AL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_setbyte:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// set:1
.loc 2 49 1
POP %RAX
POP %RBX
MOVb %AL, (%RBX)
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_readbyte:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 1
.loc 2 53 1
PUSH $1
// @temp
.loc 2 53 2
LEA temp(%rip), %RAX
PUSH %RAX
// 1
.loc 2 53 3
PUSH $1
// 0
.loc 2 53 4
PUSH $0
// syscall:3
.loc 2 53 5
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
// @temp
.loc 2 54 1
LEA temp(%rip), %RAX
PUSH %RAX
// getbyte
.loc 2 54 2
CALL func_getbyte
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
func_entry:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 123
.loc 1 6 1
PUSH $123
// printint
.loc 1 6 2
CALL func_printint
// 456
.loc 1 7 1
PUSH $456
// printint
.loc 1 7 2
CALL func_printint
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET

.section .data
string_0: .quad 6
string_0_ptr: .ascii "\033[H\033[J"
