/*
Copyright (c) 1996-2004 Han The Thanh, <thanh@pdftex.org>

This file is part of pdfTeX.

pdfTeX is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

pdfTeX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with pdfTeX; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

$Id: //depot/Build/source.development/TeX/texk/web2c/pdfetexdir/pdfetexextra.h#115 $
*/

/* pdfetexextra.h: banner etc. for pdfeTeX.

   This is included by pdfeTeX, from ../pdfetexextra.c
   (generated from ../lib/texmfmp.c).
*/

#define BANNER "This is pdfeTeX, Version 3.141592-1.20a-2.1-rc1"
#define COPYRIGHT_HOLDER "The NTS Team (eTeX)/Han The Thanh (pdfTeX)"
#define AUTHOR NULL
#define PROGRAM_HELP PDFETEXHELP
#define DUMP_VAR TEXformatdefault
#define DUMP_LENGTH_VAR formatdefaultlength
#define DUMP_OPTION "efmt"
#ifdef DOS
#define DUMP_EXT ".efm"
#else
#define DUMP_EXT ".efmt"
#endif
#define INPUT_FORMAT kpse_tex_format
#define INI_PROGRAM "pdfeinitex"
#define VIR_PROGRAM "pdfevirtex"

