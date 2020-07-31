echo on
python.exe -m pip show wget 1>nul 2>nul
if %ERRORLEVEL%==1 (
  python.exe -m pip install -U wget
)
python.exe -m wget -o "%4" %2
@echo off
