This provides a simple installer for [Aeneas](https://github.com/readbeyond/aeneas) for Windows 7 and up.

To build this installer for Windows first download (and extract) or clone this repository.

Next you will need to download the files below (Save all downloaded files into this folder):
[7-Zip](http://www.7-zip.org/a/7z1602.exe)
[Inno Setup](http://www.jrsoftware.org/download.php/is-unicode.exe)
[Python-2.7.11](https://www.python.org/ftp/python/2.7.11/python-2.7.11.msi)
[VCforPython27](http://www.microsoft.com/en-us/download/confirmation.aspx?id=44266)
[eSpeak-1.48.04](http://sourceforge.net/projects/espeak/files/espeak/espeak-1.48/setup_espeak-1.48.04.exe)
[FFmpeg-3.0.2](https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.7z)

Then run *build\_setup.bat* which will install Python27 and the other applications for building.
Finally run *build\_packages.bat* which will then build all the packages and the main installer.
