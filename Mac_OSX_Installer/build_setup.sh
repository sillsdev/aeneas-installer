#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
echo cd $CURDIR
cd $CURDIR

echo Attempting to install Xcode Command Line Tools
xcode-select --install > /dev/null 2>&1
read -p "Press [Enter] key to continue after Xcode Command Line Tools has been installed."
echo You will need to accept the license agreement if prompted
xcodebuild -license 2> /dev/null

touch $HOME/.bash_profile
if [ ! -n "$(grep 'PATH=/usr/local/bin:/usr/local/sbin:$PATH' $HOME/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

echo Installing homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#brew tap timsutton/formulae
brew tap danielbair/tap
echo Running brew update
brew update
brew install brew-pkg
brew install brew-cask
brew install ruby
brew link ruby
#sudo gem install fpm

mkdir -p $HOME/Library/Python/2.7/lib/python/site-packages
touch $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
if [ ! -n "$(grep '/usr/local/lib/python2.7/site-packages' $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth)" ]; then
	echo 'import sys; sys.path.insert(1, "/usr/local/lib/python2.7/site-packages")' >> $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
fi

if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	brew cask install packages
fi

echo -e "\n\nNow run build_packages.sh\n\n"
