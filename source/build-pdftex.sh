#!/bin/bash -e
# $Id$
# build pdftex from cut-down TeX Live sources (see sync-pdftex.sh).
# public domain.

top_dir=$(cd $(dirname $0) && pwd)
pdftex_dir=$top_dir/src/texk/web2c/pdftexdir
if test ! -d $pdftex_dir; then
    echo "$0: $pdftex_dir not found, goodbye"
    exit 1
fi

# just build pdftex.
CFG_OPTS="\
    --without-x \
    --disable-shared \
    --disable-all-pkgs \
    --enable-pdftex \
    --enable-native-texlive-build \
    --enable-cxx-runtime-hack \
"

# build with debugging only (no optimization).
DEBUG_OPTS="\
    CFLAGS=-g \
    CXXFLAGS=-g \
"

# disable system libraries; --enable-native-texlive-build should do that
# but currently doesn't.
DISABLE_SYSTEM_LIBS="\
    --without-system-cairo \
    --without-system-freetype2 \
    --without-system-gd \
    --without-system-graphite2 \
    --without-system-harfbuzz \
    --without-system-icu \
    --without-system-kpathsea \
    --without-system-libgs \
    --without-system-libpng \
    --without-system-paper \
    --without-system-pixman \
    --without-system-poppler \
    --without-system-potrace \
    --without-system-ptexenc \
    --without-system-teckit \
    --without-system-xpdf \
    --without-system-zlib \
    --without-system-zziplib \
"
CFG_OPTS="$CFG_OPTS $DEBUG_OPTS $DISABLE_SYSTEM_LIBS"

export CONFIG_SHELL=/bin/bash
build_dir=$(pwd)/build-pdftex

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
printf "\n\f\n$0: running $MAKE (`date`)\n"
$MAKE | tee make.log
if test ${PIPESTATUS[0]} -ne 0; then
  echo "$0: $MAKE failed, goodbye (see log in $build_dir/make.log)." >&2
  exit 1
fi

(cd $build_dir/texk/web2c && $MAKE pdftex) 2>&1 | tee -a make.log
ls -l $build_dir/texk/web2c/pdftex
