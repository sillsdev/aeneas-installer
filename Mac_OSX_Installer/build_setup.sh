#!/bin/bash

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

cd `dirname $0`
CURDIR=`pwd`
cd $CURDIR

./install_xcode_cl_tools.sh

export MP_PREFIX=/opt/usr
export PATH=$MP_PREFIX/bin:$MP_PREFIX/sbin:$PATH

sudo mkdir $MP_PREFIX
cd $MP_PREFIX
sudo git clone https://github.com/macports/macports-base.git
sudo git checkout v2.6.2
sudo git clone https://github.com/macports/macports-ports.git
cd macports-base
sudo ./configure --enable-readline --prefix=$MP_PREFIX --with-applications-dir=/Applications/MacPorts`echo $MP_PREFIX | sed 's#/#-#g'` --without-startupitems
sudo make
sudo make install
sudo make distclean
if [ -f " ~/etc-macports-sources.conf" ]; then
  sudo cp ~/etc-macports-sources.conf $MP_PREFIX/etc/macports/sources.conf
fi
sudo port selfupdate

cd $CURDIR
pkgutil --pkgs | grep "pkg.Packages"
if [ $? = 0 ]; then
  if [ ! -f "./Packages.dmg" ]; then
    wget --trust-server-names -N http://s.sudre.free.fr/Software/files/Packages.dmg
  fi
  sudo installer -pkg ./Packages.dmg -target /
fi

mkdir -p ./aeneas-mac-installer-packages
mkdir -p ./python-wheels

echo -e "\n\nNow run build_packages.sh\n\n"

exit 0
