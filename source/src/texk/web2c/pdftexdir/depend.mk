# Manually modfied!
# $Id$
avlstuff.o: avlstuff.c avlstuff.h
avlstuff.c: ptexlib.h avl.h ../../kpathsea/c-vararg.h \
 ../../kpathsea/c-proto.h
avlstuff.h: avl.h
epdf.o: epdf.c epdf.h ptexlib.h ../../kpathsea/c-vararg.h \
 ../../kpathsea/c-proto.h
epdf.h: ../c-auto.h ../config.h ../../kpathsea/c-auto.h \
 ../../kpathsea/c-proto.h ../../kpathsea/c-vararg.h \
 ../../kpathsea/types.h ../../../libs/obsdcompat/openbsd-compat.h \
 ptexmac.h
image.h: ../../../../src/libs/libpng/png.h 
mapfile.o: mapfile.c ptexlib.h ../../kpathsea/c-auto.h \
 ../../kpathsea/c-memstr.h
pdflib.o: pdflib.cc pdflib.h ../../../libs/xpdf/xpdf/config.h \
../../../libs/xpdf/xpdf/GlobalParams.h
pdflib.h: pdftoepdf.cc ../../../libs/xpdf/aconf.h \
 ../../../libs/xpdf/goo/gfile.h ../../../libs/xpdf/goo/GString.h \
 ../../../libs/xpdf/xpdf/Array.h ../../../libs/xpdf/xpdf/Dict.h \
 ../../../libs/xpdf/xpdf/Error.h ../../../libs/xpdf/xpdf/GfxFont.h \
 ../../../libs/xpdf/xpdf/Link.h ../../../libs/xpdf/xpdf/Object.h \
 ../../../libs/xpdf/xpdf/PDFDoc.h ../../../libs/xpdf/xpdf/Stream.h \
 ../../../libs/xpdf/xpdf/XRef.h
pdftoepdf.o: pdftoepdf.cc pdflib.h epdf.h
pkin.o: pkin.c ptexlib.h 
ptexlib.h: avlstuff.h ptexmac.h ../config.h ../cpascal.h ../help.h \
 ../pdftexcoerce.h ../pdftexd.h ../texmfmem.h ../texmfmp.h \
 ../../../libs/obsdcompat/openbsd-compat.h
subfont.o: subfont.c ptexlib.h
tounicode.o: tounicode.c ptexlib.h
utils.o: utils.c pdflib.h ptexlib.h ../../kpathsea/c-fopen.h \
 ../../kpathsea/c-proto.h ../../kpathsea/c-stat.h \
 ../../kpathsea/str-list.h ../../../libs/md5/md5.h pdftexextra.h \
../../../libs/obsdcompat/openbsd-compat.h ../../../libs/zlib/zconf.h \
../../../libs/zlib/zlib.h ../../../../src/libs/libpng/png.h
vfpacket.o: vfpacket.c ptexlib.h 
writeenc.o: writeenc.c ptexlib.h
writefont.o: writefont.c ptexlib.h
writeimg.o: writeimg.c image.h ptexlib.h ../../kpathsea/c-auto.h \
 ../../kpathsea/c-memstr.h
writejbig2.o: writejbig2.c writejbig2.h
writejpg.o: writejpg.c ptexlib.h image.h
writepng.o: writepng.c ptexlib.h image.h
writet1.o: writet1.c ptexlib.h ../../kpathsea/c-vararg.h \
 ../../kpathsea/c-proto.h
writet3.o: writet3.c ptexlib.h ../../kpathsea/c-vararg.h \
 ../../kpathsea/c-proto.h
writettf.o: writettf.c ptexlib.h writettf.h macnames.c
writezip.o: writezip.c ptexlib.h ../../../libs/zlib/zlib.h \
 ../../../libs/zlib/zconf.h
#
ttf2afm.o: ttf2afm.c ptexmac.h writettf.h macnames.c ../../kpathsea/kpathsea.h
pdftosrc.o: pdftosrc.cc pdflib.h
# vim: set noexpandtab
