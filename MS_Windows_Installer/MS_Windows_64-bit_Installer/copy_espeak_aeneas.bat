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

echo Copying espeak-ng.exe to espeak.exe
copy /b/v/y "%PF64%\eSpeak NG\espeak-ng.exe" "%PF64%\eSpeak NG\espeak.exe"

echo Copying libespeak-ng.dll to %PF64%\Python39\Lib\site-packages\aeneas\cew
copy /b/v/y "%PF64%\eSpeak NG\libespeak-ng.dll" "%PF64%\Python39\Lib\site-packages\aeneas\cew"
copy /b/v/y "%PF64%\eSpeak NG\libespeak-ng.dll" "%UserProfile%\AppData\Roaming\Python\Python39\site-packages\aeneas\cew"
