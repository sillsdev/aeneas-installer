#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:~/bin:$PATH

echo "Uninstalling espeak..."

function pkgutil-rm {
	location=$(pkgutil --pkg-info $1 | grep "location:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	volume=$(pkgutil --pkg-info $1 | grep "volume:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	for file in `pkgutil --only-files --files $1`; do
		sudo rm -v "$volume/$location/$file";
	done
	sudo pkgutil --forget $1
}

pkg=`pkgutil --pkgs | grep "org.homebrew.espeak"`
if [[ ! -z $pkg ]]; then
	pkgutil-rm $pkg
	# sudo rm -rf /usr/local/Cellar/espeak*
fi

