include ../Common.mak

all: fmt test

test:
	$(pdftex2) -fmt pdflatex f.tex

fmt:
	$(pdftex2) -ini -etex -env pdflatex.ini

clean:
	$(clean)
	rm -f pdfa.xmpi
