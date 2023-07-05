@echo off

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
  set PF32=C:\Program Files
  (call )
  GOTO WIN32PATH
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:WIN32PATH

set PATH=%PF64%\Python39\;%PF64%\Python39\Scripts;%PF64%\eSpeak NG;%PF64%\FFmpeg\bin;%PATH%

echo Copying espeak-ng.exe to espeak.exe
copy /b/v/y "%PF64%\eSpeak NG\espeak-ng.exe" "%PF64%\eSpeak NG\espeak.exe"
echo Copying espeak-ng.lib to %PF64%\Python39\libs\
copy /b/v/y "espeak-ng.lib" "%PF64%\Python39\libs\"

python -m ensurepip
REM python -m pip install -U 
python -m pip install -U numpy-1.25.0-cp39-cp39-win_amd64.whl
python -m pip install -U lxml-4.9.2-cp39-cp39-win_amd64.whl
python -m pip install -U soupsieve-2.4.1-py3-none-any.whl
python -m pip install -U beautifulsoup4-4.12.2-py3-none-any.whl
python -m pip install -U aeneas-1.7.3.0-cp39-cp39-win_amd64.whl

echo Copying libespeak-ng.dll to %PF64%\Python39\Lib\site-packages\aeneas\cew
copy /b/v/y "%PF64%\eSpeak NG\libespeak-ng.dll" "%PF64%\Python39\Lib\site-packages\aeneas\cew"
