#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

zip -v python-2.7.11-macosx10.6.pkg.zip python-2.7.11-macosx10.6.pkg
# brew pkg --with-deps --scripts python # fails to build a working package for now...
brew pkg --with-deps ffmpeg
brew pkg --with-deps --scripts espeak_install_scripts espeak
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg BeautifulSoup4
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg lxml
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg numpy
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg --post-install aeneas_install_scripts/postinstall aeneas

curl -fsSL https://raw.githubusercontent.com/readbeyond/aeneas/master/README.md | markdown > Aeneas_Readme.html

packagesbuild -v Aeneas_Installer.pkgproj

open -R ./Aeneas_Installer.mpkg
