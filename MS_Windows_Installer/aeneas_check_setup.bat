@echo off
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIFPATH
:WIN64PATH
  set PF32=C:\Program Files (x86)
  (call )
:ENDIFPATH
set PATH=%PF32%\Python38\;%PF32%\Python38\Scripts;%PF32%\eSpeak NG;%PF32%\FFmpeg\bin;%PATH%
set PYTHONIOENCODING=UTF-8
python -m aeneas.diagnostics
C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL
