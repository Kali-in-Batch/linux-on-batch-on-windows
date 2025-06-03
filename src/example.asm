; Example assembly code for emulator.bat.
; INLINE COMMENTS ARE NOT SUPPORTED.

; Load syscalls from the kernel.
mov LOAD, KERNEL.SYSCALLS.JSON

; Perform a sys_write syscall.
mov rsi, The following number of seconds have passed since the unix epoch:
mov rax, 1
; Do the sys_write syscall.
int 0x80
; Perform a sys_time syscall.
mov rax, 201
; Do the sys_time syscall.
int 0x80
; Perform a sys_read syscall.
mov rax, 0
mov rsi, Enter text: 
; Do the sys_read syscall.
int 0x80
; Perform a sys_write syscall.
mov rsi, You typed: !msg!
mov rax, 1
; Do the sys_write syscall.
int 0x80
; exit
mov rax, 60
int 0x80