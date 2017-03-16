# $Id$
# Public domain.

include ../Common.mak

default: test-pkenc

test-pkenc:
	$(prog) test-pkenc.tex
	grep -q /ffi test-pkenc.pdf # should end up with this encoded char

clean:
	$(clean)
