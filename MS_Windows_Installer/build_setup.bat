@echo off

echo Downloading 7-zip... 
cscript.exe wget.vbs "http://www.7-zip.org/a/7z1602.exe" "%cd%\7z1602.exe"
echo Installing 7-zip...
7z1602.exe

echo Downloading Inno Setup...
cscript.exe wget.vbs "http://www.jrsoftware.org/download.php/is-unicode.exe" "%cd%\innosetup-5.5.9-unicode.exe"
echo Installing InnoSetup...
innosetup-5.5.9-unicode.exe /SILENT

echo Downloading Python 2.7.11...
cscript.exe wget.vbs "https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi" "%cd%\python-2.7.11.msi"
echo Installing Python 2.7.11...
python-2.7.11.msi /PASSIVE

echo Downloading Visual C++ For Python27...
cscript.exe wget.vbs "https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi" "%cd%\VCForPython27.msi"
echo Installing Visual C++ For Python27...
VCForPython27.msi /PASSIVE

echo Setting PATH variable...
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

echo Downloading eSpeak...
cscript.exe wget.vbs "http://downloads.sourceforge.net/project/espeak/espeak/espeak-1.48/setup_espeak-1.48.04.exe?r=&ts=1466034490&use_mirror=jaist" "%cd%\setup_espeak-1.48.04.exe"

echo Downloading FFmpeg...
cscript.exe wget.vbs "https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.7z" "%cd%\ffmpeg-latest-win32-static.7z"
