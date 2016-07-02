#!/bin/bash

read -s -p "Password:" password
echo

xcode-select --install
echo $password | sudo xcodebuild -license

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
if [ ! -n "$(grep 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' ~/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

brew update
brew install wget
brew install xz
brew install pkg-config
brew install gettext
brew install texi2html
brew install yasm
brew install markdown
brew tap timsutton/formulae
brew install brew-pkg
brew install ruby
brew link ruby

#echo $password | sudo -S gem install fpm

if [ ! -f "/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python" ]; then
	curl -fsSL -O https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
	echo $password | sudo -S installer -target / -pkg python-2.7.11-macosx10.6.pkg
fi

if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	curl -fsSL -O http://s.sudre.free.fr/Software/files/Packages.dmg
	#open Packages.dmg
	hdiutil attach Packages.dmg
	echo $password | sudo -S installer -target / -pkg /Volumes/Packages\ */packages/Packages.pkg
	hdiutil eject /Volumes/Packages\ */
fi

