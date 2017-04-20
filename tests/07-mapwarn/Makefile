# $Id$
# Public domain.

include ../Common.mak

default: test-mapwarn

test-mapwarn:
	$(prog) test-mapwarn.tex; test $$? = 1 # pdftex should exit 1

clean:
	$(clean)
