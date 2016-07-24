#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

#python -m ensurepip > /dev/null
#sudo -H pip uninstall -y setuptools

echo "Uninstalling python-2.7.11 packages..."

function pkgutil-rm {
	location=$(pkgutil --pkg-info $1 | grep "location:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	volume=$(pkgutil --pkg-info $1 | grep "volume:" | cut -d':' -f2 | sed -e "s/^[[:space:]]*//")
	for file in `pkgutil --only-files --files $1`; do 
		sudo rm -v "$volume/$location/$file"; 
	done
	for dir in {Cellar,bin,include,libexec,share,lib/python2.7/site-packages}; do 
		echo Cleaning up files and folders in /usr/local/$dir; 
		sudo rm -v /$(pkgutil --only-dirs --files $1 | grep "usr/local/$dir/";);
	done
	sudo pkgutil --forget $1
}

pkgs=`pkgutil --pkgs | grep "org.python"`
if [[ ! -z $pkgs ]]; then
	for pkg in $pkgs; do
		pkgutil-rm $pkg
	done
	sudo rm -rf /Applications/Python\ 2.7
	sudo rm -rf /Library/Frameworks/Python.framework
	sudo rm -rf /Users/Shared/python-2.7.11-macosx10.6.pkg
fi

