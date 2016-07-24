#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

touch $HOME/.bash_profile
if [ ! -n "$(grep 'PATH=/usr/local/bin:/usr/local/sbin:$PATH' $HOME/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi
