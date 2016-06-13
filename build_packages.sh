#!/bin/bash

brew tap timsutton/formulae
brew install brew-pkg
brew install ruby
brew link ruby
gem install fpm

#brew pkg --with-deps --scripts python #fails to build a working package
zip -v python-2.7.11-macosx10.6.pkg.zip python-2.7.11-macosx10.6.pkg
brew pkg --with-deps ffmpeg
brew pkg --with-deps --scripts espeak_install_scripts espeak
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg BeautifulSoup4
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg lxml
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg numpy
fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg --post-install aeneas_install_scripts/postinstall aeneas

#/usr/local/bin/packagesbuild
if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	curl -fsSL -O http://s.sudre.free.fr/Software/files/Packages.dmg
	#open Packages.dmg
	hdiutil attach Packages.dmg
	sudo installer -target / -pkg /Volumes/Packages\ 1.1.3/packages/Packages.pkg
	hdiutil eject /Volumes/Packages\ 1.1.3/
fi

brew install markdown
curl -fsSL https://raw.githubusercontent.com/readbeyond/aeneas/master/README.md | markdown > Aeneas_Readme.html

mkdir ../../build
#open Aeneas_Installer.pkgproj
packagesbuild -v Aeneas_Installer.pkgproj
open -R ../../build/Aeneas_Installer.mpkg

