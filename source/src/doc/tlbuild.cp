\entry{introduction}{1}{introduction}
\entry{build system, design of}{2}{build system, design of}
\entry{Autoconf}{2}{Autoconf}
\entry{Automake}{2}{Automake}
\entry{Libtool}{2}{Libtool}
\entry{tests, running}{2}{tests, running}
\entry{kpse-pkgs.m4}{2}{\code {kpse-pkgs.m4}}
\entry{prerequisites for building}{3}{prerequisites for building}
\entry{requirements for building}{3}{requirements for building}
\entry{compilers, C and C++11}{3}{compilers, C and C++11}
\entry{GNU make, required}{3}{GNU \code {make}, required}
\entry{gmake, required}{3}{\code {gmake}, required}
\entry{FreeType}{3}{FreeType}
\entry{C++11, required}{3}{C++11, required}
\entry{perl, required by web2c, etc.}{3}{\code {perl}, required by \code {web2c}, etc.}
\entry{X11 development, required by X clients}{3}{X11 development, required by X clients}
\entry{fontconfig library, required by xetex}{3}{\code {fontconfig} library, required by \code {xetex}}
\entry{ApplicationServices Mac framework, required by xetex}{3}{\code {ApplicationServices} Mac framework, required by \code {xetex}}
\entry{Cocoa Mac framework, required by xetex}{3}{\code {Cocoa} Mac framework, required by \code {xetex}}
\entry{clisp, required by xindy}{3}{\code {clisp}, required by \code {xindy}}
\entry{libsigsegv, required by xindy}{3}{\code {libsigsegv}, required by \code {xindy}}
\entry{building}{4}{building}
\entry{overall build process}{4}{overall build process}
\entry{Build script}{4}{\code {Build \r {script}}}
\entry{source directory building, not supported}{4}{source directory building, not supported}
\entry{build directory, required}{4}{build directory, required}
\entry{build iteration}{4}{build iteration}
\entry{iteration through sources, by configure and make}{4}{iteration through sources, by \code {configure} and \code {make}}
\entry{build problems}{4}{build problems}
\entry{problems with build}{4}{problems with build}
\entry{failure to build}{4}{failure to build}
\entry{--no-clean Build option}{4}{\code {--no-clean Build \r {option}}}
\entry{building in parallel}{4}{building in parallel}
\entry{parallel build}{4}{parallel build}
\entry{cache for configure}{4}{cache for \code {configure}}
\entry{dependencies, with several output files}{4}{dependencies, with several output files}
\entry{-j make option}{4}{\code {-j make \r {option}}}
\entry{cache file, for configure}{4}{cache file, for \code {configure}}
\entry{-C configure option}{4}{\code {-C configure \r {option}}}
\entry{building a distribution}{4}{building a distribution}
\entry{distribution tarball, making}{4}{distribution tarball, making}
\entry{dist and distcheck targets for make}{4}{\code {dist} and \code {distcheck} targets for \code {make}}
\entry{build one package}{5}{build one package}
\entry{one package, building}{5}{one package, building}
\entry{--disable-all-packages}{5}{\code {--disable-all-packages}}
\entry{build on demand}{5}{build on demand}
\entry{size of source tree}{6}{size of source tree}
\entry{--enable-missing to ignore dependencies}{6}{\code {--enable-missing \r {to ignore dependencies}}}
\entry{CC=c-compiler}{6}{\code {CC=\var {c-compiler}}}
\entry{CXX=c++-compiler}{6}{\code {CXX=\var {c++-compiler}}}
\entry{OBJCXX=objc-compiler}{6}{\code {OBJCXX=\var {objc-compiler}}}
\entry{gcc, default compilers}{6}{\code {gcc\r {, default compilers}}}
\entry{build one engine}{6}{build one engine}
\entry{one engine, building}{6}{one engine, building}
\entry{engine, building one}{6}{engine, building one}
\entry{cross compilation}{6}{cross compilation}
\entry{native cross compilation}{6}{native cross compilation}
\entry{cross compilation configuring}{7}{cross compilation configuring}
\entry{configuring, for cross compilation}{7}{configuring, for cross compilation}
\entry{--host=host}{7}{\code {--host=\var {host}}}
\entry{--build=host}{7}{\code {--build=\var {host}}}
\entry{mingw32}{7}{\code {mingw32}}
\entry{BUILDCC, BUILDCFLAGS, ...}{7}{\code {BUILDCC\r {,} BUILDCFLAGS\r {, \dots {}}}}
\entry{cross compilation problems}{7}{cross compilation problems}
\entry{squeeze}{8}{\code {squeeze}}
\entry{web2c program}{8}{\code {web2c \r {program}}}
\entry{freetype cross compiling}{8}{\code {freetype} cross compiling}
\entry{CC_BUILD}{8}{\code {CC_BUILD}}
\entry{ICU cross compiling}{8}{ICU cross compiling}
\entry{tangle}{8}{\code {tangle}}
\entry{ctangle}{8}{\code {ctangle}}
\entry{otangle}{8}{\code {otangle}}
\entry{tie}{8}{\code {tie}}
\entry{xindy cross compiling impossible}{8}{\code {xindy} cross compiling impossible}
\entry{installing}{9}{installing}
\entry{support files, separate from build}{9}{support files, separate from build}
\entry{texlive.tlpdb,  database}{9}{\code {texlive.tlpdb\r {, \TL {} database}}}
\entry{install-tl,  installer}{9}{\code {install-tl\r {, \TL {} installer}}}
\entry{plain.tex, not in source tree}{9}{\code {plain.tex\r {, not in source tree}}}
\entry{installation directories}{9}{installation directories}
\entry{directories, for installation}{9}{directories, for installation}
\entry{paths, for installation}{9}{paths, for installation}
\entry{linked scripts}{9}{linked scripts}
\entry{scripts, linked and not maintained}{9}{scripts, linked and not maintained}
\entry{symlinks, used for scripts}{9}{symlinks, used for scripts}
\entry{wrapper binary for scripts on Windows}{9}{wrapper binary for scripts on Windows}
\entry{Windows, invoking scripts on}{9}{Windows, invoking scripts on}
\entry{asymptote}{10}{\code {asymptote}}
\entry{biber}{10}{\code {biber}}
\entry{xindy}{10}{\code {xindy}}
\entry{xz}{10}{\code {xz}}
\entry{wget}{10}{\code {wget}}
\entry{distro, building for}{10}{distro, building for}
\entry{operating system distribution, building for}{10}{operating system distribution, building for}
\entry{system distribution, building for}{10}{system distribution, building for}
\entry{GNU/Linux distro}{10}{GNU/Linux distro}
\entry{BSD distro}{10}{BSD distro}
\entry{shared libraries, using vs. avoiding}{10}{shared libraries, using vs.\: avoiding}
\entry{Preining, Norbert}{11}{Preining, Norbert}
\entry{adapting  for distros}{11}{adapting \TL {} for distros}
\entry{layout of sources}{12}{layout of sources}
\entry{source tree}{12}{source tree}
\entry{tools, for building}{12}{tools, for building}
\entry{GNU tools, needed for building}{12}{GNU tools, needed for building}
\entry{infrastructure, tools needed for}{12}{infrastructure, tools needed for}
\entry{reautoconf}{12}{\code {reautoconf}}
\entry{--enable-maintainer-mode}{12}{\code {--enable-maintainer-mode}}
\entry{Subversion repository}{12}{Subversion repository}
\entry{timestamps, in repository}{12}{timestamps, in repository}
\entry{use-commit-times, Subversion}{12}{\code {use-commit-times\r {, Subversion}}}
\entry{touching files to avoid rerunning}{12}{touching files to avoid rerunning}
\entry{make -t}{12}{\code {make -t}}
\entry{directories, top-level}{12}{directories, top-level}
\entry{top-level directories}{12}{top-level directories}
\entry{am/ top-level directory}{12}{\file {am/} top-level directory}
\entry{m4/ top-level directory}{12}{\file {m4/} top-level directory}
\entry{build-aux/ top-level directory}{13}{\file {build-aux/} top-level directory}
\entry{config.guess, config.sub, ...}{13}{\code {config.guess\r {,} config.sub, \dots {}}}
\entry{Gnulib, used for common files}{13}{Gnulib, used for common files}
\entry{Work/ top-level directory}{13}{\file {Work/} top-level directory}
\entry{inst/ top-level directory}{13}{\file {inst/} top-level directory}
\entry{autoconf macros}{13}{autoconf macros}
\entry{general setup macros}{13}{general setup macros}
\entry{setup macros, general}{13}{setup macros, general}
\entry{macros, general setup}{13}{macros, general setup}
\entry{KPSE_BASIC}{13}{\code {KPSE_BASIC}}
\entry{KPSE_COMMON}{13}{\code {KPSE_COMMON}}
\entry{macros, for programs}{14}{macros, for programs}
\entry{KPSE_CHECK_LATEX}{14}{\code {KPSE_CHECK_LATEX}}
\entry{KPSE_CHECK_PDFLATEX}{14}{\code {KPSE_CHECK_PDFLATEX}}
\entry{KPSE_CHECK_PERL}{14}{\code {KPSE_CHECK_PERL}}
\entry{KPSE_PROG_LEX}{14}{\code {KPSE_PROG_LEX}}
\entry{macros, for compilers}{14}{macros, for compilers}
\entry{KPSE_COMPILER_WARNINGS}{14}{\code {KPSE_COMPILER_WARNINGS}}
\entry{WARNING_C[XX]FLAGS}{14}{\code {WARNING_C[XX]FLAGS}}
\entry{kpse_cv_warning_cflags}{14}{\code {kpse_cv_warning_cflags}}
\entry{KPSE_COMPILER_VISIBILITY}{14}{\code {KPSE_COMPILER_VISIBILITY}}
\entry{kpse_cv_visibility_c[xx]flags}{14}{\code {kpse_cv_visibility_c[xx]flags}}
\entry{KPSE_CXX_HACK}{14}{\code {KPSE_CXX_HACK}}
\entry{static linking for C++}{14}{static linking for C++}
\entry{linking C++ libraries statically}{14}{linking C++ libraries statically}
\entry{--enable-cxx-runtime-hack}{14}{\code {--enable-cxx-runtime-hack}}
\entry{libstc++, statically linking}{14}{\code {libstc++\r {, statically linking}}}
\entry{kpse_cv_cxx_hack}{14}{\code {kpse_cv_cxx_hack}}
\entry{macros, for libraries}{14}{macros, for libraries}
\entry{KPSE_LARGEFILE}{14}{\code {KPSE_LARGEFILE}}
\entry{macros, for library and header flags}{15}{macros, for library and header flags}
\entry{flags, macros for library and header}{15}{flags, macros for library and header}
\entry{KPSE_LIB_FLAGS}{15}{\code {KPSE_\var {LIB}_FLAGS}}
\entry{KPSE_LIBPNG_FLAGS}{15}{\code {KPSE_LIBPNG_FLAGS}}
\entry{KPSE_ADD_FLAGS}{15}{\code {KPSE_ADD_FLAGS}}
\entry{KPSE_RESTORE_FLAGS}{15}{\code {KPSE_RESTORE_FLAGS}}
\entry{macros, for Windows}{15}{macros, for Windows}
\entry{Windows, macros for}{15}{Windows, macros for}
\entry{KPSE_CHECK_WIN32}{16}{\code {KPSE_CHECK_WIN32}}
\entry{kpse_cv_have_win32}{16}{\code {kpse_cv_have_win32}}
\entry{KPSE_COND_WIN32}{16}{\code {KPSE_COND_WIN32}}
\entry{WIN32, Automake conditional}{16}{\code {WIN32\r {, Automake conditional}}}
\entry{KPSE_COND_MINGW32}{16}{\code {KPSE_COND_MINGW32}}
\entry{MINGW32, Automake conditional}{16}{\code {MINGW32\r {, Automake conditional}}}
\entry{KPSE_COND_WIN32_WRAP}{16}{\code {KPSE_COND_WIN32_WRAP}}
\entry{WIN32_WRAP, Automake conditional}{16}{\code {WIN32_WRAP\r {, Automake conditional}}}
\entry{runscript.exe}{16}{\code {runscript.exe}}
\entry{KPSE_WIN32_CALL}{16}{\code {KPSE_WIN32_CALL}}
\entry{callexe.c}{16}{\code {callexe.c}}
\entry{library modules}{16}{library modules}
\entry{modules, for libraries}{16}{modules, for libraries}
\entry{png library}{16}{\code {png \r {library}}}
\entry{libpng library}{16}{\code {libpng \r {library}}}
\entry{KPSE_TRY_LIB}{16}{\code {KPSE_TRY_LIB}}
\entry{KPSE_TRY_LIBXX}{17}{\code {KPSE_TRY_LIBXX}}
\entry{proxy build system}{17}{proxy build system}
\entry{kpse-libpng-flags.m4}{17}{\code {kpse-libpng-flags.m4}}
\entry{KPSE_LIBPNG_FLAGS}{17}{\code {KPSE_LIBPNG_FLAGS}}
\entry{zlib library}{17}{\code {zlib \r {library}}}
\entry{kpse-zlib-flags.m4}{17}{\code {kpse-zlib-flags.m4}}
\entry{freetype library}{17}{\code {freetype \r {library}}}
\entry{wrapper build system}{17}{wrapper build system}
\entry{freetype-config}{17}{\code {freetype-config}}
\entry{kpathsea library}{17}{\code {kpathsea \r {library}}}
\entry{--with-system-kpathsea}{17}{\code {--with-system-kpathsea}}
\entry{kpathsea.ac}{17}{\code {kpathsea.ac}}
\entry{mktex.ac}{17}{\code {mktex.ac}}
\entry{--enable-mktextfm-default}{17}{\code {--enable-mktextfm-default}}
\entry{mktextfm}{17}{\code {mktextfm}}
\entry{program modules}{18}{program modules}
\entry{modules, for programs}{18}{modules, for programs}
\entry{t1utils package}{18}{\code {t1utils \r {package}}}
\entry{xindy}{18}{\code {xindy}}
\entry{xdvik}{18}{\code {xdvik}}
\entry{squeeze/configure.ac}{18}{\code {squeeze/configure.ac}}
\entry{cross compilation, with host binary}{18}{cross compilation, with host binary}
\entry{--with-xdvi-x-toolkit}{18}{\code {--with-xdvi-x-toolkit}}
\entry{asymptote}{19}{\code {asymptote}}
\entry{xasy}{19}{\code {xasy}}
\entry{OpenGL, required for Asymptote}{19}{OpenGL, required for Asymptote}
\entry{extending }{19}{extending \TL {}}
\entry{adding to }{19}{adding to \TL {}}
\entry{adding a new program}{19}{adding a new program}
\entry{program module, adding}{19}{program module, adding}
\entry{kpse_texk_pkgs}{19}{\code {kpse_texk_pkgs}}
\entry{kpse_utils_pkgs}{19}{\code {kpse_utils_pkgs}}
\entry{withenable.ac, for new modules}{19}{\code {withenable.ac\r {, for new modules}}}
\entry{KPSE_ENABLE_PROG}{19}{\code {KPSE_ENABLE_PROG}}
\entry{adding a new generic library}{20}{adding a new generic library}
\entry{generic library module, adding}{20}{generic library module, adding}
\entry{library module, generic, adding}{20}{library module, generic, adding}
\entry{kpse_libs_pkgs}{20}{\code {kpse_libs_pkgs}}
\entry{KPSE_WITH_LIB}{20}{\code {KPSE_WITH_LIB}}
\entry{KPSE_TRY_LIB}{20}{\code {KPSE_TRY_LIB}}
\entry{KPSE_TRY_LIBXX}{20}{\code {KPSE_TRY_LIBXX}}
\entry{KPSE_LIB_FLAGS}{20}{\code {KPSE_\var {LIB}_FLAGS}}
\entry{--with-system-lib}{21}{\code {--with-system-\var {lib}}}
\entry{KPSE_LIB_SYSTEM_FLAGS}{21}{\code {KPSE_\var {LIB}_SYSTEM_FLAGS}}
\entry{KPSE_ALL_SYSTEM_FLAGS}{21}{\code {KPSE_ALL_SYSTEM_FLAGS}}
\entry{adding a new TeX{}-specific library}{21}{adding a new \TeX {}-specific library}
\entry{TeX{}-specific library module, adding}{21}{\TeX {}-specific library module, adding}
\entry{library module, TeX{}-specific, adding}{21}{library module, \TeX {}-specific, adding}
\entry{kpse_texlibs_pkgs}{21}{\code {kpse_texlibs_pkgs}}
\entry{KPSE_WITH_TEXLIB}{21}{\code {KPSE_WITH_TEXLIB}}
\entry{configure options}{22}{\code {configure} options}
\entry{environment variables, for configure}{22}{environment variables, for \code {configure}}
\entry{global configure options}{22}{global \code {configure} options}
\entry{configure options, global}{22}{\code {configure} options, global}
\entry{--disable-native-texlive-build}{22}{\code {--disable-native-texlive-build}}
\entry{--enable-texlive-build}{22}{\code {--enable-texlive-build}}
\entry{--prefix configure option}{22}{\code {--prefix configure \r {option}}}
\entry{--bindir configure option}{22}{\code {--bindir configure \r {option}}}
\entry{DESTDIR}{22}{\code {DESTDIR}}
\entry{--disable-largefile}{22}{\code {--disable-largefile}}
\entry{large file support}{22}{large file support}
\entry{LFS (large file support)}{22}{LFS (large file support)}
\entry{size of PDF and PS files}{22}{size of PDF and PS files}
\entry{PDF files, size of}{22}{PDF files, size of}
\entry{PostScript files, size of}{22}{PostScript files, size of}
\entry{--disable-missing}{23}{\code {--disable-missing}}
\entry{--enable-compiler-warnings=level}{23}{\code {--enable-compiler-warnings=\var {level}}}
\entry{--enable-maintainer-mode}{23}{\code {--enable-maintainer-mode}}
\entry{--enable-multiplatform}{23}{\code {--enable-multiplatform}}
\entry{exec_prefix}{23}{\code {exec_prefix}}
\entry{--bindir configure option}{23}{\code {--bindir configure \r {option}}}
\entry{--libdir configure option}{23}{\code {--libdir configure \r {option}}}
\entry{--enable-shared}{23}{\code {--enable-shared}}
\entry{--enable-silent-rules}{23}{\code {--enable-silent-rules}}
\entry{make rules, verbose vs. silent}{23}{\code {make} rules, verbose vs.\: silent}
\entry{--without-ln-s}{23}{\code {--without-ln-s}}
\entry{--without-x}{24}{\code {--without-x}}
\entry{program-specific configure options}{24}{program-specific \code {configure} options}
\entry{configure options, program-specific}{24}{\code {configure} options, program-specific}
\entry{--enable-prog}{24}{\code {--enable-\var {prog}}}
\entry{--disable-prog}{24}{\code {--disable-\var {prog}}}
\entry{--disable-all-pkgs}{24}{\code {--disable-all-pkgs}}
\entry{configure options, for web2c}{24}{\code {configure} options, for \code {web2c}}
\entry{--with-banner-add=str}{24}{\code {--with-banner-add=\var {str}}}
\entry{--with-editor=cmd}{24}{\code {--with-editor=\var {cmd}}}
\entry{--with-fontconfig-includes=dir}{24}{\code {--with-fontconfig-includes=\var {dir}}}
\entry{--with-fontconfig-libdir=dir}{24}{\code {--with-fontconfig-libdir=\var {dir}}}
\entry{X toolkit}{24}{X toolkit}
\entry{libXt}{24}{\code {libXt}}
\entry{Xlib}{24}{\code {Xlib}}
\entry{--disable-dump-share}{24}{\code {--disable-dump-share}}
\entry{LittleEndian architectures}{24}{LittleEndian architectures}
\entry{--disable-ipc}{24}{\code {--disable-ipc}}
\entry{interprocess communication}{24}{interprocess communication}
\entry{--disable-mf-nowin}{24}{\code {--disable-mf-nowin}}
\entry{mf-nowin}{24}{\code {mf-nowin}}
\entry{--disable-tex}{24}{\code {--disable-tex}}
\entry{--enable-etex}{24}{\code {--enable-etex}}
\entry{web2c.ac}{24}{\code {web2c.ac}}
\entry{--disable-web-progs}{24}{\code {--disable-web-progs}}
\entry{--enable-auto-core}{25}{\code {--enable-auto-core}}
\entry{preloaded binaries}{25}{preloaded binaries}
\entry{--enable-libtool-hack}{25}{\code {--enable-libtool-hack}}
\entry{libtool, hack for avoiding excessive linking}{25}{\code {libtool\r {, hack for avoiding excessive linking}}}
\entry{libfontconfig, hack for avoiding linking dependencies}{25}{\code {libfontconfig\r {, hack for avoiding linking dependencies}}}
\entry{libexpat, dependency of libfontconfig}{25}{\code {libexpat\r {, dependency of \code {libfontconfig}}}}
\entry{--enable-*win for Metafont window support}{25}{\code {--enable-*win \r {for Metafont window support}}}
\entry{--enable-tex-synctex}{25}{\code {--enable-tex-synctex}}
\entry{--disable-etex-synctex}{25}{\code {--disable-etex-synctex}}
\entry{synctex}{25}{synctex}
\entry{--disable-synctex}{25}{\code {--disable-synctex}}
\entry{synctex}{25}{synctex}
\entry{configure options, for bibtex-x}{25}{\code {configure} options, for \code {bibtex-x}}
\entry{bibtex8}{25}{\code {bibtex8}}
\entry{bibtexu}{25}{\code {bibtexu}}
\entry{bibtex-x}{25}{\code {bibtex-x}}
\entry{--disable-bibtex8}{25}{\code {--disable-bibtex8}}
\entry{--disable-bibtexu}{25}{\code {--disable-bibtexu}}
\entry{configure options, for dvipdfm-x}{25}{\code {configure} options, for \code {dvipdfm-x}}
\entry{dvipdfm-x}{25}{\code {dvipdfm-x}}
\entry{dvipdfmx}{25}{\code {dvipdfmx}}
\entry{xdvipdfmx}{25}{\code {xdvipdfmx}}
\entry{--disable-dvipdfmx}{25}{\code {--disable-dvipdfmx}}
\entry{--disable-xdvipdfmx}{25}{\code {--disable-xdvipdfmx}}
\entry{configure options, for dvisvgm}{25}{\code {configure} options, for \file {dvisvgm}}
\entry{dvisvgm}{25}{\code {dvisvgm}}
\entry{--with-system-libgs}{25}{\code {--with-system-libgs}}
\entry{--without-libgs}{25}{\code {--without-libgs}}
\entry{--with-libgs-includes, -libdir}{25}{\code {--with-libgs-includes\r {,} -libdir}}
\entry{configure options, for texk/texlive}{26}{\code {configure} options, for \file {texk/texlive}}
\entry{--disable-linked-scripts}{26}{\code {--disable-linked-scripts}}
\entry{configure options, for xdvik}{26}{\code {configure} options, for \file {xdvik}}
\entry{xdvik}{26}{\code {xdvik}}
\entry{--with-gs=filename}{26}{\code {--with-gs=\var {filename}}}
\entry{Ghostscript location for Xdvik}{26}{Ghostscript location for Xdvik}
\entry{--with-xdvi-x-toolkit=kit}{26}{\code {--with-xdvi-x-toolkit=\var {kit}}}
\entry{motif}{26}{\code {motif}}
\entry{xaw}{26}{\code {xaw}}
\entry{--enable-xi2-scrolling}{26}{\code {--enable-xi2-scrolling}}
\entry{XInput}{26}{\code {XInput}}
\entry{scrolling, smooth}{26}{\code {scrolling, smooth}}
\entry{configure options, for xindy}{26}{\code {configure} options, for \file {xindy}}
\entry{xindy}{26}{\code {xindy}}
\entry{--enable-xindy-rules}{26}{\code {--enable-xindy-rules}}
\entry{--enable-xindy-docs}{26}{\code {--enable-xindy-docs}}
\entry{--with-clisp-runtime=filename}{26}{\code {--with-clisp-runtime=\var {filename}}}
\entry{lisp.run, lisp.exe}{26}{\code {lisp.run\r {,} lisp.exe}}
\entry{CLISP}{26}{CLISP}
\entry{library-specific configure options}{26}{library-specific \code {configure} options}
\entry{configure options, library-specific}{26}{\code {configure} options, library-specific}
\entry{--with-system-lib}{26}{\code {--with-system-\var {lib}}}
\entry{--with-lib-includes=dir, -libdir}{26}{\code {--with-\var {lib}-includes=\var {dir}\r {,} -libdir}}
\entry{configure options, for kpathsea}{26}{\code {configure} options, for \code {kpathsea}}
\entry{configure options, for system poppler}{27}{\code {configure} options, for system \code {poppler}}
\entry{poppler}{27}{\code {poppler}}
\entry{xpdf as library}{27}{\code {xpdf \r {as library}}}
\entry{--with-system-poppler}{27}{\code {--with-system-poppler}}
\entry{--with-system-xpdf}{27}{\code {--with-system-xpdf}}
\entry{variables for configure}{27}{variables for \code {configure}}
\entry{configure variables}{27}{\code {configure} variables}
\entry{CC}{27}{\code {CC}}
\entry{CXX}{27}{\code {CXX}}
\entry{CPPFLAGS}{27}{\code {CPPFLAGS}}
\entry{CLISP}{27}{\code {CLISP}}
\entry{clisp}{27}{\code {clisp}}
\entry{FT2_CONFIG}{27}{\code {FT2_CONFIG}}
\entry{ICU_CONFIG}{27}{\code {ICU_CONFIG}}
\entry{PKG_CONFIG}{27}{\code {PKG_CONFIG}}
\entry{freetype-config}{27}{\code {freetype-config}}
\entry{icu-config}{27}{\code {icu-config}}
\entry{libfreetype}{27}{\code {libfreetype}}
\entry{ICU libraries}{27}{ICU libraries}
\entry{KPSEWHICH}{27}{\code {KPSEWHICH}}
\entry{kpsewhich}{27}{\code {kpsewhich}}
\entry{MAKE}{28}{\code {MAKE}}
\entry{SED}{28}{\code {SED}}
\entry{PERL}{28}{\code {PERL}}
\entry{LATEX}{28}{\code {LATEX}}
\entry{PDFLATEX}{28}{\code {PDFLATEX}}
\entry{coding conventions}{29}{coding conventions}
\entry{conventions, coding}{29}{conventions, coding}
\entry{declarations and definitions, in source code}{29}{declarations and definitions, in source code}
\entry{source code declarations}{29}{source code declarations}
\entry{ANSI C}{29}{ANSI C}
\entry{declarations before statements, avoiding}{29}{declarations before statements, avoiding}
\entry{C, ANSI, required}{29}{C, ANSI, required}
\entry{C99, avoided}{29}{C99, avoided}
\entry{chktex}{29}{\code {chktex}}
\entry{stpcpy}{29}{\code {stpcpy}}
\entry{static functions}{29}{\code {static} functions}
\entry{extern functions}{29}{\code {extern} functions}
\entry{variable declarations, in source code}{29}{variable declarations, in source code}
\entry{const}{30}{\code {const}}
\entry{X11 headers, and const}{30}{X11 headers, and \code {const}}
\entry{libfreetype, and const}{30}{\code {libfreetype}, and \code {const}}
\entry{warning, discards qualifiers}{30}{warning, discards qualifiers}
\entry{discards qualifiers warning}{30}{discards qualifiers warning}
\entry{type cast from const, avoiding}{30}{type cast from const, avoiding}
\entry{continuous integration}{31}{continuous integration}
\entry{Travis-CI}{31}{Travis-CI}
\entry{git-svn}{31}{\code {git-svn}}
\entry{travis.yml}{32}{\code {travis.yml}}
