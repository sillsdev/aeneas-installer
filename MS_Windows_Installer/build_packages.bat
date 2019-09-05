@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions
IF NOT DEFINED VS90COMNTOOLS set VS90COMNTOOLS=%USERPROFILE%\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0

set CURDIR=%CD%

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

IF EXIST "%PF32%\Inno Setup 6" GOTO INNO6PATH
:INNO5PATH
  set INNOPATH=%PF32%\Inno Setup 5
  (call )
  GOTO ENDIF
:INNO6PATH
  set INNOPATH=%PF32%\Inno Setup 6
  (call )
:ENDIF

IF NOT EXIST "%cd%\python-3.7.4.exe" (
  echo Downloading Python 3.7.4...
  %CURL% "https://www.python.org/ftp/python/3.7.4/python-3.7.4.exe" -o "%cd%\python-3.7.4.exe"
)
IF EXIST "C:\Python37-32\python.exe" (
  IF NOT EXIST "%cd%\python-3.7.4.exe" (
    echo Installing Python 3.7.4...
    python-3.7.4.exe /quiet InstallAllUsers=1 TargetDir=C:\Python37-32 PrependPath=1
  )
) ELSE (
  echo Could not find Python 3.7.4...
  START https://www.python.org/downloads/release/python-374/
)

C:\Python37-32\python -m ensurepip
set pip=C:\Python37-32\Scripts\pip

%pip% install -U pip setuptools wheel

%pip% install -U patch

%pip% install -U wget

2>nul curl.exe --version
if %ERRORLEVEL%==0 goto exeCurl
  REM set CURL=C:\Python37-32\python -m wget
  set CURL=call curl.bat -L
  goto endIf
:exeCurl
  set CURL=curl.exe -L
:endIf

IF NOT EXIST "%cd%\setup_espeak-1.48.04.exe" (
  echo Downloading eSpeak...
  %CURL% http://internode.dl.sourceforge.net/project/espeak/espeak/espeak-1.48/setup_espeak-1.48.04.exe -o %cd%\setup_espeak-1.48.04.exe
)
IF EXIST "%cd%\setup_espeak-1.48.04.exe" (
REM   echo Installing eSpeak...
REM   "%cd%\setup_espeak-1.48.04.exe" /SILENT
) ELSE (
  echo Could not find eSpeak...
  echo START http://internode.dl.sourceforge.net/project/espeak/espeak/espeak-1.48/setup_espeak-1.48.04.exe
)

REM DEL "%cd%\ffmpeg-4.2-win32-static.zip"
IF NOT EXIST "%cd%\ffmpeg-4.2-win32-static.zip" (
  echo Downloading FFmpeg...
  REM %CURL% https://archive.org/download/ffmpeg-4.2-win32-static/ffmpeg-4.2-win32-static.zip -o %cd%\ffmpeg-3.2-win32-static.zip
  %CURL% https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-4.2-win32-static.zip -o %cd%\ffmpeg-4.2-win32-static.zip
)
IF NOT EXIST "%cd%\setup_ffmpeg-4.2.exe" (
  "%PF32%\7-Zip\7z.exe" x ffmpeg-4.2-win32-static.zip -aoa
  rmdir /q/s ffmpeg-4.2
  move /y ffmpeg-4.2-win32-static ffmpeg-4.2
  "%INNOPATH%\ISCC.exe" FFmpeg_Installer.iss
)
IF EXIST "%cd%\setup_ffmpeg-4.2.exe" (
REM   echo Installing FFmpeg...
REM   "%cd%\setup_ffmpeg-4.2.exe" /SILENT
) ELSE (
  echo Could not find FFmpeg...
  echo START https://ffmpeg.zeranoe.com/builds/
)

%pip% install -U numpy
%pip% install -U aeneas lxml beautifulsoup4 soupsieve

%pip% wheel pip
%pip% wheel numpy
%pip% wheel aeneas

cd %CURDIR%

REM call install_packages.bat

REM C:\Windows\System32\ping 127.0.0.1 -n 10 -w 1000 > NUL

echo.
set PYTHONIOENCODING=UTF-8
C:\Python37-32\python -m aeneas.diagnostics
C:\Python37-32\python -m aeneas.tools.execute_task --version
C:\Python37-32\python -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v C:\Windows\Temp\test.wav
echo.

REM C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL

echo Now run build_installer.bat

ENDLOCAL
