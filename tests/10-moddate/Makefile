# $Id$
# Public domain.

include ../Common.mak

default: test-moddate test-moddate-abs

test-moddate:
	# regular
	$(prog) test-moddate.tex
	grep "D:2[0-9].*-.*'" test-moddate.log >/dev/null
	#
	# just one envvar, still regular.
	SOURCE_DATE_EPOCH=1 $(prog) test-moddate.tex
	grep "D:2[0-9].*-.*'" test-moddate.log >/dev/null
	#
	# both envvars, force utc.
	FORCE_SOURCE_DATE=1 SOURCE_DATE_EPOCH=1 $(prog) test-moddate.tex
	grep "D:2[0-9].*Z " test-moddate.log >/dev/null

test-moddate-abs:
	# should fail due to openin_any.
	openin_any=p $(prog) test-moddate-abs.tex
	! grep "D:2[0-9]" test-moddate-abs.log >/dev/null

clean:
	$(clean)
