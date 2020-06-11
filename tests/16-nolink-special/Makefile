# $Id$
# Public domain.

# set texlive location; can be done here, or via env. variable
# tl = ~/IdeaProjects/texlive/Master

include ../Common.mak

default: #test-nolink-not-yet-written

nolink-xetex:
# footline is correctly not linked:
	xelatex nolink-xetex

nolink-pdftex:
	$(pdftex) -progname=pdflatex nolink-pdftex

fmt:
	$(pdftex) -ini -etex -env pdflatex.ini

clean:
	$(clean)
