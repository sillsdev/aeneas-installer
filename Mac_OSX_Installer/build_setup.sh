#!/bin/bash

export PATH=/usr/libexec/git-core/:$PATH
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

CURDIR=`dirname $0`
cd $CURDIR

#HOMEBREW_BUILD_FROM_SOURCE=true

echo Attempting to install Xcode Command Line Tools
pkgutil --pkgs | grep com.apple | grep CL | grep Tools >/dev/null 2>&1 || ./install_xcode_cl_tools.sh
xcodebuild -license 2>/dev/null

touch $HOME/.bash_profile
if [ ! -n "$(grep 'PATH=/usr/local/bin:/usr/local/sbin:$PATH' $HOME/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

echo Installing homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap danielbair/tap
echo Running brew update
brew update
brew install brew-pkg
brew install gettext
brew install ruby
brew link ruby

mkdir -p $HOME/Library/Python/2.7/lib/python/site-packages
touch $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
if [ ! -n "$(grep '/usr/local/lib/python2.7/site-packages' $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth)" ]; then
	echo 'import sys; sys.path.insert(1, "/usr/local/lib/python2.7/site-packages")' >> $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
fi

if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	brew cask install packages
fi

echo -e "\n\nNow run build_packages.sh\n\n"
