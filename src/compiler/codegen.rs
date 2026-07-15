use crate::compiler::air;
use crate::compiler::air::{
    AirAdd, AirAddF64, AirArg, AirBinaryBits, AirCallPtr, AirCallPtrTarget, AirConvertFixed,
    AirDivBits, AirDivF64, AirDivInt, AirField, AirFunction, AirJump, AirJumpArgs, AirJumpClosure,
    AirJumpEq, AirJumpGt, AirJumpLt, AirLabel, AirMul, AirMulF64, AirNewClosure, AirOp, AirPin,
    AirReadFile, AirReturn, AirStmt, AirSub, AirSysExit, AirValue, Lit, SigKind,
};
use crate::compiler::builtins;
use crate::compiler::builtins::AirRuntimeHelper;
use crate::compiler::error::{Code, Error};
use crate::compiler::hir::FixedIntInterpretation;
use crate::compiler::runtime;
use crate::compiler::span::Span;
use std::collections::{HashMap, HashSet};
use std::io::Write;

const WORD_SIZE: usize = 8;
const STRING_DESCRIPTOR_SIZE: usize = WORD_SIZE * 2;
pub const ENV_METADATA_UNWRAPPER_OFFSET: usize = 0;
pub const ENV_METADATA_RELEASE_OFFSET: usize = WORD_SIZE;
pub const ENV_METADATA_DEEP_COPY_OFFSET: usize = WORD_SIZE * 2;
pub const ENV_METADATA_ENV_SIZE_OFFSET: usize = WORD_SIZE * 3;
pub const ENV_METADATA_HEAP_SIZE_OFFSET: usize = WORD_SIZE * 4;
pub const ENV_METADATA_NUM_REMAINING_OFFSET: usize = WORD_SIZE * 5;
pub const ENV_METADATA_SIZE: usize = WORD_SIZE * 6;
pub const CLOSURE_ENV_REG: &str = "r12";
pub const ARG_REGS: [&str; 6] = ["rdi", "rsi", "rdx", "rcx", "r8", "r9"];
pub const SYSCALL_READ: i32 = 0;
pub const SYSCALL_OPEN: i32 = 2;
pub const SYSCALL_CLOSE: i32 = 3;
pub const SYSCALL_LSEEK: i32 = 8;
pub const SYSCALL_MMAP: i32 = 9;
pub const SYSCALL_MUNMAP: i32 = 11;
pub const SYSCALL_EXIT: i32 = 60;
pub const SEEK_END: i32 = 2;
pub const PROT_READ: i32 = 1;
pub const PROT_WRITE: i32 = 2;
pub const MAP_PRIVATE: i32 = 2;
pub const MAP_ANONYMOUS: i32 = 32;
pub const FMT_BUFFER_SIZE: usize = 1024;

#[derive(Debug, Default)]
pub struct Artifacts {
    string_literals: Vec<(String, String)>,
    pub externs: HashSet<String>,
    builtins_used: HashSet<String>,
}

impl Artifacts {
    pub fn collect(air_functions: &[AirFunction]) -> Self {
        let mut artifacts = Artifacts::default();
        for function in air_functions {
            for stmt in &function.items {
                artifacts.process_statement(stmt);
            }
        }
        artifacts
    }

    fn process_statement(&mut self, stmt: &AirStmt) {
        self.collect_literals_in_stmt(stmt);
        match stmt.as_op() {
            Some(AirOp::Sprintf(_)) => {
                self.externs.insert("sprintf".to_string());
            }
            Some(AirOp::Write(_)) => {
                self.externs.insert("write".to_string());
            }
            Some(AirOp::ReadFile(_)) => {
                self.externs
                    .insert(AirRuntimeHelper::ReleaseHeapPtr.name().to_string());
            }
            Some(AirOp::SysExit(_)) => {
                // Call libc exit instead of raw syscall to ensure proper cleanup and flushing
                self.externs.insert("exit".to_string());
            }
            Some(AirOp::CallPtr(_)) => {
                self.externs
                    .insert(AirRuntimeHelper::ReleaseHeapPtr.name().to_string());
            }
            Some(AirOp::ReleaseHeap(_)) => {
                self.externs
                    .insert(AirRuntimeHelper::ReleaseHeapPtr.name().to_string());
            }
            Some(AirOp::CopyField(_)) => {
                self.externs
                    .insert(AirRuntimeHelper::DeepCopyHeapPtr.name().to_string());
            }
            _ => {}
        }
    }

    fn collect_literals_in_stmt(&mut self, stmt: &AirStmt) {
        if let Some(op) = stmt.as_op() {
            self.collect_literals_in_op(op);
        }
    }

    fn collect_literals_in_args(&mut self, args: &[AirArg]) {
        for arg in args {
            if let Some(Lit::Str(value)) = &arg.literal {
                self.add_string_literal(&arg.name, value);
            }
        }
    }

    fn collect_literals_in_binary_inputs(&mut self, input_a: &AirArg, input_b: &AirArg) {
        if let Some(Lit::Str(value)) = &input_a.literal {
            self.add_string_literal(&input_a.name, value);
        }
        if let Some(Lit::Str(value)) = &input_b.literal {
            self.add_string_literal(&input_b.name, value);
        }
    }

    fn collect_literals_in_op(&mut self, op: &AirOp) {
        match op {
            AirOp::JumpClosure(jump) => self.collect_literals_in_args(&jump.args),
            AirOp::NewClosure(closure) => self.collect_literals_in_args(&closure.args),
            AirOp::SetField(set) => self.collect_literals_in_args(std::slice::from_ref(&set.value)),
            AirOp::JumpEqInt(eq) | AirOp::JumpEqStr(eq) => {
                self.collect_literals_in_args(&eq.args);
            }
            AirOp::Add(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::AddBits(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::Sub(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::SubBits(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::Mul(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::MulBits(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::DivInt(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::DivBits(op) => self.collect_literals_in_binary_inputs(&op.input_a, &op.input_b),
            AirOp::ConvertFixed(op) => {
                self.collect_literals_in_args(std::slice::from_ref(&op.input))
            }
            AirOp::Sprintf(call) => self.collect_literals_in_args(&call.args),
            AirOp::Write(call) => self.collect_literals_in_args(&call.args),
            AirOp::ReadFile(op) => self.collect_literals_in_args(std::slice::from_ref(&op.path)),
            AirOp::JumpArgs(call) => self.collect_literals_in_args(&call.args),
            AirOp::SysExit(syscall) => self.collect_literals_in_args(&syscall.args),
            _ => {}
        }
    }

    pub fn string_literals(&self) -> &[(String, String)] {
        &self.string_literals
    }

    pub fn add_string_literal(&mut self, label: &str, value: &str) {
        if self
            .string_literals
            .iter()
            .any(|(existing_label, _)| existing_label == label)
        {
            return;
        }
        self.string_literals
            .push((label.to_string(), value.to_string()));
    }
}

pub fn write_preamble<W: Write>(out: &mut W) -> Result<(), Error> {
    writeln!(out, "bits 64")?;
    writeln!(out, "default rel")?;
    writeln!(out, "section .text")?;
    Ok(())
}

pub fn function<W: Write>(
    air: AirFunction,
    artifacts: &mut Artifacts,
    out: &mut W,
) -> Result<(), Error> {
    emit_runtime_helpers(&air, artifacts, out)?;
    if !artifacts.builtins_used.insert(air.sig.name.clone()) {
        return Ok(());
    }
    if runtime::emit_builtin_function(&air, out)? {
        return Ok(());
    }
    let frame = FrameLayout::build(&air)?;
    let mut emitter = FunctionEmitter::new(air.clone(), out, frame);
    emitter.emit_function()?;
    Ok(())
}

fn emit_runtime_helpers<W: Write>(
    air: &AirFunction,
    artifacts: &mut Artifacts,
    out: &mut W,
) -> Result<(), Error> {
    let mut needs_release = false;
    let mut needs_deepcopy = false;
    for stmt in &air.items {
        match stmt.as_op() {
            Some(AirOp::ReleaseHeap(_)) => needs_release = true,
            Some(AirOp::CopyField(_)) => needs_deepcopy = true,
            Some(AirOp::CallPtr(_)) => needs_release = true,
            Some(AirOp::ReadFile(_)) => needs_release = true,
            _ => {}
        }
    }

    if needs_release {
        emit_runtime_helper_once(AirRuntimeHelper::ReleaseHeapPtr, artifacts, out)?;
    }
    if needs_deepcopy {
        emit_runtime_helper_once(AirRuntimeHelper::DeepCopyHeapPtr, artifacts, out)?;
        emit_runtime_helper_once(AirRuntimeHelper::MemcpyHelper, artifacts, out)?;
    }
    Ok(())
}

fn emit_runtime_helper_once<W: Write>(
    helper: AirRuntimeHelper,
    artifacts: &mut Artifacts,
    out: &mut W,
) -> Result<(), Error> {
    if !artifacts.builtins_used.insert(helper.name().to_string()) {
        return Ok(());
    }
    artifacts.externs.remove(helper.name());
    match helper {
        AirRuntimeHelper::ReleaseHeapPtr => runtime::emit_release_heap_ptr(out),
        AirRuntimeHelper::DeepCopyHeapPtr => runtime::emit_deepcopy_heap_ptr(out),
        AirRuntimeHelper::MemcpyHelper => runtime::emit_memcpy_helper(out),
    }
}

pub fn emit_externs<W: Write>(externs: &HashSet<String>, out: &mut W) -> Result<(), Error> {
    if externs.is_empty() {
        return Ok(());
    }
    let mut names: Vec<&String> = externs.iter().collect();
    names.sort();
    for name in names {
        writeln!(out, "extern {}", name)?;
    }
    Ok(())
}

pub fn emit_data<W: Write>(string_literals: &[(String, String)], out: &mut W) -> Result<(), Error> {
    if string_literals.is_empty() {
        return Ok(());
    }
    writeln!(out, "section .rodata")?;
    for (label, literal) in string_literals {
        writeln!(out, "{}:", label)?;
        writeln!(
            out,
            "    dq {}_data, {} ; string data pointer and byte length",
            label,
            literal.len()
        )?;
        writeln!(out, "{}_data:", label)?;
        let escaped = crate::escape_literal_for_rodata(literal);
        writeln!(out, "    db {}, 0", escaped)?;
    }
    Ok(())
}

#[derive(Clone, Debug)]
struct Binding {
    offset: i32,
}

impl Binding {
    fn slot_addr(&self, slot: usize) -> i32 {
        self.offset + (slot as i32) * 8
    }
}

struct FrameLayout {
    bindings: HashMap<String, Binding>,
    stack_size: i32,
    next_offset: i32,
}

impl FrameLayout {
    fn build(air: &AirFunction) -> Result<Self, Error> {
        let mut layout = Self {
            bindings: HashMap::new(),
            stack_size: 0,
            next_offset: 0,
        };
        for param in &air.sig.params {
            layout.allocate(&param.name, word_count_from_kind(&param.kind))?;
        }
        for stmt in &air.items {
            if let Some((name, words)) = air_statement_binding_info(stmt) {
                layout.allocate(name, words)?;
            }
        }
        layout.stack_size = align_to(layout.next_offset as usize, 16) as i32;
        Ok(layout)
    }

    fn allocate(&mut self, name: &str, words: usize) -> Result<(), Error> {
        let offset = self.next_offset + WORD_SIZE as i32;
        self.next_offset += (words * WORD_SIZE) as i32;
        self.bindings.insert(name.to_string(), Binding { offset });
        Ok(())
    }

    fn binding(&self, name: &str) -> Option<&Binding> {
        self.bindings.get(name)
    }

    fn binding_mut(&mut self, name: &str) -> Option<&mut Binding> {
        self.bindings.get_mut(name)
    }
}

fn air_statement_binding_info(stmt: &AirStmt) -> Option<(&str, usize)> {
    match stmt.as_op() {
        Some(AirOp::NewClosure(s)) => Some((&s.name, 1)),
        Some(AirOp::CloneClosure(s)) => Some((&s.dst, 1)),
        Some(AirOp::Field(field)) => {
            Some((field.result.as_str(), word_count_from_kind(&field.kind)))
        }
        Some(AirOp::CopyField(field)) => Some((field.result.as_str(), 1)),
        _ => None,
    }
}

#[derive(Clone, Copy, Debug)]
struct ArgSplit {
    reg_slots: usize,
    stack_bytes: usize,
}

struct FunctionEmitter<'a, W: Write> {
    air: AirFunction,
    out: &'a mut W,
    frame: FrameLayout,
    terminated: bool,
    label_counter: usize,
}

impl<'a, W: Write> FunctionEmitter<'a, W> {
    fn new(air: AirFunction, out: &'a mut W, frame: FrameLayout) -> Self {
        Self {
            air,
            out,
            frame,
            terminated: false,
            label_counter: 0,
        }
    }

    fn emit_function(&mut self) -> Result<(), Error> {
        writeln!(self.out, "global {}", self.air.sig.name)?;
        writeln!(self.out, "{}:", self.air.sig.name)?;
        writeln!(self.out, "    push rbp ; save executor frame pointer")?;
        writeln!(self.out, "    mov rbp, rsp ; establish new frame base")?;
        if self.frame.stack_size > 0 {
            writeln!(
                self.out,
                "    sub rsp, {} ; reserve stack space for locals",
                self.frame.stack_size
            )?;
        }
        self.store_params()?;
        self.emit_block()?;
        Ok(())
    }

    fn emit_pin(&mut self, pin: &AirPin) -> Result<(), Error> {
        self.load_value_into_reg(&pin.value, CLOSURE_ENV_REG)?;
        Ok(())
    }

    fn store_params(&mut self) -> Result<(), Error> {
        let mut slot = 0usize;
        let mut spilled = false;
        let mut stack_offset_bytes = 0usize;
        for param in &self.air.sig.params {
            let name = &param.name;
            let binding = self
                .frame
                .binding_mut(name)
                .ok_or_else(|| Error::new(Code::Codegen, "missing binding", Span::unknown()))?;
            let word_count = word_count_from_kind(&param.kind);
            for word in 0..word_count {
                let slot_addr = binding.slot_addr(word);
                if !spilled && slot < ARG_REGS.len() {
                    let reg = ARG_REGS[slot];
                    if word_count == 1 {
                        writeln!(
                            self.out,
                            "    mov [rbp-{}], {} ; store {} arg in frame",
                            slot_addr, reg, name
                        )?;
                    } else {
                        writeln!(
                            self.out,
                            "    mov [rbp-{}], {} ; store {} arg word in frame",
                            slot_addr, reg, name
                        )?;
                    }
                    slot += 1;
                } else {
                    spilled = true;
                    let addr = 8 + stack_offset_bytes;
                    if word_count == 1 {
                        writeln!(
                            self.out,
                            "    mov rax, [rbp+{}] ; load spilled {} arg",
                            addr, name
                        )?;
                        writeln!(
                            self.out,
                            "    mov [rbp-{}], rax ; store spilled arg",
                            slot_addr
                        )?;
                    } else {
                        writeln!(
                            self.out,
                            "    mov rax, [rbp+{}] ; load spilled {} arg word",
                            addr, name
                        )?;
                        writeln!(
                            self.out,
                            "    mov [rbp-{}], rax ; store spilled arg word",
                            slot_addr
                        )?;
                    }
                    stack_offset_bytes += WORD_SIZE;
                }
            }
        }
        Ok(())
    }

    fn emit_block(&mut self) -> Result<(), Error> {
        let statements = self.air.items.clone();
        for stmt in statements {
            if self.terminated {
                if let AirStmt::Label(_) = stmt {
                    self.terminated = false;
                } else {
                    continue;
                }
            }
            self.emit_statement(&stmt)?;
        }
        Ok(())
    }

    fn emit_statement(&mut self, stmt: &AirStmt) -> Result<(), Error> {
        match stmt {
            AirStmt::Label(label) => {
                self.emit_label(label)?;
                Ok(())
            }
            AirStmt::Op(op) => {
                self.emit_air_op(op.as_ref())?;
                Ok(())
            }
        }
    }

    fn emit_air_op(&mut self, op: &AirOp) -> Result<(), Error> {
        match op {
            AirOp::NewClosure(closure) => {
                let name = closure.name.clone();
                self.emit_new_closure(closure)?;
                self.store_binding_value(&name)
            }
            AirOp::CloneClosure(clone) => {
                self.emit_clone_closure(clone)?;
                self.store_binding_value(&clone.dst)
            }
            AirOp::Jump(jump) => self.emit_jump(jump),
            AirOp::JumpEqInt(eq) => self.emit_eq_int_jump(eq),
            AirOp::JumpEqStr(eq) => self.emit_eq_str_jump(eq),
            AirOp::JumpLt(jump) => self.emit_lt_jump(jump),
            AirOp::ReleaseHeap(release) => self.emit_release_heap_ptr(&release.name),
            AirOp::Pin(pin) => self.emit_pin(pin),
            AirOp::Field(field) => self.emit_get_field(field),
            AirOp::SetField(set) => self.emit_set_field(set),
            AirOp::CopyField(field) => self.emit_copy_field(field),
            AirOp::Add(op) => self.emit_add(op),
            AirOp::AddBits(op) => self.emit_add_bits(op),
            AirOp::Sub(op) => self.emit_sub(op),
            AirOp::SubBits(op) => self.emit_sub_bits(op),
            AirOp::Mul(op) => self.emit_mul(op),
            AirOp::MulBits(op) => self.emit_mul_bits(op),
            AirOp::DivInt(op) => self.emit_div_int(op),
            AirOp::DivBits(op) => self.emit_div_bits(op),
            AirOp::AddF64(op) => self.emit_add_f64(op),
            AirOp::MulF64(op) => self.emit_mul_f64(op),
            AirOp::DivF64(op) => self.emit_div_f64(op),
            AirOp::ConvertFixed(op) => self.emit_convert_fixed(op),
            AirOp::JumpGt(jump) => self.emit_gt_jump(jump),
            AirOp::Sprintf(op) => self.emit_libc_op(
                builtins::Builtin::Sprintf,
                &op.args,
                &op.arg_kinds,
                &op.target,
            ),
            AirOp::Write(op) => self.emit_libc_op(
                builtins::Builtin::Write,
                &op.args,
                &op.arg_kinds,
                &op.target,
            ),
            AirOp::ReadFile(op) => self.emit_read_file(op),
            AirOp::CallPtr(call) => self.emit_call_ptr(call),
            AirOp::SysExit(syscall) => self.emit_exit_syscall(syscall),
            AirOp::JumpArgs(call) => self.emit_jump_args(call),
            AirOp::JumpClosure(jump) => self.emit_jump_closure(jump),
            AirOp::Return(ret) => self.emit_return(ret),
        }
    }

    fn emit_set_field(&mut self, set: &air::AirSetField) -> Result<(), Error> {
        let base_reg = CLOSURE_ENV_REG;
        for word in 0..word_count_from_kind(&set.value.kind) {
            self.load_arg_word_into_reg(&set.value, word, "rcx")?;
            self.store_at(base_reg, set.offset + word as isize, "rcx")?;
        }
        Ok(())
    }

    fn emit_clone_closure(&mut self, clone: &air::AirCloneClosure) -> Result<(), Error> {
        let src_binding = self.frame.binding(&clone.src).cloned().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", clone.src),
                Span::unknown(),
            )
        })?;

        writeln!(
            self.out,
            "    mov rbx, [rbp-{}] ; original closure {} to {} env_end pointer for clone",
            src_binding.slot_addr(0),
            clone.src,
            clone.dst
        )?;
        self.emit_clone_env_from_env_end("rbx", CLOSURE_ENV_REG)?;
        writeln!(
            self.out,
            "    mov rax, {} ; copy cloned env_end pointer",
            CLOSURE_ENV_REG
        )?;

        Ok(())
    }

    fn store_at(&mut self, base_reg: &str, offset: isize, value_reg: &str) -> Result<(), Error> {
        let addr = self.env_field_operand(base_reg, offset);
        writeln!(
            self.out,
            "    mov [{}], {} ; store env field",
            addr, value_reg
        )?;
        Ok(())
    }

    fn env_field_operand(&self, base_reg: &str, offset: isize) -> String {
        let offset_bytes = offset * WORD_SIZE as isize;
        let abs_offset_bytes = offset_bytes.abs() as i32;
        if offset_bytes >= 0 {
            format!("{base_reg}+{abs_offset_bytes}")
        } else {
            format!("{base_reg}-{abs_offset_bytes}")
        }
    }

    fn emit_eq_int_jump(&mut self, eq: &AirJumpEq) -> Result<(), Error> {
        self.emit_builtin_int_condition(&eq.args, &eq.target)
    }

    fn emit_eq_str_jump(&mut self, eq: &AirJumpEq) -> Result<(), Error> {
        let false_label = self.new_label("eqs_false");
        self.emit_builtin_string_condition(&eq.args, &eq.target, &false_label)?;
        writeln!(self.out, "{}:", false_label)?;
        Ok(())
    }

    fn emit_lt_jump(&mut self, jump: &AirJumpLt) -> Result<(), Error> {
        self.load_value_into_reg(&jump.left, "rax")?;
        self.load_value_into_reg(&jump.right, "rbx")?;
        writeln!(self.out, "    cmp rax, rbx")?;
        writeln!(self.out, "    jl {}", jump.target)?;
        Ok(())
    }

    fn emit_gt_jump(&mut self, jump: &AirJumpGt) -> Result<(), Error> {
        self.load_value_into_reg(&jump.left, "rax")?;
        self.load_value_into_reg(&jump.right, "rbx")?;
        writeln!(self.out, "    cmp rax, rbx")?;
        writeln!(self.out, "    jg {}", jump.target)?;
        Ok(())
    }
    fn emit_add(&mut self, op: &AirAdd) -> Result<(), Error> {
        self.emit_binary_op(
            &op.input_a,
            &op.input_b,
            &op.target,
            "add",
            "add second integer",
            false,
        )
    }

    fn emit_add_bits(&mut self, op: &AirBinaryBits) -> Result<(), Error> {
        if op.bit_width == 128 {
            self.load_arg_word_into_reg(&op.input_a, 0, "rax")?;
            self.load_arg_word_into_reg(&op.input_a, 1, "rdx")?;
            self.load_arg_word_into_reg(&op.input_b, 0, "rbx")?;
            self.load_arg_word_into_reg(&op.input_b, 1, "rcx")?;
            writeln!(self.out, "    add rax, rbx ; add low words")?;
            writeln!(self.out, "    adc rdx, rcx ; add high words and carry")?;
            return self.emit_fixed_value_jump(&op.target, op.bit_width);
        }
        self.load_arg_into_reg(&op.input_a, "rax")?;
        self.load_arg_into_reg(&op.input_b, "rbx")?;
        writeln!(self.out, "    add rax, rbx ; add bit values")?;
        self.truncate_fixed("rax", op.bit_width)?;
        self.emit_fixed_value_jump(&op.target, op.bit_width)
    }

    fn emit_sub(&mut self, op: &AirSub) -> Result<(), Error> {
        self.emit_binary_op(
            &op.input_a,
            &op.input_b,
            &op.target,
            "sub",
            "subtract subtrahend",
            false,
        )
    }

    fn emit_mul(&mut self, op: &AirMul) -> Result<(), Error> {
        self.emit_binary_op(
            &op.input_a,
            &op.input_b,
            &op.target,
            "mul",
            "multiply by multiplier",
            false,
        )
    }

    fn emit_sub_bits(&mut self, op: &AirBinaryBits) -> Result<(), Error> {
        if op.bit_width == 128 {
            self.load_arg_word_into_reg(&op.input_a, 0, "rax")?;
            self.load_arg_word_into_reg(&op.input_a, 1, "rdx")?;
            self.load_arg_word_into_reg(&op.input_b, 0, "rbx")?;
            self.load_arg_word_into_reg(&op.input_b, 1, "rcx")?;
            writeln!(self.out, "    sub rax, rbx ; subtract low words")?;
            writeln!(
                self.out,
                "    sbb rdx, rcx ; subtract high words and borrow"
            )?;
            return self.emit_fixed_value_jump(&op.target, op.bit_width);
        }
        self.load_arg_into_reg(&op.input_a, "rax")?;
        self.load_arg_into_reg(&op.input_b, "rbx")?;
        writeln!(self.out, "    sub rax, rbx ; subtract bit values")?;
        self.truncate_fixed("rax", op.bit_width)?;
        self.emit_fixed_value_jump(&op.target, op.bit_width)
    }

    fn emit_mul_bits(&mut self, op: &AirBinaryBits) -> Result<(), Error> {
        if op.bit_width == 128 {
            self.load_arg_word_into_reg(&op.input_a, 0, "r8")?;
            self.load_arg_word_into_reg(&op.input_a, 1, "r9")?;
            self.load_arg_word_into_reg(&op.input_b, 0, "rbx")?;
            self.load_arg_word_into_reg(&op.input_b, 1, "rcx")?;
            writeln!(
                self.out,
                "    mov r10, r8 ; low left word for high cross product"
            )?;
            writeln!(self.out, "    imul r10, rcx ; low left times high right")?;
            writeln!(
                self.out,
                "    mov r11, r9 ; high left word for high cross product"
            )?;
            writeln!(self.out, "    imul r11, rbx ; high left times low right")?;
            writeln!(self.out, "    mov rax, r8 ; low left word for low product")?;
            writeln!(
                self.out,
                "    mul rbx ; low words produce the base 128-bit product"
            )?;
            writeln!(self.out, "    add rdx, r10 ; include first cross product")?;
            writeln!(self.out, "    add rdx, r11 ; include second cross product")?;
            return self.emit_fixed_value_jump(&op.target, op.bit_width);
        }
        self.load_arg_into_reg(&op.input_a, "rax")?;
        self.load_arg_into_reg(&op.input_b, "rbx")?;
        writeln!(self.out, "    imul rax, rbx ; multiply bit values")?;
        self.truncate_fixed("rax", op.bit_width)?;
        self.emit_fixed_value_jump(&op.target, op.bit_width)
    }

    fn emit_convert_fixed(&mut self, op: &AirConvertFixed) -> Result<(), Error> {
        if op.to.bit_width == 128 {
            self.load_arg_word_into_reg(&op.input, 0, "rax")?;
            self.load_arg_word_into_reg(&op.input, 1, "rdx")?;
            return self.emit_fixed_value_jump(&op.target, op.to.bit_width);
        }
        self.load_arg_into_reg(&op.input, "rax")?;
        match op.to.interpretation {
            FixedIntInterpretation::Bits | FixedIntInterpretation::Unsigned => {
                self.truncate_fixed("rax", op.to.bit_width)?;
            }
            FixedIntInterpretation::Signed => match op.to.bit_width {
                8 => writeln!(self.out, "    movsx rax, al ; interpret signed 8-bit value")?,
                32 => writeln!(
                    self.out,
                    "    movsxd rax, eax ; interpret signed 32-bit value"
                )?,
                64 | 128 => {}
                bit_width => panic!("unsupported bit width {bit_width}"),
            },
        }
        self.emit_fixed_value_jump(&op.target, op.to.bit_width)
    }

    fn truncate_fixed(&mut self, reg: &str, bit_width: u16) -> Result<(), Error> {
        match bit_width {
            8 => writeln!(self.out, "    and {reg}, 0xff ; keep low 8 bits")?,
            32 => {
                assert_eq!(reg, "rax");
                writeln!(self.out, "    mov eax, eax ; keep low 32 bits")?;
            }
            64 | 128 => {}
            _ => panic!("unsupported bit width {bit_width}"),
        }
        Ok(())
    }

    fn emit_div_int(&mut self, op: &AirDivInt) -> Result<(), Error> {
        self.load_arg_into_reg(&op.input_b, "rbx")?;

        let ok_label = self.new_label("div_ok");
        writeln!(
            self.out,
            "    cmp rbx, 0 ; check divisor for division by zero"
        )?;
        writeln!(self.out, "    jne {}", ok_label)?;

        self.emit_release_heap_ptr(&op.ok_target)?;
        self.emit_value_jump(&op.err_target, false)?;

        writeln!(self.out, "{}:", ok_label)?;
        self.emit_release_heap_ptr(&op.err_target)?;
        self.load_arg_into_reg(&op.input_a, "rax")?;
        self.load_arg_into_reg(&op.input_b, "rbx")?;
        writeln!(self.out, "    cqo ; sign extend dividend")?;
        writeln!(self.out, "    idiv rbx ; divide by divisor")?;
        self.emit_value_jump(&op.ok_target, true)
    }

    fn emit_div_bits(&mut self, op: &AirDivBits) -> Result<(), Error> {
        if op.bit_width == 128 {
            return self.emit_div_bits_128(op);
        }

        self.load_arg_into_reg(&op.input_b, "rbx")?;
        let ok_label = self.new_label("div_bits_ok");
        writeln!(self.out, "    test rbx, rbx ; check divisor for zero")?;
        writeln!(self.out, "    jne {}", ok_label)?;
        self.emit_release_heap_ptr(&op.ok_target)?;
        self.emit_value_jump(&op.err_target, false)?;

        writeln!(self.out, "{}:", ok_label)?;
        self.emit_release_heap_ptr(&op.err_target)?;
        self.load_arg_into_reg(&op.input_a, "rax")?;
        self.load_arg_into_reg(&op.input_b, "rbx")?;
        if op.is_signed {
            match op.bit_width {
                8 => {
                    writeln!(self.out, "    movsx rax, al ; signed 8-bit dividend")?;
                    writeln!(self.out, "    movsx rbx, bl ; signed 8-bit divisor")?;
                }
                32 => {
                    writeln!(self.out, "    movsxd rax, eax ; signed 32-bit dividend")?;
                    writeln!(self.out, "    movsxd rbx, ebx ; signed 32-bit divisor")?;
                }
                64 => {}
                bit_width => panic!("unsupported fixed division width {bit_width}"),
            }
            if op.bit_width == 64 {
                let divide_label = self.new_label("div_signed_b64_divide");
                let done_label = self.new_label("div_signed_b64_done");
                writeln!(
                    self.out,
                    "    mov rcx, 0x8000000000000000 ; signed 64-bit minimum"
                )?;
                writeln!(self.out, "    cmp rax, rcx ; inspect overflow dividend")?;
                writeln!(self.out, "    jne {}", divide_label)?;
                writeln!(self.out, "    cmp rbx, -1 ; inspect overflow divisor")?;
                writeln!(self.out, "    je {}", done_label)?;
                writeln!(self.out, "{}:", divide_label)?;
                writeln!(self.out, "    cqo ; extend signed dividend")?;
                writeln!(self.out, "    idiv rbx ; signed fixed-width division")?;
                writeln!(self.out, "{}:", done_label)?;
            } else {
                writeln!(self.out, "    cqo ; extend signed dividend")?;
                writeln!(self.out, "    idiv rbx ; signed fixed-width division")?;
            }
        } else {
            writeln!(
                self.out,
                "    xor edx, edx ; clear unsigned dividend high word"
            )?;
            writeln!(self.out, "    div rbx ; unsigned fixed-width division")?;
        }
        self.truncate_fixed("rax", op.bit_width)?;
        self.emit_fixed_value_jump(&op.ok_target, op.bit_width)
    }

    fn emit_div_bits_128(&mut self, op: &AirDivBits) -> Result<(), Error> {
        self.load_arg_word_into_reg(&op.input_b, 0, "rax")?;
        self.load_arg_word_into_reg(&op.input_b, 1, "rdx")?;
        writeln!(self.out, "    or rax, rdx ; check 128-bit divisor for zero")?;
        let ok_label = self.new_label("div_bits_128_ok");
        writeln!(self.out, "    jne {}", ok_label)?;
        self.emit_release_heap_ptr(&op.ok_target)?;
        self.emit_value_jump(&op.err_target, false)?;

        writeln!(self.out, "{}:", ok_label)?;
        self.emit_release_heap_ptr(&op.err_target)?;
        self.load_arg_word_into_reg(&op.input_a, 0, "r8")?;
        self.load_arg_word_into_reg(&op.input_a, 1, "r9")?;
        self.load_arg_word_into_reg(&op.input_b, 0, "r10")?;
        self.load_arg_word_into_reg(&op.input_b, 1, "r11")?;

        if op.is_signed {
            let dividend_ready = self.new_label("div_bits_128_dividend_ready");
            let divisor_ready = self.new_label("div_bits_128_divisor_ready");
            writeln!(self.out, "    mov r14, r9 ; retain dividend sign")?;
            writeln!(self.out, "    xor r14, r11 ; quotient sign bits")?;
            writeln!(self.out, "    shr r14, 63 ; quotient sign")?;
            writeln!(self.out, "    test r9, r9 ; inspect dividend sign")?;
            writeln!(self.out, "    jns {}", dividend_ready)?;
            self.emit_negate_128("r8", "r9")?;
            writeln!(self.out, "{}:", dividend_ready)?;
            writeln!(self.out, "    test r11, r11 ; inspect divisor sign")?;
            writeln!(self.out, "    jns {}", divisor_ready)?;
            self.emit_negate_128("r10", "r11")?;
            writeln!(self.out, "{}:", divisor_ready)?;
        }

        self.emit_unsigned_div_128()?;

        if op.is_signed {
            let sign_ready = self.new_label("div_bits_128_sign_ready");
            writeln!(self.out, "    test r14, r14 ; inspect quotient sign")?;
            writeln!(self.out, "    jz {}", sign_ready)?;
            self.emit_negate_128("rbx", "rcx")?;
            writeln!(self.out, "{}:", sign_ready)?;
        }

        writeln!(self.out, "    mov rax, rbx ; quotient low word")?;
        writeln!(self.out, "    mov rdx, rcx ; quotient high word")?;
        self.emit_fixed_value_jump(&op.ok_target, op.bit_width)
    }

    fn emit_unsigned_div_128(&mut self) -> Result<(), Error> {
        let loop_label = self.new_label("div_bits_128_loop");
        let subtract_label = self.new_label("div_bits_128_subtract");
        let no_subtract_label = self.new_label("div_bits_128_no_subtract");
        let next_label = self.new_label("div_bits_128_next");

        writeln!(self.out, "    xor ebx, ebx ; quotient low word")?;
        writeln!(self.out, "    xor ecx, ecx ; quotient high word")?;
        writeln!(self.out, "    xor eax, eax ; remainder low word")?;
        writeln!(self.out, "    xor edx, edx ; remainder high word")?;
        writeln!(self.out, "    mov r15d, 128 ; division bit count")?;
        writeln!(self.out, "{}:", loop_label)?;
        writeln!(self.out, "    shl r8, 1 ; advance dividend low word")?;
        writeln!(self.out, "    rcl r9, 1 ; advance dividend high word")?;
        writeln!(self.out, "    rcl rax, 1 ; shift next bit into remainder")?;
        writeln!(self.out, "    rcl rdx, 1 ; advance remainder high word")?;
        writeln!(self.out, "    jc {}", subtract_label)?;
        writeln!(self.out, "    cmp rdx, r11 ; compare remainder high word")?;
        writeln!(self.out, "    ja {}", subtract_label)?;
        writeln!(self.out, "    jb {}", no_subtract_label)?;
        writeln!(self.out, "    cmp rax, r10 ; compare remainder low word")?;
        writeln!(self.out, "    jae {}", subtract_label)?;
        writeln!(self.out, "{}:", no_subtract_label)?;
        writeln!(self.out, "    shl rbx, 1 ; append zero quotient bit")?;
        writeln!(self.out, "    rcl rcx, 1 ; advance quotient high word")?;
        writeln!(self.out, "    jmp {}", next_label)?;
        writeln!(self.out, "{}:", subtract_label)?;
        writeln!(self.out, "    sub rax, r10 ; subtract divisor low word")?;
        writeln!(self.out, "    sbb rdx, r11 ; subtract divisor high word")?;
        writeln!(self.out, "    shl rbx, 1 ; append quotient bit")?;
        writeln!(self.out, "    rcl rcx, 1 ; advance quotient high word")?;
        writeln!(self.out, "    or rbx, 1 ; set quotient low bit")?;
        writeln!(self.out, "{}:", next_label)?;
        writeln!(self.out, "    dec r15d ; consume dividend bit")?;
        writeln!(self.out, "    jnz {}", loop_label)?;
        Ok(())
    }

    fn emit_negate_128(&mut self, low: &str, high: &str) -> Result<(), Error> {
        writeln!(self.out, "    not {low} ; invert low word")?;
        writeln!(self.out, "    not {high} ; invert high word")?;
        writeln!(self.out, "    add {low}, 1 ; add two's-complement unit")?;
        writeln!(self.out, "    adc {high}, 0 ; carry into high word")?;
        Ok(())
    }

    fn emit_read_file(&mut self, op: &AirReadFile) -> Result<(), Error> {
        let read_loop = self.new_label("readfile_read_loop");
        let read_done = self.new_label("readfile_read_done");
        let err_unmap = self.new_label("readfile_err_unmap");
        let err_close = self.new_label("readfile_err_close");
        let err = self.new_label("readfile_err");

        self.load_arg_into_reg(&op.path, "rdi")?;
        writeln!(self.out, "    mov rdi, [rdi] ; path data for open")?;
        writeln!(self.out, "    mov rax, {} ; open syscall", SYSCALL_OPEN)?;
        writeln!(self.out, "    xor rsi, rsi ; flags = O_RDONLY")?;
        writeln!(self.out, "    xor rdx, rdx ; mode unused")?;
        writeln!(self.out, "    syscall")?;
        writeln!(self.out, "    test rax, rax ; negative rax is -errno")?;
        writeln!(self.out, "    js {} ; open failed", err)?;
        writeln!(self.out, "    mov r13, rax ; keep file descriptor")?;

        writeln!(self.out, "    mov rdi, r13 ; fd")?;
        writeln!(self.out, "    mov rax, {} ; lseek syscall", SYSCALL_LSEEK)?;
        writeln!(self.out, "    xor rsi, rsi ; offset 0")?;
        writeln!(self.out, "    mov rdx, {} ; SEEK_END", SEEK_END)?;
        writeln!(self.out, "    syscall")?;
        writeln!(self.out, "    test rax, rax")?;
        writeln!(self.out, "    js {} ; size probe failed", err_close)?;
        writeln!(self.out, "    mov r14, rax ; keep file size")?;

        writeln!(self.out, "    mov rdi, r13 ; fd")?;
        writeln!(self.out, "    mov rax, {} ; lseek syscall", SYSCALL_LSEEK)?;
        writeln!(self.out, "    xor rsi, rsi ; offset 0")?;
        writeln!(self.out, "    xor rdx, rdx ; SEEK_SET")?;
        writeln!(self.out, "    syscall")?;

        writeln!(self.out, "    mov rax, {} ; mmap syscall", SYSCALL_MMAP)?;
        writeln!(self.out, "    xor rdi, rdi ; addr hint")?;
        writeln!(
            self.out,
            "    lea rsi, [r14+{}] ; length = size, terminator, and descriptor",
            STRING_DESCRIPTOR_SIZE + 1
        )?;
        writeln!(
            self.out,
            "    mov rdx, {} ; prot = read/write",
            PROT_READ | PROT_WRITE
        )?;
        writeln!(
            self.out,
            "    mov r10, {} ; flags: private & anonymous",
            MAP_PRIVATE | MAP_ANONYMOUS
        )?;
        writeln!(self.out, "    mov r8, -1 ; fd = -1")?;
        writeln!(self.out, "    xor r9, r9 ; offset = 0")?;
        writeln!(self.out, "    syscall")?;
        writeln!(self.out, "    test rax, rax")?;
        writeln!(self.out, "    js {} ; mmap failed", err_close)?;
        writeln!(self.out, "    mov r15, rax ; keep contents buffer")?;
        writeln!(
            self.out,
            "    lea r12, [r15+r14+1] ; string descriptor after contents terminator"
        )?;
        writeln!(self.out, "    xor rbx, rbx ; bytes read so far")?;

        writeln!(self.out, "{}:", read_loop)?;
        writeln!(self.out, "    cmp rbx, r14 ; all bytes read?")?;
        writeln!(self.out, "    jge {}", read_done)?;
        writeln!(self.out, "    mov rdx, r14")?;
        writeln!(self.out, "    sub rdx, rbx ; remaining byte count")?;
        writeln!(self.out, "    lea rsi, [r15+rbx] ; buffer cursor")?;
        writeln!(self.out, "    mov rdi, r13 ; fd")?;
        writeln!(self.out, "    mov rax, {} ; read syscall", SYSCALL_READ)?;
        writeln!(self.out, "    syscall")?;
        writeln!(self.out, "    test rax, rax")?;
        writeln!(self.out, "    js {} ; read failed", err_unmap)?;
        writeln!(self.out, "    jz {} ; end of file", read_done)?;
        writeln!(self.out, "    add rbx, rax ; advance cursor")?;
        writeln!(self.out, "    jmp {}", read_loop)?;

        writeln!(self.out, "{}:", read_done)?;
        writeln!(self.out, "    mov byte [r15+rbx], 0 ; terminate contents")?;
        writeln!(self.out, "    mov [r12], r15 ; store contents data pointer")?;
        writeln!(
            self.out,
            "    mov [r12+8], rbx ; store contents byte length"
        )?;
        writeln!(self.out, "    mov rdi, r13 ; fd")?;
        writeln!(self.out, "    mov rax, {} ; close syscall", SYSCALL_CLOSE)?;
        writeln!(self.out, "    syscall")?;
        self.emit_release_heap_ptr(&op.err_target)?;
        writeln!(self.out, "    mov rax, r12 ; contents descriptor result")?;
        self.emit_value_jump(&op.ok_target, true)?;

        writeln!(self.out, "{}:", err_unmap)?;
        writeln!(self.out, "    mov rdi, r15 ; contents buffer")?;
        writeln!(
            self.out,
            "    lea rsi, [r14+{}] ; mapped length",
            STRING_DESCRIPTOR_SIZE + 1
        )?;
        writeln!(self.out, "    mov rax, {} ; munmap syscall", SYSCALL_MUNMAP)?;
        writeln!(self.out, "    syscall")?;
        writeln!(self.out, "{}:", err_close)?;
        writeln!(self.out, "    mov rdi, r13 ; fd")?;
        writeln!(self.out, "    mov rax, {} ; close syscall", SYSCALL_CLOSE)?;
        writeln!(self.out, "    syscall")?;
        writeln!(self.out, "{}:", err)?;
        self.emit_release_heap_ptr(&op.ok_target)?;
        self.emit_value_jump(&op.err_target, false)
    }

    fn emit_add_f64(&mut self, op: &AirAddF64) -> Result<(), Error> {
        self.emit_float_binary_op(
            &op.input_a,
            &op.input_b,
            &op.target,
            "addsd",
            "add second float",
        )
    }

    fn emit_mul_f64(&mut self, op: &AirMulF64) -> Result<(), Error> {
        self.emit_float_binary_op(
            &op.input_a,
            &op.input_b,
            &op.target,
            "mulsd",
            "multiply by multiplier float",
        )
    }

    fn emit_div_f64(&mut self, op: &AirDivF64) -> Result<(), Error> {
        self.emit_float_binary_op(
            &op.input_a,
            &op.input_b,
            &op.target,
            "divsd",
            "divide by divisor float",
        )
    }

    fn emit_binary_op(
        &mut self,
        input_a: &AirArg,
        input_b: &AirArg,
        target: &str,
        opcode: &str,
        second_comment: &str,
        is_div: bool,
    ) -> Result<(), Error> {
        self.load_arg_into_reg(input_a, "rax")?;
        self.load_arg_into_reg(input_b, "rbx")?;
        if is_div {
            writeln!(self.out, "    cqo ; sign extend dividend")?;
            writeln!(self.out, "    idiv rbx ; {}", second_comment)?;
        } else {
            writeln!(self.out, "    {} rax, rbx ; {}", opcode, second_comment)?;
        }
        self.emit_value_jump(target, true)?;
        Ok(())
    }

    fn emit_float_binary_op(
        &mut self,
        input_a: &AirArg,
        input_b: &AirArg,
        target: &str,
        opcode: &str,
        comment: &str,
    ) -> Result<(), Error> {
        self.load_arg_into_xmm(input_a, "xmm0")?;
        self.load_arg_into_xmm(input_b, "xmm1")?;
        writeln!(
            self.out,
            "    {opcode} xmm0, xmm1 ; {comment}",
            opcode = opcode,
            comment = comment
        )?;
        writeln!(self.out, "    movq rax, xmm0 ; move float result to rax")?;
        self.emit_value_jump(target, true)?;
        Ok(())
    }

    fn emit_libc_op(
        &mut self,
        builtin: builtins::Builtin,
        args: &[AirArg],
        arg_kinds: &[SigKind],
        target: &str,
    ) -> Result<(), Error> {
        let has_result = self.emit_libc_call(builtin, args, arg_kinds)?;
        self.emit_value_jump(target, has_result)?;
        Ok(())
    }

    fn emit_value_jump(&mut self, target: &str, has_result: bool) -> Result<(), Error> {
        self.emit_result_jump(target, usize::from(has_result))
    }

    fn emit_fixed_value_jump(&mut self, target: &str, bit_width: u16) -> Result<(), Error> {
        self.emit_result_jump(target, if bit_width == 128 { 2 } else { 1 })
    }

    fn emit_result_jump(&mut self, target: &str, result_words: usize) -> Result<(), Error> {
        let binding = self.frame.binding(target).cloned().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", target),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    mov {}, [rbp-{}] ; load continuation env_end pointer",
            CLOSURE_ENV_REG,
            binding.slot_addr(0)
        )?;
        if result_words > 0 {
            self.store_at(CLOSURE_ENV_REG, -(result_words as isize), "rax")?;
        }
        if result_words == 2 {
            self.store_at(CLOSURE_ENV_REG, -1, "rdx")?;
        }
        writeln!(
            self.out,
            "    mov rax, [{}+{}] ; load continuation entry point",
            CLOSURE_ENV_REG, ENV_METADATA_UNWRAPPER_OFFSET
        )?;
        writeln!(
            self.out,
            "    mov rdi, {} ; pass env_end pointer to continuation",
            CLOSURE_ENV_REG
        )?;
        writeln!(self.out, "    leave ; unwind before jumping")?;
        writeln!(self.out, "    jmp rax")?;
        self.terminated = true;
        Ok(())
    }

    fn emit_jump_closure(&mut self, jump: &AirJumpClosure) -> Result<(), Error> {
        let binding = self.frame.binding(&jump.env_end).cloned().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", jump.env_end),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    mov rbx, [rbp-{}] ; load {} closure env_end pointer",
            binding.slot_addr(0),
            jump.env_end
        )?;
        let base_reg = "rbx".to_string();
        let mut offset_words = jump
            .args
            .iter()
            .map(|arg| word_count_from_kind(&arg.kind))
            .sum::<usize>();
        for arg in &jump.args {
            for word in 0..word_count_from_kind(&arg.kind) {
                self.load_arg_word_into_reg(arg, word, "rax")?;
                self.store_at(base_reg.as_str(), -(offset_words as isize), "rax")?;
                offset_words -= 1;
            }
        }
        writeln!(
            self.out,
            "    mov rdi, {} ; pass env_end pointer to closure",
            base_reg
        )?;
        writeln!(
            self.out,
            "    mov rax, [rdi+{}] ; load closure unwrapper entry point",
            ENV_METADATA_UNWRAPPER_OFFSET
        )?;
        writeln!(self.out, "    leave ; unwind before jumping")?;
        writeln!(self.out, "    jmp rax ; tail call into closure")?;
        self.terminated = true;
        Ok(())
    }

    fn emit_exit_syscall(&mut self, syscall: &AirSysExit) -> Result<(), Error> {
        let (first_comment, _, _) = Self::exit_syscall_comments();
        writeln!(self.out, "    ; {}", first_comment)?;
        // Call libc exit() instead of raw exit syscall to ensure stdout is flushed
        let code = syscall.args.first().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                "exit builtin requires an exit code",
                Span::unknown(),
            )
        })?;
        self.load_arg_into_reg(code, "rdi")?;
        writeln!(self.out, "    call exit ; call libc exit to flush buffers")?;
        self.terminated = true;
        Ok(())
    }

    fn exit_syscall_comments() -> (&'static str, &'static str, &'static str) {
        ("load exit code", "", "terminate program")
    }

    fn emit_get_field(&mut self, field: &AirField) -> Result<(), Error> {
        let base_reg = CLOSURE_ENV_REG;
        let word_count = word_count_from_kind(&field.kind);
        for word in 0..word_count {
            let addr = self.env_field_operand(base_reg, field.offset + word as isize);
            if word_count == 1 {
                writeln!(
                    self.out,
                    "    mov rax, [{}] ; load {} env field",
                    addr, field.result
                )?;
                self.store_binding_value(&field.result)?;
            } else {
                writeln!(
                    self.out,
                    "    mov rax, [{}] ; load {} env field word",
                    addr, field.result
                )?;
                self.store_binding_word(&field.result, word, "rax")?;
            }
        }
        Ok(())
    }

    fn emit_release_heap_ptr(&mut self, name: &str) -> Result<(), Error> {
        if let Some(binding) = self.frame.binding(name) {
            let binding = binding.clone();
            let env_offset = binding.slot_addr(0);
            writeln!(
                self.out,
                "    mov rdi, [rbp-{}] ; load {} closure env_end pointer",
                env_offset, name
            )?;
        } else {
            writeln!(
                self.out,
                "    mov rdi, {} ; use pinned {} env_end pointer",
                CLOSURE_ENV_REG, name
            )?;
        }
        writeln!(
            self.out,
            "    call {} ; release {} closure environment",
            AirRuntimeHelper::ReleaseHeapPtr.name(),
            name
        )?;
        Ok(())
    }

    fn emit_copy_field(&mut self, field: &AirField) -> Result<(), Error> {
        let field_addr = self.env_field_operand(CLOSURE_ENV_REG, field.offset);
        writeln!(
            self.out,
            "    mov rcx, [{}] ; load field pointer",
            field_addr
        )?;
        writeln!(
            self.out,
            "    mov rdi, rcx ; copy pointer argument for deepcopy"
        )?;
        writeln!(
            self.out,
            "    call {} ; duplicate heap pointer",
            AirRuntimeHelper::DeepCopyHeapPtr.name()
        )?;
        writeln!(
            self.out,
            "    mov [{}], rax ; store duplicated pointer",
            field_addr
        )?;
        self.store_binding_value(&field.result)?;
        Ok(())
    }

    fn emit_call_ptr(&mut self, call: &AirCallPtr) -> Result<(), Error> {
        let AirCallPtrTarget::Binding(name) = &call.target;
        self.load_value_into_reg(&AirValue::Binding(name.clone()), "rdi")?;
        writeln!(
            self.out,
            "    call {} ; release heap pointer",
            AirRuntimeHelper::ReleaseHeapPtr.name()
        )?;
        Ok(())
    }

    fn emit_label(&mut self, label: &AirLabel) -> Result<(), Error> {
        writeln!(self.out, "{}:", label.name)?;
        Ok(())
    }

    fn emit_jump(&mut self, jump: &AirJump) -> Result<(), Error> {
        writeln!(self.out, "    jmp {}", jump.target)?;
        Ok(())
    }

    fn emit_builtin_int_condition(
        &mut self,
        args: &[AirArg],
        true_label: &str,
    ) -> Result<(), Error> {
        if args.len() < 2 {
            return Err(Error::new(
                Code::Codegen,
                "eq_int builtin requires two arguments",
                Span::unknown(),
            ));
        }
        self.load_arg_into_reg(&args[0], "rax")?;
        self.load_arg_into_reg(&args[1], "rbx")?;
        writeln!(self.out, "    cmp rax, rbx")?;
        writeln!(self.out, "    je {}", true_label)?;
        Ok(())
    }

    fn emit_builtin_string_condition(
        &mut self,
        args: &[AirArg],
        true_label: &str,
        false_label: &str,
    ) -> Result<(), Error> {
        if args.len() < 2 {
            return Err(Error::new(
                Code::Codegen,
                "eq_str builtin requires two arguments",
                Span::unknown(),
            ));
        }

        self.load_arg_into_reg(&args[0], "rax")?;
        self.load_arg_into_reg(&args[1], "rbx")?;
        writeln!(
            self.out,
            "    mov r10, [rax] ; load first string data pointer"
        )?;
        writeln!(
            self.out,
            "    mov r11, [rbx] ; load second string data pointer"
        )?;
        writeln!(
            self.out,
            "    mov rcx, [rax+8] ; load first string byte length"
        )?;
        writeln!(
            self.out,
            "    cmp rcx, [rbx+8] ; compare string byte lengths"
        )?;
        writeln!(self.out, "    jne {} ; lengths differ", false_label)?;
        writeln!(self.out, "    test rcx, rcx ; empty strings match")?;
        writeln!(self.out, "    je {}", true_label)?;

        let loop_label = self.new_label("eqs_loop");
        writeln!(self.out, "{}:", loop_label)?;
        writeln!(self.out, "    mov al, byte [r10]")?;
        writeln!(self.out, "    mov dl, byte [r11]")?;
        writeln!(self.out, "    cmp al, dl")?;
        writeln!(self.out, "    jne {} ; bytes differ", false_label)?;
        writeln!(self.out, "    inc r10")?;
        writeln!(self.out, "    inc r11")?;
        writeln!(self.out, "    dec rcx")?;
        writeln!(self.out, "    jne {}", loop_label)?;
        writeln!(self.out, "    jmp {}", true_label)?;
        Ok(())
    }

    fn load_value_into_reg(&mut self, value: &AirValue, reg: &str) -> Result<(), Error> {
        match value {
            AirValue::Binding(name) => {
                let binding = self.frame.binding(name).cloned().ok_or_else(|| {
                    Error::new(
                        Code::Codegen,
                        format!("unknown binding '{}'", name),
                        Span::unknown(),
                    )
                })?;
                writeln!(
                    self.out,
                    "    mov {}, [rbp-{}] ; load operand",
                    reg,
                    binding.slot_addr(0)
                )?;
            }
            AirValue::Literal(value) => {
                writeln!(self.out, "    mov {}, {} ; operand literal", reg, value)?;
            }
        }
        Ok(())
    }

    fn load_arg_into_reg(&mut self, arg: &AirArg, reg: &str) -> Result<(), Error> {
        if let Some(literal) = &arg.literal {
            return match literal {
                Lit::Int(value) => self.load_value_into_reg(&AirValue::Literal(*value as i64), reg),
                Lit::Str(_) => self.load_literal_into_reg(literal, &arg.name, reg),
                Lit::F64(value) => {
                    let bits = value.to_bits();
                    writeln!(
                        self.out,
                        "    mov {reg}, {bits:#x} ; load literal float bits",
                        reg = reg,
                        bits = bits
                    )?;
                    Ok(())
                }
            };
        }
        if matches!(arg.kind, SigKind::F64) {
            return self.load_float_into_reg(arg, reg);
        }
        self.load_value_into_reg(&AirValue::Binding(arg.name.clone()), reg)
    }

    fn load_arg_word_into_reg(
        &mut self,
        arg: &AirArg,
        word: usize,
        reg: &str,
    ) -> Result<(), Error> {
        if word == 0 {
            return self.load_arg_into_reg(arg, reg);
        }
        if word != 1 || word_count_from_kind(&arg.kind) != 2 {
            return Err(Error::new(
                Code::Codegen,
                format!("invalid word {word} for argument '{}'", arg.name),
                Span::unknown(),
            ));
        }
        if let Some(Lit::Int(value)) = arg.literal {
            let high = if value < 0
                && matches!(
                    arg.kind,
                    SigKind::FixedInt(kind)
                        if kind.interpretation == FixedIntInterpretation::Signed
                ) {
                -1
            } else {
                0
            };
            return self.load_value_into_reg(&AirValue::Literal(high), reg);
        }
        let binding = self.frame.binding(&arg.name).cloned().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", arg.name),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    mov {}, [rbp-{}] ; load operand word",
            reg,
            binding.slot_addr(word)
        )?;
        Ok(())
    }

    fn load_float_into_reg(&mut self, arg: &AirArg, reg: &str) -> Result<(), Error> {
        if let Some(Lit::F64(value)) = &arg.literal {
            let bits = value.to_bits();
            writeln!(
                self.out,
                "    mov {reg}, {bits:#x} ; load literal float bits",
                reg = reg,
                bits = bits
            )?;
            return Ok(());
        }
        let binding = self.frame.binding(&arg.name).cloned().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", arg.name),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    movsd xmm0, [rbp-{}] ; load float operand",
            binding.slot_addr(0)
        )?;
        writeln!(self.out, "    movq {reg}, xmm0", reg = reg)?;
        Ok(())
    }

    fn load_literal_into_reg(
        &mut self,
        literal: &Lit,
        label: &str,
        reg: &str,
    ) -> Result<(), Error> {
        match literal {
            Lit::Int(value) => {
                writeln!(
                    self.out,
                    "    mov {}, {} ; load literal integer",
                    reg, value
                )?;
            }
            Lit::Str(_) => {
                writeln!(
                    self.out,
                    "    lea {}, [rel {}] ; point to string literal",
                    reg, label
                )?;
            }
            Lit::F64(_) => {
                return Err(Error::new(
                    Code::Codegen,
                    format!("unexpected float literal for register {}", reg),
                    Span::unknown(),
                ));
            }
        }
        Ok(())
    }

    fn load_arg_into_xmm(&mut self, arg: &AirArg, xmm: &str) -> Result<(), Error> {
        if let Some(literal) = &arg.literal {
            return match literal {
                Lit::Int(value) => {
                    writeln!(
                        self.out,
                        "    mov rax, {} ; load literal integer for float",
                        value
                    )?;
                    writeln!(
                        self.out,
                        "    cvtsi2sd {xmm}, rax ; convert literal to float",
                        xmm = xmm,
                    )?;
                    Ok(())
                }
                Lit::Str(_) => Err(Error::new(
                    Code::Codegen,
                    format!(
                        "cannot use string literal '{}' in float operation",
                        arg.name
                    ),
                    Span::unknown(),
                )),
                Lit::F64(value) => {
                    let bits = value.to_bits();
                    writeln!(
                        self.out,
                        "    mov rax, {bits:#x} ; load literal float bits",
                        bits = bits
                    )?;
                    writeln!(
                        self.out,
                        "    movq {xmm}, rax ; load float literal",
                        xmm = xmm
                    )?;
                    Ok(())
                }
            };
        }

        let binding = self.frame.binding(&arg.name).cloned().ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", arg.name),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    movsd {xmm}, [rbp-{}] ; load float operand",
            binding.slot_addr(0),
            xmm = xmm,
        )?;
        Ok(())
    }

    fn emit_return(&mut self, ret: &AirReturn) -> Result<(), Error> {
        if let Some(name) = &ret.value {
            let binding = self.frame.binding(name).cloned().ok_or_else(|| {
                Error::new(
                    Code::Codegen,
                    format!("unknown binding '{}'", name),
                    Span::unknown(),
                )
            })?;
            writeln!(
                self.out,
                "    mov rax, [rbp-{}] ; load return value",
                binding.slot_addr(0)
            )?;
        }
        writeln!(self.out, "    leave")?;
        writeln!(self.out, "    ret")?;
        writeln!(self.out)?;
        self.terminated = true;
        Ok(())
    }

    fn emit_new_closure(&mut self, c: &AirNewClosure) -> Result<(), Error> {
        let sig = &c.target;
        let args = &c.args;

        let kinds = &sig.param_kinds();
        let env_size = kinds.iter().map(word_count_from_kind).sum::<usize>() * WORD_SIZE;
        let heap_size = env_size + ENV_METADATA_SIZE;

        self.emit_mmap(heap_size)?;
        writeln!(self.out, "    mov rbx, rax ; closure env base pointer")?;

        let mut offset_words = 0usize;
        for (arg, kind) in args.iter().zip(kinds.iter()) {
            let kind_words = word_count_from_kind(kind);
            if kind_words == 0 {
                continue;
            }
            let offset_bytes = offset_words * WORD_SIZE;
            if matches!(*kind, SigKind::Sig(_)) {
                self.load_arg_into_reg(arg, "rax")?;
                writeln!(
                    self.out,
                    "    mov {}, rax ; shadow closure env_end pointer",
                    CLOSURE_ENV_REG
                )?;
                writeln!(self.out, "    push rbx ; save env base pointer")?;
                self.clone_closure_argument()?;
                writeln!(self.out, "    pop rbx ; restore env base pointer")?;
                writeln!(
                    self.out,
                    "    mov [rbx+{}], {} ; capture cloned closure pointer",
                    offset_bytes, CLOSURE_ENV_REG
                )?;
            } else {
                for word in 0..kind_words {
                    self.load_arg_word_into_reg(arg, word, "rax")?;
                    if kind_words == 1 {
                        writeln!(
                            self.out,
                            "    mov [rbx+{}], rax ; capture arg into env",
                            offset_bytes
                        )?;
                    } else {
                        writeln!(
                            self.out,
                            "    mov [rbx+{}], rax ; capture arg word into env",
                            offset_bytes + word * WORD_SIZE
                        )?;
                    }
                }
            }
            offset_words += kind_words;
        }

        writeln!(
            self.out,
            "    mov {}, rbx ; env_end pointer before metadata",
            CLOSURE_ENV_REG
        )?;
        if env_size > 0 {
            writeln!(
                self.out,
                "    add {}, {} ; move pointer past env payload",
                CLOSURE_ENV_REG, env_size
            )?;
        }

        writeln!(
            self.out,
            "    mov rax, {} ; store env size metadata",
            env_size
        )?;
        writeln!(
            self.out,
            "    mov qword [{}+{}], rax ; env size metadata",
            CLOSURE_ENV_REG, ENV_METADATA_ENV_SIZE_OFFSET
        )?;
        writeln!(
            self.out,
            "    mov rax, {} ; store heap size metadata",
            heap_size
        )?;
        writeln!(
            self.out,
            "    mov qword [{}+{}], rax ; heap size metadata",
            CLOSURE_ENV_REG, ENV_METADATA_HEAP_SIZE_OFFSET
        )?;

        let unwrapper = c.unwrapper_label();
        writeln!(
            self.out,
            "    lea rax, [{}] ; load unwrapper entry point",
            unwrapper
        )?;
        writeln!(
            self.out,
            "    mov qword [{}+{}], rax ; store unwrapper entry in metadata",
            CLOSURE_ENV_REG, ENV_METADATA_UNWRAPPER_OFFSET
        )?;

        let release_helper = c.deep_release_label();
        writeln!(
            self.out,
            "    lea rax, [{}] ; load release helper entry point",
            release_helper
        )?;
        writeln!(
            self.out,
            "    mov qword [{}+{}], rax ; store release pointer in metadata",
            CLOSURE_ENV_REG, ENV_METADATA_RELEASE_OFFSET
        )?;

        let deep_copy_helper = c.deepcopy_label();
        writeln!(
            self.out,
            "    lea rax, [{}] ; load deep copy helper entry point",
            deep_copy_helper
        )?;
        writeln!(
            self.out,
            "    mov qword [{}+{}], rax ; store deep copy pointer in metadata",
            CLOSURE_ENV_REG, ENV_METADATA_DEEP_COPY_OFFSET
        )?;

        let num_remaining = kinds
            .iter()
            .skip(args.len())
            .map(word_count_from_kind)
            .sum::<usize>();
        writeln!(
            self.out,
            "    mov qword [{}+{}], {} ; store num_remaining",
            CLOSURE_ENV_REG, ENV_METADATA_NUM_REMAINING_OFFSET, num_remaining
        )?;

        writeln!(
            self.out,
            "    mov rax, {} ; copy {} closure env_end to rax",
            CLOSURE_ENV_REG, c.name
        )?;

        Ok(())
    }

    fn store_binding_value(&mut self, name: &str) -> Result<(), Error> {
        let binding = self.frame.binding_mut(name).ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", name),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    mov [rbp-{}], rax ; store value",
            binding.slot_addr(0)
        )?;
        Ok(())
    }

    fn store_binding_word(&mut self, name: &str, word: usize, reg: &str) -> Result<(), Error> {
        let binding = self.frame.binding_mut(name).ok_or_else(|| {
            Error::new(
                Code::Codegen,
                format!("unknown binding '{}'", name),
                Span::unknown(),
            )
        })?;
        writeln!(
            self.out,
            "    mov [rbp-{}], {} ; store value word",
            binding.slot_addr(word),
            reg
        )?;
        Ok(())
    }

    fn emit_jump_args(&mut self, ja: &AirJumpArgs) -> Result<(), Error> {
        let sig = &ja.target;
        let args = &ja.args;
        self.prepare_args(args)?;
        let arg_split = self.move_args_to_registers(&sig.param_kinds())?;
        let spilled_bytes = arg_split.stack_bytes;
        if spilled_bytes > 0 {
            writeln!(self.out, "    sub rsp, 8 ; allocate slot for saved rbp")?;
            writeln!(self.out, "    mov rax, [rbp] ; capture parent rbp")?;
            writeln!(self.out, "    mov [rsp], rax ; stash parent rbp for leave")?;
            writeln!(self.out, "    mov rbp, rsp ; treat slot as current rbp")?;
        }
        writeln!(self.out, "    leave ; unwind before named jump")?;
        writeln!(self.out, "    jmp {}", &sig.name)?;
        self.terminated = true;
        Ok(())
    }

    fn emit_libc_call(
        &mut self,
        builtin: builtins::Builtin,
        args: &[AirArg],
        arg_kinds: &[SigKind],
    ) -> Result<bool, Error> {
        match builtin {
            builtins::Builtin::Sprintf => {
                if args.is_empty() {
                    return Err(Error::new(
                        Code::Codegen,
                        "sprintf requires a format string before the continuation",
                        Span::unknown(),
                    ));
                }

                self.prepare_libc_args(args, arg_kinds)?;

                self.emit_mmap(FMT_BUFFER_SIZE + STRING_DESCRIPTOR_SIZE)?;
                writeln!(self.out, "    mov rbx, rax ; keep sprintf buffer pointer")?;
                writeln!(
                    self.out,
                    "    lea r15, [rbx+{}] ; descriptor after sprintf buffer",
                    FMT_BUFFER_SIZE
                )?;
                let arg_split = self.move_args_to_registers(arg_kinds)?;
                if arg_split.reg_slots == ARG_REGS.len() {
                    return Err(Error::new(
                        Code::Codegen,
                        "sprintf requires at least one register slot for the buffer pointer",
                        Span::unknown(),
                    ));
                }
                for i in (0..arg_split.reg_slots).rev() {
                    let dest = ARG_REGS[i + 1];
                    let src = ARG_REGS[i];
                    writeln!(
                        self.out,
                        "    mov {}, {} ; shift sprintf args for buffer insertion",
                        dest, src
                    )?;
                }

                writeln!(
                    self.out,
                    "    mov rdi, rbx ; destination buffer for sprintf"
                )?;
                writeln!(
                    self.out,
                    "    xor eax, eax ; no vector arguments for variadic sprintf"
                )?;
                self.emit_variadic_libc_call(builtin.name())?;
                writeln!(
                    self.out,
                    "    mov [r15], rbx ; store formatted data pointer"
                )?;
                writeln!(
                    self.out,
                    "    mov [r15+8], rax ; store formatted byte length"
                )?;
                writeln!(
                    self.out,
                    "    mov rax, r15 ; return formatted string descriptor"
                )?;
                self.cleanup_libc_stack(arg_split.stack_bytes)?;

                Ok(true)
            }
            builtins::Builtin::Write => {
                if args.is_empty() {
                    return Err(Error::new(
                        Code::Codegen,
                        "write requires a buffer before the continuation",
                        Span::unknown(),
                    ));
                }

                self.prepare_args(args)?;
                let arg_split = self.move_args_to_registers(arg_kinds)?;

                writeln!(self.out, "    mov rsi, [rdi] ; string data pointer")?;
                writeln!(self.out, "    mov rdx, [rdi+8] ; string byte length")?;
                writeln!(self.out, "    mov rdi, 1 ; stdout fd")?;

                writeln!(self.out, "    call write ; invoke libc write")?;
                self.cleanup_libc_stack(arg_split.stack_bytes)?;

                Ok(false)
            }
            _ => Err(Error::new(
                Code::Codegen,
                format!("unsupported libc call '{}'", builtin.name()),
                Span::unknown(),
            )),
        }
    }

    fn cleanup_libc_stack(&mut self, stack_bytes: usize) -> Result<(), Error> {
        if stack_bytes > 0 {
            writeln!(
                self.out,
                "    add rsp, {} ; pop stack args after libc call",
                stack_bytes
            )?;
        }
        Ok(())
    }

    fn emit_variadic_libc_call(&mut self, name: &str) -> Result<(), Error> {
        writeln!(self.out, "    push rbp ; helper prologue")?;
        writeln!(self.out, "    mov rbp, rsp")?;
        writeln!(self.out, "    push r12")?;
        writeln!(
            self.out,
            "    mov rax, rsp ; align stack for variadic {name} call"
        )?;
        writeln!(self.out, "    and rax, 15")?;
        writeln!(self.out, "    mov r12, rax")?;
        writeln!(self.out, "    sub rsp, r12")?;
        writeln!(self.out, "    call {} ; invoke libc {name}", name)?;
        writeln!(self.out, "    add rsp, r12")?;
        writeln!(self.out, "    pop r12")?;
        writeln!(self.out, "    pop rbp")?;
        Ok(())
    }

    fn emit_mmap(&mut self, size: usize) -> Result<(), Error> {
        writeln!(self.out, "    mov rax, {} ; mmap syscall", SYSCALL_MMAP)?;
        writeln!(
            self.out,
            "    xor rdi, rdi ; addr hint for kernel base selection"
        )?;
        writeln!(
            self.out,
            "    mov rsi, {} ; length for allocation",
            size.max(1)
        )?;
        writeln!(
            self.out,
            "    mov rdx, {} ; prot = read/write",
            PROT_READ | PROT_WRITE
        )?;
        writeln!(
            self.out,
            "    mov r10, {} ; flags: private & anonymous",
            MAP_PRIVATE | MAP_ANONYMOUS
        )?;
        writeln!(self.out, "    mov r8, -1 ; fd = -1")?;
        writeln!(self.out, "    xor r9, r9 ; offset = 0")?;
        writeln!(self.out, "    syscall ; allocate env pages")?;
        Ok(())
    }

    fn prepare_args(&mut self, args: &[AirArg]) -> Result<(), Error> {
        for arg in args.iter().rev() {
            let word_count = word_count_from_kind(&arg.kind);
            for word in (0..word_count).rev() {
                self.load_arg_word_into_reg(arg, word, "rax")?;
                if word_count == 1 {
                    writeln!(self.out, "    push rax ; stack arg")?;
                } else {
                    writeln!(self.out, "    push rax ; stack arg word")?;
                }
            }
        }
        Ok(())
    }

    fn prepare_libc_args(&mut self, args: &[AirArg], arg_kinds: &[SigKind]) -> Result<(), Error> {
        for (arg, kind) in args.iter().zip(arg_kinds).rev() {
            let word_count = word_count_from_kind(kind);
            for word in (0..word_count).rev() {
                self.load_arg_word_into_reg(arg, word, "rax")?;
                if word == 0 && is_string_arg(arg, kind) {
                    writeln!(
                        self.out,
                        "    mov rax, [rax] ; string data pointer for libc"
                    )?;
                }
                if word_count == 1 {
                    writeln!(self.out, "    push rax ; stack arg")?;
                } else {
                    writeln!(self.out, "    push rax ; stack arg word")?;
                }
            }
        }
        Ok(())
    }

    fn move_args_to_registers(&mut self, params: &[SigKind]) -> Result<ArgSplit, Error> {
        let mut slot = 0usize;
        let mut spilled = false;
        let mut stack_bytes = 0usize;
        for kind in params {
            let word_count = word_count_from_kind(kind);
            for _ in 0..word_count {
                if !spilled && slot < ARG_REGS.len() {
                    let reg = ARG_REGS[slot];
                    if word_count == 1 {
                        writeln!(self.out, "    pop {} ; restore arg into register", reg)?;
                    } else {
                        writeln!(self.out, "    pop {} ; restore arg word into register", reg)?;
                    }
                    slot += 1;
                } else {
                    spilled = true;
                    stack_bytes += WORD_SIZE;
                }
            }
        }
        Ok(ArgSplit {
            reg_slots: slot,
            stack_bytes,
        })
    }

    fn emit_clone_env_from_env_end(
        &mut self,
        src_env_end_reg: &str,
        dst_env_end_reg: &str,
    ) -> Result<(), Error> {
        writeln!(
            self.out,
            "    mov rbx, {} ; clone source env_end pointer",
            src_env_end_reg
        )?;
        writeln!(
            self.out,
            "    mov r13, [rbx+{}] ; load env size metadata for clone",
            ENV_METADATA_ENV_SIZE_OFFSET
        )?;
        writeln!(
            self.out,
            "    mov r14, [rbx+{}] ; load heap size metadata for clone",
            ENV_METADATA_HEAP_SIZE_OFFSET
        )?;
        writeln!(
            self.out,
            "    mov r12, rbx ; compute env base pointer for clone"
        )?;
        writeln!(
            self.out,
            "    sub r12, r13 ; env base pointer for clone source"
        )?;
        writeln!(self.out, "    mov rax, {} ; mmap syscall", SYSCALL_MMAP)?;
        writeln!(
            self.out,
            "    xor rdi, rdi ; addr hint for kernel base selection"
        )?;
        writeln!(self.out, "    mov rsi, r14 ; length for cloned environment")?;
        writeln!(
            self.out,
            "    mov rdx, {} ; prot = read/write",
            PROT_READ | PROT_WRITE
        )?;
        writeln!(
            self.out,
            "    mov r10, {} ; flags: private & anonymous",
            MAP_PRIVATE | MAP_ANONYMOUS
        )?;
        writeln!(self.out, "    mov r8, -1 ; fd = -1")?;
        writeln!(self.out, "    xor r9, r9 ; offset = 0")?;
        writeln!(self.out, "    syscall ; allocate cloned env pages")?;
        writeln!(
            self.out,
            "    mov r15, rax ; cloned closure env base pointer"
        )?;
        writeln!(
            self.out,
            "    mov rsi, r12 ; source env base for clone copy"
        )?;
        writeln!(
            self.out,
            "    mov rdi, r15 ; destination env base for clone copy"
        )?;
        writeln!(self.out, "    mov rcx, r14 ; bytes to copy for cloned env")?;
        writeln!(self.out, "    cld ; ensure forward copy for env clone")?;
        writeln!(self.out, "    rep movsb ; duplicate closure env data")?;
        writeln!(self.out, "    mov rbx, r15 ; start from cloned env base")?;
        writeln!(
            self.out,
            "    add rbx, r13 ; compute cloned env_end pointer"
        )?;
        writeln!(
            self.out,
            "    mov {}, rbx ; cloned env_end pointer",
            dst_env_end_reg
        )?;
        writeln!(
            self.out,
            "    mov rax, [{}+{}] ; load deepcopy helper entry point",
            dst_env_end_reg, ENV_METADATA_DEEP_COPY_OFFSET
        )?;
        writeln!(
            self.out,
            "    push {} ; preserve cloned env_end pointer",
            dst_env_end_reg
        )?;
        writeln!(
            self.out,
            "    mov rdi, {} ; pass env_end pointer to deepcopy helper",
            dst_env_end_reg
        )?;
        writeln!(self.out, "    call rax ; deepcopy reference fields")?;
        writeln!(
            self.out,
            "    pop {} ; restore cloned env_end pointer",
            dst_env_end_reg
        )?;
        Ok(())
    }

    fn clone_closure_argument(&mut self) -> Result<(), Error> {
        self.emit_clone_env_from_env_end(CLOSURE_ENV_REG, CLOSURE_ENV_REG)?;
        writeln!(
            self.out,
            "    mov rax, {} ; copy closure env_end to rax",
            CLOSURE_ENV_REG
        )?;
        Ok(())
    }

    fn new_label(&mut self, suffix: &str) -> String {
        let idx = self.label_counter;
        self.label_counter += 1;
        format!(
            "{}_{}_{}",
            crate::sanitize_function_name(&self.air.sig.name),
            suffix,
            idx
        )
    }
}

fn align_to(value: usize, align: usize) -> usize {
    if value == 0 {
        return 0;
    }
    value.div_ceil(align) * align
}

fn is_string_arg(arg: &AirArg, kind: &SigKind) -> bool {
    matches!(kind, SigKind::Str) || matches!(arg.literal, Some(Lit::Str(_)))
}

fn word_count_from_kind(kind: &SigKind) -> usize {
    match kind {
        SigKind::FixedInt(kind) if kind.bit_width == 128 => 2,
        _ => 1,
    }
}
