#!/bin/bash

#export PATH="/usr/libexec/git-core/:$PATH"
export PATH=/bin:/sbin:/usr/bin:/usr/sbin

export MP_PREFIX="/opt/usr"
export PATH="$MP_PREFIX/bin:$MP_PREFIX/sbin:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"

cd `dirname $0`
export CURDIR=`pwd`
echo -e "\n\nRunning `basename $0`\n from $CURDIR\n"

export CPLUS_INCLUDE_PATH="/opt/usr/include"
export C_INCLUDE_PATH="/opt/usr/include"
export LIBRARY_PATH="/opt/usr/lib"
export LDFLAGS="-L/opt/usr/lib"


cd $CURDIR

echo -e "\n\nPreparing package build environment\n\n"

#./install_xcode_cl_tools.sh
xcode-select --install

curl https://www.python.org/ftp/python/3.9.13/python-3.9.13-macosx10.9.pkg --output python-3.9.13-macosx10.9.pkg
sudo installer -pkg python-3.9.13-macosx10.9.pkg -target /

sudo mkdir -p $MP_PREFIX
cd $MP_PREFIX
sudo git clone https://github.com/macports/macports-base.git
sudo git checkout v2.8.1
cd macports-base
sudo ./configure --enable-readline --prefix=$MP_PREFIX --with-applications-dir=/Applications/MacPorts`echo $MP_PREFIX | sed 's#/#-#g'` --without-startupitems
sudo make
sudo make install
sudo make distclean

cd $MP_PREFIX
#sudo git clone https://github.com/macports/macports-ports.git
sudo git clone https://github.com/danielbair/custom-macports-ports.git

cd $CURDIR
sudo cp -v ./etc-macports-sources.conf $MP_PREFIX/etc/macports/sources.conf
sudo port selfupdate

sudo port install jq wget

pkgutil --pkgs | grep "pkg.Packages"
if [ $? = 0 ]; then
  if [ ! -f "./Packages.dmg" ]; then
    wget --trust-server-names -N http://s.sudre.free.fr/Software/files/Packages.dmg
  fi
  mkdir -p /tmp/packages-installer/
  hdiutil attach Packages.dmg -mountpoint /tmp/packages-installer/
  sudo installer -pkg  /tmp/packages-installer/ -target /
  hdiutil detach /tmp/packages-installer/
fi

echo -e "\n\nNow run build_packages.sh\n\n"

exit 0
