# $Id$
# Public domain.

include ../Common.mak

default: #test-nolink-not-yet-written

#test-nolink:
#	$(prog) test-nolink.tex

# to see the LaTeX example.
nolink-example:
# footline is wrongly linked:
	pdflatex nolink-example && mv nolink-example.pdf nolink-pdftex.pdf
# footline is correctly not linked:
	xelatex nolink-example && mv nolink-example.pdf nolink-xetex.pdf

clean:
	$(clean)
