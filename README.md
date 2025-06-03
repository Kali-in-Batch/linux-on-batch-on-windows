# Linux on Batch on Windows

Basic Linux emulator written in batch. Currently doesn't have a lot of syscalls and may be buggy.

Usage:

```batch
.\emulator.bat foo.asm
```

Nasm-style assembly will work best. Do not do inline comments:
```assembly
mov rax, 1 ; Inline comment
```
Whitespace after instructions may also break the emulator.
Jumping to labels is not supported.

Example of functioning code:
```assembly
section .data
    msg db "Hello, world!", 0x0A
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
```
You may also try the [hello-world.asm](./src/hello-world.asm) file:
```batch
.\emulator.bat hello-world.asm
```