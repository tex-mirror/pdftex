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

DISABLED_PROGS="\
    --disable-afm2pl \
    --disable-aleph \
    --disable-bibtex \
    --disable-bibtex8 \
    --disable-cfftot1 \
    --disable-cjkutils \
    --disable-detex \
    --disable-devnag \
    --disable-dialog \
    --disable-dtl \
    --disable-dvi2tty \
    --disable-dvidvi \
    --disable-dviljk \
    --disable-dvipdfm \
    --disable-dvipdfmx \
    --disable-dvipng \
    --disable-dvipos \
    --disable-dvipsk \
    --disable-gsftopk \
    --disable-lacheck \
    --disable-lcdf-typetools \
    --disable-luatex \
    --disable-makeindexk \
    --disable-mf \
    --disable-mmafm \
    --disable-mmpfb \
    --disable-mp \
    --disable-musixflx \
    --disable-one \
    --disable-otfinfo \
    --disable-otftotfm \
    --disable-pdfopen \
    --disable-ps2eps \
    --disable-ps2pkm \
    --disable-psutils \
    --disable-seetexk \
    --disable-t1dotlessj \
    --disable-t1lint \
    --disable-t1rawafm \
    --disable-t1reencode \
    --disable-t1testpage \
    --disable-t1utils \
    --disable-tex \
    --disable-tex4htk \
    --disable-tpic2pdftex \
    --disable-ttf2pk \
    --disable-ttfdump \
    --disable-ttftotype42 \
    --disable-vlna \
    --disable-web-progs \
    --disable-xdv2pdf \
    --disable-xdvik \
    --disable-xdvipdfmx \
"

OTHER_OPTS="\
    --without-system-kpathsea \
    --without-system-freetype2 \
    --without-system-gd \
    --without-system-libpng \
    --without-system-teckit \
    --without-system-zlib \
    --without-system-t1lib \
    --without-graphite \
    --without-mf-x-toolkit \
    --without-x \
    --disable-shared \
    --disable-largefile \
"

buildDir=$(pwd)/build-pdftex
rm -rf $buildDir && mkdir $buildDir && cd $buildDir

export CONFIG_SHELL=/bin/bash
$topDir/src/configure $DISABLED_PROGS $OTHER_OPTS "$@"
make all 2>&1 | tee make.log || true

ls -l $buildDir/texk/web2c/pdftex
