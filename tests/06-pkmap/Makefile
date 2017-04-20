# $Id$
# Public domain.

include ../Common.mak

default: test-pkmap

test-pkenc: # cmr10.3600pk - not used
	$(prog) test-pkmap.tex
#
# should work when and if patch is applied:
#	grep -q /ffi test-pkenc.pdf # should end up with this encoded char
#	grep -a ToUnicode test-pkenc.pdf
#
# dev convenience:
#	pdffonts test-big.pdf
#	pdftotext test-big.pdf -

cmr10.3600pk:
	mf-nowin '\mode:=ljfour;mag:=6;input cmr10'
	gftopk cmr10.3600gf

clean:
	$(clean)
