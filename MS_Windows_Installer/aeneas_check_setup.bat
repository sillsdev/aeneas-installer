@echo off
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;%PATH%;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin
  (call )
  GOTO ENDIF
:WIN64PATH
  set PATH=C:\Program Files\Python38\;C:\Program Files\Python38\Scripts;%PATH%;C:\Program Files\eSpeak NG;C:\Program Files\FFmpeg\bin
  (call )
:ENDIF
C:
cd C:\Program Files\Python38\Scripts
set PYTHONIOENCODING=UTF-8
C:\Program Files\Python38\python.exe aeneas_check_setup.py
C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL
