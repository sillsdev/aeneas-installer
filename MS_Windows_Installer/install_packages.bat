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
  set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;%PATH%
  (call )
  GOTO ENDIF
:WIN64PATH
  set PATH=C:\Program Files (x86)\Python38\;C:\Program Files (x86)\Python38\Scripts;C:\Program Files (x86)\eSpeak NG;C:\Program Files (x86)\FFmpeg\bin;%PATH%
  (call )
:ENDIF

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

echo Copying espeak-ng.exe to espeak.exe
copy /b/v/y "%PF32%\eSpeak NG\espeak-ng.exe" "%PF32%\eSpeak NG\espeak.exe"
echo Copying espeak-ng.lib to %PF32%\Python38\libs\
copy /b/v/y "espeak-ng.lib" "%PF32%\Python38\libs\"

python -m ensurepip
python -m pip install -U pip-20.1.1-py2.py3-none-any.whl
python -m pip install -U numpy-1.19.1-cp38-cp38-win32.whl
python -m pip install -U lxml-4.5.2-cp38-cp38-win32.whl
python -m pip install -U soupsieve-2.0.1-py3-none-any.whl
python -m pip install -U beautifulsoup4-4.9.1-py3-none-any.whl
python -m pip install -U aeneas-1.7.3.0-cp38-cp38-win32.whl

echo Copying libespeak-ng.dll to %PF32%\Python38\Lib\site-packages\aeneas\cew
copy /b/v/y "%PF32%\eSpeak NG\libespeak-ng.dll" "%PF32%\Python38\Lib\site-packages\aeneas\cew"
