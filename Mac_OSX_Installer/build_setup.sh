#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH

xcode-select --install
xcodebuild -license

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
if [ ! -n "$(grep 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' ~/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

if [ ! -f "/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python" ]; then
	echo Downloading https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
	curl -# -fSL -O https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
	echo Installing python-2.7.11-macosx10.6.pkg
	sudo installer -target / -pkg python-2.7.11-macosx10.6.pkg
	if [ ! -n "$(grep 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' ~/.bash_profile)" ]; then
		touch $HOME/.bash_profile
		echo 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' >> $HOME/.bash_profile
		chown $USER $HOME/.bash_profile
	fi
fi

if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	echo Downloading http://s.sudre.free.fr/Software/files/Packages.dmg
	curl -# -fSL -O http://s.sudre.free.fr/Software/files/Packages.dmg
	hdiutil attach Packages.dmg
	Installing Packages.pkg
	sudo installer -target / -pkg /Volumes/Packages\ */packages/Packages.pkg
	hdiutil eject /Volumes/Packages\ */
fi

echo Installing homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo brew update
brew update
brew tap timsutton/formulae
brew tap danielbair/tap
brew update
brew install brew-pkg
#brew install ruby
#brew link ruby
#sudo gem install fpm

echo -e "\n\nNow run build_packages.sh\n\n"
