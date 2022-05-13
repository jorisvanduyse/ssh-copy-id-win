@echo off


:: BatchGotAdmin Found on stack overflow posted by Ben Gripka and edited by dbenham
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

:: Run the powershell script //TODO Doesn't work yet (always success)
@REM COLOR 02
powershell "./KeySSHCopy.ps1"
@REM if errorlevel 1 (
@REM     COLOR 40
@REM     ECHO ================================+++ FAILED +++================================
@REM     ECHO Script FAILED your SSH public key was NOT added to the server authorized_keys!
@REM )
@REM else errorlevel 0 (
@REM     COLOR 20
@REM     ECHO ===============================+++ SUCCESS +++==============================
@REM     ECHO Script completed your SSH public key was added to the server authorized_keys
@REM )
pause

