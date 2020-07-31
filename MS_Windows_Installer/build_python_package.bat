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

set PATH=%INNOPATH%;%PFSZ%\7-Zip;%PF32%\FFmpeg\bin;%PF32%\eSpeak NG;%PF32%\Python38;%PF32%\Python38\Scripts;%PF32%\Git;%PF32%\Git\usr\bin;%PF32%\Git\mingw32\bin;%PATH%

curl.exe --version 1>nul 2>nul
if %ERRORLEVEL%==1 (
  set CURL=call curl-psh.bat -L
) else (
  set CURL=curl.exe -L
)

mkdir aeneas-win-installer-packages 1>nul 2>nul

IF EXIST "%cd%\aeneas-win-installer-packages\python-3.8.5.exe" GOTO ENDGET
  echo Downloading Python 3.8.5...
  %CURL% https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe -o python-3.8.5.exe
  IF %ERRORLEVEL%==0 GOTO ENDIF
    echo Could not download Python...
    START https://www.python.org/downloads/release/python-385/
  :ENDIF
:ENDGET
IF EXIST "%cd%\python-3.8.5.exe" (
  echo Installing Python 3.8.5...
  "%cd%\python-3.8.5.exe" /passive InstallAllUsers=1 PrependPath=1 TargetDir="%PF32%"\Python38
  move /y "%cd%\python-3.8.5.exe"  "%cd%\aeneas-win-installer-packages"
)

ENDLOCAL
