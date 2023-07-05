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

set PATH=%INNOPATH%;%PFSZ%\7-Zip;%PF64%\FFmpeg\bin;%PF64%\eSpeak NG;%PF64%\Python39;%PF64%\Python39\Scripts;%PF64%\Git;%PF64%\Git\usr\bin;%PF64%\Git\mingw64\bin;%PATH%

curl.exe --version 1>nul 2>nul
if %ERRORLEVEL%==1 (
  set CURL=call curl-psh.bat -L
) else (
  set CURL=curl.exe -L
)

mkdir aeneas-win-installer-packages 1>nul 2>nul
cd %CURDIR%

IF EXIST "%cd%\aeneas-win-installer-packages\ffmpeg-6.0-win64-static.exe" GOTO ENDGET
  echo Downloading FFmpeg...
  %CURL% https://www.gyan.dev/ffmpeg/builds/packages/ffmpeg-6.0-essentials_build.7z -o ffmpeg-6.0-win64-static.7z
  IF %ERRORLEVEL%==0 GOTO ENDIF
    echo Could not download FFmpeg...
    START https://www.gyan.dev/ffmpeg/builds/#release-builds
  :ENDIF
  rmdir /q/s ffmpeg-6.0 1>nul 2>nul
  rmdir /q/s ffmpeg-6.0-win64-static 1>nul 2>nul
  "\Program Files\7-Zip\7z.exe" x ffmpeg-6.0-win64-static.7z -aoa 
  move /y ffmpeg-6.0-essentials_build ffmpeg-6.0-win64-static
  copy /b/v/y  ff-prompt.bat ffmpeg-6.0-win64-static
  "ISCC.exe" FFmpeg_Installer.iss
:ENDGET
IF EXIST "%cd%\ffmpeg-6.0-win64-static.exe" (
  echo Installing FFmpeg...
  "%cd%\ffmpeg-6.0-win64-static.exe" /SILENT /ALLUSERS
  move /y "%cd%\ffmpeg-6.0-win64-static.exe"  "%cd%\aeneas-win-installer-packages"
  del /q ffmpeg-6.0-win64-static.zip 1>nul 2>nul
  rmdir /q/s ffmpeg-6.0-win64-static 1>nul 2>nul
  rmdir /q/s ffmpeg-6.0 1>nul 2>nul
)

ENDLOCAL
