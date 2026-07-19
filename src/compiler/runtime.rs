use std::io::Write;

use crate::compiler::air;
use crate::compiler::codegen::{
    DESCRIPTOR_HEAP_BASE_OFFSET, DESCRIPTOR_HEAP_SIZE_OFFSET, ENV_METADATA_DEEP_COPY_OFFSET,
    ENV_METADATA_ENV_SIZE_OFFSET, ENV_METADATA_HEAP_SIZE_OFFSET, ENV_METADATA_NUM_REMAINING_OFFSET,
    ENV_METADATA_RELEASE_OFFSET, ENV_METADATA_UNWRAPPER_OFFSET, MAP_ANONYMOUS, MAP_PRIVATE,
    PROT_READ, PROT_WRITE, STRING_DESCRIPTOR_SIZE, SYSCALL_MMAP, SYSCALL_MUNMAP,
};
use crate::compiler::error;

struct BytesBuildClosure<'a> {
    unwrapper: &'a str,
    release: &'a str,
    deepcopy: &'a str,
    env_size: usize,
    heap_size: usize,
    num_remaining: usize,
}

pub fn emit_builtin_function<W: Write>(
    air: &air::AirFunction,
    out: &mut W,
) -> Result<bool, error::Error> {
    if air.items.is_empty() {
        match air.sig.name.as_str() {
            "release_heap_ptr" => {
                emit_release_heap_ptr(out)?;
                return Ok(true);
            }
            "deepcopy_heap_ptr" => {
                emit_deepcopy_heap_ptr(out)?;
                return Ok(true);
            }
            "release_descriptor_ptr" => {
                emit_release_descriptor_ptr(out)?;
                return Ok(true);
            }
            "clone_descriptor_ptr" => {
                emit_clone_descriptor_ptr(out)?;
                return Ok(true);
            }
            "memcpy_helper" => {
                emit_memcpy_helper(out)?;
                return Ok(true);
            }
            _ => {}
        }
    }
    Ok(false)
}

pub fn emit_release_heap_ptr<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global release_heap_ptr")?;
    writeln!(out, "release_heap_ptr:")?;
    writeln!(out, "    push rbp ; save caller frame")?;
    writeln!(out, "    mov rbp, rsp ; establish frame")?;
    writeln!(out, "    push rbx ; preserve rbx")?;
    writeln!(out, "    mov rbx, rdi ; keep env_end pointer")?;
    writeln!(
        out,
        "    mov rcx, [rbx+{}] ; load env size metadata",
        ENV_METADATA_ENV_SIZE_OFFSET
    )?;
    writeln!(
        out,
        "    mov rdx, [rbx+{}] ; load heap size metadata",
        ENV_METADATA_HEAP_SIZE_OFFSET
    )?;
    writeln!(out, "    mov rdi, rbx")?;
    writeln!(out, "    sub rdi, rcx ; compute env base pointer")?;
    writeln!(out, "    mov rsi, rdx ; heap size for munmap")?;
    writeln!(out, "    mov rax, {} ; munmap syscall", SYSCALL_MUNMAP)?;
    writeln!(out, "    syscall")?;
    writeln!(out, "    pop rbx")?;
    writeln!(out, "    pop rbp")?;
    writeln!(out, "    ret")?;
    Ok(())
}

pub fn emit_deepcopy_heap_ptr<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global deepcopy_heap_ptr")?;
    writeln!(out, "deepcopy_heap_ptr:")?;
    writeln!(out, "    push rbp ; prologue: save executor frame pointer")?;
    writeln!(out, "    mov rbp, rsp ; prologue: establish new frame")?;
    writeln!(out, "    push rbx ; preserve callee-saved registers")?;
    writeln!(out, "    push r12")?;
    writeln!(out, "    push r13")?;
    writeln!(out, "    push r14")?;
    writeln!(out, "    push r15")?;
    writeln!(out, "    mov r12, rdi ; capture env_end pointer")?;
    writeln!(
        out,
        "    mov r14, [r12+{}] ; load env size metadata",
        ENV_METADATA_ENV_SIZE_OFFSET
    )?;
    writeln!(
        out,
        "    mov r15, [r12+{}] ; load heap size metadata",
        ENV_METADATA_HEAP_SIZE_OFFSET
    )?;
    writeln!(out, "    mov rbx, r12 ; keep env_end pointer")?;
    writeln!(out, "    sub rbx, r14 ; compute env base pointer")?;
    writeln!(out, "    mov rdi, 0 ; addr hint so kernel picks mmap base")?;
    writeln!(out, "    mov rsi, r15 ; length = heap size")?;
    writeln!(
        out,
        "    mov rdx, {} ; prot = read/write",
        PROT_READ | PROT_WRITE
    )?;
    writeln!(
        out,
        "    mov r10, {} ; flags = private & anonymous",
        MAP_PRIVATE | MAP_ANONYMOUS
    )?;
    writeln!(out, "    mov r8, -1 ; fd = -1")?;
    writeln!(out, "    xor r9, r9 ; offset = 0")?;
    writeln!(out, "    mov rax, {} ; mmap syscall", SYSCALL_MMAP)?;
    writeln!(out, "    syscall ; allocate new closure env")?;
    writeln!(out, "    mov r13, rax ; new env base pointer")?;
    writeln!(out, "    mov rdi, r13 ; memcpy dest")?;
    writeln!(out, "    mov rsi, rbx ; memcpy src")?;
    writeln!(out, "    mov rdx, r15 ; memcpy length")?;
    writeln!(out, "    call memcpy_helper ; copy env contents")?;
    writeln!(out, "    mov rax, r13 ; compute new env_end pointer")?;
    writeln!(out, "    add rax, r14")?;
    writeln!(out, "    mov r15, rax ; preserve new env_end pointer")?;
    writeln!(
        out,
        "    mov rax, [r15+{}] ; load deep copy helper entry",
        ENV_METADATA_DEEP_COPY_OFFSET
    )?;
    writeln!(out, "    mov rdi, r15 ; pass new env_end pointer")?;
    writeln!(out, "    call rax ; invoke helper")?;
    writeln!(out, "    mov rax, r15 ; return new env_end pointer")?;
    writeln!(out, "    pop r15")?;
    writeln!(out, "    pop r14")?;
    writeln!(out, "    pop r13")?;
    writeln!(out, "    pop r12")?;
    writeln!(out, "    pop rbx")?;
    writeln!(out, "    pop rbp")?;
    writeln!(out, "    ret")?;
    Ok(())
}

pub fn emit_release_descriptor_ptr<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global release_descriptor_ptr")?;
    writeln!(out, "release_descriptor_ptr:")?;
    writeln!(
        out,
        "    mov rax, [rdi+{DESCRIPTOR_HEAP_BASE_OFFSET}] ; load owned mapping base"
    )?;
    writeln!(out, "    test rax, rax ; static descriptors have no owner")?;
    writeln!(out, "    jz release_descriptor_ptr_done")?;
    writeln!(
        out,
        "    mov rsi, [rdi+{DESCRIPTOR_HEAP_SIZE_OFFSET}] ; mapping size"
    )?;
    writeln!(out, "    mov rdi, rax ; mapping base")?;
    writeln!(out, "    mov rax, {SYSCALL_MUNMAP} ; munmap syscall")?;
    writeln!(out, "    syscall")?;
    writeln!(out, "release_descriptor_ptr_done:")?;
    writeln!(out, "    ret")?;
    Ok(())
}

pub fn emit_clone_descriptor_ptr<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global clone_descriptor_ptr")?;
    writeln!(out, "clone_descriptor_ptr:")?;
    writeln!(out, "    push rbx ; preserve callee-saved registers")?;
    writeln!(out, "    push r12")?;
    writeln!(out, "    push r13")?;
    writeln!(out, "    mov r12, rdi ; source descriptor")?;
    writeln!(
        out,
        "    cmp qword [r12+{DESCRIPTOR_HEAP_BASE_OFFSET}], 0 ; static descriptor?"
    )?;
    writeln!(out, "    je clone_descriptor_ptr_static")?;
    writeln!(out, "    mov r13, [r12+8] ; byte length")?;
    writeln!(out, "    mov rsi, r13 ; data and terminator size")?;
    writeln!(
        out,
        "    add rsi, {} ; include descriptor",
        STRING_DESCRIPTOR_SIZE + 1
    )?;
    emit_dynamic_mmap(out)?;
    writeln!(out, "    mov rbx, rax ; cloned mapping base")?;
    writeln!(out, "    xor rcx, rcx ; byte offset")?;
    writeln!(out, "clone_descriptor_ptr_copy:")?;
    writeln!(out, "    cmp rcx, r13")?;
    writeln!(out, "    ja clone_descriptor_ptr_copied")?;
    writeln!(out, "    mov rdi, [r12] ; source data")?;
    writeln!(out, "    mov dl, [rdi+rcx]")?;
    writeln!(out, "    mov [rbx+rcx], dl")?;
    writeln!(out, "    inc rcx")?;
    writeln!(out, "    jmp clone_descriptor_ptr_copy")?;
    writeln!(out, "clone_descriptor_ptr_copied:")?;
    writeln!(out, "    lea rax, [rbx+r13+1] ; cloned descriptor")?;
    writeln!(out, "    mov [rax], rbx ; cloned data")?;
    writeln!(out, "    mov [rax+8], r13 ; cloned byte length")?;
    writeln!(
        out,
        "    mov [rax+{DESCRIPTOR_HEAP_BASE_OFFSET}], rbx ; owned mapping base"
    )?;
    writeln!(out, "    mov rdx, r13")?;
    writeln!(out, "    add rdx, {}", STRING_DESCRIPTOR_SIZE + 1)?;
    writeln!(
        out,
        "    mov [rax+{DESCRIPTOR_HEAP_SIZE_OFFSET}], rdx ; owned mapping size"
    )?;
    writeln!(out, "    jmp clone_descriptor_ptr_done")?;
    writeln!(out, "clone_descriptor_ptr_static:")?;
    writeln!(out, "    mov rax, r12 ; static descriptors are immutable")?;
    writeln!(out, "clone_descriptor_ptr_done:")?;
    writeln!(out, "    pop r13")?;
    writeln!(out, "    pop r12")?;
    writeln!(out, "    pop rbx")?;
    writeln!(out, "    ret")?;
    Ok(())
}

pub fn emit_memcpy_helper<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global memcpy_helper")?;
    writeln!(out, "memcpy_helper:")?;
    writeln!(out, "    push rbp ; prologue")?;
    writeln!(out, "    mov rbp, rsp")?;
    writeln!(out, "    xor rcx, rcx ; counter = 0")?;
    writeln!(out, "internal_memcpy_loop:")?;
    writeln!(out, "    cmp rcx, rdx ; counter < count?")?;
    writeln!(out, "    jge internal_memcpy_done")?;
    writeln!(out, "    mov rax, [rsi+rcx] ; load 8 bytes from source")?;
    writeln!(out, "    mov [rdi+rcx], rax ; store 8 bytes to destination")?;
    writeln!(out, "    add rcx, 8 ; advance counter by 8")?;
    writeln!(out, "    jmp internal_memcpy_loop")?;
    writeln!(out, "internal_memcpy_done:")?;
    writeln!(out, "    pop rbp")?;
    writeln!(out, "    ret")?;
    Ok(())
}

pub fn emit_bytes_build_helpers<W: Write>(out: &mut W) -> Result<(), error::Error> {
    emit_bytes_build_inspector(out)?;
    emit_bytes_build_empty(out)?;
    emit_bytes_build_one(out)?;
    emit_bytes_build_step(out)?;
    emit_bytes_build_reference_helper(
        out,
        "bytes_build_inspector_deep_release",
        &[(-32, None), (-24, None), (-8, Some(0))],
        false,
    )?;
    emit_bytes_build_reference_helper(
        out,
        "bytes_build_inspector_deepcopy",
        &[(-32, None), (-24, None), (-8, Some(0))],
        true,
    )?;
    emit_bytes_build_reference_helper(
        out,
        "bytes_build_empty_deep_release",
        &[(-48, None), (-40, None), (-32, None)],
        false,
    )?;
    emit_bytes_build_reference_helper(
        out,
        "bytes_build_empty_deepcopy",
        &[(-48, None), (-40, None), (-32, None)],
        true,
    )?;
    emit_bytes_build_reference_helper(
        out,
        "bytes_build_one_deep_release",
        &[(-56, None), (-48, None), (-40, None)],
        false,
    )?;
    emit_bytes_build_reference_helper(
        out,
        "bytes_build_one_deepcopy",
        &[(-56, None), (-48, None), (-40, None)],
        true,
    )?;
    Ok(())
}

fn emit_bytes_build_inspector<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global bytes_build_inspector_unwrapper")?;
    writeln!(out, "bytes_build_inspector_unwrapper:")?;
    writeln!(out, "    push rbp")?;
    writeln!(out, "    mov rbp, rsp")?;
    writeln!(out, "    sub rsp, 64")?;
    writeln!(out, "    mov [rbp-8], rdi")?;
    for (slot, offset) in [(16, -32), (24, -24), (32, -16), (40, -8)] {
        writeln!(out, "    mov rax, [rdi{offset:+}]")?;
        writeln!(out, "    mov [rbp-{slot}], rax")?;
    }
    writeln!(out, "    call release_heap_ptr")?;
    writeln!(out, "    mov rsi, [rbp-32]")?;
    writeln!(out, "    add rsi, {}", STRING_DESCRIPTOR_SIZE + 1)?;
    writeln!(out, "    jc bytes_build_inspector_invalid")?;
    emit_dynamic_mmap(out)?;
    writeln!(out, "    test rax, rax")?;
    writeln!(out, "    js bytes_build_inspector_invalid")?;
    writeln!(out, "    mov [rbp-48], rax")?;
    writeln!(out, "    cmp qword [rbp-32], 0")?;
    writeln!(out, "    je bytes_build_inspector_empty")?;
    writeln!(out, "    mov rdi, [rbp-16]")?;
    writeln!(out, "    mov rsi, [rbp-24]")?;
    writeln!(out, "    mov rdx, [rbp-40]")?;
    writeln!(out, "    mov rcx, [rbp-48]")?;
    writeln!(out, "    mov r8, [rbp-32]")?;
    writeln!(out, "    xor r9, r9")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp bytes_build_step")?;

    writeln!(out, "bytes_build_inspector_empty:")?;
    writeln!(out, "    mov rbx, [rbp-48]")?;
    writeln!(out, "    mov byte [rbx], 0")?;
    writeln!(out, "    lea rax, [rbx+1]")?;
    writeln!(out, "    mov [rax], rbx")?;
    writeln!(out, "    mov qword [rax+8], 0")?;
    writeln!(out, "    mov [rax+{DESCRIPTOR_HEAP_BASE_OFFSET}], rbx")?;
    writeln!(
        out,
        "    mov qword [rax+{DESCRIPTOR_HEAP_SIZE_OFFSET}], {}",
        STRING_DESCRIPTOR_SIZE + 1
    )?;
    writeln!(out, "    mov [rbp-56], rax")?;
    emit_release_stack_closure(out, 16)?;
    emit_release_stack_closure(out, 40)?;
    writeln!(out, "    mov rbx, [rbp-24]")?;
    writeln!(out, "    mov rax, [rbp-56]")?;
    writeln!(out, "    mov [rbx-8], rax")?;
    writeln!(out, "    mov qword [rbx+40], 0")?;
    writeln!(out, "    mov rdi, rbx")?;
    writeln!(out, "    mov rax, [rbx]")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp rax")?;

    writeln!(out, "bytes_build_inspector_invalid:")?;
    emit_release_stack_closure(out, 24)?;
    emit_release_stack_closure(out, 40)?;
    writeln!(out, "    mov rdi, [rbp-16]")?;
    writeln!(out, "    mov qword [rdi+40], 0")?;
    writeln!(out, "    mov rax, [rdi]")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp rax")?;
    Ok(())
}

fn emit_bytes_build_empty<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global bytes_build_empty_unwrapper")?;
    writeln!(out, "bytes_build_empty_unwrapper:")?;
    writeln!(out, "    push rbp")?;
    writeln!(out, "    mov rbp, rsp")?;
    writeln!(out, "    sub rsp, 64")?;
    writeln!(out, "    mov [rbp-8], rdi")?;
    for (slot, offset) in [(16, -48), (24, -40), (32, -32), (40, -24), (48, -16)] {
        writeln!(out, "    mov rax, [rdi{offset:+}]")?;
        writeln!(out, "    mov [rbp-{slot}], rax")?;
    }
    writeln!(out, "    call release_heap_ptr")?;
    writeln!(out, "    mov rdi, [rbp-40]")?;
    writeln!(out, "    mov rsi, [rbp-48]")?;
    writeln!(out, "    add rsi, {}", STRING_DESCRIPTOR_SIZE + 1)?;
    writeln!(out, "    mov rax, {SYSCALL_MUNMAP}")?;
    writeln!(out, "    syscall")?;
    emit_release_stack_closure(out, 24)?;
    emit_release_stack_closure(out, 32)?;
    writeln!(out, "    mov rdi, [rbp-16]")?;
    writeln!(out, "    mov qword [rdi+40], 0")?;
    writeln!(out, "    mov rax, [rdi]")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp rax")?;
    Ok(())
}

fn emit_bytes_build_one<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global bytes_build_one_unwrapper")?;
    writeln!(out, "bytes_build_one_unwrapper:")?;
    writeln!(out, "    push rbp")?;
    writeln!(out, "    mov rbp, rsp")?;
    writeln!(out, "    sub rsp, 80")?;
    writeln!(out, "    mov [rbp-8], rdi")?;
    for (slot, offset) in [
        (16, -56),
        (24, -48),
        (32, -40),
        (40, -32),
        (48, -24),
        (56, -16),
        (64, -8),
    ] {
        writeln!(out, "    mov rax, [rdi{offset:+}]")?;
        writeln!(out, "    mov [rbp-{slot}], rax")?;
    }
    writeln!(out, "    call release_heap_ptr")?;
    writeln!(out, "    mov rbx, [rbp-40]")?;
    writeln!(out, "    mov rcx, [rbp-56]")?;
    writeln!(out, "    mov rax, [rbp-64]")?;
    writeln!(out, "    mov [rbx+rcx], al")?;
    writeln!(out, "    inc rcx")?;
    writeln!(out, "    cmp rcx, [rbp-48]")?;
    writeln!(out, "    je bytes_build_one_done")?;
    writeln!(out, "    mov rdi, [rbp-16]")?;
    writeln!(out, "    mov rsi, [rbp-24]")?;
    writeln!(out, "    mov rdx, [rbp-32]")?;
    writeln!(out, "    mov r8, [rbp-48]")?;
    writeln!(out, "    mov r9, rcx")?;
    writeln!(out, "    mov rcx, rbx")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp bytes_build_step")?;

    writeln!(out, "bytes_build_one_done:")?;
    writeln!(out, "    mov byte [rbx+rcx], 0")?;
    writeln!(out, "    lea rax, [rbx+rcx+1]")?;
    writeln!(out, "    mov [rax], rbx")?;
    writeln!(out, "    mov [rax+8], rcx")?;
    writeln!(out, "    mov [rax+{DESCRIPTOR_HEAP_BASE_OFFSET}], rbx")?;
    writeln!(out, "    mov rdx, rcx")?;
    writeln!(out, "    add rdx, {}", STRING_DESCRIPTOR_SIZE + 1)?;
    writeln!(out, "    mov [rax+{DESCRIPTOR_HEAP_SIZE_OFFSET}], rdx")?;
    writeln!(out, "    mov [rbp-72], rax")?;
    emit_release_stack_closure(out, 16)?;
    emit_release_stack_closure(out, 32)?;
    writeln!(out, "    mov rbx, [rbp-24]")?;
    writeln!(out, "    mov rax, [rbp-72]")?;
    writeln!(out, "    mov [rbx-8], rax")?;
    writeln!(out, "    mov qword [rbx+40], 0")?;
    writeln!(out, "    mov rdi, rbx")?;
    writeln!(out, "    mov rax, [rbx]")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp rax")?;
    Ok(())
}

fn emit_bytes_build_step<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global bytes_build_step")?;
    writeln!(out, "bytes_build_step:")?;
    writeln!(out, "    push rbp")?;
    writeln!(out, "    mov rbp, rsp")?;
    writeln!(out, "    sub rsp, 80")?;
    for (slot, reg) in [
        (8, "rdi"),
        (16, "rsi"),
        (24, "rdx"),
        (32, "rcx"),
        (40, "r8"),
        (48, "r9"),
    ] {
        writeln!(out, "    mov [rbp-{slot}], {reg}")?;
    }
    writeln!(out, "    mov rsi, 96")?;
    emit_dynamic_mmap(out)?;
    writeln!(out, "    test rax, rax")?;
    writeln!(out, "    js bytes_build_step_invalid")?;
    writeln!(out, "    mov [rbp-56], rax")?;
    for (slot, offset) in [(8, 0), (16, 8), (24, 16)] {
        writeln!(out, "    mov rdi, [rbp-{slot}]")?;
        writeln!(out, "    call deepcopy_heap_ptr")?;
        writeln!(out, "    mov rbx, [rbp-56]")?;
        writeln!(out, "    mov [rbx+{offset}], rax")?;
    }
    writeln!(out, "    mov rbx, [rbp-56]")?;
    writeln!(out, "    mov rax, [rbp-32]")?;
    writeln!(out, "    mov [rbx+24], rax")?;
    writeln!(out, "    mov rax, [rbp-40]")?;
    writeln!(out, "    mov [rbx+32], rax")?;
    writeln!(out, "    mov rax, [rbp-48]")?;
    writeln!(out, "    mov [rbx+40], rax")?;
    writeln!(out, "    lea r12, [rbx+48]")?;
    emit_bytes_build_metadata(
        out,
        "r12",
        &BytesBuildClosure {
            unwrapper: "bytes_build_empty_unwrapper",
            release: "bytes_build_empty_deep_release",
            deepcopy: "bytes_build_empty_deepcopy",
            env_size: 48,
            heap_size: 96,
            num_remaining: 0,
        },
    )?;
    writeln!(out, "    mov [rbp-56], r12")?;

    writeln!(out, "    mov rsi, 104")?;
    emit_dynamic_mmap(out)?;
    writeln!(out, "    test rax, rax")?;
    writeln!(out, "    js bytes_build_step_one_invalid")?;
    writeln!(out, "    mov rbx, rax")?;
    for (slot, offset) in [(8, 0), (16, 8), (24, 16), (32, 24), (40, 32), (48, 40)] {
        writeln!(out, "    mov rax, [rbp-{slot}]")?;
        writeln!(out, "    mov [rbx+{offset}], rax")?;
    }
    writeln!(out, "    lea r12, [rbx+56]")?;
    emit_bytes_build_metadata(
        out,
        "r12",
        &BytesBuildClosure {
            unwrapper: "bytes_build_one_unwrapper",
            release: "bytes_build_one_deep_release",
            deepcopy: "bytes_build_one_deepcopy",
            env_size: 56,
            heap_size: 104,
            num_remaining: 1,
        },
    )?;
    writeln!(out, "    mov [rbp-64], r12")?;
    writeln!(out, "    mov rdi, [rbp-24]")?;
    writeln!(out, "    call deepcopy_heap_ptr")?;
    writeln!(out, "    mov rbx, rax")?;
    writeln!(out, "    mov rax, [rbp-48]")?;
    writeln!(out, "    mov [rbx-24], rax")?;
    writeln!(out, "    mov rax, [rbp-56]")?;
    writeln!(out, "    mov [rbx-16], rax")?;
    writeln!(out, "    mov rax, [rbp-64]")?;
    writeln!(out, "    mov [rbx-8], rax")?;
    writeln!(out, "    mov qword [rbx+40], 0")?;
    writeln!(out, "    mov rdi, rbx")?;
    writeln!(out, "    mov rax, [rbx]")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp rax")?;

    writeln!(out, "bytes_build_step_one_invalid:")?;
    writeln!(out, "    mov rdi, [rbp-56]")?;
    writeln!(out, "    mov rax, [rdi+8]")?;
    writeln!(out, "    call rax")?;
    writeln!(out, "bytes_build_step_invalid:")?;
    writeln!(out, "    mov rdi, [rbp-32]")?;
    writeln!(out, "    mov rsi, [rbp-40]")?;
    writeln!(out, "    add rsi, {}", STRING_DESCRIPTOR_SIZE + 1)?;
    writeln!(out, "    mov rax, {SYSCALL_MUNMAP}")?;
    writeln!(out, "    syscall")?;
    emit_release_stack_closure(out, 16)?;
    emit_release_stack_closure(out, 24)?;
    writeln!(out, "    mov rdi, [rbp-8]")?;
    writeln!(out, "    mov qword [rdi+40], 0")?;
    writeln!(out, "    mov rax, [rdi]")?;
    writeln!(out, "    leave")?;
    writeln!(out, "    jmp rax")?;
    Ok(())
}

fn emit_dynamic_mmap<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "    mov rax, {SYSCALL_MMAP}")?;
    writeln!(out, "    xor rdi, rdi")?;
    writeln!(out, "    mov rdx, {}", PROT_READ | PROT_WRITE)?;
    writeln!(out, "    mov r10, {}", MAP_PRIVATE | MAP_ANONYMOUS)?;
    writeln!(out, "    mov r8, -1")?;
    writeln!(out, "    xor r9, r9")?;
    writeln!(out, "    syscall")?;
    Ok(())
}

fn emit_release_stack_closure<W: Write>(out: &mut W, slot: usize) -> Result<(), error::Error> {
    writeln!(out, "    mov rdi, [rbp-{slot}]")?;
    writeln!(out, "    mov rax, [rdi+{ENV_METADATA_RELEASE_OFFSET}]")?;
    writeln!(out, "    call rax")?;
    Ok(())
}

fn emit_bytes_build_metadata<W: Write>(
    out: &mut W,
    env: &str,
    closure: &BytesBuildClosure<'_>,
) -> Result<(), error::Error> {
    for (offset, label) in [
        (ENV_METADATA_UNWRAPPER_OFFSET, closure.unwrapper),
        (ENV_METADATA_RELEASE_OFFSET, closure.release),
        (ENV_METADATA_DEEP_COPY_OFFSET, closure.deepcopy),
    ] {
        writeln!(out, "    lea rax, [{label}]")?;
        writeln!(out, "    mov [{env}+{offset}], rax")?;
    }
    writeln!(
        out,
        "    mov qword [{env}+{ENV_METADATA_ENV_SIZE_OFFSET}], {}",
        closure.env_size
    )?;
    writeln!(
        out,
        "    mov qword [{env}+{ENV_METADATA_HEAP_SIZE_OFFSET}], {}",
        closure.heap_size
    )?;
    writeln!(
        out,
        "    mov qword [{env}+{ENV_METADATA_NUM_REMAINING_OFFSET}], {}",
        closure.num_remaining
    )?;
    Ok(())
}

fn emit_bytes_build_reference_helper<W: Write>(
    out: &mut W,
    label: &str,
    references: &[(isize, Option<usize>)],
    is_copy: bool,
) -> Result<(), error::Error> {
    writeln!(out, "global {label}")?;
    writeln!(out, "{label}:")?;
    writeln!(out, "    push rbp")?;
    writeln!(out, "    mov rbp, rsp")?;
    writeln!(out, "    sub rsp, 16")?;
    writeln!(out, "    mov [rbp-8], rdi")?;
    writeln!(
        out,
        "    mov rax, [rdi+{ENV_METADATA_NUM_REMAINING_OFFSET}]"
    )?;
    writeln!(out, "    mov [rbp-16], rax")?;
    for (idx, (offset, max_remaining)) in references.iter().enumerate() {
        if let Some(max_remaining) = max_remaining {
            writeln!(out, "    cmp qword [rbp-16], {max_remaining}")?;
            writeln!(out, "    ja {label}_skip_{idx}")?;
        }
        writeln!(out, "    mov rbx, [rbp-8]")?;
        writeln!(out, "    mov rdi, [rbx{offset:+}]")?;
        if is_copy {
            writeln!(out, "    call deepcopy_heap_ptr")?;
            writeln!(out, "    mov rbx, [rbp-8]")?;
            writeln!(out, "    mov [rbx{offset:+}], rax")?;
        } else {
            writeln!(out, "    mov rax, [rdi+{ENV_METADATA_RELEASE_OFFSET}]")?;
            writeln!(out, "    call rax")?;
        }
        if max_remaining.is_some() {
            writeln!(out, "{label}_skip_{idx}:")?;
        }
    }
    if !is_copy {
        writeln!(out, "    mov rdi, [rbp-8]")?;
        writeln!(out, "    call release_heap_ptr")?;
    }
    writeln!(out, "    leave")?;
    writeln!(out, "    ret")?;
    Ok(())
}

pub fn emit_utf8_validate<W: Write>(out: &mut W) -> Result<(), error::Error> {
    writeln!(out, "global utf8_validate")?;
    writeln!(out, "utf8_validate:")?;
    writeln!(out, "    xor rdx, rdx")?;
    writeln!(out, "internal_utf8_loop:")?;
    writeln!(out, "    cmp rdx, rsi")?;
    writeln!(out, "    jae internal_utf8_valid")?;
    writeln!(out, "    movzx eax, byte [rdi+rdx]")?;
    writeln!(out, "    cmp eax, 0x80")?;
    writeln!(out, "    jb internal_utf8_ascii")?;
    writeln!(out, "    cmp eax, 0xc2")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp eax, 0xe0")?;
    writeln!(out, "    jb internal_utf8_two")?;
    writeln!(out, "    cmp eax, 0xf0")?;
    writeln!(out, "    jb internal_utf8_three")?;
    writeln!(out, "    cmp eax, 0xf5")?;
    writeln!(out, "    jb internal_utf8_four")?;
    writeln!(out, "    jmp internal_utf8_invalid")?;

    writeln!(out, "internal_utf8_ascii:")?;
    writeln!(out, "    inc rdx")?;
    writeln!(out, "    jmp internal_utf8_loop")?;

    writeln!(out, "internal_utf8_two:")?;
    writeln!(out, "    lea r8, [rdx+2]")?;
    writeln!(out, "    cmp r8, rsi")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    movzx ecx, byte [rdi+rdx+1]")?;
    writeln!(out, "    and ecx, 0xc0")?;
    writeln!(out, "    cmp ecx, 0x80")?;
    writeln!(out, "    jne internal_utf8_invalid")?;
    writeln!(out, "    add rdx, 2")?;
    writeln!(out, "    jmp internal_utf8_loop")?;

    writeln!(out, "internal_utf8_three:")?;
    writeln!(out, "    lea r8, [rdx+3]")?;
    writeln!(out, "    cmp r8, rsi")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    movzx ecx, byte [rdi+rdx+1]")?;
    writeln!(out, "    cmp eax, 0xe0")?;
    writeln!(out, "    jne internal_utf8_three_not_e0")?;
    writeln!(out, "    cmp ecx, 0xa0")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp ecx, 0xbf")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    jmp internal_utf8_three_tail")?;
    writeln!(out, "internal_utf8_three_not_e0:")?;
    writeln!(out, "    cmp eax, 0xed")?;
    writeln!(out, "    jne internal_utf8_three_middle")?;
    writeln!(out, "    cmp ecx, 0x80")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp ecx, 0x9f")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    jmp internal_utf8_three_tail")?;
    writeln!(out, "internal_utf8_three_middle:")?;
    writeln!(out, "    cmp ecx, 0x80")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp ecx, 0xbf")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "internal_utf8_three_tail:")?;
    writeln!(out, "    movzx ecx, byte [rdi+rdx+2]")?;
    writeln!(out, "    and ecx, 0xc0")?;
    writeln!(out, "    cmp ecx, 0x80")?;
    writeln!(out, "    jne internal_utf8_invalid")?;
    writeln!(out, "    add rdx, 3")?;
    writeln!(out, "    jmp internal_utf8_loop")?;

    writeln!(out, "internal_utf8_four:")?;
    writeln!(out, "    lea r8, [rdx+4]")?;
    writeln!(out, "    cmp r8, rsi")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    movzx ecx, byte [rdi+rdx+1]")?;
    writeln!(out, "    cmp eax, 0xf0")?;
    writeln!(out, "    jne internal_utf8_four_not_f0")?;
    writeln!(out, "    cmp ecx, 0x90")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp ecx, 0xbf")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    jmp internal_utf8_four_tail")?;
    writeln!(out, "internal_utf8_four_not_f0:")?;
    writeln!(out, "    cmp eax, 0xf4")?;
    writeln!(out, "    jne internal_utf8_four_middle")?;
    writeln!(out, "    cmp ecx, 0x80")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp ecx, 0x8f")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "    jmp internal_utf8_four_tail")?;
    writeln!(out, "internal_utf8_four_middle:")?;
    writeln!(out, "    cmp ecx, 0x80")?;
    writeln!(out, "    jb internal_utf8_invalid")?;
    writeln!(out, "    cmp ecx, 0xbf")?;
    writeln!(out, "    ja internal_utf8_invalid")?;
    writeln!(out, "internal_utf8_four_tail:")?;
    for offset in [2, 3] {
        writeln!(out, "    movzx ecx, byte [rdi+rdx+{}]", offset)?;
        writeln!(out, "    and ecx, 0xc0")?;
        writeln!(out, "    cmp ecx, 0x80")?;
        writeln!(out, "    jne internal_utf8_invalid")?;
    }
    writeln!(out, "    add rdx, 4")?;
    writeln!(out, "    jmp internal_utf8_loop")?;

    writeln!(out, "internal_utf8_valid:")?;
    writeln!(out, "    mov eax, 1")?;
    writeln!(out, "    ret")?;
    writeln!(out, "internal_utf8_invalid:")?;
    writeln!(out, "    xor eax, eax")?;
    writeln!(out, "    ret")?;
    Ok(())
}
