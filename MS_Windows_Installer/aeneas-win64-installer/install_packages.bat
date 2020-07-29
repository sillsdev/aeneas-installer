@echo off

IF EXIST "C:\Program Files (x86)" GOTO WIN64PATH
:WIN32PATH
  set PF32=C:\Program Files
  (call )
  GOTO ENDIFPATH
:WIN64PATH
  set PF64=C:\Program Files
  set PF32=C:\Program Files (x86)
  (call )
:ENDIFPATH

set PATH=%PF64%\Python38\;%PF64%\Python38\Scripts;%PF64%\eSpeak NG;%PF64%\FFmpeg\bin;%PATH%

echo Copying espeak-ng.exe to espeak.exe
copy /b/v/y "%PF64%\eSpeak NG\espeak-ng.exe" "%PF64%\eSpeak NG\espeak.exe"
echo Copying espeak-ng.lib to %PF64%\Python38\libs\
copy /b/v/y "espeak-ng.lib" "%PF64%\Python38\libs\"

python -m ensurepip
python -m pip install -U 
python -m pip install -U numpy-1.19.1-cp38-cp38-win_amd64.whl
python -m pip install -U lxml-4.5.2-cp38-cp38-win_amd64.whl
python -m pip install -U soupsieve-2.0.1-py3-none-any.whl
python -m pip install -U beautifulsoup4-4.9.1-py3-none-any.whl
python -m pip install -U aeneas-1.7.3.0-cp38-cp38-win_amd64.whl

echo Copying libespeak-ng.dll to %PF64%\Python38\Lib\site-packages\aeneas\cew
copy /b/v/y "%PF64%\eSpeak NG\libespeak-ng.dll" "%PF64%\Python38\Lib\site-packages\aeneas\cew"
