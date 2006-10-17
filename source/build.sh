#! /bin/sh
# builds new pdftex binaries
# ----------
# try to find gnu make; we need it
if make -v 2>&1| grep -q "GNU Make" 
then 
  MAKE=make;
  echo "Your make is a GNU-make; I will use that"
elif gmake -v >/dev/null 2>&1
then
  MAKE=gmake;
  echo "You have a GNU-make installed as gmake; I will use that"
else
  MAKE=make
  echo "I can't find a GNU-make; I'll try to use make and hope that works." 
  echo "If it doesn't, please install GNU-make."
fi
# ----------
# Options:
#       --make      : only make, no make distclean; configure
#       --parallel  : make -j2
ONLY_MAKE=FALSE
JOBS=1
while [ "$1" != "" ] ; do
  if [ "$1" = "--make" ] ;
  then ONLY_MAKE=TRUE ;
  elif [ "$1" = "--parallel" ] ;
  then MAKE=$MAKE --jobs 2 --max-load=3.0 ;
  fi ;
  shift ;
done
#
STRIP=strip
# ----------
# clean up, if needed
if [ -e Makefile -a $ONLY_MAKE = "FALSE" ]
then
  rm -rf build
elif [ ! -e Makefile ]
then
    ONLY_MAKE=FALSE
fi
if [ ! -a build ]
then
  mkdir build
fi
#
cd build
# clean up (uncomment the next line if you have commented out the rm and
# mkdir above)
# $MAKE distclean;
if [ "$ONLY_MAKE" = "FALSE" ]
then
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
fi
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
# vim: set syntax=sh ts=2:
