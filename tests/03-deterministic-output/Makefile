# $Id$
# Public domain.

include ../Common.mak

test1:
	$(prog) test-no-date-id.tex

test2:
	$(prog) test-fixed-date-id.tex

testprim:
	SOURCE_DATE_EPOCH=120 FORCE_SOURCE_DATE=1 \
	  $(prog) test-prim.tex
	
test = test-SOURCE_DATE_EPOCH
# test invalid settings of the envvar.
test3-invalid:
	-SOURCE_DATE_EPOCH=" "    $(prog) $(test).tex
	-SOURCE_DATE_EPOCH=abc123 $(prog) $(test).tex
	-SOURCE_DATE_EPOCH=0.0    $(prog) $(test).tex
	-SOURCE_DATE_EPOCH=-1     $(prog) $(test).tex
	-SOURCE_DATE_EPOCH=123abc $(prog) $(test).tex
	-SOURCE_DATE_EPOCH=994399281551439928155 $(prog) $(test).tex

test3-orig.pdf:
	$(prog) $(test).tex && mv $(test).pdf $@

# test valid settings of the envvar.
test3-valid: test3-orig.pdf test3-repro.pdf
	SOURCE_DATE_EPOCH=0  $(prog) $(test).tex
	SOURCE_DATE_EPOCH="" $(prog) $(test).tex # same as 0
	-$(diff) $< $(test).pdf              # shows differences
	SOURCE_DATE_EPOCH=11 $(prog) $(test).tex
	$(diff) test3-repro.pdf $(test).pdf  # should be identical
#	SOURCE_DATE_EPOCH=1439928155 $(prog) $(test).tex

# make an original with nonzero time for checking.
test3-repro.pdf: force
	SOURCE_DATE_EPOCH=11 $(prog) $(test).tex && mv $(test).pdf $@
force:

clean:
	rm -f *.log *.pdf *.fmt *.aux

fmt:
	$(prog) \*pdflatex.ini
	$(prog) \*pdfetex.ini
