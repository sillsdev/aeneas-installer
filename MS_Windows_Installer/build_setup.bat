@echo off

echo Installing 7-zip...
7z1602.exe

echo Installing InnoSetup...
innosetup-5.5.9-unicode.exe /SILENT

echo Installing Python 2.7.11...
python-2.7.11.msi /PASSIVE

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
