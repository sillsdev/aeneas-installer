#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

echo "Uninstalling ffmpeg..."

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

pkg=`pkgutil --pkgs | grep "ffmpeg"`
if [[ ! -z $pkg ]]; then
	pkgutil-rm $pkg
fi

sudo chown -R $USER:admin /usr/local
