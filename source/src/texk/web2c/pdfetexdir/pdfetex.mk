# Makefile fragment for pdfeTeX and web2c. --infovore@xs4all.nl. Public domain.
# This fragment contains the parts of the makefile that are most likely to
# differ between releases of pdfeTeX.

Makefile: $(srcdir)/pdfetexdir/pdfetex.mk

# pdfetex_bin = pdfetex ttf2afm pdftosrc
pdfetex_bin = pdfetex
linux_build_dir = $(HOME)/pdftex/build/linux/texk/web2c

# We build pdfetex
pdfetex = @PETEX@ pdfetex
pdfetexdir = pdfetexdir

# Extract pdfetex version
pdfetexdir/pdfetex.version: $(srcdir)/pdfetexdir/pdfetex.web
	test -d pdfetexdir || mkdir pdfetexdir
	grep '^@d pdftex_version_string==' $(srcdir)/pdfetexdir/pdfetex.web \
	  | sed "s/^.*'-//;s/'.*$$//" \
	  >pdfetexdir/pdfetex.version
          
# The C sources.
pdfetex_c = pdfetexini.c pdfetex0.c pdfetex1.c pdfetex2.c pdfetex3.c 
pdfetex_o = pdfetexini.o pdfetex0.o pdfetex1.o pdfetex2.o pdfetex3.o pdfetexextra.o

# Making pdfetex
pdfetex: pdfetexd.h $(pdfetex_o) $(pdfetexextra_o) $(pdfetexlibsdep)
	@CXXHACKLINK@ $(pdfetex_o) $(pdfetexextra_o) $(pdfetexlibs) $(socketlibs) @CXXHACKLDLIBS@ @CXXLDEXTRA@

# C file dependencies.
$(pdfetex_c) pdfetexcoerce.h pdfetexd.h: pdfetex.p $(web2c_texmf) $(srcdir)/pdfetexdir/pdfetex.defines $(srcdir)/pdfetexdir/pdfetex.h
	$(web2c) pdfetex
pdfetexextra.c: pdfetexdir/pdfetexextra.h lib/texmfmp.c
	test -d pdfetexdir || mkdir pdfetexdir
	sed s/TEX-OR-MF-OR-MP/pdfetex/ $(srcdir)/lib/texmfmp.c >$@
pdfetexdir/pdfetexextra.h: pdfetexdir/pdfetexextra.in pdfetexdir/pdfetex.version etexdir/etex.version
	test -d pdfetexdir || mkdir pdfetexdir
	sed -e s/PDFTEX-VERSION/`cat pdfetexdir/pdfetex.version`/ \
	    -e s/ETEX-VERSION/`cat etexdir/etex.version`/ \
	  $(srcdir)/pdfetexdir/pdfetexextra.in >$@

# Tangling
pdfetex.p pdfetex.pool: tangle $(srcdir)/pdfetexdir/pdfetex.web pdfetex.ch
	$(TANGLE) $(srcdir)/pdfetexdir/pdfetex.web pdfetex.ch

#   Sources for pdfetex.ch:
pdfetex_ch_srcs = $(srcdir)/pdfetexdir/pdfetex.web \
  $(srcdir)/pdfetexdir/tex.ch0 \
  $(srcdir)/tex.ch \
  $(srcdir)/pdfetexdir/pdfetex.ch1 \
  $(srcdir)/etexdir/tex.ch1 \
  $(srcdir)/etexdir/tex.ech \
  $(srcdir)/pdfetexdir/tex.ch1 \
  $(srcdir)/pdfetexdir/tex.pch \
  $(srcdir)/pdfetexdir/pdfetex.ch2
#   Rules:
pdfetex.ch: $(TIE) $(pdfetex_ch_srcs)
	$(TIE) -c pdfetex.ch $(pdfetex_ch_srcs)

# for developing only
pdfetex-org.web: $(TIE) $(pdfetex_ch_srcs_org)
	$(TIE) -m $@ $(pdfetex_ch_srcs_org)
pdfetex-all.web: $(TIE) $(srcdir)/pdfetexdir/pdfetex.web pdfetex.ch
	$(TIE) -m $@ $(srcdir)/pdfetexdir/pdfetex.web pdfetex.ch
pdfetex-all.tex: pdfetex-all.web
	$(WEAVE) pdfetex-all.web
pdfetex-all.pdf: pdfetex-all.tex
	$(pdfetex) pdfetex-all.tex

check: @PETEX@ pdfetex-check
pdfetex-check: pdfetex pdfetex.fmt

clean:: pdfetex-clean
pdfetex-clean:
	$(LIBTOOL) --mode=clean $(RM) pdfetex
	rm -f $(pdfetex_o) $(pdfetex_c) pdfetexextra.c pdfetexcoerce.h
	rm -f pdfetexdir/pdfetexextra.h
	rm -f pdfetexd.h pdfetex.p pdfetex.pool pdfetex.ch
	rm -f pdfetex.fmt pdfetex.log

# Dumps
all_pdfefmts = @FMU@ pdfetex.fmt $(pdfefmts)

dumps: @PETEX@ pdfefmts
pdfefmts: $(all_pdfefmts)

pdfefmtdir = $(web2cdir)/pdfetex
$(pdfefmtdir)::
	$(SHELL) $(top_srcdir)/../mkinstalldirs $(pdfefmtdir)

pdfetex.fmt: pdfetex
	$(dumpenv) $(MAKE) progname=pdfetex files="etex.src plain.tex cmr10.tfm" prereq-check
	$(dumpenv) ./pdfetex --progname=pdfetex --jobname=pdfetex --ini \*\\pdfoutput=1\\input etex.src \\dump </dev/null

pdflatex.fmt: pdfetex
	$(dumpenv) $(MAKE) progname=pdflatex files="latex.ltx" prereq-check
	$(dumpenv) ./pdfetex --progname=pdflatex --jobname=pdflatex --ini \*\\pdfoutput=1\\input latex.ltx </dev/null

# 
# Installation.
install-pdfetex: install-pdfetex-exec install-pdfetex-data
install-pdfetex-exec: install-pdfetex-links
install-pdfetex-data: install-pdfetex-pool @FMU@ install-pdfetex-dumps
install-pdfetex-dumps: install-pdfetex-fmts

# The actual binary executables and pool files.
install-programs: @PETEX@ install-pdfetex-programs
install-pdfetex-programs: $(pdfetex) $(bindir)
	for p in pdfetex; do $(INSTALL_LIBTOOL_PROG) $$p $(bindir); done

install-links: @PETEX@ install-pdfetex-links
install-pdfetex-links: install-pdfetex-programs
	#cd $(bindir) && (rm -f pdfeinitex pdfevirtex; \
	#  $(LN) pdfetex pdfeinitex; $(LN) pdfetex pdfevirtex)

install-fmts: @PETEX@ install-pdfetex-fmts
install-pdfetex-fmts: pdfefmts $(pdfefmtdir)
	pdfefmts="$(all_pdfefmts)"; \
	  for f in $$pdfefmts; do $(INSTALL_DATA) $$f $(pdfefmtdir)/$$f; done
	pdfefmts="$(pdfefmts)"; \
	  for f in $$pdfefmts; do base=`basename $$f .fmt`; \
	    (cd $(bindir) && (rm -f $$base; $(LN) pdfetex $$base)); done

# Auxiliary files.
install-data:: @PETEX@ install-pdfetex-data
install-pdfetex-pool: pdfetex.pool $(texpooldir)
	$(INSTALL_DATA) pdfetex.pool $(texpooldir)/pdfetex.pool

# 
# ttf2afm
ttf2afm = ttf2afm

ttf2afm: ttf2afm.o
	$(kpathsea_link) ttf2afm.o $(kpathsea)
ttf2afm.o: ttf2afm.c macnames.c
	$(compile) -c $< -o $@
ttf2afm.c: $(srcdir)/pdfetexdir/ttf2afm.c
	cp $(srcdir)/pdfetexdir/ttf2afm.c .
macnames.c: $(srcdir)/pdfetexdir/macnames.c
	cp $(srcdir)/pdfetexdir/macnames.c .
check: ttf2afm-check
ttf2afm-check: ttf2afm
clean:: ttf2afm-clean
ttf2afm-clean:
	$(LIBTOOL) --mode=clean $(RM) ttf2afm
	rm -f ttf2afm.o macnames.o
	rm -f ttf2afm.c macnames.c
# 
# pdftosrc
pdftosrc = pdftosrc

pdftosrc: pdfetexdir/pdftosrc.o $(LIBXPDFDEP)
	@CXXHACKLINK@ pdfetexdir/pdftosrc.o $(LDLIBXPDF) -lm @CXXLDEXTRA@
pdfetexdir/pdftosrc.o:$(srcdir)/pdfetexdir/pdftosrc.cc
	cd pdfetexdir && $(MAKE) pdftosrc.o
check: pdftosrc-check
pdftosrc-check: pdftosrc
clean:: pdftosrc-clean
pdftosrc-clean:
	$(LIBTOOL) --mode=clean $(RM) pdftosrc
# 
# pdfetex binaries archive
pdfetexbin:
	$(MAKE) $(pdfetex_bin)

pdfetex-cross:
	$(MAKE) web2c-cross
	$(MAKE) pdfetexbin

web2c-cross: $(web2c_programs)
	@if test ! -x $(linux_build_dir)/tangle; then echo Error: linux_build_dir not ready; exit -1; fi
	rm -f web2c/fixwrites web2c/splitup web2c/web2c
	cp -f $(linux_build_dir)/web2c/fixwrites web2c
	cp -f $(linux_build_dir)/web2c/splitup web2c
	cp -f $(linux_build_dir)/web2c/web2c web2c
	touch web2c/fixwrites web2c/splitup web2c/web2c
	$(MAKE) tangleboot && rm -f tangleboot && \
	cp -f $(linux_build_dir)/tangleboot .  && touch tangleboot
	$(MAKE) ctangleboot && rm -f ctangleboot && \
	cp -f $(linux_build_dir)/ctangleboot .  && touch ctangleboot
	$(MAKE) ctangle && rm -f ctangle && \
	cp -f $(linux_build_dir)/ctangle .  && touch ctangle
	$(MAKE) tie && rm -f tie && \
	cp -f $(linux_build_dir)/tie .  && touch tie
	$(MAKE) tangle && rm -f tangle && \
	cp -f $(linux_build_dir)/tangle .  && touch tangle

# vim: set noexpandtab
# end of pdfetex.mk
