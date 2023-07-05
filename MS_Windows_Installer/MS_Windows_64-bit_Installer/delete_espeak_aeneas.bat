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

set PATH=%PF64%\Python39\;%PF64%\Python39\Scripts;%PF64%\eSpeak NG;%PF64%\FFmpeg\bin;%PATH%

echo Deleting espeak.exe from %PF64%\eSpeak NG\
del /f/q "%PF64%\eSpeak NG\espeak.exe"

echo Deleting libespeak-ng.dll from %PF64%\Python39\Lib\site-packages\aeneas\cew
del /f/q "%PF64%\Python39\Lib\site-packages\aeneas\cew\libespeak-ng.dll"
del /f/q "%UserProfile%\AppData\Roaming\Python\Python39\site-packages\aeneas\cew\libespeak-ng.dll"