# DO NOT DELETE

$(objdir)/adler32.obj: adler32.c zlib.h zconf.h
$(objdir)/compress.obj: compress.c zlib.h zconf.h
$(objdir)/crc32.obj: crc32.c zlib.h zconf.h
$(objdir)/deflate.obj: deflate.c deflate.h zutil.h zlib.h zconf.h \
	zlib.h
$(objdir)/example.obj: example.c zconf.h \
	zutil.h
$(objdir)/gzio.obj: gzio.c zlib.h zconf.h \
	zutil.h
$(objdir)/infblock.obj: infblock.c zlib.h zconf.h \
	infblock.h inftrees.h infcodes.h infutil.h
$(objdir)/infcodes.obj: infcodes.c zutil.h zlib.h zconf.h \
	inftrees.h infblock.h infcodes.h infutil.h inffast.h
$(objdir)/inffast.obj: inffast.c zutil.h zlib.h zconf.h \
	inftrees.h infblock.h infcodes.h infutil.h inffast.h
$(objdir)/inflate.obj: inflate.c zutil.h zlib.h zconf.h \
	infblock.h
$(objdir)/inftrees.obj: inftrees.c zutil.h zlib.h zconf.h \
	inftrees.h inffixed.h
$(objdir)/infutil.obj: infutil.c zutil.h zlib.h zconf.h \
	infblock.h inftrees.h infcodes.h infutil.h \
	zutil.h
$(objdir)/maketree.obj: maketree.c zlib.h zconf.h \
	inftrees.h
$(objdir)/minigzip.obj: minigzip.c $(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h zlib.h zconf.h \
	deflate.h
$(objdir)/trees.obj: trees.c zutil.h zlib.h zconf.h \
	trees.h
$(objdir)/uncompr.obj: uncompr.c zlib.h zconf.h
$(objdir)/zutil.obj: zutil.c zutil.h zlib.h zconf.h \
	
