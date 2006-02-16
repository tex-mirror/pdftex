#! /usr/bin/env bash
# $Id$
# builds new pdftex binaries
MAKE=make
STRIP=strip
# this deletes all previous builds. 
# comment out the rm and mkdir if you want to keep them (and uncomment and
# change the $MAKE distclean below)
rm -rf build
mkdir build
cd build
# clean up (uncomment the next line if you have commented out the rm and
# mkdir above)
# $MAKE distclean;
# do a configure without all the things we don't need
echo "ignore warnings and errors about the main texmf tree"
../src/configure \
            --without-bibtex8   \
            --without-cjkutils  \
            --without-detex     \
            --without-dialog    \
            --without-dtl       \
            --without-dvi2tty   \
            --without-dvidvi    \
            --without-dviljk    \
            --without-dvipdfm   \
            --without-dvipsk    \
            --without-eomega    \
            --without-etex      \
            --without-gsftopk   \
            --without-lacheck   \
            --without-makeindexk\
            --without-musixflx  \
            --without-odvipsk   \
            --without-omega     \
            --without-oxdvik    \
            --without-ps2pkm    \
            --without-seetexk   \
            --without-t1utils   \
            --without-tetex     \
            --without-tex4htk   \
            --without-texinfo   \
            --without-texlive   \
            --without-ttf2pk    \
            --without-tth       \
            --without-xdvik     \
            || exit 1 
# make the binaries
(cd texk/web2c/web2c; $MAKE) || exit 1
(cd texk/web2c; $MAKE ../kpathsea/libkpathsea.la) || exit 1
(cd texk/web2c/lib; $MAKE) || exit 1
(cd texk/web2c; $MAKE pdftex pdfetex pdftosrc ttf2afm) || exit 1
# strip them
$STRIP texk/web2c/{pdf*tex,pdftosrc,ttf2afm}
# go back
cd ..
# show the results
ls -l build/texk/web2c/{pdf*tex,pdf*tex.pool,pdftosrc,ttf2afm}
