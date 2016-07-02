@echo off

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

echo Copying espeak.dll to C:\Windows\System32\
copy /b/v/y "%PF32%\eSpeak\espeak_sapi.dll" C:\Windows\System32\espeak.dll
echo Copying espeak.lib to C:\Python\libs\
copy /b/v/y espeak.lib C:\Python27\libs\

C:\Python27\python -m ensurepip
C:\Python27\python -m pip install pip-8.1.2-py2.py3-none-any.whl
C:\Python27\python -m pip install beautifulsoup4-4.4.1-py2-none-any.whl
C:\Python27\python -m pip install lxml-3.6.0-cp27-none-win32.whl
C:\Python27\python -m pip install numpy-1.10.1-cp27-cp27m-win32.whl
C:\Python27\python -m pip install aeneas-1.5.0.3-cp27-cp27m-win32.whl

