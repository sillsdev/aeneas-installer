@echo off

2>nul curl.exe --version
if %ERRORLEVEL%==0 goto exeCurl
  set CURL=call curl.bat
  goto endIf
:exeCurl
  set CURL=curl.exe
:endIf

IF NOT EXIST "%cd%\7z1602.exe" (
  echo Downloading 7-zip... 
  %CURL% -L "http://www.7-zip.org/a/7z1602.exe" -o "%cd%\7z1602.exe"
)
IF EXIST "%cd%\7z1602.exe" (
  echo Installing 7-zip...
  7z1602.exe
) ELSE (
  echo Could not find 7-zip...
  START http://www.7-zip.org/
)

IF NOT EXIST "%cd%\innosetup-5.5.9-unicode.exe" (
  echo Downloading Inno Setup...
  %CURL% -L "http://www.jrsoftware.org/download.php/is-unicode.exe" -o "%cd%\innosetup-5.5.9-unicode.exe"
)
IF EXIST "%cd%\innosetup-5.5.9-unicode.exe" (
  echo Installing InnoSetup...
  innosetup-5.5.9-unicode.exe /SILENT
) ELSE (
  echo Could not find InnoSetup...
  START http://www.jrsoftware.org/isdl.php
)

IF NOT EXIST "%cd%\python-2.7.11.msi" (
  echo Downloading Python 2.7.11...
  %CURL% -L "https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi" -o "%cd%\python-2.7.11.msi"
)
IF EXIST "%cd%\python-2.7.11.msi" (
  echo Installing Python 2.7.11...
  python-2.7.11.msi /PASSIVE
) ELSE (
  echo Could not find Python 2.7.11...
  START https://www.python.org/downloads/release/python-2711/
)

IF NOT EXIST "%cd%\VCForPython27.msi" (
echo Downloading Visual C++ For Python27...
  %CURL% -L "https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi" -o "%cd%\VCForPython27.msi"
)
IF EXIST "%cd%\VCForPython27.msi" (
  echo Installing Visual C++ For Python27...
  VCForPython27.msi /PASSIVE
) ELSE (
  echo Could not find Visual C++ For Python27...
  START http://www.microsoft.com/en-us/download/details.aspx?id=44266
)

IF NOT EXIST "%cd%\dotNetFx35setup.exe" (
echo Downloading Microsoft .NET Framework 3.5...
  %CURL% -L "https://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe" -o "%cd%\dotNetFx35setup.exe"
)
IF EXIST "%cd%\dotNetFx35setup.exe" (
  echo Installing Microsoft .NET Framework 3.5...
  dotNetFx35setup.exe /SILENT
) ELSE (
  echo Could not find Microsoft .NET Framework 3.5...
  START http://www.microsoft.com/en-us/download/details.aspx?id=21
)

echo Now run build_packages.bat
