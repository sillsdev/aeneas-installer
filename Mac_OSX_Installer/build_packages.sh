#!/bin/bash

export PATH=/usr/local/bin:/usr/local/sbin:$PATH
CURDIR=`pwd`

if [ ! -f "ffmpeg-3.1.1.pkg" ]; then
	brew install --build-bottle ffmpeg
	brew pkg --with-deps ffmpeg
fi

if [ ! -f "espeak-1.48.04.pkg" ]; then
	brew tap danielbair/tap
	brew update
	#brew install --build-bottle espeak
	#brew install libespeak
	brew install danielbair/tap/espeak
	brew pkg --with-deps --scripts espeak_install_scripts danielbair/tap/espeak
fi

python -m ensurepip 2> /dev/null
pip install --upgrade pip
pip install --upgrade wheel
pip install --upgrade setuptools

pip download pip==8.1.2
pip download beautifulsoup4==4.4.1

pip download lxml==3.6.0
if [ ! -f "lxml-3.6.0-cp27-cp27m-macosx_10_6_intel.whl" ]; then
	tar xvf lxml-3.6.0.tar.gz
	cd lxml-3.6.0
	python setup.py bdist_wheel
	cp dist/lxml-3.6.0-cp27-cp27m-macosx_10_6_intel.whl ../
	cd $CURDIR
fi

pip download numpy==1.10.1
mv -v numpy-1.10.1-cp27-none-macosx_10_6_intel.*.whl numpy-1.10.1-cp27-none-macosx_10_6_intel.whl
pip install --upgrade numpy-1.10.1-cp27-none-macosx_10_6_intel.whl

pip download aeneas==1.5.0.3
tar xvf aeneas-1.5.0.3.tar.gz
cd aeneas-1.5.0.3
patch -p1 -i ../aeneas-patches/setup.patch
patch -p1 -i ../aeneas-patches/diagnostics.patch
#cd aeneas/cew
#python cew_setup.py build_ext --inplace
#cd ../..
python setup.py build_ext --inplace
python setup.py bdist_wheel
cp -v dist/aeneas-1.5.0.3-cp27-cp27m-macosx_10_6_intel.whl ../
cd $CURDIR

# brew pkg --with-deps --scripts python # fails to build a working package for now...
if [ ! -f "python-2.7.11-macosx10.6.pkg" ]; then
	curl -fSL -O https://www.python.org/ftp/python/2.7.11/python-2.7.11-macosx10.6.pkg
fi
zip -v python-2.7.11-macosx10.6.pkg.zip python-2.7.11-macosx10.6.pkg

#fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg beautifulsoup4
#fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg lxml
#fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg numpy
#fpm -f --verbose --osxpkg-identifier-prefix org.python --python-pip=/usr/local/bin/pip -s python -t osxpkg --post-install aeneas_install_scripts/postinstall aeneas

packagesbuild -v Aeneas_Installer.pkgproj
if [ ! -f "aeneas-mac-setup-1.5.0.3.mpkg" ]; then
	echo -e "Resulting Installer program filename is:\n$(pwd)/aeneas-mac-setup-1.5.0.3.mpkg"
fi
