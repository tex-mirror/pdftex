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

$Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/writefont.c#12 $
*/

#include "ptexlib.h"

static const char perforce_id[] = 
    "$Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/writefont.c#12 $";

key_entry font_keys[FONT_KEYS_NUM] = {
    {"Ascent",       "Ascender",     {0}, false},
    {"CapHeight",    "CapHeight",    {0}, false},
    {"Descent",      "Descender",    {0}, false},
    {"FontName",     "FontName",     {0}, false},
    {"ItalicAngle",  "ItalicAngle",  {0}, false},
    {"StemV",        "StdVW",        {0}, false},
    {"XHeight",      "XHeight",      {0}, false},
    {"FontBBox",     "FontBBox",     {0}, false},
    {"",             "",             {0}, false},
    {"",             "",             {0}, false},
    {"",             "",             {0}, false}
};

internalfontnumber tex_font;
boolean fontfile_found;
boolean is_otf_font;
boolean write_ttf_glyph_names;

static int first_char, last_char;
static integer char_widths[MAX_CHAR_CODE + 1];
static boolean write_fontfile_only;
static boolean without_fontdescriptor;
static int char_widths_objnum,
           encoding_objnum;
static char **cur_glyph_names;

static void print_key(integer code, integer v)
{
    pdf_printf("/%s ", font_keys[code].pdfname);
    if (!font_keys[code].valid) {
        pdf_printf("%i",
                   (code == ITALIC_ANGLE_CODE) ? (int)v :
                   (int)dividescaled(v, pdffontsize[tex_font], 3));
    }
    else 
        pdf_printf("%i", (int)font_keys[code].value.num);
    pdf_puts("\n");
}

static integer getitalicangle(void)
{
    return -atan(getslant(tex_font)/65536.0)*(180/M_PI);
}

static integer getstemv(void)
{
    return getcharwidth(tex_font, '.')/3;
}

static void getbbox(void)
{
    font_keys[FONTBBOX1_CODE].value.num = 0;
    font_keys[FONTBBOX2_CODE].value.num = 
        dividescaled(-getchardepth(tex_font, 'y'), pdffontsize[tex_font], 3);
    font_keys[FONTBBOX3_CODE].value.num =
        dividescaled(getquad(tex_font), pdffontsize[tex_font], 3);
    font_keys[FONTBBOX4_CODE].value.num =
        dividescaled(getcharheight(tex_font, 'H'), pdffontsize[tex_font], 3);
}

/*
 * update glyph names of an encoding (either external or internal) 
 * when fontec[f] < 128 
 */
void update_enc(internalfontnumber f, char **glyph_names)
{
    int i;
    fm_entry *fm = fm_tab + pdffontmap[f];
    if (fontec[f] > 127 || 
        (fm >= fm_tab &&
         (is_reencoded(fm) && (enc_tab + fm->encoding)->updated)))
        return;
    for (i = fontbc[f]; i <= 32; i++)
        if (pdfcharmap[f][i] != i) {
            if (glyph_names[i + MOVE_CHARS_OFFSET] != notdef)
                xfree(glyph_names[i + MOVE_CHARS_OFFSET]);
            if (glyph_names[i] != notdef)
                glyph_names[i + MOVE_CHARS_OFFSET] = xstrdup(glyph_names[i]);
            else
                glyph_names[i + MOVE_CHARS_OFFSET] = xstrdup(notdef);
        }
    if (is_reencoded(fm))
        (enc_tab + fm->encoding)->updated = true;
}

static void get_char_widths(void)
{
    int i;
    for (i = 0; i <= MAX_CHAR_CODE; i++) {
        if (i < fontbc[tex_font] || i > fontec[tex_font])
            char_widths[i] = 0;
        else
            char_widths[i] = getcharwidth(tex_font, i);
    }
    for (i = fontbc[tex_font]; i <= 32; i++)
        char_widths[pdfcharmap[tex_font][i]] = char_widths[i];
    for (i = fontbc[tex_font]; i <= MAX_CHAR_CODE; i++)
        if (pdfcharmarked(tex_font, i))
            break;
    first_char = i;
    for (i = MAX_CHAR_CODE; i > first_char;  i--)
        if (pdfcharmarked(tex_font, i))
            break;
    last_char = i;
    if ((first_char > last_char) ||
        (first_char == last_char && !pdfcharmarked(tex_font, first_char))) { 
        write_fontfile_only = true; /* the font is used in PDF images only */
        return;
    }
    for (i = first_char; i <= last_char; i++)
        if (pdfcharmarked(tex_font, i))
            char_widths[i] = dividescaled(char_widths[i], 
                                          pdffontsize[tex_font], 3);
        else
            char_widths[i] = 0;
    if (is_reencoded(fm_cur) && pdfmovechars > 0) {
        read_enc(fm_cur->encoding);
        update_enc(f, (enc_tab + fm_cur->encoding)->glyph_names);
    }
}

static void write_char_widths(void)
{
    int i;
    pdfbeginobj(char_widths_objnum); 
    pdf_puts("[");
    for (i = first_char; i <= last_char; i++)
        pdf_printf("%i ", char_widths[i]);
    pdf_puts("]\n");
    pdfendobj();
}

static void write_fontname(boolean as_reference)
{
    if (as_reference && fm_cur->fn_objnum != 0) {
        pdf_printf("%i 0 R\n", (int)fm_cur->fn_objnum);
        return;
    }
    pdf_puts("/");
    if (fm_cur->subset_tag != 0)
        pdf_printf("%s+", fm_cur->subset_tag);
    if (font_keys[FONTNAME_CODE].valid)
        pdf_printf("%s", font_keys[FONTNAME_CODE].value.string);
    else if (fm_cur->ps_name != 0)
        pdf_printf("%s", fm_cur->ps_name);
    else
        pdf_printf("%s", fm_cur->tfm_name);
    if (pdffontexpandratio[tex_font] != 0 && !is_included(fm_cur))
        pdf_printf("%+i", (int)pdffontexpandratio[tex_font]);
    pdf_puts("\n");
}

static void write_fontobj(integer font_objnum)
{
    pdfbegindict(font_objnum);
    pdf_puts("/Type /Font\n");
    pdf_printf("/Subtype /%s\n", is_truetype(fm_cur) ? "TrueType" : "Type1");
    if (encoding_objnum != 0)
        pdf_printf("/Encoding %i 0 R\n", (int)encoding_objnum);
    if (pdffontattr[tex_font] != getnullstr()) {
        pdfprint(pdffontattr[tex_font]);
        pdf_puts("\n");
    }
    if (is_basefont(fm_cur)) {
        pdf_printf("/BaseFont /%s\n", fm_cur->ps_name);
        pdfenddict();
        return;
    }
    char_widths_objnum = pdfnewobjnum();
    pdf_printf("/FirstChar %i\n/LastChar %i\n/Widths %i 0 R\n",
               first_char, last_char, char_widths_objnum);
    if (is_noparsing(fm_cur))
        pdf_printf("/BaseFont /%s\n", fm_cur->ps_name);
    else {
        pdf_printf("/BaseFont ");
        write_fontname(true);
        if (fm_cur->fd_objnum == 0)
            fm_cur->fd_objnum = pdfnewobjnum();
        pdf_printf("/FontDescriptor %i 0 R\n", fm_cur->fd_objnum);
    }
    pdfenddict();
}

static void write_fontfile(void)
{
    int i;
    for (i = 0; i < FONT_KEYS_NUM; i++)
        font_keys[i].valid = false;
    fontfile_found = false;
    is_otf_font = false;
    if (is_truetype(fm_cur))
        writettf();
    else
        writet1();
    if (!fontfile_found || !is_included(fm_cur))
        return;
    if (fm_cur->ff_objnum == 0)
        pdftex_fail("font file object number for `%s' not initialized",
                    fm_cur->tfm_name);
    pdfbegindict(fm_cur->ff_objnum); /* font file stream */
    if (is_truetype(fm_cur))
        pdf_printf("/Length1 %i\n", (int)ttf_length);
    else if (is_otf_font) 
        pdf_printf("/Subtype /Type1C\n");
    else
        pdf_printf("/Length1 %i\n/Length2 %i\n/Length3 %i\n",
                   (int)t1_length1, (int)t1_length2, (int)t1_length3);
    pdfbeginstream();
    ff_flush();
    pdfendstream();
}

static void write_fontdescriptor(void)
{
    int i;

    pdfbegindict(fm_cur->fd_objnum); /* font descriptor */
    print_key(ASCENT_CODE, getcharheight(tex_font, 'h'));
    print_key(CAPHEIGHT_CODE, getcharheight(tex_font, 'H'));
    print_key(DESCENT_CODE, -getchardepth(tex_font, 'y'));
    pdf_printf("/FontName ");
    write_fontname(true);
    print_key(ITALIC_ANGLE_CODE, getitalicangle());
    print_key(STEMV_CODE, getstemv());
    print_key(XHEIGHT_CODE, getxheight(tex_font));
    if (!font_keys[FONTBBOX1_CODE].valid) {
        getbbox();
    }
    pdf_printf("/%s [%i %i %i %i]\n",
               font_keys[FONTBBOX1_CODE].pdfname,
               (int)font_keys[FONTBBOX1_CODE].value.num,
               (int)font_keys[FONTBBOX2_CODE].value.num,
               (int)font_keys[FONTBBOX3_CODE].value.num,
               (int)font_keys[FONTBBOX4_CODE].value.num);
    if (!fontfile_found)
        pdf_puts("/Flags 34\n");
    else
        pdf_printf("/Flags %i\n", (int)fm_cur->flags);
    if (is_included(fm_cur) && fontfile_found) {
        if (is_subsetted(fm_cur) && !is_truetype(fm_cur)) {
            cur_glyph_names = t1_glyph_names;
            pdf_puts("/CharSet (");

            for (i = 0; i <= MAX_CHAR_CODE; i++)
                if (pdfcharmarked(tex_font, i) && cur_glyph_names[i] != notdef)
					pdf_printf("/%s", cur_glyph_names[i]);
            pdf_puts(")\n");
        }
        if (is_truetype(fm_cur))
            pdf_printf("/FontFile2 %i 0 R\n", fm_cur->ff_objnum);
        else if (is_otf_font)
            pdf_printf("/FontFile3 %i 0 R\n", fm_cur->ff_objnum);
        else
            pdf_printf("/FontFile %i 0 R\n", fm_cur->ff_objnum);
    }
    pdfenddict();
}

void dopdffont(integer font_objnum, internalfontnumber f)
{
    int i;
    tex_font = f;
    cur_glyph_names = 0;
    encoding_objnum = 0;
    write_ttf_glyph_names = false;
    write_fontfile_only = false;
    without_fontdescriptor = false;
    if (pdffontmap[tex_font] == -1)
        pdftex_fail("pdffontmap not initialized for font %s", 
                    makecstring(fontname[tex_font]));
    if (pdffontmap[tex_font] >= 0)
        fm_cur = fm_tab + pdffontmap[tex_font];
    else
        fm_cur = 0;
    if (fm_cur == 0 || (fm_cur->ps_name == 0 && fm_cur->ff_name == 0)) {
        writet3(font_objnum, tex_font);
        return;
    }
    if (fm_cur->tfm_num != tex_font)
        without_fontdescriptor = true; /* cannot remember why it is needed :( */
    get_char_widths();
    if ((is_reencoded(fm_cur))) {
        read_enc(fm_cur->encoding);
/*         if (!is_truetype(fm_cur) || !indexed_enc(fm_cur)) { */
        if (!is_truetype(fm_cur)) {
            write_enc(0, fm_cur->encoding);
            encoding_objnum = enc_tab[fm_cur->encoding].objnum;
            if (is_truetype(fm_cur))
                write_ttf_glyph_names = true;
        }
    }
    else if (!is_basefont(fm_cur) && 
             !is_truetype(fm_cur) && 
             !without_fontdescriptor)
        encoding_objnum = pdfnewobjnum();
    if (without_fontdescriptor) {
        if (fm_cur->fn_objnum == 0)
            fm_cur->fn_objnum = pdfnewobjnum();
        write_fontobj(font_objnum);
        write_char_widths();
        return;
    }
    if (!is_basefont(fm_cur))
        write_fontfile();
    if (fm_cur->fn_objnum != 0) {
        pdfbeginobj(fm_cur->fn_objnum);
        write_fontname(false);
        pdfendobj();
    }
    if (!write_fontfile_only)
        write_fontobj(font_objnum);
    if (is_basefont(fm_cur) || is_noparsing(fm_cur))
        return;
    if (!write_fontfile_only) {
        write_fontdescriptor();
        write_char_widths();
    }
    if (cur_glyph_names == t1_builtin_glyph_names) {
        for (i = 0; i <= MAX_CHAR_CODE; i++)
            if (!pdfcharmarked(tex_font, i) && cur_glyph_names[i] != notdef) {
                xfree(cur_glyph_names[i]);
                cur_glyph_names[i] = xstrdup(notdef);
            }
        write_enc(cur_glyph_names, encoding_objnum);
        for (i = 0; i <= MAX_CHAR_CODE; i++)
            if (cur_glyph_names[i] != notdef)
                xfree(cur_glyph_names[i]);
    }
}
