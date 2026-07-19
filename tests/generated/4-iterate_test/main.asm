bits 64
default rel
section .text
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
global nil
nil:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store next arg in frame
    mov [rbp-16], rsi ; store end arg in frame
    push r12 ; preserve current environment
    mov rdi, [rbp-8] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-16] ; load end closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global nil_unwrapper
nil_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load next env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load end env field
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
    jmp nil
global nil_deep_release
nil_deep_release:
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
    jg nil_release_skip_0
    mov rax, [r12-16] ; load nil_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
nil_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg nil_release_skip_1
    mov rax, [r12-8] ; load nil_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
nil_release_skip_1:
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
global nil_deepcopy
nil_deepcopy:
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
    jg nil_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
nil_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg nil_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
nil_deepcopy_skip_1:
    leave
    ret

global cons
cons:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store head arg in frame
    mov [rbp-16], rsi ; store tail arg in frame
    mov [rbp-24], rdx ; store next arg in frame
    mov [rbp-32], rcx ; store end arg in frame
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-24] ; load next closure env_end pointer
    mov rax, [rbp-8] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-16] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global cons_unwrapper
cons_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load head env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load tail env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load next env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load end env field
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
    jmp cons
global cons_deep_release
cons_deep_release:
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
    jg cons_release_skip_1
    mov rax, [r12-24] ; load cons_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
cons_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg cons_release_skip_2
    mov rax, [r12-16] ; load cons_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
cons_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg cons_release_skip_3
    mov rax, [r12-8] ; load cons_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
cons_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global cons_deepcopy
cons_deepcopy:
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
    jg cons_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
cons_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg cons_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
cons_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg cons_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
cons_deepcopy_skip_3:
    leave
    ret

global _384_handler
_384_handler:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _384_handler_unwrapper
_384_handler_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _384_handler
global _384_handler_deep_release
_384_handler_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _384_handler_deepcopy
_384_handler_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _164___rgo_7374642f666d74__int_source
_164___rgo_7374642f666d74__int_source:
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
global _164___rgo_7374642f666d74__int_source_unwrapper
_164___rgo_7374642f666d74__int_source_unwrapper:
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
    jmp _164___rgo_7374642f666d74__int_source
global _164___rgo_7374642f666d74__int_source_deep_release
_164___rgo_7374642f666d74__int_source_deep_release:
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
    jg _164___rgo_7374642f666d74__int_source_release_skip_0
    mov rax, [r12-16] ; load _164___rgo_7374642f666d74__int_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_164___rgo_7374642f666d74__int_source_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _164___rgo_7374642f666d74__int_source_release_skip_1
    mov rax, [r12-8] ; load _164___rgo_7374642f666d74__int_source_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_164___rgo_7374642f666d74__int_source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _164___rgo_7374642f666d74__int_source_deepcopy
_164___rgo_7374642f666d74__int_source_deepcopy:
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
    jg _164___rgo_7374642f666d74__int_source_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_164___rgo_7374642f666d74__int_source_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _164___rgo_7374642f666d74__int_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_164___rgo_7374642f666d74__int_source_deepcopy_skip_1:
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
    je eq_uint__134_one_true_0_0
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
eq_uint__134_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _134_one closure env_end pointer
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
    mov rax, r12 ; copy _136___rgo_7374642f666d74__single_nth closure env_end to rax
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

global _147___rgo_7374642f666d74__concat_nth
_147___rgo_7374642f666d74__concat_nth:
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
global _147___rgo_7374642f666d74__concat_nth_unwrapper
_147___rgo_7374642f666d74__concat_nth_unwrapper:
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
    jmp _147___rgo_7374642f666d74__concat_nth
global _147___rgo_7374642f666d74__concat_nth_deep_release
_147___rgo_7374642f666d74__concat_nth_deep_release:
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
    jg _147___rgo_7374642f666d74__concat_nth_release_skip_0
    mov rax, [r12-32] ; load _147___rgo_7374642f666d74__concat_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_147___rgo_7374642f666d74__concat_nth_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _147___rgo_7374642f666d74__concat_nth_release_skip_1
    mov rax, [r12-24] ; load _147___rgo_7374642f666d74__concat_nth_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_147___rgo_7374642f666d74__concat_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _147___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-16] ; load _147___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_147___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _147___rgo_7374642f666d74__concat_nth_deepcopy
_147___rgo_7374642f666d74__concat_nth_deepcopy:
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
    jg _147___rgo_7374642f666d74__concat_nth_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_147___rgo_7374642f666d74__concat_nth_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _147___rgo_7374642f666d74__concat_nth_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_147___rgo_7374642f666d74__concat_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _147___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_147___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    leave
    ret

global _145___rgo_7374642f666d74__concat_nth
_145___rgo_7374642f666d74__concat_nth:
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
    lea rax, [_147___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_147___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_147___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _148___rgo_7374642f666d74__concat_nth closure env_end to rax
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
global _145___rgo_7374642f666d74__concat_nth_unwrapper
_145___rgo_7374642f666d74__concat_nth_unwrapper:
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
    jmp _145___rgo_7374642f666d74__concat_nth
global _145___rgo_7374642f666d74__concat_nth_deep_release
_145___rgo_7374642f666d74__concat_nth_deep_release:
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
    jg _145___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-24] ; load _145___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_145___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _145___rgo_7374642f666d74__concat_nth_release_skip_3
    mov rax, [r12-16] ; load _145___rgo_7374642f666d74__concat_nth_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_145___rgo_7374642f666d74__concat_nth_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _145___rgo_7374642f666d74__concat_nth_release_skip_4
    mov rax, [r12-8] ; load _145___rgo_7374642f666d74__concat_nth_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_145___rgo_7374642f666d74__concat_nth_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _145___rgo_7374642f666d74__concat_nth_deepcopy
_145___rgo_7374642f666d74__concat_nth_deepcopy:
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
    jg _145___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_145___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _145___rgo_7374642f666d74__concat_nth_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_145___rgo_7374642f666d74__concat_nth_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _145___rgo_7374642f666d74__concat_nth_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_145___rgo_7374642f666d74__concat_nth_deepcopy_skip_4:
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
    mov rbx, [rbp-40] ; original closure empty_case to ___143_a_arg_clone_1 env_end pointer for clone
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
    mov rbx, [rbp-48] ; original closure one to ___143_a_arg_clone_2 env_end pointer for clone
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
    lea rax, [_145___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_145___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_145___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _149___rgo_7374642f666d74__concat_nth closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, [rbp-32] ; load operand
    mov rbx, [rbp-8] ; load operand
    cmp rax, rbx
    jb lt_uint__143_a_true_0_0
lt_uint__149___rgo_7374642f666d74__concat_nth_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-80] ; load _149___rgo_7374642f666d74__concat_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt_uint__143_a_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-80] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _143_a closure env_end pointer
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

global _155___rgo_7374642f666d74__concat
_155___rgo_7374642f666d74__concat:
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
    mov rax, r12 ; copy _156___rgo_7374642f666d74__concat_nth closure env_end to rax
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
global _155___rgo_7374642f666d74__concat_unwrapper
_155___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _155___rgo_7374642f666d74__concat
global _155___rgo_7374642f666d74__concat_deep_release
_155___rgo_7374642f666d74__concat_deep_release:
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
    jg _155___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-40] ; load _155___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_155___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _155___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _155___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_155___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _155___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-16] ; load _155___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_155___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _155___rgo_7374642f666d74__concat_deepcopy
_155___rgo_7374642f666d74__concat_deepcopy:
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
    jg _155___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_155___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _155___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_155___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _155___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_155___rgo_7374642f666d74__concat_deepcopy_skip_3:
    leave
    ret

global _153___rgo_7374642f666d74__concat
_153___rgo_7374642f666d74__concat:
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
    lea rax, [_155___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_155___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_155___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _157___rgo_7374642f666d74__concat closure env_end to rax
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
global _153___rgo_7374642f666d74__concat_unwrapper
_153___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _153___rgo_7374642f666d74__concat
global _153___rgo_7374642f666d74__concat_deep_release
_153___rgo_7374642f666d74__concat_deep_release:
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
    jg _153___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-32] ; load _153___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_153___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _153___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _153___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_153___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _153___rgo_7374642f666d74__concat_release_skip_4
    mov rax, [r12-8] ; load _153___rgo_7374642f666d74__concat_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_153___rgo_7374642f666d74__concat_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _153___rgo_7374642f666d74__concat_deepcopy
_153___rgo_7374642f666d74__concat_deepcopy:
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
    jg _153___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_153___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _153___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_153___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _153___rgo_7374642f666d74__concat_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_153___rgo_7374642f666d74__concat_deepcopy_skip_4:
    leave
    ret

global _151___rgo_7374642f666d74__concat
_151___rgo_7374642f666d74__concat:
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
    lea rax, [_153___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_153___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_153___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _158___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _151___rgo_7374642f666d74__concat_unwrapper
_151___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _151___rgo_7374642f666d74__concat
global _151___rgo_7374642f666d74__concat_deep_release
_151___rgo_7374642f666d74__concat_deep_release:
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
    jg _151___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-32] ; load _151___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_151___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _151___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-24] ; load _151___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_151___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _151___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-8] ; load _151___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_151___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _151___rgo_7374642f666d74__concat_deepcopy
_151___rgo_7374642f666d74__concat_deepcopy:
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
    jg _151___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_151___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _151___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_151___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _151___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_151___rgo_7374642f666d74__concat_deepcopy_skip_3:
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
    lea rax, [_151___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_151___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_151___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _159___rgo_7374642f666d74__concat closure env_end to rax
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

global _271___rgo_7374642f666d74__from_int
_271___rgo_7374642f666d74__from_int:
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
    mov rax, r12 ; copy _273___rgo_7374642f666d74__single closure env_end to rax
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
    mov rax, r12 ; copy _274___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _271___rgo_7374642f666d74__from_int_unwrapper
_271___rgo_7374642f666d74__from_int_unwrapper:
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
    jmp _271___rgo_7374642f666d74__from_int
global _271___rgo_7374642f666d74__from_int_deep_release
_271___rgo_7374642f666d74__from_int_deep_release:
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
    jg _271___rgo_7374642f666d74__from_int_release_skip_0
    mov rax, [r12-16] ; load _271___rgo_7374642f666d74__from_int_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_271___rgo_7374642f666d74__from_int_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _271___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-8] ; load _271___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_271___rgo_7374642f666d74__from_int_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _271___rgo_7374642f666d74__from_int_deepcopy
_271___rgo_7374642f666d74__from_int_deepcopy:
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
    jg _271___rgo_7374642f666d74__from_int_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_271___rgo_7374642f666d74__from_int_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _271___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_271___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    leave
    ret

global _257___rgo_7374642f666d74__negative_digits
_257___rgo_7374642f666d74__negative_digits:
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
    mov rax, r12 ; copy _258___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _257___rgo_7374642f666d74__negative_digits_unwrapper
_257___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _257___rgo_7374642f666d74__negative_digits
global _257___rgo_7374642f666d74__negative_digits_deep_release
_257___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _257___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-24] ; load _257___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_257___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _257___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-16] ; load _257___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_257___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _257___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-8] ; load _257___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_257___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _257___rgo_7374642f666d74__negative_digits_deepcopy
_257___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _257___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_257___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _257___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_257___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _257___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_257___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    leave
    ret

global _255___rgo_7374642f666d74__negative_digits
_255___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_257___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_257___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_257___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _259___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _255___rgo_7374642f666d74__negative_digits_unwrapper
_255___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _255___rgo_7374642f666d74__negative_digits
global _255___rgo_7374642f666d74__negative_digits_deep_release
_255___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _255___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _255___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_255___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _255___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _255___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_255___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _255___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _255___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_255___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _255___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-8] ; load _255___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_255___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _255___rgo_7374642f666d74__negative_digits_deepcopy
_255___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _255___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_255___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _255___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_255___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _255___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_255___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _255___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_255___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _251___rgo_7374642f666d74__negative_digits
_251___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store quotient arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-32], rcx ; store invalid arg in frame
    mov [rbp-40], r8 ; store suffix arg in frame
    mov rbx, [rbp-16] ; original closure ok to _253_ok env_end pointer for clone
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
    mov rbx, [rbp-40] ; original closure suffix to ___253_ok_arg_clone_0 env_end pointer for clone
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
    lea rax, [_255___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_255___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_255___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _260___rgo_7374642f666d74__negative_digits closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_int__253_ok_true_0_0
eq_int__260___rgo_7374642f666d74__negative_digits_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-64] ; load _260___rgo_7374642f666d74__negative_digits closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
eq_int__253_ok_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-64] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _253_ok closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _251___rgo_7374642f666d74__negative_digits_unwrapper
_251___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _251___rgo_7374642f666d74__negative_digits
global _251___rgo_7374642f666d74__negative_digits_deep_release
_251___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _251___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-32] ; load _251___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_251___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _251___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_251___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _251___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_251___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-8] ; load _251___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_251___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _251___rgo_7374642f666d74__negative_digits_deepcopy
_251___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _251___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_251___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_251___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_251___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _251___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_251___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _207___rgo_7374642f666d74__digit
_207___rgo_7374642f666d74__digit:
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
    mov rax, r12 ; copy _208___rgo_7374642f666d74__single closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-8] ; load ok closure env_end pointer
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _207___rgo_7374642f666d74__digit_unwrapper
_207___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _207___rgo_7374642f666d74__digit
global _207___rgo_7374642f666d74__digit_deep_release
_207___rgo_7374642f666d74__digit_deep_release:
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
    jg _207___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _207___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_207___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _207___rgo_7374642f666d74__digit_deepcopy
_207___rgo_7374642f666d74__digit_deepcopy:
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
    jg _207___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_207___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _205___rgo_7374642f666d74__digit
_205___rgo_7374642f666d74__digit:
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
    lea rax, [_207___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_207___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_207___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _209___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-16] ; load operand
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _205___rgo_7374642f666d74__digit_unwrapper
_205___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _205___rgo_7374642f666d74__digit
global _205___rgo_7374642f666d74__digit_deep_release
_205___rgo_7374642f666d74__digit_deep_release:
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
    jg _205___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _205___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_205___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _205___rgo_7374642f666d74__digit_deepcopy
_205___rgo_7374642f666d74__digit_deepcopy:
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
    jg _205___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_205___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _203___rgo_7374642f666d74__digit
_203___rgo_7374642f666d74__digit:
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
    lea rax, [_205___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_205___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_205___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _210___rgo_7374642f666d74__digit closure env_end to rax
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
global _203___rgo_7374642f666d74__digit_unwrapper
_203___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _203___rgo_7374642f666d74__digit
global _203___rgo_7374642f666d74__digit_deep_release
_203___rgo_7374642f666d74__digit_deep_release:
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
    jg _203___rgo_7374642f666d74__digit_release_skip_1
    mov rax, [r12-16] ; load _203___rgo_7374642f666d74__digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_203___rgo_7374642f666d74__digit_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _203___rgo_7374642f666d74__digit_deepcopy
_203___rgo_7374642f666d74__digit_deepcopy:
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
    jg _203___rgo_7374642f666d74__digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_203___rgo_7374642f666d74__digit_deepcopy_skip_1:
    leave
    ret

global _200___rgo_7374642f666d74__digit
_200___rgo_7374642f666d74__digit:
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
    lea rax, [_203___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_203___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_203___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _211___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 48 ; operand literal
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _200___rgo_7374642f666d74__digit_unwrapper
_200___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _200___rgo_7374642f666d74__digit
global _200___rgo_7374642f666d74__digit_deep_release
_200___rgo_7374642f666d74__digit_deep_release:
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
    jg _200___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _200___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_200___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _200___rgo_7374642f666d74__digit_deepcopy
_200___rgo_7374642f666d74__digit_deepcopy:
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
    jg _200___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_200___rgo_7374642f666d74__digit_deepcopy_skip_0:
    leave
    ret

global _198___rgo_7374642f666d74__digit
_198___rgo_7374642f666d74__digit:
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
    lea rax, [_200___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_200___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_200___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _212___rgo_7374642f666d74__digit closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-16] ; load operand
    and rax, 0xff ; keep low 8 bits
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _198___rgo_7374642f666d74__digit_unwrapper
_198___rgo_7374642f666d74__digit_unwrapper:
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
    jmp _198___rgo_7374642f666d74__digit
global _198___rgo_7374642f666d74__digit_deep_release
_198___rgo_7374642f666d74__digit_deep_release:
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
    jg _198___rgo_7374642f666d74__digit_release_skip_0
    mov rax, [r12-16] ; load _198___rgo_7374642f666d74__digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_198___rgo_7374642f666d74__digit_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _198___rgo_7374642f666d74__digit_deepcopy
_198___rgo_7374642f666d74__digit_deepcopy:
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
    jg _198___rgo_7374642f666d74__digit_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_198___rgo_7374642f666d74__digit_deepcopy_skip_0:
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
    lea rax, [_198___rgo_7374642f666d74__digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_198___rgo_7374642f666d74__digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_198___rgo_7374642f666d74__digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _213___rgo_7374642f666d74__digit closure env_end to rax
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

global _249___rgo_7374642f666d74__negative_digits
_249___rgo_7374642f666d74__negative_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__negative_digits arg in frame
    mov [rbp-40], r8 ; store remainder arg in frame
    mov rbx, [rbp-8] ; original closure invalid to ___261___rgo_7374642f666d74__negative_digits_arg_clone_3 env_end pointer for clone
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
    lea rax, [_251___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_251___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_251___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _261___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _249___rgo_7374642f666d74__negative_digits_unwrapper
_249___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _249___rgo_7374642f666d74__negative_digits
global _249___rgo_7374642f666d74__negative_digits_deep_release
_249___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _249___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _249___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_249___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _249___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _249___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_249___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _249___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _249___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_249___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _249___rgo_7374642f666d74__negative_digits_deepcopy
_249___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _249___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_249___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _249___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_249___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _249___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_249___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global _246___rgo_7374642f666d74__negative_digits
_246___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_249___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_249___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_249___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _262___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _246___rgo_7374642f666d74__negative_digits_unwrapper
_246___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _246___rgo_7374642f666d74__negative_digits
global _246___rgo_7374642f666d74__negative_digits_deep_release
_246___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _246___rgo_7374642f666d74__negative_digits_release_skip_0
    mov rax, [r12-40] ; load _246___rgo_7374642f666d74__negative_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_246___rgo_7374642f666d74__negative_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _246___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _246___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_246___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _246___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _246___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_246___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _246___rgo_7374642f666d74__negative_digits_deepcopy
_246___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _246___rgo_7374642f666d74__negative_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_246___rgo_7374642f666d74__negative_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _246___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_246___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _246___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_246___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    leave
    ret

global _244___rgo_7374642f666d74__negative_digits
_244___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_246___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_246___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_246___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _263___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _244___rgo_7374642f666d74__negative_digits_unwrapper
_244___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _244___rgo_7374642f666d74__negative_digits
global _244___rgo_7374642f666d74__negative_digits_deep_release
_244___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _244___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-40] ; load _244___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_244___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-24] ; load _244___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_244___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__negative_digits_release_skip_4
    mov rax, [r12-16] ; load _244___rgo_7374642f666d74__negative_digits_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_244___rgo_7374642f666d74__negative_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _244___rgo_7374642f666d74__negative_digits_deepcopy
_244___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _244___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_244___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_244___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _244___rgo_7374642f666d74__negative_digits_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_244___rgo_7374642f666d74__negative_digits_deepcopy_skip_4:
    leave
    ret

global _241___rgo_7374642f666d74__negative_digits
_241___rgo_7374642f666d74__negative_digits:
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
    lea rax, [_244___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_244___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_244___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _264___rgo_7374642f666d74__negative_digits closure env_end to rax
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
global _241___rgo_7374642f666d74__negative_digits_unwrapper
_241___rgo_7374642f666d74__negative_digits_unwrapper:
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
    jmp _241___rgo_7374642f666d74__negative_digits
global _241___rgo_7374642f666d74__negative_digits_deep_release
_241___rgo_7374642f666d74__negative_digits_deep_release:
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
    jg _241___rgo_7374642f666d74__negative_digits_release_skip_1
    mov rax, [r12-32] ; load _241___rgo_7374642f666d74__negative_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_241___rgo_7374642f666d74__negative_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _241___rgo_7374642f666d74__negative_digits_release_skip_2
    mov rax, [r12-24] ; load _241___rgo_7374642f666d74__negative_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_241___rgo_7374642f666d74__negative_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _241___rgo_7374642f666d74__negative_digits_release_skip_3
    mov rax, [r12-16] ; load _241___rgo_7374642f666d74__negative_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_241___rgo_7374642f666d74__negative_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _241___rgo_7374642f666d74__negative_digits_deepcopy
_241___rgo_7374642f666d74__negative_digits_deepcopy:
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
    jg _241___rgo_7374642f666d74__negative_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_241___rgo_7374642f666d74__negative_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _241___rgo_7374642f666d74__negative_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_241___rgo_7374642f666d74__negative_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _241___rgo_7374642f666d74__negative_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_241___rgo_7374642f666d74__negative_digits_deepcopy_skip_3:
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
    mov rbx, [rbp-16] ; original closure invalid to ___265___rgo_7374642f666d74__negative_digits_arg_clone_1 env_end pointer for clone
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
    lea rax, [_241___rgo_7374642f666d74__negative_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_241___rgo_7374642f666d74__negative_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_241___rgo_7374642f666d74__negative_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _265___rgo_7374642f666d74__negative_digits closure env_end to rax
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

global _269___rgo_7374642f666d74__from_int
_269___rgo_7374642f666d74__from_int:
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
    lea rax, [_271___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_271___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_271___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _275___rgo_7374642f666d74__from_int closure env_end to rax
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
global _269___rgo_7374642f666d74__from_int_unwrapper
_269___rgo_7374642f666d74__from_int_unwrapper:
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
    jmp _269___rgo_7374642f666d74__from_int
global _269___rgo_7374642f666d74__from_int_deep_release
_269___rgo_7374642f666d74__from_int_deep_release:
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
    jg _269___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load _269___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_269___rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _269___rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load _269___rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_269___rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _269___rgo_7374642f666d74__from_int_deepcopy
_269___rgo_7374642f666d74__from_int_deepcopy:
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
    jg _269___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_269___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _269___rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_269___rgo_7374642f666d74__from_int_deepcopy_skip_2:
    leave
    ret

global _230___rgo_7374642f666d74__positive_digits
_230___rgo_7374642f666d74__positive_digits:
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
global _230___rgo_7374642f666d74__positive_digits_unwrapper
_230___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _230___rgo_7374642f666d74__positive_digits
global _230___rgo_7374642f666d74__positive_digits_deep_release
_230___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _230___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-24] ; load _230___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_230___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-16] ; load _230___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_230___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-8] ; load _230___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_230___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _230___rgo_7374642f666d74__positive_digits_deepcopy
_230___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _230___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_230___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_230___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _230___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_230___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    leave
    ret

global _228___rgo_7374642f666d74__positive_digits
_228___rgo_7374642f666d74__positive_digits:
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
    lea rax, [_230___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_230___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_230___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _232___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _228___rgo_7374642f666d74__positive_digits_unwrapper
_228___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _228___rgo_7374642f666d74__positive_digits
global _228___rgo_7374642f666d74__positive_digits_deep_release
_228___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _228___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-40] ; load _228___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _228___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _228___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-8] ; load _228___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_228___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _228___rgo_7374642f666d74__positive_digits_deepcopy
_228___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _228___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_228___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_228___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_228___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _228___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_228___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _224___rgo_7374642f666d74__positive_digits
_224___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store quotient arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store __rgo_7374642f666d74__positive_digits arg in frame
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
    lea rax, [_228___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_228___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_228___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _233___rgo_7374642f666d74__positive_digits closure env_end to rax
    mov [rbp-64], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    je eq_int__226_ok_true_0_0
eq_int__233___rgo_7374642f666d74__positive_digits_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-64] ; load _233___rgo_7374642f666d74__positive_digits closure env_end pointer
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
global _224___rgo_7374642f666d74__positive_digits_unwrapper
_224___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _224___rgo_7374642f666d74__positive_digits
global _224___rgo_7374642f666d74__positive_digits_deep_release
_224___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _224___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-32] ; load _224___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _224___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _224___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-8] ; load _224___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_224___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _224___rgo_7374642f666d74__positive_digits_deepcopy
_224___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _224___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_224___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_224___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_224___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _224___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
_224___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _222___rgo_7374642f666d74__positive_digits
_222___rgo_7374642f666d74__positive_digits:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store invalid arg in frame
    mov [rbp-16], rsi ; store quotient arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store __rgo_7374642f666d74__positive_digits arg in frame
    mov [rbp-40], r8 ; store remainder arg in frame
    mov rbx, [rbp-8] ; original closure invalid to ___234___rgo_7374642f666d74__positive_digits_arg_clone_3 env_end pointer for clone
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
    lea rax, [_224___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_224___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_224___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _234___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _222___rgo_7374642f666d74__positive_digits_unwrapper
_222___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _222___rgo_7374642f666d74__positive_digits
global _222___rgo_7374642f666d74__positive_digits_deep_release
_222___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _222___rgo_7374642f666d74__positive_digits_release_skip_0
    mov rax, [r12-40] ; load _222___rgo_7374642f666d74__positive_digits_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_222___rgo_7374642f666d74__positive_digits_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _222___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_222___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _222___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_222___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _222___rgo_7374642f666d74__positive_digits_deepcopy
_222___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _222___rgo_7374642f666d74__positive_digits_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_222___rgo_7374642f666d74__positive_digits_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_222___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _222___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_222___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    leave
    ret

global _220___rgo_7374642f666d74__positive_digits
_220___rgo_7374642f666d74__positive_digits:
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
    lea rax, [_222___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_222___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_222___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _235___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _220___rgo_7374642f666d74__positive_digits_unwrapper
_220___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _220___rgo_7374642f666d74__positive_digits
global _220___rgo_7374642f666d74__positive_digits_deep_release
_220___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _220___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-40] ; load _220___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_220___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _220___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-24] ; load _220___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_220___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _220___rgo_7374642f666d74__positive_digits_release_skip_4
    mov rax, [r12-16] ; load _220___rgo_7374642f666d74__positive_digits_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_220___rgo_7374642f666d74__positive_digits_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _220___rgo_7374642f666d74__positive_digits_deepcopy
_220___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _220___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_220___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _220___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_220___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _220___rgo_7374642f666d74__positive_digits_deepcopy_skip_4
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_220___rgo_7374642f666d74__positive_digits_deepcopy_skip_4:
    leave
    ret

global _217___rgo_7374642f666d74__positive_digits
_217___rgo_7374642f666d74__positive_digits:
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
    lea rax, [_220___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_220___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_220___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _236___rgo_7374642f666d74__positive_digits closure env_end to rax
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
global _217___rgo_7374642f666d74__positive_digits_unwrapper
_217___rgo_7374642f666d74__positive_digits_unwrapper:
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
    jmp _217___rgo_7374642f666d74__positive_digits
global _217___rgo_7374642f666d74__positive_digits_deep_release
_217___rgo_7374642f666d74__positive_digits_deep_release:
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
    jg _217___rgo_7374642f666d74__positive_digits_release_skip_1
    mov rax, [r12-32] ; load _217___rgo_7374642f666d74__positive_digits_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_217___rgo_7374642f666d74__positive_digits_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__positive_digits_release_skip_2
    mov rax, [r12-24] ; load _217___rgo_7374642f666d74__positive_digits_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_217___rgo_7374642f666d74__positive_digits_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__positive_digits_release_skip_3
    mov rax, [r12-16] ; load _217___rgo_7374642f666d74__positive_digits_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_217___rgo_7374642f666d74__positive_digits_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _217___rgo_7374642f666d74__positive_digits_deepcopy
_217___rgo_7374642f666d74__positive_digits_deepcopy:
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
    jg _217___rgo_7374642f666d74__positive_digits_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_217___rgo_7374642f666d74__positive_digits_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__positive_digits_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_217___rgo_7374642f666d74__positive_digits_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _217___rgo_7374642f666d74__positive_digits_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_217___rgo_7374642f666d74__positive_digits_deepcopy_skip_3:
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
    mov rbx, [rbp-16] ; original closure invalid to ___237___rgo_7374642f666d74__positive_digits_arg_clone_1 env_end pointer for clone
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
    lea rax, [_217___rgo_7374642f666d74__positive_digits_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_217___rgo_7374642f666d74__positive_digits_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_217___rgo_7374642f666d74__positive_digits_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _237___rgo_7374642f666d74__positive_digits closure env_end to rax
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

global _278___rgo_7374642f666d74__from_int
_278___rgo_7374642f666d74__from_int:
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
global _278___rgo_7374642f666d74__from_int_unwrapper
_278___rgo_7374642f666d74__from_int_unwrapper:
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
    jmp _278___rgo_7374642f666d74__from_int
global _278___rgo_7374642f666d74__from_int_deep_release
_278___rgo_7374642f666d74__from_int_deep_release:
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
    jg _278___rgo_7374642f666d74__from_int_release_skip_1
    mov rax, [r12-16] ; load _278___rgo_7374642f666d74__from_int_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_278___rgo_7374642f666d74__from_int_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _278___rgo_7374642f666d74__from_int_release_skip_2
    mov rax, [r12-8] ; load _278___rgo_7374642f666d74__from_int_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_278___rgo_7374642f666d74__from_int_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _278___rgo_7374642f666d74__from_int_deepcopy
_278___rgo_7374642f666d74__from_int_deepcopy:
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
    jg _278___rgo_7374642f666d74__from_int_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_278___rgo_7374642f666d74__from_int_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _278___rgo_7374642f666d74__from_int_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_278___rgo_7374642f666d74__from_int_deepcopy_skip_2:
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
    mov rbx, [rbp-16] ; original closure invalid to ___276___rgo_7374642f666d74__from_int_arg_clone_1 env_end pointer for clone
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
    mov rbx, [rbp-24] ; original closure ok to ___276___rgo_7374642f666d74__from_int_arg_clone_2 env_end pointer for clone
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
    lea rax, [_269___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_269___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_269___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _276___rgo_7374642f666d74__from_int closure env_end to rax
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
    lea rax, [_278___rgo_7374642f666d74__from_int_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_278___rgo_7374642f666d74__from_int_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_278___rgo_7374642f666d74__from_int_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _279___rgo_7374642f666d74__from_int closure env_end to rax
    mov [rbp-56], rax ; store value
    mov rax, [rbp-8] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jl lt__276___rgo_7374642f666d74__from_int_true_0_0
lt__279___rgo_7374642f666d74__from_int_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _279___rgo_7374642f666d74__from_int closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt__276___rgo_7374642f666d74__from_int_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _276___rgo_7374642f666d74__from_int closure env_end pointer
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
    lea rax, [_164___rgo_7374642f666d74__int_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_164___rgo_7374642f666d74__int_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_164___rgo_7374642f666d74__int_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _165___rgo_7374642f666d74__int_source closure env_end to rax
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
    mov [rbp-8], rdi ; store _128___rgo_7374642f666d74__empty_nth arg in frame
    mov [rbp-16], rsi ; store empty arg in frame
    mov [rbp-24], rdx ; store _129___rgo_7374642f666d74__empty_nth arg in frame
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
    mov rax, [r12-24] ; load _128___rgo_7374642f666d74__empty_nth env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load empty env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _129___rgo_7374642f666d74__empty_nth env field
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
global _390_handler
_390_handler:
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
global _390_handler_unwrapper
_390_handler_unwrapper:
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
    jmp _390_handler
global _390_handler_deep_release
_390_handler_deep_release:
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
    jg _390_handler_release_skip_0
    mov rax, [r12-16] ; load _390_handler_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_390_handler_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _390_handler_release_skip_1
    mov rax, [r12-8] ; load _390_handler_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_390_handler_release_skip_1:
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
global _390_handler_deepcopy
_390_handler_deepcopy:
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
    jg _390_handler_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_390_handler_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _390_handler_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_390_handler_deepcopy_skip_1:
    leave
    ret

global _389_handler
_389_handler:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store _356___rgo_7374642f666d74__new arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _390_handler
global _389_handler_unwrapper
_389_handler_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load _356___rgo_7374642f666d74__new env field
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
    jmp _389_handler
global _389_handler_deep_release
_389_handler_deep_release:
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
    jg _389_handler_release_skip_0
    mov rax, [r12-16] ; load _389_handler_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_389_handler_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _389_handler_release_skip_1
    mov rax, [r12-8] ; load _389_handler_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_389_handler_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _389_handler_deepcopy
_389_handler_deepcopy:
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
    jg _389_handler_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_389_handler_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _389_handler_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_389_handler_deepcopy_skip_1:
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
global _194___rgo_7374642f666d74__finish
_194___rgo_7374642f666d74__finish:
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
    jz _194___rgo_7374642f666d74__finish_str_from_utf8_invalid_0
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
_194___rgo_7374642f666d74__finish_str_from_utf8_invalid_0:
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
global _194___rgo_7374642f666d74__finish_unwrapper
_194___rgo_7374642f666d74__finish_unwrapper:
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
    jmp _194___rgo_7374642f666d74__finish
global _194___rgo_7374642f666d74__finish_deep_release
_194___rgo_7374642f666d74__finish_deep_release:
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
    jg _194___rgo_7374642f666d74__finish_release_skip_0
    mov rax, [r12-24] ; load _194___rgo_7374642f666d74__finish_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_194___rgo_7374642f666d74__finish_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__finish_release_skip_1
    mov rax, [r12-16] ; load _194___rgo_7374642f666d74__finish_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_194___rgo_7374642f666d74__finish_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__finish_release_skip_2
    mov rax, [r12-8] ; load _194___rgo_7374642f666d74__finish_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_194___rgo_7374642f666d74__finish_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _194___rgo_7374642f666d74__finish_deepcopy
_194___rgo_7374642f666d74__finish_deepcopy:
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
    jg _194___rgo_7374642f666d74__finish_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_194___rgo_7374642f666d74__finish_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__finish_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_194___rgo_7374642f666d74__finish_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _194___rgo_7374642f666d74__finish_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_194___rgo_7374642f666d74__finish_deepcopy_skip_2:
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
global handler
handler:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 112 ; reserve stack space for locals
    mov [rbp-8], rdi ; store n arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
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
    lea rax, [_384_handler_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_384_handler_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_384_handler_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _384_handler closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rbx, [rbp-24] ; original closure _384_handler to ____comptime_13_arg_clone_1 env_end pointer for clone
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
    mov rax, r12 ; copy __comptime_13 closure env_end to rax
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
    mov rax, [rbp-48] ; load operand
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
    mov rax, r12 ; copy __comptime_14 closure env_end to rax
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
    mov rax, r12 ; copy __comptime_16 closure env_end to rax
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
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
    mov rax, r12 ; copy __comptime_17 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, r12 ; copy __comptime_19 closure env_end to rax
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-80] ; load operand
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
    mov [rbp-88], rax ; store value
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
    lea rax, [_389_handler_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_389_handler_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_389_handler_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_21 closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rbx, [rbp-24] ; original closure _384_handler to ____comptime_22_arg_clone_0 env_end pointer for clone
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
    mov rax, [rbp-96] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_194___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_194___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_194___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_22 closure env_end to rax
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
    js handler_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-24] ; load operand
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
    mov rbx, [rbp-88] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
handler_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-112] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-88] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global handler_unwrapper
handler_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load n env field
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
    jmp handler
global handler_deep_release
handler_deep_release:
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
    jg handler_release_skip_1
    mov rax, [r12-8] ; load handler_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
handler_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global handler_deepcopy
handler_deepcopy:
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
    jg handler_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
handler_deepcopy_skip_1:
    leave
    ret

global _394_end
_394_end:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _394_end_unwrapper
_394_end_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _394_end
global _394_end_deep_release
_394_end_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _394_end_deepcopy
_394_end_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _401_end
_401_end:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 0 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _401_end_unwrapper
_401_end_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _401_end
global _401_end_deep_release
_401_end_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _401_end_deepcopy
_401_end_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _399_end
_399_end:
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
global _399_end_unwrapper
_399_end_unwrapper:
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
    jmp _399_end
global _399_end_deep_release
_399_end_deep_release:
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
    jg _399_end_release_skip_0
    mov rax, [r12-16] ; load _399_end_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_399_end_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _399_end_release_skip_1
    mov rax, [r12-8] ; load _399_end_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_399_end_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _399_end_deepcopy
_399_end_deepcopy:
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
    jg _399_end_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_399_end_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _399_end_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_399_end_deepcopy_skip_1:
    leave
    ret

global _398_end
_398_end:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _356___rgo_7374642f666d74__new arg in frame
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
    lea rax, [_401_end_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_401_end_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_401_end_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _401_end closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _399_end
global _398_end_unwrapper
_398_end_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load _356___rgo_7374642f666d74__new env field
    mov [rbp-16], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp _398_end
global _398_end_deep_release
_398_end_deep_release:
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
    jg _398_end_release_skip_0
    mov rax, [r12-8] ; load _398_end_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_398_end_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _398_end_deepcopy
_398_end_deepcopy:
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
    jg _398_end_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_398_end_deepcopy_skip_0:
    leave
    ret

global end
end:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 112 ; reserve stack space for locals
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
    mov rax, r12 ; copy __comptime_1 closure env_end to rax
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov rax, [rbp-8] ; load operand
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
    mov rax, r12 ; copy __comptime_4 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, r12 ; copy __comptime_5 closure env_end to rax
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
    mov rax, r12 ; copy __comptime_7 closure env_end to rax
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
    mov rax, [rbp-40] ; load operand
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
    mov rax, r12 ; copy __comptime_8 closure env_end to rax
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
    mov rax, r12 ; copy __comptime_10 closure env_end to rax
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
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
    mov rax, r12 ; copy __comptime_11 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    lea rax, [_394_end_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_394_end_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_394_end_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _394_end closure env_end to rax
    mov [rbp-80], rax ; store value
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
    lea rax, [_398_end_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_398_end_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_398_end_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _398_end closure env_end to rax
    mov [rbp-88], rax ; store value
    mov rbx, [rbp-80] ; original closure _394_end to ____comptime_12_arg_clone_0 env_end pointer for clone
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
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_194___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_194___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_194___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_12 closure env_end to rax
    mov [rbp-104], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    test rax, rax
    js end_bytes_build_allocation_failed_0
    mov rbx, rax
    mov rax, [rbp-80] ; load operand
    mov [rbx], rax
    mov rax, [rbp-104] ; load operand
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
    mov rbx, [rbp-72] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
end_bytes_build_allocation_failed_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-104] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    push r12 ; preserve current environment
    mov rdi, [rbp-72] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov r12, [rbp-80] ; load continuation env_end pointer
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global end_unwrapper
end_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp end
global end_deep_release
end_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global end_deepcopy
end_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global iterate_inner
iterate_inner:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 64 ; reserve stack space for locals
    mov [rbp-8], rdi ; store iterate arg in frame
    mov [rbp-16], rsi ; store handler arg in frame
    mov [rbp-24], rdx ; store end arg in frame
    mov [rbp-32], rcx ; store head arg in frame
    mov [rbp-40], r8 ; store tail arg in frame
    mov rax, [rbp-8] ; load operand
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-16] ; original closure handler to __x_arg_clone_0 env_end pointer for clone
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
    mov [r12-24], rcx ; store env field
    mov rcx, [rbp-40] ; load operand
    mov [r12-16], rcx ; store env field
    mov rcx, [rbp-24] ; load operand
    mov [r12-8], rcx ; store env field
    mov rcx, 0 ; operand literal
    mov [r12+40], rcx ; store env field
    mov rbx, [rbp-16] ; load handler closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-48] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global iterate_inner_unwrapper
iterate_inner_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-40] ; load iterate env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-32] ; load handler env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-24] ; load end env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-16] ; load head env field
    mov [rbp-40], rax ; store value
    mov rax, [r12-8] ; load tail env field
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
    jmp iterate_inner
global iterate_inner_deep_release
iterate_inner_deep_release:
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
    jg iterate_inner_release_skip_0
    mov rax, [r12-40] ; load iterate_inner_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_inner_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg iterate_inner_release_skip_1
    mov rax, [r12-32] ; load iterate_inner_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_inner_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg iterate_inner_release_skip_2
    mov rax, [r12-24] ; load iterate_inner_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_inner_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg iterate_inner_release_skip_4
    mov rax, [r12-8] ; load iterate_inner_release_field_4 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_inner_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global iterate_inner_deepcopy
iterate_inner_deepcopy:
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
    jg iterate_inner_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
iterate_inner_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 3 ; operand literal
    cmp rax, rbx
    jg iterate_inner_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
iterate_inner_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg iterate_inner_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
iterate_inner_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg iterate_inner_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
iterate_inner_deepcopy_skip_4:
    leave
    ret

global iterate
iterate:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store handler arg in frame
    mov [rbp-16], rsi ; store arr arg in frame
    mov [rbp-24], rdx ; store end arg in frame
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
    lea rax, [iterate_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [iterate_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [iterate_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy iterate closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-24] ; original closure end to ___381_iterate_inner_arg_clone_2 env_end pointer for clone
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 40 ; move pointer past env payload
    mov rax, 40 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 88 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [iterate_inner_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [iterate_inner_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [iterate_inner_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _381_iterate_inner closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-16] ; load arr closure env_end pointer
    mov rax, [rbp-48] ; load operand
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global iterate_unwrapper
iterate_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load handler env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load arr env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load end env field
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
    jmp iterate
global iterate_deep_release
iterate_deep_release:
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
    jg iterate_release_skip_0
    mov rax, [r12-24] ; load iterate_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg iterate_release_skip_1
    mov rax, [r12-16] ; load iterate_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg iterate_release_skip_2
    mov rax, [r12-8] ; load iterate_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
iterate_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global iterate_deepcopy
iterate_deepcopy:
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
    jg iterate_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
iterate_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg iterate_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
iterate_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg iterate_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
iterate_deepcopy_skip_2:
    leave
    ret

global main
main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store mylist arg in frame
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [handler_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [handler_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [handler_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy handler closure env_end to rax
    mov [rbp-16], rax ; store value
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
    lea rax, [end_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [end_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [end_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy end closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, [rbp-24] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp iterate
global main_unwrapper
main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-8] ; load mylist env field
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

global _start
_start:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 64 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [nil_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [nil_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [nil_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy nil closure env_end to rax
    mov [rbp-8], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 4 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [cons_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [cons_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [cons_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _104_cons closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 3 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [cons_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [cons_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [cons_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _105_cons closure env_end to rax
    mov [rbp-24], rax ; store value
    mov rax, 9 ; mmap syscall
    xor rdi, rdi ; addr hint for kernel base selection
    mov rsi, 80 ; length for allocation
    mov rdx, 3 ; prot = read/write
    mov r10, 34 ; flags: private & anonymous
    mov r8, -1 ; fd = -1
    xor r9, r9 ; offset = 0
    syscall ; allocate env pages
    mov rbx, rax ; closure env base pointer
    mov rax, 2 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [cons_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [cons_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [cons_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _106_cons closure env_end to rax
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
    mov rax, 1 ; operand literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-32] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [cons_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [cons_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [cons_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy mylist closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rax, [rbp-40] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp main
