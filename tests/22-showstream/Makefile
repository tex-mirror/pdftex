# $Id$
# Public domain.
# Test \showstream.

include ../Common.mak

default: test-showstream

test-showstream: test-showstream-basic test-showstream-only

# bad return status since normal \show's happen.
test-showstream-basic: test-showstream-basic.tex
	! $(prog) $<
	$(MAKE) xray=test-showstream-basic.xray grep-xray

# good return status since only showstream.
test-showstream-only: test-showstream-only.tex
	$(prog) $<
	$(MAKE) xray=test-showstream-only.xray grep-xray

# the .xray files have the same contents in both contents
grep-xray:
	grep 42 $(xray) >/dev/null
	grep '\\undefined=undefined' $(xray) >/dev/null
	grep '\\par=\\par' $(xray) >/dev/null

clean:
	$(clean)
