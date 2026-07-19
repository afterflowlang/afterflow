bits 64
default rel
section .text
global _160_lambda
_160_lambda:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
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
global _160_lambda_unwrapper
_160_lambda_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _160_lambda
global _160_lambda_deep_release
_160_lambda_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _160_lambda_deepcopy
_160_lambda_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _1482_main
_1482_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 0 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _1482_main_unwrapper
_1482_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _1482_main
global _1482_main_deep_release
_1482_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1482_main_deepcopy
_1482_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
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
global calculated
calculated:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store message arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store _1468_calculated arg in frame
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
global calculated_unwrapper
calculated_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load message env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _1468_calculated env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp calculated
global calculated_deep_release
calculated_deep_release:
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
    jg calculated_release_skip_0
    mov rax, [r12-24] ; load calculated_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
calculated_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg calculated_release_skip_1
    mov rax, [r12-16] ; load calculated_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
calculated_release_skip_1:
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
global calculated_deepcopy
calculated_deepcopy:
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
    jg calculated_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
calculated_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg calculated_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
calculated_deepcopy_skip_1:
    leave
    ret

global constant
constant:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store handle_error arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel __comptime_2] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [calculated_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [calculated_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [calculated_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_3 closure env_end to rax
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, 0x3ff0000000000000 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4000000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    addsd xmm0, xmm1 ; add second float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global constant_unwrapper
constant_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load handle_error env field
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
    jmp constant
global constant_deep_release
constant_deep_release:
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
    jg constant_release_skip_0
    mov rax, [r12-16] ; load constant_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
constant_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg constant_release_skip_1
    mov rax, [r12-8] ; load constant_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
constant_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global constant_deepcopy
constant_deepcopy:
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
    jg constant_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
constant_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg constant_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
constant_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__constant
__rgo_7374642f6d6174682f63616c63__constant:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov rbx, [rbp-16] ; load ok closure env_end pointer
    movsd xmm0, [rbp-8] ; load float operand
    movq rax, xmm0
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__constant_unwrapper
__rgo_7374642f6d6174682f63616c63__constant_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load ok env field
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
    jmp __rgo_7374642f6d6174682f63616c63__constant
global __rgo_7374642f6d6174682f63616c63__constant_deep_release
__rgo_7374642f6d6174682f63616c63__constant_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__constant_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__constant_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__constant_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__constant_deepcopy
__rgo_7374642f6d6174682f63616c63__constant_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__constant_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__constant_deepcopy_skip_1:
    leave
    ret

global _422___rgo_7374642f6d6174682f63616c63__negate
_422___rgo_7374642f6d6174682f63616c63__negate:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store number arg in frame
    mov rax, 0x0 ; load literal float bits
    movq xmm0, rax ; load float literal
    movsd xmm1, [rbp-16] ; load float operand
    subsd xmm0, xmm1 ; subtract second float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-8] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _422___rgo_7374642f6d6174682f63616c63__negate_unwrapper
_422___rgo_7374642f6d6174682f63616c63__negate_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load number env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _422___rgo_7374642f6d6174682f63616c63__negate
global _422___rgo_7374642f6d6174682f63616c63__negate_deep_release
_422___rgo_7374642f6d6174682f63616c63__negate_deep_release:
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
    jg _422___rgo_7374642f6d6174682f63616c63__negate_release_skip_0
    mov rax, [r12-16] ; load _422___rgo_7374642f6d6174682f63616c63__negate_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_422___rgo_7374642f6d6174682f63616c63__negate_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _422___rgo_7374642f6d6174682f63616c63__negate_deepcopy
_422___rgo_7374642f6d6174682f63616c63__negate_deepcopy:
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
    jg _422___rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_422___rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__negate
__rgo_7374642f6d6174682f63616c63__negate:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
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
    lea rax, [_422___rgo_7374642f6d6174682f63616c63__negate_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_422___rgo_7374642f6d6174682f63616c63__negate_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_422___rgo_7374642f6d6174682f63616c63__negate_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _424___rgo_7374642f6d6174682f63616c63__negate closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-8] ; load value closure env_end pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__negate_unwrapper
__rgo_7374642f6d6174682f63616c63__negate_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load value env field
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
    jmp __rgo_7374642f6d6174682f63616c63__negate
global __rgo_7374642f6d6174682f63616c63__negate_deep_release
__rgo_7374642f6d6174682f63616c63__negate_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__negate_release_skip_0
    mov rax, [r12-16] ; load __rgo_7374642f6d6174682f63616c63__negate_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__negate_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__negate_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__negate_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__negate_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__negate_deepcopy
__rgo_7374642f6d6174682f63616c63__negate_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_1:
    leave
    ret

global _443___rgo_7374642f6d6174682f63616c63__divide
_443___rgo_7374642f6d6174682f63616c63__divide:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a_value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store b_value arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-24] ; load float operand
    divsd xmm0, xmm1 ; divide by divisor float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _443___rgo_7374642f6d6174682f63616c63__divide_unwrapper
_443___rgo_7374642f6d6174682f63616c63__divide_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load b_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
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
    jmp _443___rgo_7374642f6d6174682f63616c63__divide
global _443___rgo_7374642f6d6174682f63616c63__divide_deep_release
_443___rgo_7374642f6d6174682f63616c63__divide_deep_release:
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
    jg _443___rgo_7374642f6d6174682f63616c63__divide_release_skip_1
    mov rax, [r12-16] ; load _443___rgo_7374642f6d6174682f63616c63__divide_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_443___rgo_7374642f6d6174682f63616c63__divide_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _443___rgo_7374642f6d6174682f63616c63__divide_deepcopy
_443___rgo_7374642f6d6174682f63616c63__divide_deepcopy:
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
    jg _443___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_443___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1:
    leave
    ret

global _441___rgo_7374642f6d6174682f63616c63__divide
_441___rgo_7374642f6d6174682f63616c63__divide:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store a_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_443___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_443___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_443___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _444___rgo_7374642f6d6174682f63616c63__divide closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _441___rgo_7374642f6d6174682f63616c63__divide_unwrapper
_441___rgo_7374642f6d6174682f63616c63__divide_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load b env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load a_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _441___rgo_7374642f6d6174682f63616c63__divide
global _441___rgo_7374642f6d6174682f63616c63__divide_deep_release
_441___rgo_7374642f6d6174682f63616c63__divide_deep_release:
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
    jg _441___rgo_7374642f6d6174682f63616c63__divide_release_skip_0
    mov rax, [r12-24] ; load _441___rgo_7374642f6d6174682f63616c63__divide_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_441___rgo_7374642f6d6174682f63616c63__divide_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _441___rgo_7374642f6d6174682f63616c63__divide_release_skip_1
    mov rax, [r12-16] ; load _441___rgo_7374642f6d6174682f63616c63__divide_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_441___rgo_7374642f6d6174682f63616c63__divide_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _441___rgo_7374642f6d6174682f63616c63__divide_deepcopy
_441___rgo_7374642f6d6174682f63616c63__divide_deepcopy:
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
    jg _441___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_441___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _441___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_441___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1:
    leave
    ret

global _436___rgo_7374642f6d6174682f63616c63__multiply
_436___rgo_7374642f6d6174682f63616c63__multiply:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a_value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store b_value arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-24] ; load float operand
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _436___rgo_7374642f6d6174682f63616c63__multiply_unwrapper
_436___rgo_7374642f6d6174682f63616c63__multiply_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load b_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
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
    jmp _436___rgo_7374642f6d6174682f63616c63__multiply
global _436___rgo_7374642f6d6174682f63616c63__multiply_deep_release
_436___rgo_7374642f6d6174682f63616c63__multiply_deep_release:
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
    jg _436___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1
    mov rax, [r12-16] ; load _436___rgo_7374642f6d6174682f63616c63__multiply_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_436___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _436___rgo_7374642f6d6174682f63616c63__multiply_deepcopy
_436___rgo_7374642f6d6174682f63616c63__multiply_deepcopy:
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
    jg _436___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_436___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1:
    leave
    ret

global _434___rgo_7374642f6d6174682f63616c63__multiply
_434___rgo_7374642f6d6174682f63616c63__multiply:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store a_value arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_436___rgo_7374642f6d6174682f63616c63__multiply_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_436___rgo_7374642f6d6174682f63616c63__multiply_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_436___rgo_7374642f6d6174682f63616c63__multiply_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _437___rgo_7374642f6d6174682f63616c63__multiply closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _434___rgo_7374642f6d6174682f63616c63__multiply_unwrapper
_434___rgo_7374642f6d6174682f63616c63__multiply_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load b env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load a_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp _434___rgo_7374642f6d6174682f63616c63__multiply
global _434___rgo_7374642f6d6174682f63616c63__multiply_deep_release
_434___rgo_7374642f6d6174682f63616c63__multiply_deep_release:
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
    jg _434___rgo_7374642f6d6174682f63616c63__multiply_release_skip_0
    mov rax, [r12-24] ; load _434___rgo_7374642f6d6174682f63616c63__multiply_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_434___rgo_7374642f6d6174682f63616c63__multiply_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _434___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1
    mov rax, [r12-16] ; load _434___rgo_7374642f6d6174682f63616c63__multiply_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_434___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy
_434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy:
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
    jg _434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1:
    leave
    ret

global _417___rgo_7374642f6d6174682f63616c63__add
_417___rgo_7374642f6d6174682f63616c63__add:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a_value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store b_value arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-24] ; load float operand
    addsd xmm0, xmm1 ; add second float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _417___rgo_7374642f6d6174682f63616c63__add_unwrapper
_417___rgo_7374642f6d6174682f63616c63__add_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a_value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load b_value env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
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
    jmp _417___rgo_7374642f6d6174682f63616c63__add
global _417___rgo_7374642f6d6174682f63616c63__add_deep_release
_417___rgo_7374642f6d6174682f63616c63__add_deep_release:
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
    jg _417___rgo_7374642f6d6174682f63616c63__add_release_skip_1
    mov rax, [r12-16] ; load _417___rgo_7374642f6d6174682f63616c63__add_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_417___rgo_7374642f6d6174682f63616c63__add_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _417___rgo_7374642f6d6174682f63616c63__add_deepcopy
_417___rgo_7374642f6d6174682f63616c63__add_deepcopy:
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
    jg _417___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_417___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_1:
    leave
    ret

global _458___rgo_7374642f6d6174682f63616c63__append_digit
_458___rgo_7374642f6d6174682f63616c63__append_digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store digit arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store shifted arg in frame
    movsd xmm0, [rbp-24] ; load float operand
    movsd xmm1, [rbp-8] ; load float operand
    addsd xmm0, xmm1 ; add second float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _458___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper
_458___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load digit env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load shifted env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
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
    jmp _458___rgo_7374642f6d6174682f63616c63__append_digit
global _458___rgo_7374642f6d6174682f63616c63__append_digit_deep_release
_458___rgo_7374642f6d6174682f63616c63__append_digit_deep_release:
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
    jg _458___rgo_7374642f6d6174682f63616c63__append_digit_release_skip_1
    mov rax, [r12-16] ; load _458___rgo_7374642f6d6174682f63616c63__append_digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_458___rgo_7374642f6d6174682f63616c63__append_digit_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _458___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy
_458___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy:
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
    jg _458___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_458___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_1:
    leave
    ret

global staged
staged:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 112 ; reserve stack space for locals
    mov [rbp-8], rdi ; store handle_error arg in frame
    mov [rbp-16], rsi ; store price arg in frame
    mov [rbp-24], rdx ; store tax arg in frame
    mov [rbp-32], rcx ; store ok arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 0x4024000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_8 closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_9 closure env_end to rax
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
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__negate_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__negate_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__negate_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_10 closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 0x4000000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__constant_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_12 closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel __comptime_13] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [calculated_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [calculated_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [calculated_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_14 closure env_end to rax
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
    lea rax, [_441___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_441___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_441___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_15 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, [rbp-80] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_434___rgo_7374642f6d6174682f63616c63__multiply_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_434___rgo_7374642f6d6174682f63616c63__multiply_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_434___rgo_7374642f6d6174682f63616c63__multiply_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_16 closure env_end to rax
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
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_417___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_417___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_417___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_17 closure env_end to rax
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
    mov rax, [rbp-40] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-96] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_441___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_441___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_441___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_18 closure env_end to rax
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
    mov rax, 0x4014000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_458___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_458___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_458___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_19 closure env_end to rax
    mov [rbp-112], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, 0x4000000000000000 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4024000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-112] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global staged_unwrapper
staged_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load handle_error env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load price env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load tax env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp staged
global staged_deep_release
staged_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load __num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg staged_release_skip_0
    mov rax, [r12-32] ; load staged_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
staged_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg staged_release_skip_3
    mov rax, [r12-8] ; load staged_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
staged_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global staged_deepcopy
staged_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12+40] ; load num_remaining env field
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg staged_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
staged_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg staged_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
staged_deepcopy_skip_3:
    leave
    ret

global main
main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store handle_error arg in frame
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
    lea rax, [_1482_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1482_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1482_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1482_main closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rbx, [rbp-8] ; original closure handle_error to ___1485_constant_arg_clone_0 env_end pointer for clone
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
    mov [rbp-24], rax ; store value
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
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [constant_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [constant_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [constant_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1485_constant closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, 0x4008000000000000 ; load literal float bits
    push rax ; stack arg
    mov rax, 0x4024000000000000 ; load literal float bits
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp staged
global main_unwrapper
main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load handle_error env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
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
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg main_release_skip_0
    mov rax, [r12-8] ; load main_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
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
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg main_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
main_deepcopy_skip_0:
    leave
    ret

global compile_error_unwrapper
compile_error_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load message env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load runtime_fallback env field
    mov [rbp-24], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rbx, [rbp-24] ; load runtime_fallback closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global compile_error_deep_release
compile_error_deep_release:
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
    jg compile_error_release_skip_0
    mov rax, [r12-16] ; load compile_error_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
compile_error_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg compile_error_release_skip_1
    mov rax, [r12-8] ; load compile_error_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
compile_error_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global compile_error_deepcopy
compile_error_deepcopy:
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
    jg compile_error_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
compile_error_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg compile_error_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
compile_error_deepcopy_skip_1:
    leave
    ret

global _start
_start:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
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
    lea rax, [_160_lambda_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_160_lambda_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_160_lambda_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _160_lambda closure env_end to rax
    mov [rbp-8], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    lea rax, [rel _158] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [compile_error_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [compile_error_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [compile_error_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy handle_error closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp main
section .rodata
__comptime_2:
    dq __comptime_2_data, 21, 0, 0 ; data, byte length, heap base, heap size
__comptime_2_data:
    db "constant calculation", 10, 0
__comptime_13:
    dq __comptime_13_data, 19, 0, 0 ; data, byte length, heap base, heap size
__comptime_13_data:
    db "staged calculation", 10, 0
_158:
    dq _158_data, 19, 0, 0 ; data, byte length, heap base, heap size
_158_data:
    db "invalid calculation", 0
