#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

#python -m ensurepip > /dev/null
#sudo -H pip uninstall -y setuptools

echo "Uninstalling python packages..."

function pkgutil-rm {
	location=$(pkgutil --pkg-info $1 | grep "location:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	volume=$(pkgutil --pkg-info $1 | grep "volume:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	path=$(echo "$volume/$location/" | sed -e 's#//#/#g' -e 's#//#/#g' -e 's#//#/#g' -e 's#/$##'); 
	for file in `pkgutil --only-files --files $1`; do 
		sudo rm -v "$path/$file"; 
	done
	find /usr/local -empty -type d -print -delete
	sudo pkgutil --forget $1
}

pkgs=`pkgutil --pkgs | grep "org.python"`
if [[ ! -z $pkgs ]]; then
	sudo rm -rf /usr/local/Cellar/python
	for pkg in $pkgs; do
		pkgutil-rm $pkg
	done
fi

sudo chown -R $USER:admin /usr/local
