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

    call "%temp%\getadmin.vbs"
    exit /B

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
echo Copying espeak.lib to C:\Python\libs\
copy /b/v/y espeak.lib C:\Python27\libs\

C:\Python27\python -m ensurepip
C:\Python27\python -m pip install -U pip-8.1.2-py2.py3-none-any.whl
C:\Python27\python -m pip install -U beautifulsoup4-4.4.1-py2-none-any.whl
C:\Python27\python -m pip install -U lxml-3.6.0-cp27-none-win32.whl
C:\Python27\python -m pip install -U numpy-1.10.1-cp27-cp27m-win32.whl
C:\Python27\python -m pip uninstall -y aeneas
C:\Python27\python -m pip install aeneas-1.5.1.0-cp27-cp27m-win32.whl

