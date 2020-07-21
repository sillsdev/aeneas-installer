#!/bin/bash

#export PATH="/usr/libexec/git-core/:$PATH"
export MP_PREFIX="/opt/usr"
export PATH="$MP_PREFIX/bin:$MP_PREFIX/sbin:$PATH"
export PATH="/Library/Frameworks/Python.framework/Versions/Current/bin:$PATH"

cd `dirname $0`
export CURDIR=`pwd`
pwd

export REVISION=_2

export FFMPEG_VER=`curl -s https://evermeet.cx/ffmpeg/info/ffmpeg/release | jq -r '.version'`
export ESPEAK_VER=`port info --version espeak-ng | cut -d' ' -f2`
export PYTHON_VER=`port info --version python38 | cut -d' ' -f2`
export AENEAS_VER=`pip3 show aeneas | grep "Version:" | cut -d' ' -f2`
export NUMPY_VER=`pip3 show numpy | grep "Version:" | cut -d' ' -f2`
export LXML_VER=`pip3 show lxml | grep "Version:" | cut -d' ' -f2`
export BS4_VER=`pip3 show beautifulsoup4 | grep "Version:" | cut -d' ' -f2`
export SOUPSIEVE_VER=`pip3 show soupsieve | grep "Version:" | cut -d' ' -f2`
export VERSION="$AENEAS_VER$REVISION"

export LDFLAGS="-L/opt/usr/lib"
