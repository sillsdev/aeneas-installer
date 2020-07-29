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

set PATH=%INNOPATH%;%PFSZ%\7-Zip;%PF64%\FFmpeg\bin;%PF64%\eSpeak NG;%PF64%\Python38;%PF64%\Python38\Scripts;%PF64%\Git;%PF64%\Git\usr\bin;%PF64%\Git\mingw64\bin;%PATH%

curl.exe --version 1>nul 2>nul
if %ERRORLEVEL%==1 (
  set CURL=call curl-psh.bat -L
) else (
  set CURL=curl.exe -L
)

mkdir aeneas-win-installer-packages 1>nul 2>nul
cd %CURDIR%

IF EXIST "%cd%\aeneas-win-installer-packages\ffmpeg-4.3-win64-static.exe" GOTO ENDGET
  echo Downloading FFmpeg...
  %CURL% https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.3-win64-static.zip -o ffmpeg-4.3-win64-static.zip
  IF %ERRORLEVEL%==0 GOTO ENDIF
    echo Could not download FFmpeg...
    START https://ffmpeg.zeranoe.com/builds/
  :ENDIF
  rmdir /q/s ffmpeg-4.3 1>nul 2>nul
  rmdir /q/s ffmpeg-4.3-win64-static 1>nul 2>nul
  "7z.exe" x ffmpeg-4.3-win64-static.zip -aoa
  copy /b/v/y  ff-prompt.bat ffmpeg-4.3-win64-static
  "ISCC.exe" FFmpeg_Installer.iss
:ENDGET
IF EXIST "%cd%\ffmpeg-4.3-win64-static.exe" (
  echo Installing FFmpeg...
  "%cd%\ffmpeg-4.3-win64-static.exe" /SILENT /ALLUSERS
  move /y "%cd%\ffmpeg-4.3-win64-static.exe"  "%cd%\aeneas-win-installer-packages"
  del /q ffmpeg-4.3-win64-static.zip 1>nul 2>nul
  rmdir /q/s ffmpeg-4.3-win64-static 1>nul 2>nul
  rmdir /q/s ffmpeg-4.3 1>nul 2>nul
)

ENDLOCAL
