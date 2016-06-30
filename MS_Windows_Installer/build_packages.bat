@echo off

echo %PATH% >> C:\Windows\Temp\PATH.bak
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

C:\Python27\python -m pip install --upgrade pip
C:\Python27\python -m pip install --upgrade wget
C:\Python27\python -m pip install --upgrade wheel
C:\Python27\python -m pip install --upgrade numpy

C:\Python27\python -m pip download pip==8.1.2
C:\Python27\python -m pip download beautifulsoup4==4.4.1
C:\Python27\python -m pip download lxml==3.6.0
C:\Python27\python -m pip download numpy==1.10.1
C:\Python27\python -m pip download aeneas==1.5.0.3


"%PF32%\7-Zip\7z.exe" x numpy-1.10.1.zip -aoa
cd numpy-1.10.1
C:\Python27\python setup.py bdist_wheel
copy /b/v/y dist\numpy-1.10.1-cp27-cp27m-win32.whl ..\
cd ..

C:\Python27\python -m pip install numpy-1.10.1-cp27-cp27m-win32.whl

"%PF32%\7-Zip\7z.exe" e aeneas-1.5.0.3.tar.gz -aoa
"%PF32%\7-Zip\7z.exe" x aeneas-1.5.0.3.tar -aoa
copy /b/v/y aeneas-patches\setup.py aeneas-1.5.0.3\
copy /b/v/y aeneas-patches\diagnostics.py aeneas-1.5.0.3\aeneas\
copy /b/v/y espeak.lib C:\Python27\libs\
set CVPDIR=%USERPROFILE%\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0\
set PATH=%CVPDIR%;%PATH%
set VCINSTALLDIR=%CVPDIR%VC\
set WindowsSdkDir=%CVPDIR%WinSDK\
if not exist "%VCINSTALLDIR%bin\cl.exe" goto missing
set PATH=%VCINSTALLDIR%Bin;%WindowsSdkDir%Bin;%PATH%
set INCLUDE=%VCINSTALLDIR%Include;%WindowsSdkDir%Include;%INCLUDE%
set LIB=%VCINSTALLDIR%Lib;%WindowsSdkDir%Lib;%LIB%
set LIBPATH=%VCINSTALLDIR%Lib;%WindowsSdkDir%Lib;%LIBPATH%
SET DISTUTILS_USE_SDK=1
SET MSSDK=1
cd aeneas-1.5.0.3\aeneas\cew
C:\Python27\python cew_setup.py build_ext --inplace
cd ..\..
C:\Python27\python setup.py build_ext --inplace
C:\Python27\python setup.py bdist_wheel
copy /b/v/y dist\aeneas-*-win32.whl ..\
cd ..

IF NOT EXIST "%cd%\python-2.7.11.msi" (
  echo Downloading Python 2.7.11...
  C:\Python27\python -m wget https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi -o %cd%\python-2.7.11.msi
)

IF NOT EXIST "%cd%\setup_espeak-1.48.04.exe" (
  echo Downloading eSpeak...
  C:\Python27\python -m wget http://internode.dl.sourceforge.net/project/espeak/espeak/espeak-1.48/setup_espeak-1.48.04.exe -o %cd%\setup_espeak-1.48.04.exe
)

IF NOT EXIST "%cd%\ffmpeg-latest-win32-static.7z" (
  echo Downloading FFmpeg...
  C:\Python27\python -m wget https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.7z -o %cd%\ffmpeg-latest-win32-static.7z
)

IF NOT EXIST "%cd%\setup_ffmpeg-3.0.2.exe" (
  "%PF32%\7-Zip\7z.exe" x ffmpeg-*-win32-static.7z -aoa
  rmdir /s ffmpeg-3.0.2
  move /y ffmpeg-*-win32-static ffmpeg-3.0.2
  "%PF32%\Inno Setup 5\ISCC.exe" FFmpeg_Installer.iss
)

"%PF32%\Inno Setup 5\ISCC.exe" Aeneas_Installer.iss
