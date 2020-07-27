@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions
IF NOT DEFINED VS90COMNTOOLS set VS90COMNTOOLS=%USERPROFILE%\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0

set CURDIR=%CD%

set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;%PATH%;C:\Program Files\Git\usr\bin

IF EXIST "C:\Program Files\7-Zip\7z.exe" GOTO SEVENZ64PATH
:SEVENZ32PATH
  set SEVENZ=C:\Program Files (x86)\7-Zip\7z.exe
  (call )
  GOTO SEVENENDIF
:SEVENZ64PATH
  set SEVENZ=C:\Program Files\7-Zip\7z.exe
  (call )
:SEVENENDIF

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO WINENDIF
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:WINENDIF

IF EXIST "%PF32%\Inno Setup 6" GOTO INNO6PATH
:INNO5PATH
  set INNOPATH=%PF32%\Inno Setup 5
  (call )
  GOTO INNOENDIF
:INNO6PATH
  set INNOPATH=%PF32%\Inno Setup 6
  (call )
:INNOENDIF

2>nul curl.exe --version
if %ERRORLEVEL%==0 goto exeCurl
  REM python.exe -m pip install -U wget
  REM set CURL=python.exe -m wget
  set CURL=call curl.bat -L
  goto endIf
:exeCurl
  set CURL=curl.exe -L
:endIf

REM mkdir aeneas-win-installer-packages
REM mkdir python-wheels

IF NOT EXIST "%cd%\python-3.8.5-amd64.exe" (
  echo Downloading Python 3.8.5...
  %CURL% "https://www.python.org/ftp/python/3.8.5/python-3.8.5-amd64.exe" -o "%cd%\python-3.8.5-amd64.exe"
)
IF EXIST "%cd%\python-3.8.5-amd64.exe" (
  echo Installing Python 3.8.5...
  python-3.8.5-amd64.exe /passive InstallAllUsers=1 PrependPath=1 TargetDir="C:\Program Files\Python38"
) ELSE (
  echo Could not find Python 3.8.5...
  START https://www.python.org/downloads/release/python-385/
)

"C:\Program Files\Python38\python.exe" -m ensurepip
set pip=C:\Program Files\Python38\Scripts\pip.exe
set python=C:\Program Files\Python38\python.exe

"%pip%" install -U pip setuptools wheel

IF NOT EXIST "%cd%\espeak-ng-1.50-x64.msi" (
  echo Downloading eSpeak-ng...
  %CURL% https://github.com/espeak-ng/espeak-ng/releases/download/1.50/espeak-ng-20191129-b702b03-x64.msi -o %cd%\espeak-ng-1.50-x64.msi
)
IF EXIST "%cd%\espeak-ng-1.50-x64.msi" (
   echo Installing eSpeak-ng...
   "%cd%\espeak-ng-1.50-x64.msi" /passive InstallAllUsers=1 PrependPath=1
   call "%cd%\install_espeak-ng-dll.bat"
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
  rmdir /q/s ffmpeg-4.3
  move /y ffmpeg-4.3-win64-static ffmpeg-4.3
  copy /b/v/y  ff-prompt.bat ffmpeg-4.3
  "%INNOPATH%\ISCC.exe" FFmpeg_Installer.iss
)
IF EXIST "%cd%\ffmpeg-4.3-win64-static.exe" (
   echo Installing FFmpeg...
   "%cd%\ffmpeg-4.3-win64-static.exe" /SILENT /ALLUSERS
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

"%pip%" download aeneas==1.7.3.0 --no-cache-dir

IF NOT EXIST "%cd%\aeneas-1.7.3.0.tar.gz" (
  echo Downloading FFmpeg...
  %CURL% https://github.com/readbeyond/aeneas/archive/v1.7.3.tar.gz -o %cd%\aeneas-1.7.3.0.tar.gz
)

RMDIR /S /Q aeneas-1.7.3.0
"%SEVENZ%" e aeneas-1.7.3.0.tar.gz -aoa
"%SEVENZ%" x aeneas-1.7.3.0.tar -aoa

IF NOT EXIST "%cd%\aeneas-1.7.3.0" (
  move aeneas-1.7.3 aeneas-1.7.3.0
)
cd aeneas-1.7.3.0
echo "Checking for patch.exe"
2>nul patch.exe --version
if %ERRORLEVEL%==0 goto exePatch
  python.exe -m pip install -U patch
  python.exe -m patch -v -p 1 --debug ..\aeneas-patches\patch-espeak-ng.diff
  python.exe -m patch -v -p 1 --debug ..\aeneas-patches\patch-py38-utf8.diff
  goto endPatch
:exePatch
  patch.exe -p1 < ..\aeneas-patches\patch-espeak-ng.diff
  patch.exe -p1 < ..\aeneas-patches\patch-py38-utf8.diff
:endPatch
move /y aeneas\cew\speak_lib.h thirdparty\speak_lib.h
copy /b/v/y ..\libespeak-ng-dll2lib-x64\libespeak-ng.lib thirdparty\libespeak-ng-x64.lib
copy /b/v/y ..\libespeak-ng-dll2lib-x86\libespeak-ng.lib thirdparty\libespeak-ng-x86.lib
set AENEAS_USE_ESPEAKNG=True
"%python%" setup.py build_ext --inplace
"%python%" setup.py bdist_wheel
echo.
set PYTHONIOENCODING=UTF-8
"%python%" -m aeneas.diagnostics
"%python%" -m aeneas.tools.execute_task --version
"%python%" -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v C:\Windows\Temp\test.wav
echo.
copy /b/v/y dist\aeneas-*.whl ..\
cd %CURDIR%

FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-%aeneas_ver%*.whl /b`) DO (SET aeneas_file=%%F)
"%pip%" install -U pip %aeneas_file%

REM call install_packages.bat

echo Now run build_installer.bat

ENDLOCAL
