# DO NOT DELETE

$(objdir)/png.obj: png.c png.h $(zlibdir)/zlib.h $(zlibdir)/zconf.h \
	pngconf.h \
	png.h
$(objdir)/pngerror.obj: pngerror.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pnggccrd.obj: pnggccrd.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngget.obj: pngget.c $(zlibdir)/zlib.h $(zlibdir)/zconf.h \
	pngconf.h \
	png.h
$(objdir)/pngmem.obj: pngmem.c $(zlibdir)/zlib.h $(zlibdir)/zconf.h \
	pngconf.h \
	png.h
$(objdir)/pngpread.obj: pngpread.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngread.obj: pngread.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngrio.obj: pngrio.c $(zlibdir)/zlib.h $(zlibdir)/zconf.h \
	pngconf.h \
	png.h
$(objdir)/pngrtran.obj: pngrtran.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngrutil.obj: pngrutil.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngset.obj: pngset.c $(zlibdir)/zlib.h $(zlibdir)/zconf.h \
	pngconf.h \
	png.h
$(objdir)/pngtest.obj: pngtest.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngtrans.obj: pngtrans.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngvcrd.obj: pngvcrd.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngwio.obj: pngwio.c $(zlibdir)/zlib.h $(zlibdir)/zconf.h \
	pngconf.h \
	png.h
$(objdir)/pngwrite.obj: pngwrite.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngwtran.obj: pngwtran.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	png.h
$(objdir)/pngwutil.obj: pngwutil.c $(zlibdir)/zlib.h \
	$(zlibdir)/zconf.h pngconf.h \
	
