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

C:\Python27\python -m ensurepip
C:\Python27\python -m pip install -U pip setuptools wheel

C:\Python27\python -m pip install -U patch

C:\Python27\python -m pip install -U wget
2>nul curl.exe --version
if %ERRORLEVEL%==0 goto exeCurl
  set CURL=C:\Python27\python -m wget
  REM set CURL=call curl.bat -L
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
  echo START https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.7z
)

IF NOT EXIST "%cd%\ffmpeg-latest-win32-static.7z" (
  echo Downloading FFmpeg...
  %CURL% https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.7z -o %cd%\ffmpeg-latest-win32-static.7z
)
IF NOT EXIST "%cd%\setup_ffmpeg-3.0.2.exe" (
  "%PF32%\7-Zip\7z.exe" x ffmpeg-*-win32-static.7z -aoa
  rmdir /q/s ffmpeg-3.0.2
  move /y ffmpeg-*-win32-static ffmpeg-3.0.2
  "%PF32%\Inno Setup 5\ISCC.exe" FFmpeg_Installer.iss
)
IF EXIST "%cd%\setup_ffmpeg-3.0.2.exe" (
REM   echo Installing FFmpeg...
REM   "%cd%\setup_ffmpeg-3.0.2.exe" /SILENT
) ELSE (
  echo Could not find FFmpeg...
  echo START http://internode.dl.sourceforge.net/project/espeak/espeak/espeak-1.48/setup_espeak-1.48.04.exe
)


C:\Python27\python -m pip download pip==8.1.2
C:\Python27\python -m pip download beautifulsoup4==4.4.1
C:\Python27\python -m pip download lxml==3.6.0
C:\Python27\python -m pip download numpy==1.10.1

IF NOT EXIST "%cd%\numpy-1.10.1-cp27-cp27m-win32.whl" (
  "%PF32%\7-Zip\7z.exe" x numpy-1.10.1.zip -aoa
  cd numpy-1.10.1
  C:\Python27\python setup.py bdist_wheel
  copy /b/v/y dist\numpy-1.10.1-cp27-cp27m-win32.whl ..\
  cd %CURDIR%
)

C:\Python27\python -m pip install -U numpy-1.10.1-cp27-cp27m-win32.whl
C:\Python27\python -m pip install -U lxml-3.6.0-cp27-none-win32.whl
C:\Python27\python -m pip install -U beautifulsoup4-4.4.1-py2-none-any.whl

REM C:\Python27\python -m pip download aeneas==1.5.0.3
C:\Python27\python -m pip download aeneas==1.5.1.0

RMDIR /S /Q aeneas-1.5.1.0
REM "%PF32%\7-Zip\7z.exe" e aeneas-1.5.0.3.tar.gz -aoa
REM "%PF32%\7-Zip\7z.exe" x aeneas-1.5.0.3.tar -aoa
"%PF32%\7-Zip\7z.exe" e aeneas-1.5.1.0.tar.gz -aoa
"%PF32%\7-Zip\7z.exe" x aeneas-1.5.1.0.tar -aoa
echo copying espeak.lib to C:\Python27\libs\
copy /b/v/y espeak.lib C:\Python27\libs\
REM copy /b/v/y aeneas-patches\setup.py aeneas-1.5.0.3\
REM copy /b/v/y aeneas-patches\diagnostics.py aeneas-1.5.0.3\aeneas\
REM call "%VS90COMNTOOLS%\vcvarsall.bat" x86
REM SET DISTUTILS_USE_SDK=1
REM SET MSSDK=1
REM cd aeneas-1.5.0.3
REM C:\Python27\python.exe -m patch -v -p 1 --debug ..\aeneas-patches\setup.patch
REM C:\Python27\python.exe -m patch -v -p 1 --debug ..\aeneas-patches\diagnostics.patch
REM REM cd aeneas\cew
REM REM C:\Python27\python cew_setup.py build_ext --inplace
REM REM cd ..\..
cd aeneas-1.5.1.0
C:\Python27\python.exe -m patch -v -p 0 --debug ..\aeneas-patches\1.5.1.0-windows.diff
C:\Python27\python setup.py build_ext --inplace
C:\Python27\python setup.py bdist_wheel
copy /b/v/y dist\aeneas-*-win32.whl ..\
cd %CURDIR%

REM call install_packages.bat

REM C:\Windows\System32\ping 127.0.0.1 -n 10 -w 1000 > NUL

echo.
set PYTHONIOENCODING=UTF-8
REM C:\Python27\python -m aeneas.diagnostics
REM C:\Python27\python -m aeneas.tools.execute_task --version
REM C:\Python27\python -m aeneas.tools.synthesize_text list "This is a test|with two lines" eng -v C:\Windows\Temp\test.wav
REM echo.

REM C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL

IF NOT EXIST "%cd%\python-2.7.11.msi" (
  echo Downloading Python 2.7.11...
  %CURL% https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi -o %cd%\python-2.7.11.msi
)

"%PF32%\Inno Setup 5\ISCC.exe" Aeneas_Installer.iss

ENDLOCAL
