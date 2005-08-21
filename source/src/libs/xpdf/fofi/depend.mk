FoFiBase.o: $(srcdir)/FoFiBase.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/FoFiBase.h \
  ../../../../src/libs/xpdf/goo/gtypes.h
FoFiEncodings.o: $(srcdir)/FoFiEncodings.cc \
  ../aconf.h ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/FoFiEncodings.h \
  ../../../../src/libs/xpdf/goo/gtypes.h
FoFiTrueType.o: $(srcdir)/FoFiTrueType.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  ../../../../src/libs/xpdf/goo/GHash.h \
  $(srcdir)/FoFiTrueType.h \
  $(srcdir)/FoFiBase.h
FoFiType1.o: $(srcdir)/FoFiType1.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/FoFiEncodings.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/FoFiType1.h \
  $(srcdir)/FoFiBase.h
FoFiType1C.o: $(srcdir)/FoFiType1C.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/FoFiEncodings.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/FoFiType1C.h \
  $(srcdir)/FoFiBase.h
