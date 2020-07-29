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

set PATH=%INNOPATH%;%PFSZ%\7-Zip;%PF32%\FFmpeg\bin;%PF32%\eSpeak NG;%PF32%\Python38;%PF32%\Python38\Scripts;%PF32%\Git;%PF32%\Git\usr\bin;%PF32%\Git\mingw32\bin;%PATH%

curl.exe --version 1>nul 2>nul
if %ERRORLEVEL%==1 (
  set CURL=call curl-psh.bat -L
) else (
  set CURL=curl.exe -L
)

set cat="cat.exe"
set cut="cut.exe"
set sed="sed.exe"
set grep="grep.exe"

echo.
echo Finding package versions
FOR /F "tokens=* USEBACKQ" %%F IN (`ffmpeg -version ^| %grep% version -m 1 ^| %cut% -d' ' -f3`) DO (SET ffmpeg_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`espeak-ng --version ^| %cut% -d':' -f2 ^| %cut% -d' ' -f2`) DO (SET espeak_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python --version ^| %cut% -d' ' -f2`) DO (SET python_ver=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`python -m pip show pip ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET pip_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python -m pip show aeneas ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET aeneas_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python -m pip show numpy ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET numpy_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python -m pip show lxml ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET lxml_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python -m pip show beautifulsoup4 ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET bs4_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python -m pip show soupsieve ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET soupsieve_ver=%%F)

echo.
echo Finding package files
FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-win-installer-packages\espeak-ng-*.msi /b`) DO (SET espeak_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-win-installer-packages\ffmpeg-*.exe /b`) DO (SET ffmpeg_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-win-installer-packages\python-*.exe /b`) DO (SET python_file=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-wheels\pip-%pip_ver%*.whl /b`) DO (SET pip_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-wheels\aeneas-%aeneas_ver%*.whl /b`) DO (SET aeneas_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-wheels\numpy-%numpy_ver%*.whl /b`) DO (SET numpy_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-wheels\lxml-%lxml_ver%*.whl /b`) DO (SET lxml_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-wheels\beautifulsoup4-%bs4_ver%*.whl /b`) DO (SET bs4_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-wheels\soupsieve-%soupsieve_ver%*.whl /b`) DO (SET soupsieve_file=%%F)

echo.
echo Parsing templates
REM echo "%cat% install_packages_TEMPLATE.bat | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > install_packages.bat"
REM echo "%cat% Aeneas_Installer_TEMPLATE.iss | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > Aeneas_Installer.iss"

%cat% install_packages_TEMPLATE.bat | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > install_packages.bat
%cat% Aeneas_Installer_TEMPLATE.iss | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > Aeneas_Installer.iss

copy /b/v/y libespeak-ng-dll2lib-x86\libespeak-ng.lib espeak-ng.lib

"%INNOPATH%\ISCC.exe" Aeneas_Installer.iss

ENDLOCAL
