################################################################################
#
# Makefile  : fpTeX libraries
# Author    : Fabrice Popineau <Fabrice.Popineau@supelec.fr>
# Platform  : Win32, Microsoft VC++ 6.0, depends upon fpTeX 0.5 sources
# Time-stamp: <03/04/02 21:08:31 popineau>
#
################################################################################
root_srcdir = ..
INCLUDE=$(INCLUDE);$(root_srcdir)\texk

!include <msvc/common.mak>

# Package subdirectories.
subdirs = \
	libgnuw32	   \
	libgsw32	   \
	regex$(regexver)   \
	zlib$(zlibver)     \
	libpng$(pngver)    \
	jpeg$(jpgver)      \
#	libtiff$(tiffver)  \
	xpdf$(xpdfver)     \
	freetype2	   \
	libttf$(ttfver)    \
#	gifreader$(gifver) \
#	curl		   \
	expat$(expatver)   \
	geturl$(geturlver) \
#	unzip		   \
#	T1$(t1ver)

!include <msvc/subdirs.mak>
!include <msvc/clean.mak>

# Local Variables:
# mode: Makefile
# End:
