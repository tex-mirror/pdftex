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

$Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/config.c#13 $
*/

#include "ptexlib.h"

static const char perforce_id[] = 
    "$Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/config.c#13 $";

static FILE *cfg_file;
static char config_name[] = "pdftex.cfg";
boolean true_dimen;

#define cfg_open()       \
    open_input(&cfg_file, kpse_tex_format, FOPEN_RBIN_MODE)
#define cfg_close()      xfclose(cfg_file, cur_file_name)
#define cfg_getchar()    xgetc(cfg_file)
#define cfg_eof()        feof(cfg_file)

typedef struct {
    int code;
    const char *name;
    integer value;
    boolean is_true_dimen;
} cfg_entry;

#define CFG_BUF_SIZE     1024
#define CFG_FONTMAP_CODE 0

cfg_entry cfg_tab[] = {
    {CFG_FONTMAP_CODE,       "map",                  0, false},
    {cfgoutputcode,          "output_format",        0, false},
    {cfgadjustspacingcode,   "adjust_spacing"      , 0, false},
    {cfgcompresslevelcode,   "compress_level",       0, false},
    {cfgdecimaldigitscode,   "decimal_digits",       4, false},
    {cfgmovecharscode,       "move_chars",           0, false},
    {cfgimageresolutioncode, "image_resolution",     0, false},
    {cfgpkresolutioncode,    "pk_resolution",        0, false},
    {cfguniqueresnamecode,   "unique_resname",       0, false},
    {cfgprotrudecharscode,   "protrude_chars",       0, false},
    {cfghorigincode,         "horigin",              0, false},
    {cfgvorigincode,         "vorigin",              0, false},
    {cfgpageheightcode,      "page_height",          0, false},
    {cfgpagewidthcode,       "page_width",           0, false},
    {cfglinkmargincode,      "link_margin",          0, false},
    {cfgdestmargincode,      "dest_margin",          0, false},
    {cfgthreadmargincode,    "thread_margin",        0, false},
    {cfgpdf12compliantcode,  "pdf12_compliant",      0, false},
    {cfgpdf13compliantcode,  "pdf13_compliant",      0, false},
    {cfgpdfminorversioncode, "pdf_minorversion",    -1, false},
    {cfgalwaysusepdfpageboxcode,    "always_use_pdfpagebox",  0, false},
    {cfgpdfoptionpdfinclusionerrorlevelcode, "pdf_inclusion_errorlevel",  1, false},
    {0,                      0,                      0, false}
};

#define is_cfg_comment(c) (c == '*' || c == '#' || c == ';' || c == '%')

static char *add_map_file(char *s)
{
    char *p = s, *q = s;
    for (; *p != 0 && *p != ' ' && *p != 10; p++);
    if (*q != '+') {
        xfree(mapfiles);
        mapfiles = 0;
    }
    else
        q++;
    if (mapfiles == 0) {
        mapfiles = xtalloc(p - q + 2, char);
        *mapfiles = 0;
    }
    else
        mapfiles = 
            xretalloc(mapfiles, strlen(mapfiles) + p - q + 2, char);
    strncat(mapfiles, q, (unsigned)(p - q));
    strcat(mapfiles, "\n");
    return p;
}

void pdfmapfile(integer t)
{
    add_map_file(makecstring(tokenstostring(t)));
}

void readconfigfile()
{
    int c, res, sign;
    cfg_entry *ce;
    char cfg_line[CFG_BUF_SIZE], *p;
    set_cur_file_name(config_name);
    if (!cfg_open())
        pdftex_fail("cannot open config file");
    cur_file_name = (char*)nameoffile + 1;
    tex_printf("{%s", cur_file_name);
    for (;;) {
        if (cfg_eof()) {
            cfg_close();
            tex_printf("}");
            cur_file_name = 0;
            break;
        }
        p = cfg_line;
        do {
            c = cfg_getchar();
            append_char_to_buf(c, p, cfg_line, CFG_BUF_SIZE);
        } while (c != 10);
        append_eol(p, cfg_line, CFG_BUF_SIZE);
        c = *cfg_line;
        if (p - cfg_line == 1 || is_cfg_comment(c))
            continue;
        p = cfg_line;
        for (ce = cfg_tab; ce->name != 0; ce++)
            if (!strncmp(cfg_line, ce->name, strlen(ce->name))) {
                break;
                }
        if (ce->name == 0) {
            remove_eol(p, cfg_line);
            pdftex_warn("invalid parameter name in config file: `%s'", cfg_line);
            continue;
        }
        p = cfg_line + strlen(ce->name);
        skip(p, ' ');
        skip(p, '=');
        skip(p, ' ');
        switch (ce->code) {
        case CFG_FONTMAP_CODE:
            p = add_map_file(p);
            break;
        case cfgoutputcode:
        case cfgadjustspacingcode:
        case cfgcompresslevelcode:
        case cfgdecimaldigitscode:
        case cfgmovecharscode:
        case cfgimageresolutioncode:
        case cfgpkresolutioncode:
        case cfguniqueresnamecode:
        case cfgprotrudecharscode:
        case cfgpdf12compliantcode:
        case cfgpdf13compliantcode:
        case cfgpdfminorversioncode:
        case cfgalwaysusepdfpageboxcode:
        case cfgpdfoptionpdfinclusionerrorlevelcode:
            if (*p == '-') {
                p++;
                sign = -1;
            }
            else
                sign = 1;
            ce->value = myatol(&p);
            if (ce->value == -1) {
                remove_eol(p, cfg_line);
                pdftex_warn("invalid parameter value in config filecode: `%s'", cfg_line);
                ce->value = 0;
            }
            else
                ce->value *= sign;
            break;
        case cfghorigincode:
        case cfgvorigincode:
        case cfgpageheightcode:
        case cfgpagewidthcode:
        case cfglinkmargincode:
        case cfgthreadmargincode:
            ce->value = myatodim(&p);
            ce->is_true_dimen = true_dimen;
            break;
        }
        skip(p, ' ');
        if (*p != 10 && !is_cfg_comment(*p)) {
            remove_eol(p, cfg_line);
            pdftex_warn("invalid line in config file: `%s'", cfg_line);
        }
    }
    res = cfgpar(cfgpkresolutioncode);
    if (res == 0)
        res = 600;
    kpse_init_prog("pdfTeX", (unsigned)res, NULL, NULL);
    if (mapfiles == 0)
        mapfiles = xstrdup("psfonts.map\n");
}

boolean iscfgtruedimen(integer code)
{
    cfg_entry *ce;
    for (ce = cfg_tab; ce->name != 0; ce++)
        if (ce->code == code)
            return ce->is_true_dimen;
    return 0;
}

integer cfgpar(integer code)
{
    cfg_entry *ce;
    for (ce = cfg_tab; ce->name != 0; ce++)
        if (ce->code == code)
           return ce->value;
    return 0;
}
