# $Id$
# Public domain.

# Common Makefile definitions to run pdftex from test hierarchy,
# but use support files from an installation.

tl = /usr/local/texlive-rel
tl_dist = $(tl)/texmf-dist
#
plain = $(tl_dist)/tex/plain/base
plain_config = $(tl_dist)/tex/plain/config
generic_config = $(tl)/texmf-config/tex/generic/config
generic_hyphen = $(tl_dist)/tex/generic/hyphen
#
tfm_cm = $(tl_dist)/fonts/tfm/public/cm
tfm_knuth = $(tl_dist)/fonts/tfm/public/knuth-lib
t1_cm = $(tl_dist)/fonts/type1/public/amsfonts/cm
#
env = TEXINPUTS=.:$(plain):$(plain_config):$(generic_config):$(generic_hyphen)\
      TEXFONTS=.:$(tfm_cm):$(tfm_knuth):$(t1_cm) \
      TEXFONTMAPS=$(tl_dist)/fonts/map/pdftex/updmap \
      ENCFONTS=$(tl_dist)/fonts/enc/dvips/base \
      MKTEXTFM=0 \
      MKTEXPK=0 \
      KPATHSEA_WARNING=0

diff = diff --text -c0

pdftex = ../../source/build-pdftex/texk/web2c/pdftex
prog = $(env) $(pdftex) -ini -interaction=nonstopmode

# can't make the clean: target here since then it would be the default.
clean = rm -f *.log *.pdf *.fmt *.aux
