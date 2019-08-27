#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

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

chown -R $USER:admin /usr/local/*
pip3 install -U /usr/local/share/aeneas_tools/aeneas-*.whl
chown -R $USER:admin /usr/local/*

osascript <<END
tell application "Terminal"
        set newTab to do script "aeneas_check_setup; exit"
        activate
        set current settings of newTab to settings set "Pro"
        set theWindow to first window of (every window whose tabs contains newTab)
        set windowId to theWindow's id
        delay 5
        try
                close (every window whose tabs contains newTab)
        end try
end tell
tell application "Installer"
        activate
end tell
END

