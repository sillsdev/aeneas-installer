#!/bin/bash

export PATH="/opt/usr/bin:/opt/usr/sbin:$PATH"

touch $HOME/.bash_profile
if [ ! -n "$(grep '^export PATH"=/opt/usr/bin:/opt/usr/sbin:' $HOME/.bash_profile)" ]; then
        echo 'export PATH="/opt/usr/bin:/opt/usr/sbin:$PATH"' >> $HOME/.bash_profile
        chown $USER $HOME/.bash_profile
fi

python3 -m pip install -U /opt/usr/share/aeneas_tools/lxml-*.whl

