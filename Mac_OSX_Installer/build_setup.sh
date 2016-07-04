#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH

xcode-select --install
xcodebuild -license

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
if [ ! -n "$(grep 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' ~/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

brew update
brew install xz
brew install gettext
brew install pkg-config
brew install texi2html
brew install yasm
brew tap timsutton/formulae
brew tap danielbair/tap
brew update
brew install brew-pkg
#brew install ruby
#brew link ruby
#sudo gem install fpm

if [ ! -f "/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python" ]; then
	curl -fSL -O https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
	sudo installer -target / -pkg python-2.7.11-macosx10.6.pkg
fi

if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	curl -fSL -O http://s.sudre.free.fr/Software/files/Packages.dmg
	hdiutil attach Packages.dmg
	sudo installer -target / -pkg /Volumes/Packages\ */packages/Packages.pkg
	hdiutil eject /Volumes/Packages\ */
fi

echo -e "\nNow run build_packages.sh"
