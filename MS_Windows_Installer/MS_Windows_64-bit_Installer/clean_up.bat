@echo off
del /q aeneas-win-installer-packages\*
del /q python-wheels\*
rmdir /s /q numpy-*
rmdir /s /q aeneas-*
rmdir /s /q espeak-*
rmdir /s /q ffmpeg-*
rmdir /s /q python-*
del *.tar*
del *.zip
del *.whl
del *.exe
del *.msi
del *.7z

