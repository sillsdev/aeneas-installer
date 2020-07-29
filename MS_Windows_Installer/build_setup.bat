@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions

set CURDIR=%~dp0
cd %CURDIR%
echo Running %~n0 from %CURDIR%

IF EXIST "C:\Program Files (x86)" GOTO WIN64PF
  set PF32=C:\Program Files
  GOTO PFENDIF
:WIN64PF
  set PF32=C:\Program Files (x86)
:PFENDIF

IF EXIST "C:\Program Files (x86)\7-Zip" GOTO WIN64SEVEN
  set PFSZ=C:\Program Files
  GOTO SEVENENDIF
:WIN64SEVEN
  set PFSZ=C:\Program Files (x86)
:SEVENENDIF

IF EXIST "%PF32%\Inno Setup 6" GOTO INNOSIX
  set INNOPATH=%PF32%\Inno Setup 5
  GOTO INNOENDIF
:INNOSIX
  set INNOPATH=%PF32%\Inno Setup 6
:INNOENDIF

set PATH=%PATH%;%INNOPATH%;%PFSZ%\7-Zip;%PF32%\FFmpeg\bin;%PF32%\eSpeak NG;%PF32%\Python38;%PF32%\Python38\Scripts;%PF32%\Git;%PF32%\Git\usr\bin;%PF32%\Git\mingw32\bin

curl.exe --version 1>nul 2>nul
if %ERRORLEVEL%==1 (
  set CURL=call curl-psh.bat -L
) else (
  set CURL=curl.exe -L
)

IF NOT EXIST "%cd%\Git-2.27.0-32-bit.exe" (
echo Downloading Git for Windows...
  %CURL% "https://netix.dl.sourceforge.net/project/git-for-windows.mirror/v2.27.0.windows.1/Git-2.27.0-32-bit.exe" -o "%cd%\Git-2.27.0-32-bit.exe"
)
IF EXIST "%cd%\Git-2.27.0-32-bit.exe" (
  echo Installing Git for Windows...
  Git-2.27.0-32-bit.exe /SILENT
) ELSE (
  echo Could not find Git for Windows 2.27.0...
  START https://git-scm.com/download/win
)

set PATH=%PATH%;%PF32%\Git;%PF32%\Git\usr\bin;%PF32%\Git\mingw32\bin

2>nul curl.exe --version
IF %ERRORLEVEL%==0 (
  set CURL=call curl-psh.bat -L
) ELSE (
  set CURL=curl.exe -L
)

IF NOT EXIST "%cd%\7z1900.exe" (
  echo Downloading 7-zip... 
  %CURL% "https://www.7-zip.org/a/7z1900.exe" -o "%cd%\7z1900.exe"
)
IF EXIST "%cd%\7z1900.exe" (
  echo Installing 7-zip...
  7z1900.exe /SILENT
) ELSE (
  echo Could not find 7-zip...
  START http://www.7-zip.org/
)

IF NOT EXIST "%cd%\innosetup-6.0.5.exe" (
  echo Downloading Inno Setup...
  %CURL% "https://files.jrsoftware.org/is/6/innosetup-6.0.5.exe" -o "%cd%\innosetup-6.0.5.exe"
)
IF EXIST "%cd%\innosetup-6.0.5.exe" (
  echo Installing InnoSetup...
  innosetup-6.0.5.exe /SILENT
) ELSE (
  echo Could not find InnoSetup...
  START http://www.jrsoftware.org/isdl.php
)

IF NOT EXIST "%cd%\python-3.8.5.exe" (
  echo Downloading Python 3.8.5...
  %CURL% "https://www.python.org/ftp/python/3.8.5/python-3.8.5.exe" -o "%cd%\python-3.8.5.exe"
)
IF EXIST "%cd%\python-3.8.5.exe" (
  echo Installing Python 3.8.5...
  python-3.8.5.exe /passive InstallAllUsers=1 PrependPath=1 TargetDir="%PF32%"\Python38
) ELSE (
  echo Could not find Python 3.8.5...
  START https://www.python.org/downloads/release/python-385/
)

REM IF NOT EXIST "%cd%\dotNetFx35setup.exe" (
REM echo Downloading Microsoft .NET Framework 3.5...
REM   %CURL% "https://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe" -o "%cd%\dotNetFx35setup.exe"
REM )
REM IF EXIST "%cd%\dotNetFx35setup.exe" (
REM   echo Installing Microsoft .NET Framework 3.5...
REM   dotNetFx35setup.exe /SILENT
REM ) ELSE (
REM   echo Could not find Microsoft .NET Framework 3.5...
REM   START http://www.microsoft.com/en-us/download/details.aspx?id=21
REM )

REM IF NOT EXIST "%cd%\VCForPython27.msi" (
REM echo Downloading Visual C++ For Python27...
REM   %CURL% "https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi" -o "%cd%\VCForPython27.msi"
REM )
REM IF EXIST "%cd%\VCForPython27.msi" (
REM   echo Installing Visual C++ For Python27...
REM   VCForPython27.msi /PASSIVE
REM ) ELSE (
REM   echo Could not find Visual C++ For Python27...
REM   START http://www.microsoft.com/en-us/download/details.aspx?id=44266
REM )

echo You need to have Microsoft VisualStudio C++ Build Tools installed
START https://visualstudio.microsoft.com/visual-cpp-build-tools/

echo Now run build_packages.bat
