# $Id$
# Makefile for pdfTeX documentation.  Public domain.

mandir=manual
distdate=`date +%y%m%d`
distrev=`awk '/Id:/{print $$4; exit}' $(mandir)/pdftex-t.tex`

# Get version we're documenting from the \def in the manual.
pdftexversion=`sed -n 's,^.def.currentpdftex{\(.*\)},\1,p' manual/pdftex-t.tex`

distall=$(distnopdf) pdftex-a.pdf pdftex-l.pdf pdftex-s.pdf

distnopdf=pdftex-w.tex pdftex-t.txt pdftex-t.tex \
	pdftex-i.tex syntaxform.awk Makefile makefiles.cmd \
	pdftex-syntax.txt pdftex-help.txt README ChangeLog

context = texexec --batchmode
# context does not have \setupoutput.
# texmfstart exits immediately.

default: pdftex-a.pdf

all:	pdftex-a.pdf \
	pdftex-l.pdf \
	pdftex-s.pdf \
	pdftex-syntax.txt

common_deps = pdftex-t.tex pdftex-t.txt pdftex-help.txt
pdftex-a.pdf a:	$(common_deps)
	$(context) --result=$@ $<

pdftex-l.pdf l:	$(common_deps)
	$(context) --mode=letter --result=$@ $<

pdftex-s.pdf s:	$(common_deps) pdftex-i.tex
	$(context) --mode=screen --result=$@ $<


# booklet version is not made by default.
booklet:	pdftex-b.pdf pdftex-b-e.pdf pdftex-b-o.pdf

pdftex-b.pdf b:	pdftex-a.pdf
	$(context) --pdfarrange --paper=a5a4 --print=up --addempty=1,2 \
	--result=$@ $<

pdftex-b-e.pdf:	pdftex-a.pdf
	$(context) --pdfarrange --paper=a5a4 --print=up --addempty=1,2 \
	--pages=even --result=$@ $<

pdftex-b-o.pdf:	pdftex-a.pdf
	$(context) --pdfarrange --paper=a5a4 --print=up --addempty=1,2 \
	--pages=odd --result=$@ $<


# 
# TeXable text for the title page.
pdftex-t.txt: pdftex-w.pdf Makefile
	cat $< \
	| expand \
	| fmt -s -w36 \
	| grep --text . \
	| expand > $@
	wc -l pdftex-t.txt # titlepagelines=half of this

# PDF for the title page.
pdftex-w.pdf:	pdftex-w.tex
	pdftex $<


# Help text is too annoying to remake every time, check by hand when needed.
pdftex-help.txt:
	$(pdftex_build_binary) --help >$@
pdftex_build_binary = ../../source/build-pdftex/texk/web2c/pdftex

# Syntax list.
pdftex-syntax.txt: pdftex-t.tex syntaxform.awk
	gawk -f syntaxform.awk $< > $@


# 
# tar/zip including pdftex-a.pdf, pdftex-l.pdf, pdftex-s.pdf:

alltar:	$(distall)
	cd .. && tar cvjf $(mandir)/pdftex-$(pdftexversion)-userman-$(distrev).tar.bz2 \
	$(patsubst %, $(mandir)/%, $(distall))

allzip:	$(distall)
	cd .. && zip $(mandir)/pdftex-$(pdftexversion)-userman-$(distrev).zip \
	$(patsubst %, $(mandir)/%, $(distall))


# tar/zip without PDF files:

tar:	$(distnopdf)
	cd .. && tar cvjf $(mandir)/pdftex-$(pdftexversion)-userman-$(distrev)-src.tar.bz2 \
	$(patsubst %, $(mandir)/%, $(distnopdf))
	ls -l *.tar.bz2

zip:	$(distnopdf)
	cd .. && zip $(mandir)/pdftex-$(pdftexversion)-userman-$(distrev)-src.zip \
	$(patsubst %, $(mandir)/%, $(distnopdf))


clean:
	rm -f *.log *.tuo *.tui *.top *.tmp *-mpgraph.mp

maintainer-clean: clean
	rm -f pdftex-a.pdf pdftex-l.pdf pdftex-s.pdf
	rm -f pdftex-b.pdf pdftex-b-e.pdf pdftex-b-o.pdf
	rm -f pdftex-help.txt pdftex-syntax.txt
	rm -f pdftex-w.pdf pdftex-t.txt

clobber allclean realclean distclean: maintainer-clean
