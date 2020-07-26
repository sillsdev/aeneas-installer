@echo off

2>nul curl.exe --version
if %ERRORLEVEL%==0 goto exeCurl
  set CURL=call curl.bat -L
  goto endIf
:exeCurl
  set CURL=curl.exe -L
:endIf

IF NOT EXIST "%cd%\7z1900-x64.exe" (
  echo Downloading 7-zip... 
  %CURL% "https://www.7-zip.org/a/7z1900-x64.exe" -o "%cd%\7z1900-x64.exe"
)
IF EXIST "%cd%\7z1900-x64.exe" (
  echo Installing 7-zip...
  7z1900-x64.exe
) ELSE (
  echo Could not find 7-zip...
  START http://www.7-zip.org/
)

IF NOT EXIST "%cd%\innosetup-6.0.5.exe" (
  echo Downloading Inno Setup...
  %CURL% "http://www.jrsoftware.org/download.php/is.exe" -o "%cd%\innosetup-6.0.5.exe"
)
IF EXIST "%cd%\innosetup-6.0.5.exe" (
  echo Installing InnoSetup...
  innosetup-6.0.5.exe /SILENT
) ELSE (
  echo Could not find InnoSetup...
  START http://www.jrsoftware.org/isdl.php
)

IF NOT EXIST "%cd%\dotNetFx35setup.exe" (
echo Downloading Microsoft .NET Framework 3.5...
  %CURL% "https://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe" -o "%cd%\dotNetFx35setup.exe"
)
IF EXIST "%cd%\dotNetFx35setup.exe" (
  echo Installing Microsoft .NET Framework 3.5...
  dotNetFx35setup.exe /SILENT
) ELSE (
  echo Could not find Microsoft .NET Framework 3.5...
  START http://www.microsoft.com/en-us/download/details.aspx?id=21
)

IF NOT EXIST "%cd%\python-3.8.5-amd64.exe" (
  echo Downloading Python 3.8.5...
  %CURL% "https://www.python.org/ftp/python/3.8.5/python-3.8.5-amd64.exe" -o "%cd%\python-3.8.5-amd64.exe"
)
IF EXIST "%cd%\python-3.8.5-amd64.exe" (
  echo Installing Python 3.8.5...
  python-3.8.5-amd64.exe /passive InstallAllUsers=1 TargetDir=C:\Python38 PrependPath=1
) ELSE (
  echo Could not find Python 3.8.5...
  START https://www.python.org/downloads/release/python-385/
)

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

IF NOT EXIST "%cd%\Git-2.27.0-64-bit.exe" (
echo Downloading Git for Windows...
  %CURL% "https://github.com/git-for-windows/git/releases/download/v2.27.0.windows.1/Git-2.27.0-64-bit.exe" -o "%cd%\Git-2.27.0-64-bit.exe"
)
IF EXIST "%cd%\Git-2.27.0-64-bit.exe" (
  echo Installing Git for Windows...
  Git-2.27.0-64-bit.exe /SILENT
) ELSE (
  echo Could not find Git for Windows 2.27.0...
  START https://git-scm.com/download/win
)

REM https://www.exemsi.com/downloads/msi_wrapper/MSI_Wrapper_9_0_35_0.msi

echo Now run build_packages.bat
