#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

pip install --upgrade pip
pip install --upgrade wheel
pip install beautifulsoup4==4.4.1
pip install lxml==3.6.0
pip install numpy==1.10.1
pip install aeneas==1.5.0.3

pip download pip==8.1.2
pip download beautifulsoup4==4.4.1
pip download lxml==3.6.0
pip download numpy==1.10.1
pip download aeneas==1.5.0.3

zip -v python-2.7.11-macosx10.6.pkg.zip python-2.7.11-macosx10.6.pkg
# brew pkg --with-deps --scripts python # fails to build a working package for now...
brew pkg --with-deps ffmpeg
brew pkg --with-deps --scripts espeak_install_scripts espeak
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg beautifulsoup4
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg lxml
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg numpy
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg --post-install aeneas_install_scripts/postinstall aeneas

packagesbuild -v Aeneas_Installer.pkgproj

