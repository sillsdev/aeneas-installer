@echo off

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
  set PF32=C:\Program Files
  (call )
  GOTO WIN32PATH
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:WIN32PATH

set PATH=%PF32%\Python38\;%PF32%\Python38\Scripts;%PF32%\eSpeak NG;%PF32%\FFmpeg\bin;%PATH%

echo Deleting espeak.exe from %PF32%\eSpeak NG\
del /f/q "%PF32%\eSpeak NG\espeak.exe"

echo Deleting libespeak-ng.dll from %PF32%\Python38\Lib\site-packages\aeneas\cew
del /f/q "%PF32%\Python38\Lib\site-packages\aeneas\cew\libespeak-ng.dll"
