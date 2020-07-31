@echo off
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF
set PATH=%PF64%\Python38\;%PF64%\Python38\Scripts;%PF64%\eSpeak NG;%PF64%\FFmpeg\bin;%PATH%
set PYTHONIOENCODING=UTF-8
python -m aeneas.diagnostics
C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL
