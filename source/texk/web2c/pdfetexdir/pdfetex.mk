# Makefile fragment for pdfeTeX and web2c. --infovore@xs4all.nl. Public domain.
# This fragment contains the parts of the makefile that are most likely to
# differ between releases of pdfeTeX.

Makefile: $(srcdir)/pdfetexdir/pdfetex.mk

# We build pdfetex
pdfetex = pdfetex
pdfetexdir = pdfetexdir

# The C sources.
pdfetex_c = pdfetexini.c pdfetex0.c pdfetex1.c pdfetex2.c pdfetex3.c
pdfetex_o = pdfetexini.o pdfetex0.o pdfetex1.o pdfetex2.o pdfetex3.o pdfetexextra.o

# Making pdfetex
pdfetex: pdftexd.h $(pdfetex_o) $(pdfetexextra_o) $(pdftexlibsdep)
	@CXXHACKLINK@ $(pdfetex_o) $(pdfetexextra_o) $(pdftexlibs) $(socketlibs) @CXXHACKLDLIBS@ @CXXLDEXTRA@

# C file dependencies.
$(pdfetex_c) pdfetexcoerce.h pdfetexd.h: pdfetex.p $(web2c_texmf)
	$(web2c) pdfetex
pdfetexextra.c: lib/texmfmp.c
	sed s/TEX-OR-MF-OR-MP/pdfetex/ $(srcdir)/lib/texmfmp.c >$@

# Tangling
pdfetex.p pdfetex.pool: tangle pdfetex.web pdfetex.ch
	./tangle pdfetex.web pdfetex.ch

# Generation of the web and ch file.
pdfetex.web: tie tex.web \
             etexdir/etex.ch0 \
             etexdir/etex.ch \
             etexdir/etex.fix \
             etexdir/etex.ch1 \
             pdfetexdir/pdfetex.ch1 \
             pdftexdir/pdftex.ch \
             pdfetexdir/pdfetex.ch2 \
             pdfetexdir/pdfetex.h \
             pdfetexdir/pdfetex.defines \
             pdfetexdir/pdfetex.mk
	./tie -m pdfetex.web $(srcdir)/tex.web \
		$(srcdir)/etexdir/etex.ch0 \
		$(srcdir)/etexdir/etex.ch \
		$(srcdir)/etexdir/etex.fix \
		$(srcdir)/etexdir/etex.ch1 \
		$(srcdir)/pdfetexdir/pdfetex.ch1 \
		$(srcdir)/pdftexdir/pdftex.ch \
		$(srcdir)/pdfetexdir/pdfetex.ch2
pdfetex.ch: tie pdfetex.web pdfetexdir/tex.ch0 tex.ch etexdir/tex.ch1 \
            etexdir/tex.ech etexdir/tex.ch2 pdfetexdir/tex.ch1 \
	    pdftexdir/tex.pch pdfetexdir/tex.ch2 pdfetexdir/pdfetex.mk
	./tie -c pdfetex.ch pdfetex.web \
		$(srcdir)/pdfetexdir/tex.ch0 \
		$(srcdir)/tex.ch \
		$(srcdir)/etexdir/tex.ch1 \
		$(srcdir)/etexdir/tex.ech \
		$(srcdir)/etexdir/tex.ch2 \
		$(srcdir)/pdfetexdir/tex.ch1 \
		$(srcdir)/pdftexdir/tex.pch \
		$(srcdir)/pdfetexdir/tex.ch2

$(srcdir)/pdfetexdir/pdfetex.h: $(srcdir)/pdftexdir/pdftex.h
	cp -f $(srcdir)/pdftexdir/pdftex.h $@

$(srcdir)/pdfetexdir/pdfetex.defines: $(srcdir)/pdftexdir/pdftex.defines
	cp -f $(srcdir)/pdftexdir/pdftex.defines $@

check: pdfetex-check
pdfetex-check: pdfetex pdfetex.efmt

clean:: pdfetex-clean
pdfetex-clean:
	$(LIBTOOL) --mode=clean $(RM) pdfetex
	rm -f $(pdfetex_o) $(pdfetex_c) pdfetexextra.c pdfetexcoerce.h
	rm -f pdfetexd.h pdfetex.p pdfetex.pool pdfetex.web pdfetex.ch
	rm -f pdfetex.efmt pdfetex.log

# Dumps
all_pdfefmts = pdfetex.efmt $(pdfefmts)
pdfefmts: $(all_pdfefmts)

pdfetex.efmt: pdfetex
	$(dumpenv) $(MAKE) progname=pdfetex files="etex.src plain.tex cmr10.tfm" prereq-check
	$(dumpenv) ./pdfetex --progname=pdfetex --jobname=pdfetex --ini \*\\pdfoutput=1\\input etex.src \\dump </dev/null

pdfelatex.efmt: pdfetex
	$(dumpenv) $(MAKE) progname=pdfelatex files="latex.ltx" prereq-check
	$(dumpenv) ./pdfetex --progname=pdfelatex --jobname=pdfelatex --ini \*\\pdfoutput=1\\input latex.ltx </dev/null

pdflatex.efmt: pdfetex
	$(dumpenv) $(MAKE) progname=pdflatex files="latex.ltx" prereq-check
	$(dumpenv) ./pdfetex --progname=pdflatex --jobname=pdflatex --ini \*\\pdfoutput=1\\input latex.ltx </dev/null


# Installation.
install-pdfetex: install-pdfetex-exec install-pdfetex-data
install-pdfetex-exec: install-pdfetex-links
install-pdfetex-data:: install-pdfetex-dumps
install-pdfetex-dumps: install-pdfetex-fmts

# The actual binary executables and pool files.
install-programs: install-pdfetex-programs
install-pdfetex-programs: $(pdfetex) $(bindir)
	for p in pdfetex; do $(INSTALL_LIBTOOL_PROG) $$p $(bindir); done

install-links: install-pdfetex-links
install-pdfetex-links: install-pdfetex-programs
	cd $(bindir) && (rm -f inipdfetex virpdfetex; \
	  $(LN) pdfetex inipdfetex; $(LN) pdfetex virpdfetex)
	pdfefmts="$(pdfefmts)";
	  for f in $$pdfefmts; do base=`basename $$f .efmt`; \
	    (cd $(bindir) && (rm -f $$base; $(LN) pdfetex $$base)); done

install-fmts: install-pdfetex-fmts
install-pdfetex-fmts: pdfefmts $(fmtdir)
	pdfefmts="$(all_pdfefmts)";
	  for f in $$pdfefmts; do $(INSTALL_DATA) $$f $(fmtdir)/$$f; done

# Auxiliary files.
install-data install-pdfetex-data:: $(texpooldir)
	$(INSTALL_DATA) pdfetex.pool $(texpooldir)/pdfetex.pool

# end of pdfetex.mk
