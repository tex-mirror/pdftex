################################################################################
#
# Makefile  : XPdf
# Author    : Fabrice Popineau <Fabrice.Popineau@supelec.fr>
# Platform  : Win32, Microsoft VC++ 6.0, depends upon fpTeX 0.5 sources
# Time-stamp: <02/12/25 22:41:37 popineau>
#
################################################################################
root_srcdir=..\..
INCLUDE=$(INCLUDE);$(root_srcdir)\texk

!include <msvc/common.mak>

# Package subdirectories.
subdirs = goo xpdf doc

!include <msvc/subdirs.mak>
!include <msvc/clean.mak>

distclean::
	-@$(del) aconf.h

#
# Local Variables:
# mode: Makefile
# End:
