#!/bin/bash

CURDIR="/Users/Shared/"
unzip -d "$CURDIR" /Users/Shared/python-2.7.11-macosx10.6.pkg.zip
rm -f /Users/Shared/python-2.7.11-macosx10.6.pkg.zip
sudo installer -target / -pkg "$CURDIR"/python-2.7.11-macosx10.6.pkg
export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH

pip install -U pip
pip install -U setuptools

if [ ! -n "$(grep 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' ~/.bash_profile)" ]; then
        touch $HOME/.bash_profile
        echo 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' >> $HOME/.bash_profile
        chown $USER $HOME/.bash_profile
fi
