# $Id$
# Public domain.

include ../Common.mak

default: test-pkmap

test-pkmap: cmr10.360pk cmr10.72pk cmb10.72pk
	$(prog) test-pkmap.tex
	grep -q /ffi test-pkmap.pdf # should end up with this encoded char
	grep -a ToUnicode test-pkmap.pdf
#
# dev convenience:
#	pdffonts test-big.pdf
#	pdftotext test-big.pdf -

cmr10.360pk:
	mf-nowin '\mode:=ljfour; mag:=0.6; input cmr10'
	gftopk cmr10.360gf

cmr10.72pk:
	mf-nowin '\mode:=mactrue; input cmr10'
	gftopk cmr10.72gf

cmb10.72pk:
	mf-nowin '\mode:=mactrue; input cmb10'
	gftopk cmb10.72gf

clean:
	$(clean)
