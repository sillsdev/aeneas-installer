@echo off

IF NOT EXIST "%cd%\7z1602.exe" (
  echo Downloading 7-zip... 
  call:myCurl 'http://www.7-zip.org/a/7z1602.exe' '%cd%\7z1602.exe'
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
  call:myCurl 'http://www.jrsoftware.org/download.php/is-unicode.exe' '%cd%\innosetup-5.5.9-unicode.exe'
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
  call:myCurl 'https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi' '%cd%\python-2.7.11.msi'
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
  call:myCurl 'https://download.microsoft.com/download/7/9/6/796EF2E4-801B-4FC4-AB28-B59FBF6D907B/VCForPython27.msi' '%cd%\VCForPython27.msi'
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
  call:myCurl 'https://download.microsoft.com/download/7/0/3/703455ee-a747-4cc8-bd3e-98a615c3aedb/dotNetFx35setup.exe' '%cd%\dotNetFx35setup.exe'
)
IF EXIST "%cd%\dotNetFx35setup.exe" (
  echo Installing Microsoft .NET Framework 3.5...
  dotNetFx35setup.exe /SILENT
) ELSE (
  echo Could not find Microsoft .NET Framework 3.5...
  START http://www.microsoft.com/en-us/download/details.aspx?id=21
)


goto:eof


:myCurl
2>nul curl --version
if %ERRORLEVEL%==0 goto runCurl
  powershell "(new-object System.Net.WebClient).DownloadFile(%~1, %~2)"
  echo Saved %~2
  goto endIf
:runCurl
  curl '%~1' -o '%~2'
:endIf