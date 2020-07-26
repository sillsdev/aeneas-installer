@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions
IF NOT DEFINED VS90COMNTOOLS set VS90COMNTOOLS=%USERPROFILE%\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0

set CURDIR=%CD%

set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;C:\Program Files\Git\usr\bin;%PATH%

IF EXIST "C:\Program Files\7-Zip\7z.exe" GOTO SEVENZ64PATH
:SEVENZ32PATH
  set SEVENZ=C:\Program Files (x86)\7-Zip\7z.exe
  (call )
  GOTO ENDIF
:SEVENZ64PATH
  set SEVENZ=C:\Program Files\7-Zip\7z.exe
  (call )
:ENDIF

IF EXIST "C:\Program Files\Inno Setup 5\ISCC.exe" GOTO INNO64PATH
:INNO32PATH
  set ISCC=C:\Program Files (x86)\Inno Setup 5\ISCC.exe
  (call )
  GOTO ENDIF
:INNO64PATH
  set ISCC=C:\Program Files\Inno Setup 5\ISCC.exe
  (call )
:ENDIF
IF EXIST "C:\Program Files\Inno Setup 6\ISCC.exe" GOTO INNO64
:INNO32
  set ISCC=C:\Program Files (x86)\Inno Setup 6\ISCC.exe
  (call )
  GOTO ENDIF
:INNO64
  set ISCC=C:\Program Files\Inno Setup 6\ISCC.exe
  (call )
:ENDIF

2>nul curl.exe --version
if %ERRORLEVEL%==0 goto exeCurl
  REM python.exe -m pip install -U wget
  REM set CURL=python.exe -m wget
  set CURL=call curl.bat -L
  goto endIf
:exeCurl
  set CURL=curl.exe -L
:endIf

IF NOT EXIST "%cd%\python-3.8.5-amd64.exe" (
  echo Downloading Python 3.8.5...
  %CURL% "http://www.python.org/ftp/python/3.8.5/python-3.8.5-amd64.exe" -o "%cd%\python-3.8.5-amd64.exe"
)
IF EXIST "%cd%\python-3.8.5-amd64.exe" (
  echo Installing Python 3.8.5...
  python-3.8.5-amd64.exe /passive InstallAllUsers=1 PrependPath=1
) ELSE (
  echo Could not find Python 3.8.5...
  START https://www.python.org/downloads/release/python-385/
)

"C:\Program Files\Python38\python.exe" -m ensurepip
set pip=C:\Program Files\Python38\Scripts\pip.exe
set python=C:\Program Files\Python38\python.exe

"%pip%" install -U pip setuptools wheel

"%pip%" install -U patch

IF NOT EXIST "%cd%\espeak-ng-1.50-x64.msi" (
  echo Downloading eSpeak-ng...
  %CURL% http://github.com/espeak-ng/espeak-ng/releases/download/1.50/espeak-ng-20191129-b702b03-x64.msi -o %cd%\espeak-ng-1.50-x64.msi
)
IF EXIST "%cd%\espeak-ng-1.50-x64.msi" (
REM   echo Installing eSpeak-ng...
REM   "%cd%\espeak-ng-1.50-x64.msi" /passive InstallAllUsers=1 PrependPath=1
) ELSE (
  echo Could not find eSpeak-ng...
  echo START https://github.com/espeak-ng/espeak-ng/releases
)

REM DEL "%cd%\ffmpeg-4.3-win64-static.zip"
IF NOT EXIST "%cd%\ffmpeg-4.3-win64-static.zip" (
  echo Downloading FFmpeg...
  %CURL% https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.3-win64-static.zip -o %cd%\ffmpeg-4.3-win64-static.zip
)
IF NOT EXIST "%cd%\ffmpeg-4.3-win64-static.exe" (
  "%SEVENZ%" x ffmpeg-4.3-win64-static.zip -aoa
  rmdir /q/s ffmpeg-4.2
  move /y ffmpeg-4.3-win64-static ffmpeg-4.3
  "%ISCC%" FFmpeg_Installer.iss
)
IF EXIST "%cd%\ffmpeg-4.3-win64-static.exe" (
   echo Installing FFmpeg...
   "%cd%\ffmpeg-4.3-win64-static.exe" /SILENT
) ELSE (
  echo Could not find FFmpeg...
  echo START https://ffmpeg.zeranoe.com/builds/
)

del *.whl

"%pip%" install -U numpy
"%pip%" install -U lxml beautifulsoup4 soupsieve

"%pip%" wheel pip
"%pip%" wheel numpy
"%pip%" wheel lxml beautifulsoup4 soupsieve
"%pip%" download aeneas==1.7.3.0

RMDIR /S /Q aeneas-1.7.3.0
"%SEVENZ%" e aeneas-1.7.3.0.tar.gz -aoa
"%SEVENZ%" x aeneas-1.7.3.0.tar -aoa
cd aeneas-1.7.3.0
"%python%" -m patch -v -p 1 --debug ..\aeneas-patches\patch-espeak-ng.diff
"%python%" -m patch -v -p 1 --debug ..\aeneas-patches\patch-py38-utf8.diff
move aeneas\cew\speak_lib.h thirdparty\speak_lib.h
set AENEAS_USE_ESPEAKNG=True
"%python%" setup.py bdist_wheel
del ..\aeneas-*.whl
copy /b/v/y dist\aeneas-*.whl ..\
cd %CURDIR%

"%pip%" install -U aeneas-*.whl

REM call install_packages.bat

REM C:\Windows\System32\ping 127.0.0.1 -n 10 -w 1000 > NUL

echo.
set PYTHONIOENCODING=UTF-8
"%python%" -m aeneas.diagnostics
"%python%" -m aeneas.tools.execute_task --version
"%python%" -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v C:\Windows\Temp\test.wav
echo.

REM C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL

echo Now run build_installer.bat

ENDLOCAL
