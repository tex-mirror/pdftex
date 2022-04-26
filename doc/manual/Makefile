# $Id$
# Makefile for pdfTeX documentation.  Public domain.

# Get version we're documenting from the \def in the manual.
pdftexversion=`sed -n 's,^.def.currentpdftex{\(.*\)},\1,p' manual/pdftex-t.tex`

context = texexec --batchmode
# context does not have \setupoutput.
# texmfstart exits immediately.

# what we distribute in TeX Live.
default: pdftex-a.pdf pdftex-syntax.txt

# the other formats (everything that can be built).
all: pdftex-l.pdf pdftex-s.pdf booklet

common_deps = pdftex-t.tex pdftex-w.txt pdftex-syntax.tex # pdftex-help.txt
pdftex-a.pdf a:	$(common_deps)
	$(context) --mode=a4 --result=$@ $<

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


#  Creating the subsidiary/dependent files.

# TeXable text for the title page.
pdftex-w.txt: pdftex-w.pdf
	cat $< \
	| expand \
	| fmt -s -w36 \
	| grep --text . \
	| expand >$@ || rm -f $@
	wc -l pdftex-w.txt  # set titlepagelines=half of this

# PDF for the title page. This should be updated every year;
# - update version numbers
# - make new binary
# - run this target
# Also check pdftex-help.txt for updates.
pdftex_binary = ../../source/build-pdftex/texk/web2c/pdftex
pdftex-w.pdf: pdftex-w.tex Makefile
	TEXFONTS=/usr/local/texlive/dev/texmf-dist/fonts// \
	KPATHSEA_WARNING=0 \
	$(pdftex_binary) -ini '$<'


# Too annoying to remake help text every time; check by hand when needed.
pdftex-help.txt: force
	$(pdftex_binary) --help >$@ || rm -f $@
force:

# if we don't have a build tree around, try from PATH.
build_binary := ../../source/build-pdftex/texk/web2c/pdftex
ifneq "$(realpath $(build_binary))" ""
pdftex_binary := $(build_binary)
else
pdftex_binary := pdftex
endif

# Primitives and syntax, in TeX for the printed manual, and then in
# plain text for human convenience.
pdftex-syntax.tex: pdftex-t.tex syntaxform.pl
	perl syntaxform.pl pdftex-t.tex >pdftex-syntax.tex || rm -f $@

pdftex-syntax.txt: pdftex-t.tex pdftex-syntax.tex syntaxform.awk
	gawk -f syntaxform.awk pdftex-syntax.tex $< >$@ || rm -f $@


#  Install from this source directory to TL.

# svn co svn://u:pw@tug.org/texlive/trunk/Master/texmf-dist/doc/pdftex
tltree = /v/texlive/karl/Master/texmf-dist
dest = $(tltree)/doc/pdftex/manual

INSTALL_DATA = cp -p

install: default
	$(INSTALL_DATA) ChangeLog Makefile README makefiles.cmd $(dest)
	$(INSTALL_DATA) pdftex-a.pdf pdftex-syntax.txt $(dest)
	$(INSTALL_DATA) pdftex-t.tex pdftex-w.tex pdftex-i.tex $(dest)
	$(INSTALL_DATA) syntaxform.awk syntaxform.pl $(dest)


#  Dist and clean.
# tar/zip including pdftex-a.pdf, pdftex-l.pdf, pdftex-s.pdf,
# although we don't ever make such distributions any more.

distall=$(distnopdf) pdftex-a.pdf pdftex-l.pdf pdftex-s.pdf

mandir=manual
distdate=`date +%y%m%d`
distrev=`awk '/Id:/{print $$4; exit}' $(mandir)/pdftex-t.tex`

distnopdf=pdftex-w.tex pdftex-w.txt pdftex-t.tex \
	pdftex-i.tex syntaxform.awk Makefile makefiles.cmd \
	pdftex-syntax.txt pdftex-help.txt README ChangeLog

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
	rm -f pdftex-help.txt pdftex-syntax.txt pdftex-syntax.tex
	rm -f pdftex-w.pdf pdftex-w.txt

clobber allclean realclean distclean: maintainer-clean

spell:
	myspell pdftex-t.tex
