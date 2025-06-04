section .bss
    input_buff resb 64

section .data
    msg db "Hello, world!", 0x0A
    msg_len equ $ - msg
    msg2 db "Goodbye, world!", 0x0A
    msg2_len equ $ - msg2
    msg3 db "Enter a string that will be echoed back to you", 0x0A
    msg3_len equ $ - msg3

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

    mov rax, 1
    mov rdi, 1
    mov rsi, msg3
    mov rdx, msg3_len
    syscall

    ; Now, we read from stdin
    mov rax, 0
    mov rdi, 0
    mov rsi, input_buff
    mov rdx, 64
    syscall

    ; Write the input_buff to stdout
    mov rax, 1
    mov rdi, 1
    mov rsi, input_buff
    syscall


    mov rax, 60
    mov rdi, 0
    syscall