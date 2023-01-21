# $Id$
# Public domain. Originally written by Karl Berry.
# Top-level tests Makefile. Not done.

default:
	@echo "install to copy tests to TL Master for distribution."
	@echo "all to try running all tests, but doesn't work."

all:
	for d in *; do make -C $$d </dev/null || exit 1; done >log 2>&1

dest = /v/texlive/Master/texmf-dist/doc/pdftex/tests
filelist = /tmp/sat # svn status, numbers, not directories or .
install:
	rsync -avR --delete `cat $(filelist)` $(dest)/
