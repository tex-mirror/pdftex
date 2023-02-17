# public domain

font = pdftexspace

try-space.pdf: try-space.tex $(font).pfb $(font).tfm
	pdftex $<

$(font).pfb: $(font).pfa
	t1asm $< $@ || rm -f $@

$(font).tfm: $(font).pl
	pltotf $< $@ || rm -f $@

files = Makefile
files += $(font).pfb $(font).pfa
files += $(font).tfm $(font).pl
files += try-space.tex try-space.pdf

dist: try-space.pdf
	tar czf $(font).tgz $(files)
