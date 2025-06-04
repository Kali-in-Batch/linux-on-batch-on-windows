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