/*
Copyright (c) 1996-2002 Han The Thanh, <thanh@pdftex.org>

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

$Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/epdf.c#11 $
*/

#include "ptexlib.h"
#include <kpathsea/c-vararg.h>
#include <kpathsea/c-proto.h>

integer pdfbufmax = pdfbufsize;

extern void epdf_check_mem(void);

int is_subsetable(int i)
{
    fm_entry *fm = fm_tab + i;
    return is_included(fm) && is_subsetted(fm);
}

int is_type1(int i)
{
    fm_entry *fm = fm_tab + i;
    return is_t1fontfile(fm);
}

void mark_glyphs(int i, char *charset)
{
    char *new_charset = fm_tab[i].charset;
    if (charset == 0)
        return;
    if (new_charset == 0)
        new_charset = xstrdup(charset);
    else {
        new_charset = xretalloc(new_charset, 
                                strlen(new_charset) + strlen(charset) + 1,
                                char);
        strcat(new_charset, charset);
    }
    fm_tab[i].charset = new_charset;
}

void embed_whole_font(int i)
{
    fm_tab[i].all_glyphs = true;
}

integer get_fontfile(int i)
{
    return fm_tab[i].ff_objnum;
}

integer get_fontname(int i)
{
    if (fm_tab[i].fn_objnum == 0)
        fm_tab[i].fn_objnum = pdfnewobjnum();
    return fm_tab[i].fn_objnum;
}

void epdf_free(void)
{
    epdf_check_mem();
}
