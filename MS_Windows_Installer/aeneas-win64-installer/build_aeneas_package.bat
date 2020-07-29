@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT
IF /i {%2}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions

set CURDIR=%~dp0
cd %CURDIR%
echo Running %~n0 from %CURDIR%

IF EXIST "C:\Program Files (x86)" GOTO WIN64PF
  set PF32=C:\Program Files
  GOTO PFENDIF
:WIN64PF
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
:PFENDIF

IF EXIST "C:\Program Files (x86)\7-Zip" GOTO WIN64SEVEN
  set PFSZ=C:\Program Files
  GOTO SEVENENDIF
:WIN64SEVEN
  set PFSZ=C:\Program Files (x86)
:SEVENENDIF

IF EXIST "%PF32%\Inno Setup 6" GOTO INNOSIX
  set INNOPATH=%PF32%\Inno Setup 5
  GOTO INNOENDIF
:INNOSIX
  set INNOPATH=%PF32%\Inno Setup 6
:INNOENDIF

set PATH=%PATH%;%INNOPATH%;%PFSZ%\7-Zip;%PF64%\FFmpeg\bin;%PF64%\eSpeak NG;%PF64%\Python38;%PF64%\Python38\Scripts;%PF64%\Git;%PF64%\Git\usr\bin;%PF64%\Git\mingw64\bin

curl.exe --version 1>nul 2>nul
if %ERRORLEVEL%==1 (
  set CURL=call curl-psh.bat -L
) else (
  set CURL=curl.exe -L
)

mkdir python-wheels 1>nul 2>nul

rmdir /q/s %USERPROFILE%\AppData\Roaming\Python\Python38\site-packages
set PATH=%USERPROFILE%\AppData\Roaming\Python\Python38\Scripts;%PATH%
python.exe -m ensurepip
python -m pip install -U pip setuptools wheel

DEL /Q *.whl 1>nul 2>nul
DEL /Q python-wheels\*.whl 1>nul 2>nul

python -m pip install -U numpy
python -m pip install -U lxml beautifulsoup4 soupsieve

REM python -m pip wheel pip
python -m pip wheel numpy
python -m pip wheel lxml beautifulsoup4 soupsieve

python -m pip download aeneas==1.7.3.0 --no-cache-dir

IF EXIST "%cd%\aeneas-1.7.3.0.tar.gz" GOTO ENDGET
  echo Downloading aeneas...
  %CURL% https://github.com/readbeyond/aeneas/archive/v1.7.3.tar.gz -o aeneas-1.7.3.0.tar.gz
  IF %ERRORLEVEL%==0 GOTO ENDIF
    echo Could not download aeneas...
    START https://github.com/readbeyond/aeneas/archive
  :ENDIF
:ENDGET

RMDIR /S /Q aeneas-1.7.3.0
"7z.exe" e aeneas-1.7.3.0.tar.gz -aoa
"7z.exe" x aeneas-1.7.3.0.tar -aoa

IF EXIST "%cd%\aeneas-1.7.3" (
  move /y aeneas-1.7.3 aeneas-1.7.3.0
)

cd aeneas-1.7.3.0
echo "Checking for patch.exe"
2>nul patch.exe --version
if %ERRORLEVEL%==1 (
  python -m pip install -U patch
  python.exe -m patch -v -p 1 --debug ..\aeneas-patches\patch-espeak-ng.diff
  python.exe -m patch -v -p 1 --debug ..\aeneas-patches\patch-py38-utf8.diff
) ELSE (
  patch.exe -p1 < ..\aeneas-patches\patch-espeak-ng.diff
  patch.exe -p1 < ..\aeneas-patches\patch-py38-utf8.diff
)
move /y aeneas\cew\speak_lib.h thirdparty\speak_lib.h
copy /b/v/y ..\libespeak-ng-dll2lib-x64\libespeak-ng.lib thirdparty\libespeak-ng-x64.lib
copy /b/v/y ..\libespeak-ng-dll2lib-x86\libespeak-ng.lib thirdparty\libespeak-ng-x86.lib
set AENEAS_USE_ESPEAKNG=True
python.exe setup.py build_ext --inplace
python.exe setup.py bdist_wheel
echo.
set PYTHONIOENCODING=UTF-8
python.exe -m aeneas.diagnostics
python.exe -m aeneas.tools.execute_task --version
python.exe -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v C:\Windows\Temp\test.wav
echo.
copy /b/v/y dist\aeneas-*.whl ..\
cd %CURDIR%

FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-*.whl /b`) DO (SET aeneas_file=%%F)
IF %ERRORLEVEL%==0 (
  python -m pip install -U pip %aeneas_file%
  RMDIR /S /Q aeneas-1.7.3.0
  DEL /Q aeneas-1.7.3.0.tar
  DEL /Q aeneas-1.7.3.0.tar.gz
  MOVE /Y *.whl "%cd%\python-wheels"
)

ENDLOCAL
