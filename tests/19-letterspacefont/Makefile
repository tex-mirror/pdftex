include ../Common.mak

pdftex2 ?= /usr/local/texlive/2021basic/bin/local/pdftex2
# pdftex2 is a copy of ../../source/build-pdftex/texk/web2c/pdftex
# why? I have only mactex basic installed, not whole tl

prog = $(pdftex2) -fmt pdfetex

test:
	$(prog) ./f.tex

test2:
	$(prog)  ./f2.tex

fmt:
	$(pdftex2) -ini '*pdfetex.ini'

clean:
	$(clean)
