Array.o: $(srcdir)/Array.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h
BuiltinFont.o: $(srcdir)/BuiltinFont.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/FontEncodingTables.h \
  $(srcdir)/BuiltinFont.h \
  ../../../../src/libs/xpdf/goo/gtypes.h
BuiltinFontTables.o: $(srcdir)/BuiltinFontTables.cc \
  ../aconf.h ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/FontEncodingTables.h \
  $(srcdir)/BuiltinFontTables.h \
  $(srcdir)/BuiltinFont.h \
  ../../../../src/libs/xpdf/goo/gtypes.h
Catalog.o: $(srcdir)/Catalog.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/XRef.h \
  $(srcdir)/Page.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Link.h \
  $(srcdir)/Catalog.h
CharCodeToUnicode.o: $(srcdir)/CharCodeToUnicode.cc \
  ../aconf.h ../../../../src/libs/xpdf/aconf2.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/gfile.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/GlobalParams.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/PSTokenizer.h \
  $(srcdir)/CharCodeToUnicode.h
CMap.o: $(srcdir)/CMap.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/gfile.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/GlobalParams.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/PSTokenizer.h \
  $(srcdir)/CMap.h
Decrypt.o: $(srcdir)/Decrypt.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Decrypt.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h
Dict.o: $(srcdir)/Dict.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/XRef.h
Error.o: $(srcdir)/Error.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/GlobalParams.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h
FontEncodingTables.o:  \
 $(srcdir)/FontEncodingTables.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/FontEncodingTables.h
Function.o: $(srcdir)/Function.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Function.h
GfxFont.o: $(srcdir)/GfxFont.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/GlobalParams.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/CMap.h \
  $(srcdir)/CharCodeToUnicode.h \
  $(srcdir)/FontEncodingTables.h \
  $(srcdir)/BuiltinFontTables.h \
  $(srcdir)/BuiltinFont.h \
  ../../../../src/libs/xpdf/fofi/FoFiType1.h \
  ../../../../src/libs/xpdf/fofi/FoFiBase.h \
  ../../../../src/libs/xpdf/fofi/FoFiType1C.h \
  ../../../../src/libs/xpdf/fofi/FoFiTrueType.h \
  $(srcdir)/GfxFont.h
GfxState.o: $(srcdir)/GfxState.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Page.h \
  $(srcdir)/GfxState.h \
  $(srcdir)/Function.h
GlobalParams.o: $(srcdir)/GlobalParams.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  ../../../../src/libs/xpdf/goo/GList.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GHash.h \
  ../../../../src/libs/xpdf/goo/gfile.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/NameToCharCode.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/CharCodeToUnicode.h \
  $(srcdir)/UnicodeMap.h \
  $(srcdir)/CMap.h \
  $(srcdir)/BuiltinFontTables.h \
  $(srcdir)/BuiltinFont.h \
  $(srcdir)/FontEncodingTables.h \
  $(srcdir)/GlobalParams.h \
  $(srcdir)/NameToUnicodeTable.h \
  $(srcdir)/UnicodeMapTables.h \
  $(srcdir)/UTF8.h
JArithmeticDecoder.o:  \
 $(srcdir)/JArithmeticDecoder.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/JArithmeticDecoder.h
JBIG2Stream.o: $(srcdir)/JBIG2Stream.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  ../../../../src/libs/xpdf/goo/GList.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/JArithmeticDecoder.h \
  $(srcdir)/JBIG2Stream.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Stream-CCITT.h
JPXStream.o: $(srcdir)/JPXStream.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/JArithmeticDecoder.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/JPXStream.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h
Lexer.o: $(srcdir)/Lexer.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/Lexer.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h
Link.o: $(srcdir)/Link.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Link.h
NameToCharCode.o: $(srcdir)/NameToCharCode.cc \
  ../aconf.h ../../../../src/libs/xpdf/aconf2.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/NameToCharCode.h \
  $(srcdir)/CharTypes.h
Object.o: $(srcdir)/Object.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/XRef.h
Outline.o: $(srcdir)/Outline.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  ../../../../src/libs/xpdf/goo/GList.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/Link.h \
  $(srcdir)/Object.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/PDFDocEncoding.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/Outline.h
OutputDev.o: $(srcdir)/OutputDev.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/GfxState.h \
  $(srcdir)/Function.h \
  $(srcdir)/OutputDev.h \
  $(srcdir)/CharTypes.h
Page.o: $(srcdir)/Page.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/GlobalParams.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/XRef.h \
  $(srcdir)/Link.h \
  $(srcdir)/OutputDev.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Page.h
Parser.o: $(srcdir)/Parser.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Parser.h \
  $(srcdir)/Lexer.h \
  $(srcdir)/XRef.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/Decrypt.h
PDFDoc.o: $(srcdir)/PDFDoc.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/config.h \
  $(srcdir)/GlobalParams.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/Page.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Catalog.h \
  $(srcdir)/XRef.h \
  $(srcdir)/Link.h \
  $(srcdir)/OutputDev.h \
  $(srcdir)/Error.h \
  $(srcdir)/ErrorCodes.h \
  $(srcdir)/Lexer.h \
  $(srcdir)/Parser.h \
  $(srcdir)/SecurityHandler.h \
  $(srcdir)/Outline.h \
  $(srcdir)/PDFDoc.h
PDFDocEncoding.o: $(srcdir)/PDFDocEncoding.cc \
  $(srcdir)/PDFDocEncoding.h \
  $(srcdir)/CharTypes.h
PSTokenizer.o: $(srcdir)/PSTokenizer.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h \
  $(srcdir)/PSTokenizer.h \
  ../../../../src/libs/xpdf/goo/gtypes.h
SecurityHandler.o: $(srcdir)/SecurityHandler.cc \
  ../aconf.h ../../../../src/libs/xpdf/aconf2.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/PDFDoc.h \
  $(srcdir)/XRef.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Catalog.h \
  $(srcdir)/Page.h \
  $(srcdir)/Decrypt.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/GlobalParams.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/SecurityHandler.h
Stream.o: $(srcdir)/Stream.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/gfile.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  $(srcdir)/config.h \
  $(srcdir)/Error.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Lexer.h \
  $(srcdir)/Decrypt.h \
  $(srcdir)/GfxState.h \
  $(srcdir)/Function.h \
  $(srcdir)/JBIG2Stream.h \
  $(srcdir)/JPXStream.h \
  $(srcdir)/Stream-CCITT.h
UnicodeMap.o: $(srcdir)/UnicodeMap.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  ../../../../src/libs/xpdf/goo/gfile.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  ../../../../src/libs/xpdf/goo/GList.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/GlobalParams.h \
  $(srcdir)/CharTypes.h \
  $(srcdir)/UnicodeMap.h
XRef.o: $(srcdir)/XRef.cc ../aconf.h \
  ../../../../src/libs/xpdf/aconf2.h ../../../../src/libs/xpdf/goo/gmem.h \
  $(srcdir)/Object.h \
  ../../../../src/libs/xpdf/goo/gtypes.h \
  ../../../../src/libs/xpdf/goo/GString.h \
  $(srcdir)/Array.h \
  $(srcdir)/Dict.h \
  $(srcdir)/Stream.h \
  $(srcdir)/Lexer.h \
  $(srcdir)/Parser.h \
  $(srcdir)/Error.h \
  $(srcdir)/config.h \
  $(srcdir)/ErrorCodes.h \
  $(srcdir)/XRef.h
