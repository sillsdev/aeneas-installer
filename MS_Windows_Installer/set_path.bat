@echo off

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
