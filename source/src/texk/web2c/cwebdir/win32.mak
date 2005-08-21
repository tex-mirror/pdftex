################################################################################
#
# Makefile  : CWeb
# Author    : Fabrice Popineau <Fabrice.Popineau@supelec.fr>
# Platform  : Win32, Microsoft VC++ 6.0, depends upon fpTeX 0.5 sources
# Time-stamp: <02/02/05 00:35:09 popineau>
#
################################################################################
root_srcdir = ..\..
INCLUDE=$(INCLUDE);$(root_srcdir)\texk
#
# For BSD Unix use the following CFLAGS definition
# CFLAGS = -Dstrchr=index
#
# This Makefile does not work for MSDOS. Make your 
# own one, or compile by hand.
#

USE_KPATHSEA = 1
USE_GNUW32 = 1

!include <msvc/common.mak>

# optflags = $(optflags:G5r=G5)

ctangle = $(objdir)\ctangle.exe
cweave = $(objdir)\cweave.exe

objects = $(ctangle:.exe=.obj) $(cweave:.exe=.obj)
programs = $(ctangle) $(cweave)
manfiles = cweb.1
sources = cweave.w common.w ctangle.w

pdftex = pdftex
# pdftex = dvipdfm

tchanges = ctang-w32.ch
wchanges = cweav-w32.ch
cchanges = comm-w32.ch

DEFS = $(DEFS) -DCWEBINPUTS="\"c:/\""

.SUFFIXES: .dvi .tex .w .pdf

.w.tex:
	$(cweave) $* null.ch

.tex.dvi:	
	tex $<

.w.dvi:
	$(cweave) $*.tex
	tex $*.dvi

.w.c:
	$(ctangle) $*

.w.pdf:
	$(cweave) $*.tex
!if ("$(pdftex)" == "dvipdfm")
	tex "\let\pdf+ \input $*" && dvipdfm $*
!elseif ("$(pdftex)" == "pdftex")
	pdftex $*
!endif

all: $(objdir) $(programs)

cautiously: $(ctangle)
	$(copy) common.c save-common.c
	$(ctangle) common $(cchanges)
	$(diff) common.c save-common.c
	$(del) save-common.c
	$(copy) ctangle.c save-ctangle.c
	$(ctangle) ctangle $(tchanges)
	$(diff) ctangle.c save-ctangle.c
	$(del) save-ctangle.c

save-ctangle.c:
	$(copy) ctangle.c $@

save-common.c:
	$(copy) common.c $@

$(objdir)\ctangle.exe: $(objdir)\ctangle.obj $(objdir)\common.obj
	$(link) $(**) $(conlibs)

$(objdir)\cweave.exe: $(objdir)\cweave.obj $(objdir)\common.obj
	$(link) $(**) $(conlibs)

$(objdir)\ctangle.obj: ctangle.c

$(objdir)\cweave.obj: cweave.c

ctangle.c: ctangle.w $(tchanges)
	$(ctangle) ctangle $(tchanges)

cweave.c: cweave.w $(wchanges)
	$(ctangle) cweave $(wchanges)

common.c: common.w $(cchanges)
	$(ctangle) common $(cchanges)

!include <msvc/config.mak>
!include <msvc/install.mak>

install:: install-exec install-man

usermanual: cwebman.tex cwebmac.tex
	tex cwebman

fullmanual: $(cweave) usermanual $(sources) comm-man.ch ctang-man.ch cweav-man.ch
	$(cweave) common.w comm-man.ch
	tex common.tex
	$(cweave) ctangle.w ctang-man.ch
	tex ctangle.tex
	$(cweave) cweave.w cweav-man.ch
	tex cweave.tex

!include <msvc/clean.mak>
!include <msvc/rdepend.mak>
!include "./depend.mak"

#
# Local Variables:
# mode: makefile
# End:
