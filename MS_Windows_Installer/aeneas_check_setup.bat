@echo off
IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PATH=C:\Python27\;C:\Python27\Scripts;%PATH%;C:\Program Files\eSpeak\command_line;C:\Program Files\FFmpeg\bin
  (call )
  GOTO ENDIF
:WIN64PATH
  set PATH=C:\Python27\;C:\Python27\Scripts;%PATH%;C:\Program Files (x86)\eSpeak\command_line;C:\Program Files (x86)\FFmpeg\bin
  (call )
:ENDIF
C:
cd C:\Python27\Scripts
set PYTHONIOENCODING=UTF-8
C:\Python27\python aeneas_check_setup
C:\Windows\System32\ping 127.0.0.1 -n 5 -w 1000 > NUL
