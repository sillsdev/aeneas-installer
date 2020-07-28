@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

set CURDIR=%CD%

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

IF EXIST "%PF32%\Inno Setup 6" GOTO INNO6PATH
:INNO5PATH
  set INNOPATH=%PF32%\Inno Setup 5
  (call )
  GOTO INNOENDIF
:INNO6PATH
  set INNOPATH=%PF32%\Inno Setup 6
  (call )
:INNOENDIF

IF EXIST "%PF64%\Git\usr\bin" GOTO SETGITPATH
:LOCALGITPATH
	set cat="cat.exe"
	set cut="cut.exe"
	set sed="sed.exe"
	set grep="grep.exe"
  (call )
  GOTO ENDGITPATH
:SETGITPATH
	set cat="%PF64%\Git\usr\bin\cat.exe"
	set cut="%PF64%\Git\usr\bin\cut.exe"
	set sed="%PF64%\Git\usr\bin\sed.exe"
	set grep="%PF64%\Git\usr\bin\grep.exe"
  (call )
:ENDGITPATH

set PATH=%PATH%;%PF64%\FFmpeg\bin;%PF64%\eSpeak NG;%PF64%\Python38;%PF64%\Python38\Scripts;%PF64%\Git\usr\bin;%PF64%\Git\mingw64\bin

echo.
echo Finding package versions
FOR /F "tokens=* USEBACKQ" %%F IN (`ffmpeg -version ^| %grep% version -m 1 ^| %cut% -d' ' -f3`) DO (SET ffmpeg_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`espeak-ng --version ^| %cut% -d':' -f2 ^| %cut% -d' ' -f2`) DO (SET espeak_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python --version ^| %cut% -d' ' -f2`) DO (SET python_ver=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`pip show pip ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET pip_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`pip show aeneas ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET aeneas_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`pip show numpy ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET numpy_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`pip show lxml ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET lxml_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`pip show beautifulsoup4 ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET bs4_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`pip show soupsieve ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET soupsieve_ver=%%F)

echo.
echo Finding package files
FOR /F "tokens=* USEBACKQ" %%F IN (`dir espeak-ng-*.exe /b`) DO (SET espeak_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir ffmpeg-*.exe /b`) DO (SET ffmpeg_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-*.exe /b`) DO (SET python_file=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`dir pip-%pip_ver%*.whl /b`) DO (SET pip_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-%aeneas_ver%*.whl /b`) DO (SET aeneas_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir numpy-%numpy_ver%*.whl /b`) DO (SET numpy_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir lxml-%lxml_ver%*.whl /b`) DO (SET lxml_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir beautifulsoup4-%bs4_ver%*.whl /b`) DO (SET bs4_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir soupsieve-%soupsieve_ver%*.whl /b`) DO (SET soupsieve_file=%%F)

echo.
echo Parsing templages
REM echo "%cat% install_packages_TEMPLATE.bat | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > install_packages.bat"
REM echo "%cat% Aeneas_Installer_TEMPLATE.iss | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > Aeneas_Installer.iss"
%cat% install_packages_TEMPLATE.bat | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > install_packages.bat
%cat% Aeneas_Installer_TEMPLATE.iss | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[ESPEAK_VER\]/'%espeak_ver%'/g' | %sed% -e 's/\[ESPEAK_FILE\]/'%espeak_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > Aeneas_Installer.iss

copy /b/v/y libespeak-ng-dll2lib-x64\libespeak-ng.lib espeak-ng.lib

"%INNOPATH%\ISCC.exe" Aeneas_Installer.iss

ENDLOCAL
