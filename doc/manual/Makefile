# $Id: Makefile,v 1.75 2005/02/04 18:16:10 oneiros Exp $
#
# Makefile for pdfTeX documentation

pdftexversion=1.21a
distdate=`date +%y%m%d`
mandir=manual
distfiles=pdftex-w.tex pdftex-t.txt pdftex-t.tex \
	pdftex-i.tex syntaxform.awk Makefile makefiles.cmd \
	pdftex-a.pdf pdftex-l.pdf pdftex-syntax.txt README

all:	pdftex-a.pdf \
	pdftex-l.pdf \
	pdftex-s.pdf \
	pdftex-syntax.txt

booklet:	pdftex-b.pdf pdftex-b-e.pdf pdftex-b-o.pdf

pdftex-a.pdf:	pdftex-t.tex pdftex-t.txt
	texexec --result $@ $<

pdftex-l.pdf:	pdftex-t.tex pdftex-t.txt
	texexec --mode=letter --result $@ $<

pdftex-s.pdf:	pdftex-t.tex pdftex-i.tex
	texexec --mode=screen --result $@ $<

pdftex-b.pdf:	pdftex-a.pdf
	texexec --pdfarrange --paper=a5a4 --print=up --addempty=1,2 \
	--result $@ $<

pdftex-b-e.pdf:	pdftex-a.pdf
	texexec --pdfarrange --paper=a5a4 --print=up --addempty=1,2 \
	--pages=even --result $@ $<

pdftex-b-o.pdf:	pdftex-a.pdf
	texexec --pdfarrange --paper=a5a4 --print=up --addempty=1,2 \
	--pages=odd --result $@ $<

pdftex-t.txt:	pdftex-w.pdf Makefile
	cat $< \
	| expand \
	| sed -e '/\/Differences/s/\// \//g' \
	| fmt -s -w45 \
	| sed -e '/Differences/,/endobj/s/ //g' \
	| grep . \
	| expand \
	| cat > $@

pdftex-w.pdf:	pdftex-w.tex
	pdfetex $<

pdftex-syntax.txt:	pdftex-t.tex syntaxform.awk
	awk -f syntaxform.awk $< > $@

tar:	$(distfiles)
	cd .. && tar cvjf $(mandir)/pdftex-userman-$(pdftexversion)-$(distdate).tar.bz2 \
	$(patsubst %, $(mandir)/%, $(distfiles))

zip:	$(distfiles)
	cd .. && zip $(mandir)/pdftex-userman-$(pdftexversion)-$(distdate).zip \
	$(patsubst %, $(mandir)/%, $(distfiles))

clean:
	texutil --purge

allclean:
	- rm -f pdftex-a.pdf pdftex-l.pdf pdftex-s.pdf
	- rm -f pdftex-b.pdf pdftex-b-e.pdf pdftex-b-o.pdf
	- rm -f pdftex-syntax.txt
	- rm -f pdftex-w.pdf pdftex-t.txt
	make clean
