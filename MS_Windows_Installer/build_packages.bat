@echo off

echo %PATH% >> C:\Windows\Temp\PATH.bak
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PATH=C:\Python27\;C:\Python27\Scripts\;%PATH%;C:\Program Files\7-Zip\;C:\Program Files\Inno Setup 5\
  (call )
  GOTO SETPATH
:WIN64PATH
  set PATH=C:\Python27\;C:\Python27\Scripts\;%PATH%;C:\Program Files (x86)\7-Zip\;C:\Program Files (x86)\Inno Setup 5\
  (call )
:SETPATH
C:\Windows\System32\setx PATH "%PATH%"

C:\Python27\python -m pip install --upgrade pip
C:\Python27\python -m pip install --upgrade wheel
C:\Python27\python -m pip install beautifulsoup4
C:\Python27\python -m pip install lxml
C:\Python27\python -m pip install numpy
C:\Python27\python -m pip install aeneas

C:\Python27\python -m pip download pip
C:\Python27\python -m pip download beautifulsoup4
C:\Python27\python -m pip download lxml
C:\Python27\python -m pip download numpy==1.10.1
C:\Python27\python -m pip download aeneas


7z.exe x numpy-1.10.1.zip -aoa
cd numpy-1.10.1
python setup.py bdist_wheel
copy dist\numpy-1.10.1-cp27-cp27m-win32.whl ..\
cd ..

C:\Python27\python -m pip install numpy-1.10.1-cp27-cp27m-win32.whl

7z.exe e aeneas-1.5.0.3.tar.gz -aoa
7z.exe x aeneas-1.5.0.3.tar -aoa
cd aeneas-1.5.0.3
python setup.py bdist_wheel
copy dist\aeneas-1.5.0.3-cp27-cp27m-win32.whl ..\
cd ..

IF NOT EXIST "%cd%\setup_espeak-1.48.04.exe" (
  echo Downloading eSpeak...
  cscript.exe /NoLogo wget.vbs "http://internode.dl.sourceforge.net/project/espeak/espeak/espeak-1.48/setup_espeak-1.48.04.exe" "%cd%\setup_espeak-1.48.04.exe"
)

IF NOT EXIST "%cd%\ffmpeg-latest-win32-static.7z" (
  echo Downloading FFmpeg...
  cscript.exe /NoLogo wget.vbs "https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.7z" "%cd%\ffmpeg-latest-win32-static.7z"
)

7z.exe x ffmpeg-*-win32-static.7z -aoa
move /y ffmpeg-*-win32-static ffmpeg-3.0.2

IF NOT EXIST "%cd%\python-2.7.11.msi" (
  echo Downloading Python 2.7.11...
  cscript.exe /NoLogo wget.vbs "https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi" "%cd%\python-2.7.11.msi"
)

ISCC.exe FFmpeg_Installer.iss

ISCC.exe Aeneas_Installer.iss
