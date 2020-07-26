@echo off

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
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

REM    call "%temp%\getadmin.vbs"
REM    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

echo Copying espeak-ng.dll to C:\Windows\System32\
copy /b/v/y "%PF64%\eSpeak-ng\espeak-ng.dll" C:\Windows\System32\espeak-ng.dll
echo Copying espeak-ng.lib to C:\Python38\libs\
copy /b/v/y espeak-ng.lib C:\Python38\libs\

C:\Python38\python -m ensurepip
C:\Python38\python -m pip install -U [PIP_FILE]
C:\Python38\python -m pip install -U [NUMPY_FILE]
C:\Python38\python -m pip install -U [LXML_FILE]
C:\Python38\python -m pip install -U [SOUPSIEVE_FILE]
C:\Python38\python -m pip install -U [BS4_FILE]
C:\Python38\python -m pip install -U [AENEAS_FILE]

