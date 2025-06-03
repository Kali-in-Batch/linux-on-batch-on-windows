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

set syscall=number
set text=hi
rem Check if the file exists
if not exist %1 (
    echo File %1 does not exist
    exit /b 1
) else (
    goto execute
)

:syscall_0

set /p "msg=!text!"

rem Go back to caller
goto :eof

:syscall_1

echo !text!
rem Go back to caller
goto :eof

:syscall_60

exit

:syscall_201
for /f %%t in ('powershell -nologo -command "[int][double]::Parse((Get-Date -UFormat %%s))"') do (
    set time=%%t
)
echo !time!
rem Go back to caller
goto :eof

:execute

rem Load each line of the file into a variable
for /f "tokens=*" %%a in (%1) do (
    rem Check if it has a semicolon
    for /f "tokens=* delims=;" %%b in ("%%a") do (
        rem Remove everything after the semicolon
        set "%%a=%%b"
        rem Remove the semicolon
        set "%%a=%%a:;= "
    )
    rem Check for mov
    for /f "tokens=1* delims= " %%b in ("%%a") do (
        if "%%b" == "mov" (
            if "%%c"=="LOAD, KERNEL.SYSCALLS.JSON" (
                rem Read and parse the JSON file using powershell and store each thing a syscall equals in a variable
                for /f "tokens=1,* delims=:" %%s in ('powershell -Command "Get-Content %~dp0\KERNEL.SYSCALLS.JSON | ConvertFrom-Json | ForEach-Object { $_.PSObject.Properties | ForEach-Object { $_.Name + ':' + $_.Value } }"') do (
                    set "syscall_%%s=%%t"
                )
            )
            for /f "tokens=1* delims=," %%d in ("%%c") do (
                for /f "tokens=* delims= " %%x in ("%%e") do (
                    if "%%d" == "rax" (
                        set syscall=%%x
                    ) else if "%%d" == "rsi" (
                        set "text=%%x"
                    )
                )
            )
        ) else (
            if "%%a" == "int 0x80" (
                if "!syscall_1!" == "" (
                    echo YOU DIDN'T LOAD ANY SYSCALLS WHAT ARE YOU DOING
                    exit /b
                ) else (
                    rem Check if !syscall! is number
                    if "!syscall!" == "number" (
                        rem Nothing to do, this is a placeholder value
                    ) else (
                        call :syscall_!syscall!
                    )
                )
            )
        )
    )
)
rem This part running means there was no exit syscall.
echo Segmentation fault ^(core dumped^)
exit /b 1