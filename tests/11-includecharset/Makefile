# $Id: Makefile 808 2018-11-13 18:39:00Z karl $
# Public domain.

include ../Common.mak

default: test-includecharset

test-includecharset:
	# by default, no CharSet
	$(prog) test-includecharset.tex
	! grep "/CharSet" test-includecharset.pdf >/dev/null
	#
	# force CharSet to be included
	$(prog) '\pdfincludecharset=1 \input test-includecharset.tex'
	grep "/CharSet" test-includecharset.pdf >/dev/null

clean:
	$(clean)
