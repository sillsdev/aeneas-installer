@echo off
IF /i {%1}=={ECHO} ECHO ON&SHIFT

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions
IF NOT DEFINED VS90COMNTOOLS set VS90COMNTOOLS=%USERPROFILE%\AppData\Local\Programs\Common\Microsoft\Visual C++ for Python\9.0

set CURDIR=%CD%

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIF
:WIN64PATH
  set PF32=C:\Program Files (x86)
  (call )
:ENDIF

IF EXIST "%PF32%\Inno Setup 6" GOTO INNO6PATH
:INNO5PATH
  set INNOPATH=%PF32%\Inno Setup 5
  (call )
  GOTO ENDIF
:INNO6PATH
  set INNOPATH=%PF32%\Inno Setup 6
  (call )
:ENDIF

IF EXIST "C:\Program Files\Git\usr\bin" GOTO SETGITPATH
:LOCALPATH
	set cat="cat.exe"
	set cut="cut.exe"
	set sed="sed.exe"
	set grep="grep.exe"
  (call )
  GOTO ENDIF
:SETGITPATH
	set cat="C:\Program Files\Git\usr\bin\cat.exe"
	set cut="C:\Program Files\Git\usr\bin\cut.exe"
	set sed="C:\Program Files\Git\usr\bin\sed.exe"
	set grep="C:\Program Files\Git\usr\bin\grep.exe"
  (call )
:ENDIF

set pip=C:\Python37-32\Scripts\pip

FOR /F "tokens=* USEBACKQ" %%F IN (`ffmpeg -version ^| %grep% version -m 1 ^| %cut% -d' ' -f3`) DO (SET ffmpeg_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`python --version ^| %cut% -d' ' -f2`) DO (SET python_ver=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`dir setup_ffmpeg-*.exe /b`) DO (SET ffmpeg_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir python-*.exe /b`) DO (SET python_file=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`%pip% show pip ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET pip_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`%pip% show aeneas ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET aeneas_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`%pip% show numpy ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET numpy_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`%pip% show lxml ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET lxml_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`%pip% show beautifulsoup4 ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET bs4_ver=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`%pip% show soupsieve ^| %grep% Version ^| %cut% -d' ' -f2`) DO (SET soupsieve_ver=%%F)

FOR /F "tokens=* USEBACKQ" %%F IN (`dir pip-%pip_ver%*.whl /b`) DO (SET pip_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir aeneas-%aeneas_ver%*.whl /b`) DO (SET aeneas_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir numpy-%numpy_ver%*.whl /b`) DO (SET numpy_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir lxml-%lxml_ver%*.whl /b`) DO (SET lxml_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir beautifulsoup4-%bs4_ver%*.whl /b`) DO (SET bs4_file=%%F)
FOR /F "tokens=* USEBACKQ" %%F IN (`dir soupsieve-%soupsieve_ver%*.whl /b`) DO (SET soupsieve_file=%%F)

%cat% install_packages_TEMPLATE.bat | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > install_packages.bat
%cat% Aeneas_Installer_TEMPLATE.iss | %sed% -e 's/\[PIP_FILE\]/'%pip_file%'/g' | %sed% -e 's/\[FFMPEG_VER\]/'%ffmpeg_ver%'/g' | %sed% -e 's/\[FFMPEG_FILE\]/'%ffmpeg_file%'/g' | %sed% -e 's/\[PYTHON_VER\]/'%python_ver%'/g' | %sed% -e 's/\[PYTHON_FILE\]/'%python_file%'/g' | %sed% -e 's/\[NUMPY_VER\]/'%numpy_ver%'/g' | %sed% -e 's/\[NUMPY_FILE\]/'%numpy_file%'/g' | %sed% -e 's/\[LXML_VER\]/'%lxml_ver%'/g' | %sed% -e 's/\[LXML_FILE\]/'%lxml_file%'/g' | %sed% -e 's/\[BS4_VER\]/'%bs4_ver%'/g' | %sed% -e 's/\[BS4_FILE\]/'%bs4_file%'/g' | %sed% -e 's/\[SOUPSIEVE_VER\]/'%soupsieve_ver%'/g' | %sed% -e 's/\[SOUPSIEVE_FILE\]/'%soupsieve_file%'/g' | %sed% -e 's/\[AENEAS_VER\]/'%aeneas_ver%'/g' | %sed% -e 's/\[AENEAS_FILE\]/'%aeneas_file%'/g' > Aeneas_Installer.iss

"%INNOPATH%\ISCC.exe" Aeneas_Installer.iss

ENDLOCAL
