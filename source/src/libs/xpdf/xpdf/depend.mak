$(objdir)/Lexer.obj: \
	../aconf.h \
	../aconf2.h \
	Lexer.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h

$(objdir)/FTFont.obj: \
	../aconf.h \
	../aconf2.h

$(objdir)/XPDFApp.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	XPDFViewer.h \
	XPDFCore.h \
	$(xpdfdir)/Goo/gfile.h \
	XPDFApp.h

$(objdir)/Outline.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	Link.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	PDFDocEncoding.h \
	CharTypes.h \
	Outline.h

$(objdir)/Catalog.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Page.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Link.h \
	Catalog.h

$(objdir)/SFont.obj: \
	../aconf.h \
	../aconf2.h \
	SFont.h \
	$(xpdfdir)/Goo/gtypes.h \
	CharTypes.h

$(objdir)/CharCodeToUnicode.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	CharTypes.h \
	PSTokenizer.h \
	CharCodeToUnicode.h

$(objdir)/Stream.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gtypes.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Error.h \
	Object.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Decrypt.h \
	JBIG2Stream.h \
	Stream-CCITT.h

$(objdir)/OutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	GfxState.h \
	Function.h \
	OutputDev.h \
	CharTypes.h

$(objdir)/JBIG2Stream.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	JBIG2Stream.h \
	Object.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Stream-CCITT.h

$(objdir)/NameToCharCode.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	NameToCharCode.h \
	CharTypes.h

$(objdir)/FontEncodingTables.obj: \
	../aconf.h \
	../aconf2.h \
	FontEncodingTables.h

$(objdir)/pdftops.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Catalog.h \
	Page.h \
	PDFDoc.h \
	Link.h \
	PSOutputDev.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	OutputDev.h \
	Error.h

$(objdir)/XPDFViewer.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	CharTypes.h \
	PDFDoc.h \
	XRef.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	Link.h \
	Catalog.h \
	Page.h \
	ErrorCodes.h \
	Outline.h \
	UnicodeMap.h \
	XPDFTree.h \
	XPDFApp.h \
	XPDFViewer.h \
	XPDFCore.h \
	XPixmapOutputDev.h \
	XOutputDev.h \
	OutputDev.h \
	PSOutputDev.h \
	xpdfIcon.xpm \
	leftArrow.xbm \
	leftArrowDis.xbm \
	dblLeftArrow.xbm \
	dblLeftArrowDis.xbm \
	rightArrow.xbm \
	rightArrowDis.xbm \
	dblRightArrow.xbm \
	dblRightArrowDis.xbm \
	backArrow.xbm \
	backArrowDis.xbm \
	forwardArrow.xbm \
	forwardArrowDis.xbm \
	find.xbm \
	findDis.xbm \
	print.xbm \
	printDis.xbm \
	about.xbm \
	about-text.h

$(objdir)/XPDFCore.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	CharTypes.h \
	PDFDoc.h \
	XRef.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	Link.h \
	Catalog.h \
	Page.h \
	ErrorCodes.h \
	GfxState.h \
	Function.h \
	PSOutputDev.h \
	OutputDev.h \
	TextOutputDev.h \
	GfxFont.h \
	XPixmapOutputDev.h \
	XOutputDev.h \
	XPDFCore.h \
	$(xpdfdir)/Goo/gfile.h

$(objdir)/BuiltinFontTables.obj: \
	../aconf.h \
	../aconf2.h \
	FontEncodingTables.h \
	BuiltinFontTables.h \
	BuiltinFont.h \
	$(xpdfdir)/Goo/gtypes.h

$(objdir)/PDFDoc.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/GString.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h \
	CharTypes.h \
	Page.h \
	Object.h \
	$(xpdfdir)/Goo/gmem.h \
	Array.h \
	Dict.h \
	Stream.h \
	Catalog.h \
	XRef.h \
	Link.h \
	OutputDev.h \
	Error.h \
	ErrorCodes.h \
	Lexer.h \
	Parser.h \
	Outline.h \
	PDFDoc.h

$(objdir)/XRef.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Lexer.h \
	Parser.h \
	Decrypt.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	ErrorCodes.h \
	XRef.h

$(objdir)/PSTokenizer.obj: \
	../aconf.h \
	../aconf2.h \
	PSTokenizer.h \
	$(xpdfdir)/Goo/gtypes.h

$(objdir)/pdftotext.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Catalog.h \
	Page.h \
	PDFDoc.h \
	Link.h \
	TextOutputDev.h \
	GfxFont.h \
	OutputDev.h \
	UnicodeMap.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h

$(objdir)/PDFDocEncoding.obj: \
	PDFDocEncoding.h \
	CharTypes.h

$(objdir)/XPDFTree.obj: \
	$(xpdfdir)/Goo/gmem.h \
	XPDFTreeP.h \
	XPDFTree.h

$(objdir)/PSOutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	$(xpdfdir)/Goo/gmem.h \
	Array.h \
	Dict.h \
	Stream.h \
	Error.h \
	Function.h \
	Gfx.h \
	GfxState.h \
	GfxFont.h \
	CharCodeToUnicode.h \
	UnicodeMap.h \
	FontFile.h \
	Catalog.h \
	Page.h \
	Annot.h \
	PSOutputDev.h \
	OutputDev.h

$(objdir)/GfxFont.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	GlobalParams.h \
	CharTypes.h \
	CMap.h \
	CharCodeToUnicode.h \
	FontEncodingTables.h \
	BuiltinFontTables.h \
	BuiltinFont.h \
	FontFile.h \
	GfxFont.h

$(objdir)/UnicodeMap.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	CharTypes.h \
	UnicodeMap.h

$(objdir)/pdfinfo.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Catalog.h \
	Page.h \
	PDFDoc.h \
	Link.h \
	UnicodeMap.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h

$(objdir)/Link.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	Array.h \
	Dict.h \
	Stream.h \
	Link.h

$(objdir)/TTFont.obj: \
	../aconf.h \
	../aconf2.h

$(objdir)/Error.obj: \
	../aconf.h \
	../aconf2.h \
	GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h \
	CharTypes.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h

$(objdir)/XPixmapOutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	GfxState.h \
	Function.h \
	XPixmapOutputDev.h \
	XOutputDev.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	CharTypes.h \
	GlobalParams.h \
	OutputDev.h

$(objdir)/Array.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h

$(objdir)/FontFile.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h \
	CharTypes.h \
	CharCodeToUnicode.h \
	FontEncodingTables.h \
	FontFile.h \
	$(xpdfdir)/Goo/GString.h \
	CompactFontTables.h

$(objdir)/pdffonts.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	GfxFont.h \
	Annot.h \
	PDFDoc.h \
	XRef.h \
	Link.h \
	Catalog.h \
	Page.h

$(objdir)/TextOutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Error.h \
	GlobalParams.h \
	CharTypes.h \
	UnicodeMap.h \
	GfxState.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	Function.h \
	TextOutputDev.h \
	GfxFont.h \
	OutputDev.h

$(objdir)/GlobalParams.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GHash.h \
	$(xpdfdir)/Goo/gfile.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	NameToCharCode.h \
	CharTypes.h \
	CharCodeToUnicode.h \
	UnicodeMap.h \
	CMap.h \
	BuiltinFontTables.h \
	BuiltinFont.h \
	FontEncodingTables.h \
	GlobalParams.h \
	NameToUnicodeTable.h \
	UnicodeMapTables.h \
	DisplayFontTable.h \
	UTF8.h

$(objdir)/xpdf.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	XPDFApp.h \
	config.h \
	$(gnuw32dir)/win32lib.h

$(objdir)/BuiltinFont.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	FontEncodingTables.h \
	BuiltinFont.h \
	$(xpdfdir)/Goo/gtypes.h

$(objdir)/ImageOutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Error.h \
	GfxState.h \
	$(xpdfdir)/Goo/gtypes.h \
	Object.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Function.h \
	ImageOutputDev.h \
	OutputDev.h \
	CharTypes.h

$(objdir)/Function.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Function.h

$(objdir)/PBMOutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	Array.h \
	Dict.h \
	Stream.h \
	GfxState.h \
	Function.h \
	GfxFont.h \
	CharTypes.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	PBMOutputDev.h \
	XOutputDev.h \
	GlobalParams.h \
	OutputDev.h

$(objdir)/T1Font.obj: \
	../aconf.h \
	../aconf2.h

$(objdir)/Gfx.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h \
	CharTypes.h \
	Object.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Lexer.h \
	Parser.h \
	GfxFont.h \
	GfxState.h \
	Function.h \
	OutputDev.h \
	Page.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Gfx.h

$(objdir)/XOutputDev.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/GList.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	Link.h \
	GfxState.h \
	Function.h \
	GfxFont.h \
	CharTypes.h \
	UnicodeMap.h \
	CharCodeToUnicode.h \
	FontFile.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	TextOutputDev.h \
	OutputDev.h \
	XOutputDev.h \
	GlobalParams.h

$(objdir)/pdftopbm.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Catalog.h \
	Page.h \
	PDFDoc.h \
	Link.h \
	PBMOutputDev.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	XOutputDev.h \
	OutputDev.h \
	Error.h

$(objdir)/Parser.obj: \
	../aconf.h \
	../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Parser.h \
	Lexer.h \
	XRef.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Decrypt.h

$(objdir)/Annot.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Gfx.h \
	Annot.h

$(objdir)/Decrypt.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Decrypt.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h

$(objdir)/GfxState.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Page.h \
	GfxState.h \
	Function.h

$(objdir)/pdfimages.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/parseargs.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	$(xpdfdir)/Goo/gmem.h \
	GlobalParams.h \
	CharTypes.h \
	Object.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Catalog.h \
	Page.h \
	PDFDoc.h \
	Link.h \
	ImageOutputDev.h \
	OutputDev.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h

$(objdir)/Page.obj: \
	../aconf.h \
	../aconf2.h \
	GlobalParams.h \
	$(xpdfdir)/Goo/gtypes.h \
	CharTypes.h \
	Object.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h \
	Link.h \
	OutputDev.h \
	Gfx.h \
	Annot.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	Page.h

$(objdir)/Dict.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	XRef.h

$(objdir)/Object.obj: \
	../aconf.h \
	../aconf2.h \
	Object.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/GString.h \
	Array.h \
	Dict.h \
	Stream.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	XRef.h

$(objdir)/CMap.obj: \
	../aconf.h \
	../aconf2.h \
	$(xpdfdir)/Goo/gmem.h \
	$(xpdfdir)/Goo/gfile.h \
	$(xpdfdir)/Goo/gtypes.h \
	$(xpdfdir)/Goo/GString.h \
	Error.h \
	config.h \
	$(gnuw32dir)/win32lib.h \
	GlobalParams.h \
	CharTypes.h \
	PSTokenizer.h \
	CMap.h

