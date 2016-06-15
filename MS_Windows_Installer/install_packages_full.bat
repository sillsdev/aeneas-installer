@echo off

echo Installing eSpeak...
setup_espeak-1.48.04.exe
echo Installing FFmpeg...
setup_ffmpeg-3.0.2.exe
echo Installing Python...
python-2.7.11.msi

echo Setting PATH variable...
echo %PATH% >> C:\Windows\Temp\PATH.bak
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PATH=C:\Python27\;C:\Python27\Scripts;%PATH%;C:\Program Files\eSpeak\command_line;C:\Program Files\FFmpeg\bin
  (call )
  GOTO SETPATH
:WIN64PATH
  set PATH=C:\Python27\;C:\Python27\Scripts;%PATH%;C:\Program Files (x86)\eSpeak\command_line;C:\Program Files (x86)\FFmpeg\bin
  (call )
:SETPATH
C:\Windows\System32\setx PATH "%PATH%"

C:\Python27\python -m pip install --upgrade pip-8.1.2-py2.py3-none-any.whl

C:\Python27\python -m pip install --upgrade beautifulsoup4-4.4.1-py2-none-any.whl
C:\Python27\python -m pip install --upgrade lxml-3.6.0-cp27-none-win32.whl
C:\Python27\python -m pip install --upgrade aeneas-1.5.0.3-cp27-none-win32.whl
C:\Python27\python -m pip install --upgrade numpy-1.10.1-cp27-none-win32.whl

C:
cd C:\Python27\Scripts
set PYTHONIOENCODING=UTF-8
C:\Python27\python aeneas_check_setup
C:\Windows\System32\ping 127.0.0.1 -n 10 -w 1000 > NUL
