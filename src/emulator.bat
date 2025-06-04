@echo off
setlocal enabledelayedexpansion

rem Copyright (c) 2025 benja2998
rem License: MIT
rem This is a very basic batch script that can run ASM files with Linux syscalls.
rem Part of the Linux on Batch on Windows project.

goto check_args

:check_args
if "%1"=="" (
    set "full_path=%~f0"
    rem Only get the name and extension
    for %%F in ("!full_path!") do set "filename=%%~nxF"
    echo Usage: .\!filename! ^<file^>
    exit /b 1
) else (
    goto start
)

:start
set "function_call=number"
set "text=hi"
set "file_descriptor=1"
set "third_arg=0"
set "len=0"

rem Check if the file exists
if not exist %1 (
    echo File %1 does not exist
    exit /b 1
) else (
    goto execute
)

:syscall_0
rem sys_read (file descriptor, buffer, count)
rem Error if file descriptor is not 0

if "!file_descriptor!" == "0" (
    rem stdin
    set /p stdin=
    rem Get the length of !stdin!
    for /f %%L in ('powershell -Command "('!stdin!').Length"') do set "lenstdin=%%L"
    rem Save it to the buffer given
    for /f "tokens=1" %%t in ("!textValue!") do (
        rem If !lenstdin! is greater than !pointer_%%t!, cause a segfault
        if "!lenstdin!" GTR "!pointer_%%t!" (
            rem Buffer overflow
            echo Segmentation fault ^(core dumped^)
            exit 1
        )
        set "pointer_%%t=!stdin!"
    )
) else (
    echo invalid file descriptor
)

goto :eof

:syscall_1
rem sys_write

for /f "delims=" %%A in ('powershell -Command "$t='!text!'; $t.Substring(0, [Math]::Min($t.Length, !third_arg!))"') do (
    set "truncated=%%A"
)
rem Error if file descriptor is not 1
if "!file_descriptor!" == "1" (
    echo !truncated!
) else (
    echo invalid file descriptor
)
goto :eof

:syscall_39
rem sys_getpid
powershell -nologo -command "Write-Host $PID"
goto :eof

:syscall_60
rem sys_exit
exit !file_descriptor!

:syscall_201
rem sys_time
for /f %%t in ('powershell -nologo -command "[int][double]::Parse((Get-Date -UFormat %%s))"') do (
    set time=%%t
)
echo !time!
goto :eof

:execute
rem Load each line of the file into a variable
for /f "tokens=*" %%a in (%1) do (
    rem Remove comments and semicolons
    for /f "tokens=* delims=;" %%b in ("%%a") do (
        set "line=%%b"
        set "line=!line:;=!"
        
        rem Check for mov instruction
        for /f "tokens=1* delims= " %%b in ("!line!") do (
            set "opcode=%%b"
            set "operands=%%c"

            if "!opcode!" == "mov" (
                for /f "tokens=1* delims=," %%d in ("!operands!") do (
                    for /f "tokens=* delims= " %%x in ("%%e") do (
                        if "%%d" == "rax" (
                            set function_call=%%x
                        ) else if "%%d" == "rsi" (
                            set "text=!pointer_%%x!"
                            set "textValue=%%x"
                        ) else if "%%d" == "rdi" (
                            set "file_descriptor=%%x"
                        ) else if "%%d" == "rdx" (
                            set "third_arg=!pointer_%%x!"
                            rem Check if rdx is a number
                            for /f %%A in ('powershell -Command "if ([double]::TryParse('%%x', [ref]0)) { 1 } else { 0 }"') do (
                                if "%%A" == "1" (
                                    set "third_arg=%%x"
                                )
                            )
                        )
                    )
                )
            ) else (
                if "!line!" == "syscall" (
                    if "!function_call!" == "number" (
                        rem Placeholder
                    ) else (
                        call :syscall_!function_call!
                    )
                ) else (
                    rem For msg db "Hello, world!", 0x0A and similar
                    for /f "tokens=3,*" %%t in ("!line!") do (
                        set "pointer=%%t %%u"
                    )
                    for /f "tokens=1,2" %%t in ("!line!") do (
                        set "first_word=%%t"
                        set "second_word=%%u"
                    )
                    if "!second_word!" == "db" (
                        for /f "tokens=*" %%t in ("!first_word!") do (
                            set "pointer_%%t=!pointer!"
                            rem Remove , 0x0A from the pointer
                            set "pointer_%%t=!pointer_%%t:, 0x0A=!"
                            rem Remove surrounding quotes
                            set "pointer_%%t=!pointer_%%t:"=!"
                        )
                    ) else if "!second_word!" == "equ" (
                        rem Something like len equ $ - msg
                        for /f "tokens=3,*" %%t in ("!pointer!") do (
                            set "pointer2=%%t"
                            if "!pointer!" == "$ - !pointer2!" (
                                rem Get the length of !pointer_%%t!
                                for /f %%L in ('powershell -Command "('!pointer_%%t!').Length"') do set "len_%%t=%%L"
                            )
                            for /f "tokens=*" %%u in ("!first_word!") do (
                                set "pointer_%%u=!len_%%t!"
                            )
                        )
                        rem Or if it's something like len equ 123
                        for /f "tokens=1" %%t in ("!pointer!") do (
                            for /f %%A in ('powershell -Command "if ([double]::TryParse('!pointer!', [ref]0)) { 1 } else { 0 }"') do (
                                if %%A==1 (
                                    for /f "tokens=*" %%u in ("!first_word!") do (
                                        set "pointer_%%u=%%t"
                                    )
                                )
                            )
                        )
                    ) else if "!second_word!" == "resb" (
                        rem Something like buffer resb 100
                        for /f "tokens=1" %%t in ("!first_word!") do (
                            rem Probably the most straight forward one to implement...
                            set "pointer_%%t=!pointer!"
                        )
                    )
                )
            )
        )
    )
)

rem This part running means there was no exit syscall, so we should do a segfault
echo Segmentation fault
exit 1
