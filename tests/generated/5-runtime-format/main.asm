bits 64
default rel
section .text
extern freestanding_format_f64_len
extern freestanding_format_f64_nth
global _418_main
_418_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 0 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
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
global _418_main_unwrapper
_418_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _418_main
global _418_main_deep_release
_418_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _418_main_deepcopy
_418_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global __rgo_7374642f666d74__single_nth
__rgo_7374642f666d74__single_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store idx arg in frame
    mov [rbp-24], rdx ; store empty_case arg in frame
    mov [rbp-32], rcx ; store one arg in frame
    mov rax, [rbp-32] ; load operand
    mov [rbp-40], rax ; store value
    mov r12, [rbp-40] ; load operand
    mov rcx, [rbp-8] ; load operand
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_uint__107_one_true_0_0
eq_uint_empty_case_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-24] ; load empty_case closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_uint__107_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _107_one closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__single_nth_unwrapper
__rgo_7374642f666d74__single_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load idx env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load empty_case env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load one env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__single_nth
global __rgo_7374642f666d74__single_nth_deep_release
__rgo_7374642f666d74__single_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__single_nth_release_skip_2
    mov rax, [r12-16] ; load __rgo_7374642f666d74__single_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__single_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__single_nth_release_skip_3
    mov rax, [r12-8] ; load __rgo_7374642f666d74__single_nth_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__single_nth_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global deepcopy_heap_ptr
deepcopy_heap_ptr:
    push rbp ; prologue: save executor frame pointer
    mov rbp, rsp ; prologue: establish new frame
    push rbx ; preserve callee-saved registers
    push r12
    push r13
    push r14
    push r15
    mov r12, rdi ; capture env_end pointer
    mov r14, [r12+24] ; load env size metadata
    mov r15, [r12+32] ; load heap size metadata
    mov rbx, r12 ; keep env_end pointer
    sub rbx, r14 ; compute env base pointer
    mov rdi, 0 ; addr hint so kernel picks mmap base
    mov rsi, r15 ; length = heap size
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags = private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    mov rax, 9 ; mmap syscall
    syscall ; allocate new closure env
    mov r13, rax ; new env base pointer
    mov rdi, r13 ; memcpy dest
    mov rsi, rbx ; memcpy src
    mov rdx, r15 ; memcpy length
    call memcpy_helper ; copy env contents
    mov rax, r13 ; compute new env_end pointer
    add rax, r14
    mov r15, rax ; preserve new env_end pointer
    mov rax, [r15+16] ; load deep copy helper entry
    mov rdi, r15 ; pass new env_end pointer
    call rax ; invoke helper
    mov rax, r15 ; return new env_end pointer
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    pop rbp
    ret
global memcpy_helper
memcpy_helper:
    push rbp ; prologue
    mov rbp, rsp
    xor rcx, rcx ; counter = 0
internal_memcpy_loop:
    cmp rcx, rdx ; counter < count?
    jge internal_memcpy_done
    mov rax, [rsi+rcx] ; load 8 bytes from source
    mov [rdi+rcx], rax ; store 8 bytes to destination
    add rcx, 8 ; advance counter by 8
    jmp internal_memcpy_loop
internal_memcpy_done:
    pop rbp
    ret
global __rgo_7374642f666d74__single_nth_deepcopy
__rgo_7374642f666d74__single_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__single_nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__single_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__single_nth_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__single_nth_deepcopy_skip_3:
    leave
    ret

global __rgo_7374642f666d74__single
__rgo_7374642f666d74__single:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _109___rgo_7374642f666d74__single_nth closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-16] ; load inspect_value closure env_end pointer
    mov rax, 1 ; operand literal
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__single_unwrapper
__rgo_7374642f666d74__single_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__single
global __rgo_7374642f666d74__single_deep_release
__rgo_7374642f666d74__single_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__single_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f666d74__single_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__single_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__single_deepcopy
__rgo_7374642f666d74__single_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__single_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__single_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f666d74__empty_nth
__rgo_7374642f666d74__empty_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _101___rgo_7374642f666d74__empty_nth arg in frame
    mov [rbp-16], rsi ; store empty arg in frame
    mov [rbp-24], rdx ; store _102___rgo_7374642f666d74__empty_nth arg in frame
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-16] ; load empty closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__empty_nth_unwrapper
__rgo_7374642f666d74__empty_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load _101___rgo_7374642f666d74__empty_nth env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load empty env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _102___rgo_7374642f666d74__empty_nth env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__empty_nth
global __rgo_7374642f666d74__empty_nth_deep_release
__rgo_7374642f666d74__empty_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__empty_nth_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__empty_nth_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__empty_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__empty_nth_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__empty_nth_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__empty_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__empty_nth_deepcopy
__rgo_7374642f666d74__empty_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__empty_nth_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__empty_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__empty_nth_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__empty_nth_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f666d74__empty
__rgo_7374642f666d74__empty:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__empty_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty_nth closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rbx, [rbp-8] ; load inspect_value closure env_end pointer
    mov rax, 0 ; operand literal
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-16] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__empty_unwrapper
__rgo_7374642f666d74__empty_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__empty
global __rgo_7374642f666d74__empty_deep_release
__rgo_7374642f666d74__empty_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__empty_release_skip_0
    mov rax, [r12-8] ; load __rgo_7374642f666d74__empty_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__empty_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__empty_deepcopy
__rgo_7374642f666d74__empty_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__empty_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__empty_deepcopy_skip_0:
    leave
    ret

global _120___rgo_7374642f666d74__concat_nth
_120___rgo_7374642f666d74__concat_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store empty_case arg in frame
    mov [rbp-24], rdx ; store one arg in frame
    mov [rbp-32], rcx ; store b_idx arg in frame
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-24], rax ; store env field
    mov rax, [rbp-16] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _120___rgo_7374642f666d74__concat_nth_unwrapper
_120___rgo_7374642f666d74__concat_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load b env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load empty_case env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load one env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load b_idx env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp _120___rgo_7374642f666d74__concat_nth
global _120___rgo_7374642f666d74__concat_nth_deep_release
_120___rgo_7374642f666d74__concat_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _120___rgo_7374642f666d74__concat_nth_release_skip_0
    mov rax, [r12-32] ; load _120___rgo_7374642f666d74__concat_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_120___rgo_7374642f666d74__concat_nth_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _120___rgo_7374642f666d74__concat_nth_release_skip_1
    mov rax, [r12-24] ; load _120___rgo_7374642f666d74__concat_nth_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_120___rgo_7374642f666d74__concat_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _120___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-16] ; load _120___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_120___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _120___rgo_7374642f666d74__concat_nth_deepcopy
_120___rgo_7374642f666d74__concat_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _120___rgo_7374642f666d74__concat_nth_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_120___rgo_7374642f666d74__concat_nth_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _120___rgo_7374642f666d74__concat_nth_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_120___rgo_7374642f666d74__concat_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _120___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_120___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    leave
    ret

global _118___rgo_7374642f666d74__concat_nth
_118___rgo_7374642f666d74__concat_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store idx arg in frame
    mov [rbp-16], rsi ; store l arg in frame
    mov [rbp-24], rdx ; store b arg in frame
    mov [rbp-32], rcx ; store empty_case arg in frame
    mov [rbp-40], r8 ; store one arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_120___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_120___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_120___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _121___rgo_7374642f666d74__concat_nth closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, [rbp-16] ; load operand
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _118___rgo_7374642f666d74__concat_nth_unwrapper
_118___rgo_7374642f666d74__concat_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load idx env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load l env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load b env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load empty_case env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load one env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _118___rgo_7374642f666d74__concat_nth
global _118___rgo_7374642f666d74__concat_nth_deep_release
_118___rgo_7374642f666d74__concat_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _118___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-24] ; load _118___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_118___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _118___rgo_7374642f666d74__concat_nth_release_skip_3
    mov rax, [r12-16] ; load _118___rgo_7374642f666d74__concat_nth_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_118___rgo_7374642f666d74__concat_nth_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _118___rgo_7374642f666d74__concat_nth_release_skip_4
    mov rax, [r12-8] ; load _118___rgo_7374642f666d74__concat_nth_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_118___rgo_7374642f666d74__concat_nth_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _118___rgo_7374642f666d74__concat_nth_deepcopy
_118___rgo_7374642f666d74__concat_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _118___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_118___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _118___rgo_7374642f666d74__concat_nth_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_118___rgo_7374642f666d74__concat_nth_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _118___rgo_7374642f666d74__concat_nth_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_118___rgo_7374642f666d74__concat_nth_deepcopy_skip_4:
    leave
    ret

global __rgo_7374642f666d74__concat_nth
__rgo_7374642f666d74__concat_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 80 ; reserve stack space for locals
    mov [rbp-8], rdi ; store l arg in frame
    mov [rbp-16], rsi ; store a arg in frame
    mov [rbp-24], rdx ; store b arg in frame
    mov [rbp-32], rcx ; store idx arg in frame
    mov [rbp-40], r8 ; store empty_case arg in frame
    mov [rbp-48], r9 ; store one arg in frame
    mov rax, [rbp-16] ; load operand
    mov [rbp-56], rax ; store value
    mov rbx, [rbp-40] ; original closure empty_case to ___116_a_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-64], rax ; store value
    mov rbx, [rbp-48] ; original closure one to ___116_a_arg_clone_2 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-72], rax ; store value
    mov r12, [rbp-56] ; load operand
    mov rcx, [rbp-32] ; load operand
    mov [r12-24], rcx ; store env field
    mov rcx, [rbp-64] ; load operand
    mov [r12-16], rcx ; store env field
    mov rcx, [rbp-72] ; load operand
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov rax, [rbp-48] ; load operand
    mov [rbx+32], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_118___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_118___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_118___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _122___rgo_7374642f666d74__concat_nth closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, [rbp-32] ; load operand
    mov rbx, [rbp-8] ; load operand
    cmp rax, rbx
    jb lt_uint__116_a_true_0_0
lt_uint__122___rgo_7374642f666d74__concat_nth_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-80] ; load _122___rgo_7374642f666d74__concat_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt_uint__116_a_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-80] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _116_a closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__concat_nth_unwrapper
__rgo_7374642f666d74__concat_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-48] ; load l env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-40] ; load a env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-32] ; load b env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-24] ; load idx env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-16] ; load empty_case env field
    mov [rbp-48], rax ; store value
    mov rax, [r12-8] ; load one env field
    mov [rbp-56], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-56] ; load operand
    push rax ; stack arg
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    pop r9 ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__concat_nth
global __rgo_7374642f666d74__concat_nth_deep_release
__rgo_7374642f666d74__concat_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_release_skip_1
    mov rax, [r12-40] ; load __rgo_7374642f666d74__concat_nth_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-32] ; load __rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_release_skip_4
    mov rax, [r12-16] ; load __rgo_7374642f666d74__concat_nth_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_nth_release_skip_4:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_release_skip_5
    mov rax, [r12-8] ; load __rgo_7374642f666d74__concat_nth_release_field_5 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_nth_release_skip_5:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__concat_nth_deepcopy
__rgo_7374642f666d74__concat_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__concat_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f666d74__concat_nth_deepcopy_skip_4:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_nth_deepcopy_skip_5
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
__rgo_7374642f666d74__concat_nth_deepcopy_skip_5:
    leave
    ret

global _128___rgo_7374642f666d74__concat
_128___rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store a_l arg in frame
    mov [rbp-24], rdx ; store a_nth arg in frame
    mov [rbp-32], rcx ; store b_nth arg in frame
    mov [rbp-40], r8 ; store l arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 96 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 48 ; move pointer past env payload
    mov rax, 48 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 96 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _129___rgo_7374642f666d74__concat_nth closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-8] ; load inspect_value closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-48] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _128___rgo_7374642f666d74__concat_unwrapper
_128___rgo_7374642f666d74__concat_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load inspect_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load a_l env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load a_nth env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load b_nth env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load l env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _128___rgo_7374642f666d74__concat
global _128___rgo_7374642f666d74__concat_deep_release
_128___rgo_7374642f666d74__concat_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _128___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-40] ; load _128___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_128___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _128___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _128___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_128___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _128___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-16] ; load _128___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_128___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _128___rgo_7374642f666d74__concat_deepcopy
_128___rgo_7374642f666d74__concat_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _128___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_128___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _128___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_128___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _128___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_128___rgo_7374642f666d74__concat_deepcopy_skip_3:
    leave
    ret

global _126___rgo_7374642f666d74__concat
_126___rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a_l arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov [rbp-24], rdx ; store a_nth arg in frame
    mov [rbp-32], rcx ; store b_l arg in frame
    mov [rbp-40], r8 ; store b_nth arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_128___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_128___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_128___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _130___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, [rbp-32] ; load operand
    add rax, rbx ; add second integer
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _126___rgo_7374642f666d74__concat_unwrapper
_126___rgo_7374642f666d74__concat_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load a_l env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load inspect_value env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load a_nth env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load b_l env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load b_nth env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _126___rgo_7374642f666d74__concat
global _126___rgo_7374642f666d74__concat_deep_release
_126___rgo_7374642f666d74__concat_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _126___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-32] ; load _126___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_126___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _126___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _126___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_126___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _126___rgo_7374642f666d74__concat_release_skip_4
    mov rax, [r12-8] ; load _126___rgo_7374642f666d74__concat_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_126___rgo_7374642f666d74__concat_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _126___rgo_7374642f666d74__concat_deepcopy
_126___rgo_7374642f666d74__concat_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _126___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_126___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _126___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_126___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _126___rgo_7374642f666d74__concat_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_126___rgo_7374642f666d74__concat_deepcopy_skip_4:
    leave
    ret

global _124___rgo_7374642f666d74__concat
_124___rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov [rbp-24], rdx ; store a_l arg in frame
    mov [rbp-32], rcx ; store a_nth arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_126___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_126___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_126___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _131___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _124___rgo_7374642f666d74__concat_unwrapper
_124___rgo_7374642f666d74__concat_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load b env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load inspect_value env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load a_l env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load a_nth env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp _124___rgo_7374642f666d74__concat
global _124___rgo_7374642f666d74__concat_deep_release
_124___rgo_7374642f666d74__concat_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _124___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-32] ; load _124___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_124___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _124___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-24] ; load _124___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_124___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _124___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-8] ; load _124___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_124___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _124___rgo_7374642f666d74__concat_deepcopy
_124___rgo_7374642f666d74__concat_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _124___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_124___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _124___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_124___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _124___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_124___rgo_7374642f666d74__concat_deepcopy_skip_3:
    leave
    ret

global __rgo_7374642f666d74__concat
__rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a arg in frame
    mov [rbp-16], rsi ; store b arg in frame
    mov [rbp-24], rdx ; store inspect_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_124___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_124___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_124___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _132___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load a closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__concat_unwrapper
__rgo_7374642f666d74__concat_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load b env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__concat
global __rgo_7374642f666d74__concat_deep_release
__rgo_7374642f666d74__concat_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-24] ; load __rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__concat_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__concat_deepcopy
__rgo_7374642f666d74__concat_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f666d74__concat_deepcopy_skip_2:
    leave
    ret

global release_descriptor_ptr
release_descriptor_ptr:
    mov rax, [rdi+16] ; load owned mapping base
    test rax, rax ; static descriptors have no owner
    jz release_descriptor_ptr_done
    mov rsi, [rdi+24] ; mapping size
    mov rdi, rax ; mapping base
    mov rax, 11 ; munmap syscall
    syscall
release_descriptor_ptr_done:
    ret
global __rgo_7374642f666d74__raw_nth
__rgo_7374642f666d74__raw_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store idx arg in frame
    mov [rbp-24], rdx ; store empty_case arg in frame
    mov [rbp-32], rcx ; store one arg in frame
    mov rbx, [rbp-8] ; load operand
    mov rcx, [rbp-16] ; load operand
    cmp rcx, [rbx+8]
    jae __rgo_7374642f666d74__raw_nth_bytes_nth_empty_0
    mov rdx, [rbx]
    movzx eax, byte [rdx+rcx]
    push rax
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    pop rax
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
__rgo_7374642f666d74__raw_nth_bytes_nth_empty_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__raw_nth_unwrapper
__rgo_7374642f666d74__raw_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load idx env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load empty_case env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load one env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__raw_nth
global __rgo_7374642f666d74__raw_nth_deep_release
__rgo_7374642f666d74__raw_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__raw_nth_release_skip_0
    mov rax, [r12-32] ; load __rgo_7374642f666d74__raw_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
__rgo_7374642f666d74__raw_nth_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__raw_nth_release_skip_2
    mov rax, [r12-16] ; load __rgo_7374642f666d74__raw_nth_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__raw_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__raw_nth_release_skip_3
    mov rax, [r12-8] ; load __rgo_7374642f666d74__raw_nth_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__raw_nth_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global clone_descriptor_ptr
clone_descriptor_ptr:
    push rbx ; preserve callee-saved registers
    push r12
    push r13
    mov r12, rdi ; source descriptor
    cmp qword [r12+16], 0 ; static descriptor?
    je clone_descriptor_ptr_static
    mov r13, [r12+8] ; byte length
    mov rsi, r13 ; data and terminator size
    add rsi, 33 ; include descriptor
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    mov rbx, rax ; cloned mapping base
    xor rcx, rcx ; byte offset
clone_descriptor_ptr_copy:
    cmp rcx, r13
    ja clone_descriptor_ptr_copied
    mov rdi, [r12] ; source data
    mov dl, [rdi+rcx]
    mov [rbx+rcx], dl
    inc rcx
    jmp clone_descriptor_ptr_copy
clone_descriptor_ptr_copied:
    lea rax, [rbx+r13+1] ; cloned descriptor
    mov [rax], rbx ; cloned data
    mov [rax+8], r13 ; cloned byte length
    mov [rax+16], rbx ; owned mapping base
    mov rdx, r13
    add rdx, 33
    mov [rax+24], rdx ; owned mapping size
    jmp clone_descriptor_ptr_done
clone_descriptor_ptr_static:
    mov rax, r12 ; static descriptors are immutable
clone_descriptor_ptr_done:
    pop r13
    pop r12
    pop rbx
    ret
global __rgo_7374642f666d74__raw_nth_deepcopy
__rgo_7374642f666d74__raw_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__raw_nth_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__raw_nth_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__raw_nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__raw_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__raw_nth_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f666d74__raw_nth_deepcopy_skip_3:
    leave
    ret

global _112___rgo_7374642f666d74__from_raw
_112___rgo_7374642f666d74__from_raw:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov [rbp-24], rdx ; store l arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__raw_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__raw_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__raw_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _113___rgo_7374642f666d74__raw_nth closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load inspect_value closure env_end pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _112___rgo_7374642f666d74__from_raw_unwrapper
_112___rgo_7374642f666d74__from_raw_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load inspect_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load value env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load l env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _112___rgo_7374642f666d74__from_raw
global _112___rgo_7374642f666d74__from_raw_deep_release
_112___rgo_7374642f666d74__from_raw_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _112___rgo_7374642f666d74__from_raw_release_skip_0
    mov rax, [r12-24] ; load _112___rgo_7374642f666d74__from_raw_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_112___rgo_7374642f666d74__from_raw_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _112___rgo_7374642f666d74__from_raw_release_skip_1
    mov rax, [r12-16] ; load _112___rgo_7374642f666d74__from_raw_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_112___rgo_7374642f666d74__from_raw_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _112___rgo_7374642f666d74__from_raw_deepcopy
_112___rgo_7374642f666d74__from_raw_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _112___rgo_7374642f666d74__from_raw_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_112___rgo_7374642f666d74__from_raw_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _112___rgo_7374642f666d74__from_raw_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_112___rgo_7374642f666d74__from_raw_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f666d74__from_raw
__rgo_7374642f666d74__from_raw:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov rdi, [rbp-8] ; load operand
    call clone_descriptor_ptr ; clone owned descriptor
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_112___rgo_7374642f666d74__from_raw_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_112___rgo_7374642f666d74__from_raw_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_112___rgo_7374642f666d74__from_raw_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _114___rgo_7374642f666d74__from_raw closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load operand
    mov rax, [rbx+8]
    push rax ; preserve byte length
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    pop rax ; restore byte length
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__from_raw_unwrapper
__rgo_7374642f666d74__from_raw_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__from_raw
global __rgo_7374642f666d74__from_raw_deep_release
__rgo_7374642f666d74__from_raw_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_raw_release_skip_0
    mov rax, [r12-16] ; load __rgo_7374642f666d74__from_raw_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
__rgo_7374642f666d74__from_raw_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_raw_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f666d74__from_raw_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__from_raw_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__from_raw_deepcopy
__rgo_7374642f666d74__from_raw_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_raw_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__from_raw_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_raw_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__from_raw_deepcopy_skip_1:
    leave
    ret

global _134___rgo_7374642f666d74__str_source
_134___rgo_7374642f666d74__str_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store value_bytes arg in frame
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__from_raw
global _134___rgo_7374642f666d74__str_source_unwrapper
_134___rgo_7374642f666d74__str_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load inspect_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load value_bytes env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _134___rgo_7374642f666d74__str_source
global _134___rgo_7374642f666d74__str_source_deep_release
_134___rgo_7374642f666d74__str_source_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _134___rgo_7374642f666d74__str_source_release_skip_0
    mov rax, [r12-16] ; load _134___rgo_7374642f666d74__str_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_134___rgo_7374642f666d74__str_source_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _134___rgo_7374642f666d74__str_source_release_skip_1
    mov rax, [r12-8] ; load _134___rgo_7374642f666d74__str_source_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_134___rgo_7374642f666d74__str_source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _134___rgo_7374642f666d74__str_source_deepcopy
_134___rgo_7374642f666d74__str_source_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _134___rgo_7374642f666d74__str_source_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_134___rgo_7374642f666d74__str_source_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _134___rgo_7374642f666d74__str_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_134___rgo_7374642f666d74__str_source_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f666d74__str_source
__rgo_7374642f666d74__str_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_134___rgo_7374642f666d74__str_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_134___rgo_7374642f666d74__str_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_134___rgo_7374642f666d74__str_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _135___rgo_7374642f666d74__str_source closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__str_source_unwrapper
__rgo_7374642f666d74__str_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__str_source
global __rgo_7374642f666d74__str_source_deep_release
__rgo_7374642f666d74__str_source_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__str_source_release_skip_0
    mov rax, [r12-16] ; load __rgo_7374642f666d74__str_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
__rgo_7374642f666d74__str_source_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__str_source_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f666d74__str_source_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__str_source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__str_source_deepcopy
__rgo_7374642f666d74__str_source_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__str_source_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__str_source_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__str_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__str_source_deepcopy_skip_1:
    leave
    ret

global _367_test_executable_output
_367_test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store output arg in frame
    mov [rbp-16], rsi ; store _353_test_executable_output arg in frame
    mov [rbp-24], rdx ; store _354_test_executable_output arg in frame
    mov [rbp-32], rcx ; store _355_test_executable_output arg in frame
    mov rbx, [rbp-8] ; load operand
    mov r9, [rbp-16] ; load operand
    mov rsi, [rbx]
    mov rcx, [rbx+8]
    xor rdx, rdx
    xor r8, r8
_367_test_executable_output_str_rune_nth_loop_0:
    cmp rdx, rcx
    jae _367_test_executable_output_str_rune_nth_empty_7
    movzx eax, byte [rsi+rdx]
    mov r10d, eax
    and r10d, 0xc0
    cmp r10d, 0x80
    je _367_test_executable_output_str_rune_nth_continuation_1
    cmp r8, r9
    je _367_test_executable_output_str_rune_nth_found_2
    inc r8
_367_test_executable_output_str_rune_nth_continuation_1:
    inc rdx
    jmp _367_test_executable_output_str_rune_nth_loop_0
_367_test_executable_output_str_rune_nth_found_2:
    movzx eax, byte [rsi+rdx]
    cmp eax, 0x80
    jb _367_test_executable_output_str_rune_nth_decoded_6
    cmp eax, 0xe0
    jb _367_test_executable_output_str_rune_nth_width_two_3
    cmp eax, 0xf0
    jb _367_test_executable_output_str_rune_nth_width_three_4
    jmp _367_test_executable_output_str_rune_nth_width_four_5
_367_test_executable_output_str_rune_nth_width_two_3:
    and eax, 0x1f
    shl eax, 6
    movzx r10d, byte [rsi+rdx+1]
    and r10d, 0x3f
    or eax, r10d
    jmp _367_test_executable_output_str_rune_nth_decoded_6
_367_test_executable_output_str_rune_nth_width_three_4:
    and eax, 0x0f
    shl eax, 12
    movzx r10d, byte [rsi+rdx+1]
    and r10d, 0x3f
    shl r10d, 6
    or eax, r10d
    movzx r10d, byte [rsi+rdx+2]
    and r10d, 0x3f
    or eax, r10d
    jmp _367_test_executable_output_str_rune_nth_decoded_6
_367_test_executable_output_str_rune_nth_width_four_5:
    and eax, 0x07
    shl eax, 18
    movzx r10d, byte [rsi+rdx+1]
    and r10d, 0x3f
    shl r10d, 12
    or eax, r10d
    movzx r10d, byte [rsi+rdx+2]
    and r10d, 0x3f
    shl r10d, 6
    or eax, r10d
    movzx r10d, byte [rsi+rdx+3]
    and r10d, 0x3f
    or eax, r10d
_367_test_executable_output_str_rune_nth_decoded_6:
    push rax
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    pop rax
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
_367_test_executable_output_str_rune_nth_empty_7:
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _367_test_executable_output_unwrapper
_367_test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load output env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load _353_test_executable_output env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load _354_test_executable_output env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load _355_test_executable_output env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp _367_test_executable_output
global _367_test_executable_output_deep_release
_367_test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _367_test_executable_output_release_skip_0
    mov rax, [r12-32] ; load _367_test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_367_test_executable_output_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _367_test_executable_output_release_skip_2
    mov rax, [r12-16] ; load _367_test_executable_output_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_367_test_executable_output_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _367_test_executable_output_release_skip_3
    mov rax, [r12-8] ; load _367_test_executable_output_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_367_test_executable_output_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _367_test_executable_output_deepcopy
_367_test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _367_test_executable_output_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_367_test_executable_output_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _367_test_executable_output_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_367_test_executable_output_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _367_test_executable_output_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_367_test_executable_output_deepcopy_skip_3:
    leave
    ret

global _363_test_executable_output
_363_test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store output arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    mov rax, 1 ; write syscall
    syscall
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _363_test_executable_output_unwrapper
_363_test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load output env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _363_test_executable_output
global _363_test_executable_output_deep_release
_363_test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _363_test_executable_output_release_skip_0
    mov rax, [r12-16] ; load _363_test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_363_test_executable_output_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _363_test_executable_output_release_skip_1
    mov rax, [r12-8] ; load _363_test_executable_output_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_363_test_executable_output_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _363_test_executable_output_deepcopy
_363_test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _363_test_executable_output_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_363_test_executable_output_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _363_test_executable_output_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_363_test_executable_output_deepcopy_skip_1:
    leave
    ret

global unexpected_rune
unexpected_rune:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _342_unexpected_rune arg in frame
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global unexpected_rune_unwrapper
unexpected_rune_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load _342_unexpected_rune env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp unexpected_rune
global unexpected_rune_deep_release
unexpected_rune_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global unexpected_rune_deepcopy
unexpected_rune_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _360_test_executable_output
_360_test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store nth arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_363_test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_363_test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_363_test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _364_test_executable_output closure env_end to rax
    mov [rbp-32], rax ; store value
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
    lea rax, [unexpected_rune_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [unexpected_rune_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [unexpected_rune_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy unexpected_rune closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-8] ; load nth closure env_end pointer
    mov rax, 4 ; operand literal
    mov [rbx-24], rax ; store env field
    mov rax, [rbp-32] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _360_test_executable_output_unwrapper
_360_test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load nth env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load output env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _360_test_executable_output
global _360_test_executable_output_deep_release
_360_test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _360_test_executable_output_release_skip_0
    mov rax, [r12-24] ; load _360_test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_360_test_executable_output_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _360_test_executable_output_release_skip_1
    mov rax, [r12-16] ; load _360_test_executable_output_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_360_test_executable_output_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _360_test_executable_output_release_skip_2
    mov rax, [r12-8] ; load _360_test_executable_output_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_360_test_executable_output_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _360_test_executable_output_deepcopy
_360_test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _360_test_executable_output_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_360_test_executable_output_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _360_test_executable_output_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_360_test_executable_output_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _360_test_executable_output_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_360_test_executable_output_deepcopy_skip_2:
    leave
    ret

global invalid
invalid:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global invalid_unwrapper
invalid_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp invalid
global invalid_deep_release
invalid_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global invalid_deepcopy
invalid_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _357_test_executable_output
_357_test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store output arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store l arg in frame
    mov [rbp-32], rcx ; store nth arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_360_test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_360_test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_360_test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _365_test_executable_output closure env_end to rax
    mov [rbp-40], rax ; store value
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-24] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    je eq_uint__365_test_executable_output_true_0_0
eq_uint_invalid_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load invalid closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_uint__365_test_executable_output_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _365_test_executable_output closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _357_test_executable_output_unwrapper
_357_test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load output env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load l env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load nth env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp _357_test_executable_output
global _357_test_executable_output_deep_release
_357_test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _357_test_executable_output_release_skip_0
    mov rax, [r12-32] ; load _357_test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_357_test_executable_output_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _357_test_executable_output_release_skip_1
    mov rax, [r12-24] ; load _357_test_executable_output_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_357_test_executable_output_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _357_test_executable_output_release_skip_3
    mov rax, [r12-8] ; load _357_test_executable_output_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_357_test_executable_output_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _357_test_executable_output_deepcopy
_357_test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _357_test_executable_output_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_357_test_executable_output_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _357_test_executable_output_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_357_test_executable_output_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _357_test_executable_output_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_357_test_executable_output_deepcopy_skip_3:
    leave
    ret

global _351_test_executable_output
_351_test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store output arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store _349_str_rune_len arg in frame
    mov rdi, [rbp-8] ; load operand
    call clone_descriptor_ptr ; clone owned descriptor
    mov [rbp-32], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_367_test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_367_test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_367_test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _368_test_executable_output closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; capture arg into env
    mov rax, [rbp-40] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_357_test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_357_test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_357_test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _369_test_executable_output closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-48] ; load _369_test_executable_output closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _351_test_executable_output_unwrapper
_351_test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load output env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _349_str_rune_len env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _351_test_executable_output
global _351_test_executable_output_deep_release
_351_test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _351_test_executable_output_release_skip_0
    mov rax, [r12-24] ; load _351_test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_351_test_executable_output_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _351_test_executable_output_release_skip_1
    mov rax, [r12-16] ; load _351_test_executable_output_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_351_test_executable_output_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _351_test_executable_output_deepcopy
_351_test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _351_test_executable_output_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_351_test_executable_output_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _351_test_executable_output_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_351_test_executable_output_deepcopy_skip_1:
    leave
    ret

global _348_test_executable_output
_348_test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov rdi, [rbp-16] ; load operand
    call clone_descriptor_ptr ; clone owned descriptor
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_351_test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_351_test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_351_test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _370_test_executable_output closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-16] ; load operand
    mov rsi, [rbx]
    mov rcx, [rbx+8]
    xor rdx, rdx
    xor rax, rax
_348_test_executable_output_str_rune_len_loop_0:
    cmp rdx, rcx
    jae _348_test_executable_output_str_rune_len_done_2
    movzx r8d, byte [rsi+rdx]
    and r8d, 0xc0
    cmp r8d, 0x80
    je _348_test_executable_output_str_rune_len_next_1
    inc rax
_348_test_executable_output_str_rune_len_next_1:
    inc rdx
    jmp _348_test_executable_output_str_rune_len_loop_0
_348_test_executable_output_str_rune_len_done_2:
    push rax ; preserve rune length
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    pop rax ; restore rune length
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _348_test_executable_output_unwrapper
_348_test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load output env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _348_test_executable_output
global _348_test_executable_output_deep_release
_348_test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _348_test_executable_output_release_skip_0
    mov rax, [r12-16] ; load _348_test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_348_test_executable_output_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _348_test_executable_output_release_skip_1
    mov rax, [r12-8] ; load _348_test_executable_output_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_348_test_executable_output_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _348_test_executable_output_deepcopy
_348_test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _348_test_executable_output_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_348_test_executable_output_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _348_test_executable_output_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_348_test_executable_output_deepcopy_skip_1:
    leave
    ret

global utf8_validate
utf8_validate:
    xor rdx, rdx
internal_utf8_loop:
    cmp rdx, rsi
    jae internal_utf8_valid
    movzx eax, byte [rdi+rdx]
    cmp eax, 0x80
    jb internal_utf8_ascii
    cmp eax, 0xc2
    jb internal_utf8_invalid
    cmp eax, 0xe0
    jb internal_utf8_two
    cmp eax, 0xf0
    jb internal_utf8_three
    cmp eax, 0xf5
    jb internal_utf8_four
    jmp internal_utf8_invalid
internal_utf8_ascii:
    inc rdx
    jmp internal_utf8_loop
internal_utf8_two:
    lea r8, [rdx+2]
    cmp r8, rsi
    ja internal_utf8_invalid
    movzx ecx, byte [rdi+rdx+1]
    and ecx, 0xc0
    cmp ecx, 0x80
    jne internal_utf8_invalid
    add rdx, 2
    jmp internal_utf8_loop
internal_utf8_three:
    lea r8, [rdx+3]
    cmp r8, rsi
    ja internal_utf8_invalid
    movzx ecx, byte [rdi+rdx+1]
    cmp eax, 0xe0
    jne internal_utf8_three_not_e0
    cmp ecx, 0xa0
    jb internal_utf8_invalid
    cmp ecx, 0xbf
    ja internal_utf8_invalid
    jmp internal_utf8_three_tail
internal_utf8_three_not_e0:
    cmp eax, 0xed
    jne internal_utf8_three_middle
    cmp ecx, 0x80
    jb internal_utf8_invalid
    cmp ecx, 0x9f
    ja internal_utf8_invalid
    jmp internal_utf8_three_tail
internal_utf8_three_middle:
    cmp ecx, 0x80
    jb internal_utf8_invalid
    cmp ecx, 0xbf
    ja internal_utf8_invalid
internal_utf8_three_tail:
    movzx ecx, byte [rdi+rdx+2]
    and ecx, 0xc0
    cmp ecx, 0x80
    jne internal_utf8_invalid
    add rdx, 3
    jmp internal_utf8_loop
internal_utf8_four:
    lea r8, [rdx+4]
    cmp r8, rsi
    ja internal_utf8_invalid
    movzx ecx, byte [rdi+rdx+1]
    cmp eax, 0xf0
    jne internal_utf8_four_not_f0
    cmp ecx, 0x90
    jb internal_utf8_invalid
    cmp ecx, 0xbf
    ja internal_utf8_invalid
    jmp internal_utf8_four_tail
internal_utf8_four_not_f0:
    cmp eax, 0xf4
    jne internal_utf8_four_middle
    cmp ecx, 0x80
    jb internal_utf8_invalid
    cmp ecx, 0x8f
    ja internal_utf8_invalid
    jmp internal_utf8_four_tail
internal_utf8_four_middle:
    cmp ecx, 0x80
    jb internal_utf8_invalid
    cmp ecx, 0xbf
    ja internal_utf8_invalid
internal_utf8_four_tail:
    movzx ecx, byte [rdi+rdx+2]
    and ecx, 0xc0
    cmp ecx, 0x80
    jne internal_utf8_invalid
    movzx ecx, byte [rdi+rdx+3]
    and ecx, 0xc0
    cmp ecx, 0x80
    jne internal_utf8_invalid
    add rdx, 4
    jmp internal_utf8_loop
internal_utf8_valid:
    mov eax, 1
    ret
internal_utf8_invalid:
    xor eax, eax
    ret
global _167___rgo_7374642f666d74__finish
_167___rgo_7374642f666d74__finish:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store value arg in frame
    mov rbx, [rbp-24] ; load operand
    mov rdi, [rbx]
    mov rsi, [rbx+8]
    call utf8_validate
    test eax, eax
    jz _167___rgo_7374642f666d74__finish_str_from_utf8_invalid_0
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, [rbp-24] ; load operand
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
_167___rgo_7374642f666d74__finish_str_from_utf8_invalid_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _167___rgo_7374642f666d74__finish_unwrapper
_167___rgo_7374642f666d74__finish_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load invalid env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _167___rgo_7374642f666d74__finish
global _167___rgo_7374642f666d74__finish_deep_release
_167___rgo_7374642f666d74__finish_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _167___rgo_7374642f666d74__finish_release_skip_0
    mov rax, [r12-24] ; load _167___rgo_7374642f666d74__finish_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_167___rgo_7374642f666d74__finish_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _167___rgo_7374642f666d74__finish_release_skip_1
    mov rax, [r12-16] ; load _167___rgo_7374642f666d74__finish_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_167___rgo_7374642f666d74__finish_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _167___rgo_7374642f666d74__finish_release_skip_2
    mov rax, [r12-8] ; load _167___rgo_7374642f666d74__finish_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_167___rgo_7374642f666d74__finish_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _167___rgo_7374642f666d74__finish_deepcopy
_167___rgo_7374642f666d74__finish_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _167___rgo_7374642f666d74__finish_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_167___rgo_7374642f666d74__finish_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _167___rgo_7374642f666d74__finish_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_167___rgo_7374642f666d74__finish_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _167___rgo_7374642f666d74__finish_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_167___rgo_7374642f666d74__finish_deepcopy_skip_2:
    leave
    ret

global bytes_build_inspector_unwrapper
bytes_build_inspector_unwrapper:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rdi
    mov rax, [rdi-32]
    mov [rbp-16], rax
    mov rax, [rdi-24]
    mov [rbp-24], rax
    mov rax, [rdi-16]
    mov [rbp-32], rax
    mov rax, [rdi-8]
    mov [rbp-40], rax
    call release_heap_ptr
    mov rsi, [rbp-32]
    add rsi, 33
    jc bytes_build_inspector_invalid
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax
    js bytes_build_inspector_invalid
    mov [rbp-48], rax
    cmp qword [rbp-32], 0
    je bytes_build_inspector_empty
    mov rdi, [rbp-16]
    mov rsi, [rbp-24]
    mov rdx, [rbp-40]
    mov rcx, [rbp-48]
    mov r8, [rbp-32]
    xor r9, r9
    leave
    jmp bytes_build_step
bytes_build_inspector_empty:
    mov rbx, [rbp-48]
    mov byte [rbx], 0
    lea rax, [rbx+1]
    mov [rax], rbx
    mov qword [rax+8], 0
    mov [rax+16], rbx
    mov qword [rax+24], 33
    mov [rbp-56], rax
    mov rdi, [rbp-16]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-40]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-24]
    mov rax, [rbp-56]
    mov [rbx-8], rax
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
bytes_build_inspector_invalid:
    mov rdi, [rbp-24]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-40]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-16]
    mov qword [rdi+40], 0
    mov rax, [rdi]
    leave
    jmp rax
global bytes_build_empty_unwrapper
bytes_build_empty_unwrapper:
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov [rbp-8], rdi
    mov rax, [rdi-48]
    mov [rbp-16], rax
    mov rax, [rdi-40]
    mov [rbp-24], rax
    mov rax, [rdi-32]
    mov [rbp-32], rax
    mov rax, [rdi-24]
    mov [rbp-40], rax
    mov rax, [rdi-16]
    mov [rbp-48], rax
    call release_heap_ptr
    mov rdi, [rbp-40]
    mov rsi, [rbp-48]
    add rsi, 33
    mov rax, 11
    syscall
    mov rdi, [rbp-24]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-32]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-16]
    mov qword [rdi+40], 0
    mov rax, [rdi]
    leave
    jmp rax
global bytes_build_one_unwrapper
bytes_build_one_unwrapper:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], rdi
    mov rax, [rdi-56]
    mov [rbp-16], rax
    mov rax, [rdi-48]
    mov [rbp-24], rax
    mov rax, [rdi-40]
    mov [rbp-32], rax
    mov rax, [rdi-32]
    mov [rbp-40], rax
    mov rax, [rdi-24]
    mov [rbp-48], rax
    mov rax, [rdi-16]
    mov [rbp-56], rax
    mov rax, [rdi-8]
    mov [rbp-64], rax
    call release_heap_ptr
    mov rbx, [rbp-40]
    mov rcx, [rbp-56]
    mov rax, [rbp-64]
    mov [rbx+rcx], al
    inc rcx
    cmp rcx, [rbp-48]
    je bytes_build_one_done
    mov rdi, [rbp-16]
    mov rsi, [rbp-24]
    mov rdx, [rbp-32]
    mov r8, [rbp-48]
    mov r9, rcx
    mov rcx, rbx
    leave
    jmp bytes_build_step
bytes_build_one_done:
    mov byte [rbx+rcx], 0
    lea rax, [rbx+rcx+1]
    mov [rax], rbx
    mov [rax+8], rcx
    mov [rax+16], rbx
    mov rdx, rcx
    add rdx, 33
    mov [rax+24], rdx
    mov [rbp-72], rax
    mov rdi, [rbp-16]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-32]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-24]
    mov rax, [rbp-72]
    mov [rbx-8], rax
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
global bytes_build_step
bytes_build_step:
    push rbp
    mov rbp, rsp
    sub rsp, 80
    mov [rbp-8], rdi
    mov [rbp-16], rsi
    mov [rbp-24], rdx
    mov [rbp-32], rcx
    mov [rbp-40], r8
    mov [rbp-48], r9
    mov rsi, 96
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax
    js bytes_build_step_invalid
    mov [rbp-56], rax
    mov rdi, [rbp-8]
    call deepcopy_heap_ptr
    mov rbx, [rbp-56]
    mov [rbx+0], rax
    mov rdi, [rbp-16]
    call deepcopy_heap_ptr
    mov rbx, [rbp-56]
    mov [rbx+8], rax
    mov rdi, [rbp-24]
    call deepcopy_heap_ptr
    mov rbx, [rbp-56]
    mov [rbx+16], rax
    mov rbx, [rbp-56]
    mov rax, [rbp-32]
    mov [rbx+24], rax
    mov rax, [rbp-40]
    mov [rbx+32], rax
    mov rax, [rbp-48]
    mov [rbx+40], rax
    lea r12, [rbx+48]
    lea rax, [bytes_build_empty_unwrapper]
    mov [r12+0], rax
    lea rax, [bytes_build_empty_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_empty_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 48
    mov qword [r12+32], 96
    mov qword [r12+40], 0
    mov [rbp-56], r12
    mov rsi, 104
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax
    js bytes_build_step_one_invalid
    mov rbx, rax
    mov rax, [rbp-8]
    mov [rbx+0], rax
    mov rax, [rbp-16]
    mov [rbx+8], rax
    mov rax, [rbp-24]
    mov [rbx+16], rax
    mov rax, [rbp-32]
    mov [rbx+24], rax
    mov rax, [rbp-40]
    mov [rbx+32], rax
    mov rax, [rbp-48]
    mov [rbx+40], rax
    lea r12, [rbx+56]
    lea rax, [bytes_build_one_unwrapper]
    mov [r12+0], rax
    lea rax, [bytes_build_one_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_one_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 56
    mov qword [r12+32], 104
    mov qword [r12+40], 1
    mov [rbp-64], r12
    mov rdi, [rbp-24]
    call deepcopy_heap_ptr
    mov rbx, rax
    mov rax, [rbp-48]
    mov [rbx-24], rax
    mov rax, [rbp-56]
    mov [rbx-16], rax
    mov rax, [rbp-64]
    mov [rbx-8], rax
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
bytes_build_step_one_invalid:
    mov rdi, [rbp-56]
    mov rax, [rdi+8]
    call rax
bytes_build_step_invalid:
    mov rdi, [rbp-32]
    mov rsi, [rbp-40]
    add rsi, 33
    mov rax, 11
    syscall
    mov rdi, [rbp-16]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-24]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-8]
    mov qword [rdi+40], 0
    mov rax, [rdi]
    leave
    jmp rax
global bytes_build_inspector_deep_release
bytes_build_inspector_deep_release:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdi
    mov rax, [rdi+40]
    mov [rbp-16], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-32]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-24]
    mov rax, [rdi+8]
    call rax
    cmp qword [rbp-16], 0
    ja bytes_build_inspector_deep_release_skip_2
    mov rbx, [rbp-8]
    mov rdi, [rbx-8]
    mov rax, [rdi+8]
    call rax
bytes_build_inspector_deep_release_skip_2:
    mov rdi, [rbp-8]
    call release_heap_ptr
    leave
    ret
global bytes_build_inspector_deepcopy
bytes_build_inspector_deepcopy:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdi
    mov rax, [rdi+40]
    mov [rbp-16], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-32]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-32], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-24]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-24], rax
    cmp qword [rbp-16], 0
    ja bytes_build_inspector_deepcopy_skip_2
    mov rbx, [rbp-8]
    mov rdi, [rbx-8]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-8], rax
bytes_build_inspector_deepcopy_skip_2:
    leave
    ret
global bytes_build_empty_deep_release
bytes_build_empty_deep_release:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdi
    mov rax, [rdi+40]
    mov [rbp-16], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-48]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-40]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-32]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-8]
    call release_heap_ptr
    leave
    ret
global bytes_build_empty_deepcopy
bytes_build_empty_deepcopy:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdi
    mov rax, [rdi+40]
    mov [rbp-16], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-48]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-48], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-40]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-40], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-32]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-32], rax
    leave
    ret
global bytes_build_one_deep_release
bytes_build_one_deep_release:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdi
    mov rax, [rdi+40]
    mov [rbp-16], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-56]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-48]
    mov rax, [rdi+8]
    call rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-40]
    mov rax, [rdi+8]
    call rax
    mov rdi, [rbp-8]
    call release_heap_ptr
    leave
    ret
global bytes_build_one_deepcopy
bytes_build_one_deepcopy:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp-8], rdi
    mov rax, [rdi+40]
    mov [rbp-16], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-56]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-56], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-48]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-48], rax
    mov rbx, [rbp-8]
    mov rdi, [rbx-40]
    call deepcopy_heap_ptr
    mov rbx, [rbp-8]
    mov [rbx-40], rax
    leave
    ret
global test_executable_output
test_executable_output:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 112 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 65 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_108 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_109 closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel __comptime_110] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__str_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__str_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__str_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_111 closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_112 closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 33 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_114 closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-56] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_115 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 10 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_117 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_118 closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_348_test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_348_test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_348_test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_119 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rbx, [rbp-96] ; original closure invalid to ____comptime_120_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-104] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_167___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_120 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js test_executable_output_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-96] ; load operand
    mov [rbx], rax
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax
    lea r12, [rbx+32]
    lea rax, [bytes_build_inspector_unwrapper]
    mov [r12], rax
    lea rax, [bytes_build_inspector_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_inspector_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 32
    mov qword [r12+32], 80
    mov qword [r12+40], 2
    mov rbx, [rbp-80] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
test_executable_output_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-112] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-80] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-96] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global test_executable_output_unwrapper
test_executable_output_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_executable_output
global test_executable_output_deep_release
test_executable_output_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_executable_output_release_skip_0
    mov rax, [r12-8] ; load test_executable_output_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_executable_output_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_executable_output_deepcopy
test_executable_output_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_executable_output_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_executable_output_deepcopy_skip_0:
    leave
    ret

global _143___rgo_7374642f666d74__f64_nth
_143___rgo_7374642f666d74__f64_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store one arg in frame
    mov [rbp-16], rsi ; store byte arg in frame
    mov rbx, [rbp-8] ; load one closure env_end pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _143___rgo_7374642f666d74__f64_nth_unwrapper
_143___rgo_7374642f666d74__f64_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load one env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load byte env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _143___rgo_7374642f666d74__f64_nth
global _143___rgo_7374642f666d74__f64_nth_deep_release
_143___rgo_7374642f666d74__f64_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _143___rgo_7374642f666d74__f64_nth_release_skip_0
    mov rax, [r12-16] ; load _143___rgo_7374642f666d74__f64_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_143___rgo_7374642f666d74__f64_nth_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _143___rgo_7374642f666d74__f64_nth_deepcopy
_143___rgo_7374642f666d74__f64_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _143___rgo_7374642f666d74__f64_nth_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_143___rgo_7374642f666d74__f64_nth_deepcopy_skip_0:
    leave
    ret

global _141___rgo_7374642f666d74__f64_nth
_141___rgo_7374642f666d74__f64_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store idx arg in frame
    mov [rbp-24], rdx ; store one arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_143___rgo_7374642f666d74__f64_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_143___rgo_7374642f666d74__f64_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_143___rgo_7374642f666d74__f64_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _144___rgo_7374642f666d74__f64_nth closure env_end to rax
    mov [rbp-32], rax ; store value
    movsd xmm0, [rbp-8] ; load float operand
    mov rdi, [rbp-16] ; load operand
    sub rsp, 8 ; align stack for native call
    call freestanding_format_f64_nth
    add rsp, 8 ; restore stack after native call
    movzx eax, al ; normalize u8 result
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _141___rgo_7374642f666d74__f64_nth_unwrapper
_141___rgo_7374642f666d74__f64_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load idx env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load one env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _141___rgo_7374642f666d74__f64_nth
global _141___rgo_7374642f666d74__f64_nth_deep_release
_141___rgo_7374642f666d74__f64_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _141___rgo_7374642f666d74__f64_nth_release_skip_2
    mov rax, [r12-8] ; load _141___rgo_7374642f666d74__f64_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_141___rgo_7374642f666d74__f64_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _141___rgo_7374642f666d74__f64_nth_deepcopy
_141___rgo_7374642f666d74__f64_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _141___rgo_7374642f666d74__f64_nth_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_141___rgo_7374642f666d74__f64_nth_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f666d74__f64_nth
__rgo_7374642f666d74__f64_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store l arg in frame
    mov [rbp-24], rdx ; store idx arg in frame
    mov [rbp-32], rcx ; store empty_case arg in frame
    mov [rbp-40], r8 ; store one arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    movsd xmm0, [rbp-8] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-40] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_141___rgo_7374642f666d74__f64_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_141___rgo_7374642f666d74__f64_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_141___rgo_7374642f666d74__f64_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _145___rgo_7374642f666d74__f64_nth closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-24] ; load operand
    mov rbx, [rbp-16] ; load operand
    cmp rax, rbx
    jb lt_uint__145___rgo_7374642f666d74__f64_nth_true_0_0
lt_uint_empty_case_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-32] ; load empty_case closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt_uint__145___rgo_7374642f666d74__f64_nth_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _145___rgo_7374642f666d74__f64_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__f64_nth_unwrapper
__rgo_7374642f666d74__f64_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load l env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load idx env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load empty_case env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load one env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__f64_nth
global __rgo_7374642f666d74__f64_nth_deep_release
__rgo_7374642f666d74__f64_nth_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__f64_nth_release_skip_3
    mov rax, [r12-16] ; load __rgo_7374642f666d74__f64_nth_release_field_3 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__f64_nth_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__f64_nth_release_skip_4
    mov rax, [r12-8] ; load __rgo_7374642f666d74__f64_nth_release_field_4 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__f64_nth_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__f64_nth_deepcopy
__rgo_7374642f666d74__f64_nth_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__f64_nth_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__f64_nth_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__f64_nth_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__f64_nth_deepcopy_skip_4:
    leave
    ret

global _147___rgo_7374642f666d74__f64_source
_147___rgo_7374642f666d74__f64_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov [rbp-24], rdx ; store l arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__f64_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__f64_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__f64_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _148___rgo_7374642f666d74__f64_nth closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load inspect_value closure env_end pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _147___rgo_7374642f666d74__f64_source_unwrapper
_147___rgo_7374642f666d74__f64_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load inspect_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load value env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load l env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _147___rgo_7374642f666d74__f64_source
global _147___rgo_7374642f666d74__f64_source_deep_release
_147___rgo_7374642f666d74__f64_source_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _147___rgo_7374642f666d74__f64_source_release_skip_0
    mov rax, [r12-24] ; load _147___rgo_7374642f666d74__f64_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_147___rgo_7374642f666d74__f64_source_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _147___rgo_7374642f666d74__f64_source_deepcopy
_147___rgo_7374642f666d74__f64_source_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _147___rgo_7374642f666d74__f64_source_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_147___rgo_7374642f666d74__f64_source_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f666d74__f64_source
__rgo_7374642f666d74__f64_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    movsd xmm0, [rbp-8] ; load float operand
    movq rax, xmm0
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_147___rgo_7374642f666d74__f64_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_147___rgo_7374642f666d74__f64_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_147___rgo_7374642f666d74__f64_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _149___rgo_7374642f666d74__f64_source closure env_end to rax
    mov [rbp-24], rax ; store value
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_format_f64_len
    add rsp, 8 ; restore stack after native call
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__f64_source_unwrapper
__rgo_7374642f666d74__f64_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__f64_source
global __rgo_7374642f666d74__f64_source_deep_release
__rgo_7374642f666d74__f64_source_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__f64_source_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f666d74__f64_source_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__f64_source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__f64_source_deepcopy
__rgo_7374642f666d74__f64_source_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__f64_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__f64_source_deepcopy_skip_1:
    leave
    ret

global _400_test_floats
_400_test_floats:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    mov rax, 1 ; write syscall
    syscall
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _400_test_floats_unwrapper
_400_test_floats_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load output env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _400_test_floats
global _400_test_floats_deep_release
_400_test_floats_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _400_test_floats_release_skip_0
    mov rax, [r12-16] ; load _400_test_floats_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_400_test_floats_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _400_test_floats_release_skip_1
    mov rax, [r12-8] ; load _400_test_floats_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_400_test_floats_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _400_test_floats_deepcopy
_400_test_floats_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _400_test_floats_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_400_test_floats_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _400_test_floats_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_400_test_floats_deepcopy_skip_1:
    leave
    ret

global test_floats
test_floats:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 112 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 0x4044000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__f64_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__f64_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__f64_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_122 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_123 closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_125 closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_126 closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 0x4029000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__f64_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__f64_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__f64_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_128 closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-56] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_129 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 10 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_131 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_132 closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_400_test_floats_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_400_test_floats_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_400_test_floats_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_133 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rbx, [rbp-96] ; original closure invalid to ____comptime_134_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-104] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_167___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_134 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js test_floats_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-96] ; load operand
    mov [rbx], rax
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax
    lea r12, [rbx+32]
    lea rax, [bytes_build_inspector_unwrapper]
    mov [r12], rax
    lea rax, [bytes_build_inspector_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_inspector_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 32
    mov qword [r12+32], 80
    mov qword [r12+40], 2
    mov rbx, [rbp-80] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
test_floats_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-112] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-80] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-96] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global test_floats_unwrapper
test_floats_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_floats
global test_floats_deep_release
test_floats_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_floats_release_skip_0
    mov rax, [r12-8] ; load test_floats_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_floats_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_floats_deepcopy
test_floats_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_floats_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_floats_deepcopy_skip_0:
    leave
    ret

global _137___rgo_7374642f666d74__int_source
_137___rgo_7374642f666d74__int_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store rendered arg in frame
    mov rbx, [rbp-16] ; load rendered closure env_end pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _137___rgo_7374642f666d74__int_source_unwrapper
_137___rgo_7374642f666d74__int_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load inspect_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load rendered env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _137___rgo_7374642f666d74__int_source
global _137___rgo_7374642f666d74__int_source_deep_release
_137___rgo_7374642f666d74__int_source_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _137___rgo_7374642f666d74__int_source_release_skip_0
    mov rax, [r12-16] ; load _137___rgo_7374642f666d74__int_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_137___rgo_7374642f666d74__int_source_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _137___rgo_7374642f666d74__int_source_release_skip_1
    mov rax, [r12-8] ; load _137___rgo_7374642f666d74__int_source_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_137___rgo_7374642f666d74__int_source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _137___rgo_7374642f666d74__int_source_deepcopy
_137___rgo_7374642f666d74__int_source_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _137___rgo_7374642f666d74__int_source_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_137___rgo_7374642f666d74__int_source_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _137___rgo_7374642f666d74__int_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_137___rgo_7374642f666d74__int_source_deepcopy_skip_1:
    leave
    ret

global _244___rgo_7374642f666d74__from_int
_244___rgo_7374642f666d74__from_int:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store magnitude arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 45 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _246___rgo_7374642f666d74__single closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _247___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _244___rgo_7374642f666d74__from_int_unwrapper
_244___rgo_7374642f666d74__from_int_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load magnitude env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _244___rgo_7374642f666d74__from_int
global _244___rgo_7374642f666d74__from_int_deep_release
_244___rgo_7374642f666d74__from_int_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__from_int_release_skip_0
    mov rax, [r12-16] ; load _244___rgo_7374642f666d74__from_int_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_244___rgo_7374642f666d74__from_int_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-8] ; load _244___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_244___rgo_7374642f666d74__from_int_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _244___rgo_7374642f666d74__from_int_deepcopy
_244___rgo_7374642f666d74__from_int_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__from_int_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_244___rgo_7374642f666d74__from_int_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_244___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    leave
    ret

global _230___rgo_7374642f666d74__negative_digits
_230___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store suffix arg in frame
    mov [rbp-24], rdx ; store prefix arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _231___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _230___rgo_7374642f666d74__negative_digits_unwrapper
_230___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load suffix env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load prefix env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _230___rgo_7374642f666d74__negative_digits
global _230___rgo_7374642f666d74__negative_digits_deep_release
_230___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-24] ; load _230___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_230___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-16] ; load _230___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_230___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-8] ; load _230___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_230___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _230___rgo_7374642f666d74__negative_digits_deepcopy
_230___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_230___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_230___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_230___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    leave
    ret

global _228___rgo_7374642f666d74__negative_digits
_228___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store invalid arg in frame
    mov [rbp-32], rcx ; store ok arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_230___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_230___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_230___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _232___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-8] ; load __rgo_7374642f666d74__negative_digits closure env_end pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx-24], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-48] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _228___rgo_7374642f666d74__negative_digits_unwrapper
_228___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load __rgo_7374642f666d74__negative_digits env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load invalid env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load suffix env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _228___rgo_7374642f666d74__negative_digits
global _228___rgo_7374642f666d74__negative_digits_deep_release
_228___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _228___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _228___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _228___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-8] ; load _228___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _228___rgo_7374642f666d74__negative_digits_deepcopy
_228___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_228___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_228___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_228___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_228___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _224___rgo_7374642f666d74__negative_digits
_224___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store quotient arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-32], rcx ; store invalid arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rbx, [rbp-16] ; original closure ok to _226_ok env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-40] ; original closure suffix to ___226_ok_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-56], rax ; store value
    mov r12, [rbp-48] ; load operand
    mov rcx, [rbp-56] ; load operand
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+32], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_228___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_228___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_228___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _233___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_int__226_ok_true_0_0
eq_int__233___rgo_7374642f666d74__negative_digits_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-64] ; load _233___rgo_7374642f666d74__negative_digits closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_int__226_ok_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-64] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _226_ok closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _224___rgo_7374642f666d74__negative_digits_unwrapper
_224___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load quotient env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load __rgo_7374642f666d74__negative_digits env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load suffix env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _224___rgo_7374642f666d74__negative_digits
global _224___rgo_7374642f666d74__negative_digits_deep_release
_224___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-32] ; load _224___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _224___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _224___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-8] ; load _224___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _224___rgo_7374642f666d74__negative_digits_deepcopy
_224___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_224___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_224___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_224___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_224___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _180___rgo_7374642f666d74__digit
_180___rgo_7374642f666d74__digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store ascii arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _181___rgo_7374642f666d74__single closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _180___rgo_7374642f666d74__digit_unwrapper
_180___rgo_7374642f666d74__digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load ascii env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _180___rgo_7374642f666d74__digit
global _180___rgo_7374642f666d74__digit_deep_release
_180___rgo_7374642f666d74__digit_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _180___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _180___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_180___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _180___rgo_7374642f666d74__digit_deepcopy
_180___rgo_7374642f666d74__digit_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _180___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_180___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _178___rgo_7374642f666d74__digit
_178___rgo_7374642f666d74__digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store ascii_bits arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_180___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_180___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_180___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _182___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-16] ; load operand
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _178___rgo_7374642f666d74__digit_unwrapper
_178___rgo_7374642f666d74__digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load ascii_bits env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _178___rgo_7374642f666d74__digit
global _178___rgo_7374642f666d74__digit_deep_release
_178___rgo_7374642f666d74__digit_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _178___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _178___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_178___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _178___rgo_7374642f666d74__digit_deepcopy
_178___rgo_7374642f666d74__digit_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _178___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_178___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _176___rgo_7374642f666d74__digit
_176___rgo_7374642f666d74__digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value_bits arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store zero_bits arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_178___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_178___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_178___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _183___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, [rbp-24] ; load operand
    add rax, rbx ; add bit values
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _176___rgo_7374642f666d74__digit_unwrapper
_176___rgo_7374642f666d74__digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value_bits env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load zero_bits env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _176___rgo_7374642f666d74__digit
global _176___rgo_7374642f666d74__digit_deep_release
_176___rgo_7374642f666d74__digit_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _176___rgo_7374642f666d74__digit_release_skip_1
    mov rax, [r12-16] ; load _176___rgo_7374642f666d74__digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_176___rgo_7374642f666d74__digit_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _176___rgo_7374642f666d74__digit_deepcopy
_176___rgo_7374642f666d74__digit_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _176___rgo_7374642f666d74__digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_176___rgo_7374642f666d74__digit_deepcopy_skip_1:
    leave
    ret

global _173___rgo_7374642f666d74__digit
_173___rgo_7374642f666d74__digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store value_bits arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_176___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_176___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_176___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _184___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 48 ; operand literal
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _173___rgo_7374642f666d74__digit_unwrapper
_173___rgo_7374642f666d74__digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load value_bits env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _173___rgo_7374642f666d74__digit
global _173___rgo_7374642f666d74__digit_deep_release
_173___rgo_7374642f666d74__digit_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _173___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _173___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_173___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _173___rgo_7374642f666d74__digit_deepcopy
_173___rgo_7374642f666d74__digit_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _173___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_173___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _171___rgo_7374642f666d74__digit
_171___rgo_7374642f666d74__digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store value_u8 arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_173___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_173___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_173___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _185___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-16] ; load operand
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _171___rgo_7374642f666d74__digit_unwrapper
_171___rgo_7374642f666d74__digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load value_u8 env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _171___rgo_7374642f666d74__digit
global _171___rgo_7374642f666d74__digit_deep_release
_171___rgo_7374642f666d74__digit_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _171___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _171___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_171___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _171___rgo_7374642f666d74__digit_deepcopy
_171___rgo_7374642f666d74__digit_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _171___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_171___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f666d74__digit
__rgo_7374642f666d74__digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_171___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_171___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_171___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _186___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-8] ; load operand
    test rax, rax
    js __rgo_7374642f666d74__digit_u8_from_int_invalid_0
    cmp rax, 255
    ja __rgo_7374642f666d74__digit_u8_from_int_invalid_0
    push rax
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    pop rax
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
__rgo_7374642f666d74__digit_u8_from_int_invalid_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__digit_unwrapper
__rgo_7374642f666d74__digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__digit
global __rgo_7374642f666d74__digit_deep_release
__rgo_7374642f666d74__digit_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__digit_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__digit_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__digit_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__digit_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__digit_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__digit_deepcopy
__rgo_7374642f666d74__digit_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__digit_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__digit_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__digit_deepcopy_skip_2:
    leave
    ret

global _222___rgo_7374642f666d74__negative_digits
_222___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-40], r8 ; store remainder arg in frame
    mov rbx, [rbp-8] ; original closure invalid to ___234___rgo_7374642f666d74__negative_digits_arg_clone_3 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-48] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_224___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_224___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_224___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _234___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-56] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__digit
global _222___rgo_7374642f666d74__negative_digits_unwrapper
_222___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load invalid env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__negative_digits env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load remainder env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _222___rgo_7374642f666d74__negative_digits
global _222___rgo_7374642f666d74__negative_digits_deep_release
_222___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _222___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_222___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _222___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_222___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _222___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_222___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _222___rgo_7374642f666d74__negative_digits_deepcopy
_222___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_222___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_222___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_222___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global _219___rgo_7374642f666d74__negative_digits
_219___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-40], r8 ; store negative_remainder arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_222___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_222___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_222___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _235___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 0 ; operand literal
    mov rbx, [rbp-40] ; load operand
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _219___rgo_7374642f666d74__negative_digits_unwrapper
_219___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load invalid env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__negative_digits env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load negative_remainder env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _219___rgo_7374642f666d74__negative_digits
global _219___rgo_7374642f666d74__negative_digits_deep_release
_219___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _219___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _219___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_219___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _219___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _219___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_219___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _219___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _219___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_219___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _219___rgo_7374642f666d74__negative_digits_deepcopy
_219___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _219___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_219___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _219___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_219___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _219___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_219___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global _217___rgo_7374642f666d74__negative_digits
_217___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store quotient arg in frame
    mov [rbp-32], rcx ; store ok arg in frame
    mov [rbp-40], r8 ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-48], r9 ; store magnitude arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_219___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_219___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_219___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _236___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, [rbp-48] ; load operand
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-56] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _217___rgo_7374642f666d74__negative_digits_unwrapper
_217___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-48] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-40] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__negative_digits env field
    mov [rbp-48], rax ; store value
    mov rax, [r12-8] ; load magnitude env field
    mov [rbp-56], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-56] ; load operand
    push rax ; stack arg
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    pop r9 ; restore arg into register
    leave ; unwind before named jump
    jmp _217___rgo_7374642f666d74__negative_digits
global _217___rgo_7374642f666d74__negative_digits_deep_release
_217___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-40] ; load _217___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_217___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-24] ; load _217___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_217___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-16] ; load _217___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_217___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _217___rgo_7374642f666d74__negative_digits_deepcopy
_217___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_217___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_217___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_217___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _214___rgo_7374642f666d74__negative_digits
_214___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-40], r8 ; store quotient arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 96 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+16], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+32], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 48 ; move pointer past env payload
    mov rax, 48 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 96 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_217___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_217___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_217___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _237___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-40] ; load operand
    mov rbx, 10 ; operand literal
    imul rax, rbx ; multiply by multiplier
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _214___rgo_7374642f666d74__negative_digits_unwrapper
_214___rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__negative_digits env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load quotient env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _214___rgo_7374642f666d74__negative_digits
global _214___rgo_7374642f666d74__negative_digits_deep_release
_214___rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _214___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-32] ; load _214___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_214___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _214___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _214___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_214___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _214___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _214___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_214___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _214___rgo_7374642f666d74__negative_digits_deepcopy
_214___rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _214___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_214___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _214___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_214___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _214___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_214___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global __rgo_7374642f666d74__negative_digits
__rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-16] ; original closure invalid to ___238___rgo_7374642f666d74__negative_digits_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_214___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_214___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_214___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _238___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, 10 ; operand literal
    cmp rbx, 0 ; check divisor for division by zero
    jne __rgo_7374642f666d74__negative_digits_div_ok_0
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
__rgo_7374642f666d74__negative_digits_div_ok_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, [rbp-8] ; load operand
    mov rbx, 10 ; operand literal
    cqo ; sign extend dividend
    idiv rbx ; divide by divisor
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__negative_digits_unwrapper
__rgo_7374642f666d74__negative_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__negative_digits
global __rgo_7374642f666d74__negative_digits_deep_release
__rgo_7374642f666d74__negative_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__negative_digits_deepcopy
__rgo_7374642f666d74__negative_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    leave
    ret

global _242___rgo_7374642f666d74__from_int
_242___rgo_7374642f666d74__from_int:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_244___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_244___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_244___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _248___rgo_7374642f666d74__from_int closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__negative_digits
global _242___rgo_7374642f666d74__from_int_unwrapper
_242___rgo_7374642f666d74__from_int_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _242___rgo_7374642f666d74__from_int
global _242___rgo_7374642f666d74__from_int_deep_release
_242___rgo_7374642f666d74__from_int_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _242___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load _242___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_242___rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _242___rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load _242___rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_242___rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _242___rgo_7374642f666d74__from_int_deepcopy
_242___rgo_7374642f666d74__from_int_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _242___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_242___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _242___rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_242___rgo_7374642f666d74__from_int_deepcopy_skip_2:
    leave
    ret

global _203___rgo_7374642f666d74__positive_digits
_203___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store suffix arg in frame
    mov [rbp-24], rdx ; store prefix arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _204___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _203___rgo_7374642f666d74__positive_digits_unwrapper
_203___rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load suffix env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load prefix env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _203___rgo_7374642f666d74__positive_digits
global _203___rgo_7374642f666d74__positive_digits_deep_release
_203___rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _203___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-24] ; load _203___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_203___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _203___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-16] ; load _203___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_203___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _203___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-8] ; load _203___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_203___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _203___rgo_7374642f666d74__positive_digits_deepcopy
_203___rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _203___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_203___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _203___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_203___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _203___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_203___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    leave
    ret

global _201___rgo_7374642f666d74__positive_digits
_201___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store invalid arg in frame
    mov [rbp-32], rcx ; store ok arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_203___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_203___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_203___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _205___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-8] ; load __rgo_7374642f666d74__positive_digits closure env_end pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx-24], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-48] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _201___rgo_7374642f666d74__positive_digits_unwrapper
_201___rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load __rgo_7374642f666d74__positive_digits env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load invalid env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load suffix env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _201___rgo_7374642f666d74__positive_digits
global _201___rgo_7374642f666d74__positive_digits_deep_release
_201___rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-40] ; load _201___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_201___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _201___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_201___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _201___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_201___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-8] ; load _201___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_201___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _201___rgo_7374642f666d74__positive_digits_deepcopy
_201___rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_201___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_201___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_201___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _201___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_201___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _197___rgo_7374642f666d74__positive_digits
_197___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store quotient arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-32], rcx ; store invalid arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rbx, [rbp-16] ; original closure ok to _199_ok env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-40] ; original closure suffix to ___199_ok_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-56], rax ; store value
    mov r12, [rbp-48] ; load operand
    mov rcx, [rbp-56] ; load operand
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+32], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_201___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_201___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_201___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _206___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_int__199_ok_true_0_0
eq_int__206___rgo_7374642f666d74__positive_digits_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-64] ; load _206___rgo_7374642f666d74__positive_digits closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_int__199_ok_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-64] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _199_ok closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _197___rgo_7374642f666d74__positive_digits_unwrapper
_197___rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load quotient env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load __rgo_7374642f666d74__positive_digits env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load suffix env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _197___rgo_7374642f666d74__positive_digits
global _197___rgo_7374642f666d74__positive_digits_deep_release
_197___rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-32] ; load _197___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_197___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _197___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_197___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _197___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_197___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-8] ; load _197___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_197___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _197___rgo_7374642f666d74__positive_digits_deepcopy
_197___rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_197___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_197___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_197___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _197___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_197___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _195___rgo_7374642f666d74__positive_digits
_195___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-40], r8 ; store remainder arg in frame
    mov rbx, [rbp-8] ; original closure invalid to ___207___rgo_7374642f666d74__positive_digits_arg_clone_3 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-48] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_197___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_197___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_197___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _207___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-56] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__digit
global _195___rgo_7374642f666d74__positive_digits_unwrapper
_195___rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load invalid env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__positive_digits env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load remainder env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _195___rgo_7374642f666d74__positive_digits
global _195___rgo_7374642f666d74__positive_digits_deep_release
_195___rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _195___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-40] ; load _195___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_195___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _195___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _195___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_195___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _195___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _195___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_195___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _195___rgo_7374642f666d74__positive_digits_deepcopy
_195___rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _195___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_195___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _195___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_195___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _195___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_195___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    leave
    ret

global _193___rgo_7374642f666d74__positive_digits
_193___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store quotient arg in frame
    mov [rbp-32], rcx ; store ok arg in frame
    mov [rbp-40], r8 ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-48], r9 ; store magnitude arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_195___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_195___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_195___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _208___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, [rbp-48] ; load operand
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-56] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _193___rgo_7374642f666d74__positive_digits_unwrapper
_193___rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-48] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-40] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-32] ; load quotient env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__positive_digits env field
    mov [rbp-48], rax ; store value
    mov rax, [r12-8] ; load magnitude env field
    mov [rbp-56], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-56] ; load operand
    push rax ; stack arg
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    pop r9 ; restore arg into register
    leave ; unwind before named jump
    jmp _193___rgo_7374642f666d74__positive_digits
global _193___rgo_7374642f666d74__positive_digits_deep_release
_193___rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _193___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-40] ; load _193___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_193___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _193___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-24] ; load _193___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_193___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _193___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-16] ; load _193___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_193___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _193___rgo_7374642f666d74__positive_digits_deepcopy
_193___rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 4 ; operand literal
    cmp rax, rbx
    jg _193___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_193___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _193___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_193___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _193___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_193___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _190___rgo_7374642f666d74__positive_digits
_190___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-40], r8 ; store quotient arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 96 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+16], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+32], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 48 ; move pointer past env payload
    mov rax, 48 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 96 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_193___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_193___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_193___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _209___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-40] ; load operand
    mov rbx, 10 ; operand literal
    imul rax, rbx ; multiply by multiplier
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _190___rgo_7374642f666d74__positive_digits_unwrapper
_190___rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load __rgo_7374642f666d74__positive_digits env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load quotient env field
    mov [rbp-48], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-48] ; load operand
    push rax ; stack arg
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    pop r8 ; restore arg into register
    leave ; unwind before named jump
    jmp _190___rgo_7374642f666d74__positive_digits
global _190___rgo_7374642f666d74__positive_digits_deep_release
_190___rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _190___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-32] ; load _190___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_190___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _190___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _190___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_190___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _190___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _190___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_190___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _190___rgo_7374642f666d74__positive_digits_deepcopy
_190___rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg _190___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_190___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _190___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_190___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _190___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_190___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    leave
    ret

global __rgo_7374642f666d74__positive_digits
__rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-16] ; original closure invalid to ___210___rgo_7374642f666d74__positive_digits_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 88 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+24], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_190___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_190___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_190___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _210___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, 10 ; operand literal
    cmp rbx, 0 ; check divisor for division by zero
    jne __rgo_7374642f666d74__positive_digits_div_ok_0
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
__rgo_7374642f666d74__positive_digits_div_ok_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, [rbp-8] ; load operand
    mov rbx, 10 ; operand literal
    cqo ; sign extend dividend
    idiv rbx ; divide by divisor
    mov r12, [rbp-48] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f666d74__positive_digits_unwrapper
__rgo_7374642f666d74__positive_digits_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__positive_digits
global __rgo_7374642f666d74__positive_digits_deep_release
__rgo_7374642f666d74__positive_digits_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__positive_digits_deepcopy
__rgo_7374642f666d74__positive_digits_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    leave
    ret

global _251___rgo_7374642f666d74__from_int
_251___rgo_7374642f666d74__from_int:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__positive_digits
global _251___rgo_7374642f666d74__from_int_unwrapper
_251___rgo_7374642f666d74__from_int_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _251___rgo_7374642f666d74__from_int
global _251___rgo_7374642f666d74__from_int_deep_release
_251___rgo_7374642f666d74__from_int_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load _251___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_251___rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load _251___rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_251___rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _251___rgo_7374642f666d74__from_int_deepcopy
_251___rgo_7374642f666d74__from_int_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_251___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_251___rgo_7374642f666d74__from_int_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f666d74__from_int
__rgo_7374642f666d74__from_int:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov rbx, [rbp-16] ; original closure invalid to ___249___rgo_7374642f666d74__from_int_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-24] ; original closure ok to ___249___rgo_7374642f666d74__from_int_arg_clone_2 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_242___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_242___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_242___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _249___rgo_7374642f666d74__from_int closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_251___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_251___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_251___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _252___rgo_7374642f666d74__from_int closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jl lt__249___rgo_7374642f666d74__from_int_true_0_0
lt__252___rgo_7374642f666d74__from_int_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _252___rgo_7374642f666d74__from_int closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt__249___rgo_7374642f666d74__from_int_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _249___rgo_7374642f666d74__from_int closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f666d74__from_int_unwrapper
__rgo_7374642f666d74__from_int_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__from_int
global __rgo_7374642f666d74__from_int_deep_release
__rgo_7374642f666d74__from_int_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__from_int_deepcopy
__rgo_7374642f666d74__from_int_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__from_int_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f666d74__int_source
__rgo_7374642f666d74__int_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store invalid arg in frame
    mov [rbp-24], rdx ; store inspect_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_137___rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_137___rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_137___rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _138___rgo_7374642f666d74__int_source closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__from_int
global __rgo_7374642f666d74__int_source_unwrapper
__rgo_7374642f666d74__int_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load invalid env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load inspect_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f666d74__int_source
global __rgo_7374642f666d74__int_source_deep_release
__rgo_7374642f666d74__int_source_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__int_source_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f666d74__int_source_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__int_source_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__int_source_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f666d74__int_source_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f666d74__int_source_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f666d74__int_source_deepcopy
__rgo_7374642f666d74__int_source_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__int_source_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f666d74__int_source_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f666d74__int_source_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f666d74__int_source_deepcopy_skip_2:
    leave
    ret

global _389_test_integers
_389_test_integers:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    mov rax, 1 ; write syscall
    syscall
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _389_test_integers_unwrapper
_389_test_integers_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load output env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _389_test_integers
global _389_test_integers_deep_release
_389_test_integers_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _389_test_integers_release_skip_0
    mov rax, [r12-16] ; load _389_test_integers_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_389_test_integers_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _389_test_integers_release_skip_1
    mov rax, [r12-8] ; load _389_test_integers_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_389_test_integers_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _389_test_integers_deepcopy
_389_test_integers_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _389_test_integers_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_389_test_integers_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _389_test_integers_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_389_test_integers_deepcopy_skip_1:
    leave
    ret

global _382_test_integers
_382_test_integers:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 192 ; reserve stack space for locals
    mov [rbp-8], rdi ; store negative arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store minimum arg in frame
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-32] ; original closure invalid to ____comptime_1_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 0 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_1 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-48] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_2 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_4 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_5 closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rbx, [rbp-32] ; original closure invalid to ____comptime_6_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-88], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_6 closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-96] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_7 closure env_end to rax
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_9 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-104] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_10 closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rbx, [rbp-32] ; original closure invalid to ____comptime_11_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-128], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-128] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_11 closure env_end to rax
    mov [rbp-136], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-120] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-136] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_12 closure env_end to rax
    mov [rbp-144], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 10 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_14 closure env_end to rax
    mov [rbp-152], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-144] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_15 closure env_end to rax
    mov [rbp-160], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_389_test_integers_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_389_test_integers_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_389_test_integers_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_16 closure env_end to rax
    mov [rbp-168], rax ; store value
    mov rbx, [rbp-32] ; original closure invalid to ____comptime_17_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-176], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-176] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-168] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_167___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_17 closure env_end to rax
    mov [rbp-184], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js _382_test_integers_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-32] ; load operand
    mov [rbx], rax
    mov rax, [rbp-184] ; load operand
    mov [rbx+8], rax
    lea r12, [rbx+32]
    lea rax, [bytes_build_inspector_unwrapper]
    mov [r12], rax
    lea rax, [bytes_build_inspector_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_inspector_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 32
    mov qword [r12+32], 80
    mov qword [r12+40], 2
    mov rbx, [rbp-160] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
_382_test_integers_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-184] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-160] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _382_test_integers_unwrapper
_382_test_integers_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load negative env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load minimum env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _382_test_integers
global _382_test_integers_deep_release
_382_test_integers_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _382_test_integers_release_skip_1
    mov rax, [r12-16] ; load _382_test_integers_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_382_test_integers_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _382_test_integers_deepcopy
_382_test_integers_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _382_test_integers_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_382_test_integers_deepcopy_skip_1:
    leave
    ret

global _379_test_integers
_379_test_integers:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store negative arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store negative_max arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_382_test_integers_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_382_test_integers_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_382_test_integers_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _391_test_integers closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-24] ; load operand
    mov rbx, 1 ; operand literal
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _379_test_integers_unwrapper
_379_test_integers_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load negative env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load negative_max env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _379_test_integers
global _379_test_integers_deep_release
_379_test_integers_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _379_test_integers_release_skip_1
    mov rax, [r12-16] ; load _379_test_integers_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_379_test_integers_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _379_test_integers_deepcopy
_379_test_integers_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _379_test_integers_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_379_test_integers_deepcopy_skip_1:
    leave
    ret

global _375_test_integers
_375_test_integers:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store negative arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_379_test_integers_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_379_test_integers_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_379_test_integers_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _392_test_integers closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 0 ; operand literal
    mov rbx, 9223372036854775807 ; operand literal
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _375_test_integers_unwrapper
_375_test_integers_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load negative env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _375_test_integers
global _375_test_integers_deep_release
_375_test_integers_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _375_test_integers_release_skip_0
    mov rax, [r12-16] ; load _375_test_integers_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_375_test_integers_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _375_test_integers_deepcopy
_375_test_integers_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _375_test_integers_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_375_test_integers_deepcopy_skip_0:
    leave
    ret

global test_integers
test_integers:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_375_test_integers_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_375_test_integers_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_375_test_integers_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _393_test_integers closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, 0 ; operand literal
    mov rbx, 42 ; operand literal
    sub rax, rbx ; subtract subtrahend
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global test_integers_unwrapper
test_integers_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_integers
global test_integers_deep_release
test_integers_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_integers_release_skip_0
    mov rax, [r12-8] ; load test_integers_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_integers_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_integers_deepcopy
test_integers_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_integers_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_integers_deepcopy_skip_0:
    leave
    ret

global _404_test_percent
_404_test_percent:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    mov rax, 1 ; write syscall
    syscall
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _404_test_percent_unwrapper
_404_test_percent_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load output env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _404_test_percent
global _404_test_percent_deep_release
_404_test_percent_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _404_test_percent_release_skip_0
    mov rax, [r12-16] ; load _404_test_percent_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_404_test_percent_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _404_test_percent_release_skip_1
    mov rax, [r12-8] ; load _404_test_percent_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_404_test_percent_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _404_test_percent_deepcopy
_404_test_percent_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _404_test_percent_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_404_test_percent_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _404_test_percent_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_404_test_percent_deepcopy_skip_1:
    leave
    ret

global test_percent
test_percent:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 208 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 49 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_136 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_137 closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 48 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_139 closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_140 closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 48 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_142 closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-56] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_143 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 37 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_145 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_146 closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_148 closure env_end to rax
    mov [rbp-88], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_149 closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 100 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_151 closure env_end to rax
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_152 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 111 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_154 closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-112] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-120] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_155 closure env_end to rax
    mov [rbp-128], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 110 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_157 closure env_end to rax
    mov [rbp-136], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-128] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-136] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_158 closure env_end to rax
    mov [rbp-144], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 101 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_160 closure env_end to rax
    mov [rbp-152], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-144] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_161 closure env_end to rax
    mov [rbp-160], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 10 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_163 closure env_end to rax
    mov [rbp-168], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-160] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-168] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_164 closure env_end to rax
    mov [rbp-176], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_404_test_percent_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_404_test_percent_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_404_test_percent_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_165 closure env_end to rax
    mov [rbp-184], rax ; store value
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-192], rax ; store value
    mov rbx, [rbp-192] ; original closure invalid to ____comptime_166_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-200], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-200] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-184] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_167___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_166 closure env_end to rax
    mov [rbp-208], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js test_percent_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-192] ; load operand
    mov [rbx], rax
    mov rax, [rbp-208] ; load operand
    mov [rbx+8], rax
    lea r12, [rbx+32]
    lea rax, [bytes_build_inspector_unwrapper]
    mov [r12], rax
    lea rax, [bytes_build_inspector_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_inspector_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 32
    mov qword [r12+32], 80
    mov qword [r12+40], 2
    mov rbx, [rbp-176] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
test_percent_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-208] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-176] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-192] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global test_percent_unwrapper
test_percent_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_percent
global test_percent_deep_release
test_percent_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_percent_release_skip_0
    mov rax, [r12-8] ; load test_percent_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_percent_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_percent_deepcopy
test_percent_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_percent_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_percent_deepcopy_skip_0:
    leave
    ret

global _410_test_unicode
_410_test_unicode:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    mov rax, 1 ; write syscall
    syscall
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _410_test_unicode_unwrapper
_410_test_unicode_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load output env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _410_test_unicode
global _410_test_unicode_deep_release
_410_test_unicode_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _410_test_unicode_release_skip_0
    mov rax, [r12-16] ; load _410_test_unicode_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_410_test_unicode_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _410_test_unicode_release_skip_1
    mov rax, [r12-8] ; load _410_test_unicode_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_410_test_unicode_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _410_test_unicode_deepcopy
_410_test_unicode_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _410_test_unicode_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_410_test_unicode_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _410_test_unicode_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_410_test_unicode_deepcopy_skip_1:
    leave
    ret

global test_unicode
test_unicode:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 256 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 240 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_168 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_169 closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 159 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_171 closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_172 closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 152 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_174 closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-56] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_175 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 128 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_177 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_178 closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_180 closure env_end to rax
    mov [rbp-88], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_181 closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel __comptime_182] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__str_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__str_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__str_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_183 closure env_end to rax
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_184 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_186 closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-112] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-120] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_187 closure env_end to rax
    mov [rbp-128], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 99 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_189 closure env_end to rax
    mov [rbp-136], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-128] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-136] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_190 closure env_end to rax
    mov [rbp-144], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 97 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_192 closure env_end to rax
    mov [rbp-152], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-144] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_193 closure env_end to rax
    mov [rbp-160], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 102 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_195 closure env_end to rax
    mov [rbp-168], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-160] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-168] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_196 closure env_end to rax
    mov [rbp-176], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 195 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_198 closure env_end to rax
    mov [rbp-184], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-176] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-184] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_199 closure env_end to rax
    mov [rbp-192], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 169 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_201 closure env_end to rax
    mov [rbp-200], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-192] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-200] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_202 closure env_end to rax
    mov [rbp-208], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 10 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_204 closure env_end to rax
    mov [rbp-216], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-208] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-216] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_205 closure env_end to rax
    mov [rbp-224], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_410_test_unicode_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_410_test_unicode_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_410_test_unicode_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_206 closure env_end to rax
    mov [rbp-232], rax ; store value
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-240], rax ; store value
    mov rbx, [rbp-240] ; original closure invalid to ____comptime_207_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-248], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-248] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-232] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_167___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_207 closure env_end to rax
    mov [rbp-256], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js test_unicode_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-240] ; load operand
    mov [rbx], rax
    mov rax, [rbp-256] ; load operand
    mov [rbx+8], rax
    lea r12, [rbx+32]
    lea rax, [bytes_build_inspector_unwrapper]
    mov [r12], rax
    lea rax, [bytes_build_inspector_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_inspector_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 32
    mov qword [r12+32], 80
    mov qword [r12+40], 2
    mov rbx, [rbp-224] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
test_unicode_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-256] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-224] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-240] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global test_unicode_unwrapper
test_unicode_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_unicode
global test_unicode_deep_release
test_unicode_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_unicode_release_skip_0
    mov rax, [r12-8] ; load test_unicode_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_unicode_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_unicode_deepcopy
test_unicode_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_unicode_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_unicode_deepcopy_skip_0:
    leave
    ret

global _412_test_basic_ok
_412_test_basic_ok:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store next arg in frame
    mov [rbp-16], rsi ; store output arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    mov rsi, [rdi] ; string data pointer
    mov rdx, [rdi+8] ; string byte length
    mov rdi, 1 ; stdout fd
    mov rax, 1 ; write syscall
    syscall
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _412_test_basic_ok_unwrapper
_412_test_basic_ok_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load next env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load output env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _412_test_basic_ok
global _412_test_basic_ok_deep_release
_412_test_basic_ok_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _412_test_basic_ok_release_skip_0
    mov rax, [r12-16] ; load _412_test_basic_ok_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_412_test_basic_ok_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _412_test_basic_ok_release_skip_1
    mov rax, [r12-8] ; load _412_test_basic_ok_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_412_test_basic_ok_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _412_test_basic_ok_deepcopy
_412_test_basic_ok_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _412_test_basic_ok_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_412_test_basic_ok_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _412_test_basic_ok_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_412_test_basic_ok_deepcopy_skip_1:
    leave
    ret

global test_basic
test_basic:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 544 ; reserve stack space for locals
    mov [rbp-8], rdi ; store name arg in frame
    mov [rbp-16], rsi ; store count arg in frame
    mov [rbp-24], rdx ; store next arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 104 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_19 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_20 closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 101 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_22 closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-56] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_23 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 108 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_25 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_26 closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 108 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_28 closure env_end to rax
    mov [rbp-88], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_29 closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 111 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_31 closure env_end to rax
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_32 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_34 closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-112] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-120] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_35 closure env_end to rax
    mov [rbp-128], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel __comptime_36] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__str_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__str_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__str_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_37 closure env_end to rax
    mov [rbp-136], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-128] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-136] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_38 closure env_end to rax
    mov [rbp-144], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 44 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_40 closure env_end to rax
    mov [rbp-152], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-144] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_41 closure env_end to rax
    mov [rbp-160], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_43 closure env_end to rax
    mov [rbp-168], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-160] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-168] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_44 closure env_end to rax
    mov [rbp-176], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 121 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_46 closure env_end to rax
    mov [rbp-184], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-176] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-184] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_47 closure env_end to rax
    mov [rbp-192], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 111 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_49 closure env_end to rax
    mov [rbp-200], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-192] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-200] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_50 closure env_end to rax
    mov [rbp-208], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 117 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_52 closure env_end to rax
    mov [rbp-216], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-208] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-216] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_53 closure env_end to rax
    mov [rbp-224], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_55 closure env_end to rax
    mov [rbp-232], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-224] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-232] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_56 closure env_end to rax
    mov [rbp-240], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 104 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_58 closure env_end to rax
    mov [rbp-248], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-240] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-248] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_59 closure env_end to rax
    mov [rbp-256], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 97 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_61 closure env_end to rax
    mov [rbp-264], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-256] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-264] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_62 closure env_end to rax
    mov [rbp-272], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 118 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_64 closure env_end to rax
    mov [rbp-280], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-272] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-280] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_65 closure env_end to rax
    mov [rbp-288], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 101 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_67 closure env_end to rax
    mov [rbp-296], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-288] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-296] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_68 closure env_end to rax
    mov [rbp-304], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_70 closure env_end to rax
    mov [rbp-312], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-304] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-312] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_71 closure env_end to rax
    mov [rbp-320], rax ; store value
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
    lea rax, [invalid_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy invalid closure env_end to rax
    mov [rbp-328], rax ; store value
    mov rbx, [rbp-328] ; original closure invalid to ____comptime_73_arg_clone_1 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-336], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 42 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-336] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_73 closure env_end to rax
    mov [rbp-344], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-320] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-344] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_74 closure env_end to rax
    mov [rbp-352], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 32 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_76 closure env_end to rax
    mov [rbp-360], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-352] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-360] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_77 closure env_end to rax
    mov [rbp-368], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 109 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_79 closure env_end to rax
    mov [rbp-376], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-368] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-376] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_80 closure env_end to rax
    mov [rbp-384], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 101 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_82 closure env_end to rax
    mov [rbp-392], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-384] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-392] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_83 closure env_end to rax
    mov [rbp-400], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 115 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_85 closure env_end to rax
    mov [rbp-408], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-400] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-408] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_86 closure env_end to rax
    mov [rbp-416], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 115 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_88 closure env_end to rax
    mov [rbp-424], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-416] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-424] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_89 closure env_end to rax
    mov [rbp-432], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 97 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_91 closure env_end to rax
    mov [rbp-440], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-432] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-440] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_92 closure env_end to rax
    mov [rbp-448], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 103 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_94 closure env_end to rax
    mov [rbp-456], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-448] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-456] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_95 closure env_end to rax
    mov [rbp-464], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 101 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_97 closure env_end to rax
    mov [rbp-472], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-464] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-472] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_98 closure env_end to rax
    mov [rbp-480], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 115 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_100 closure env_end to rax
    mov [rbp-488], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-480] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-488] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_101 closure env_end to rax
    mov [rbp-496], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 10 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__single_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_103 closure env_end to rax
    mov [rbp-504], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-496] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-504] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_104 closure env_end to rax
    mov [rbp-512], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_412_test_basic_ok_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_412_test_basic_ok_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_412_test_basic_ok_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_105 closure env_end to rax
    mov [rbp-520], rax ; store value
    mov rbx, [rbp-328] ; original closure invalid to ____comptime_106_arg_clone_0 env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, r14 ; length for cloned environment
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate cloned env pages
    mov r15, rax ; cloned closure env base pointer
    mov rsi, r12 ; source env base for clone copy
    mov rdi, r15 ; destination env base for clone copy
    mov rcx, r14 ; bytes to copy for cloned env
    cld ; ensure forward copy for env clone
    rep movsb ; duplicate closure env data
    mov rbx, r15 ; start from cloned env base
    add rbx, r13 ; compute cloned env_end pointer
    mov r12, rbx ; cloned env_end pointer
    mov rax, [r12+16] ; load deepcopy helper entry point
    push r12 ; preserve cloned env_end pointer
    mov rdi, r12 ; pass env_end pointer to deepcopy helper
    call rax ; deepcopy reference fields
    pop r12 ; restore cloned env_end pointer
    mov rax, r12 ; copy cloned env_end pointer
    mov [rbp-528], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-528] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-520] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_167___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_167___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_106 closure env_end to rax
    mov [rbp-536], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js test_basic_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-328] ; load operand
    mov [rbx], rax
    mov rax, [rbp-536] ; load operand
    mov [rbx+8], rax
    lea r12, [rbx+32]
    lea rax, [bytes_build_inspector_unwrapper]
    mov [r12], rax
    lea rax, [bytes_build_inspector_deep_release]
    mov [r12+8], rax
    lea rax, [bytes_build_inspector_deepcopy]
    mov [r12+16], rax
    mov qword [r12+24], 32
    mov qword [r12+32], 80
    mov qword [r12+40], 2
    mov rbx, [rbp-512] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
test_basic_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-536] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-512] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-328] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global test_basic_unwrapper
test_basic_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load name env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load count env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load next env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp test_basic
global test_basic_deep_release
test_basic_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg test_basic_release_skip_0
    mov rax, [r12-24] ; load test_basic_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
test_basic_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_basic_release_skip_2
    mov rax, [r12-8] ; load test_basic_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_basic_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_basic_deepcopy
test_basic_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg test_basic_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_basic_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg test_basic_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
test_basic_deepcopy_skip_2:
    leave
    ret

global main
main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store name arg in frame
    mov [rbp-16], rsi ; store count arg in frame
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
    lea rax, [_418_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_418_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_418_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _418_main closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [test_executable_output_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [test_executable_output_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [test_executable_output_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _421_test_executable_output closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [test_floats_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [test_floats_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [test_floats_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _422_test_floats closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [test_integers_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [test_integers_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [test_integers_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _423_test_integers closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [test_percent_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [test_percent_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [test_percent_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _424_test_percent closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 56 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [test_unicode_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [test_unicode_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [test_unicode_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _425_test_unicode closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-64] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp test_basic
global main_unwrapper
main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load name env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load count env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp main
global main_deep_release
main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg main_release_skip_0
    mov rax, [r12-16] ; load main_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
main_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global main_deepcopy
main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg main_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
main_deepcopy_skip_0:
    leave
    ret

global _start
_start:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    mov rax, 42 ; operand literal
    push rax ; stack arg
    lea rax, [rel name] ; point to string literal
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp main
section .rodata
__comptime_110:
    dq __comptime_110_data, 4, 0, 0 ; data, byte length, heap base, heap size
__comptime_110_data:
    db 0xf0, 0x9f, 0x98, 0x80, 0
__comptime_182:
    dq __comptime_182_data, 6, 0, 0 ; data, byte length, heap base, heap size
__comptime_182_data:
    db 0xe4, 0xb8, 0x96, 0xe7, 0x95, 0x8c, 0
__comptime_36:
    dq __comptime_36_data, 5, 0, 0 ; data, byte length, heap base, heap size
__comptime_36_data:
    db "Alice", 0
name:
    dq name_data, 5, 0, 0 ; data, byte length, heap base, heap size
name_data:
    db "Alice", 0
