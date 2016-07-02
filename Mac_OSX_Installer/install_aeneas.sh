#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

python -m ensurepip
echo -e "y\r" | pip -q uninstall aeneas
pip install /Users/Shared/aeneas-1.5.0.3-cp27-cp27m-macosx_10_6_intel.whl

sudo ln -fs /Library/Frameworks/Python.framework/Versions/2.7/bin/aeneas* /usr/local/bin/

if [ ! -n "$(grep 'export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH' ~/.bash_profile)" ]; then
        touch $HOME/.bash_profile
        echo 'export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH' >> $HOME/.bash_profile
        chown $USER $HOME/.bash_profile
fi

osascript <<END 
tell application "Terminal"
        activate
        set newTab to do script "aeneas_check_setup; exit"
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

