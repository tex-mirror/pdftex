# $Id$
# Public domain.
# Test \pdfmajorversion and image inclusion.

include ../Common.mak

default: test-compress test-badver test-pdfmajor test-incl

test-compress: test-compress2.tex
	$(prog) $<
	! grep "warning.*Object streams" test-compress2.log >/dev/null

test-badver: test-pdfmajor.tex
	! $(prog) '\pdfmajorversion=0 \input $<'
	! $(prog) '\pdfminorversion=-1 \input $<\end'

test-pdfmajor: test-pdfmajor.tex
	$(prog) $<
	# by default, first line should start with %PDF-1.
	sed 1q test-pdfmajor.pdf | grep "%PDF-1" >/dev/null
	#
	# go to PDF 2.
	$(prog) '\pdfmajorversion=2 \input $<'
	sed 1q test-pdfmajor.pdf | grep "%PDF-2" >/dev/null

test-incl: test-incl22 test-incl21 test-incl12
#
test-incl22: test-doc2incl2.tex incl2.pdf
	$(prog) $< # no pdftex warning
	! grep "at most version <" test-doc2incl2.log >/dev/null

test-incl21: test-doc2incl1.tex incl1.pdf
	$(prog) $< # no pdftex warning
	! grep "at most version <" test-doc2incl1.log >/dev/null

test-incl12: test-doc1incl2.tex incl2.pdf
	$(prog) $< # pdftex warning should be in the log
	grep "at most version <" test-doc1incl2.log >/dev/null
	# 
	# Now let's force omission of the warning.
	$(prog) '\pdfinclusionerrorlevel=-1 \input $<'
	! grep "at most version <" test-doc1incl2.log >/dev/null

incl2.pdf: incl2.tex
	$(prog) incl2.tex
incl1.pdf: incl1.tex
	$(prog) incl1.tex
clean:
	$(clean)
