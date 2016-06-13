#!/bin/bash

xcode-select --install
sudo xcodebuild -license

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update

brew install curl
brew install wget
brew install ffmpeg
brew install espeak
brew install pkg-config
brew install xz
brew install gettext
brew install texi2thml
brew install yams

curl -fsSL -O https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
sudo installer -target / -pkg python-2.7.11-macosx10.6.pkg

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
if [ ! -n "$(grep 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' ~/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

pip install --upgrade pip

pip install BeautifulSoup4
pip install lxml
pip install numpy
pip install aeneas

sudo ln -fs /Library/Frameworks/Python.framework/Versions/2.7/bin/aeneas* /usr/local/bin/
aeneas_check_setup

brew tap timsutton/formulae
brew install brew-pkg
brew install ruby
brew link ruby
gem install fpm

#brew pkg --with-deps --scripts python #fails to build a working package
brew pkg --with-deps ffmpeg
brew pkg --with-deps --scripts espeak_install_scripts espeak
fpm -f --verbose --python-pip=/usr/local/bin/pip -s python -t osxpkg BeautifulSoup4
fpm -f --verbose --python-pip=/usr/local/bin/pip -s python -t osxpkg lxml
fpm -f --verbose --python-pip=/usr/local/bin/pip -s python -t osxpkg numpy
fpm -f --verbose --python-pip=/usr/local/bin/pip -s python -t osxpkg --post-install aeneas_install_scripts/postinstall aeneas

curl -fsSL -O http://s.sudre.free.fr/Software/files/Packages.dmg
open Packages.dmg
