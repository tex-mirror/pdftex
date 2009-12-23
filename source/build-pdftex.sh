#!/bin/bash
# script to build pdftex from a subset of TeX Live sources

set -e
set -x

topDir=$(cd $(dirname $0) && pwd)

pdftexDir=$topDir/src/texk/web2c/pdftexdir
if [ ! -d $pdftexDir ]; then
    echo "$pdftexDir not found"
    exit -1
fi

CFG_OPTS="\
    --enable-native-texlive-build \
    --enable-cxx-runtime-hack \
    --disable-shared \
    --disable-largefile \
    --without-x \
    --disable-all-pkgs \
    --disable-synctex \
    --enable-pdftex \
    --without-system-xpdf \
"

buildDir=$(pwd)/build-pdftex
rm -rf $buildDir && mkdir $buildDir && cd $buildDir

export CONFIG_SHELL=/bin/bash
$topDir/src/configure $CFG_OPTS "$@" 2>&1 | tee configure.log
make | tee make.log

## TESTING
# exit

(cd $buildDir/texk/web2c; make pdftex) 2>&1 | tee -a make.log

ls -l $buildDir/texk/web2c/pdftex
