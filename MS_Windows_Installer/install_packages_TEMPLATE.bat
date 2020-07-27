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
  set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;%PATH%
  (call )
:ENDIF

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

echo Copying espeak-ng.exe to espeak.exe
copy /b/v/y "%PF64%"\eSpeak-ng\espeak-ng.exe "%PF64%"\eSpeak-ng\espeak.exe
echo Copying espeak-ng.dll to C:\Windows\System32\
copy /b/v/y "%PF64%"\eSpeak-ng\espeak-ng.dll C:\Windows\System32\espeak-ng.dll
echo Copying espeak-ng.lib to %PF64%"\Python38\libs\
copy /b/v/y espeak-ng.lib %PF64%"\Python38\libs\

python -m ensurepip
python -m pip install -U [PIP_FILE]
python -m pip install -U [NUMPY_FILE]
python -m pip install -U [LXML_FILE]
python -m pip install -U [SOUPSIEVE_FILE]
python -m pip install -U [BS4_FILE]
python -m pip install -U [AENEAS_FILE]

