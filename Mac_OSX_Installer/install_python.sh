#!/bin/bash

TMPDIR="/Users/Shared/"
unzip -d "$TMPDIR" /Users/Shared/python-2.7.11-macosx10.6.pkg.zip
rm -f /Users/Shared/python-2.7.11-macosx10.6.pkg.zip
sudo installer -target / -pkg "$TMPDIR"/python-2.7.11-macosx10.6.pkg
export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH

if [ ! -n "$(grep 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' ~/.bash_profile)" ]; then
        touch $HOME/.bash_profile
        echo 'export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin:$PATH' >> $HOME/.bash_profile
        chown $USER $HOME/.bash_profile
fi
