# DO NOT DELETE

$(objdir)/gmem.obj: gmem.c ../aconf.h ../aconf2.h \
	gmem.h \
	parseargs.h
$(objdir)/parseargs.obj: parseargs.c gtypes.h \
	vms_dirent.h
$(objdir)/vms_directory.obj: vms_directory.c $(kpathseadir)/types.h \
	vms_sys_dirent.h \
	vms_unix_time.h \
	../aconf.h
$(objdir)/gfile.obj: gfile.cc ../aconf2.h \
	gfile.h \
	$(gnuw32dir)/win32lib.h \
	$(gnuw32dir)/oldnames.h gtypes.h
$(objdir)/GHash.obj: GHash.cc ../aconf.h ../aconf2.h gmem.h \
	GString.h \
	GHash.h gtypes.h
$(objdir)/GList.obj: GList.cc ../aconf.h ../aconf2.h \
	gmem.h \
	GList.h gtypes.h
$(objdir)/gmempp.obj: gmempp.cc ../aconf.h ../aconf2.h gmem.h \
	../aconf.h
$(objdir)/GString.obj: GString.cc ../aconf2.h \
	gtypes.h GString.h
