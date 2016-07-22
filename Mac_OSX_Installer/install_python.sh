#!/bin/bash

CURDIR="/Users/Shared/"
cd $CURDIR
unzip -o python-2.7.11-macosx10.6.pkg.zip
rm -f python-2.7.11-macosx10.6.pkg.zip
sudo installer -target / -pkg python-2.7.11-macosx10.6.pkg
export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH

python -m ensurepip 2> /dev/null
pip install -U pip setuptools wheel

if [ ! -n "$(grep 'PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' ~/.bash_profile)" ]; then
        touch $HOME/.bash_profile
        echo 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' >> $HOME/.bash_profile
        chown $USER $HOME/.bash_profile
fi
