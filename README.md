# Linux on Batch on Windows

Basic Linux emulator written in batch. Currently doesn't have a lot of syscalls and may be buggy.

*Note: This is alpha-quality software. I do **NOT** recommend using this for testing Linux ports of programs written in NASM unless they're VERY basic, like hello world programs. If you just want to experiment, do whatever you want. If you work at a company and see someone using this software for production, tell your boss immediately.*

## Usage

```batch
.\emulator.bat foo.asm
```

Nasm-style assembly will work best.

Whitespace after instructions may break the emulator.
Inline comments are not supported. They must be on their own line.
Jumping to labels is not supported.

Example of functioning code:
```assembly
section .data
    msg db "Hello, world!", 0x0A
    msg_len equ $ - msg
    msg2 db "Goodbye, world!", 0x0A
    msg2_len equ $ - msg2

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    mov rdx, msg2_len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```
You may also try the [hello-world.asm](./src/hello-world.asm) file:
```batch
.\emulator.bat hello-world.asm
```

## Downloads

For the latest features and updates, check out our [nightly builds!](https://github.com/benja2998/linux-on-batch-on-windows/releases/)

For the most stable features and updates, check out the [latest release!](https://github.com/benja2998/linux-on-batch-on-windows/releases/latest)