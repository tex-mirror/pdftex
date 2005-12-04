# $Id: Makefile,v 1.82 2005/10/23 22:46:32 hhenkel Exp $
#
# Makefile for pdfTeX documentation

pdftexversion=1.30.4
mandir=manual
distdate=`date +%y%m%d`
distrev=`awk '/Id:/{print $$4; exit}' $(mandir)/pdftex-t.tex`

distall=pdftex-w.tex pdftex-t.txt pdftex-t.tex \
	pdftex-i.tex syntaxform.awk Makefile makefiles.cmd \
	pdftex-a.pdf pdftex-l.pdf pdftex-s.pdf \
	pdftex-syntax.txt README Changelog

distnopdf=pdftex-w.tex pdftex-t.txt pdftex-t.tex \
	pdftex-i.tex syntaxform.awk Makefile makefiles.cmd \
	pdftex-syntax.txt README Changelog

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

zip:	$(distnopdf)
	cd .. && zip $(mandir)/pdftex-$(pdftexversion)-userman-$(distrev)-src.zip \
	$(patsubst %, $(mandir)/%, $(distnopdf))

clean:
	texutil --purge

allclean:
	- rm -f pdftex-a.pdf pdftex-l.pdf pdftex-s.pdf
	- rm -f pdftex-b.pdf pdftex-b-e.pdf pdftex-b-o.pdf
	- rm -f pdftex-syntax.txt
	- rm -f pdftex-w.pdf pdftex-t.txt
	make clean
