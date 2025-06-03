section .data
    msg db "Hello, world!", 0x0A
    msg2 db "Goodbye, world!", 0x0A
    msg3 db "Really long long long long long long long word", 0x0A
    really_long_long_long_label db "Really long long long long long long long word but with a really long label", 0x0A

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg2
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, really_long_long_long_label
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

