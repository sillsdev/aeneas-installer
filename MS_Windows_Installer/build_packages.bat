@echo off

C:\Python27\python -m pip download pip
C:\Python27\python -m pip download beautifulsoup4
C:\Python27\python -m pip download lxml
C:\Python27\python -m pip download numpy==1.10.1
C:\Python27\python -m pip download aeneas


7z.exe x numpy-1.10.1.zip -aoa
cd numpy-1.10.1
python setup.py bdist_wheel
copy dist\numpy-1.10.1-cp27-cp27m-win32.whl ..\
cd ..

C:\Python27\python -m pip install numpy-1.10.1-cp27-cp27m-win32.whl

7z.exe e aeneas-1.5.0.3.tar.gz -aoa
7z.exe x aeneas-1.5.0.3.tar -aoa
cd aeneas-1.5.0.3
python setup.py bdist_wheel
copy dist\aeneas-1.5.0.3-cp27-cp27m-win32.whl ..\
cd ..

7z.exe x ffmpeg-latest-win32-static.7z -aoa
move /y ffmpeg-20160614-*-win32-static ffmpeg-3.0.2

ISCC.exe FFmpeg_Installer.iss

ISCC.exe Aeneas_Installer.iss

