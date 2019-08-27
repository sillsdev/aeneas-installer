#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

touch $HOME/.bash_profile
if [ ! -n "$(grep 'PATH=/usr/local/bin:/usr/local/sbin:$PATH' $HOME/.bash_profile)" ]; then
	touch $HOME/.bash_profile
	echo 'export PATH=/usr/local/bin:/usr/local/sbin:$PATH' >> $HOME/.bash_profile
	chown $USER $HOME/.bash_profile
fi

#mkdir -p /usr/local/Cellar/espeak/1.48.04_1/lib/
#ln -s /usr/local/lib/libespeak.* /usr/local/Cellar/espeak/1.48.04_1/lib/
#mkdir -p /usr/local/opt/
#ln -s /usr/local/Cellar/espeak/1.48.04_1 /usr/local/opt/espeak

chown -R $USER:admin /usr/local/*

