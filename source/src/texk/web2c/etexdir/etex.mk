# Makefile fragment for e-TeX and web2c. --infovore@xs4all.nl. Public domain.
# This fragment contains the parts of the makefile that are most likely to
# differ between releases of e-TeX.

Makefile: etexdir/etex.mk

# We build etex.
etex = etex

# The C sources.
etex_c = etexini.c etex0.c etex1.c etex2.c
etex_o = etexini.o etex0.o etex1.o etex2.o etexextra.o

# Making etex.
etex: $(etex_o)
	$(kpathsea_link) $(etex_o) $(socketlibs) $(LOADLIBES)

# C file dependencies
$(etex_c) etexcoerce.h etexd.h: etex.p $(web2c_texmf)
	$(web2c) etex
etexextra.c: lib/texmfmp.c
	sed s/TEX-OR-MF-OR-MP/etex/ $(srcdir)/lib/texmfmp.c >$@

# Tangling
etex.p etex.pool: tangle etex.web etex.ch
	./tangle etex.web etex.ch

# Generation of the web and ch file.
etex.web: tie tex.web \
          etexdir/etex.ch0 \
          etexdir/etex.ch \
          etexdir/etex.fix \
          etexdir/etex.ch1 \
          etexdir/etex.mk
	./tie -m etex.web $(srcdir)/tex.web \
		$(srcdir)/etexdir/etex.ch0 \
		$(srcdir)/etexdir/etex.ch \
		$(srcdir)/etexdir/etex.fix \
		$(srcdir)/etexdir/etex.ch1
etex.ch: tie etex.web \
         etexdir/tex.ch0 \
         tex.ch \
         etexdir/tex.ch1 \
         etexdir/tex.ech \
         etexdir/tex.ch2 \
         etexdir/etex.mk
	./tie -c etex.ch etex.web \
		$(srcdir)/etexdir/tex.ch0 \
		$(srcdir)/tex.ch \
		$(srcdir)/etexdir/tex.ch1 \
		$(srcdir)/etexdir/tex.ech \
		$(srcdir)/etexdir/tex.ch2

# Tests...
check: etex-check
etex-check: etrip etex.efmt
# Test truncation (but don't bother showing the warning msg).
	./etex --progname=etex --output-comment="`cat $(srcdir)/PROJECTS`" \
	  $(srcdir)/tests/hello 2>/dev/null \
	  && ./dvitype hello.dvi | grep olaf@infovore.xs4all.nl >/dev/null
# \openout should show up in \write's.
	./etex --progname=etex $(srcdir)/tests/openout && grep xfoo openout.log
# one.two.tex -> one.two.log
	./etex --progname=etex $(srcdir)/tests/one.two && ls -l one.two.log
# uno.dos -> uno.log
	./etex --progname=etex $(srcdir)/tests/uno.dos && ls -l uno.log
	./etex --progname=etex $(srcdir)/tests/just.texi && ls -l just.log
	-./etex --progname=etex $(srcdir)/tests/batch.tex
	./etex --progname=etex --shell $(srcdir)/tests/write18 | grep echo
# tcx files are a bad idea.
#	./etex --translate-file=$(srcdir)/share/isol1-t1.tcx \
#	  $(srcdir)/tests/eight && ./dvitype eight.dvi >eigh.typ
	./etex --mltex --progname=einitex $(srcdir)/tests/mltextst
	-./etex --progname=etex </dev/null
	-PATH=`pwd`:$(kpathsea_dir):$(kpathsea_srcdir):$$PATH \
	  WEB2C=$(kpathsea_srcdir) TMPDIR=.. \
	  ./etex --progname=etex '\nonstopmode\font\foo=nonesuch\end'

# Cleaning up.
clean:: etex-clean
etex-clean: etrip-clean
	$(LIBTOOL) --mode=clean $(RM) etex
	rm -f $(etex_o) $(etex_c) etexextra.c etexcoerce.h etexd.h
	rm -f etex.p etex.pool etex.web etex.ch
	rm -f etex.efmt etex.log
	rm -f hello.dvi hello.log xfoo.out openout.log one.two.log uno.log
	rm -f just.log batch.log write18.log mltextst.log texput.log
	rm -f missfont.log
	rm -rf tfm

# etrip
etestdir = $(srcdir)/etexdir/etrip
etestenv = TEXMFCNF=$(etestdir)

triptrap: etrip
etrip: pltotf tftopl etex dvitype etrip-clean
	@echo ">>> See $(etestdir)/etrip.diffs for example of acceptable diffs." >&2
	@echo "*** TRIP test for e-TeX in compatibility mode ***."
	./pltotf $(testdir)/trip.pl trip.tfm
	./tftopl ./trip.tfm trip.pl
	-diff $(testdir)/trip.pl trip.pl
	$(LN) $(testdir)/trip.tex . # get same filename in log
	-$(SHELL) -c '$(etestenv) ./etex --progname=einitex <$(testdir)/trip1.in >ctripin.fot'
	mv trip.log ctripin.log
	-diff $(testdir)/tripin.log ctripin.log
	-$(SHELL) -c '$(etestenv) ./etex <$(testdir)/trip2.in >ctrip.fot'
	mv trip.log ctrip.log
	-diff $(testdir)/trip.fot ctrip.fot
	-$(DIFF) $(DIFFFLAGS) $(testdir)/trip.log ctrip.log
	$(SHELL) -c '$(etestenv) ./dvitype $(dvitype_args) trip.dvi >ctrip.typ'
	-$(DIFF) $(DIFFFLAGS) $(testdir)/trip.typ ctrip.typ
	@echo "*** TRIP test for e-TeX in extended mode ***."
	-$(SHELL) -c '$(etestenv) ./etex --progname=einitex <$(etestdir)/etrip1.in >xtripin.fot'
	mv trip.log xtripin.log
	-diff ctripin.log xtripin.log
	-$(SHELL) -c '$(etestenv) ./etex <$(etestdir)/trip2.in >xtrip.fot'
	mv trip.log xtrip.log
	-diff ctrip.fot xtrip.fot
	-$(DIFF) $(DIFFFLAGS) ctrip.log xtrip.log
	$(SHELL) -c '$(etestenv) ./dvitype $(dvitype_args) trip.dvi >xtrip.typ'
	-$(DIFF) $(DIFFFLAGS) ctrip.typ xtrip.typ
	@echo "*** e-TeX specific part of e-TRIP test ***."
	./pltotf $(etestdir)/etrip.pl etrip.tfm
	./tftopl ./etrip.tfm etrip.pl
	-diff $(etestdir)/etrip.pl etrip.pl
	$(LN) $(etestdir)/etrip.tex . # get same filename in log
	-$(SHELL) -c '$(etestenv) ./etex --progname=einitex <$(etestdir)/etrip2.in >etripin.fot'
	mv etrip.log etripin.log
	-diff $(etestdir)/etripin.log etripin.log
	-$(SHELL) -c '$(etestenv) ./etex <$(etestdir)/etrip3.in >etrip.fot'
	-diff $(etestdir)/etrip.fot etrip.fot
	-$(DIFF) $(DIFFFLAGS) $(etestdir)/etrip.log etrip.log
	diff $(etestdir)/etrip.out etrip.out
	$(SHELL) -c '$(etestenv) ./dvitype $(dvitype_args) etrip.dvi >etrip.typ'
	-$(DIFF) $(DIFFFLAGS) $(etestdir)/etrip.typ etrip.typ

# Cleaning up for the etrip.
etrip-clean:
	rm -f trip.tfm trip.pl trip.tex trip.efmt ctripin.fot ctripin.log
	rm -f ctrip.fot ctrip.log trip.dvi ctrip.typ
	rm -f xtripin.fot xtripin.log
	rm -f xtrip.fot xtrip.log xtrip.typ
	rm -f etrip.tfm etrip.pl etrip.tex etrip.efmt etripin.fot etripin.log
	rm -f etrip.fot etrip.log etrip.dvi etrip.out etrip.typ
	rm -f tripos.tex 8terminal.tex
	rm -rf tfm

# Distfiles ...
@MAINT@triptrapdiffs: etexdir/etrip/etrip.diffs
@MAINT@etexdir/etrip/etrip.diffs: etex
@MAINT@	$(MAKE) etrip | tail +1 >etexdir/etrip/etrip.diffs


# Dumps
all_efmts = etex.efmt $(efmts)

dumps: efmts
efmts: $(all_efmts)

etex.efmt: etex
	$(dumpenv) $(MAKE) progname=etex files="etex.src plain.tex cmr10.tfm" prereq-check
	$(dumpenv) ./etex --progname=etex --jobname=etex --ini \*\\input etex.src \\dump </dev/null

elatex.efmt: etex
	$(dumpenv) $(MAKE) progname=elatex files="latex.ltx" prereq-check
	$(dumpenv) ./etex --progname=elatex --jobname=elatex --ini \*\\input latex.ltx </dev/null

latex.efmt: etex
	$(dumpenv) $(MAKE) progname=latex files="latex.ltx" prereq-check
	$(dumpenv) ./etex --progname=latex --jobname=latex --ini \*\\input latex.ltx </dev/null

tex.efmt: etex
	$(dumpenv) $(MAKE) progname=tex files="plain.tex cmr10.tfm" prereq-check
	$(dumpenv) ./etex --progname=tex --jobname=tex --ini \\input plain \\dump </dev/null

olatex.efmt: etex
	$(dumpenv) $(MAKE) progname=olatex files="latex.ltx" prereq-check
	$(dumpenv) ./etex --progname=olatex --progname=olatex --ini \\input latex.ltx </dev/null

# Install
install-etex: install-etex-exec install-etex-data
install-etex-exec: install-etex-links
install-etex-data:: install-etex-dumps
install-etex-dumps: install-etex-fmts

install-programs: install-etex-programs
install-etex-programs: etex $(bindir)

install-links: install-etex-links
install-etex-links: install-etex-programs
	cd $(bindir) && (rm -f einitex evirtex; \
	  $(LN) etex einitex; $(LN) etex evirtex)
	efmts="$(efmts)"; \
	  for f in $$efmts; do base=`basename $$f .efmt`; \
	    (cd $(bindir) && (rm -f $$base; $(LN) etex $$base)); done

install-fmts: install-etex-fmts
install-etex-fmts: efmts
	$(SHELL) $(top_srcdir)/../mkinstalldirs $(fmtdir)
	efmts="$(all_efmts)"; \
	  for f in $$efmts; do $(INSTALL_DATA) $$f $(fmtdir)/$$f; done

install-data install-etex-data:: $(texpooldir)
	$(INSTALL_DATA) etex.pool $(texpooldir)/etex.pool

# end of etex.mk
