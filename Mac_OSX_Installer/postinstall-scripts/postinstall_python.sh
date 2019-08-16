#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

#python -m ensurepip 2> /dev/null
#pip install -U pip setuptools wheel

mkdir -p $HOME/Library/Python/2.7/lib/python/site-packages
touch $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
if [ ! -n "$(grep '/usr/local/lib/python2.7/site-packages' $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth)" ]; then
	echo 'import sys; sys.path.insert(1, "/usr/local/lib/python2.7/site-packages")' >> $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
fi

touch $HOME/.bash_profile
if [ ! -n "$(grep 'PATH=/usr/local/bin:/usr/local/sbin:$PATH' $HOME/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

mkdir -p /usr/local/Cellar/python@2/2.7.16/Frameworks/
ln -s /usr/local/Frameworks/Python.framework /usr/local/Cellar/python@2/2.7.16/Frameworks/
mkdir -p /usr/local/opt/python@2
ln -s /usr/local/bin /usr/local/opt/python@2
mkdir -p /usr/local/opt/
ln -s /usr/local/Cellar/python@2/2.7.16 /usr/local/opt/python
mkdir -p /usr/local/opt/python
ln -s /usr/local/opt/python/Frameworks/Python.framework/Versions/Current/bin /usr/local/opt/python/

chown -R $USER:admin /usr/local/*
