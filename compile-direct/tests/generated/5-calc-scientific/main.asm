bits 64
default rel
section .text
__rgo_allocation_failed:
    mov rdi, 1 ; allocation failure exit code
    mov rax, 60 ; exit syscall
    syscall
extern freestanding_format_f64_len
extern freestanding_format_f64_nth
extern freestanding_math_acos
extern freestanding_math_acosh
extern freestanding_math_asin
extern freestanding_math_asinh
extern freestanding_math_atan
extern freestanding_math_atan2
extern freestanding_math_atanh
extern freestanding_math_cbrt
extern freestanding_math_ceil
extern freestanding_math_cos
extern freestanding_math_cosh
extern freestanding_math_exp
extern freestanding_math_exp2
extern freestanding_math_expm1
extern freestanding_math_fabs
extern freestanding_math_floor
extern freestanding_math_fmax
extern freestanding_math_fmin
extern freestanding_math_fmod
extern freestanding_math_hypot
extern freestanding_math_log
extern freestanding_math_log10
extern freestanding_math_log1p
extern freestanding_math_log2
extern freestanding_math_pow
extern freestanding_math_remainder
extern freestanding_math_round
extern freestanding_math_sin
extern freestanding_math_sinh
extern freestanding_math_sqrt
extern freestanding_math_tan
extern freestanding_math_tanh
extern freestanding_math_trunc
global _1851_main
_1851_main:
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
global _1851_main_unwrapper
_1851_main_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _1851_main
global _1851_main_deep_release
_1851_main_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1851_main_deepcopy
_1851_main_deepcopy:
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

global _1570___rgo_7374642f666d74__from_raw
_1570___rgo_7374642f666d74__from_raw:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov [rbp-24], rdx ; store l arg in frame
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
    lea rax, [__rgo_7374642f666d74__raw_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__raw_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__raw_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _1571___rgo_7374642f666d74__raw_nth closure env_end to rax
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
global _1570___rgo_7374642f666d74__from_raw_unwrapper
_1570___rgo_7374642f666d74__from_raw_unwrapper:
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
    jmp _1570___rgo_7374642f666d74__from_raw
global _1570___rgo_7374642f666d74__from_raw_deep_release
_1570___rgo_7374642f666d74__from_raw_deep_release:
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
    jg _1570___rgo_7374642f666d74__from_raw_release_skip_0
    mov rax, [r12-24] ; load _1570___rgo_7374642f666d74__from_raw_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1570___rgo_7374642f666d74__from_raw_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1570___rgo_7374642f666d74__from_raw_release_skip_1
    mov rax, [r12-16] ; load _1570___rgo_7374642f666d74__from_raw_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_1570___rgo_7374642f666d74__from_raw_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1570___rgo_7374642f666d74__from_raw_deepcopy
_1570___rgo_7374642f666d74__from_raw_deepcopy:
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
    jg _1570___rgo_7374642f666d74__from_raw_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1570___rgo_7374642f666d74__from_raw_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1570___rgo_7374642f666d74__from_raw_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1570___rgo_7374642f666d74__from_raw_deepcopy_skip_1:
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1570___rgo_7374642f666d74__from_raw_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1570___rgo_7374642f666d74__from_raw_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1570___rgo_7374642f666d74__from_raw_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1572___rgo_7374642f666d74__from_raw closure env_end to rax
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

global _1592___rgo_7374642f666d74__str_source
_1592___rgo_7374642f666d74__str_source:
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
global _1592___rgo_7374642f666d74__str_source_unwrapper
_1592___rgo_7374642f666d74__str_source_unwrapper:
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
    jmp _1592___rgo_7374642f666d74__str_source
global _1592___rgo_7374642f666d74__str_source_deep_release
_1592___rgo_7374642f666d74__str_source_deep_release:
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
    jg _1592___rgo_7374642f666d74__str_source_release_skip_0
    mov rax, [r12-16] ; load _1592___rgo_7374642f666d74__str_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1592___rgo_7374642f666d74__str_source_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1592___rgo_7374642f666d74__str_source_release_skip_1
    mov rax, [r12-8] ; load _1592___rgo_7374642f666d74__str_source_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_1592___rgo_7374642f666d74__str_source_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1592___rgo_7374642f666d74__str_source_deepcopy
_1592___rgo_7374642f666d74__str_source_deepcopy:
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
    jg _1592___rgo_7374642f666d74__str_source_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1592___rgo_7374642f666d74__str_source_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1592___rgo_7374642f666d74__str_source_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1592___rgo_7374642f666d74__str_source_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f666d74__str_source
__rgo_7374642f666d74__str_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
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
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1592___rgo_7374642f666d74__str_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1592___rgo_7374642f666d74__str_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1592___rgo_7374642f666d74__str_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1593___rgo_7374642f666d74__str_source closure env_end to rax
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

global __rgo_7374642f666d74__empty_nth
__rgo_7374642f666d74__empty_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store _1559___rgo_7374642f666d74__empty_nth arg in frame
    mov [rbp-16], rsi ; store empty arg in frame
    mov [rbp-24], rdx ; store _1560___rgo_7374642f666d74__empty_nth arg in frame
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
    mov rax, [r12-24] ; load _1559___rgo_7374642f666d74__empty_nth env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load empty env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load _1560___rgo_7374642f666d74__empty_nth env field
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

global _1578___rgo_7374642f666d74__concat_nth
_1578___rgo_7374642f666d74__concat_nth:
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
global _1578___rgo_7374642f666d74__concat_nth_unwrapper
_1578___rgo_7374642f666d74__concat_nth_unwrapper:
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
    jmp _1578___rgo_7374642f666d74__concat_nth
global _1578___rgo_7374642f666d74__concat_nth_deep_release
_1578___rgo_7374642f666d74__concat_nth_deep_release:
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
    jg _1578___rgo_7374642f666d74__concat_nth_release_skip_0
    mov rax, [r12-32] ; load _1578___rgo_7374642f666d74__concat_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1578___rgo_7374642f666d74__concat_nth_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1578___rgo_7374642f666d74__concat_nth_release_skip_1
    mov rax, [r12-24] ; load _1578___rgo_7374642f666d74__concat_nth_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1578___rgo_7374642f666d74__concat_nth_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1578___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-16] ; load _1578___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1578___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1578___rgo_7374642f666d74__concat_nth_deepcopy
_1578___rgo_7374642f666d74__concat_nth_deepcopy:
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
    jg _1578___rgo_7374642f666d74__concat_nth_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1578___rgo_7374642f666d74__concat_nth_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1578___rgo_7374642f666d74__concat_nth_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1578___rgo_7374642f666d74__concat_nth_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1578___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1578___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    leave
    ret

global _1576___rgo_7374642f666d74__concat_nth
_1576___rgo_7374642f666d74__concat_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store idx arg in frame
    mov [rbp-16], rsi ; store l arg in frame
    mov [rbp-24], rdx ; store b arg in frame
    mov [rbp-32], rcx ; store empty_case arg in frame
    mov [rbp-40], r8 ; store one arg in frame
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
    lea rax, [_1578___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1578___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1578___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1579___rgo_7374642f666d74__concat_nth closure env_end to rax
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
global _1576___rgo_7374642f666d74__concat_nth_unwrapper
_1576___rgo_7374642f666d74__concat_nth_unwrapper:
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
    jmp _1576___rgo_7374642f666d74__concat_nth
global _1576___rgo_7374642f666d74__concat_nth_deep_release
_1576___rgo_7374642f666d74__concat_nth_deep_release:
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
    jg _1576___rgo_7374642f666d74__concat_nth_release_skip_2
    mov rax, [r12-24] ; load _1576___rgo_7374642f666d74__concat_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1576___rgo_7374642f666d74__concat_nth_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1576___rgo_7374642f666d74__concat_nth_release_skip_3
    mov rax, [r12-16] ; load _1576___rgo_7374642f666d74__concat_nth_release_field_3 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1576___rgo_7374642f666d74__concat_nth_release_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1576___rgo_7374642f666d74__concat_nth_release_skip_4
    mov rax, [r12-8] ; load _1576___rgo_7374642f666d74__concat_nth_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1576___rgo_7374642f666d74__concat_nth_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1576___rgo_7374642f666d74__concat_nth_deepcopy
_1576___rgo_7374642f666d74__concat_nth_deepcopy:
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
    jg _1576___rgo_7374642f666d74__concat_nth_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1576___rgo_7374642f666d74__concat_nth_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1576___rgo_7374642f666d74__concat_nth_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1576___rgo_7374642f666d74__concat_nth_deepcopy_skip_3:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1576___rgo_7374642f666d74__concat_nth_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1576___rgo_7374642f666d74__concat_nth_deepcopy_skip_4:
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
    mov rbx, [rbp-40] ; original closure empty_case to ___1574_a_arg_clone_1 env_end pointer for clone
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
    mov [rbp-64], rax ; store value
    mov rbx, [rbp-48] ; original closure one to ___1574_a_arg_clone_2 env_end pointer for clone
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
    mov rsi, 88 ; length for allocation
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
    lea rax, [_1576___rgo_7374642f666d74__concat_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1576___rgo_7374642f666d74__concat_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1576___rgo_7374642f666d74__concat_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1580___rgo_7374642f666d74__concat_nth closure env_end to rax
    mov [rbp-80], rax ; store value
    mov rax, [rbp-32] ; load operand
    mov rbx, [rbp-8] ; load operand
    cmp rax, rbx
    jb lt_uint__1574_a_true_0_0
lt_uint__1580___rgo_7374642f666d74__concat_nth_false_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-56] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-80] ; load _1580___rgo_7374642f666d74__concat_nth closure env_end pointer
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
lt_uint__1574_a_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-80] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-56] ; load _1574_a closure env_end pointer
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

global _1586___rgo_7374642f666d74__concat
_1586___rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store a_l arg in frame
    mov [rbp-24], rdx ; store a_nth arg in frame
    mov [rbp-32], rcx ; store b_nth arg in frame
    mov [rbp-40], r8 ; store l arg in frame
    mov rsi, 96 ; length for allocation
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
    mov rax, r12 ; copy _1587___rgo_7374642f666d74__concat_nth closure env_end to rax
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
global _1586___rgo_7374642f666d74__concat_unwrapper
_1586___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _1586___rgo_7374642f666d74__concat
global _1586___rgo_7374642f666d74__concat_deep_release
_1586___rgo_7374642f666d74__concat_deep_release:
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
    jg _1586___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-40] ; load _1586___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1586___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1586___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _1586___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1586___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1586___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-16] ; load _1586___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1586___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1586___rgo_7374642f666d74__concat_deepcopy
_1586___rgo_7374642f666d74__concat_deepcopy:
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
    jg _1586___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-40] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-40], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1586___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1586___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1586___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1586___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1586___rgo_7374642f666d74__concat_deepcopy_skip_3:
    leave
    ret

global _1584___rgo_7374642f666d74__concat
_1584___rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a_l arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov [rbp-24], rdx ; store a_nth arg in frame
    mov [rbp-32], rcx ; store b_l arg in frame
    mov [rbp-40], r8 ; store b_nth arg in frame
    mov rsi, 88 ; length for allocation
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
    lea rax, [_1586___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1586___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1586___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1588___rgo_7374642f666d74__concat closure env_end to rax
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
global _1584___rgo_7374642f666d74__concat_unwrapper
_1584___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _1584___rgo_7374642f666d74__concat
global _1584___rgo_7374642f666d74__concat_deep_release
_1584___rgo_7374642f666d74__concat_deep_release:
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
    jg _1584___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-32] ; load _1584___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1584___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1584___rgo_7374642f666d74__concat_release_skip_2
    mov rax, [r12-24] ; load _1584___rgo_7374642f666d74__concat_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1584___rgo_7374642f666d74__concat_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1584___rgo_7374642f666d74__concat_release_skip_4
    mov rax, [r12-8] ; load _1584___rgo_7374642f666d74__concat_release_field_4 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1584___rgo_7374642f666d74__concat_release_skip_4:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1584___rgo_7374642f666d74__concat_deepcopy
_1584___rgo_7374642f666d74__concat_deepcopy:
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
    jg _1584___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1584___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1584___rgo_7374642f666d74__concat_deepcopy_skip_2
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1584___rgo_7374642f666d74__concat_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1584___rgo_7374642f666d74__concat_deepcopy_skip_4
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1584___rgo_7374642f666d74__concat_deepcopy_skip_4:
    leave
    ret

global _1582___rgo_7374642f666d74__concat
_1582___rgo_7374642f666d74__concat:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
    mov [rbp-24], rdx ; store a_l arg in frame
    mov [rbp-32], rcx ; store a_nth arg in frame
    mov rsi, 88 ; length for allocation
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
    lea rax, [_1584___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1584___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1584___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _1589___rgo_7374642f666d74__concat closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _1582___rgo_7374642f666d74__concat_unwrapper
_1582___rgo_7374642f666d74__concat_unwrapper:
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
    jmp _1582___rgo_7374642f666d74__concat
global _1582___rgo_7374642f666d74__concat_deep_release
_1582___rgo_7374642f666d74__concat_deep_release:
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
    jg _1582___rgo_7374642f666d74__concat_release_skip_0
    mov rax, [r12-32] ; load _1582___rgo_7374642f666d74__concat_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1582___rgo_7374642f666d74__concat_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1582___rgo_7374642f666d74__concat_release_skip_1
    mov rax, [r12-24] ; load _1582___rgo_7374642f666d74__concat_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1582___rgo_7374642f666d74__concat_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1582___rgo_7374642f666d74__concat_release_skip_3
    mov rax, [r12-8] ; load _1582___rgo_7374642f666d74__concat_release_field_3 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1582___rgo_7374642f666d74__concat_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1582___rgo_7374642f666d74__concat_deepcopy
_1582___rgo_7374642f666d74__concat_deepcopy:
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
    jg _1582___rgo_7374642f666d74__concat_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1582___rgo_7374642f666d74__concat_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1582___rgo_7374642f666d74__concat_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1582___rgo_7374642f666d74__concat_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1582___rgo_7374642f666d74__concat_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1582___rgo_7374642f666d74__concat_deepcopy_skip_3:
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1582___rgo_7374642f666d74__concat_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1582___rgo_7374642f666d74__concat_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1582___rgo_7374642f666d74__concat_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy _1590___rgo_7374642f666d74__concat closure env_end to rax
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
    je eq_uint__1565_one_true_0_0
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
eq_uint__1565_one_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-40] ; load _1565_one closure env_end pointer
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
    lea rax, [__rgo_7374642f666d74__single_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__single_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__single_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy _1567___rgo_7374642f666d74__single_nth closure env_end to rax
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

global _1601___rgo_7374642f666d74__f64_nth
_1601___rgo_7374642f666d74__f64_nth:
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
global _1601___rgo_7374642f666d74__f64_nth_unwrapper
_1601___rgo_7374642f666d74__f64_nth_unwrapper:
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
    jmp _1601___rgo_7374642f666d74__f64_nth
global _1601___rgo_7374642f666d74__f64_nth_deep_release
_1601___rgo_7374642f666d74__f64_nth_deep_release:
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
    jg _1601___rgo_7374642f666d74__f64_nth_release_skip_0
    mov rax, [r12-16] ; load _1601___rgo_7374642f666d74__f64_nth_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1601___rgo_7374642f666d74__f64_nth_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1601___rgo_7374642f666d74__f64_nth_deepcopy
_1601___rgo_7374642f666d74__f64_nth_deepcopy:
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
    jg _1601___rgo_7374642f666d74__f64_nth_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1601___rgo_7374642f666d74__f64_nth_deepcopy_skip_0:
    leave
    ret

global _1599___rgo_7374642f666d74__f64_nth
_1599___rgo_7374642f666d74__f64_nth:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store idx arg in frame
    mov [rbp-24], rdx ; store one arg in frame
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
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1601___rgo_7374642f666d74__f64_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1601___rgo_7374642f666d74__f64_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1601___rgo_7374642f666d74__f64_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1602___rgo_7374642f666d74__f64_nth closure env_end to rax
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
global _1599___rgo_7374642f666d74__f64_nth_unwrapper
_1599___rgo_7374642f666d74__f64_nth_unwrapper:
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
    jmp _1599___rgo_7374642f666d74__f64_nth
global _1599___rgo_7374642f666d74__f64_nth_deep_release
_1599___rgo_7374642f666d74__f64_nth_deep_release:
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
    jg _1599___rgo_7374642f666d74__f64_nth_release_skip_2
    mov rax, [r12-8] ; load _1599___rgo_7374642f666d74__f64_nth_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1599___rgo_7374642f666d74__f64_nth_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1599___rgo_7374642f666d74__f64_nth_deepcopy
_1599___rgo_7374642f666d74__f64_nth_deepcopy:
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
    jg _1599___rgo_7374642f666d74__f64_nth_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1599___rgo_7374642f666d74__f64_nth_deepcopy_skip_2:
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
    lea rax, [_1599___rgo_7374642f666d74__f64_nth_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1599___rgo_7374642f666d74__f64_nth_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1599___rgo_7374642f666d74__f64_nth_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1603___rgo_7374642f666d74__f64_nth closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rax, [rbp-24] ; load operand
    mov rbx, [rbp-16] ; load operand
    cmp rax, rbx
    jb lt_uint__1603___rgo_7374642f666d74__f64_nth_true_0_0
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
lt_uint__1603___rgo_7374642f666d74__f64_nth_true_0_0:
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
    mov rbx, [rbp-48] ; load _1603___rgo_7374642f666d74__f64_nth closure env_end pointer
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

global _1605___rgo_7374642f666d74__f64_source
_1605___rgo_7374642f666d74__f64_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store inspect_value arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov [rbp-24], rdx ; store l arg in frame
    mov rsi, 88 ; length for allocation
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
    mov rax, r12 ; copy _1606___rgo_7374642f666d74__f64_nth closure env_end to rax
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
global _1605___rgo_7374642f666d74__f64_source_unwrapper
_1605___rgo_7374642f666d74__f64_source_unwrapper:
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
    jmp _1605___rgo_7374642f666d74__f64_source
global _1605___rgo_7374642f666d74__f64_source_deep_release
_1605___rgo_7374642f666d74__f64_source_deep_release:
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
    jg _1605___rgo_7374642f666d74__f64_source_release_skip_0
    mov rax, [r12-24] ; load _1605___rgo_7374642f666d74__f64_source_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1605___rgo_7374642f666d74__f64_source_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1605___rgo_7374642f666d74__f64_source_deepcopy
_1605___rgo_7374642f666d74__f64_source_deepcopy:
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
    jg _1605___rgo_7374642f666d74__f64_source_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1605___rgo_7374642f666d74__f64_source_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f666d74__f64_source
__rgo_7374642f666d74__f64_source:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store inspect_value arg in frame
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
    lea rax, [_1605___rgo_7374642f666d74__f64_source_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1605___rgo_7374642f666d74__f64_source_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1605___rgo_7374642f666d74__f64_source_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1607___rgo_7374642f666d74__f64_source closure env_end to rax
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

global _1790___rgo_7374642f666d74__new
_1790___rgo_7374642f666d74__new:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    ; load exit code
    mov rdi, 1 ; operand literal
    mov rax, 60 ; exit syscall
    syscall
global _1790___rgo_7374642f666d74__new_unwrapper
_1790___rgo_7374642f666d74__new_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave ; unwind before named jump
    jmp _1790___rgo_7374642f666d74__new
global _1790___rgo_7374642f666d74__new_deep_release
_1790___rgo_7374642f666d74__new_deep_release:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1790___rgo_7374642f666d74__new_deepcopy
_1790___rgo_7374642f666d74__new_deepcopy:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    leave
    ret

global _1809_show
_1809_show:
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
global _1809_show_unwrapper
_1809_show_unwrapper:
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
    jmp _1809_show
global _1809_show_deep_release
_1809_show_deep_release:
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
    jg _1809_show_release_skip_0
    mov rax, [r12-16] ; load _1809_show_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1809_show_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1809_show_release_skip_1
    mov rax, [r12-8] ; load _1809_show_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_1809_show_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1809_show_deepcopy
_1809_show_deepcopy:
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
    jg _1809_show_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1809_show_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1809_show_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1809_show_deepcopy_skip_1:
    leave
    ret

global _1808_show
_1808_show:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
    mov [rbp-16], rsi ; store _1787___rgo_7374642f666d74__new arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    mov rax, [rbp-8] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    leave ; unwind before named jump
    jmp _1809_show
global _1808_show_unwrapper
_1808_show_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load ok env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-8] ; load _1787___rgo_7374642f666d74__new env field
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
    jmp _1808_show
global _1808_show_deep_release
_1808_show_deep_release:
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
    jg _1808_show_release_skip_0
    mov rax, [r12-16] ; load _1808_show_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1808_show_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1808_show_release_skip_1
    mov rax, [r12-8] ; load _1808_show_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_1808_show_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1808_show_deepcopy
_1808_show_deepcopy:
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
    jg _1808_show_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1808_show_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1808_show_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1808_show_deepcopy_skip_1:
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
global _1625___rgo_7374642f666d74__finish
_1625___rgo_7374642f666d74__finish:
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
    jz _1625___rgo_7374642f666d74__finish_str_from_utf8_invalid_0
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
_1625___rgo_7374642f666d74__finish_str_from_utf8_invalid_0:
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
global _1625___rgo_7374642f666d74__finish_unwrapper
_1625___rgo_7374642f666d74__finish_unwrapper:
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
    jmp _1625___rgo_7374642f666d74__finish
global _1625___rgo_7374642f666d74__finish_deep_release
_1625___rgo_7374642f666d74__finish_deep_release:
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
    jg _1625___rgo_7374642f666d74__finish_release_skip_0
    mov rax, [r12-24] ; load _1625___rgo_7374642f666d74__finish_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1625___rgo_7374642f666d74__finish_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1625___rgo_7374642f666d74__finish_release_skip_1
    mov rax, [r12-16] ; load _1625___rgo_7374642f666d74__finish_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1625___rgo_7374642f666d74__finish_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1625___rgo_7374642f666d74__finish_release_skip_2
    mov rax, [r12-8] ; load _1625___rgo_7374642f666d74__finish_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
_1625___rgo_7374642f666d74__finish_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1625___rgo_7374642f666d74__finish_deepcopy
_1625___rgo_7374642f666d74__finish_deepcopy:
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
    jg _1625___rgo_7374642f666d74__finish_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1625___rgo_7374642f666d74__finish_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1625___rgo_7374642f666d74__finish_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1625___rgo_7374642f666d74__finish_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg _1625___rgo_7374642f666d74__finish_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1625___rgo_7374642f666d74__finish_deepcopy_skip_2:
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
global show
show:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 160 ; reserve stack space for locals
    mov [rbp-8], rdi ; store label arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store value arg in frame
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
    mov rax, r12 ; copy __comptime_203 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    lea rax, [__rgo_7374642f666d74__empty_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f666d74__empty_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f666d74__empty_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f666d74__empty closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov rax, r12 ; copy __comptime_204 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    mov rax, 58 ; operand literal
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
    mov rax, r12 ; copy __comptime_206 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, r12 ; copy __comptime_207 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, r12 ; copy __comptime_209 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, r12 ; copy __comptime_210 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
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
    mov rax, r12 ; copy __comptime_211 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov rax, r12 ; copy __comptime_212 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov rax, r12 ; copy __comptime_214 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov rax, r12 ; copy __comptime_215 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    lea rax, [_1790___rgo_7374642f666d74__new_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1790___rgo_7374642f666d74__new_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1790___rgo_7374642f666d74__new_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1790___rgo_7374642f666d74__new closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rbx, [rbp-120] ; original closure _1790___rgo_7374642f666d74__new to ____comptime_217_arg_clone_1 env_end pointer for clone
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
    mov [rbp-128], rax ; store value
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
    lea rax, [rel __comptime_216] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-128] ; load operand
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
    mov rax, r12 ; copy __comptime_217 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    lea rax, [rel __comptime_218] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-120] ; load operand
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
    mov rax, r12 ; copy __comptime_219 closure env_end to rax
    mov [rbp-144], rax ; store value
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
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1808_show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1808_show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1808_show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_220 closure env_end to rax
    mov [rbp-152], rax ; store value
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
    lea rax, [_1625___rgo_7374642f666d74__finish_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1625___rgo_7374642f666d74__finish_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1625___rgo_7374642f666d74__finish_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_221 closure env_end to rax
    mov [rbp-160], rax ; store value
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
    mov rax, [rbp-136] ; load operand
    mov [rbx], rax
    mov rax, [rbp-160] ; load operand
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
    mov rbx, [rbp-112] ; load operand
    mov [rbx-8], r12
    mov qword [rbx+40], 0
    mov rdi, rbx
    mov rax, [rbx]
    leave
    jmp rax
global show_unwrapper
show_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load label env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load value env field
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
    jmp show
global show_deep_release
show_deep_release:
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
    jg show_release_skip_0
    mov rax, [r12-24] ; load show_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
show_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg show_release_skip_1
    mov rax, [r12-16] ; load show_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
show_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global show_deepcopy
show_deepcopy:
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
    jg show_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
show_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg show_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
show_deepcopy_skip_1:
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
    jg compile_error_deep_release_compile_error_release_skip_0
    mov rax, [r12-16] ; load compile_error_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    call release_descriptor_ptr ; release owned descriptor
    pop r12 ; restore current environment
compile_error_deep_release_compile_error_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg compile_error_deep_release_compile_error_release_skip_1
    mov rax, [r12-8] ; load compile_error_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
compile_error_deep_release_compile_error_release_skip_1:
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
    jg compile_error_deepcopy_compile_error_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call clone_descriptor_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
compile_error_deepcopy_compile_error_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg compile_error_deepcopy_compile_error_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
compile_error_deepcopy_compile_error_deepcopy_skip_1:
    leave
    ret

global variable_case
variable_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
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
    lea rax, [rel __comptime_277] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_278 closure env_end to rax
    mov [rbp-24], rax ; store value
    movsd xmm0, [rbp-8] ; load float operand
    mov rax, 0x4000000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    sub rsp, 8 ; align stack for native call
    call freestanding_math_pow
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global variable_case_unwrapper
variable_case_unwrapper:
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
    jmp variable_case
global variable_case_deep_release
variable_case_deep_release:
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
    jg variable_case_release_skip_1
    mov rax, [r12-8] ; load variable_case_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
variable_case_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global variable_case_deepcopy
variable_case_deepcopy:
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
    jg variable_case_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
variable_case_deepcopy_skip_1:
    leave
    ret

global constants_case
constants_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store ok arg in frame
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
    lea rax, [rel __comptime_2] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_3 closure env_end to rax
    mov [rbp-16], rax ; store value
    mov rax, 0x401921fb54442d18 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x400921fb54442d18 ; load literal float bits
    movq xmm1, rax ; load float literal
    divsd xmm0, xmm1 ; divide by divisor float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global constants_case_unwrapper
constants_case_unwrapper:
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
    jmp constants_case
global constants_case_deep_release
constants_case_deep_release:
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
    jg constants_case_release_skip_0
    mov rax, [r12-8] ; load constants_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
constants_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global constants_case_deepcopy
constants_case_deepcopy:
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
    jg constants_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
constants_case_deepcopy_skip_0:
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

global _529___rgo_7374642f6d6174682f63616c63__append_digit
_529___rgo_7374642f6d6174682f63616c63__append_digit:
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
global _529___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper
_529___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper:
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
    jmp _529___rgo_7374642f6d6174682f63616c63__append_digit
global _529___rgo_7374642f6d6174682f63616c63__append_digit_deep_release
_529___rgo_7374642f6d6174682f63616c63__append_digit_deep_release:
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
    jg _529___rgo_7374642f6d6174682f63616c63__append_digit_release_skip_1
    mov rax, [r12-16] ; load _529___rgo_7374642f6d6174682f63616c63__append_digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_529___rgo_7374642f6d6174682f63616c63__append_digit_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy
_529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy:
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
    jg _529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_1:
    leave
    ret

global _526___rgo_7374642f6d6174682f63616c63__append_digit
_526___rgo_7374642f6d6174682f63616c63__append_digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store digit arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store prefix_value arg in frame
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
    movsd xmm0, [rbp-8] ; load float operand
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
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _530___rgo_7374642f6d6174682f63616c63__append_digit closure env_end to rax
    mov [rbp-32], rax ; store value
    movsd xmm0, [rbp-24] ; load float operand
    mov rax, 0x4024000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _526___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper
_526___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load digit env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load prefix_value env field
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
    jmp _526___rgo_7374642f6d6174682f63616c63__append_digit
global _526___rgo_7374642f6d6174682f63616c63__append_digit_deep_release
_526___rgo_7374642f6d6174682f63616c63__append_digit_deep_release:
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
    jg _526___rgo_7374642f6d6174682f63616c63__append_digit_release_skip_1
    mov rax, [r12-16] ; load _526___rgo_7374642f6d6174682f63616c63__append_digit_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_526___rgo_7374642f6d6174682f63616c63__append_digit_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _526___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy
_526___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy:
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
    jg _526___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_526___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__append_digit
__rgo_7374642f6d6174682f63616c63__append_digit:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store prefix arg in frame
    mov [rbp-16], rsi ; store digit arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
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
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_526___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_526___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_526___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _531___rgo_7374642f6d6174682f63616c63__append_digit closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load prefix closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__append_digit_unwrapper
__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load prefix env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load digit env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
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
    jmp __rgo_7374642f6d6174682f63616c63__append_digit
global __rgo_7374642f6d6174682f63616c63__append_digit_deep_release
__rgo_7374642f6d6174682f63616c63__append_digit_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__append_digit_release_skip_0
    mov rax, [r12-24] ; load __rgo_7374642f6d6174682f63616c63__append_digit_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__append_digit_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__append_digit_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__append_digit_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__append_digit_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__append_digit_deepcopy
__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy_skip_2:
    leave
    ret

global _514___rgo_7374642f6d6174682f63616c63__divide
_514___rgo_7374642f6d6174682f63616c63__divide:
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
global _514___rgo_7374642f6d6174682f63616c63__divide_unwrapper
_514___rgo_7374642f6d6174682f63616c63__divide_unwrapper:
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
    jmp _514___rgo_7374642f6d6174682f63616c63__divide
global _514___rgo_7374642f6d6174682f63616c63__divide_deep_release
_514___rgo_7374642f6d6174682f63616c63__divide_deep_release:
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
    jg _514___rgo_7374642f6d6174682f63616c63__divide_release_skip_1
    mov rax, [r12-16] ; load _514___rgo_7374642f6d6174682f63616c63__divide_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_514___rgo_7374642f6d6174682f63616c63__divide_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _514___rgo_7374642f6d6174682f63616c63__divide_deepcopy
_514___rgo_7374642f6d6174682f63616c63__divide_deepcopy:
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
    jg _514___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_514___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1:
    leave
    ret

global _512___rgo_7374642f6d6174682f63616c63__divide
_512___rgo_7374642f6d6174682f63616c63__divide:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store a_value arg in frame
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
    lea rax, [_514___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_514___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_514___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _515___rgo_7374642f6d6174682f63616c63__divide closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _512___rgo_7374642f6d6174682f63616c63__divide_unwrapper
_512___rgo_7374642f6d6174682f63616c63__divide_unwrapper:
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
    jmp _512___rgo_7374642f6d6174682f63616c63__divide
global _512___rgo_7374642f6d6174682f63616c63__divide_deep_release
_512___rgo_7374642f6d6174682f63616c63__divide_deep_release:
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
    jg _512___rgo_7374642f6d6174682f63616c63__divide_release_skip_0
    mov rax, [r12-24] ; load _512___rgo_7374642f6d6174682f63616c63__divide_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_512___rgo_7374642f6d6174682f63616c63__divide_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _512___rgo_7374642f6d6174682f63616c63__divide_release_skip_1
    mov rax, [r12-16] ; load _512___rgo_7374642f6d6174682f63616c63__divide_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_512___rgo_7374642f6d6174682f63616c63__divide_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _512___rgo_7374642f6d6174682f63616c63__divide_deepcopy
_512___rgo_7374642f6d6174682f63616c63__divide_deepcopy:
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
    jg _512___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_512___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _512___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_512___rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__divide
__rgo_7374642f6d6174682f63616c63__divide:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a arg in frame
    mov [rbp-16], rsi ; store b arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _516___rgo_7374642f6d6174682f63616c63__divide closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load a closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__divide_unwrapper
__rgo_7374642f6d6174682f63616c63__divide_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load b env field
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
    jmp __rgo_7374642f6d6174682f63616c63__divide
global __rgo_7374642f6d6174682f63616c63__divide_deep_release
__rgo_7374642f6d6174682f63616c63__divide_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__divide_release_skip_0
    mov rax, [r12-24] ; load __rgo_7374642f6d6174682f63616c63__divide_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__divide_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__divide_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f6d6174682f63616c63__divide_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__divide_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__divide_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__divide_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__divide_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__divide_deepcopy
__rgo_7374642f6d6174682f63616c63__divide_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f6d6174682f63616c63__divide_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__floor
__rgo_7374642f6d617468__floor:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_floor
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__floor_unwrapper
__rgo_7374642f6d617468__floor_unwrapper:
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
    jmp __rgo_7374642f6d617468__floor
global __rgo_7374642f6d617468__floor_deep_release
__rgo_7374642f6d617468__floor_deep_release:
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
    jg __rgo_7374642f6d617468__floor_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__floor_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__floor_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__floor_deepcopy
__rgo_7374642f6d617468__floor_deepcopy:
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
    jg __rgo_7374642f6d617468__floor_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__floor_deepcopy_skip_1:
    leave
    ret

global _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store operation arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store number arg in frame
    mov rbx, [rbp-8] ; load operation closure env_end pointer
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-16] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load operation env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load number env field
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
    jmp _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation
global _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release:
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
    jg _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_0
    mov rax, [r12-24] ; load _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_1
    mov rax, [r12-16] ; load _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy:
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
    jg _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__apply_unary_operation
__rgo_7374642f6d6174682f63616c63__apply_unary_operation:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store operation arg in frame
    mov [rbp-16], rsi ; store value arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
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
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1209___rgo_7374642f6d6174682f63616c63__apply_unary_operation closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-16] ; load value closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load operation env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load value env field
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
    jmp __rgo_7374642f6d6174682f63616c63__apply_unary_operation
global __rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_0
    mov rax, [r12-24] ; load __rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__round
__rgo_7374642f6d617468__round:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_round
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__round_unwrapper
__rgo_7374642f6d617468__round_unwrapper:
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
    jmp __rgo_7374642f6d617468__round
global __rgo_7374642f6d617468__round_deep_release
__rgo_7374642f6d617468__round_deep_release:
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
    jg __rgo_7374642f6d617468__round_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__round_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__round_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__round_deepcopy
__rgo_7374642f6d617468__round_deepcopy:
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
    jg __rgo_7374642f6d617468__round_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__round_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__trunc
__rgo_7374642f6d617468__trunc:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_trunc
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__trunc_unwrapper
__rgo_7374642f6d617468__trunc_unwrapper:
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
    jmp __rgo_7374642f6d617468__trunc
global __rgo_7374642f6d617468__trunc_deep_release
__rgo_7374642f6d617468__trunc_deep_release:
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
    jg __rgo_7374642f6d617468__trunc_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__trunc_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__trunc_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__trunc_deepcopy
__rgo_7374642f6d617468__trunc_deepcopy:
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
    jg __rgo_7374642f6d617468__trunc_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__trunc_deepcopy_skip_1:
    leave
    ret

global _488___rgo_7374642f6d6174682f63616c63__add
_488___rgo_7374642f6d6174682f63616c63__add:
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
global _488___rgo_7374642f6d6174682f63616c63__add_unwrapper
_488___rgo_7374642f6d6174682f63616c63__add_unwrapper:
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
    jmp _488___rgo_7374642f6d6174682f63616c63__add
global _488___rgo_7374642f6d6174682f63616c63__add_deep_release
_488___rgo_7374642f6d6174682f63616c63__add_deep_release:
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
    jg _488___rgo_7374642f6d6174682f63616c63__add_release_skip_1
    mov rax, [r12-16] ; load _488___rgo_7374642f6d6174682f63616c63__add_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_488___rgo_7374642f6d6174682f63616c63__add_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _488___rgo_7374642f6d6174682f63616c63__add_deepcopy
_488___rgo_7374642f6d6174682f63616c63__add_deepcopy:
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
    jg _488___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_488___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_1:
    leave
    ret

global _486___rgo_7374642f6d6174682f63616c63__add
_486___rgo_7374642f6d6174682f63616c63__add:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store a_value arg in frame
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
    lea rax, [_488___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_488___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_488___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _489___rgo_7374642f6d6174682f63616c63__add closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _486___rgo_7374642f6d6174682f63616c63__add_unwrapper
_486___rgo_7374642f6d6174682f63616c63__add_unwrapper:
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
    jmp _486___rgo_7374642f6d6174682f63616c63__add
global _486___rgo_7374642f6d6174682f63616c63__add_deep_release
_486___rgo_7374642f6d6174682f63616c63__add_deep_release:
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
    jg _486___rgo_7374642f6d6174682f63616c63__add_release_skip_0
    mov rax, [r12-24] ; load _486___rgo_7374642f6d6174682f63616c63__add_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_486___rgo_7374642f6d6174682f63616c63__add_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _486___rgo_7374642f6d6174682f63616c63__add_release_skip_1
    mov rax, [r12-16] ; load _486___rgo_7374642f6d6174682f63616c63__add_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_486___rgo_7374642f6d6174682f63616c63__add_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _486___rgo_7374642f6d6174682f63616c63__add_deepcopy
_486___rgo_7374642f6d6174682f63616c63__add_deepcopy:
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
    jg _486___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_486___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _486___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_486___rgo_7374642f6d6174682f63616c63__add_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__ceil
__rgo_7374642f6d617468__ceil:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_ceil
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__ceil_unwrapper
__rgo_7374642f6d617468__ceil_unwrapper:
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
    jmp __rgo_7374642f6d617468__ceil
global __rgo_7374642f6d617468__ceil_deep_release
__rgo_7374642f6d617468__ceil_deep_release:
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
    jg __rgo_7374642f6d617468__ceil_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__ceil_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__ceil_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__ceil_deepcopy
__rgo_7374642f6d617468__ceil_deepcopy:
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
    jg __rgo_7374642f6d617468__ceil_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__ceil_deepcopy_skip_1:
    leave
    ret

global rounding_case
rounding_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 224 ; reserve stack space for locals
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
    mov rax, r12 ; copy __comptime_170 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov rax, r12 ; copy __comptime_172 closure env_end to rax
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
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x4022000000000000 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_174 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, r12 ; copy __comptime_176 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_177 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__floor_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__floor_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__floor_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__floor closure env_end to rax
    mov [rbp-56], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_178 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, r12 ; copy __comptime_180 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x4018000000000000 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_182 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, r12 ; copy __comptime_184 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_185 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__round_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__round_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__round_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__round closure env_end to rax
    mov [rbp-104], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_186 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov rax, r12 ; copy __comptime_188 closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, [rbp-120] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x4022000000000000 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_190 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    mov rax, r12 ; copy __comptime_192 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_193 closure env_end to rax
    mov [rbp-144], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__trunc_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__trunc_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__trunc_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__trunc closure env_end to rax
    mov [rbp-152], rax ; store value
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
    mov rax, [rbp-152] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-144] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_194 closure env_end to rax
    mov [rbp-160], rax ; store value
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
    lea rax, [rel __comptime_195] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_196 closure env_end to rax
    mov [rbp-168], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_197 closure env_end to rax
    mov [rbp-176], rax ; store value
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
    mov rax, [rbp-112] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-176] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_198 closure env_end to rax
    mov [rbp-184], rax ; store value
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
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-184] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_199 closure env_end to rax
    mov [rbp-192], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__ceil_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__ceil_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__ceil_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__ceil closure env_end to rax
    mov [rbp-200], rax ; store value
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
    mov rax, [rbp-200] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-192] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_200 closure env_end to rax
    mov [rbp-208], rax ; store value
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-208] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_201 closure env_end to rax
    mov [rbp-216], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-216] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_202 closure env_end to rax
    mov [rbp-224], rax ; store value
    mov rax, 0x4000000000000000 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4024000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-224] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global rounding_case_unwrapper
rounding_case_unwrapper:
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
    jmp rounding_case
global rounding_case_deep_release
rounding_case_deep_release:
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
    jg rounding_case_release_skip_0
    mov rax, [r12-8] ; load rounding_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
rounding_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global rounding_case_deepcopy
rounding_case_deepcopy:
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
    jg rounding_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
rounding_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__max_f64
__rgo_7374642f6d617468__max_f64:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a arg in frame
    mov [rbp-16], rsi ; store b arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_fmax
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__max_f64_unwrapper
__rgo_7374642f6d617468__max_f64_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load b env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__max_f64
global __rgo_7374642f6d617468__max_f64_deep_release
__rgo_7374642f6d617468__max_f64_deep_release:
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
    jg __rgo_7374642f6d617468__max_f64_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__max_f64_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__max_f64_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__max_f64_deepcopy
__rgo_7374642f6d617468__max_f64_deepcopy:
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
    jg __rgo_7374642f6d617468__max_f64_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__max_f64_deepcopy_skip_2:
    leave
    ret

global _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store operation arg in frame
    mov [rbp-16], rsi ; store a_value arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store b_value arg in frame
    mov rbx, [rbp-8] ; load operation closure env_end pointer
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    mov [rbx-24], rax ; store env field
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
    mov [rbx-16], rax ; store env field
    mov rax, [rbp-24] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load operation env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load a_value env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load b_value env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-40] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
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
    pop rcx ; restore arg into register
    leave ; unwind before named jump
    jmp _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation
global _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release:
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
    jg _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_0
    mov rax, [r12-32] ; load _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_2
    mov rax, [r12-16] ; load _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_2 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy:
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
    jg _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_2:
    leave
    ret

global _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store operation arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    mov [rbp-32], rcx ; store a_value arg in frame
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
    mov [rbx+0], rax ; move closure pointer into environment
    movsd xmm0, [rbp-32] ; load float operand
    movq rax, xmm0
    mov [rbx+8], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1218___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1219___rgo_7374642f6d6174682f63616c63__apply_binary_operation closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load b env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load operation env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load a_value env field
    mov [rbp-40], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    movsd xmm0, [rbp-40] ; load float operand
    movq rax, xmm0
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
    jmp _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation
global _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release:
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
    jg _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_0
    mov rax, [r12-32] ; load _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_1
    mov rax, [r12-24] ; load _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_2
    mov rax, [r12-16] ; load _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy:
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
    jg _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__apply_binary_operation
__rgo_7374642f6d6174682f63616c63__apply_binary_operation:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store operation arg in frame
    mov [rbp-16], rsi ; store a arg in frame
    mov [rbp-24], rdx ; store b arg in frame
    mov [rbp-32], rcx ; store ok arg in frame
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
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-32] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1216___rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _1220___rgo_7374642f6d6174682f63616c63__apply_binary_operation closure env_end to rax
    mov [rbp-40], rax ; store value
    mov rbx, [rbp-16] ; load a closure env_end pointer
    mov rax, [rbp-40] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 48 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-32] ; load operation env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-24] ; load a env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-16] ; load b env field
    mov [rbp-32], rax ; store value
    mov rax, [r12-8] ; load ok env field
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
    jmp __rgo_7374642f6d6174682f63616c63__apply_binary_operation
global __rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_0
    mov rax, [r12-32] ; load __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_1
    mov rax, [r12-24] ; load __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_2
    mov rax, [r12-16] ; load __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_3
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_field_3 env field
    mov [rbp-48], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-48] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_release_skip_3:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_0
    mov rcx, [r12-32] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-32], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 2 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_1
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_2
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_2:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_3
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-48], rax ; store value
__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy_skip_3:
    leave
    ret

global __rgo_7374642f6d617468__min_f64
__rgo_7374642f6d617468__min_f64:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a arg in frame
    mov [rbp-16], rsi ; store b arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_fmin
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__min_f64_unwrapper
__rgo_7374642f6d617468__min_f64_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load b env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__min_f64
global __rgo_7374642f6d617468__min_f64_deep_release
__rgo_7374642f6d617468__min_f64_deep_release:
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
    jg __rgo_7374642f6d617468__min_f64_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__min_f64_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__min_f64_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__min_f64_deepcopy
__rgo_7374642f6d617468__min_f64_deepcopy:
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
    jg __rgo_7374642f6d617468__min_f64_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__min_f64_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__mod
__rgo_7374642f6d617468__mod:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store dividend arg in frame
    mov [rbp-16], rsi ; store divisor arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_fmod
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__mod_unwrapper
__rgo_7374642f6d617468__mod_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load dividend env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load divisor env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__mod
global __rgo_7374642f6d617468__mod_deep_release
__rgo_7374642f6d617468__mod_deep_release:
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
    jg __rgo_7374642f6d617468__mod_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__mod_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__mod_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__mod_deepcopy
__rgo_7374642f6d617468__mod_deepcopy:
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
    jg __rgo_7374642f6d617468__mod_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__mod_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__remainder
__rgo_7374642f6d617468__remainder:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store dividend arg in frame
    mov [rbp-16], rsi ; store divisor arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_remainder
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__remainder_unwrapper
__rgo_7374642f6d617468__remainder_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load dividend env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load divisor env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__remainder
global __rgo_7374642f6d617468__remainder_deep_release
__rgo_7374642f6d617468__remainder_deep_release:
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
    jg __rgo_7374642f6d617468__remainder_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__remainder_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__remainder_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__remainder_deepcopy
__rgo_7374642f6d617468__remainder_deepcopy:
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
    jg __rgo_7374642f6d617468__remainder_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__remainder_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__abs
__rgo_7374642f6d617468__abs:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_fabs
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__abs_unwrapper
__rgo_7374642f6d617468__abs_unwrapper:
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
    jmp __rgo_7374642f6d617468__abs
global __rgo_7374642f6d617468__abs_deep_release
__rgo_7374642f6d617468__abs_deep_release:
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
    jg __rgo_7374642f6d617468__abs_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__abs_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__abs_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__abs_deepcopy
__rgo_7374642f6d617468__abs_deepcopy:
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
    jg __rgo_7374642f6d617468__abs_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__abs_deepcopy_skip_1:
    leave
    ret

global utility_case
utility_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 176 ; reserve stack space for locals
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
    mov rax, r12 ; copy __comptime_253 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov rax, 0x4014000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_255 closure env_end to rax
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__max_f64_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__max_f64_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__max_f64_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__max_f64 closure env_end to rax
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
    mov rbx, rax ; closure env base pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-16] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_256 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov rax, 0x4008000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_258 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    lea rax, [__rgo_7374642f6d617468__min_f64_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__min_f64_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__min_f64_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__min_f64 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-48] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_259 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, 0x401c000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_261 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, 0x4010000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_263 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    lea rax, [__rgo_7374642f6d617468__mod_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__mod_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__mod_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__mod closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov rax, [rbp-88] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-80] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_264 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov rax, 0x401c000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_266 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov rax, 0x4010000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_268 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    lea rax, [__rgo_7374642f6d617468__remainder_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__remainder_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__remainder_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__remainder closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, [rbp-120] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_269 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    lea rax, [rel __comptime_270] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_271 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_272 closure env_end to rax
    mov [rbp-144], rax ; store value
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
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-144] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_273 closure env_end to rax
    mov [rbp-152], rax ; store value
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
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_274 closure env_end to rax
    mov [rbp-160], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__abs_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__abs_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__abs_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__abs closure env_end to rax
    mov [rbp-168], rax ; store value
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
    mov rax, [rbp-168] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-160] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_275 closure env_end to rax
    mov [rbp-176], rax ; store value
    mov rax, 0x0 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4010000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    subsd xmm0, xmm1 ; subtract second float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-176] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global utility_case_unwrapper
utility_case_unwrapper:
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
    jmp utility_case
global utility_case_deep_release
utility_case_deep_release:
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
    jg utility_case_release_skip_0
    mov rax, [r12-8] ; load utility_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
utility_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global utility_case_deepcopy
utility_case_deepcopy:
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
    jg utility_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
utility_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__exp2
__rgo_7374642f6d617468__exp2:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_exp2
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__exp2_unwrapper
__rgo_7374642f6d617468__exp2_unwrapper:
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
    jmp __rgo_7374642f6d617468__exp2
global __rgo_7374642f6d617468__exp2_deep_release
__rgo_7374642f6d617468__exp2_deep_release:
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
    jg __rgo_7374642f6d617468__exp2_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__exp2_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__exp2_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__exp2_deepcopy
__rgo_7374642f6d617468__exp2_deepcopy:
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
    jg __rgo_7374642f6d617468__exp2_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__exp2_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__exp_m1
__rgo_7374642f6d617468__exp_m1:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_expm1
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__exp_m1_unwrapper
__rgo_7374642f6d617468__exp_m1_unwrapper:
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
    jmp __rgo_7374642f6d617468__exp_m1
global __rgo_7374642f6d617468__exp_m1_deep_release
__rgo_7374642f6d617468__exp_m1_deep_release:
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
    jg __rgo_7374642f6d617468__exp_m1_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__exp_m1_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__exp_m1_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__exp_m1_deepcopy
__rgo_7374642f6d617468__exp_m1_deepcopy:
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
    jg __rgo_7374642f6d617468__exp_m1_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__exp_m1_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__ln_1p
__rgo_7374642f6d617468__ln_1p:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_log1p
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__ln_1p_unwrapper
__rgo_7374642f6d617468__ln_1p_unwrapper:
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
    jmp __rgo_7374642f6d617468__ln_1p
global __rgo_7374642f6d617468__ln_1p_deep_release
__rgo_7374642f6d617468__ln_1p_deep_release:
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
    jg __rgo_7374642f6d617468__ln_1p_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__ln_1p_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__ln_1p_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__ln_1p_deepcopy
__rgo_7374642f6d617468__ln_1p_deepcopy:
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
    jg __rgo_7374642f6d617468__ln_1p_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__ln_1p_deepcopy_skip_1:
    leave
    ret

global exponential_case
exponential_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 112 ; reserve stack space for locals
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
    mov rax, 0x4008000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_6 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__exp2_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__exp2_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__exp2_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__exp2 closure env_end to rax
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_7 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov [rbp-40], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__exp_m1_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__exp_m1_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__exp_m1_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__exp_m1 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_10 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__ln_1p_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__ln_1p_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__ln_1p_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__ln_1p closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_13 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    lea rax, [rel __comptime_14] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_15 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_16 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-96] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_17 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_18 closure env_end to rax
    mov [rbp-112], rax ; store value
    mov rax, 0x0 ; load literal float bits
    movq xmm0, rax ; load float literal
    sub rsp, 8 ; align stack for native call
    call freestanding_math_exp
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-112] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global exponential_case_unwrapper
exponential_case_unwrapper:
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
    jmp exponential_case
global exponential_case_deep_release
exponential_case_deep_release:
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
    jg exponential_case_release_skip_0
    mov rax, [r12-8] ; load exponential_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
exponential_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global exponential_case_deepcopy
exponential_case_deepcopy:
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
    jg exponential_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
exponential_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__cosh
__rgo_7374642f6d617468__cosh:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_cosh
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__cosh_unwrapper
__rgo_7374642f6d617468__cosh_unwrapper:
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
    jmp __rgo_7374642f6d617468__cosh
global __rgo_7374642f6d617468__cosh_deep_release
__rgo_7374642f6d617468__cosh_deep_release:
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
    jg __rgo_7374642f6d617468__cosh_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__cosh_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__cosh_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__cosh_deepcopy
__rgo_7374642f6d617468__cosh_deepcopy:
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
    jg __rgo_7374642f6d617468__cosh_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__cosh_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__tanh
__rgo_7374642f6d617468__tanh:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_tanh
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__tanh_unwrapper
__rgo_7374642f6d617468__tanh_unwrapper:
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
    jmp __rgo_7374642f6d617468__tanh
global __rgo_7374642f6d617468__tanh_deep_release
__rgo_7374642f6d617468__tanh_deep_release:
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
    jg __rgo_7374642f6d617468__tanh_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__tanh_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__tanh_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__tanh_deepcopy
__rgo_7374642f6d617468__tanh_deepcopy:
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
    jg __rgo_7374642f6d617468__tanh_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__tanh_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__asinh
__rgo_7374642f6d617468__asinh:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_asinh
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__asinh_unwrapper
__rgo_7374642f6d617468__asinh_unwrapper:
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
    jmp __rgo_7374642f6d617468__asinh
global __rgo_7374642f6d617468__asinh_deep_release
__rgo_7374642f6d617468__asinh_deep_release:
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
    jg __rgo_7374642f6d617468__asinh_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__asinh_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__asinh_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__asinh_deepcopy
__rgo_7374642f6d617468__asinh_deepcopy:
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
    jg __rgo_7374642f6d617468__asinh_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__asinh_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__acosh
__rgo_7374642f6d617468__acosh:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_acosh
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__acosh_unwrapper
__rgo_7374642f6d617468__acosh_unwrapper:
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
    jmp __rgo_7374642f6d617468__acosh
global __rgo_7374642f6d617468__acosh_deep_release
__rgo_7374642f6d617468__acosh_deep_release:
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
    jg __rgo_7374642f6d617468__acosh_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__acosh_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__acosh_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__acosh_deepcopy
__rgo_7374642f6d617468__acosh_deepcopy:
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
    jg __rgo_7374642f6d617468__acosh_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__acosh_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__atanh
__rgo_7374642f6d617468__atanh:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_atanh
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__atanh_unwrapper
__rgo_7374642f6d617468__atanh_unwrapper:
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
    jmp __rgo_7374642f6d617468__atanh
global __rgo_7374642f6d617468__atanh_deep_release
__rgo_7374642f6d617468__atanh_deep_release:
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
    jg __rgo_7374642f6d617468__atanh_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__atanh_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__atanh_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__atanh_deepcopy
__rgo_7374642f6d617468__atanh_deepcopy:
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
    jg __rgo_7374642f6d617468__atanh_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__atanh_deepcopy_skip_1:
    leave
    ret

global hyperbolic_case
hyperbolic_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 176 ; reserve stack space for locals
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_21 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__cosh_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__cosh_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__cosh_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__cosh closure env_end to rax
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_22 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_24 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__tanh_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__tanh_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__tanh_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__tanh closure env_end to rax
    mov [rbp-48], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_25 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_27 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__asinh_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__asinh_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__asinh_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__asinh closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_28 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_30 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__acosh_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__acosh_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__acosh_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__acosh closure env_end to rax
    mov [rbp-96], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_31 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_33 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__atanh_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__atanh_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__atanh_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__atanh closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, [rbp-120] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_34 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    lea rax, [rel __comptime_35] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_36 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_37 closure env_end to rax
    mov [rbp-144], rax ; store value
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
    mov rax, [rbp-104] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-144] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_38 closure env_end to rax
    mov [rbp-152], rax ; store value
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
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_39 closure env_end to rax
    mov [rbp-160], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-160] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_40 closure env_end to rax
    mov [rbp-168], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-168] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_41 closure env_end to rax
    mov [rbp-176], rax ; store value
    mov rax, 0x0 ; load literal float bits
    movq xmm0, rax ; load float literal
    sub rsp, 8 ; align stack for native call
    call freestanding_math_sinh
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-176] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global hyperbolic_case_unwrapper
hyperbolic_case_unwrapper:
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
    jmp hyperbolic_case
global hyperbolic_case_deep_release
hyperbolic_case_deep_release:
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
    jg hyperbolic_case_release_skip_0
    mov rax, [r12-8] ; load hyperbolic_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
hyperbolic_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global hyperbolic_case_deepcopy
hyperbolic_case_deepcopy:
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
    jg hyperbolic_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
hyperbolic_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__acos
__rgo_7374642f6d617468__acos:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_acos
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__acos_unwrapper
__rgo_7374642f6d617468__acos_unwrapper:
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
    jmp __rgo_7374642f6d617468__acos
global __rgo_7374642f6d617468__acos_deep_release
__rgo_7374642f6d617468__acos_deep_release:
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
    jg __rgo_7374642f6d617468__acos_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__acos_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__acos_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__acos_deepcopy
__rgo_7374642f6d617468__acos_deepcopy:
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
    jg __rgo_7374642f6d617468__acos_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__acos_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__atan
__rgo_7374642f6d617468__atan:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_atan
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__atan_unwrapper
__rgo_7374642f6d617468__atan_unwrapper:
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
    jmp __rgo_7374642f6d617468__atan
global __rgo_7374642f6d617468__atan_deep_release
__rgo_7374642f6d617468__atan_deep_release:
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
    jg __rgo_7374642f6d617468__atan_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__atan_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__atan_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__atan_deepcopy
__rgo_7374642f6d617468__atan_deepcopy:
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
    jg __rgo_7374642f6d617468__atan_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__atan_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__atan2
__rgo_7374642f6d617468__atan2:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store y arg in frame
    mov [rbp-16], rsi ; store x arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_atan2
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__atan2_unwrapper
__rgo_7374642f6d617468__atan2_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load y env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load x env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__atan2
global __rgo_7374642f6d617468__atan2_deep_release
__rgo_7374642f6d617468__atan2_deep_release:
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
    jg __rgo_7374642f6d617468__atan2_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__atan2_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__atan2_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__atan2_deepcopy
__rgo_7374642f6d617468__atan2_deepcopy:
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
    jg __rgo_7374642f6d617468__atan2_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__atan2_deepcopy_skip_2:
    leave
    ret

global inverse_case
inverse_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 128 ; reserve stack space for locals
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_44 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__acos_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__acos_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__acos_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__acos closure env_end to rax
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_45 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_47 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__atan_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__atan_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__atan_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__atan closure env_end to rax
    mov [rbp-48], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_48 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_50 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_52 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    lea rax, [__rgo_7374642f6d617468__atan2_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__atan2_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__atan2_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__atan2 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-72] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_53 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [rel __comptime_54] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_55 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov rax, [rbp-88] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-96] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_56 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_57 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_58 closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rax, 0x0 ; load literal float bits
    movq xmm0, rax ; load float literal
    sub rsp, 8 ; align stack for native call
    call freestanding_math_asin
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-120] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global inverse_case_unwrapper
inverse_case_unwrapper:
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
    jmp inverse_case
global inverse_case_deep_release
inverse_case_deep_release:
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
    jg inverse_case_release_skip_0
    mov rax, [r12-8] ; load inverse_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
inverse_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global inverse_case_deepcopy
inverse_case_deepcopy:
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
    jg inverse_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
inverse_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__cos
__rgo_7374642f6d617468__cos:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store radians arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_cos
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__cos_unwrapper
__rgo_7374642f6d617468__cos_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load radians env field
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
    jmp __rgo_7374642f6d617468__cos
global __rgo_7374642f6d617468__cos_deep_release
__rgo_7374642f6d617468__cos_deep_release:
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
    jg __rgo_7374642f6d617468__cos_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__cos_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__cos_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__cos_deepcopy
__rgo_7374642f6d617468__cos_deepcopy:
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
    jg __rgo_7374642f6d617468__cos_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__cos_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__tan
__rgo_7374642f6d617468__tan:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store radians arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_tan
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__tan_unwrapper
__rgo_7374642f6d617468__tan_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load radians env field
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
    jmp __rgo_7374642f6d617468__tan
global __rgo_7374642f6d617468__tan_deep_release
__rgo_7374642f6d617468__tan_deep_release:
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
    jg __rgo_7374642f6d617468__tan_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__tan_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__tan_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__tan_deepcopy
__rgo_7374642f6d617468__tan_deepcopy:
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
    jg __rgo_7374642f6d617468__tan_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__tan_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__to_degrees
__rgo_7374642f6d617468__to_degrees:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store radians arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    mov rax, 0x404ca5dc1a63c1f8 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__to_degrees_unwrapper
__rgo_7374642f6d617468__to_degrees_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load radians env field
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
    jmp __rgo_7374642f6d617468__to_degrees
global __rgo_7374642f6d617468__to_degrees_deep_release
__rgo_7374642f6d617468__to_degrees_deep_release:
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
    jg __rgo_7374642f6d617468__to_degrees_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__to_degrees_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__to_degrees_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__to_degrees_deepcopy
__rgo_7374642f6d617468__to_degrees_deepcopy:
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
    jg __rgo_7374642f6d617468__to_degrees_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__to_degrees_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__to_radians
__rgo_7374642f6d617468__to_radians:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store degrees arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    mov rax, 0x3f91df46a2529d39 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__to_radians_unwrapper
__rgo_7374642f6d617468__to_radians_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load degrees env field
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
    jmp __rgo_7374642f6d617468__to_radians
global __rgo_7374642f6d617468__to_radians_deep_release
__rgo_7374642f6d617468__to_radians_deep_release:
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
    jg __rgo_7374642f6d617468__to_radians_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__to_radians_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__to_radians_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__to_radians_deepcopy
__rgo_7374642f6d617468__to_radians_deepcopy:
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
    jg __rgo_7374642f6d617468__to_radians_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__to_radians_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__sin
__rgo_7374642f6d617468__sin:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store radians arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_sin
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__sin_unwrapper
__rgo_7374642f6d617468__sin_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-16] ; load radians env field
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
    jmp __rgo_7374642f6d617468__sin
global __rgo_7374642f6d617468__sin_deep_release
__rgo_7374642f6d617468__sin_deep_release:
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
    jg __rgo_7374642f6d617468__sin_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__sin_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__sin_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__sin_deepcopy
__rgo_7374642f6d617468__sin_deepcopy:
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
    jg __rgo_7374642f6d617468__sin_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__sin_deepcopy_skip_1:
    leave
    ret

global trigonometry_case
trigonometry_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 192 ; reserve stack space for locals
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_225 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__cos_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__cos_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__cos_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__cos closure env_end to rax
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_226 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, 0x0 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_228 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__tan_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__tan_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__tan_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__tan closure env_end to rax
    mov [rbp-48], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_229 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, 0x400921fb54442d18 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_231 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__to_degrees_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__to_degrees_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__to_degrees_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__to_degrees closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_232 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_234 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov rax, [rbp-88] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x4020000000000000 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_236 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_238 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__to_radians_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__to_radians_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__to_radians_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__to_radians closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov rax, [rbp-112] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-104] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_239 closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, 0x400921fb54442d18 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_241 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    mov rax, [rbp-120] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-128] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_242 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    lea rax, [rel __comptime_243] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_244 closure env_end to rax
    mov [rbp-144], rax ; store value
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
    mov rax, [rbp-136] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-144] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_245 closure env_end to rax
    mov [rbp-152], rax ; store value
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
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_246 closure env_end to rax
    mov [rbp-160], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-160] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_247 closure env_end to rax
    mov [rbp-168], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-168] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_248 closure env_end to rax
    mov [rbp-176], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__sin_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__sin_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__sin_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__sin closure env_end to rax
    mov [rbp-184], rax ; store value
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
    mov rax, [rbp-184] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-176] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_249 closure env_end to rax
    mov [rbp-192], rax ; store value
    mov rax, 0x400921fb54442d18 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4000000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    divsd xmm0, xmm1 ; divide by divisor float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-192] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global trigonometry_case_unwrapper
trigonometry_case_unwrapper:
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
    jmp trigonometry_case
global trigonometry_case_deep_release
trigonometry_case_deep_release:
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
    jg trigonometry_case_release_skip_0
    mov rax, [r12-8] ; load trigonometry_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
trigonometry_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global trigonometry_case_deepcopy
trigonometry_case_deepcopy:
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
    jg trigonometry_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
trigonometry_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__log10
__rgo_7374642f6d617468__log10:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_log10
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__log10_unwrapper
__rgo_7374642f6d617468__log10_unwrapper:
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
    jmp __rgo_7374642f6d617468__log10
global __rgo_7374642f6d617468__log10_deep_release
__rgo_7374642f6d617468__log10_deep_release:
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
    jg __rgo_7374642f6d617468__log10_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__log10_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__log10_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__log10_deepcopy
__rgo_7374642f6d617468__log10_deepcopy:
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
    jg __rgo_7374642f6d617468__log10_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__log10_deepcopy_skip_1:
    leave
    ret

global _261___rgo_7374642f6d617468__log
_261___rgo_7374642f6d617468__log:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value_logarithm arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store base_logarithm arg in frame
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
global _261___rgo_7374642f6d617468__log_unwrapper
_261___rgo_7374642f6d617468__log_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value_logarithm env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load base_logarithm env field
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
    jmp _261___rgo_7374642f6d617468__log
global _261___rgo_7374642f6d617468__log_deep_release
_261___rgo_7374642f6d617468__log_deep_release:
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
    jg _261___rgo_7374642f6d617468__log_release_skip_1
    mov rax, [r12-16] ; load _261___rgo_7374642f6d617468__log_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_261___rgo_7374642f6d617468__log_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _261___rgo_7374642f6d617468__log_deepcopy
_261___rgo_7374642f6d617468__log_deepcopy:
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
    jg _261___rgo_7374642f6d617468__log_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_261___rgo_7374642f6d617468__log_deepcopy_skip_1:
    leave
    ret

global _259___rgo_7374642f6d617468__log
_259___rgo_7374642f6d617468__log:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store base arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store value_logarithm arg in frame
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
    lea rax, [_261___rgo_7374642f6d617468__log_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_261___rgo_7374642f6d617468__log_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_261___rgo_7374642f6d617468__log_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _262___rgo_7374642f6d617468__log closure env_end to rax
    mov [rbp-32], rax ; store value
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_log
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global _259___rgo_7374642f6d617468__log_unwrapper
_259___rgo_7374642f6d617468__log_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load base env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load ok env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load value_logarithm env field
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
    jmp _259___rgo_7374642f6d617468__log
global _259___rgo_7374642f6d617468__log_deep_release
_259___rgo_7374642f6d617468__log_deep_release:
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
    jg _259___rgo_7374642f6d617468__log_release_skip_1
    mov rax, [r12-16] ; load _259___rgo_7374642f6d617468__log_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_259___rgo_7374642f6d617468__log_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _259___rgo_7374642f6d617468__log_deepcopy
_259___rgo_7374642f6d617468__log_deepcopy:
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
    jg _259___rgo_7374642f6d617468__log_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_259___rgo_7374642f6d617468__log_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__log
__rgo_7374642f6d617468__log:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store base arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
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
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_259___rgo_7374642f6d617468__log_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_259___rgo_7374642f6d617468__log_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_259___rgo_7374642f6d617468__log_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _263___rgo_7374642f6d617468__log closure env_end to rax
    mov [rbp-32], rax ; store value
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_log
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-32] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__log_unwrapper
__rgo_7374642f6d617468__log_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load value env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load base env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__log
global __rgo_7374642f6d617468__log_deep_release
__rgo_7374642f6d617468__log_deep_release:
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
    jg __rgo_7374642f6d617468__log_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__log_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__log_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__log_deepcopy
__rgo_7374642f6d617468__log_deepcopy:
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
    jg __rgo_7374642f6d617468__log_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__log_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__log2
__rgo_7374642f6d617468__log2:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_log2
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__log2_unwrapper
__rgo_7374642f6d617468__log2_unwrapper:
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
    jmp __rgo_7374642f6d617468__log2
global __rgo_7374642f6d617468__log2_deep_release
__rgo_7374642f6d617468__log2_deep_release:
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
    jg __rgo_7374642f6d617468__log2_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__log2_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__log2_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__log2_deepcopy
__rgo_7374642f6d617468__log2_deepcopy:
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
    jg __rgo_7374642f6d617468__log2_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__log2_deepcopy_skip_1:
    leave
    ret

global logs_case
logs_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 208 ; reserve stack space for locals
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_61 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_63 closure env_end to rax
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
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_65 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_67 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__log10_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__log10_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__log10_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__log10 closure env_end to rax
    mov [rbp-48], rax ; store value
    mov rbx, [rbp-48] ; original closure __rgo_7374642f6d617468__log10 to ____comptime_68_arg_clone_0 env_end pointer for clone
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
    mov [rbp-56], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-40] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_68 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, 0x4020000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_70 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x3ff0000000000000 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_72 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, 0x4008000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_74 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [__rgo_7374642f6d617468__log_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__log_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__log_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__log closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov rax, [rbp-96] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-80] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_75 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    mov rax, 0x4020000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_77 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__log2_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__log2_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__log2_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__log2 closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, [rbp-120] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_78 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_80 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    mov rax, [rbp-136] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_82 closure env_end to rax
    mov [rbp-144], rax ; store value
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
    mov rax, [rbp-144] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_84 closure env_end to rax
    mov [rbp-152], rax ; store value
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
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-152] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_85 closure env_end to rax
    mov [rbp-160], rax ; store value
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
    lea rax, [rel __comptime_86] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_87 closure env_end to rax
    mov [rbp-168], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_88 closure env_end to rax
    mov [rbp-176], rax ; store value
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
    mov rax, [rbp-128] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-176] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_89 closure env_end to rax
    mov [rbp-184], rax ; store value
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
    mov rax, [rbp-104] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-184] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_90 closure env_end to rax
    mov [rbp-192], rax ; store value
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
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-192] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_91 closure env_end to rax
    mov [rbp-200], rax ; store value
    mov rax, 0x4005bf0a8b145769 ; load literal float bits
    movq xmm0, rax ; load float literal
    sub rsp, 8 ; align stack for native call
    call freestanding_math_log
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-200] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global logs_case_unwrapper
logs_case_unwrapper:
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
    jmp logs_case
global logs_case_deep_release
logs_case_deep_release:
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
    jg logs_case_release_skip_0
    mov rax, [r12-8] ; load logs_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
logs_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global logs_case_deepcopy
logs_case_deepcopy:
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
    jg logs_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
logs_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__cbrt
__rgo_7374642f6d617468__cbrt:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_cbrt
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__cbrt_unwrapper
__rgo_7374642f6d617468__cbrt_unwrapper:
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
    jmp __rgo_7374642f6d617468__cbrt
global __rgo_7374642f6d617468__cbrt_deep_release
__rgo_7374642f6d617468__cbrt_deep_release:
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
    jg __rgo_7374642f6d617468__cbrt_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__cbrt_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__cbrt_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__cbrt_deepcopy
__rgo_7374642f6d617468__cbrt_deepcopy:
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
    jg __rgo_7374642f6d617468__cbrt_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__cbrt_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d617468__hypot
__rgo_7374642f6d617468__hypot:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store x arg in frame
    mov [rbp-16], rsi ; store y arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_hypot
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__hypot_unwrapper
__rgo_7374642f6d617468__hypot_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load x env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load y env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__hypot
global __rgo_7374642f6d617468__hypot_deep_release
__rgo_7374642f6d617468__hypot_deep_release:
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
    jg __rgo_7374642f6d617468__hypot_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__hypot_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__hypot_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__hypot_deepcopy
__rgo_7374642f6d617468__hypot_deepcopy:
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
    jg __rgo_7374642f6d617468__hypot_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__hypot_deepcopy_skip_2:
    leave
    ret

global __rgo_7374642f6d617468__sqrt
__rgo_7374642f6d617468__sqrt:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 16 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_sqrt
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-16] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__sqrt_unwrapper
__rgo_7374642f6d617468__sqrt_unwrapper:
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
    jmp __rgo_7374642f6d617468__sqrt
global __rgo_7374642f6d617468__sqrt_deep_release
__rgo_7374642f6d617468__sqrt_deep_release:
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
    jg __rgo_7374642f6d617468__sqrt_release_skip_1
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__sqrt_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__sqrt_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__sqrt_deepcopy
__rgo_7374642f6d617468__sqrt_deepcopy:
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
    jg __rgo_7374642f6d617468__sqrt_deepcopy_skip_1
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__sqrt_deepcopy_skip_1:
    leave
    ret

global roots_case
roots_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 128 ; reserve stack space for locals
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
    mov rax, r12 ; copy __comptime_151 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x401c000000000000 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_153 closure env_end to rax
    mov [rbp-24], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__cbrt_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__cbrt_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__cbrt_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__cbrt closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_154 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov rax, 0x4008000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_156 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    mov rax, 0x4010000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_158 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    lea rax, [__rgo_7374642f6d617468__hypot_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__hypot_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__hypot_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 3 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__hypot closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-48] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov rax, [rbp-56] ; load operand
    mov [rbx+16], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 32 ; move pointer past env payload
    mov rax, 32 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 80 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__apply_binary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_159 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    lea rax, [rel __comptime_160] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_161 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_162 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov rax, [rbp-40] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_163 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d617468__sqrt_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d617468__sqrt_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d617468__sqrt_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 2 ; store num_remaining
    mov rax, r12 ; copy __rgo_7374642f6d617468__sqrt closure env_end to rax
    mov [rbp-104], rax ; store value
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
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1208___rgo_7374642f6d6174682f63616c63__apply_unary_operation_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_164 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_165 closure env_end to rax
    mov [rbp-120], rax ; store value
    mov rax, 0x4020000000000000 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4024000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-120] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global roots_case_unwrapper
roots_case_unwrapper:
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
    jmp roots_case
global roots_case_deep_release
roots_case_deep_release:
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
    jg roots_case_release_skip_0
    mov rax, [r12-8] ; load roots_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
roots_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global roots_case_deepcopy
roots_case_deepcopy:
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
    jg roots_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
roots_case_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d617468__pow
__rgo_7374642f6d617468__pow:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store base arg in frame
    mov [rbp-16], rsi ; store exponent arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
    movsd xmm0, [rbp-8] ; load float operand
    movsd xmm1, [rbp-16] ; load float operand
    sub rsp, 8 ; align stack for native call
    call freestanding_math_pow
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-24] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global __rgo_7374642f6d617468__pow_unwrapper
__rgo_7374642f6d617468__pow_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load base env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load exponent env field
    mov [rbp-24], rax ; store value
    mov rax, [r12-8] ; load ok env field
    mov [rbp-32], rax ; store value
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    mov rax, [rbp-32] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-16] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__pow
global __rgo_7374642f6d617468__pow_deep_release
__rgo_7374642f6d617468__pow_deep_release:
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
    jg __rgo_7374642f6d617468__pow_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d617468__pow_release_field_2 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d617468__pow_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d617468__pow_deepcopy
__rgo_7374642f6d617468__pow_deepcopy:
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
    jg __rgo_7374642f6d617468__pow_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d617468__pow_deepcopy_skip_2:
    leave
    ret

global _521___rgo_7374642f6d6174682f63616c63__power
_521___rgo_7374642f6d6174682f63616c63__power:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a_value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store b_value arg in frame
    mov rax, [rbp-16] ; load operand
    push rax ; stack arg
    movsd xmm0, [rbp-24] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    movsd xmm0, [rbp-8] ; load float operand
    movq rax, xmm0
    push rax ; stack arg
    pop rdi ; restore arg into register
    pop rsi ; restore arg into register
    pop rdx ; restore arg into register
    leave ; unwind before named jump
    jmp __rgo_7374642f6d617468__pow
global _521___rgo_7374642f6d6174682f63616c63__power_unwrapper
_521___rgo_7374642f6d6174682f63616c63__power_unwrapper:
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
    jmp _521___rgo_7374642f6d6174682f63616c63__power
global _521___rgo_7374642f6d6174682f63616c63__power_deep_release
_521___rgo_7374642f6d6174682f63616c63__power_deep_release:
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
    jg _521___rgo_7374642f6d6174682f63616c63__power_release_skip_1
    mov rax, [r12-16] ; load _521___rgo_7374642f6d6174682f63616c63__power_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_521___rgo_7374642f6d6174682f63616c63__power_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _521___rgo_7374642f6d6174682f63616c63__power_deepcopy
_521___rgo_7374642f6d6174682f63616c63__power_deepcopy:
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
    jg _521___rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_521___rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_1:
    leave
    ret

global _519___rgo_7374642f6d6174682f63616c63__power
_519___rgo_7374642f6d6174682f63616c63__power:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store a_value arg in frame
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
    lea rax, [_521___rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_521___rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_521___rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _522___rgo_7374642f6d6174682f63616c63__power closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _519___rgo_7374642f6d6174682f63616c63__power_unwrapper
_519___rgo_7374642f6d6174682f63616c63__power_unwrapper:
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
    jmp _519___rgo_7374642f6d6174682f63616c63__power
global _519___rgo_7374642f6d6174682f63616c63__power_deep_release
_519___rgo_7374642f6d6174682f63616c63__power_deep_release:
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
    jg _519___rgo_7374642f6d6174682f63616c63__power_release_skip_0
    mov rax, [r12-24] ; load _519___rgo_7374642f6d6174682f63616c63__power_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_519___rgo_7374642f6d6174682f63616c63__power_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _519___rgo_7374642f6d6174682f63616c63__power_release_skip_1
    mov rax, [r12-16] ; load _519___rgo_7374642f6d6174682f63616c63__power_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_519___rgo_7374642f6d6174682f63616c63__power_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _519___rgo_7374642f6d6174682f63616c63__power_deepcopy
_519___rgo_7374642f6d6174682f63616c63__power_deepcopy:
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
    jg _519___rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_519___rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _519___rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_519___rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__power
__rgo_7374642f6d6174682f63616c63__power:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a arg in frame
    mov [rbp-16], rsi ; store b arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_519___rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_519___rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_519___rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _523___rgo_7374642f6d6174682f63616c63__power closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load a closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__power_unwrapper
__rgo_7374642f6d6174682f63616c63__power_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load b env field
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
    jmp __rgo_7374642f6d6174682f63616c63__power
global __rgo_7374642f6d6174682f63616c63__power_deep_release
__rgo_7374642f6d6174682f63616c63__power_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__power_release_skip_0
    mov rax, [r12-24] ; load __rgo_7374642f6d6174682f63616c63__power_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__power_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__power_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f6d6174682f63616c63__power_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__power_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__power_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__power_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__power_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__power_deepcopy
__rgo_7374642f6d6174682f63616c63__power_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f6d6174682f63616c63__power_deepcopy_skip_2:
    leave
    ret

global _493___rgo_7374642f6d6174682f63616c63__negate
_493___rgo_7374642f6d6174682f63616c63__negate:
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
global _493___rgo_7374642f6d6174682f63616c63__negate_unwrapper
_493___rgo_7374642f6d6174682f63616c63__negate_unwrapper:
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
    jmp _493___rgo_7374642f6d6174682f63616c63__negate
global _493___rgo_7374642f6d6174682f63616c63__negate_deep_release
_493___rgo_7374642f6d6174682f63616c63__negate_deep_release:
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
    jg _493___rgo_7374642f6d6174682f63616c63__negate_release_skip_0
    mov rax, [r12-16] ; load _493___rgo_7374642f6d6174682f63616c63__negate_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_493___rgo_7374642f6d6174682f63616c63__negate_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _493___rgo_7374642f6d6174682f63616c63__negate_deepcopy
_493___rgo_7374642f6d6174682f63616c63__negate_deepcopy:
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
    jg _493___rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_0
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_493___rgo_7374642f6d6174682f63616c63__negate_deepcopy_skip_0:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__negate
__rgo_7374642f6d6174682f63616c63__negate:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store value arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
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
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_493___rgo_7374642f6d6174682f63616c63__negate_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_493___rgo_7374642f6d6174682f63616c63__negate_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_493___rgo_7374642f6d6174682f63616c63__negate_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _495___rgo_7374642f6d6174682f63616c63__negate closure env_end to rax
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

global _507___rgo_7374642f6d6174682f63616c63__multiply
_507___rgo_7374642f6d6174682f63616c63__multiply:
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
global _507___rgo_7374642f6d6174682f63616c63__multiply_unwrapper
_507___rgo_7374642f6d6174682f63616c63__multiply_unwrapper:
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
    jmp _507___rgo_7374642f6d6174682f63616c63__multiply
global _507___rgo_7374642f6d6174682f63616c63__multiply_deep_release
_507___rgo_7374642f6d6174682f63616c63__multiply_deep_release:
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
    jg _507___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1
    mov rax, [r12-16] ; load _507___rgo_7374642f6d6174682f63616c63__multiply_release_field_1 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_507___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _507___rgo_7374642f6d6174682f63616c63__multiply_deepcopy
_507___rgo_7374642f6d6174682f63616c63__multiply_deepcopy:
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
    jg _507___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_507___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1:
    leave
    ret

global _505___rgo_7374642f6d6174682f63616c63__multiply
_505___rgo_7374642f6d6174682f63616c63__multiply:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store b arg in frame
    mov [rbp-16], rsi ; store ok arg in frame
    mov [rbp-24], rdx ; store a_value arg in frame
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
    lea rax, [_507___rgo_7374642f6d6174682f63616c63__multiply_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_507___rgo_7374642f6d6174682f63616c63__multiply_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_507___rgo_7374642f6d6174682f63616c63__multiply_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _508___rgo_7374642f6d6174682f63616c63__multiply closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load b closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global _505___rgo_7374642f6d6174682f63616c63__multiply_unwrapper
_505___rgo_7374642f6d6174682f63616c63__multiply_unwrapper:
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
    jmp _505___rgo_7374642f6d6174682f63616c63__multiply
global _505___rgo_7374642f6d6174682f63616c63__multiply_deep_release
_505___rgo_7374642f6d6174682f63616c63__multiply_deep_release:
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
    jg _505___rgo_7374642f6d6174682f63616c63__multiply_release_skip_0
    mov rax, [r12-24] ; load _505___rgo_7374642f6d6174682f63616c63__multiply_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_505___rgo_7374642f6d6174682f63616c63__multiply_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _505___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1
    mov rax, [r12-16] ; load _505___rgo_7374642f6d6174682f63616c63__multiply_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
_505___rgo_7374642f6d6174682f63616c63__multiply_release_skip_1:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global _505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy
_505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy:
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
    jg _505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
_505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg _505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
_505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1:
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__multiply
__rgo_7374642f6d6174682f63616c63__multiply:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store a arg in frame
    mov [rbp-16], rsi ; store b arg in frame
    mov [rbp-24], rdx ; store ok arg in frame
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_505___rgo_7374642f6d6174682f63616c63__multiply_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_505___rgo_7374642f6d6174682f63616c63__multiply_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy _509___rgo_7374642f6d6174682f63616c63__multiply closure env_end to rax
    mov [rbp-32], rax ; store value
    mov rbx, [rbp-8] ; load a closure env_end pointer
    mov rax, [rbp-32] ; load operand
    mov [rbx-8], rax ; store env field
    mov rdi, rbx ; pass env_end pointer to closure
    mov rax, [rdi+0] ; load closure unwrapper entry point
    leave ; unwind before jumping
    jmp rax ; tail call into closure
global __rgo_7374642f6d6174682f63616c63__multiply_unwrapper
__rgo_7374642f6d6174682f63616c63__multiply_unwrapper:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 32 ; reserve stack space for locals
    mov [rbp-8], rdi ; store env_end arg in frame
    mov r12, [rbp-8] ; load operand
    mov rax, [r12-24] ; load a env field
    mov [rbp-16], rax ; store value
    mov rax, [r12-16] ; load b env field
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
    jmp __rgo_7374642f6d6174682f63616c63__multiply
global __rgo_7374642f6d6174682f63616c63__multiply_deep_release
__rgo_7374642f6d6174682f63616c63__multiply_deep_release:
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
    jg __rgo_7374642f6d6174682f63616c63__multiply_release_skip_0
    mov rax, [r12-24] ; load __rgo_7374642f6d6174682f63616c63__multiply_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__multiply_release_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__multiply_release_skip_1
    mov rax, [r12-16] ; load __rgo_7374642f6d6174682f63616c63__multiply_release_field_1 env field
    mov [rbp-32], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-32] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__multiply_release_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__multiply_release_skip_2
    mov rax, [r12-8] ; load __rgo_7374642f6d6174682f63616c63__multiply_release_field_2 env field
    mov [rbp-40], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-40] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
__rgo_7374642f6d6174682f63616c63__multiply_release_skip_2:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global __rgo_7374642f6d6174682f63616c63__multiply_deepcopy
__rgo_7374642f6d6174682f63616c63__multiply_deepcopy:
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
    jg __rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_0
    mov rcx, [r12-24] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-24], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
__rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_0:
    mov rax, [rbp-16] ; load operand
    mov rbx, 1 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1
    mov rcx, [r12-16] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-16], rax ; store duplicated pointer
    mov [rbp-32], rax ; store value
__rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_1:
    mov rax, [rbp-16] ; load operand
    mov rbx, 0 ; operand literal
    cmp rax, rbx
    jg __rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_2
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-40], rax ; store value
__rgo_7374642f6d6174682f63616c63__multiply_deepcopy_skip_2:
    leave
    ret

global notation_case
notation_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 144 ; reserve stack space for locals
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
    mov rax, r12 ; copy __comptime_97 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, 0x0 ; load literal float bits
    mov [rbx+8], rax ; capture arg into env
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_99 closure env_end to rax
    mov [rbp-24], rax ; store value
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
    mov rax, r12 ; copy __comptime_101 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, r12 ; copy __comptime_103 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_104 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    mov rax, 0x4014000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_106 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, r12 ; copy __comptime_108 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, 0x3ff0000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_110 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
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
    mov rax, r12 ; copy __comptime_111 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-80] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_112 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-88] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__multiply_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__multiply_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__multiply_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_113 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    lea rax, [rel __comptime_114] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_115 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_116 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_505___rgo_7374642f6d6174682f63616c63__multiply_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_505___rgo_7374642f6d6174682f63616c63__multiply_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_505___rgo_7374642f6d6174682f63616c63__multiply_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_117 closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-120] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_512___rgo_7374642f6d6174682f63616c63__divide_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_118 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    mov rax, 0x4014000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-128] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_526___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_526___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_526___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_119 closure env_end to rax
    mov [rbp-136], rax ; store value
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
    mov rax, 0x4000000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-136] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_529___rgo_7374642f6d6174682f63616c63__append_digit_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_120 closure env_end to rax
    mov [rbp-144], rax ; store value
    mov rax, 0x3ff0000000000000 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4024000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    mulsd xmm0, xmm1 ; multiply by multiplier float
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-144] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global notation_case_unwrapper
notation_case_unwrapper:
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
    jmp notation_case
global notation_case_deep_release
notation_case_deep_release:
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
    jg notation_case_release_skip_0
    mov rax, [r12-8] ; load notation_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
notation_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global notation_case_deepcopy
notation_case_deepcopy:
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
    jg notation_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
notation_case_deepcopy_skip_0:
    leave
    ret

global power_case
power_case:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 144 ; reserve stack space for locals
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
    mov rax, r12 ; copy __comptime_125 closure env_end to rax
    mov [rbp-16], rax ; store value
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
    mov rax, r12 ; copy __comptime_127 closure env_end to rax
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
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-24] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_128 closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, [rbp-32] ; load operand
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
    mov rax, r12 ; copy __comptime_129 closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov rax, r12 ; copy __comptime_131 closure env_end to rax
    mov [rbp-48], rax ; store value
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
    mov rax, r12 ; copy __comptime_133 closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, [rbp-56] ; load operand
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
    mov rax, r12 ; copy __comptime_134 closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-64] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_135 closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, r12 ; copy __comptime_137 closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, 0x4008000000000000 ; load literal float bits
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
    mov rax, r12 ; copy __comptime_139 closure env_end to rax
    mov [rbp-88], rax ; store value
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
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [__rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_140 closure env_end to rax
    mov [rbp-96], rax ; store value
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
    lea rax, [rel __comptime_141] ; point to string literal
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [show_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [show_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [show_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_142 closure env_end to rax
    mov [rbp-104], rax ; store value
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
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_143 closure env_end to rax
    mov [rbp-112], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-112] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_144 closure env_end to rax
    mov [rbp-120], rax ; store value
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
    mov rax, [rbp-40] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov rax, [rbp-120] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_486___rgo_7374642f6d6174682f63616c63__add_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_145 closure env_end to rax
    mov [rbp-128], rax ; store value
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
    mov rax, 0x4000000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-128] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 24 ; move pointer past env payload
    mov rax, 24 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 72 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [_521___rgo_7374642f6d6174682f63616c63__power_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_521___rgo_7374642f6d6174682f63616c63__power_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_521___rgo_7374642f6d6174682f63616c63__power_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 1 ; store num_remaining
    mov rax, r12 ; copy __comptime_146 closure env_end to rax
    mov [rbp-136], rax ; store value
    mov rax, 0x4008000000000000 ; load literal float bits
    movq xmm0, rax ; load float literal
    mov rax, 0x4000000000000000 ; load literal float bits
    movq xmm1, rax ; load float literal
    sub rsp, 8 ; align stack for native call
    call freestanding_math_pow
    add rsp, 8 ; restore stack after native call
    movq rax, xmm0 ; move float result to rax
    mov r12, [rbp-136] ; load continuation env_end pointer
    mov [r12-8], rax ; store env field
    mov rax, [r12+0] ; load continuation entry point
    mov rdi, r12 ; pass env_end pointer to continuation
    leave ; unwind before jumping
    jmp rax
global power_case_unwrapper
power_case_unwrapper:
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
    jmp power_case
global power_case_deep_release
power_case_deep_release:
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
    jg power_case_release_skip_0
    mov rax, [r12-8] ; load power_case_release_field_0 env field
    mov [rbp-24], rax ; store value
    push r12 ; preserve current environment
    mov rdi, [rbp-24] ; load operand
    mov rax, [rdi+8] ; load closure release helper
    call rax ; recursively release closure
    pop r12 ; restore current environment
power_case_release_skip_0:
    mov rdi, r12 ; use pinned __env_end env_end pointer
    call release_heap_ptr ; release __env_end closure environment
    leave
    ret

global power_case_deepcopy
power_case_deepcopy:
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
    jg power_case_deepcopy_skip_0
    mov rcx, [r12-8] ; load field pointer
    mov rdi, rcx ; copy pointer argument for deepcopy
    call deepcopy_heap_ptr ; duplicate owned pointer
    mov [r12-8], rax ; store duplicated pointer
    mov [rbp-24], rax ; store value
power_case_deepcopy_skip_0:
    leave
    ret

global main
main:
    push rbp ; save executor frame pointer
    mov rbp, rsp ; establish new frame base
    sub rsp, 96 ; reserve stack space for locals
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
    lea rax, [_1851_main_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [_1851_main_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [_1851_main_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1851_main closure env_end to rax
    mov [rbp-8], rax ; store value
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
    mov rax, 0x4008000000000000 ; load literal float bits
    mov [rbx+0], rax ; capture arg into env
    mov rax, [rbp-8] ; load operand
    mov [rbx+8], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 16 ; move pointer past env payload
    mov rax, 16 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 64 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [variable_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [variable_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [variable_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1854_variable_case closure env_end to rax
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
    mov rax, [rbp-16] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [constants_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [constants_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [constants_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1855_constants_case closure env_end to rax
    mov [rbp-24], rax ; store value
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
    mov rax, [rbp-24] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [rounding_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [rounding_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [rounding_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1856_rounding_case closure env_end to rax
    mov [rbp-32], rax ; store value
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
    mov rax, [rbp-32] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [utility_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [utility_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [utility_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1857_utility_case closure env_end to rax
    mov [rbp-40], rax ; store value
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
    mov rax, [rbp-40] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [exponential_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [exponential_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [exponential_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1858_exponential_case closure env_end to rax
    mov [rbp-48], rax ; store value
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
    mov rax, [rbp-48] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [hyperbolic_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [hyperbolic_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [hyperbolic_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1859_hyperbolic_case closure env_end to rax
    mov [rbp-56], rax ; store value
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
    mov rax, [rbp-56] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [inverse_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [inverse_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [inverse_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1860_inverse_case closure env_end to rax
    mov [rbp-64], rax ; store value
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
    mov rax, [rbp-64] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [trigonometry_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [trigonometry_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [trigonometry_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1861_trigonometry_case closure env_end to rax
    mov [rbp-72], rax ; store value
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
    mov rax, [rbp-72] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [logs_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [logs_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [logs_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1862_logs_case closure env_end to rax
    mov [rbp-80], rax ; store value
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
    mov rax, [rbp-80] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [roots_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [roots_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [roots_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1863_roots_case closure env_end to rax
    mov [rbp-88], rax ; store value
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
    mov rax, [rbp-88] ; load operand
    mov [rbx+0], rax ; move closure pointer into environment
    mov r12, rbx ; env_end pointer before metadata
    add r12, 8 ; move pointer past env payload
    mov rax, 8 ; store env size metadata
    mov qword [r12+24], rax ; env size metadata
    mov rax, 56 ; store heap size metadata
    mov qword [r12+32], rax ; heap size metadata
    lea rax, [notation_case_unwrapper] ; load unwrapper entry point
    mov qword [r12+0], rax ; store unwrapper entry in metadata
    lea rax, [notation_case_deep_release] ; load release helper entry point
    mov qword [r12+8], rax ; store release pointer in metadata
    lea rax, [notation_case_deepcopy] ; load deep copy helper entry point
    mov qword [r12+16], rax ; store deep copy pointer in metadata
    mov qword [r12+40], 0 ; store num_remaining
    mov rax, r12 ; copy _1864_notation_case closure env_end to rax
    mov [rbp-96], rax ; store value
    mov rax, [rbp-96] ; load operand
    push rax ; stack arg
    pop rdi ; restore arg into register
    leave ; unwind before named jump
    jmp power_case
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
section .rodata
__comptime_216:
    dq __comptime_216_data, 14, 0, 0 ; data, byte length, heap base, heap size
__comptime_216_data:
    db "invalid format", 0
__comptime_218:
    dq __comptime_218_data, 14, 0, 0 ; data, byte length, heap base, heap size
__comptime_218_data:
    db "invalid format", 0
__comptime_277:
    dq __comptime_277_data, 8, 0, 0 ; data, byte length, heap base, heap size
__comptime_277_data:
    db "variable", 0
__comptime_2:
    dq __comptime_2_data, 9, 0, 0 ; data, byte length, heap base, heap size
__comptime_2_data:
    db "constants", 0
__comptime_195:
    dq __comptime_195_data, 8, 0, 0 ; data, byte length, heap base, heap size
__comptime_195_data:
    db "rounding", 0
__comptime_270:
    dq __comptime_270_data, 9, 0, 0 ; data, byte length, heap base, heap size
__comptime_270_data:
    db "utilities", 0
__comptime_14:
    dq __comptime_14_data, 11, 0, 0 ; data, byte length, heap base, heap size
__comptime_14_data:
    db "exponential", 0
__comptime_35:
    dq __comptime_35_data, 10, 0, 0 ; data, byte length, heap base, heap size
__comptime_35_data:
    db "hyperbolic", 0
__comptime_54:
    dq __comptime_54_data, 7, 0, 0 ; data, byte length, heap base, heap size
__comptime_54_data:
    db "inverse", 0
__comptime_243:
    dq __comptime_243_data, 12, 0, 0 ; data, byte length, heap base, heap size
__comptime_243_data:
    db "trigonometry", 0
__comptime_86:
    dq __comptime_86_data, 4, 0, 0 ; data, byte length, heap base, heap size
__comptime_86_data:
    db "logs", 0
__comptime_160:
    dq __comptime_160_data, 5, 0, 0 ; data, byte length, heap base, heap size
__comptime_160_data:
    db "roots", 0
__comptime_114:
    dq __comptime_114_data, 8, 0, 0 ; data, byte length, heap base, heap size
__comptime_114_data:
    db "notation", 0
__comptime_141:
    dq __comptime_141_data, 6, 0, 0 ; data, byte length, heap base, heap size
__comptime_141_data:
    db "powers", 0
