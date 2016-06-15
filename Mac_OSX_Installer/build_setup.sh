#!/bin/bash

xcode-select --install
sudo xcodebuild -license

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew update
brew install wget
brew install curl
<<<<<<< Updated upstream
=======
#brew link curl
>>>>>>> Stashed changes
brew install ffmpeg
brew install espeak
brew install pkg-config
brew install xz
brew install gettext
brew install texi2html
brew install yasm
brew install markdown
brew tap timsutton/formulae
brew install brew-pkg
brew install ruby
brew link ruby

sudo /usr/local/bin/gem install fpm

#/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python
if [ ! -f "/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python" ]; then
	curl -fsSL -O https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
	sudo installer -target / -pkg python-2.7.11-macosx10.6.pkg
fi

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
