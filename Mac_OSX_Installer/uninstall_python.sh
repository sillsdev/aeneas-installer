#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

#python -m ensurepip > /dev/null
#sudo -H pip uninstall -y setuptools

echo "Uninstalling python-2.7.11 packages..."

function pkgutil-rm {
	location=$(pkgutil --pkg-info $1 | grep "location:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	volume=$(pkgutil --pkg-info $1 | grep "volume:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	for file in `pkgutil --files $1`; do 
		if [[ $file != "///Users" && $file != "///Users/Shared" ]]; then
			sudo rm -v "$volume/$location/$file" 2> /dev/null 
		fi	
	done
	sudo pkgutil --forget $1
}

pkgs=`pkgutil --pkgs | grep "org.python"`
if [[ ! -z $pkgs ]]; then
	for pkg in $pkgs; do
		pkgutil-rm $pkg
	done
fi

sudo rm -rf /Applications/Python\ 2.7
sudo rm -rf /Library/Frameworks/Python.framework/*
sudo rm -rf /Users/Shared/python-2.7.11-macosx10.6.pkg

