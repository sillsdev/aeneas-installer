#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

touch $HOME/.bash_profile
if [ ! -n "$(grep 'PATH=/usr/local/bin:/usr/local/sbin:$PATH' $HOME/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

mkdir -p $HOME/Library/Python/2.7/lib/python/site-packages
touch $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
if [ ! -n "$(grep '/usr/local/lib/python2.7/site-packages' $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth)" ]; then
	echo 'import sys; sys.path.insert(1, "/usr/local/lib/python2.7/site-packages")' >> $HOME/Library/Python/2.7/lib/python/site-packages/homebrew.pth
fi

mkdir -p /usr/local/Cellar/python/
ln -s /usr/local/Frameworks/Python.framework/Versions/3.7/ /usr/local/Cellar/python/3.7.4
ln -s /usr/local/Frameworks /usr/local/Cellar/python/3.7.4/
mkdir -p /usr/local/opt
ln -s /usr/local/Frameworks/Python.framework/Versions/3.7 /usr/local/opt/python
#cp /usr/local/opt/python/libexec/bin/* /usr/local/bin/
ln -s /usr/local/Frameworks/Python.framework/Versions/3.7 /usr/local/Frameworks/Python.framework/Versions/Current
rm -f /usr/local/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages
ln -s /usr/local/lib/python3.7/site-packages /usr/local/Frameworks/Python.framework/Versions/3.7/lib/python3.7/

chown -R $USER:admin /usr/local/*
python3 -m ensurepip 2> /dev/null
chown -R $USER:admin /usr/local/*
cp /Volumes/Aeneas_Tools/aeneas-mac-installer-packages/pip-*.whl /usr/local/share/aeneas_tools/
pip3 install -U /usr/local/share/aeneas_tools/pip-*.whl
chown -R $USER:admin /usr/local/*

