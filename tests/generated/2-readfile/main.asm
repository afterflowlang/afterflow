bits 64
default rel
section .text
global _7_error
_7_error:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    call exit ; call libc exit to flush buffers
global release_heap_ptr
release_heap_ptr:
    push rbp ; save caller frame
    mov rbp, rsp ; establish frame
    push rbx ; preserve rbx
    mov rbx, rdi ; keep env_end pointer
    mov rcx, [rbx+24] ; load env size metadata
    mov rdx, [rbx+32] ; load heap size metadata
    mov rdi, rbx
    sub rdi, rcx ; compute env base pointer
    mov rsi, rdx ; heap size for munmap
    mov rax, 11 ; munmap syscall
    syscall
    pop rbx
    pop rbp
    ret
global _7_error_unwrapper
_7_error_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _7_error
global _7_error_deep_release
_7_error_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _7_error_deepcopy
_7_error_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _5_error
_5_error:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store s arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 48 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_7_error_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_7_error_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_7_error_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _7_error closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    call write ; invoke libc write
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _5_error_unwrapper
_5_error_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load s env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp _5_error
global _5_error_deep_release
_5_error_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _5_error_deepcopy
_5_error_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global error
error:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store msg arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_5_error_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_5_error_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_5_error_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _5_error closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rax, [rax] ; string data pointer for libc
    push rax ; stack arg
    lea rax, [rel _3] ; point to string literal
    mov rax, [rax] ; string data pointer for libc
    push rax ; stack arg
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 1040 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; keep sprintf buffer pointer
    lea r15, [rbx+1024] ; descriptor after sprintf buffer
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    mov rdx, rsi ; shift sprintf args for buffer insertion
    mov rsi, rdi ; shift sprintf args for buffer insertion
    mov rdi, rbx ; destination buffer for sprintf
    xor eax, eax ; no vector arguments for variadic sprintf
    push rbp ; helper prologue
    mov rbp, rsp
    push r12
    mov rax, rsp ; align stack for variadic sprintf call
    and rax, 15
    mov r12, rax
    sub rsp, r12
    call sprintf ; invoke libc sprintf
    add rsp, r12
    pop r12
    pop rbp
    mov [r15], rbx ; store formatted data pointer
    mov [r15+8], rax ; store formatted byte length
    mov rax, r15 ; return formatted string descriptor
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global error_unwrapper
error_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load msg env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp error
global error_deep_release
error_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global error_deepcopy
error_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _17_main
_17_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 0 ; operand literal
    call exit ; call libc exit to flush buffers
global _17_main_unwrapper
_17_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _17_main
global _17_main_deep_release
_17_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _17_main_deepcopy
_17_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _15_main
_15_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store contents arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 48 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_17_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_17_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_17_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _17_main closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    call write ; invoke libc write
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _15_main_unwrapper
_15_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load contents env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp _15_main
global _15_main_deep_release
_15_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _15_main_deepcopy
_15_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global main
main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel _12] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [error_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [error_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [error_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _13_error closure env_end to rax
    mov [rbp-8], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_15_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_15_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_15_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _15_main closure env_end to rax
    mov [rbp-16], rax ; store value
    lea rdi, [rel _11] ; point to string literal
    mov rdi, [rdi] ; path data for open
    mov rax, 2 ; open syscall
    xor rsi, rsi ; flags = O_RDONLY
    xor rdx, rdx ; mode unused
    syscall
    test rax, rax ; negative rax is -errno
    js main_readfile_err_4 ; open failed
    mov r13, rax ; keep file descriptor
    mov rdi, r13 ; fd
    mov rax, 8 ; lseek syscall
    xor rsi, rsi ; offset 0
    mov rdx, 2 ; SEEK_END
    syscall
    test rax, rax
    js main_readfile_err_close_3 ; size probe failed
    mov r14, rax ; keep file size
    mov rdi, r13 ; fd
    mov rax, 8 ; lseek syscall
    xor rsi, rsi ; offset 0
    xor rdx, rdx ; SEEK_SET
    syscall
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint
    lea rsi, [r14+17] ; length = size, terminator, and descriptor
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall
    test rax, rax
    js main_readfile_err_close_3 ; mmap failed
    mov r15, rax ; keep contents buffer
    lea r12, [r15+r14+1] ; string descriptor after contents terminator
    xor rbx, rbx ; bytes read so far
main_readfile_read_loop_0:
    cmp rbx, r14 ; all bytes read?
    jge main_readfile_read_done_1
    mov rdx, r14
    sub rdx, rbx ; remaining byte count
    lea rsi, [r15+rbx] ; buffer cursor
    mov rdi, r13 ; fd
    mov rax, 0 ; read syscall
    syscall
    test rax, rax
    js main_readfile_err_unmap_2 ; read failed
    jz main_readfile_read_done_1 ; end of file
    add rbx, rax ; advance cursor
    jmp main_readfile_read_loop_0
main_readfile_read_done_1:
    mov byte [r15+rbx], 0 ; terminate contents
    mov [r12], r15 ; store contents data pointer
    mov [r12+8], rbx ; store contents byte length
    mov rdi, r13 ; fd
    mov rax, 3 ; close syscall
    syscall
    mov rdi, [rbp-8] ; load _13_error closure env_end pointer
    call release_heap_ptr ; release _13_error closure environment
    mov rax, r12 ; contents descriptor result
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
main_readfile_err_unmap_2:
    mov rdi, r15 ; contents buffer
    lea rsi, [r14+17] ; mapped length
    mov rax, 11 ; munmap syscall
    syscall
main_readfile_err_close_3:
    mov rdi, r13 ; fd
    mov rax, 3 ; close syscall
    syscall
main_readfile_err_4:
    mov rdi, [rbp-16] ; load _15_main closure env_end pointer
    call release_heap_ptr ; release _15_main closure environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global main_unwrapper
main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp main
global main_deep_release
main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global main_deepcopy
main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _start
_start:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    leave ; unwind before named jump
    jmp main
extern exit
extern sprintf
extern write
section .rodata
_3:
    dq _3_data, 10 ; string data pointer and byte length
_3_data:
    db "Error: %s", 10, 0
_12:
    dq _12_data, 16 ; string data pointer and byte length
_12_data:
    db "cannot read file", 0
_11:
    dq _11_data, 32 ; string data pointer and byte length
_11_data:
    db "tests/golden/2-readfile/data.txt", 0
