#!/bin/bash

export PATH="/opt/usr/bin:/opt/usr/sbin:$PATH"

touch $HOME/.bash_profile
if [ ! -n "$(grep '^export PATH"=/opt/usr/bin:/opt/usr/sbin:' $HOME/.bash_profile)" ]; then
	echo 'export PATH="/opt/usr/bin:/opt/usr/sbin:$PATH"' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

python3 -m pip install -U /opt/usr/share/aeneas_tools/aeneas-*.whl

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

