@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions

set CURDIR=%~dp0
cd %CURDIR%
echo Running %~n0 from %CURDIR%

call "%cd%\build_espeak_package.bat" %1
call "%cd%\build_ffmpeg_package.bat" %1
call "%cd%\build_python_package.bat" %1
call "%cd%\build_aeneas_package.bat" %1

echo Now run build_installer.bat

ENDLOCAL
