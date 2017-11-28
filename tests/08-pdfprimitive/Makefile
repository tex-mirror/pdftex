# $Id$
# Public domain.

include ../Common.mak

default: test-ok test-non test-post

test-ok:
	$(prog) test-pdfprimitive-ok.tex
	grep ' hello ' test-pdfprimitive-ok.log >/dev/null

test-non:
	$(prog) test-pdfprimitive-non.tex
	grep 'No pages of output' test-pdfprimitive-non.log >/dev/null

test-post:
	! $(prog) test-pdfprimitive-post.tex
	grep '|||' test-pdfprimitive-post.log >/dev/null

clean:
	$(clean)
