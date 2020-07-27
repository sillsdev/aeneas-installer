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
echo Copying libespeak-ng.dll to %PF32%\Python38\Lib\site-packages\aeneas\cew
copy /b/v/y "%PF32%\eSpeak NG\libespeak-ng.dll" "%PF32%\Python38\Lib\site-packages\aeneas\cew"
echo Copying espeak-ng.lib to %PF32%\Python38\libs\
copy /b/v/y "espeak-ng.lib" "%PF32%\Python38\libs\"


