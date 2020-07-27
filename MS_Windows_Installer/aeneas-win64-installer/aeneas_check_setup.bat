@echo off
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;%PATH%
  (call )
  GOTO ENDIF
:WIN64PATH
  set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin;%PATH%
  (call )
:ENDIF
set PYTHONIOENCODING=UTF-8
python -m aeneas.diagnostics
C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL
