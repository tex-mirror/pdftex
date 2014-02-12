# $Id$
# public domain.

default:
	@echo "make build  to build, synctest or syncreal to sync,"
	@echo "  svnstatus to make file lists." 
	@echo "But read/understand the scripts before doing anything."

build:
	./build-pdftex.sh

synctest:
	./sync-pdftex.sh  # does not actually change anything.

syncreal:
	./sync-pdftex.sh --real # read the trailing info!


svnstatus:
	svn status >/tmp/sat
	sed -n 's/^\?//p' /tmp/sat >/tmp/sad # add these
	sed -n 's/^!//p'  /tmp/sat >/tmp/srm # remove these
