#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:/usr/libexec/git-core/:$PATH

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
brew install curl
brew link --overwrite curl
brew install ruby
brew link --overwrite ruby
brew install git
brew link --overwrite git
#brew install gcc
#brew link --overwrite gcc
