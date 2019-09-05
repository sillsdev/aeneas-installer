#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:/usr/libexec/git-core/:$PATH

CURDIR=`dirname $0`
cd $CURDIR

./install_homebrew.sh

brew install git
echo Running brew update
brew update
brew tap danielbair/tap
brew install binutils wget jq
brew install danielbair/tap/brew-pkg
#brew install danielbair/tap/create-dmg
brew install create-dmg

mkdir -p $HOME/Library/Python/2.7/lib/python/site-packages
touch $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
if [ ! -n "$(grep '/usr/local/lib/python2.7/site-packages' $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth)" ]; then
	echo 'import sys; sys.path.insert(1, "/usr/local/lib/python2.7/site-packages")' >> $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
fi

if [ ! -f "/usr/local/bin/packagesbuild" ]; then
	brew cask install packages
	brew cask install homebrew/cask-versions/adoptopenjdk8
fi

echo -e "\n\nNow run build_packages.sh\n\n"

exit 0
