#!/bin/bash

#export PATH="/usr/libexec/git-core/:$PATH"
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

source ./build_env.sh

cd $CURDIR

echo -e "\n\nPreparing package build environment\n\n"

./install_xcode_cl_tools.sh

pkgutil --pkgs | grep "pkg.Packages"
if [ $? = 0 ]; then
  if [ ! -f "./Packages.dmg" ]; then
    wget --trust-server-names -N http://s.sudre.free.fr/Software/files/Packages.dmg
  fi
  sudo installer -pkg ./Packages.dmg -target /
fi

sudo mkdir $MP_PREFIX
cd $MP_PREFIX
sudo git clone https://github.com/macports/macports-base.git
sudo git checkout v2.6.2
cd macports-base
sudo ./configure --enable-readline --prefix=$MP_PREFIX --with-applications-dir=/Applications/MacPorts`echo $MP_PREFIX | sed 's#/#-#g'` --without-startupitems
sudo make
sudo make install
sudo make distclean

cd $MP_PREFIX
sudo git clone https://github.com/macports/macports-ports.git
sudo git clone https://github.com/danielbair/custom-macports-ports.git

cd $CURDIR
sudo cp -v ./etc-macports-sources.conf $MP_PREFIX/etc/macports/sources.conf
sudo port selfupdate

echo -e "\n\nNow run build_packages.sh\n\n"

exit 0
