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
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

echo Copying espeak.dll to C:\Windows\System32\
copy /b/v/y "%PF32%\eSpeak\espeak_sapi.dll" C:\Windows\System32\espeak.dll
echo Copying espeak.lib to C:\Python37-32\libs\
copy /b/v/y espeak.lib C:\Python37-32\libs\

C:\Python37-32\python -m ensurepip
C:\Python37-32\python -m pip install -U pip-19.2.3-py2.py3-none-any.whl
C:\Python37-32\python -m pip install -U numpy-1.17.1-cp37-cp37m-win32.whl
C:\Python37-32\python -m pip install -U lxml-4.4.1-cp37-cp37m-win32.whl
C:\Python37-32\python -m pip install -U soupsieve-1.9.3-py2.py3-none-any.whl
C:\Python37-32\python -m pip install -U beautifulsoup4-4.8.0-py3-none-any.whl
C:\Python37-32\python -m pip install -U aeneas-1.7.3.0-cp37-cp37m-win32.whl

