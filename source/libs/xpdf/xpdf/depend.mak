# DO NOT DELETE

$(objdir)/Annot.obj: Annot.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h Gfx.h \
	Annot.h
$(objdir)/Array.obj: Array.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h Array.h \
	../aconf.h
$(objdir)/BuiltinFont.obj: BuiltinFont.cc ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	FontEncodingTables.h BuiltinFont.h $(xpdfdir)/Goo/gtypes.h \
	../aconf.h
$(objdir)/BuiltinFontTables.obj: BuiltinFontTables.cc ../aconf2.h \
	FontEncodingTables.h BuiltinFontTables.h BuiltinFont.h \
	$(xpdfdir)/Goo/gtypes.h
$(objdir)/Catalog.obj: Catalog.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h XRef.h \
	Array.h Dict.h Page.h Error.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Link.h Catalog.h
$(objdir)/CharCodeToUnicode.obj: CharCodeToUnicode.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h Error.h config.h GlobalParams.h \
	CharTypes.h PSTokenizer.h CharCodeToUnicode.h
$(objdir)/CMap.obj: CMap.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h Error.h config.h GlobalParams.h \
	CharTypes.h PSTokenizer.h CMap.h
$(objdir)/Decrypt.obj: Decrypt.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Decrypt.h $(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h \
	../aconf.h
$(objdir)/Dict.obj: Dict.cc ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h $(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h \
	XRef.h Dict.h
$(objdir)/Error.obj: Error.cc ../aconf.h ../aconf2.h \
	GlobalParams.h $(xpdfdir)/Goo/gtypes.h CharTypes.h Error.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h
$(objdir)/FontEncodingTables.obj: FontEncodingTables.cc ../aconf.h \
	../aconf2.h \
	FontEncodingTables.h
$(objdir)/FontFile.obj: FontFile.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Error.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h CharTypes.h CharCodeToUnicode.h \
	FontEncodingTables.h FontFile.h $(xpdfdir)/Goo/GString.h \
	CompactFontTables.h
$(objdir)/FTFont.obj: FTFont.cc ../aconf.h ../aconf2.h
$(objdir)/Function.obj: Function.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h $(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h \
	Dict.h Stream.h Error.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Function.h
$(objdir)/Gfx.obj: Gfx.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h CharTypes.h Object.h \
	$(xpdfdir)/Goo/GString.h Array.h Dict.h Stream.h Lexer.h Parser.h \
	GfxFont.h GfxState.h Function.h OutputDev.h Page.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Gfx.h
$(objdir)/GfxFont.obj: GfxFont.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h Dict.h \
	GlobalParams.h CharTypes.h CMap.h CharCodeToUnicode.h FontEncodingTables.h \
	BuiltinFontTables.h BuiltinFont.h FontFile.h GfxFont.h
$(objdir)/GfxState.obj: GfxState.cc ../aconf.h ../aconf2.h \
	Error.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h Array.h Page.h GfxState.h Function.h \
	../aconf.h
$(objdir)/GlobalParams.obj: GlobalParams.cc ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GHash.h \
	$(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Error.h config.h NameToCharCode.h \
	CharTypes.h CharCodeToUnicode.h UnicodeMap.h CMap.h BuiltinFontTables.h \
	BuiltinFont.h FontEncodingTables.h GlobalParams.h NameToUnicodeTable.h \
	UnicodeMapTables.h DisplayFontTable.h UTF8.h
$(objdir)/ImageOutputDev.obj: ImageOutputDev.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Error.h GfxState.h \
	$(xpdfdir)/Goo/gtypes.h Object.h \
	$(xpdfdir)/Goo/GString.h Function.h Stream.h ImageOutputDev.h \
	OutputDev.h CharTypes.h
$(objdir)/JBIG2Stream.obj: JBIG2Stream.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/GList.h $(xpdfdir)/Goo/gtypes.h Error.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h JBIG2Stream.h Object.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/GString.h Stream.h \
	../aconf.h
$(objdir)/Lexer.obj: Lexer.cc ../aconf2.h \
	Lexer.h Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h Stream.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h
$(objdir)/Link.obj: Link.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Object.h \
	$(xpdfdir)/Goo/gtypes.h Array.h Dict.h Link.h
$(objdir)/NameToCharCode.obj: NameToCharCode.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	NameToCharCode.h CharTypes.h
$(objdir)/Object.obj: Object.cc ../aconf.h ../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h Array.h Dict.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Stream.h XRef.h
$(objdir)/Outline.obj: Outline.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h $(xpdfdir)/Goo/gtypes.h Link.h \
	Object.h PDFDocEncoding.h CharTypes.h Outline.h
$(objdir)/OutputDev.obj: OutputDev.cc ../aconf.h ../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h Stream.h GfxState.h Function.h \
	OutputDev.h CharTypes.h
$(objdir)/Page.obj: Page.cc ../aconf.h ../aconf2.h \
	GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h CharTypes.h Object.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/GString.h Array.h \
	Dict.h XRef.h Link.h OutputDev.h Gfx.h Annot.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Page.h
$(objdir)/Parser.obj: Parser.cc ../aconf.h ../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h Array.h Dict.h Parser.h Lexer.h Stream.h \
	XRef.h Error.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Decrypt.h
$(objdir)/PBMOutputDev.obj: PBMOutputDev.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/GString.h Object.h \
	$(xpdfdir)/Goo/gtypes.h Stream.h GfxState.h Function.h GfxFont.h \
	CharTypes.h Error.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h PBMOutputDev.h XOutputDev.h \
	GlobalParams.h OutputDev.h
$(objdir)/PDFDoc.obj: PDFDoc.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/GString.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h CharTypes.h Page.h Object.h \
	$(xpdfdir)/Goo/gmem.h Catalog.h Stream.h XRef.h Link.h OutputDev.h \
	Error.h ErrorCodes.h Lexer.h Parser.h Outline.h PDFDoc.h
$(objdir)/PDFDocEncoding.obj: PDFDocEncoding.cc PDFDocEncoding.h CharTypes.h \
	../aconf.h
$(objdir)/pdffonts.obj: pdffonts.cc ../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Object.h Dict.h GfxFont.h Annot.h \
	PDFDoc.h XRef.h Link.h Catalog.h Page.h
$(objdir)/pdfimages.obj: pdfimages.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Object.h Stream.h Array.h Dict.h XRef.h \
	Catalog.h Page.h PDFDoc.h Link.h ImageOutputDev.h OutputDev.h Error.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h
$(objdir)/pdfinfo.obj: pdfinfo.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Object.h Stream.h Array.h Dict.h XRef.h \
	Catalog.h Page.h PDFDoc.h Link.h UnicodeMap.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h
$(objdir)/pdftopbm.obj: pdftopbm.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Object.h Stream.h Array.h Dict.h XRef.h \
	Catalog.h Page.h PDFDoc.h Link.h PBMOutputDev.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h XOutputDev.h OutputDev.h Error.h \
	../aconf.h
$(objdir)/pdftops.obj: pdftops.cc ../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Object.h Stream.h Array.h Dict.h XRef.h \
	Catalog.h Page.h PDFDoc.h Link.h PSOutputDev.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h OutputDev.h Error.h
$(objdir)/pdftotext.obj: pdftotext.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Object.h Stream.h Array.h Dict.h XRef.h \
	Catalog.h Page.h PDFDoc.h Link.h TextOutputDev.h GfxFont.h OutputDev.h \
	UnicodeMap.h Error.h config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h
$(objdir)/PSOutputDev.obj: PSOutputDev.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h $(xpdfdir)/Goo/gtypes.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h GlobalParams.h CharTypes.h Object.h \
	$(xpdfdir)/Goo/gmem.h Error.h Function.h Gfx.h GfxState.h \
	GfxFont.h CharCodeToUnicode.h UnicodeMap.h FontFile.h Catalog.h Page.h \
	Stream.h Annot.h PSOutputDev.h OutputDev.h
$(objdir)/PSTokenizer.obj: PSTokenizer.cc ../aconf.h ../aconf2.h \
	PSTokenizer.h $(xpdfdir)/Goo/gtypes.h
$(objdir)/SFont.obj: SFont.cc ../aconf.h ../aconf2.h SFont.h \
	$(xpdfdir)/Goo/gtypes.h CharTypes.h
$(objdir)/Stream.obj: Stream.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gtypes.h \
	config.h Error.h Object.h $(xpdfdir)/Goo/GString.h Decrypt.h \
	Stream.h JBIG2Stream.h Stream-CCITT.h
$(objdir)/T1Font.obj: T1Font.cc ../aconf.h ../aconf2.h
$(objdir)/TextOutputDev.obj: TextOutputDev.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h $(xpdfdir)/Goo/gtypes.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h Error.h GlobalParams.h CharTypes.h \
	UnicodeMap.h GfxState.h Object.h Function.h TextOutputDev.h GfxFont.h \
	OutputDev.h
$(objdir)/TTFont.obj: TTFont.cc ../aconf.h ../aconf2.h
$(objdir)/UnicodeMap.obj: UnicodeMap.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/GList.h Error.h \
	config.h GlobalParams.h CharTypes.h UnicodeMap.h
$(objdir)/XOutputDev.obj: XOutputDev.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h $(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/GList.h Object.h \
	Stream.h Link.h GfxState.h Function.h GfxFont.h CharTypes.h UnicodeMap.h \
	CharCodeToUnicode.h FontFile.h Error.h config.h TextOutputDev.h \
	OutputDev.h XOutputDev.h GlobalParams.h
$(objdir)/xpdf.obj: xpdf.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/parseargs.h $(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gmem.h \
	GlobalParams.h CharTypes.h Object.h XPDFApp.h config.h
$(objdir)/XPDFApp.obj: XPDFApp.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h $(xpdfdir)/Goo/gtypes.h Error.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h XPDFViewer.h XPDFCore.h \
	$(xpdfdir)/Goo/gfile.h \
	XPDFApp.h
$(objdir)/XPDFCore.obj: XPDFCore.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h $(xpdfdir)/Goo/gtypes.h Error.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h GlobalParams.h CharTypes.h PDFDoc.h \
	XRef.h Object.h Link.h Catalog.h Page.h ErrorCodes.h GfxState.h Function.h \
	PSOutputDev.h \
	OutputDev.h TextOutputDev.h GfxFont.h XPixmapOutputDev.h XOutputDev.h \
	XPDFCore.h $(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gmem.h \
	XPDFTreeP.h
$(objdir)/XPDFTree.obj: XPDFTree.cc XPDFTree.h
$(objdir)/XPDFViewer.obj: XPDFViewer.cc ../aconf.h ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h $(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h $(xpdfdir)/Goo/GList.h Error.h \
	config.h GlobalParams.h CharTypes.h PDFDoc.h XRef.h Object.h Link.h \
	Catalog.h Page.h ErrorCodes.h Outline.h UnicodeMap.h XPDFTree.h XPDFApp.h \
	XPDFViewer.h XPDFCore.h XPixmapOutputDev.h XOutputDev.h OutputDev.h \
	PSOutputDev.h xpdfIcon.xpm leftArrow.xbm leftArrowDis.xbm dblLeftArrow.xbm \
	dblLeftArrowDis.xbm rightArrow.xbm rightArrowDis.xbm dblRightArrow.xbm \
	dblRightArrowDis.xbm backArrow.xbm backArrowDis.xbm forwardArrow.xbm \
	forwardArrowDis.xbm find.xbm findDis.xbm print.xbm printDis.xbm about.xbm \
	about-text.h
$(objdir)/XPixmapOutputDev.obj: XPixmapOutputDev.cc ../aconf.h ../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h GfxState.h Function.h XPixmapOutputDev.h \
	XOutputDev.h \
	config.h $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h CharTypes.h GlobalParams.h OutputDev.h \
	../aconf.h
$(objdir)/XRef.obj: XRef.cc ../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h $(xpdfdir)/Goo/gtypes.h $(xpdfdir)/Goo/GString.h \
	Stream.h Lexer.h Parser.h Dict.h Decrypt.h Error.h config.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h ErrorCodes.h XRef.h
