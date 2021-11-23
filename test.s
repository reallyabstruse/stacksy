.global _start

.section .data

.section .bss
.lcomm call_stack, 4000
.lcomm call_stack_end, 0
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
.lcomm temp_end, 0
.section .text
// #sys_read
.loc 2 7 1 
func_sys_read:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 0
.loc 2 7 2 prologue_end
PUSH $0
// syscall:3
.loc 2 7 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_write
.loc 2 8 1 
func_sys_write:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 1
.loc 2 8 2 prologue_end
PUSH $1
// syscall:3
.loc 2 8 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_open
.loc 2 9 1 
func_sys_open:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 2
.loc 2 9 2 prologue_end
PUSH $2
// syscall:3
.loc 2 9 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_close
.loc 2 10 1 
func_sys_close:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 3
.loc 2 10 2 prologue_end
PUSH $3
// syscall:1
.loc 2 10 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_stat
.loc 2 11 1 
func_sys_stat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 4
.loc 2 11 2 prologue_end
PUSH $4
// syscall:2
.loc 2 11 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fstat
.loc 2 12 1 
func_sys_fstat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 5
.loc 2 12 2 prologue_end
PUSH $5
// syscall:2
.loc 2 12 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lstat
.loc 2 13 1 
func_sys_lstat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 6
.loc 2 13 2 prologue_end
PUSH $6
// syscall:2
.loc 2 13 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_poll
.loc 2 14 1 
func_sys_poll:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 7
.loc 2 14 2 prologue_end
PUSH $7
// syscall:3
.loc 2 14 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lseek
.loc 2 15 1 
func_sys_lseek:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 8
.loc 2 15 2 prologue_end
PUSH $8
// syscall:3
.loc 2 15 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mmap
.loc 2 16 1 
func_sys_mmap:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 9
.loc 2 16 2 prologue_end
PUSH $9
// syscall:6
.loc 2 16 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mprotect
.loc 2 17 1 
func_sys_mprotect:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 10
.loc 2 17 2 prologue_end
PUSH $10
// syscall:3
.loc 2 17 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_munmap
.loc 2 18 1 
func_sys_munmap:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 11
.loc 2 18 2 prologue_end
PUSH $11
// syscall:2
.loc 2 18 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_brk
.loc 2 19 1 
func_sys_brk:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 12
.loc 2 19 2 prologue_end
PUSH $12
// syscall:1
.loc 2 19 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigaction
.loc 2 20 1 
func_sys_rt_sigaction:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 13
.loc 2 20 2 prologue_end
PUSH $13
// syscall:4
.loc 2 20 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigprocmask
.loc 2 21 1 
func_sys_rt_sigprocmask:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 14
.loc 2 21 2 prologue_end
PUSH $14
// syscall:4
.loc 2 21 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigreturn
.loc 2 22 1 
func_sys_rt_sigreturn:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 15
.loc 2 22 2 prologue_end
PUSH $15
// syscall:6
.loc 2 22 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ioctl
.loc 2 23 1 
func_sys_ioctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 16
.loc 2 23 2 prologue_end
PUSH $16
// syscall:3
.loc 2 23 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pread64
.loc 2 24 1 
func_sys_pread64:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 17
.loc 2 24 2 prologue_end
PUSH $17
// syscall:4
.loc 2 24 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pwrite64
.loc 2 25 1 
func_sys_pwrite64:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 18
.loc 2 25 2 prologue_end
PUSH $18
// syscall:4
.loc 2 25 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_readv
.loc 2 26 1 
func_sys_readv:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 19
.loc 2 26 2 prologue_end
PUSH $19
// syscall:3
.loc 2 26 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_writev
.loc 2 27 1 
func_sys_writev:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 20
.loc 2 27 2 prologue_end
PUSH $20
// syscall:3
.loc 2 27 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_access
.loc 2 28 1 
func_sys_access:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 21
.loc 2 28 2 prologue_end
PUSH $21
// syscall:2
.loc 2 28 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pipe
.loc 2 29 1 
func_sys_pipe:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 22
.loc 2 29 2 prologue_end
PUSH $22
// syscall:1
.loc 2 29 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_select
.loc 2 30 1 
func_sys_select:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 23
.loc 2 30 2 prologue_end
PUSH $23
// syscall:5
.loc 2 30 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_yield
.loc 2 31 1 
func_sys_sched_yield:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 24
.loc 2 31 2 prologue_end
PUSH $24
// syscall:0
.loc 2 31 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mremap
.loc 2 32 1 
func_sys_mremap:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 25
.loc 2 32 2 prologue_end
PUSH $25
// syscall:5
.loc 2 32 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_msync
.loc 2 33 1 
func_sys_msync:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 26
.loc 2 33 2 prologue_end
PUSH $26
// syscall:3
.loc 2 33 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mincore
.loc 2 34 1 
func_sys_mincore:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 27
.loc 2 34 2 prologue_end
PUSH $27
// syscall:3
.loc 2 34 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_madvise
.loc 2 35 1 
func_sys_madvise:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 28
.loc 2 35 2 prologue_end
PUSH $28
// syscall:3
.loc 2 35 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_shmget
.loc 2 36 1 
func_sys_shmget:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 29
.loc 2 36 2 prologue_end
PUSH $29
// syscall:3
.loc 2 36 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_shmat
.loc 2 37 1 
func_sys_shmat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 30
.loc 2 37 2 prologue_end
PUSH $30
// syscall:3
.loc 2 37 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_shmctl
.loc 2 38 1 
func_sys_shmctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 31
.loc 2 38 2 prologue_end
PUSH $31
// syscall:3
.loc 2 38 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_dup
.loc 2 39 1 
func_sys_dup:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 32
.loc 2 39 2 prologue_end
PUSH $32
// syscall:1
.loc 2 39 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_dup2
.loc 2 40 1 
func_sys_dup2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 33
.loc 2 40 2 prologue_end
PUSH $33
// syscall:2
.loc 2 40 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pause
.loc 2 41 1 
func_sys_pause:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 34
.loc 2 41 2 prologue_end
PUSH $34
// syscall:0
.loc 2 41 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_nanosleep
.loc 2 42 1 
func_sys_nanosleep:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 35
.loc 2 42 2 prologue_end
PUSH $35
// syscall:2
.loc 2 42 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getitimer
.loc 2 43 1 
func_sys_getitimer:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 36
.loc 2 43 2 prologue_end
PUSH $36
// syscall:2
.loc 2 43 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_alarm
.loc 2 44 1 
func_sys_alarm:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 37
.loc 2 44 2 prologue_end
PUSH $37
// syscall:1
.loc 2 44 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setitimer
.loc 2 45 1 
func_sys_setitimer:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 38
.loc 2 45 2 prologue_end
PUSH $38
// syscall:3
.loc 2 45 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getpid
.loc 2 46 1 
func_sys_getpid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 39
.loc 2 46 2 prologue_end
PUSH $39
// syscall:0
.loc 2 46 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sendfile
.loc 2 47 1 
func_sys_sendfile:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 40
.loc 2 47 2 prologue_end
PUSH $40
// syscall:4
.loc 2 47 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_socket
.loc 2 48 1 
func_sys_socket:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 41
.loc 2 48 2 prologue_end
PUSH $41
// syscall:3
.loc 2 48 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_connect
.loc 2 49 1 
func_sys_connect:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 42
.loc 2 49 2 prologue_end
PUSH $42
// syscall:3
.loc 2 49 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_accept
.loc 2 50 1 
func_sys_accept:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 43
.loc 2 50 2 prologue_end
PUSH $43
// syscall:3
.loc 2 50 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sendto
.loc 2 51 1 
func_sys_sendto:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 44
.loc 2 51 2 prologue_end
PUSH $44
// syscall:6
.loc 2 51 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_recvfrom
.loc 2 52 1 
func_sys_recvfrom:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 45
.loc 2 52 2 prologue_end
PUSH $45
// syscall:6
.loc 2 52 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sendmsg
.loc 2 53 1 
func_sys_sendmsg:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 46
.loc 2 53 2 prologue_end
PUSH $46
// syscall:3
.loc 2 53 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_recvmsg
.loc 2 54 1 
func_sys_recvmsg:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 47
.loc 2 54 2 prologue_end
PUSH $47
// syscall:3
.loc 2 54 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_shutdown
.loc 2 55 1 
func_sys_shutdown:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 48
.loc 2 55 2 prologue_end
PUSH $48
// syscall:2
.loc 2 55 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_bind
.loc 2 56 1 
func_sys_bind:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 49
.loc 2 56 2 prologue_end
PUSH $49
// syscall:3
.loc 2 56 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_listen
.loc 2 57 1 
func_sys_listen:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 50
.loc 2 57 2 prologue_end
PUSH $50
// syscall:2
.loc 2 57 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getsockname
.loc 2 58 1 
func_sys_getsockname:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 51
.loc 2 58 2 prologue_end
PUSH $51
// syscall:3
.loc 2 58 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getpeername
.loc 2 59 1 
func_sys_getpeername:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 52
.loc 2 59 2 prologue_end
PUSH $52
// syscall:3
.loc 2 59 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_socketpair
.loc 2 60 1 
func_sys_socketpair:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 53
.loc 2 60 2 prologue_end
PUSH $53
// syscall:4
.loc 2 60 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setsockopt
.loc 2 61 1 
func_sys_setsockopt:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 54
.loc 2 61 2 prologue_end
PUSH $54
// syscall:5
.loc 2 61 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getsockopt
.loc 2 62 1 
func_sys_getsockopt:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 55
.loc 2 62 2 prologue_end
PUSH $55
// syscall:5
.loc 2 62 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_clone
.loc 2 63 1 
func_sys_clone:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 56
.loc 2 63 2 prologue_end
PUSH $56
// syscall:5
.loc 2 63 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fork
.loc 2 64 1 
func_sys_fork:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 57
.loc 2 64 2 prologue_end
PUSH $57
// syscall:0
.loc 2 64 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_vfork
.loc 2 65 1 
func_sys_vfork:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 58
.loc 2 65 2 prologue_end
PUSH $58
// syscall:0
.loc 2 65 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_execve
.loc 2 66 1 
func_sys_execve:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 59
.loc 2 66 2 prologue_end
PUSH $59
// syscall:3
.loc 2 66 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_exit
.loc 2 67 1 
func_sys_exit:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 60
.loc 2 67 2 prologue_end
PUSH $60
// syscall:1
.loc 2 67 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_wait4
.loc 2 68 1 
func_sys_wait4:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 61
.loc 2 68 2 prologue_end
PUSH $61
// syscall:4
.loc 2 68 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_kill
.loc 2 69 1 
func_sys_kill:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 62
.loc 2 69 2 prologue_end
PUSH $62
// syscall:2
.loc 2 69 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_uname
.loc 2 70 1 
func_sys_uname:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 63
.loc 2 70 2 prologue_end
PUSH $63
// syscall:1
.loc 2 70 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_semget
.loc 2 71 1 
func_sys_semget:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 64
.loc 2 71 2 prologue_end
PUSH $64
// syscall:3
.loc 2 71 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_semop
.loc 2 72 1 
func_sys_semop:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 65
.loc 2 72 2 prologue_end
PUSH $65
// syscall:3
.loc 2 72 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_semctl
.loc 2 73 1 
func_sys_semctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 66
.loc 2 73 2 prologue_end
PUSH $66
// syscall:4
.loc 2 73 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_shmdt
.loc 2 74 1 
func_sys_shmdt:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 67
.loc 2 74 2 prologue_end
PUSH $67
// syscall:1
.loc 2 74 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_msgget
.loc 2 75 1 
func_sys_msgget:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 68
.loc 2 75 2 prologue_end
PUSH $68
// syscall:2
.loc 2 75 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_msgsnd
.loc 2 76 1 
func_sys_msgsnd:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 69
.loc 2 76 2 prologue_end
PUSH $69
// syscall:4
.loc 2 76 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_msgrcv
.loc 2 77 1 
func_sys_msgrcv:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 70
.loc 2 77 2 prologue_end
PUSH $70
// syscall:5
.loc 2 77 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_msgctl
.loc 2 78 1 
func_sys_msgctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 71
.loc 2 78 2 prologue_end
PUSH $71
// syscall:3
.loc 2 78 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fcntl
.loc 2 79 1 
func_sys_fcntl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 72
.loc 2 79 2 prologue_end
PUSH $72
// syscall:3
.loc 2 79 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_flock
.loc 2 80 1 
func_sys_flock:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 73
.loc 2 80 2 prologue_end
PUSH $73
// syscall:2
.loc 2 80 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fsync
.loc 2 81 1 
func_sys_fsync:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 74
.loc 2 81 2 prologue_end
PUSH $74
// syscall:1
.loc 2 81 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fdatasync
.loc 2 82 1 
func_sys_fdatasync:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 75
.loc 2 82 2 prologue_end
PUSH $75
// syscall:1
.loc 2 82 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_truncate
.loc 2 83 1 
func_sys_truncate:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 76
.loc 2 83 2 prologue_end
PUSH $76
// syscall:2
.loc 2 83 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ftruncate
.loc 2 84 1 
func_sys_ftruncate:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 77
.loc 2 84 2 prologue_end
PUSH $77
// syscall:2
.loc 2 84 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getdents
.loc 2 85 1 
func_sys_getdents:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 78
.loc 2 85 2 prologue_end
PUSH $78
// syscall:3
.loc 2 85 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getcwd
.loc 2 86 1 
func_sys_getcwd:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 79
.loc 2 86 2 prologue_end
PUSH $79
// syscall:2
.loc 2 86 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_chdir
.loc 2 87 1 
func_sys_chdir:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 80
.loc 2 87 2 prologue_end
PUSH $80
// syscall:1
.loc 2 87 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fchdir
.loc 2 88 1 
func_sys_fchdir:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 81
.loc 2 88 2 prologue_end
PUSH $81
// syscall:1
.loc 2 88 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rename
.loc 2 89 1 
func_sys_rename:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 82
.loc 2 89 2 prologue_end
PUSH $82
// syscall:2
.loc 2 89 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mkdir
.loc 2 90 1 
func_sys_mkdir:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 83
.loc 2 90 2 prologue_end
PUSH $83
// syscall:2
.loc 2 90 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rmdir
.loc 2 91 1 
func_sys_rmdir:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 84
.loc 2 91 2 prologue_end
PUSH $84
// syscall:1
.loc 2 91 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_creat
.loc 2 92 1 
func_sys_creat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 85
.loc 2 92 2 prologue_end
PUSH $85
// syscall:2
.loc 2 92 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_link
.loc 2 93 1 
func_sys_link:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 86
.loc 2 93 2 prologue_end
PUSH $86
// syscall:2
.loc 2 93 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_unlink
.loc 2 94 1 
func_sys_unlink:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 87
.loc 2 94 2 prologue_end
PUSH $87
// syscall:1
.loc 2 94 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_symlink
.loc 2 95 1 
func_sys_symlink:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 88
.loc 2 95 2 prologue_end
PUSH $88
// syscall:2
.loc 2 95 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_readlink
.loc 2 96 1 
func_sys_readlink:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 89
.loc 2 96 2 prologue_end
PUSH $89
// syscall:3
.loc 2 96 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_chmod
.loc 2 97 1 
func_sys_chmod:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 90
.loc 2 97 2 prologue_end
PUSH $90
// syscall:2
.loc 2 97 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fchmod
.loc 2 98 1 
func_sys_fchmod:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 91
.loc 2 98 2 prologue_end
PUSH $91
// syscall:2
.loc 2 98 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_chown
.loc 2 99 1 
func_sys_chown:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 92
.loc 2 99 2 prologue_end
PUSH $92
// syscall:3
.loc 2 99 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fchown
.loc 2 100 1 
func_sys_fchown:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 93
.loc 2 100 2 prologue_end
PUSH $93
// syscall:3
.loc 2 100 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lchown
.loc 2 101 1 
func_sys_lchown:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 94
.loc 2 101 2 prologue_end
PUSH $94
// syscall:3
.loc 2 101 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_umask
.loc 2 102 1 
func_sys_umask:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 95
.loc 2 102 2 prologue_end
PUSH $95
// syscall:1
.loc 2 102 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_gettimeofday
.loc 2 103 1 
func_sys_gettimeofday:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 96
.loc 2 103 2 prologue_end
PUSH $96
// syscall:2
.loc 2 103 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getrlimit
.loc 2 104 1 
func_sys_getrlimit:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 97
.loc 2 104 2 prologue_end
PUSH $97
// syscall:2
.loc 2 104 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getrusage
.loc 2 105 1 
func_sys_getrusage:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 98
.loc 2 105 2 prologue_end
PUSH $98
// syscall:2
.loc 2 105 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sysinfo
.loc 2 106 1 
func_sys_sysinfo:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 99
.loc 2 106 2 prologue_end
PUSH $99
// syscall:1
.loc 2 106 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_times
.loc 2 107 1 
func_sys_times:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 100
.loc 2 107 2 prologue_end
PUSH $100
// syscall:1
.loc 2 107 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ptrace
.loc 2 108 1 
func_sys_ptrace:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 101
.loc 2 108 2 prologue_end
PUSH $101
// syscall:4
.loc 2 108 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getuid
.loc 2 109 1 
func_sys_getuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 102
.loc 2 109 2 prologue_end
PUSH $102
// syscall:0
.loc 2 109 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_syslog
.loc 2 110 1 
func_sys_syslog:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 103
.loc 2 110 2 prologue_end
PUSH $103
// syscall:3
.loc 2 110 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getgid
.loc 2 111 1 
func_sys_getgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 104
.loc 2 111 2 prologue_end
PUSH $104
// syscall:0
.loc 2 111 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setuid
.loc 2 112 1 
func_sys_setuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 105
.loc 2 112 2 prologue_end
PUSH $105
// syscall:1
.loc 2 112 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setgid
.loc 2 113 1 
func_sys_setgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 106
.loc 2 113 2 prologue_end
PUSH $106
// syscall:1
.loc 2 113 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_geteuid
.loc 2 114 1 
func_sys_geteuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 107
.loc 2 114 2 prologue_end
PUSH $107
// syscall:0
.loc 2 114 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getegid
.loc 2 115 1 
func_sys_getegid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 108
.loc 2 115 2 prologue_end
PUSH $108
// syscall:0
.loc 2 115 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setpgid
.loc 2 116 1 
func_sys_setpgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 109
.loc 2 116 2 prologue_end
PUSH $109
// syscall:2
.loc 2 116 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getppid
.loc 2 117 1 
func_sys_getppid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 110
.loc 2 117 2 prologue_end
PUSH $110
// syscall:0
.loc 2 117 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getpgrp
.loc 2 118 1 
func_sys_getpgrp:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 111
.loc 2 118 2 prologue_end
PUSH $111
// syscall:0
.loc 2 118 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setsid
.loc 2 119 1 
func_sys_setsid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 112
.loc 2 119 2 prologue_end
PUSH $112
// syscall:0
.loc 2 119 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setreuid
.loc 2 120 1 
func_sys_setreuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 113
.loc 2 120 2 prologue_end
PUSH $113
// syscall:2
.loc 2 120 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setregid
.loc 2 121 1 
func_sys_setregid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 114
.loc 2 121 2 prologue_end
PUSH $114
// syscall:2
.loc 2 121 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getgroups
.loc 2 122 1 
func_sys_getgroups:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 115
.loc 2 122 2 prologue_end
PUSH $115
// syscall:2
.loc 2 122 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setgroups
.loc 2 123 1 
func_sys_setgroups:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 116
.loc 2 123 2 prologue_end
PUSH $116
// syscall:2
.loc 2 123 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setresuid
.loc 2 124 1 
func_sys_setresuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 117
.loc 2 124 2 prologue_end
PUSH $117
// syscall:3
.loc 2 124 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getresuid
.loc 2 125 1 
func_sys_getresuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 118
.loc 2 125 2 prologue_end
PUSH $118
// syscall:3
.loc 2 125 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setresgid
.loc 2 126 1 
func_sys_setresgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 119
.loc 2 126 2 prologue_end
PUSH $119
// syscall:3
.loc 2 126 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getresgid
.loc 2 127 1 
func_sys_getresgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 120
.loc 2 127 2 prologue_end
PUSH $120
// syscall:3
.loc 2 127 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getpgid
.loc 2 128 1 
func_sys_getpgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 121
.loc 2 128 2 prologue_end
PUSH $121
// syscall:1
.loc 2 128 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setfsuid
.loc 2 129 1 
func_sys_setfsuid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 122
.loc 2 129 2 prologue_end
PUSH $122
// syscall:1
.loc 2 129 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setfsgid
.loc 2 130 1 
func_sys_setfsgid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 123
.loc 2 130 2 prologue_end
PUSH $123
// syscall:1
.loc 2 130 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getsid
.loc 2 131 1 
func_sys_getsid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 124
.loc 2 131 2 prologue_end
PUSH $124
// syscall:1
.loc 2 131 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_capget
.loc 2 132 1 
func_sys_capget:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 125
.loc 2 132 2 prologue_end
PUSH $125
// syscall:2
.loc 2 132 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_capset
.loc 2 133 1 
func_sys_capset:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 126
.loc 2 133 2 prologue_end
PUSH $126
// syscall:2
.loc 2 133 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigpending
.loc 2 134 1 
func_sys_rt_sigpending:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 127
.loc 2 134 2 prologue_end
PUSH $127
// syscall:2
.loc 2 134 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigtimedwait
.loc 2 135 1 
func_sys_rt_sigtimedwait:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 128
.loc 2 135 2 prologue_end
PUSH $128
// syscall:4
.loc 2 135 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigqueueinfo
.loc 2 136 1 
func_sys_rt_sigqueueinfo:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 129
.loc 2 136 2 prologue_end
PUSH $129
// syscall:3
.loc 2 136 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_sigsuspend
.loc 2 137 1 
func_sys_rt_sigsuspend:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 130
.loc 2 137 2 prologue_end
PUSH $130
// syscall:2
.loc 2 137 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sigaltstack
.loc 2 138 1 
func_sys_sigaltstack:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 131
.loc 2 138 2 prologue_end
PUSH $131
// syscall:2
.loc 2 138 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_utime
.loc 2 139 1 
func_sys_utime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 132
.loc 2 139 2 prologue_end
PUSH $132
// syscall:2
.loc 2 139 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mknod
.loc 2 140 1 
func_sys_mknod:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 133
.loc 2 140 2 prologue_end
PUSH $133
// syscall:3
.loc 2 140 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_uselib
.loc 2 141 1 
func_sys_uselib:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 134
.loc 2 141 2 prologue_end
PUSH $134
// syscall:1
.loc 2 141 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_personality
.loc 2 142 1 
func_sys_personality:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 135
.loc 2 142 2 prologue_end
PUSH $135
// syscall:1
.loc 2 142 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ustat
.loc 2 143 1 
func_sys_ustat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 136
.loc 2 143 2 prologue_end
PUSH $136
// syscall:2
.loc 2 143 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_statfs
.loc 2 144 1 
func_sys_statfs:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 137
.loc 2 144 2 prologue_end
PUSH $137
// syscall:2
.loc 2 144 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fstatfs
.loc 2 145 1 
func_sys_fstatfs:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 138
.loc 2 145 2 prologue_end
PUSH $138
// syscall:2
.loc 2 145 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sysfs
.loc 2 146 1 
func_sys_sysfs:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 139
.loc 2 146 2 prologue_end
PUSH $139
// syscall:3
.loc 2 146 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getpriority
.loc 2 147 1 
func_sys_getpriority:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 140
.loc 2 147 2 prologue_end
PUSH $140
// syscall:2
.loc 2 147 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setpriority
.loc 2 148 1 
func_sys_setpriority:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 141
.loc 2 148 2 prologue_end
PUSH $141
// syscall:3
.loc 2 148 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_setparam
.loc 2 149 1 
func_sys_sched_setparam:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 142
.loc 2 149 2 prologue_end
PUSH $142
// syscall:2
.loc 2 149 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_getparam
.loc 2 150 1 
func_sys_sched_getparam:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 143
.loc 2 150 2 prologue_end
PUSH $143
// syscall:2
.loc 2 150 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_setscheduler
.loc 2 151 1 
func_sys_sched_setscheduler:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 144
.loc 2 151 2 prologue_end
PUSH $144
// syscall:3
.loc 2 151 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_getscheduler
.loc 2 152 1 
func_sys_sched_getscheduler:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 145
.loc 2 152 2 prologue_end
PUSH $145
// syscall:1
.loc 2 152 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_get_priority_max
.loc 2 153 1 
func_sys_sched_get_priority_max:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 146
.loc 2 153 2 prologue_end
PUSH $146
// syscall:1
.loc 2 153 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_get_priority_min
.loc 2 154 1 
func_sys_sched_get_priority_min:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 147
.loc 2 154 2 prologue_end
PUSH $147
// syscall:1
.loc 2 154 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_rr_get_interval
.loc 2 155 1 
func_sys_sched_rr_get_interval:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 148
.loc 2 155 2 prologue_end
PUSH $148
// syscall:2
.loc 2 155 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mlock
.loc 2 156 1 
func_sys_mlock:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 149
.loc 2 156 2 prologue_end
PUSH $149
// syscall:2
.loc 2 156 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_munlock
.loc 2 157 1 
func_sys_munlock:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 150
.loc 2 157 2 prologue_end
PUSH $150
// syscall:2
.loc 2 157 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mlockall
.loc 2 158 1 
func_sys_mlockall:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 151
.loc 2 158 2 prologue_end
PUSH $151
// syscall:1
.loc 2 158 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_munlockall
.loc 2 159 1 
func_sys_munlockall:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 152
.loc 2 159 2 prologue_end
PUSH $152
// syscall:0
.loc 2 159 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_vhangup
.loc 2 160 1 
func_sys_vhangup:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 153
.loc 2 160 2 prologue_end
PUSH $153
// syscall:0
.loc 2 160 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_modify_ldt
.loc 2 161 1 
func_sys_modify_ldt:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 154
.loc 2 161 2 prologue_end
PUSH $154
// syscall:6
.loc 2 161 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pivot_root
.loc 2 162 1 
func_sys_pivot_root:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 155
.loc 2 162 2 prologue_end
PUSH $155
// syscall:2
.loc 2 162 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys__sysctl
.loc 2 163 1 
func_sys__sysctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 156
.loc 2 163 2 prologue_end
PUSH $156
// syscall:6
.loc 2 163 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_prctl
.loc 2 164 1 
func_sys_prctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 157
.loc 2 164 2 prologue_end
PUSH $157
// syscall:5
.loc 2 164 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_arch_prctl
.loc 2 165 1 
func_sys_arch_prctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 158
.loc 2 165 2 prologue_end
PUSH $158
// syscall:6
.loc 2 165 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_adjtimex
.loc 2 166 1 
func_sys_adjtimex:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 159
.loc 2 166 2 prologue_end
PUSH $159
// syscall:1
.loc 2 166 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setrlimit
.loc 2 167 1 
func_sys_setrlimit:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 160
.loc 2 167 2 prologue_end
PUSH $160
// syscall:2
.loc 2 167 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_chroot
.loc 2 168 1 
func_sys_chroot:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 161
.loc 2 168 2 prologue_end
PUSH $161
// syscall:1
.loc 2 168 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sync
.loc 2 169 1 
func_sys_sync:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 162
.loc 2 169 2 prologue_end
PUSH $162
// syscall:0
.loc 2 169 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_acct
.loc 2 170 1 
func_sys_acct:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 163
.loc 2 170 2 prologue_end
PUSH $163
// syscall:1
.loc 2 170 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_settimeofday
.loc 2 171 1 
func_sys_settimeofday:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 164
.loc 2 171 2 prologue_end
PUSH $164
// syscall:2
.loc 2 171 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mount
.loc 2 172 1 
func_sys_mount:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 165
.loc 2 172 2 prologue_end
PUSH $165
// syscall:5
.loc 2 172 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_umount2
.loc 2 173 1 
func_sys_umount2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 166
.loc 2 173 2 prologue_end
PUSH $166
// syscall:6
.loc 2 173 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_swapon
.loc 2 174 1 
func_sys_swapon:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 167
.loc 2 174 2 prologue_end
PUSH $167
// syscall:2
.loc 2 174 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_swapoff
.loc 2 175 1 
func_sys_swapoff:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 168
.loc 2 175 2 prologue_end
PUSH $168
// syscall:1
.loc 2 175 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_reboot
.loc 2 176 1 
func_sys_reboot:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 169
.loc 2 176 2 prologue_end
PUSH $169
// syscall:4
.loc 2 176 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sethostname
.loc 2 177 1 
func_sys_sethostname:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 170
.loc 2 177 2 prologue_end
PUSH $170
// syscall:2
.loc 2 177 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setdomainname
.loc 2 178 1 
func_sys_setdomainname:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 171
.loc 2 178 2 prologue_end
PUSH $171
// syscall:2
.loc 2 178 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_iopl
.loc 2 179 1 
func_sys_iopl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 172
.loc 2 179 2 prologue_end
PUSH $172
// syscall:6
.loc 2 179 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ioperm
.loc 2 180 1 
func_sys_ioperm:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 173
.loc 2 180 2 prologue_end
PUSH $173
// syscall:3
.loc 2 180 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_create_module
.loc 2 181 1 
func_sys_create_module:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 174
.loc 2 181 2 prologue_end
PUSH $174
// syscall:6
.loc 2 181 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_init_module
.loc 2 182 1 
func_sys_init_module:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 175
.loc 2 182 2 prologue_end
PUSH $175
// syscall:3
.loc 2 182 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_delete_module
.loc 2 183 1 
func_sys_delete_module:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 176
.loc 2 183 2 prologue_end
PUSH $176
// syscall:2
.loc 2 183 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_get_kernel_syms
.loc 2 184 1 
func_sys_get_kernel_syms:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 177
.loc 2 184 2 prologue_end
PUSH $177
// syscall:6
.loc 2 184 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_query_module
.loc 2 185 1 
func_sys_query_module:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 178
.loc 2 185 2 prologue_end
PUSH $178
// syscall:6
.loc 2 185 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_quotactl
.loc 2 186 1 
func_sys_quotactl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 179
.loc 2 186 2 prologue_end
PUSH $179
// syscall:4
.loc 2 186 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_nfsservctl
.loc 2 187 1 
func_sys_nfsservctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 180
.loc 2 187 2 prologue_end
PUSH $180
// syscall:6
.loc 2 187 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getpmsg
.loc 2 188 1 
func_sys_getpmsg:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 181
.loc 2 188 2 prologue_end
PUSH $181
// syscall:6
.loc 2 188 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_putpmsg
.loc 2 189 1 
func_sys_putpmsg:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 182
.loc 2 189 2 prologue_end
PUSH $182
// syscall:6
.loc 2 189 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_afs_syscall
.loc 2 190 1 
func_sys_afs_syscall:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 183
.loc 2 190 2 prologue_end
PUSH $183
// syscall:6
.loc 2 190 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_tuxcall
.loc 2 191 1 
func_sys_tuxcall:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 184
.loc 2 191 2 prologue_end
PUSH $184
// syscall:6
.loc 2 191 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_security
.loc 2 192 1 
func_sys_security:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 185
.loc 2 192 2 prologue_end
PUSH $185
// syscall:6
.loc 2 192 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_gettid
.loc 2 193 1 
func_sys_gettid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 186
.loc 2 193 2 prologue_end
PUSH $186
// syscall:0
.loc 2 193 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_readahead
.loc 2 194 1 
func_sys_readahead:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 187
.loc 2 194 2 prologue_end
PUSH $187
// syscall:3
.loc 2 194 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setxattr
.loc 2 195 1 
func_sys_setxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 188
.loc 2 195 2 prologue_end
PUSH $188
// syscall:5
.loc 2 195 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lsetxattr
.loc 2 196 1 
func_sys_lsetxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 189
.loc 2 196 2 prologue_end
PUSH $189
// syscall:5
.loc 2 196 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fsetxattr
.loc 2 197 1 
func_sys_fsetxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 190
.loc 2 197 2 prologue_end
PUSH $190
// syscall:5
.loc 2 197 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getxattr
.loc 2 198 1 
func_sys_getxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 191
.loc 2 198 2 prologue_end
PUSH $191
// syscall:4
.loc 2 198 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lgetxattr
.loc 2 199 1 
func_sys_lgetxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 192
.loc 2 199 2 prologue_end
PUSH $192
// syscall:4
.loc 2 199 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fgetxattr
.loc 2 200 1 
func_sys_fgetxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 193
.loc 2 200 2 prologue_end
PUSH $193
// syscall:4
.loc 2 200 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_listxattr
.loc 2 201 1 
func_sys_listxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 194
.loc 2 201 2 prologue_end
PUSH $194
// syscall:3
.loc 2 201 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_llistxattr
.loc 2 202 1 
func_sys_llistxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 195
.loc 2 202 2 prologue_end
PUSH $195
// syscall:3
.loc 2 202 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_flistxattr
.loc 2 203 1 
func_sys_flistxattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 196
.loc 2 203 2 prologue_end
PUSH $196
// syscall:3
.loc 2 203 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_removexattr
.loc 2 204 1 
func_sys_removexattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 197
.loc 2 204 2 prologue_end
PUSH $197
// syscall:2
.loc 2 204 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lremovexattr
.loc 2 205 1 
func_sys_lremovexattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 198
.loc 2 205 2 prologue_end
PUSH $198
// syscall:2
.loc 2 205 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fremovexattr
.loc 2 206 1 
func_sys_fremovexattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 199
.loc 2 206 2 prologue_end
PUSH $199
// syscall:2
.loc 2 206 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_tkill
.loc 2 207 1 
func_sys_tkill:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 200
.loc 2 207 2 prologue_end
PUSH $200
// syscall:2
.loc 2 207 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_time
.loc 2 208 1 
func_sys_time:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 201
.loc 2 208 2 prologue_end
PUSH $201
// syscall:1
.loc 2 208 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_futex
.loc 2 209 1 
func_sys_futex:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 202
.loc 2 209 2 prologue_end
PUSH $202
// syscall:6
.loc 2 209 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_setaffinity
.loc 2 210 1 
func_sys_sched_setaffinity:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 203
.loc 2 210 2 prologue_end
PUSH $203
// syscall:3
.loc 2 210 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_getaffinity
.loc 2 211 1 
func_sys_sched_getaffinity:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 204
.loc 2 211 2 prologue_end
PUSH $204
// syscall:3
.loc 2 211 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_set_thread_area
.loc 2 212 1 
func_sys_set_thread_area:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 205
.loc 2 212 2 prologue_end
PUSH $205
// syscall:6
.loc 2 212 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_io_setup
.loc 2 213 1 
func_sys_io_setup:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 206
.loc 2 213 2 prologue_end
PUSH $206
// syscall:2
.loc 2 213 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_io_destroy
.loc 2 214 1 
func_sys_io_destroy:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 207
.loc 2 214 2 prologue_end
PUSH $207
// syscall:1
.loc 2 214 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_io_getevents
.loc 2 215 1 
func_sys_io_getevents:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 208
.loc 2 215 2 prologue_end
PUSH $208
// syscall:5
.loc 2 215 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_io_submit
.loc 2 216 1 
func_sys_io_submit:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 209
.loc 2 216 2 prologue_end
PUSH $209
// syscall:3
.loc 2 216 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_io_cancel
.loc 2 217 1 
func_sys_io_cancel:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 210
.loc 2 217 2 prologue_end
PUSH $210
// syscall:3
.loc 2 217 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_get_thread_area
.loc 2 218 1 
func_sys_get_thread_area:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 211
.loc 2 218 2 prologue_end
PUSH $211
// syscall:6
.loc 2 218 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_lookup_dcookie
.loc 2 219 1 
func_sys_lookup_dcookie:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 212
.loc 2 219 2 prologue_end
PUSH $212
// syscall:3
.loc 2 219 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_create
.loc 2 220 1 
func_sys_epoll_create:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 213
.loc 2 220 2 prologue_end
PUSH $213
// syscall:1
.loc 2 220 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_ctl_old
.loc 2 221 1 
func_sys_epoll_ctl_old:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 214
.loc 2 221 2 prologue_end
PUSH $214
// syscall:6
.loc 2 221 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_wait_old
.loc 2 222 1 
func_sys_epoll_wait_old:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 215
.loc 2 222 2 prologue_end
PUSH $215
// syscall:6
.loc 2 222 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_remap_file_pages
.loc 2 223 1 
func_sys_remap_file_pages:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 216
.loc 2 223 2 prologue_end
PUSH $216
// syscall:5
.loc 2 223 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getdents64
.loc 2 224 1 
func_sys_getdents64:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 217
.loc 2 224 2 prologue_end
PUSH $217
// syscall:3
.loc 2 224 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_set_tid_address
.loc 2 225 1 
func_sys_set_tid_address:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 218
.loc 2 225 2 prologue_end
PUSH $218
// syscall:1
.loc 2 225 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_restart_syscall
.loc 2 226 1 
func_sys_restart_syscall:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 219
.loc 2 226 2 prologue_end
PUSH $219
// syscall:0
.loc 2 226 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_semtimedop
.loc 2 227 1 
func_sys_semtimedop:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 220
.loc 2 227 2 prologue_end
PUSH $220
// syscall:4
.loc 2 227 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fadvise64
.loc 2 228 1 
func_sys_fadvise64:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 221
.loc 2 228 2 prologue_end
PUSH $221
// syscall:4
.loc 2 228 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timer_create
.loc 2 229 1 
func_sys_timer_create:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 222
.loc 2 229 2 prologue_end
PUSH $222
// syscall:3
.loc 2 229 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timer_settime
.loc 2 230 1 
func_sys_timer_settime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 223
.loc 2 230 2 prologue_end
PUSH $223
// syscall:4
.loc 2 230 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timer_gettime
.loc 2 231 1 
func_sys_timer_gettime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 224
.loc 2 231 2 prologue_end
PUSH $224
// syscall:2
.loc 2 231 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timer_getoverrun
.loc 2 232 1 
func_sys_timer_getoverrun:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 225
.loc 2 232 2 prologue_end
PUSH $225
// syscall:1
.loc 2 232 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timer_delete
.loc 2 233 1 
func_sys_timer_delete:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 226
.loc 2 233 2 prologue_end
PUSH $226
// syscall:1
.loc 2 233 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_clock_settime
.loc 2 234 1 
func_sys_clock_settime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 227
.loc 2 234 2 prologue_end
PUSH $227
// syscall:2
.loc 2 234 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_clock_gettime
.loc 2 235 1 
func_sys_clock_gettime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 228
.loc 2 235 2 prologue_end
PUSH $228
// syscall:2
.loc 2 235 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_clock_getres
.loc 2 236 1 
func_sys_clock_getres:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 229
.loc 2 236 2 prologue_end
PUSH $229
// syscall:2
.loc 2 236 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_clock_nanosleep
.loc 2 237 1 
func_sys_clock_nanosleep:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 230
.loc 2 237 2 prologue_end
PUSH $230
// syscall:4
.loc 2 237 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_exit_group
.loc 2 238 1 
func_sys_exit_group:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 231
.loc 2 238 2 prologue_end
PUSH $231
// syscall:1
.loc 2 238 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_wait
.loc 2 239 1 
func_sys_epoll_wait:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 232
.loc 2 239 2 prologue_end
PUSH $232
// syscall:4
.loc 2 239 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_ctl
.loc 2 240 1 
func_sys_epoll_ctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 233
.loc 2 240 2 prologue_end
PUSH $233
// syscall:4
.loc 2 240 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_tgkill
.loc 2 241 1 
func_sys_tgkill:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 234
.loc 2 241 2 prologue_end
PUSH $234
// syscall:3
.loc 2 241 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_utimes
.loc 2 242 1 
func_sys_utimes:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 235
.loc 2 242 2 prologue_end
PUSH $235
// syscall:2
.loc 2 242 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_vserver
.loc 2 243 1 
func_sys_vserver:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 236
.loc 2 243 2 prologue_end
PUSH $236
// syscall:6
.loc 2 243 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mbind
.loc 2 244 1 
func_sys_mbind:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 237
.loc 2 244 2 prologue_end
PUSH $237
// syscall:6
.loc 2 244 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_set_mempolicy
.loc 2 245 1 
func_sys_set_mempolicy:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 238
.loc 2 245 2 prologue_end
PUSH $238
// syscall:3
.loc 2 245 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_get_mempolicy
.loc 2 246 1 
func_sys_get_mempolicy:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 239
.loc 2 246 2 prologue_end
PUSH $239
// syscall:5
.loc 2 246 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mq_open
.loc 2 247 1 
func_sys_mq_open:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 240
.loc 2 247 2 prologue_end
PUSH $240
// syscall:4
.loc 2 247 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mq_unlink
.loc 2 248 1 
func_sys_mq_unlink:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 241
.loc 2 248 2 prologue_end
PUSH $241
// syscall:1
.loc 2 248 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mq_timedsend
.loc 2 249 1 
func_sys_mq_timedsend:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 242
.loc 2 249 2 prologue_end
PUSH $242
// syscall:5
.loc 2 249 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mq_timedreceive
.loc 2 250 1 
func_sys_mq_timedreceive:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 243
.loc 2 250 2 prologue_end
PUSH $243
// syscall:5
.loc 2 250 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mq_notify
.loc 2 251 1 
func_sys_mq_notify:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 244
.loc 2 251 2 prologue_end
PUSH $244
// syscall:2
.loc 2 251 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mq_getsetattr
.loc 2 252 1 
func_sys_mq_getsetattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 245
.loc 2 252 2 prologue_end
PUSH $245
// syscall:3
.loc 2 252 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_kexec_load
.loc 2 253 1 
func_sys_kexec_load:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 246
.loc 2 253 2 prologue_end
PUSH $246
// syscall:4
.loc 2 253 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_waitid
.loc 2 254 1 
func_sys_waitid:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 247
.loc 2 254 2 prologue_end
PUSH $247
// syscall:5
.loc 2 254 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_add_key
.loc 2 255 1 
func_sys_add_key:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 248
.loc 2 255 2 prologue_end
PUSH $248
// syscall:5
.loc 2 255 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_request_key
.loc 2 256 1 
func_sys_request_key:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 249
.loc 2 256 2 prologue_end
PUSH $249
// syscall:4
.loc 2 256 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_keyctl
.loc 2 257 1 
func_sys_keyctl:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 250
.loc 2 257 2 prologue_end
PUSH $250
// syscall:5
.loc 2 257 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ioprio_set
.loc 2 258 1 
func_sys_ioprio_set:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 251
.loc 2 258 2 prologue_end
PUSH $251
// syscall:3
.loc 2 258 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ioprio_get
.loc 2 259 1 
func_sys_ioprio_get:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 252
.loc 2 259 2 prologue_end
PUSH $252
// syscall:2
.loc 2 259 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_inotify_init
.loc 2 260 1 
func_sys_inotify_init:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 253
.loc 2 260 2 prologue_end
PUSH $253
// syscall:0
.loc 2 260 3 
POP %RAX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_inotify_add_watch
.loc 2 261 1 
func_sys_inotify_add_watch:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 254
.loc 2 261 2 prologue_end
PUSH $254
// syscall:3
.loc 2 261 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_inotify_rm_watch
.loc 2 262 1 
func_sys_inotify_rm_watch:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 255
.loc 2 262 2 prologue_end
PUSH $255
// syscall:2
.loc 2 262 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_migrate_pages
.loc 2 263 1 
func_sys_migrate_pages:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 256
.loc 2 263 2 prologue_end
PUSH $256
// syscall:4
.loc 2 263 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_openat
.loc 2 264 1 
func_sys_openat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 257
.loc 2 264 2 prologue_end
PUSH $257
// syscall:4
.loc 2 264 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mkdirat
.loc 2 265 1 
func_sys_mkdirat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 258
.loc 2 265 2 prologue_end
PUSH $258
// syscall:3
.loc 2 265 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mknodat
.loc 2 266 1 
func_sys_mknodat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 259
.loc 2 266 2 prologue_end
PUSH $259
// syscall:4
.loc 2 266 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fchownat
.loc 2 267 1 
func_sys_fchownat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 260
.loc 2 267 2 prologue_end
PUSH $260
// syscall:5
.loc 2 267 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_futimesat
.loc 2 268 1 
func_sys_futimesat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 261
.loc 2 268 2 prologue_end
PUSH $261
// syscall:3
.loc 2 268 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_newfstatat
.loc 2 269 1 
func_sys_newfstatat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 262
.loc 2 269 2 prologue_end
PUSH $262
// syscall:4
.loc 2 269 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_unlinkat
.loc 2 270 1 
func_sys_unlinkat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 263
.loc 2 270 2 prologue_end
PUSH $263
// syscall:3
.loc 2 270 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_renameat
.loc 2 271 1 
func_sys_renameat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 264
.loc 2 271 2 prologue_end
PUSH $264
// syscall:4
.loc 2 271 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_linkat
.loc 2 272 1 
func_sys_linkat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 265
.loc 2 272 2 prologue_end
PUSH $265
// syscall:5
.loc 2 272 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_symlinkat
.loc 2 273 1 
func_sys_symlinkat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 266
.loc 2 273 2 prologue_end
PUSH $266
// syscall:3
.loc 2 273 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_readlinkat
.loc 2 274 1 
func_sys_readlinkat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 267
.loc 2 274 2 prologue_end
PUSH $267
// syscall:4
.loc 2 274 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fchmodat
.loc 2 275 1 
func_sys_fchmodat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 268
.loc 2 275 2 prologue_end
PUSH $268
// syscall:3
.loc 2 275 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_faccessat
.loc 2 276 1 
func_sys_faccessat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 269
.loc 2 276 2 prologue_end
PUSH $269
// syscall:3
.loc 2 276 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pselect6
.loc 2 277 1 
func_sys_pselect6:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 270
.loc 2 277 2 prologue_end
PUSH $270
// syscall:6
.loc 2 277 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_ppoll
.loc 2 278 1 
func_sys_ppoll:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 271
.loc 2 278 2 prologue_end
PUSH $271
// syscall:5
.loc 2 278 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_unshare
.loc 2 279 1 
func_sys_unshare:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 272
.loc 2 279 2 prologue_end
PUSH $272
// syscall:1
.loc 2 279 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_set_robust_list
.loc 2 280 1 
func_sys_set_robust_list:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 273
.loc 2 280 2 prologue_end
PUSH $273
// syscall:2
.loc 2 280 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_get_robust_list
.loc 2 281 1 
func_sys_get_robust_list:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 274
.loc 2 281 2 prologue_end
PUSH $274
// syscall:3
.loc 2 281 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_splice
.loc 2 282 1 
func_sys_splice:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 275
.loc 2 282 2 prologue_end
PUSH $275
// syscall:6
.loc 2 282 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_tee
.loc 2 283 1 
func_sys_tee:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 276
.loc 2 283 2 prologue_end
PUSH $276
// syscall:4
.loc 2 283 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sync_file_range
.loc 2 284 1 
func_sys_sync_file_range:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 277
.loc 2 284 2 prologue_end
PUSH $277
// syscall:4
.loc 2 284 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_vmsplice
.loc 2 285 1 
func_sys_vmsplice:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 278
.loc 2 285 2 prologue_end
PUSH $278
// syscall:4
.loc 2 285 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_move_pages
.loc 2 286 1 
func_sys_move_pages:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 279
.loc 2 286 2 prologue_end
PUSH $279
// syscall:6
.loc 2 286 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_utimensat
.loc 2 287 1 
func_sys_utimensat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 280
.loc 2 287 2 prologue_end
PUSH $280
// syscall:4
.loc 2 287 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_pwait
.loc 2 288 1 
func_sys_epoll_pwait:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 281
.loc 2 288 2 prologue_end
PUSH $281
// syscall:6
.loc 2 288 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_signalfd
.loc 2 289 1 
func_sys_signalfd:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 282
.loc 2 289 2 prologue_end
PUSH $282
// syscall:3
.loc 2 289 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timerfd_create
.loc 2 290 1 
func_sys_timerfd_create:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 283
.loc 2 290 2 prologue_end
PUSH $283
// syscall:2
.loc 2 290 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_eventfd
.loc 2 291 1 
func_sys_eventfd:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 284
.loc 2 291 2 prologue_end
PUSH $284
// syscall:1
.loc 2 291 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fallocate
.loc 2 292 1 
func_sys_fallocate:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 285
.loc 2 292 2 prologue_end
PUSH $285
// syscall:4
.loc 2 292 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timerfd_settime
.loc 2 293 1 
func_sys_timerfd_settime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 286
.loc 2 293 2 prologue_end
PUSH $286
// syscall:4
.loc 2 293 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_timerfd_gettime
.loc 2 294 1 
func_sys_timerfd_gettime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 287
.loc 2 294 2 prologue_end
PUSH $287
// syscall:2
.loc 2 294 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_accept4
.loc 2 295 1 
func_sys_accept4:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 288
.loc 2 295 2 prologue_end
PUSH $288
// syscall:4
.loc 2 295 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_signalfd4
.loc 2 296 1 
func_sys_signalfd4:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 289
.loc 2 296 2 prologue_end
PUSH $289
// syscall:4
.loc 2 296 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_eventfd2
.loc 2 297 1 
func_sys_eventfd2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 290
.loc 2 297 2 prologue_end
PUSH $290
// syscall:2
.loc 2 297 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_epoll_create1
.loc 2 298 1 
func_sys_epoll_create1:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 291
.loc 2 298 2 prologue_end
PUSH $291
// syscall:1
.loc 2 298 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_dup3
.loc 2 299 1 
func_sys_dup3:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 292
.loc 2 299 2 prologue_end
PUSH $292
// syscall:3
.loc 2 299 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pipe2
.loc 2 300 1 
func_sys_pipe2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 293
.loc 2 300 2 prologue_end
PUSH $293
// syscall:2
.loc 2 300 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_inotify_init1
.loc 2 301 1 
func_sys_inotify_init1:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 294
.loc 2 301 2 prologue_end
PUSH $294
// syscall:1
.loc 2 301 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_preadv
.loc 2 302 1 
func_sys_preadv:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 295
.loc 2 302 2 prologue_end
PUSH $295
// syscall:5
.loc 2 302 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pwritev
.loc 2 303 1 
func_sys_pwritev:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 296
.loc 2 303 2 prologue_end
PUSH $296
// syscall:5
.loc 2 303 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_rt_tgsigqueueinfo
.loc 2 304 1 
func_sys_rt_tgsigqueueinfo:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 297
.loc 2 304 2 prologue_end
PUSH $297
// syscall:4
.loc 2 304 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_perf_event_open
.loc 2 305 1 
func_sys_perf_event_open:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 298
.loc 2 305 2 prologue_end
PUSH $298
// syscall:5
.loc 2 305 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_recvmmsg
.loc 2 306 1 
func_sys_recvmmsg:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 299
.loc 2 306 2 prologue_end
PUSH $299
// syscall:5
.loc 2 306 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fanotify_init
.loc 2 307 1 
func_sys_fanotify_init:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 300
.loc 2 307 2 prologue_end
PUSH $300
// syscall:2
.loc 2 307 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_fanotify_mark
.loc 2 308 1 
func_sys_fanotify_mark:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 301
.loc 2 308 2 prologue_end
PUSH $301
// syscall:5
.loc 2 308 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_prlimit64
.loc 2 309 1 
func_sys_prlimit64:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 302
.loc 2 309 2 prologue_end
PUSH $302
// syscall:4
.loc 2 309 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_name_to_handle_at
.loc 2 310 1 
func_sys_name_to_handle_at:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 303
.loc 2 310 2 prologue_end
PUSH $303
// syscall:5
.loc 2 310 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_open_by_handle_at
.loc 2 311 1 
func_sys_open_by_handle_at:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 304
.loc 2 311 2 prologue_end
PUSH $304
// syscall:3
.loc 2 311 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_clock_adjtime
.loc 2 312 1 
func_sys_clock_adjtime:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 305
.loc 2 312 2 prologue_end
PUSH $305
// syscall:2
.loc 2 312 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_syncfs
.loc 2 313 1 
func_sys_syncfs:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 306
.loc 2 313 2 prologue_end
PUSH $306
// syscall:1
.loc 2 313 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sendmmsg
.loc 2 314 1 
func_sys_sendmmsg:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 307
.loc 2 314 2 prologue_end
PUSH $307
// syscall:4
.loc 2 314 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_setns
.loc 2 315 1 
func_sys_setns:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 308
.loc 2 315 2 prologue_end
PUSH $308
// syscall:2
.loc 2 315 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getcpu
.loc 2 316 1 
func_sys_getcpu:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 309
.loc 2 316 2 prologue_end
PUSH $309
// syscall:3
.loc 2 316 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_process_vm_readv
.loc 2 317 1 
func_sys_process_vm_readv:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 310
.loc 2 317 2 prologue_end
PUSH $310
// syscall:6
.loc 2 317 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_process_vm_writev
.loc 2 318 1 
func_sys_process_vm_writev:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 311
.loc 2 318 2 prologue_end
PUSH $311
// syscall:6
.loc 2 318 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_kcmp
.loc 2 319 1 
func_sys_kcmp:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 312
.loc 2 319 2 prologue_end
PUSH $312
// syscall:5
.loc 2 319 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_finit_module
.loc 2 320 1 
func_sys_finit_module:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 313
.loc 2 320 2 prologue_end
PUSH $313
// syscall:3
.loc 2 320 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_setattr
.loc 2 321 1 
func_sys_sched_setattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 314
.loc 2 321 2 prologue_end
PUSH $314
// syscall:3
.loc 2 321 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_sched_getattr
.loc 2 322 1 
func_sys_sched_getattr:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 315
.loc 2 322 2 prologue_end
PUSH $315
// syscall:4
.loc 2 322 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_renameat2
.loc 2 323 1 
func_sys_renameat2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 316
.loc 2 323 2 prologue_end
PUSH $316
// syscall:5
.loc 2 323 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_seccomp
.loc 2 324 1 
func_sys_seccomp:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 317
.loc 2 324 2 prologue_end
PUSH $317
// syscall:3
.loc 2 324 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_getrandom
.loc 2 325 1 
func_sys_getrandom:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 318
.loc 2 325 2 prologue_end
PUSH $318
// syscall:3
.loc 2 325 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_memfd_create
.loc 2 326 1 
func_sys_memfd_create:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 319
.loc 2 326 2 prologue_end
PUSH $319
// syscall:2
.loc 2 326 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_kexec_file_load
.loc 2 327 1 
func_sys_kexec_file_load:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 320
.loc 2 327 2 prologue_end
PUSH $320
// syscall:5
.loc 2 327 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_bpf
.loc 2 328 1 
func_sys_bpf:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 321
.loc 2 328 2 prologue_end
PUSH $321
// syscall:3
.loc 2 328 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_execveat
.loc 2 329 1 
func_sys_execveat:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 322
.loc 2 329 2 prologue_end
PUSH $322
// syscall:5
.loc 2 329 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_userfaultfd
.loc 2 330 1 
func_sys_userfaultfd:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 323
.loc 2 330 2 prologue_end
PUSH $323
// syscall:1
.loc 2 330 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_membarrier
.loc 2 331 1 
func_sys_membarrier:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 324
.loc 2 331 2 prologue_end
PUSH $324
// syscall:2
.loc 2 331 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_mlock2
.loc 2 332 1 
func_sys_mlock2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 325
.loc 2 332 2 prologue_end
PUSH $325
// syscall:3
.loc 2 332 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_copy_file_range
.loc 2 333 1 
func_sys_copy_file_range:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 326
.loc 2 333 2 prologue_end
PUSH $326
// syscall:6
.loc 2 333 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_preadv2
.loc 2 334 1 
func_sys_preadv2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 327
.loc 2 334 2 prologue_end
PUSH $327
// syscall:6
.loc 2 334 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pwritev2
.loc 2 335 1 
func_sys_pwritev2:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 328
.loc 2 335 2 prologue_end
PUSH $328
// syscall:6
.loc 2 335 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
POP %R9
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pkey_mprotect
.loc 2 336 1 
func_sys_pkey_mprotect:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 329
.loc 2 336 2 prologue_end
PUSH $329
// syscall:4
.loc 2 336 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pkey_alloc
.loc 2 337 1 
func_sys_pkey_alloc:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 330
.loc 2 337 2 prologue_end
PUSH $330
// syscall:2
.loc 2 337 3 
POP %RAX
POP %RDI
POP %RSI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_pkey_free
.loc 2 338 1 
func_sys_pkey_free:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 331
.loc 2 338 2 prologue_end
PUSH $331
// syscall:1
.loc 2 338 3 
POP %RAX
POP %RDI
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #sys_statx
.loc 2 339 1 
func_sys_statx:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 332
.loc 2 339 2 prologue_end
PUSH $332
// syscall:5
.loc 2 339 3 
POP %RAX
POP %RDI
POP %RSI
POP %RDX
POP %R10
POP %R8
SYSCALL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #to_string
.loc 2 363 1 
func_to_string:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 0
.loc 2 364 1 prologue_end
PUSH $0
// swap
.loc 2 364 2 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// @temp_end
.loc 2 364 3 
LEA temp_end(%rip), %RAX
PUSH %RAX
// 1
.loc 2 364 4 
PUSH $1
// -
.loc 2 364 5 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// copy:1
.loc 2 365 1 
MOV 8(%RSP), %RAX
PUSH %RAX
// 0
.loc 2 365 2 
PUSH $0
// <
.loc 2 365 3 
POP %RBX
POP %RCX
XOR %RAX, %RAX
CMP %RBX, %RCX
SETL %AL
PUSH %RAX
// if
.loc 2 365 4 
POP %RAX
CMP $0, %RAX
JE endif_0
// 1
.loc 2 366 1 
PUSH $1
// swap:3
.loc 2 366 2 
MOV 24(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 24(%RSP)
MOV %RAX, 0(%RSP)
// pop
.loc 2 366 3 
POP %RAX
// swap
.loc 2 367 1 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// -1
.loc 2 367 2 
PUSH $-1
// *
.loc 2 367 3 
POP %RBX
POP %RAX
MUL %RBX
PUSH %RAX
// swap
.loc 2 367 4 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// fi
.loc 2 368 1 

endif_0:
// while
.loc 2 369 1 

while_0:
// copy
.loc 2 370 1 
MOV 0(%RSP), %RAX
PUSH %RAX
// swap:2
.loc 2 370 2 
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// 10
.loc 2 370 3 
PUSH $10
// divmod
.loc 2 370 4 
POP %RBX
POP %RAX
XOR %RDX, %RDX
DIV %RBX
PUSH %RAX
PUSH %RDX
// '0'
.loc 2 371 1 
PUSH $48
// +
.loc 2 371 2 
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// swap:2:1
.loc 2 372 1 
MOV 16(%RSP), %RAX
MOV 8(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 8(%RSP)
// setbyte
.loc 2 373 1 
CALL func_setbyte
// copy
.loc 2 374 1 
MOV 0(%RSP), %RAX
PUSH %RAX
// 0
.loc 2 375 1 
PUSH $0
// !=
.loc 2 375 2 
POP %RBX
POP %RCX
XOR %RAX, %RAX
CMP %RBX, %RCX
SETNE %AL
PUSH %RAX
// do
.loc 2 375 3 
POP %RAX
CMP $0, %RAX
JE endwhile_0
// swap
.loc 2 376 1 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 1
.loc 2 376 2 
PUSH $1
// -
.loc 2 376 3 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// elihw
.loc 2 377 1 
JMP while_0

endwhile_0:
// pop
.loc 2 379 1 
POP %RAX
// swap
.loc 2 380 1 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 1
.loc 2 380 2 
PUSH $1
// =
.loc 2 380 3 
POP %RBX
POP %RCX
XOR %RAX, %RAX
CMP %RBX, %RCX
SETE %AL
PUSH %RAX
// if
.loc 2 380 4 
POP %RAX
CMP $0, %RAX
JE endif_1
// 1
.loc 2 381 1 
PUSH $1
// -
.loc 2 381 2 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// copy
.loc 2 381 3 
MOV 0(%RSP), %RAX
PUSH %RAX
// '-'
.loc 2 381 4 
PUSH $45
// setbyte
.loc 2 381 5 
CALL func_setbyte
// fi
.loc 2 382 1 

endif_1:
// copy
.loc 2 384 1 
MOV 0(%RSP), %RAX
PUSH %RAX
// 8
.loc 2 384 2 
PUSH $8
// -
.loc 2 384 3 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// copy
.loc 2 384 4 
MOV 0(%RSP), %RAX
PUSH %RAX
// swap:2
.loc 2 384 5 
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// @temp_end
.loc 2 386 1 
LEA temp_end(%rip), %RAX
PUSH %RAX
// swap
.loc 2 386 2 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// -
.loc 2 386 3 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// set:8
.loc 2 387 1 
POP %RAX
POP %RBX
MOVq %RAX, (%RBX)
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #clear
.loc 2 392 1 
func_clear:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// "\x1b[H\x1b[J"
.loc 2 393 1 prologue_end
LEA string_0(%rip), %RAX
PUSH %RAX
// print
.loc 2 393 2 
CALL func_print
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #print
.loc 2 397 1 
func_print:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// copy
.loc 2 398 1 prologue_end
MOV 0(%RSP), %RAX
PUSH %RAX
// get:8
.loc 2 398 2 
POP %RBX
MOVq (%RBX), %RAX
PUSH %RAX
// swap
.loc 2 398 3 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 8
.loc 2 398 4 
PUSH $8
// +
.loc 2 398 5 
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// $STDOUT
.loc 2 399 1 
PUSH $1
// sys_write
.loc 2 399 2 
CALL func_sys_write
// pop
.loc 2 399 3 
POP %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #strlen
.loc 2 403 1 
func_strlen:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// copy
.loc 2 404 1 prologue_end
MOV 0(%RSP), %RAX
PUSH %RAX
// while
.loc 2 405 1 

while_1:
// copy
.loc 2 405 2 
MOV 0(%RSP), %RAX
PUSH %RAX
// get:1
.loc 2 405 3 
POP %RBX
XOR %RAX, %RAX
MOVb (%RBX), %AL
PUSH %RAX
// do
.loc 2 405 4 
POP %RAX
CMP $0, %RAX
JE endwhile_1
// 1
.loc 2 406 1 
PUSH $1
// +
.loc 2 406 2 
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// elihw
.loc 2 407 1 
JMP while_1

endwhile_1:
// swap
.loc 2 408 1 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// -
.loc 2 408 2 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #puts
.loc 2 412 1 
func_puts:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// copy
.loc 2 413 1 prologue_end
MOV 0(%RSP), %RAX
PUSH %RAX
// strlen
.loc 2 413 2 
CALL func_strlen
// swap
.loc 2 413 3 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// $STDOUT
.loc 2 414 1 
PUSH $1
// sys_write
.loc 2 414 2 
CALL func_sys_write
// pop
.loc 2 414 3 
POP %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #printint
.loc 2 418 1 
func_printint:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// to_string
.loc 2 419 1 prologue_end
CALL func_to_string
// print
.loc 2 419 2 
CALL func_print
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #getbyte
.loc 2 423 1 
func_getbyte:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// get:1
.loc 2 424 1 prologue_end
POP %RBX
XOR %RAX, %RAX
MOVb (%RBX), %AL
PUSH %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #setbyte
.loc 2 428 1 
func_setbyte:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// set:1
.loc 2 429 1 prologue_end
POP %RAX
POP %RBX
MOVb %AL, (%RBX)
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #readbyte
.loc 2 432 1 
func_readbyte:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 1
.loc 2 433 1 prologue_end
PUSH $1
// @temp
.loc 2 433 2 
LEA temp(%rip), %RAX
PUSH %RAX
// $STDIN
.loc 2 433 3 
PUSH $0
// sys_read
.loc 2 433 4 
CALL func_sys_read
// pop
.loc 2 433 5 
POP %RAX
// @temp
.loc 2 434 1 
LEA temp(%rip), %RAX
PUSH %RAX
// getbyte
.loc 2 434 2 
CALL func_getbyte
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #readstring
.loc 2 438 1 
func_readstring:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// copy:1
.loc 2 439 1 prologue_end
MOV 8(%RSP), %RAX
PUSH %RAX
// 8
.loc 2 439 2 
PUSH $8
// +
.loc 2 439 3 
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// swap
.loc 2 440 1 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// 8
.loc 2 440 2 
PUSH $8
// -
.loc 2 440 3 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// swap
.loc 2 440 4 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// $STDIN
.loc 2 441 1 
PUSH $0
// sys_read
.loc 2 441 2 
CALL func_sys_read
// set:8
.loc 2 442 1 
POP %RAX
POP %RBX
MOVq %RAX, (%RBX)
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
.section .bss
.lcomm buffer, 100
.lcomm buffer_end, 0
.section .text
// #file_pos
.loc 1 6 1 
func_file_pos:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// $SEEK_CUR
.loc 1 7 1 prologue_end
PUSH $1
// 0
.loc 1 7 2 
PUSH $0
// swap:2
.loc 1 7 3 
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// sys_lseek
.loc 1 7 4 
CALL func_sys_lseek
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #file_size
.loc 1 13 1 
func_file_size:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// copy
.loc 1 14 1 prologue_end
MOV 0(%RSP), %RAX
PUSH %RAX
// file_pos
.loc 1 14 2 
CALL func_file_pos
// $SEEK_END
.loc 1 16 1 
PUSH $2
// 0
.loc 1 16 2 
PUSH $0
// copy:3
.loc 1 16 3 
MOV 24(%RSP), %RAX
PUSH %RAX
// sys_lseek
.loc 1 16 4 
CALL func_sys_lseek
// swap:2
.loc 1 18 1 
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// $SEEK_SET
.loc 1 20 1 
PUSH $0
// swap:2
.loc 1 20 2 
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// swap
.loc 1 20 3 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// sys_lseek
.loc 1 21 1 
CALL func_sys_lseek
// pop
.loc 1 21 2 
POP %RAX
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #openfile
.loc 1 24 1 
func_openfile:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// $O_RDONLY
.loc 1 25 1 prologue_end
PUSH $0
// 0
.loc 1 25 2 
PUSH $0
// "./test.stacksy\x00"
.loc 1 25 3 
LEA string_1(%rip), %RAX
PUSH %RAX
// 8
.loc 1 25 4 
PUSH $8
// +
.loc 1 25 5 
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// $AT_FDCWD
.loc 1 25 6 
PUSH $-100
// sys_openat
.loc 1 25 7 
CALL func_sys_openat
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #readfile
.loc 1 29 1 
func_readfile:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// 8
.loc 1 30 1 prologue_end
PUSH $8
// -
.loc 1 30 2 
POP %RBX
POP %RAX
SUB %RBX, %RAX
PUSH %RAX
// swap
.loc 1 30 3 
MOV 8(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 8(%RSP)
MOV %RAX, 0(%RSP)
// copy
.loc 1 31 1 
MOV 0(%RSP), %RAX
PUSH %RAX
// 8
.loc 1 31 2 
PUSH $8
// +
.loc 1 31 3 
POP %RBX
POP %RAX
ADD %RBX, %RAX
PUSH %RAX
// swap:2
.loc 1 31 4 
MOV 16(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 0(%RSP)
// swap:3
.loc 1 32 1 
MOV 24(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 24(%RSP)
MOV %RAX, 0(%RSP)
// swap:2:3
.loc 1 32 2 
MOV 16(%RSP), %RAX
MOV 24(%RSP), %RBX
MOV %RBX, 16(%RSP)
MOV %RAX, 24(%RSP)
// sys_read
.loc 1 33 1 
CALL func_sys_read
// set:8
.loc 1 34 1 
POP %RAX
POP %RBX
MOVq %RAX, (%RBX)
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #malloc
.loc 1 37 1 
func_malloc:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// -1
.loc 1 38 1 prologue_end
PUSH $-1
// $MAP_PRIVATE
.loc 1 38 2 
PUSH $2
// $MAP_ANONYMOUS
.loc 1 38 3 
PUSH $0x20
// or
.loc 1 38 4 
POP %RBX
POP %RAX
OR %RBX, %RAX
PUSH %RAX
// $PROT_READ
.loc 1 38 5 
PUSH $1
// $PROT_WRITE
.loc 1 38 6 
PUSH $2
// or
.loc 1 38 7 
POP %RBX
POP %RAX
OR %RBX, %RAX
PUSH %RAX
// 0
.loc 1 38 8 
PUSH $0
// swap:4
.loc 1 38 9 
MOV 32(%RSP), %RAX
MOV 0(%RSP), %RBX
MOV %RBX, 32(%RSP)
MOV %RAX, 0(%RSP)
// 0
.loc 1 38 10 
PUSH $0
// sys_mmap
.loc 1 38 11 
CALL func_sys_mmap
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET
// #entry
.loc 1 41 1 
func_entry:
POP %RCX
MOV %RCX, (%R12)
ADD $8, %R12
// openfile
.loc 1 42 1 prologue_end
CALL func_openfile
// file_size
.loc 1 43 1 
CALL func_file_size
// malloc
.loc 1 43 2 
CALL func_malloc
// copy
.loc 1 44 1 
MOV 0(%RSP), %RAX
PUSH %RAX
// 100
.loc 1 44 2 
PUSH $100
// readfile
.loc 1 44 3 
CALL func_readfile
// copy
.loc 1 44 4 
MOV 0(%RSP), %RAX
PUSH %RAX
// puts
.loc 1 44 5 
CALL func_puts
SUB $8, %R12
MOV (%R12), %RCX
PUSH %RCX
RET

.section .data
string_0: .quad 6
string_0_ptr: .ascii "\033[H\033[J"
string_1: .quad 15
string_1_ptr: .ascii "./test.stacksy\000"
