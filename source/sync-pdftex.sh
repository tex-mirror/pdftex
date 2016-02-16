#!/bin/sh
# Sync from TeX Live repository to pdftex repository.  Public domain.
# We assume no spaces in any of the file names.
# --karl, 9jan14.

chicken=true  # do nothing by default
: ${tldir=/r/tug/home/texlive/karl/Build/source}

while test $# -gt 0; do
  if test "x$1" = x--version; then
    echo '$Id$'
    exit 0
  elif test "x$1" = x--help; then
    echo "Usage: $0 [--real] /TL/SOURCE"
    echo "Sync from TL source tree given as the first arg."
    echo "By default, just show (approximately) what would be done."
    echo "To actually execute the sync, specify --real."
    echo "More hints are given at the end of output."
    exit 0
  elif test "x$1" = x--real; then
    chicken=false
  elif test -d "$1"; then
    tldir=$1
  else
    echo "$0: quitting, unknown option: $1" >&2
    exit 1
  fi
  shift
done

mydir=`dirname $0`
cd "$mydir/src" || exit 1

# use rsync instead of cp so we can get local deletion for free.
copy="rsync -ari --delete --exclude=.svn"
if $chicken; then
  copy="$copy -n"
fi

if test ! -d $tldir; then
  echo "$0: no TL source directory: $tldir" >&2
  exit 1
fi
if test ! -d $tldir/texk; then
  echo "$0: the TL source directory should have subdir texk, etc." >&2
  exit 1
fi

if $chicken; then
  echo "$0: just showing, not updating (--real to do it for real)."
fi

#  handle major subdirectory $1 (libs, texk, utils).  For these, we
# only want to sync the entries we have, not copying everything from TL.
# Furthermore, handle texk/web2c and other needed subdirs similarly --
# those where configure has to create a file, but we don't need or want
# the full sources for pdftex.  Sigh.
sync_dir ()
{
  for f in $1/*; do
    if test -f $f; then
      # Just copy plain files from TL dir.
      $copy $tldir/$f $1
    
    # These are the subdirs which we don't want to copy in full.
    # If we erroneously specify a directory here that no longer exists
    # in TL, rsync will complain about not being able to change_dir there.
    elif test $f = texk/web2c \
         || test $f = texk/web2c/doc \
         || test $f = texk/web2c/luatexdir \
         || test $f = texk/web2c/luatexdir/luafontloader \
         || test $f = texk/web2c/man \
         || test $f = texk/web2c/omegafonts \
         || test $f = texk/web2c/otps \
         || test $f = texk/web2c/otps/win32 \
         || test $f = texk/web2c/window \
         ; then
      echo "$0: recursively syncing directory $f"
      sync_dir $f
    
    elif test -d $f; then  # other directories
      if test -d $tldir/$f; then
        echo "$0: syncing directory $f"
        $copy $tldir/$f $1

      else
        # If a directory doesn't exist in TL, it should be removed.
        echo "$0: not a directory in TL, so svn remove: $f (in $1)" >&2
      fi
        
    else
      echo "$0: skipping non-directory non-file: $f (in $1)" >&2
    fi
  done  
}

#  main program.
for f in *; do
  test $f = README && continue  # local README for pdftex

  if test -f $f; then
    # Just copy plain files at the top level.
    $copy $tldir/$f .

  elif test $f = libs || test $f = texk || test $f = utils; then
    # Major subdirectory, handle what we've got, only.
    printf "\n\f\n$0: syncing major directory $f\n"
    sync_dir $f

  elif test -d $f; then
    # Other subdirectories (build-aux, etc.), copy in their entirety,
    # including removals from the local dir.
    echo; echo "$0: syncing top-level subdir $f"
    $copy $tldir/$f .
  
  else
    echo "$0: skipping non-directory non-file: $f" >&2
  fi
done  

printf "$0: "
$chicken && printf "would be "
echo "done."
echo "  Now try a svn status:"
echo "    specifically, ! entries from svn status should be svn removed,"
echo "    and ? entries should be svn added."
echo "  Do not do svn update first, or removes will be lost."
echo "  make svnstatus at the top level makes three temp files for this job;"
echo "    see comments there."
echo
echo "  Then do a build (probably more necessary updates will be discovered)"
echo "  When all looks good, commit."
echo "  When the commit succeeds, do svn update afterward, due to removals."
echo "Good luck."
