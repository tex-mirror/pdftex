################################################################################
#
# Makefile  : fpTeX libraries
# Author    : Fabrice Popineau <Fabrice.Popineau@supelec.fr>
# Platform  : Win32, Microsoft VC++ 6.0, depends upon fpTeX 0.5 sources
# Time-stamp: <03/07/22 05:10:55 popineau>
#
################################################################################
root_srcdir = ..
INCLUDE=$(INCLUDE);$(root_srcdir)\texk

!include <msvc/common.mak>

prereqfiles = \
	"$(MSDEV)\Visual Studio .NET Enterprise Architect 2003 - English\MSVCP71.dll" \
	"$(MSDEV)\Visual Studio .NET Enterprise Architect 2003 - English\MSVCR71.dll" \
	"c:\Windows\System32\MFC71.dll" \
	c:\Local\ActiveState\Perl\bin\perl58.dll \
#	$(jpegdll) \
#	$(pngdll) \
#	$(zlibdll) \
#	$(bzip2dll)

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
	md5		   \
	expat$(expatver)   \
	geturl$(geturlver) \
#	unzip		   \
#	T1$(t1ver)

!include <msvc/subdirs.mak>

install:: prerequisites

prerequisites: $(prereqfiles)
	for %%f in ($(prereqfiles)) do $(copy) %%f $(bindir)

!include <msvc/clean.mak>

# Local Variables:
# mode: Makefile
# End:
