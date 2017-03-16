# $Id$
# Public domain.

include ../Common.mak

all: abc-diff testptex-diff testdate-diff testtrailer-diff

abc abc.pdf:
	$(env) $(prog) '\pdfsuppressptexinfo=1\input' abc.tex </dev/null

abc-orig.pdf:
	$(env) $(prog) abc.tex </dev/null && mv abc.pdf $@
abc-diff: abc-orig.pdf abc.pdf
	-$(diff) $^  # /PTEX.Fullbanner should be gone

testptex = test-pdfsuppressptexinfo
$(testptex)-orig.pdf: $(testptex).tex abc.pdf
	$(env) $(prog) $(testptex).tex </dev/null \
	  && mv $(testptex).pdf $(testptex)-orig.pdf
$(testptex).pdf: $(testptex).tex abc.pdf Makefile
	$(env) $(prog) '\pdfsuppressptexinfo=-1\input' $(testptex).tex \
	  </dev/null
testptex-diff: $(testptex)-orig.pdf $(testptex).pdf
	-$(diff) $^  # all /PTEX.* should be gone

# these are also tested in ../03-deterministic-output, but can try them here.
testdate = test-pdfinfoomitdate
$(testdate).pdf: $(testdate).tex abc.pdf
	$(env) $(prog) $(testdate).tex </dev/null
testdate-diff: $(testptex)-orig.pdf $(testdate).pdf
	-$(diff) $^  # /CreationDate, /ModDate should be gone

testtrailer = test-pdftrailer
$(testtrailer).pdf: $(testtrailer).tex abc.pdf
	$(env) $(prog) $(testtrailer).tex </dev/null
testtrailer-diff: $(testptex)-orig.pdf $(testtrailer).pdf
	-$(diff) $^  # new /mytrlrkey, dates+id should be different

clean:
	$(clean)
