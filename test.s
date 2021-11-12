.global _start

.section .data

.section .bss
.lcomm call_stack 4000
end_call_stack:

.section .text

   

.file 1 "test.stacksy"
_start:
PUSH %R12
ENTER $0x20, $0
LEA call_stack(%rip), %R12
CALL func_entry
LEAVE
POP %R12
RET
// import:std.stacksy
.loc 1 1 1
.file 2 "std.stacksy"
// @temp:100
.loc 2 1 1
.section .bss
.lcomm temp, 100
temp_end:
.section .text
// #to_string
.loc 2 3 1
func_to_string:
// 0
.loc 2 4 1
// swap
.loc 2 4 2
// @temp_end
.loc 2 4 3
// 1
.loc 2 4 4
// -
.loc 2 4 5
// copy:1
.loc 2 5 1
// 0
.loc 2 5 2
// <
.loc 2 5 3
// if
.loc 2 5 4
JE endif_0
// 1
.loc 2 6 1
// swap:3
.loc 2 6 2
// pop
.loc 2 6 3
// swap
.loc 2 7 1
// -1
.loc 2 7 2
// *
.loc 2 7 3
// swap
.loc 2 7 4
// fi
.loc 2 8 1

endif_0:
// while
.loc 2 9 1

while_0:
// copy
.loc 2 10 1
// swap:2
.loc 2 10 2
// 10
.loc 2 10 3
// divmod
.loc 2 10 4
// '0'
.loc 2 11 1
// +
.loc 2 11 2
// swap:2:1
.loc 2 12 1
// setbyte
.loc 2 13 1
CALL func_setbyte
// copy
.loc 2 14 1
// 0
.loc 2 15 1
// !=
.loc 2 15 2
// do
.loc 2 15 3
JE endwhile_0
// swap
.loc 2 16 1
// 1
.loc 2 16 2
// -
.loc 2 16 3
// elihw
.loc 2 17 1
JMP while_0

endwhile_0:
// pop
.loc 2 19 1
// swap
.loc 2 20 1
// 1
.loc 2 20 2
// =
.loc 2 20 3
// if
.loc 2 20 4
JE endif_1
// 1
.loc 2 21 1
// -
.loc 2 21 2
// copy
.loc 2 21 3
// '-'
.loc 2 21 4
// setbyte
.loc 2 21 5
CALL func_setbyte
// fi
.loc 2 22 1

endif_1:
// copy
.loc 2 24 1
// 8
.loc 2 24 2
// -
.loc 2 24 3
// copy
.loc 2 24 4
// swap:2
.loc 2 24 5
// @temp_end
.loc 2 26 1
// swap
.loc 2 26 2
// -
.loc 2 26 3
// set:8
.loc 2 27 1
// #
.loc 2 29 1
// #clear
.loc 2 31 1
func_clear:
// "\x1b[H\x1b[J"
.loc 2 32 1
// print
.loc 2 32 2
CALL func_print
// #
.loc 2 33 1
// #print
.loc 2 35 1
func_print:
// copy
.loc 2 36 1
// get:8
.loc 2 36 2
// swap
.loc 2 36 3
// 8
.loc 2 36 4
// +
.loc 2 36 5
// 1
.loc 2 37 1
// 1
.loc 2 37 2
// syscall:3
.loc 2 37 3
POP %RAX
POP %RDI
POP %RSI
POP %RDX
// #
.loc 2 38 1
// #printint
.loc 2 40 1
func_printint:
// to_string
.loc 2 41 1
CALL func_to_string
// print
.loc 2 41 2
CALL func_print
// #
.loc 2 42 1
// #getbyte
.loc 2 44 1
func_getbyte:
// get:1
.loc 2 45 1
// #
.loc 2 46 1
// #setbyte
.loc 2 48 1
func_setbyte:
// set:1
.loc 2 49 1
// #
.loc 2 50 1
// #readbyte
.loc 2 52 1
func_readbyte:
// 1
.loc 2 53 1
// @temp
.loc 2 53 2
// 1
.loc 2 53 3
// 0
.loc 2 53 4
// syscall:3
.loc 2 53 5
POP %RAX
POP %RDI
POP %RSI
POP %RDX
// @temp
.loc 2 54 1
// getbyte
.loc 2 54 2
CALL func_getbyte
// #
.loc 2 55 1
// #entry
.loc 1 5 1
func_entry:
// 1337
.loc 1 6 1
// printint
.loc 1 6 2
CALL func_printint
// 1337
.loc 1 7 1
// printint
.loc 1 7 2
CALL func_printint
// 1337
.loc 1 8 1
// printint
.loc 1 8 2
CALL func_printint
// 1337
.loc 1 9 1
// printint
.loc 1 9 2
CALL func_printint
// #
.loc 1 10 1

.section .data
string_0: .quad 6
string_0_ptr: .ascii "\033[H\033[J"
