#!/bin/bash
IFS=$'\n'

export PATH=/usr/local/bin:/usr/local/sbin:$PATH

#python -m ensurepip > /dev/null
#sudo -H pip uninstall -y setuptools

echo "Uninstalling aeneas and all its dependencies..."

CURDIR=`dirname $0`
cd $CURDIR

for uninstaller in _uninstall_*.sh; do
	bash $uninstaller
done

