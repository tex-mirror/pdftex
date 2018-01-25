# $Id$
# Public domain.

include ../Common.mak

default: test-ok

test-ok:
	$(prog) test-fontobjnum.tex
	grep 'fontobjnum=1' test-fontobjnum.log >/dev/null

clean:
	$(clean)
