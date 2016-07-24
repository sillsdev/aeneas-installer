#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

echo "Uninstalling ffmpeg..."

function pkgutil-rm {
	location=$(pkgutil --pkg-info $1 | grep "location:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	volume=$(pkgutil --pkg-info $1 | grep "volume:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	for file in `pkgutil --only-files --files $1`; do 
		sudo rm -v "$volume/$location/$file"; 
	done
	for dir in {Cellar,bin,include,lib,libexec,share}; do 
		echo Cleaning up files and folders in /usr/local/$dir; 
		sudo rm -v /$(pkgutil --only-dirs --files $1 | grep "usr/local/$dir/";);
	done
	sudo pkgutil --forget $1
}

pkg=`pkgutil --pkgs | grep "ffmpeg"`
if [[ ! -z $pkg ]]; then
	pkgutil-rm $pkg
fi

