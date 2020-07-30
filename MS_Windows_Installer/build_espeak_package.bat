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

IF EXIST "%cd%\aeneas-win-installer-packages\espeak-ng-1.50-x86.msi" GOTO ENDGET
  echo Downloading eSpeak-ng...
  %CURL% https://github.com/espeak-ng/espeak-ng/releases/download/1.50/espeak-ng-20191129-b702b03-x86.msi -o espeak-ng-1.50-x86.msi
  IF %ERRORLEVEL%==0 GOTO ENDIF
    echo Could not download eSpeak-ng...
    START https://github.com/espeak-ng/espeak-ng/releases
  :ENDIF
:ENDGET
IF EXIST "%cd%\espeak-ng-1.50-x86.msi" (
  echo Installing eSpeak-ng...
  "%cd%\espeak-ng-1.50-x86.msi" /PASSIVE
  copy /b/v/y "%CD%\install_espeak-ng-dll.bat" "%USERPROFILE%\install_espeak-ng-dll.bat"
  call "%USERPROFILE%\install_espeak-ng-dll.bat"
  move /y "%cd%\espeak-ng-1.50-x86.msi"  "%cd%\aeneas-win-installer-packages"
)

ENDLOCAL
