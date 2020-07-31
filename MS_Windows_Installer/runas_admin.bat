@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

IF "%~1"=="" (
  echo "USAGE: runas_admin script_name"
  exit /B 1
)
echo copy "%~s1" "%temp%\%~snx1"
copy /b/v/y "%~s1" "%temp%\%~snx1"

:--------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%temp%\%~snx1", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    call "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

call "%temp%\%~snx1"
