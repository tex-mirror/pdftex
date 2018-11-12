# $Id$
# public domain.  Originally written by Karl Berry.

default:
	@echo "make build to rebuild completely,"
	@echo "make remake to make the binary,"
	@echo "make versionhelp to see built --version and --help."
	@echo "make synctest or syncreal to sync with TL,"
	@echo "  and make svnstatus for file lists to help with syncing." 
	@echo "But read/understand the scripts before doing anything."

# full build.
build:
	./build-pdftex.sh
#
# just remake binary; can only build pdftex in our stripped-down-tree.
remake:
	make -C build-pdftex/texk/web2c pdftex

# simple check that binary works.
versionhelp:
	cd build-pdftex/texk/web2c && ./pdftex --version && ./pdftex --help
#
# full make check, painful because the cut-down tree means we have to
# remove all dependencies (= we can't build the other engines).
# The list might change in the future with Makefile or automake changes.
recheck:
	make -C build-pdftex/texk/web2c TESTS='$$(pdftex_tests)' \
	  SUBDIRS=. PROGRAMS="" LIBRARIES="" LTLIBRARIES="" \
	  MANS="" DATA="" HEADERS="" \
	  check

synctest:
	svn status	  # if not clean, commit first or changes will be lost
	./sync-pdftex.sh  # does not actually change anything.

syncreal:
	./sync-pdftex.sh --real | tee /tmp/pdfsync.out # read trailing info!

# The idea is to run this, do the needed svn adds and svn removes,
# then (if something fails, which usually happens), deal with it, then
# rerun this.  Repeat until all files are empty.
svnstatus:
	svn status >/tmp/sat
	-grep -v '^[MDA?!]' /tmp/sat >/tmp/sun # unknown
	ls -l /tmp/sun
	@echo
	sed -n 's/^\?//p'   /tmp/sat >/tmp/sad # add these
	ls -l /tmp/sad
	@echo
	sed -n 's/^!//p'    /tmp/sat >/tmp/srm # remove these
	ls -l /tmp/srm
