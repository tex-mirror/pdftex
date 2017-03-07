#!/bin/bash -e
# $Id$
# build pdftex from cut-down TeX Live sources (see sync-pdftex.sh).
# public domain.
# The only intended bash-ism is the use of PIPESTATUS near the end.
# Could rewrite, but no requests to do so ...

top_dir=$(cd $(dirname $0) && pwd)
pdftex_dir=$top_dir/src/texk/web2c/pdftexdir
if test ! -d $pdftex_dir; then
    echo "$0: $pdftex_dir not found, goodbye"
    exit 1
fi

# just build pdftex; normally disable poppler here since typically we
# want to build/debug with our own libxpdf.
# 
able_poppler=--disable-poppler
#
CFG_OPTS="\
    --without-x \
    --disable-shared \
    --disable-all-pkgs \
    --enable-pdftex \
    --disable-synctex \
    $able_poppler \
    --enable-native-texlive-build \
    --enable-cxx-runtime-hack \
"

# build with debugging only (no optimization).
DEBUG_OPTS="\
    CFLAGS=-g \
    CXXFLAGS=-g \
"

# disable system libraries for everything, so that configure does not
# report any "Assuming installed ...", only "Using ... from TL tree".
# 
# Sadly, --enable-native-texlive-build can't easily do it for cut-down
# source trees like this one.  For example, our tree does not include
# teckit, therefore configure thinks the system teckit should be used,
# therefore teckit dependencies should also be taken from the system,
# and that includes zlib -- even though we do have zlib present in the
# source tree here, and want to use it.  Sigh.
#
DISABLE_SYSTEM_LIBS="\
    --without-system-cairo \
    --without-system-freetype2 \
    --without-system-gd \
    --without-system-gmp \
    --without-system-graphite2 \
    --without-system-harfbuzz \
    --without-system-icu \
    --without-system-kpathsea \
    --without-system-libgs \
    --without-system-libpaper \
    --without-system-libpng \
    --without-system-mpfr \
    --without-system-pixman \
    --without-system-poppler \
    --without-system-potrace \
    --without-system-ptexenc \
    --without-system-teckit \
    --without-system-xpdf \
    --without-system-zlib \
    --without-system-zziplib \
"
CFG_OPTS="-C $CFG_OPTS $DEBUG_OPTS $DISABLE_SYSTEM_LIBS"

export CONFIG_SHELL=/bin/bash
build_dir=`pwd`/build-pdftex

set -x
rm -rf $build_dir && mkdir $build_dir && cd $build_dir

{
  echo "starting `date`"
  $top_dir/src/configure $CFG_OPTS "$@"
} 2>&1 | tee configure.log
if test ${PIPESTATUS[0]} -ne 0; then  # a bash feature
  set +x
  echo "$0: configure failed, goodbye (see log in $build_dir/configure.log)." >&2
  exit 1
fi

# try to find gnu make; we may need it
MAKE=make
if make -v 2>&1| grep "GNU Make" >/dev/null; then
    echo "$0: Your make is a GNU-make; I will use that."
elif gmake -v >/dev/null 2>&1; then
    MAKE=gmake
    echo "$0: You have a GNU-make installed as gmake; I will use that."
else
    echo "$0: I can't find a GNU-make; I'll just use make and hope it works."
    echo "$0: If it doesn't, please install GNU-make."
fi

export MAKE
printf "\n\f\n$0: running general $MAKE (`date`)\n"
$MAKE | tee make.log
if test ${PIPESTATUS[0]} -ne 0; then
  echo "$0: general $MAKE failed, goodbye (see $build_dir/make.log)." >&2
  exit 1
fi

printf "\n\f\n$0: running pdftex $MAKE (`date`)\n"
(cd $build_dir/texk/web2c && $MAKE pdftex) 2>&1 | tee -a make.log
if test ${PIPESTATUS[0]} -ne 0; then
  echo "$0: pdftex $MAKE failed, goodbye (see $build_dir/make.log)." >&2
  exit 1
fi

printf "\n\f\n$0: running final binary (`date`)\n"
ls -l $build_dir/texk/web2c/pdftex | tee -a make.log
(cd $build_dir/texk/web2c && ./pdftex --version) | tee -a make.log
