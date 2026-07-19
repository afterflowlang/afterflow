bits 64
default rel
section .text
global _342_foo
_342_foo:
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
global _342_foo_unwrapper
_342_foo_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _342_foo
global _342_foo_deep_release
_342_foo_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _342_foo_deepcopy
_342_foo_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _136___rgo_7374642f666d74__int_source
_136___rgo_7374642f666d74__int_source:
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
global _136___rgo_7374642f666d74__int_source_unwrapper
_136___rgo_7374642f666d74__int_source_unwrapper:
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
    jmp _136___rgo_7374642f666d74__int_source
global _136___rgo_7374642f666d74__int_source_deep_release
_136___rgo_7374642f666d74__int_source_deep_release:
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
    jg _136___rgo_7374642f666d74__int_source_release_skip_0
    mov rax, [r12-16] ; load _136___rgo_7374642f666d74__int_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_136___rgo_7374642f666d74__int_source_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _136___rgo_7374642f666d74__int_source_release_skip_1
    mov rax, [r12-8] ; load _136___rgo_7374642f666d74__int_source_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_136___rgo_7374642f666d74__int_source_release_skip_1:
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
global _136___rgo_7374642f666d74__int_source_deepcopy
_136___rgo_7374642f666d74__int_source_deepcopy:
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
    jg _136___rgo_7374642f666d74__int_source_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_136___rgo_7374642f666d74__int_source_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _136___rgo_7374642f666d74__int_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_136___rgo_7374642f666d74__int_source_deepcopy_skip_1:
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
    je eq_uint__106_one_true_0_0
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
eq_uint__106_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _106_one closure env_end pointer
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
    mov rax, r12 ; copy _108___rgo_7374642f666d74__single_nth closure env_end to rax
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

global _119___rgo_7374642f666d74__concat_nth
_119___rgo_7374642f666d74__concat_nth:
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
global _119___rgo_7374642f666d74__concat_nth_unwrapper
_119___rgo_7374642f666d74__concat_nth_unwrapper:
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
    jmp _119___rgo_7374642f666d74__concat_nth
global _119___rgo_7374642f666d74__concat_nth_deep_release
_119___rgo_7374642f666d74__concat_nth_deep_release:
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
    jg _119___rgo_7374642f666d74__concat_nth_release_skip_0
    mov rax, [r12-32] ; load _119___rgo_7374642f666d74__concat_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_119___rgo_7374642f666d74__concat_nth_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _119___rgo_7374642f666d74__concat_nth_release_skip_1
    mov rax, [r12-24] ; load _119___rgo_7374642f666d74__concat_nth_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_119___rgo_7374642f666d74__concat_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _119___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-16] ; load _119___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_119___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _119___rgo_7374642f666d74__concat_nth_deepcopy
_119___rgo_7374642f666d74__concat_nth_deepcopy:
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
    jg _119___rgo_7374642f666d74__concat_nth_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_119___rgo_7374642f666d74__concat_nth_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _119___rgo_7374642f666d74__concat_nth_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_119___rgo_7374642f666d74__concat_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _119___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_119___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    leave
    ret

global _117___rgo_7374642f666d74__concat_nth
_117___rgo_7374642f666d74__concat_nth:
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
    lea rax, [_119___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_119___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_119___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _120___rgo_7374642f666d74__concat_nth closure env_end to rax
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
global _117___rgo_7374642f666d74__concat_nth_unwrapper
_117___rgo_7374642f666d74__concat_nth_unwrapper:
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
    jmp _117___rgo_7374642f666d74__concat_nth
global _117___rgo_7374642f666d74__concat_nth_deep_release
_117___rgo_7374642f666d74__concat_nth_deep_release:
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
    jg _117___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-24] ; load _117___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_117___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _117___rgo_7374642f666d74__concat_nth_release_skip_3
    mov rax, [r12-16] ; load _117___rgo_7374642f666d74__concat_nth_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_117___rgo_7374642f666d74__concat_nth_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _117___rgo_7374642f666d74__concat_nth_release_skip_4
    mov rax, [r12-8] ; load _117___rgo_7374642f666d74__concat_nth_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_117___rgo_7374642f666d74__concat_nth_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _117___rgo_7374642f666d74__concat_nth_deepcopy
_117___rgo_7374642f666d74__concat_nth_deepcopy:
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
    jg _117___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_117___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _117___rgo_7374642f666d74__concat_nth_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_117___rgo_7374642f666d74__concat_nth_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _117___rgo_7374642f666d74__concat_nth_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_117___rgo_7374642f666d74__concat_nth_deepcopy_skip_4:
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
    mov rbx, [rbp-40] ; original closure empty_case to ___115_a_arg_clone_1 env_end pointer for clone
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
    mov rbx, [rbp-48] ; original closure one to ___115_a_arg_clone_2 env_end pointer for clone
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
    lea rax, [_117___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_117___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_117___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _121___rgo_7374642f666d74__concat_nth closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, [rbp-32] ; load operand
    mov rbx, [rbp-8] ; load operand
    cmp rax, rbx
    jb lt_uint__115_a_true_0_0
lt_uint__121___rgo_7374642f666d74__concat_nth_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-80] ; load _121___rgo_7374642f666d74__concat_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt_uint__115_a_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-80] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _115_a closure env_end pointer
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

global _127___rgo_7374642f666d74__concat
_127___rgo_7374642f666d74__concat:
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
    mov rax, r12 ; copy _128___rgo_7374642f666d74__concat_nth closure env_end to rax
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
global _127___rgo_7374642f666d74__concat_unwrapper
_127___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _127___rgo_7374642f666d74__concat
global _127___rgo_7374642f666d74__concat_deep_release
_127___rgo_7374642f666d74__concat_deep_release:
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
    jg _127___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-40] ; load _127___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_127___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _127___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _127___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_127___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _127___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-16] ; load _127___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_127___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _127___rgo_7374642f666d74__concat_deepcopy
_127___rgo_7374642f666d74__concat_deepcopy:
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
    jg _127___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_127___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _127___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_127___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _127___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_127___rgo_7374642f666d74__concat_deepcopy_skip_3:
    leave
    ret

global _125___rgo_7374642f666d74__concat
_125___rgo_7374642f666d74__concat:
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
    lea rax, [_127___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_127___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_127___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _129___rgo_7374642f666d74__concat closure env_end to rax
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
global _125___rgo_7374642f666d74__concat_unwrapper
_125___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _125___rgo_7374642f666d74__concat
global _125___rgo_7374642f666d74__concat_deep_release
_125___rgo_7374642f666d74__concat_deep_release:
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
    jg _125___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-32] ; load _125___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_125___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _125___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _125___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_125___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _125___rgo_7374642f666d74__concat_release_skip_4
    mov rax, [r12-8] ; load _125___rgo_7374642f666d74__concat_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_125___rgo_7374642f666d74__concat_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _125___rgo_7374642f666d74__concat_deepcopy
_125___rgo_7374642f666d74__concat_deepcopy:
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
    jg _125___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_125___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _125___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_125___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _125___rgo_7374642f666d74__concat_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_125___rgo_7374642f666d74__concat_deepcopy_skip_4:
    leave
    ret

global _123___rgo_7374642f666d74__concat
_123___rgo_7374642f666d74__concat:
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
    lea rax, [_125___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_125___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_125___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _130___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _123___rgo_7374642f666d74__concat_unwrapper
_123___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _123___rgo_7374642f666d74__concat
global _123___rgo_7374642f666d74__concat_deep_release
_123___rgo_7374642f666d74__concat_deep_release:
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
    jg _123___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-32] ; load _123___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_123___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _123___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-24] ; load _123___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_123___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _123___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-8] ; load _123___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_123___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _123___rgo_7374642f666d74__concat_deepcopy
_123___rgo_7374642f666d74__concat_deepcopy:
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
    jg _123___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_123___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _123___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_123___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _123___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_123___rgo_7374642f666d74__concat_deepcopy_skip_3:
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
    lea rax, [_123___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_123___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_123___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _131___rgo_7374642f666d74__concat closure env_end to rax
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

global _243___rgo_7374642f666d74__from_int
_243___rgo_7374642f666d74__from_int:
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
    mov rax, r12 ; copy _245___rgo_7374642f666d74__single closure env_end to rax
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
    mov rax, r12 ; copy _246___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _243___rgo_7374642f666d74__from_int_unwrapper
_243___rgo_7374642f666d74__from_int_unwrapper:
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
    jmp _243___rgo_7374642f666d74__from_int
global _243___rgo_7374642f666d74__from_int_deep_release
_243___rgo_7374642f666d74__from_int_deep_release:
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
    jg _243___rgo_7374642f666d74__from_int_release_skip_0
    mov rax, [r12-16] ; load _243___rgo_7374642f666d74__from_int_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_243___rgo_7374642f666d74__from_int_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _243___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-8] ; load _243___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_243___rgo_7374642f666d74__from_int_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _243___rgo_7374642f666d74__from_int_deepcopy
_243___rgo_7374642f666d74__from_int_deepcopy:
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
    jg _243___rgo_7374642f666d74__from_int_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_243___rgo_7374642f666d74__from_int_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _243___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_243___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    leave
    ret

global _229___rgo_7374642f666d74__negative_digits
_229___rgo_7374642f666d74__negative_digits:
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
    mov rax, r12 ; copy _230___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _229___rgo_7374642f666d74__negative_digits_unwrapper
_229___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _229___rgo_7374642f666d74__negative_digits
global _229___rgo_7374642f666d74__negative_digits_deep_release
_229___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _229___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-24] ; load _229___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_229___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _229___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-16] ; load _229___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_229___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _229___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-8] ; load _229___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_229___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _229___rgo_7374642f666d74__negative_digits_deepcopy
_229___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _229___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_229___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _229___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_229___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _229___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_229___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    leave
    ret

global _227___rgo_7374642f666d74__negative_digits
_227___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_229___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_229___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_229___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _231___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _227___rgo_7374642f666d74__negative_digits_unwrapper
_227___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _227___rgo_7374642f666d74__negative_digits
global _227___rgo_7374642f666d74__negative_digits_deep_release
_227___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _227___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _227___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_227___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _227___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _227___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_227___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _227___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _227___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_227___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _227___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-8] ; load _227___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_227___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _227___rgo_7374642f666d74__negative_digits_deepcopy
_227___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _227___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_227___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _227___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_227___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _227___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_227___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _227___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_227___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _223___rgo_7374642f666d74__negative_digits
_223___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store quotient arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-32], rcx ; store invalid arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rbx, [rbp-16] ; original closure ok to _225_ok env_end pointer for clone
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
    mov rbx, [rbp-40] ; original closure suffix to ___225_ok_arg_clone_0 env_end pointer for clone
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
    lea rax, [_227___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_227___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_227___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _232___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_int__225_ok_true_0_0
eq_int__232___rgo_7374642f666d74__negative_digits_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-64] ; load _232___rgo_7374642f666d74__negative_digits closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_int__225_ok_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-64] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _225_ok closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _223___rgo_7374642f666d74__negative_digits_unwrapper
_223___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _223___rgo_7374642f666d74__negative_digits
global _223___rgo_7374642f666d74__negative_digits_deep_release
_223___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _223___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-32] ; load _223___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_223___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _223___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _223___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_223___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _223___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _223___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_223___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _223___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-8] ; load _223___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_223___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _223___rgo_7374642f666d74__negative_digits_deepcopy
_223___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _223___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_223___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _223___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_223___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _223___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_223___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _223___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_223___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _179___rgo_7374642f666d74__digit
_179___rgo_7374642f666d74__digit:
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
    mov rax, r12 ; copy _180___rgo_7374642f666d74__single closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _179___rgo_7374642f666d74__digit_unwrapper
_179___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _179___rgo_7374642f666d74__digit
global _179___rgo_7374642f666d74__digit_deep_release
_179___rgo_7374642f666d74__digit_deep_release:
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
    jg _179___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _179___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_179___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _179___rgo_7374642f666d74__digit_deepcopy
_179___rgo_7374642f666d74__digit_deepcopy:
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
    jg _179___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_179___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _177___rgo_7374642f666d74__digit
_177___rgo_7374642f666d74__digit:
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
    lea rax, [_179___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_179___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_179___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _181___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-16] ; load operand
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _177___rgo_7374642f666d74__digit_unwrapper
_177___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _177___rgo_7374642f666d74__digit
global _177___rgo_7374642f666d74__digit_deep_release
_177___rgo_7374642f666d74__digit_deep_release:
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
    jg _177___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _177___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_177___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _177___rgo_7374642f666d74__digit_deepcopy
_177___rgo_7374642f666d74__digit_deepcopy:
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
    jg _177___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_177___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _175___rgo_7374642f666d74__digit
_175___rgo_7374642f666d74__digit:
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
    lea rax, [_177___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_177___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_177___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _182___rgo_7374642f666d74__digit closure env_end to rax
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
global _175___rgo_7374642f666d74__digit_unwrapper
_175___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _175___rgo_7374642f666d74__digit
global _175___rgo_7374642f666d74__digit_deep_release
_175___rgo_7374642f666d74__digit_deep_release:
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
    jg _175___rgo_7374642f666d74__digit_release_skip_1
    mov rax, [r12-16] ; load _175___rgo_7374642f666d74__digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_175___rgo_7374642f666d74__digit_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _175___rgo_7374642f666d74__digit_deepcopy
_175___rgo_7374642f666d74__digit_deepcopy:
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
    jg _175___rgo_7374642f666d74__digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_175___rgo_7374642f666d74__digit_deepcopy_skip_1:
    leave
    ret

global _172___rgo_7374642f666d74__digit
_172___rgo_7374642f666d74__digit:
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
    lea rax, [_175___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_175___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_175___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _183___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 48 ; operand literal
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _172___rgo_7374642f666d74__digit_unwrapper
_172___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _172___rgo_7374642f666d74__digit
global _172___rgo_7374642f666d74__digit_deep_release
_172___rgo_7374642f666d74__digit_deep_release:
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
    jg _172___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _172___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_172___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _172___rgo_7374642f666d74__digit_deepcopy
_172___rgo_7374642f666d74__digit_deepcopy:
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
    jg _172___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_172___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _170___rgo_7374642f666d74__digit
_170___rgo_7374642f666d74__digit:
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
    lea rax, [_172___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_172___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_172___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _184___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-16] ; load operand
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _170___rgo_7374642f666d74__digit_unwrapper
_170___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _170___rgo_7374642f666d74__digit
global _170___rgo_7374642f666d74__digit_deep_release
_170___rgo_7374642f666d74__digit_deep_release:
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
    jg _170___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _170___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_170___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _170___rgo_7374642f666d74__digit_deepcopy
_170___rgo_7374642f666d74__digit_deepcopy:
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
    jg _170___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_170___rgo_7374642f666d74__digit_deepcopy_skip_0:
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
    lea rax, [_170___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_170___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_170___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _185___rgo_7374642f666d74__digit closure env_end to rax
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

global _221___rgo_7374642f666d74__negative_digits
_221___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-40], r8 ; store remainder arg in frame
    mov rbx, [rbp-8] ; original closure invalid to ___233___rgo_7374642f666d74__negative_digits_arg_clone_3 env_end pointer for clone
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
    lea rax, [_223___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_223___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_223___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _233___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _221___rgo_7374642f666d74__negative_digits_unwrapper
_221___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _221___rgo_7374642f666d74__negative_digits
global _221___rgo_7374642f666d74__negative_digits_deep_release
_221___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _221___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _221___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_221___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _221___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _221___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_221___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _221___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _221___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_221___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _221___rgo_7374642f666d74__negative_digits_deepcopy
_221___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _221___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_221___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _221___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_221___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _221___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_221___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global _218___rgo_7374642f666d74__negative_digits
_218___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_221___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_221___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_221___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _234___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _218___rgo_7374642f666d74__negative_digits_unwrapper
_218___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _218___rgo_7374642f666d74__negative_digits
global _218___rgo_7374642f666d74__negative_digits_deep_release
_218___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _218___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _218___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_218___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _218___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _218___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_218___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _218___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _218___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_218___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _218___rgo_7374642f666d74__negative_digits_deepcopy
_218___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _218___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_218___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _218___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_218___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _218___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_218___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global _216___rgo_7374642f666d74__negative_digits
_216___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_218___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_218___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_218___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _235___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _216___rgo_7374642f666d74__negative_digits_unwrapper
_216___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _216___rgo_7374642f666d74__negative_digits
global _216___rgo_7374642f666d74__negative_digits_deep_release
_216___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _216___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-40] ; load _216___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_216___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _216___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-24] ; load _216___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_216___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _216___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-16] ; load _216___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_216___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _216___rgo_7374642f666d74__negative_digits_deepcopy
_216___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _216___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_216___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _216___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_216___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _216___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_216___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _213___rgo_7374642f666d74__negative_digits
_213___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_216___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_216___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_216___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _236___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _213___rgo_7374642f666d74__negative_digits_unwrapper
_213___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _213___rgo_7374642f666d74__negative_digits
global _213___rgo_7374642f666d74__negative_digits_deep_release
_213___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _213___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-32] ; load _213___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_213___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _213___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _213___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_213___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _213___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _213___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_213___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _213___rgo_7374642f666d74__negative_digits_deepcopy
_213___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _213___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_213___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _213___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_213___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _213___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_213___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
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
    mov rbx, [rbp-16] ; original closure invalid to ___237___rgo_7374642f666d74__negative_digits_arg_clone_1 env_end pointer for clone
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
    lea rax, [_213___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_213___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_213___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _237___rgo_7374642f666d74__negative_digits closure env_end to rax
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

global _241___rgo_7374642f666d74__from_int
_241___rgo_7374642f666d74__from_int:
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
    lea rax, [_243___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_243___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_243___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _247___rgo_7374642f666d74__from_int closure env_end to rax
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
global _241___rgo_7374642f666d74__from_int_unwrapper
_241___rgo_7374642f666d74__from_int_unwrapper:
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
    jmp _241___rgo_7374642f666d74__from_int
global _241___rgo_7374642f666d74__from_int_deep_release
_241___rgo_7374642f666d74__from_int_deep_release:
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
    jg _241___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load _241___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_241___rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _241___rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load _241___rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_241___rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _241___rgo_7374642f666d74__from_int_deepcopy
_241___rgo_7374642f666d74__from_int_deepcopy:
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
    jg _241___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_241___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _241___rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_241___rgo_7374642f666d74__from_int_deepcopy_skip_2:
    leave
    ret

global _202___rgo_7374642f666d74__positive_digits
_202___rgo_7374642f666d74__positive_digits:
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
    mov rax, r12 ; copy _203___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _202___rgo_7374642f666d74__positive_digits_unwrapper
_202___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _202___rgo_7374642f666d74__positive_digits
global _202___rgo_7374642f666d74__positive_digits_deep_release
_202___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _202___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-24] ; load _202___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_202___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _202___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-16] ; load _202___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_202___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _202___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-8] ; load _202___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_202___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _202___rgo_7374642f666d74__positive_digits_deepcopy
_202___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _202___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_202___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _202___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_202___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _202___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_202___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    leave
    ret

global _200___rgo_7374642f666d74__positive_digits
_200___rgo_7374642f666d74__positive_digits:
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
    lea rax, [_202___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_202___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_202___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _204___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _200___rgo_7374642f666d74__positive_digits_unwrapper
_200___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _200___rgo_7374642f666d74__positive_digits
global _200___rgo_7374642f666d74__positive_digits_deep_release
_200___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _200___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-40] ; load _200___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_200___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _200___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _200___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_200___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _200___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _200___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_200___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _200___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-8] ; load _200___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_200___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _200___rgo_7374642f666d74__positive_digits_deepcopy
_200___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _200___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_200___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _200___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_200___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _200___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_200___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _200___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_200___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _196___rgo_7374642f666d74__positive_digits
_196___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store quotient arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-32], rcx ; store invalid arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rbx, [rbp-16] ; original closure ok to _198_ok env_end pointer for clone
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
    mov rbx, [rbp-40] ; original closure suffix to ___198_ok_arg_clone_0 env_end pointer for clone
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
    lea rax, [_200___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_200___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_200___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _205___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_int__198_ok_true_0_0
eq_int__205___rgo_7374642f666d74__positive_digits_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-64] ; load _205___rgo_7374642f666d74__positive_digits closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_int__198_ok_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-64] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _198_ok closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _196___rgo_7374642f666d74__positive_digits_unwrapper
_196___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _196___rgo_7374642f666d74__positive_digits
global _196___rgo_7374642f666d74__positive_digits_deep_release
_196___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _196___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-32] ; load _196___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_196___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _196___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _196___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_196___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _196___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _196___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_196___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _196___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-8] ; load _196___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_196___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _196___rgo_7374642f666d74__positive_digits_deepcopy
_196___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _196___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_196___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _196___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_196___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _196___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_196___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _196___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_196___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _194___rgo_7374642f666d74__positive_digits
_194___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-40], r8 ; store remainder arg in frame
    mov rbx, [rbp-8] ; original closure invalid to ___206___rgo_7374642f666d74__positive_digits_arg_clone_3 env_end pointer for clone
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
    lea rax, [_196___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_196___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_196___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _206___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _194___rgo_7374642f666d74__positive_digits_unwrapper
_194___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _194___rgo_7374642f666d74__positive_digits
global _194___rgo_7374642f666d74__positive_digits_deep_release
_194___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _194___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-40] ; load _194___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_194___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _194___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_194___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _194___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_194___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _194___rgo_7374642f666d74__positive_digits_deepcopy
_194___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _194___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_194___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_194___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_194___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    leave
    ret

global _192___rgo_7374642f666d74__positive_digits
_192___rgo_7374642f666d74__positive_digits:
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
    lea rax, [_194___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_194___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_194___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _207___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _192___rgo_7374642f666d74__positive_digits_unwrapper
_192___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _192___rgo_7374642f666d74__positive_digits
global _192___rgo_7374642f666d74__positive_digits_deep_release
_192___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _192___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-40] ; load _192___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_192___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _192___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-24] ; load _192___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_192___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _192___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-16] ; load _192___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_192___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _192___rgo_7374642f666d74__positive_digits_deepcopy
_192___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _192___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_192___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _192___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_192___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _192___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_192___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _189___rgo_7374642f666d74__positive_digits
_189___rgo_7374642f666d74__positive_digits:
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
    lea rax, [_192___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_192___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_192___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _208___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _189___rgo_7374642f666d74__positive_digits_unwrapper
_189___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _189___rgo_7374642f666d74__positive_digits
global _189___rgo_7374642f666d74__positive_digits_deep_release
_189___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _189___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-32] ; load _189___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_189___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _189___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _189___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_189___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _189___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _189___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_189___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _189___rgo_7374642f666d74__positive_digits_deepcopy
_189___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _189___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_189___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _189___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_189___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _189___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_189___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
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
    mov rbx, [rbp-16] ; original closure invalid to ___209___rgo_7374642f666d74__positive_digits_arg_clone_1 env_end pointer for clone
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
    lea rax, [_189___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_189___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_189___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _209___rgo_7374642f666d74__positive_digits closure env_end to rax
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

global _250___rgo_7374642f666d74__from_int
_250___rgo_7374642f666d74__from_int:
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
global _250___rgo_7374642f666d74__from_int_unwrapper
_250___rgo_7374642f666d74__from_int_unwrapper:
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
    jmp _250___rgo_7374642f666d74__from_int
global _250___rgo_7374642f666d74__from_int_deep_release
_250___rgo_7374642f666d74__from_int_deep_release:
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
    jg _250___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load _250___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_250___rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _250___rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load _250___rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_250___rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _250___rgo_7374642f666d74__from_int_deepcopy
_250___rgo_7374642f666d74__from_int_deepcopy:
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
    jg _250___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_250___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _250___rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_250___rgo_7374642f666d74__from_int_deepcopy_skip_2:
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
    mov rbx, [rbp-16] ; original closure invalid to ___248___rgo_7374642f666d74__from_int_arg_clone_1 env_end pointer for clone
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
    mov rbx, [rbp-24] ; original closure ok to ___248___rgo_7374642f666d74__from_int_arg_clone_2 env_end pointer for clone
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
    lea rax, [_241___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_241___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_241___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _248___rgo_7374642f666d74__from_int closure env_end to rax
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
    lea rax, [_250___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_250___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_250___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _251___rgo_7374642f666d74__from_int closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jl lt__248___rgo_7374642f666d74__from_int_true_0_0
lt__251___rgo_7374642f666d74__from_int_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _251___rgo_7374642f666d74__from_int closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt__248___rgo_7374642f666d74__from_int_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _248___rgo_7374642f666d74__from_int closure env_end pointer
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
    lea rax, [_136___rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_136___rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_136___rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _137___rgo_7374642f666d74__int_source closure env_end to rax
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

global __rgo_7374642f666d74__empty_nth
__rgo_7374642f666d74__empty_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _100___rgo_7374642f666d74__empty_nth arg in frame
    mov [rbp-16], rsi ; store empty arg in frame
    mov [rbp-24], rdx ; store _101___rgo_7374642f666d74__empty_nth arg in frame
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
    mov rax, [r12-24] ; load _100___rgo_7374642f666d74__empty_nth env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load empty env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _101___rgo_7374642f666d74__empty_nth env field
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

global _350_foo
_350_foo:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 0 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _350_foo_unwrapper
_350_foo_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _350_foo
global _350_foo_deep_release
_350_foo_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _350_foo_deepcopy
_350_foo_deepcopy:
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
global _348_foo
_348_foo:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store value arg in frame
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
global _348_foo_unwrapper
_348_foo_unwrapper:
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
    jmp _348_foo
global _348_foo_deep_release
_348_foo_deep_release:
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
    jg _348_foo_release_skip_0
    mov rax, [r12-16] ; load _348_foo_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_348_foo_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _348_foo_release_skip_1
    mov rax, [r12-8] ; load _348_foo_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_348_foo_release_skip_1:
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
global _348_foo_deepcopy
_348_foo_deepcopy:
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
    jg _348_foo_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_348_foo_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _348_foo_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_348_foo_deepcopy_skip_1:
    leave
    ret

global _347_foo
_347_foo:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _328___rgo_7374642f666d74__new arg in frame
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
    lea rax, [_350_foo_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_350_foo_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_350_foo_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _350_foo closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _348_foo
global _347_foo_unwrapper
_347_foo_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load _328___rgo_7374642f666d74__new env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp _347_foo
global _347_foo_deep_release
_347_foo_deep_release:
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
    jg _347_foo_release_skip_0
    mov rax, [r12-8] ; load _347_foo_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_347_foo_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _347_foo_deepcopy
_347_foo_deepcopy:
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
    jg _347_foo_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_347_foo_deepcopy_skip_0:
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
global _166___rgo_7374642f666d74__finish
_166___rgo_7374642f666d74__finish:
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
    jz _166___rgo_7374642f666d74__finish_str_from_utf8_invalid_0
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
_166___rgo_7374642f666d74__finish_str_from_utf8_invalid_0:
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
global _166___rgo_7374642f666d74__finish_unwrapper
_166___rgo_7374642f666d74__finish_unwrapper:
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
    jmp _166___rgo_7374642f666d74__finish
global _166___rgo_7374642f666d74__finish_deep_release
_166___rgo_7374642f666d74__finish_deep_release:
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
    jg _166___rgo_7374642f666d74__finish_release_skip_0
    mov rax, [r12-24] ; load _166___rgo_7374642f666d74__finish_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_166___rgo_7374642f666d74__finish_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _166___rgo_7374642f666d74__finish_release_skip_1
    mov rax, [r12-16] ; load _166___rgo_7374642f666d74__finish_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_166___rgo_7374642f666d74__finish_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _166___rgo_7374642f666d74__finish_release_skip_2
    mov rax, [r12-8] ; load _166___rgo_7374642f666d74__finish_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_166___rgo_7374642f666d74__finish_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _166___rgo_7374642f666d74__finish_deepcopy
_166___rgo_7374642f666d74__finish_deepcopy:
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
    jg _166___rgo_7374642f666d74__finish_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_166___rgo_7374642f666d74__finish_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _166___rgo_7374642f666d74__finish_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_166___rgo_7374642f666d74__finish_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _166___rgo_7374642f666d74__finish_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_166___rgo_7374642f666d74__finish_deepcopy_skip_2:
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
global foo__generic_0
foo__generic_0:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 80 ; reserve stack space for locals
    mov [rbp-8], rdi ; store x arg in frame
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
    lea rax, [_342_foo_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_342_foo_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_342_foo_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _342_foo closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rbx, [rbp-16] ; original closure _342_foo to ____comptime_0_arg_clone_1 env_end pointer for clone
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
    mov rsi, 72 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
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
    mov rax, r12 ; copy __comptime_0 closure env_end to rax
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
    lea rax, [_347_foo_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_347_foo_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_347_foo_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _347_foo closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rbx, [rbp-16] ; original closure _342_foo to ____comptime_2_arg_clone_0 env_end pointer for clone
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_166___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_166___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_166___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_2 closure env_end to rax
    mov [rbp-72], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js foo__generic_0_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-16] ; load operand
    mov [rbx], rax
    mov rax, [rbp-72] ; load operand
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
    mov rbx, [rbp-48] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
foo__generic_0_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-72] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
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
global foo__generic_0_unwrapper
foo__generic_0_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load x env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp foo__generic_0
global foo__generic_0_deep_release
foo__generic_0_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global foo__generic_0_deepcopy
foo__generic_0_deepcopy:
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
    mov rax, 42 ; operand literal
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp foo__generic_0
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
