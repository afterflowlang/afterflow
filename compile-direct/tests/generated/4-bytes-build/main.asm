bits 64
default rel
section .text
__rgo_allocation_failed:
    mov rdi, 1 ; allocation failure exit code
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
global _37_nth
_37_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store idx arg in frame
    mov [rbp-16], rsi ; store one arg in frame
    mov [rbp-24], rdx ; store empty arg in frame
    mov rax, [rbp-16] ; load operand
    mov [rbp-32], rax ; store value
    mov r12, [rbp-32] ; load operand
    mov rcx, 67 ; operand literal
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rax, [rbp-8] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    je eq_uint__40_one_true_0_0
eq_uint_empty_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-24] ; load empty closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_uint__40_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-32] ; load _40_one closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _37_nth_unwrapper
_37_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load idx env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load one env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load empty env field
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
    jmp _37_nth
global _37_nth_deep_release
_37_nth_deep_release:
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
    jg _37_nth_release_skip_1
    mov rax, [r12-16] ; load _37_nth_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_37_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _37_nth_release_skip_2
    mov rax, [r12-8] ; load _37_nth_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_37_nth_release_skip_2:
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
    mov rsi, r15 ; length = heap size
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
global _37_nth_deepcopy
_37_nth_deepcopy:
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
    jg _37_nth_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_37_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _37_nth_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_37_nth_deepcopy_skip_2:
    leave
    ret

global _32_nth
_32_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store idx arg in frame
    mov [rbp-16], rsi ; store one arg in frame
    mov [rbp-24], rdx ; store empty arg in frame
    mov rbx, [rbp-16] ; original closure one to _35_one env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rsi, r14 ; length for cloned environment
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
    mov r12, [rbp-32] ; load operand
    mov rcx, 66 ; operand literal
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rsi, 72 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
    lea rax, [_37_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_37_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_37_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _41_nth closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    je eq_uint__35_one_true_0_0
eq_uint__41_nth_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _41_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_uint__35_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-32] ; load _35_one closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _32_nth_unwrapper
_32_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load idx env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load one env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load empty env field
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
    jmp _32_nth
global _32_nth_deep_release
_32_nth_deep_release:
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
    jg _32_nth_release_skip_1
    mov rax, [r12-16] ; load _32_nth_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_32_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _32_nth_release_skip_2
    mov rax, [r12-8] ; load _32_nth_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_32_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _32_nth_deepcopy
_32_nth_deepcopy:
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
    jg _32_nth_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_32_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _32_nth_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_32_nth_deepcopy_skip_2:
    leave
    ret

global nth
nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store base arg in frame
    mov [rbp-16], rsi ; store idx arg in frame
    mov [rbp-24], rdx ; store empty arg in frame
    mov [rbp-32], rcx ; store one arg in frame
    mov rbx, [rbp-32] ; original closure one to _30_one env_end pointer for clone
    mov rbx, rbx ; clone source env_end pointer
    mov r13, [rbx+24] ; load env size metadata for clone
    mov r14, [rbx+32] ; load heap size metadata for clone
    mov r12, rbx ; compute env base pointer for clone
    sub r12, r13 ; env base pointer for clone source
    mov rsi, r14 ; length for cloned environment
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
    mov r12, [rbp-40] ; load operand
    mov rcx, [rbp-8] ; load operand
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rsi, 72 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_32_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_32_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_32_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _42_nth closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_uint__30_one_true_0_0
eq_uint__42_nth_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _42_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_uint__30_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _30_one closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global nth_unwrapper
nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load base env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load idx env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load empty env field
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
    jmp nth
global nth_deep_release
nth_deep_release:
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
    jg nth_release_skip_2
    mov rax, [r12-16] ; load nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg nth_release_skip_3
    mov rax, [r12-8] ; load nth_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
nth_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global nth_deepcopy
nth_deepcopy:
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
    jg nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg nth_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
nth_deepcopy_skip_3:
    leave
    ret

global source
source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store base arg in frame
    mov [rbp-16], rsi ; store inspect arg in frame
    mov rsi, 80 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _50_nth closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-16] ; load inspect closure env_end pointer
    mov rax, 3 ; operand literal
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global source_unwrapper
source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load base env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load inspect env field
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
    jmp source
global source_deep_release
source_deep_release:
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
    jg source_release_skip_1
    mov rax, [r12-8] ; load source_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global source_deepcopy
source_deepcopy:
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
    jg source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
source_deepcopy_skip_1:
    leave
    ret

global _101_main
_101_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _101_main_unwrapper
_101_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _101_main
global _101_main_deep_release
_101_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _101_main_deepcopy
_101_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _107_main
_107_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _107_main_unwrapper
_107_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _107_main
global _107_main_deep_release
_107_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _107_main_deepcopy
_107_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _113_main
_113_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 0 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _113_main_unwrapper
_113_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _113_main
global _113_main_deep_release
_113_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _113_main_deepcopy
_113_main_deepcopy:
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
global _111_main
_111_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store text arg in frame
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_113_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_113_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_113_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _113_main closure env_end to rax
    mov [rbp-16], rax ; store value
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
global _111_main_unwrapper
_111_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load text env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp _111_main
global _111_main_deep_release
_111_main_deep_release:
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
    jg _111_main_release_skip_0
    mov rax, [r12-8] ; load _111_main_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_111_main_release_skip_0:
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
    jc __rgo_allocation_failed ; allocation size overflow
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
global _111_main_deepcopy
_111_main_deepcopy:
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
    jg _111_main_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_111_main_deepcopy_skip_0:
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
global _105_main
_105_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_107_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_107_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_107_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _107_main closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rsi, 56 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_111_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_111_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_111_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _111_main closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-8] ; load operand
    mov rdi, [rbx]
    mov rsi, [rbx+8]
    call utf8_validate
    test eax, eax
    jz _105_main_str_from_utf8_invalid_0
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, [rbp-8] ; load operand
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
_105_main_str_from_utf8_invalid_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _105_main_unwrapper
_105_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load value env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp _105_main
global _105_main_deep_release
_105_main_deep_release:
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
    jg _105_main_release_skip_0
    mov rax, [r12-8] ; load _105_main_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_105_main_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _105_main_deepcopy
_105_main_deepcopy:
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
    jg _105_main_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_105_main_deepcopy_skip_0:
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
    jc __rgo_allocation_failed ; allocation size overflow
    mov rax, 9
    xor rdi, rdi
    mov rdx, 3
    mov r10, 34
    mov r8, -1
    xor r9, r9
    syscall
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
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
global _98_main
_98_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov rsi, 64 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov rax, 65 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy labelled closure env_end to rax
    mov [rbp-8], rax ; store value
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_101_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_101_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_101_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _101_main closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rsi, 56 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_105_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_105_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_105_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _105_main closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rsi, 80 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax
    mov rax, [rbp-16] ; load operand
    mov [rbx], rax
    mov rax, [rbp-24] ; load operand
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
    mov rbx, [rbp-8] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
global _98_main_unwrapper
_98_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _98_main
global _98_main_deep_release
_98_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _98_main_deepcopy
_98_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global empty_nth
empty_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _51_empty_nth arg in frame
    mov [rbp-16], rsi ; store empty arg in frame
    mov [rbp-24], rdx ; store _52_empty_nth arg in frame
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
global empty_nth_unwrapper
empty_nth_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load _51_empty_nth env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load empty env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _52_empty_nth env field
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
    jmp empty_nth
global empty_nth_deep_release
empty_nth_deep_release:
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
    jg empty_nth_release_skip_1
    mov rax, [r12-16] ; load empty_nth_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
empty_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg empty_nth_release_skip_2
    mov rax, [r12-8] ; load empty_nth_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
empty_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global empty_nth_deepcopy
empty_nth_deepcopy:
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
    jg empty_nth_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
empty_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg empty_nth_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
empty_nth_deepcopy_skip_2:
    leave
    ret

global invalid_source
invalid_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect arg in frame
    mov rsi, 72 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [empty_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [empty_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [empty_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy empty_nth closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rbx, [rbp-8] ; load inspect closure env_end pointer
    mov rax, 1 ; operand literal
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-16] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global invalid_source_unwrapper
invalid_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load inspect env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp invalid_source
global invalid_source_deep_release
invalid_source_deep_release:
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
    jg invalid_source_release_skip_0
    mov rax, [r12-8] ; load invalid_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
invalid_source_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global invalid_source_deepcopy
invalid_source_deepcopy:
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
    jg invalid_source_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
invalid_source_deepcopy_skip_0:
    leave
    ret

global unexpected_bytes
unexpected_bytes:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _68_unexpected_bytes arg in frame
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global unexpected_bytes_unwrapper
unexpected_bytes_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load _68_unexpected_bytes env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp unexpected_bytes
global unexpected_bytes_deep_release
unexpected_bytes_deep_release:
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
    jg unexpected_bytes_release_skip_0
    mov rax, [r12-8] ; load unexpected_bytes_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
unexpected_bytes_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global unexpected_bytes_deepcopy
unexpected_bytes_deepcopy:
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
    jg unexpected_bytes_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
unexpected_bytes_deepcopy_skip_0:
    leave
    ret

global test_invalid
test_invalid:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rsi, 56 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [invalid_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [invalid_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [invalid_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy invalid_source closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rsi, 56 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [unexpected_bytes_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [unexpected_bytes_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [unexpected_bytes_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy unexpected_bytes closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rsi, 80 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax
    mov rax, [rbp-8] ; load operand
    mov [rbx], rax
    mov rax, [rbp-24] ; load operand
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
    mov rbx, [rbp-16] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
global test_invalid_unwrapper
test_invalid_unwrapper:
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
    jmp test_invalid
global test_invalid_deep_release
test_invalid_deep_release:
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
    jg test_invalid_release_skip_0
    mov rax, [r12-8] ; load test_invalid_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_invalid_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_invalid_deepcopy
test_invalid_deepcopy:
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
    jg test_invalid_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_invalid_deepcopy_skip_0:
    leave
    ret

global _96_main
_96_main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_98_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_98_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_98_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _98_main closure env_end to rax
    mov [rbp-8], rax ; store value
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_invalid
global _96_main_unwrapper
_96_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _96_main
global _96_main_deep_release
_96_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _96_main_deepcopy
_96_main_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _91_test_empty
_91_test_empty:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store _71_empty_inspect arg in frame
    mov [rbp-24], rdx ; store _72_empty_inspect arg in frame
    mov [rbp-32], rcx ; store _73_empty_inspect arg in frame
    mov rbx, [rbp-8] ; load operand
    mov rcx, [rbp-16] ; load operand
    cmp rcx, [rbx+8]
    jae _91_test_empty_bytes_nth_empty_0
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
_91_test_empty_bytes_nth_empty_0:
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
global _91_test_empty_unwrapper
_91_test_empty_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load _71_empty_inspect env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load _72_empty_inspect env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load _73_empty_inspect env field
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
    jmp _91_test_empty
global _91_test_empty_deep_release
_91_test_empty_deep_release:
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
    jg _91_test_empty_release_skip_0
    mov rax, [r12-32] ; load _91_test_empty_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_91_test_empty_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _91_test_empty_release_skip_2
    mov rax, [r12-16] ; load _91_test_empty_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_91_test_empty_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _91_test_empty_release_skip_3
    mov rax, [r12-8] ; load _91_test_empty_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_91_test_empty_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _91_test_empty_deepcopy
_91_test_empty_deepcopy:
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
    jg _91_test_empty_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_91_test_empty_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _91_test_empty_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_91_test_empty_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _91_test_empty_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_91_test_empty_deepcopy_skip_3:
    leave
    ret

global _77_empty_inspect
_77_empty_inspect:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _77_empty_inspect_unwrapper
_77_empty_inspect_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _77_empty_inspect
global _77_empty_inspect_deep_release
_77_empty_inspect_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _77_empty_inspect_deepcopy
_77_empty_inspect_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global empty_inspect
empty_inspect:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store l arg in frame
    mov [rbp-24], rdx ; store _70_empty_inspect arg in frame
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_77_empty_inspect_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_77_empty_inspect_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_77_empty_inspect_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _77_empty_inspect closure env_end to rax
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_uint_ok_true_0_0
eq_uint__77_empty_inspect_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-32] ; load _77_empty_inspect closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_uint_ok_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global empty_inspect_unwrapper
empty_inspect_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load l env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _70_empty_inspect env field
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
    jmp empty_inspect
global empty_inspect_deep_release
empty_inspect_deep_release:
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
    jg empty_inspect_release_skip_0
    mov rax, [r12-24] ; load empty_inspect_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
empty_inspect_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg empty_inspect_release_skip_2
    mov rax, [r12-8] ; load empty_inspect_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
empty_inspect_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global empty_inspect_deepcopy
empty_inspect_deepcopy:
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
    jg empty_inspect_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
empty_inspect_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg empty_inspect_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
empty_inspect_deepcopy_skip_2:
    leave
    ret

global _89_test_empty
_89_test_empty:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov [rbp-24], rdx ; store _87_bytes_len arg in frame
    mov rsi, 80 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_91_test_empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_91_test_empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_91_test_empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _92_test_empty closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp empty_inspect
global _89_test_empty_unwrapper
_89_test_empty_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load value env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _87_bytes_len env field
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
    jmp _89_test_empty
global _89_test_empty_deep_release
_89_test_empty_deep_release:
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
    jg _89_test_empty_release_skip_0
    mov rax, [r12-24] ; load _89_test_empty_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_89_test_empty_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _89_test_empty_release_skip_1
    mov rax, [r12-16] ; load _89_test_empty_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_89_test_empty_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _89_test_empty_deepcopy
_89_test_empty_deepcopy:
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
    jg _89_test_empty_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_89_test_empty_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _89_test_empty_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_89_test_empty_deepcopy_skip_1:
    leave
    ret

global _85_test_empty
_85_test_empty:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov rdi, [rbp-16] ; load operand
    call clone_descriptor_ptr ; clone owned descriptor
    mov [rbp-24], rax ; store value
    mov rsi, 72 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_89_test_empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_89_test_empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_89_test_empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _93_test_empty closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-16] ; load operand
    mov rax, [rbx+8]
    push rax ; preserve byte length
    push r12 ; preserve current environment
    mov rdi, [rbp-16] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
    pop rax ; restore byte length
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _85_test_empty_unwrapper
_85_test_empty_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load value env field
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
    jmp _85_test_empty
global _85_test_empty_deep_release
_85_test_empty_deep_release:
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
    jg _85_test_empty_release_skip_0
    mov rax, [r12-16] ; load _85_test_empty_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_85_test_empty_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _85_test_empty_release_skip_1
    mov rax, [r12-8] ; load _85_test_empty_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_85_test_empty_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _85_test_empty_deepcopy
_85_test_empty_deepcopy:
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
    jg _85_test_empty_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_85_test_empty_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _85_test_empty_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_85_test_empty_deepcopy_skip_1:
    leave
    ret

global empty_source
empty_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect arg in frame
    mov rsi, 72 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [empty_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [empty_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [empty_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy empty_nth closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rbx, [rbp-8] ; load inspect closure env_end pointer
    mov rax, 0 ; operand literal
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-16] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global empty_source_unwrapper
empty_source_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load inspect env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp empty_source
global empty_source_deep_release
empty_source_deep_release:
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
    jg empty_source_release_skip_0
    mov rax, [r12-8] ; load empty_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
empty_source_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global empty_source_deepcopy
empty_source_deepcopy:
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
    jg empty_source_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
empty_source_deepcopy_skip_0:
    leave
    ret

global _81_test_empty
_81_test_empty:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _81_test_empty_unwrapper
_81_test_empty_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _81_test_empty
global _81_test_empty_deep_release
_81_test_empty_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _81_test_empty_deepcopy
_81_test_empty_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global test_empty
test_empty:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov rsi, 64 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_85_test_empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_85_test_empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_85_test_empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _94_test_empty closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rsi, 56 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [empty_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [empty_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [empty_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy empty_source closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_81_test_empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_81_test_empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_81_test_empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _81_test_empty closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rsi, 80 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax
    mov rax, [rbp-32] ; load operand
    mov [rbx], rax
    mov rax, [rbp-16] ; load operand
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
    mov rbx, [rbp-24] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
global test_empty_unwrapper
test_empty_unwrapper:
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
    jmp test_empty
global test_empty_deep_release
test_empty_deep_release:
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
    jg test_empty_release_skip_0
    mov rax, [r12-8] ; load test_empty_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
test_empty_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global test_empty_deepcopy
test_empty_deepcopy:
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
    jg test_empty_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
test_empty_deepcopy_skip_0:
    leave
    ret

global main
main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov rsi, 48 ; length for allocation
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax ; negative rax is -errno
    js __rgo_allocation_failed ; mmap failed
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    mov rax, 0 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 48 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_96_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_96_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_96_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _96_main closure env_end to rax
    mov [rbp-8], rax ; store value
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp test_empty
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
