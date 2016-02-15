# $Id$
# public domain.  Originally written by Karl Berry.

default:
	@echo "make build to build, make version to see built --version."
	@echo "make synctest or syncreal to sync,"
	@echo "  and svnstatus to make file lists to help with syncing." 
	@echo "But read/understand the scripts before doing anything."

build:
	./build-pdftex.sh

# impractical to get real make check to work without the whole tree.
version:
	cd build-pdftex/texk/web2c && ./pdftex --version

synctest:
	./sync-pdftex.sh  # does not actually change anything.

syncreal:
	./sync-pdftex.sh --real # read the trailing info!

# The idea is to run this, do the needed svn adds and svn removes,
# then (if something fails, which usually happens), deal with it, then
# rerun this.  Repeat until all files are empty.
svnstatus:
	svn status >/tmp/sat
	-grep -v '^[MDA]' /tmp/sat >/tmp/sun  # unknown
	ls -l /tmp/sun
	@echo
	sed -n 's/^\?//p' /tmp/sat >/tmp/sad  # add these
	ls -l /tmp/sad
	@echo
	sed -n 's/^!//p'  /tmp/sat >/tmp/srm  # remove these
	ls -l /tmp/srm
