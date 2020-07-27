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

set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;%PATH%

set PF64=C:\Program Files

echo Copying espeak-ng.exe to espeak.exe
copy /b/v/y "%PF64%\eSpeak NG\espeak-ng.exe" "%PF64%\eSpeak NG\espeak.exe"
echo Copying libespeak-ng.dll to %PF64%\Python38\Lib\site-packages\aeneas\cew
copy /b/v/y "%PF64%\eSpeak NG\libespeak-ng.dll" "%PF64%\Python38\Lib\site-packages\aeneas\cew"
echo Copying libespeak-ng.lib to "%PF64%\Python38\libs\"
copy /b/v/y "espeak-ng.lib" "%PF64%\Python38\libs\"

python -m ensurepip
python -m pip install -U pip-20.1.1-py2.py3-none-any.whl
python -m pip install -U numpy-1.19.1-cp38-cp38-win_amd64.whl
python -m pip install -U lxml-4.5.2-cp38-cp38-win_amd64.whl
python -m pip install -U soupsieve-2.0.1-py3-none-any.whl
python -m pip install -U beautifulsoup4-4.9.1-py3-none-any.whl
python -m pip install -U aeneas-1.7.3.0-cp38-cp38-win_amd64.whl

