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

$Id: //depot/Build/source.development/TeX/texk/web2c/pdftexdir/mapfile.c#17 $
*/

#include <math.h>
#include "ptexlib.h"
#include <kpathsea/c-auto.h>
#include <kpathsea/c-memstr.h>
#include "avlstuff.h"

#define AUTO_MAKE_EXT_FONT
#undef AUTO_MAKE_EXT_FONT

static const char perforce_id[] =
    "$Id: //depot/Build/source.development/TeX/texk/web2c/pdftexdir/mapfile.c#17 $";

#define FM_BUF_SIZE     1024

static FILE *fm_file;

#define fm_open()       \
    open_input (&fm_file, kpse_fontmap_format, FOPEN_RBIN_MODE)
#define fm_close()      xfclose(fm_file, cur_file_name)
#define fm_getchar()    xgetc(fm_file)
#define fm_eof()        feof(fm_file)

#ifdef DELETE
#undef DELETE
#endif
enum _mode { DUPIGNORE, REPLACE, DELETE };
enum _ltype { MAPFILE, MAPLINE };

typedef struct mitem {
    int mode;			/* DUPIGNORE or REPLACE or DELETE */
    int type;			/* mapfile or map line */
    char *line;			/* pointer to map line */
    struct mitem *next;		/* pointer to next item, or NULL */
} mapitem;
mapitem *miptr, *mapitems = NULL;

fm_entry *fm_cur;
static const char nontfm[] = "<nontfm>";

static const char *basefont_names[14] = {
    "Courier",
    "Courier-Bold",
    "Courier-Oblique",
    "Courier-BoldOblique",
    "Helvetica",
    "Helvetica-Bold",
    "Helvetica-Oblique",
    "Helvetica-BoldOblique",
    "Symbol",
    "Times-Roman",
    "Times-Bold",
    "Times-Italic",
    "Times-BoldItalic",
    "ZapfDingbats"
};

#define read_field(r, q, buf) do {                     \
    for (q = buf; *r != ' ' && *r != 10; *q++ = *r++); \
    *q = 0;                                            \
    skip (r, ' ');                                     \
} while (0)

#define set_field(F) do {                              \
    if (q > buf)                                       \
        fm_ptr->F = xstrdup(buf);                      \
    if (*r == 10)                                      \
        goto done;                                     \
} while (0)

static fm_entry *new_fm_entry(void)
{
    fm_entry *fm;
    fm = xtalloc(1, fm_entry);
    fm->tfm_name = NULL;
    fm->ps_name = NULL;
    fm->flags = 0;
    fm->ff_name = NULL;
    fm->subset_tag = NULL;
    fm->encoding = -1;
    fm->tfm_num = getnullfont();
    fm->type = 0;
    fm->slant = 0;
    fm->extend = 0;
    fm->expansion = 0;
    fm->ff_objnum = 0;
    fm->fn_objnum = 0;
    fm->fd_objnum = 0;
    fm->charset = NULL;
    fm->all_glyphs = false;
    fm->links = 0;
    return fm;
}

static void delete_fm_entry(fm_entry * fm)
{
    if (fm->tfm_name != nontfm)
        xfree(fm->tfm_name);
    xfree(fm->ps_name);
    xfree(fm->ff_name);
    xfree(fm->subset_tag);
    xfree(fm->charset);
    xfree(fm);
}

static ff_entry *new_ff_entry(void)
{
    ff_entry *ff;
    ff = xtalloc(1, ff_entry);
    ff->ff_name = NULL;
    ff->ff_path = NULL;
    ff->expansion = 0;
    ff->ismm = 0;
    return ff;
}

static void delete_ff_entry(ff_entry * ff)
{
    xfree(ff->ff_name);
    xfree(ff->ff_path);
    xfree(ff);
}

static fm_entry *dummy_fm_entry()
{
    static const fm_entry const_fm_entry;
    return (fm_entry*) &const_fm_entry;
}

boolean hasfmentry(fmentryptr fm)
{
    return fm != (fmentryptr) 0 && fm != (fmentryptr) dummy_fm_entry();
}

/**********************************************************************/

struct avl_table *tfm_tree = NULL;
struct avl_table *ps_tree = NULL;
struct avl_table *ff_tree = NULL;

/* AVL sort fm_entry into tfm_tree by tfm_name and expansion */

static int comp_fm_entry_tfm(const void *pa, const void *pb, void *param)
{
    int a, b;
    int i;
    if ((i =
         strcmp(((const fm_entry *) pa)->tfm_name,
                ((const fm_entry *) pb)->tfm_name)) != 0)
        return i;
    a = ((const fm_entry *) pa)->expansion;
    b = ((const fm_entry *) pb)->expansion;
    if (a > b)
        return 1;
    if (a < b)
        return -1;
    return 0;
}

/* AVL sort fm_entry into ps_tree by ps_name, slant, and extend */

static int comp_fm_entry_ps(const void *pa, const void *pb, void *param)
{
    integer a, b;
    int i;
    if ((i =
         strcmp(((const fm_entry *) pa)->ps_name,
                ((const fm_entry *) pb)->ps_name)) != 0)
        return i;
    a = ((const fm_entry *) pa)->slant;
    b = ((const fm_entry *) pb)->slant;
    if (a > b)
        return 1;
    if (a < b)
        return -1;
    a = ((const fm_entry *) pa)->extend;
    b = ((const fm_entry *) pb)->extend;
    if (a > b)
        return 1;
    if (a < b)
        return -1;
    return 0;
}

/* AVL sort ff_entry into ff_tree by ff_name and expansion */

static int comp_ff_entry(const void *pa, const void *pb, void *param)
{
    int a, b;
    int i;
    if ((i =
         strcmp(((const ff_entry *) pa)->ff_name,
                ((const ff_entry *) pb)->ff_name)) != 0)
        return i;
    a = ((const ff_entry *) pa)->expansion;
    b = ((const ff_entry *) pb)->expansion;
    if (a > b)
        return 1;
    if (a < b)
        return -1;
    return 0;
}

static void create_avl_trees()
{
    if (tfm_tree == NULL) {
        tfm_tree = avl_create(comp_fm_entry_tfm, NULL, &avl_xallocator);
        assert(tfm_tree != NULL);
    }
    if (ps_tree == NULL) {
        ps_tree = avl_create(comp_fm_entry_ps, NULL, &avl_xallocator);
        assert(ps_tree != NULL);
    }
    if (ff_tree == NULL) {
        ff_tree = avl_create(comp_ff_entry, NULL, &avl_xallocator);
        assert(ff_tree != NULL);
    }
}

/*
The function avl_do_entry() is not completely symmetrical with regards
to tfm_name and ps_name handling, e. g. a duplicate tfm_name gives a
"goto exit", and no ps_name link is tried. This is to keep it compatible
with the original version.
*/

static int avl_do_entry(fm_entry * fp, int mode)
{
    fm_entry *p;

    /* handle tfm_name link */

    if (fp->tfm_name != nontfm) {
        p = (fm_entry *) avl_find(tfm_tree, fp);
        if (p != NULL) {
            if (mode == DUPIGNORE) {
                pdftex_warn("fontmap entry for `%s' already exists, duplicates ignored",
                            fp->tfm_name);
                goto exit;
            } else {
                if (fontused[p->tfm_num]) {
                    /* REPLACE/DELETE not allowed */
                    pdftex_warn("fontmap entry for `%s' has been used, replace/delete not allowed",
                                fp->tfm_name);
                    goto exit;        
                }
                assert(avl_delete(tfm_tree, p) != NULL);
                unset_tfmlink(p);
                if (!has_pslink(p))
                    delete_fm_entry(p);
            }
        }
        if (mode != DELETE) {
            assert(avl_probe(tfm_tree, fp) != NULL);
            set_tfmlink(fp);
        }
    }

    /* handle ps_name link */

    if (fp->ps_name != NULL) {
        p = avl_find(ps_tree, fp);
        if (p != NULL) {
            if (mode == DUPIGNORE) {
                /*
                pdftex_warn("ps_name entry for `%s' already exists, duplicates ignored",
                            fp->ps_name);
                */
                goto exit;
            } else {
                if (fontused[p->tfm_num]) {
                    /* REPLACE/DELETE not allowed */
                    pdftex_warn("fontmap entry for `%s' has been used, replace/delete not allowed",
                                p->tfm_name);
                    goto exit;        
                }
                assert(avl_delete(ps_tree, p) != NULL);
                unset_pslink(p);
                if (!has_tfmlink(p))
                    delete_fm_entry(p);
            }
        }
        if (mode != DELETE) {
            assert(avl_probe(ps_tree, fp) != NULL);
            set_pslink(fp);
        }
    }
exit:
    if (!has_tfmlink(fp) && !has_pslink(fp))        /* e. g. after DELETE */
        return 1;                /* deallocation of fm_entry structure required */
    else
        return 0;
}

/**********************************************************************/

static void fm_scan_line(mapitem * mitem)
{
    int a, b, c, i, j;
    float d;
    char fm_line[FM_BUF_SIZE], buf[FM_BUF_SIZE];
    fm_entry *fm_ptr = NULL;
    char *p, *q, *r, *s, *t = NULL;
    p = fm_line;
    switch (mitem->type) {
    case MAPFILE:
        do {
            c = fm_getchar();
            append_char_to_buf(c, p, fm_line, FM_BUF_SIZE);
        }
        while (c != 10);
        break;
    case MAPLINE:
        t = mitem->line;
        while ((c = *t++) != 0)
            append_char_to_buf(c, p, fm_line, FM_BUF_SIZE);
        break;
    default:
        assert(0);
    }
    append_eol(p, fm_line, FM_BUF_SIZE);
    if (is_cfg_comment(*fm_line))
        return;
    r = fm_line;
    read_field(r, q, buf);
    fm_ptr = new_fm_entry();
    if (strcmp(buf, nontfm) == 0)
        fm_ptr->tfm_name = (char*)nontfm;  /* don't allocate mem for nontfm */
    else
        set_field(tfm_name);
    if (*r == 10)
        goto done;
    p = r;
    read_field(r, q, buf);
    if (*buf != '<' && *buf != '"')
        set_field(ps_name);
    else
        r = p;                        /* unget the field */
    if (isdigit(*r)) {                /* font flags given */
        fm_ptr->flags = atoi(r);
        while (isdigit(*r))
            r++;
    } else
        fm_ptr->flags = 4;      /* treat as Symbol font */
    while (1) {                 /* this was former label reswitch: */
        skip(r, ' ');
        a = b = 0;
        if (*r == '!')
            a = *r++;
        else {
            if (*r == '<')
                a = *r++;
            if (*r == '<' || *r == '[')
                b = *r++;
        }
        switch (*r) {
        case 10:
            goto done;
        case '"':                /* opening quote */
            r++;
            do {
                skip(r, ' ');
                if (sscanf(r, "%f %n", &d, &j) > 0) {
                    s = r + j;        /* jump behind number, eat also blanks, if any */
                    if (*(s - 1) == 'E' || *(s - 1) == 'e')
                        s--;        /* e. g. 0.5ExtendFont: %f = 0.5E */
                    if (strncmp(s, "SlantFont", strlen("SlantFont")) == 0) {
                        d *= 1000.0;        /* correct rounding also for neg. numbers */
                        fm_ptr->slant =
                            (integer) (d > 0 ? d + 0.5 : d - 0.5);
                        r = s + strlen("SlantFont");
                    } else
                        if (strncmp(s, "ExtendFont", strlen("ExtendFont"))
                            == 0) {
                        d *= 1000.0;
                        fm_ptr->extend =
                            (integer) (d > 0 ? d + 0.5 : d - 0.5);
                        if (fm_ptr->extend == 1000)
                            fm_ptr->extend = 0;
                        r = s + strlen("ExtendFont");
                    } else {
                        pdftex_warn
                            ("invalid entry for `%s': unknown name `%s' ignored",
                             fm_ptr->tfm_name, s);
                        for (r = s; *r != ' ' && *r != '"' && *r != 10;
                             r++);
                    }
                } else
                    for (; *r != ' ' && *r != '"' && *r != 10; r++);
            }
            while (*r == ' ');
            if (*r == '"')        /* closing quote */
                r++;
            else {
                pdftex_warn("invalid entry for `%s': unknown line format",
                            fm_ptr->tfm_name);
                goto bad_line;
            }
            break;
        default:
            read_field(r, q, buf);
            if ((a == '<' && b == '[') ||
                (a != '!' && b == 0 && (strlen(buf) > 4) &&
                 !strcasecmp(strend(buf) - 4, ".enc")))
                fm_ptr->encoding = add_enc(buf);
            else {
                if (a == '<') {
                    set_included(fm_ptr);
                    if (b == 0)
                        set_subsetted(fm_ptr);
                } else if (a == '!')
                    set_noparsing(fm_ptr);
                set_field(ff_name);
            }
        }
    }
  done:
    if (fm_ptr->ps_name != NULL) {
        for (i = 0; i < 14; i++)
            if (strcmp(basefont_names[i], fm_ptr->ps_name) == 0)
                break;
        if (i < 14) {
            set_basefont(fm_ptr);
            unset_included(fm_ptr);
            unset_subsetted(fm_ptr);
            unset_truetype(fm_ptr);
            unset_fontfile(fm_ptr);
        } else if (fm_ptr->ff_name == NULL) {
            pdftex_warn("invalid entry for `%s': font file missing",
                        fm_ptr->tfm_name);
            goto bad_line;
        }
    }
    if (fm_fontfile(fm_ptr) != NULL &&
        strcasecmp(strend(fm_fontfile(fm_ptr)) - 4, ".ttf") == 0)
        set_truetype(fm_ptr);
    if ((fm_ptr->slant != 0 || fm_ptr->extend != 0) &&
        (!is_included(fm_ptr) || is_truetype(fm_ptr))) {
        pdftex_warn
            ("invalid entry for `%s': SlantFont/ExtendFont can be used only with embedded T1 fonts",
             fm_ptr->tfm_name);
        goto bad_line;
    }
    if (is_truetype(fm_ptr) && (is_reencoded(fm_ptr)) &&
        !is_subsetted(fm_ptr)) {
        pdftex_warn
            ("invalid entry for `%s': only subsetted TrueType font can be reencoded",
             fm_ptr->tfm_name);
        goto bad_line;
    }
    if (abs(fm_ptr->slant) >= 2000) {
        pdftex_warn
            ("invalid entry for `%s': too big value of SlantFont (%.3g)",
             fm_ptr->tfm_name, fm_ptr->slant / 1000.0);
        goto bad_line;
    }
    if (abs(fm_ptr->extend) >= 2000) {
        pdftex_warn
            ("invalid entry for `%s': too big value of ExtendFont (%.3g)",
             fm_ptr->tfm_name, fm_ptr->extend / 1000.0);
        goto bad_line;
    }

    /*
       Until here the map line has been completely scanned without errors;
       fm_ptr points to a valid, freshly filled-out fm_entry structure.
       Now follows the actual work of registering/deleting.
     */

    if (avl_do_entry(fm_ptr, mitem->mode) == 1) /* if no link to fm_entry */
        goto bad_line;
    return;
  bad_line:
    delete_fm_entry(fm_ptr);
}

void fm_read_info()
{
    mapitem *tmp;
    create_avl_trees();
    while (mapitems != NULL) {
        assert(mapitems->line != NULL);
        switch (mapitems->type) {
        case MAPFILE:
            set_cur_file_name(mapitems->line);
            if (!fm_open()) {
                pdftex_warn("cannot open font map file");
            } else {
                cur_file_name = (char *) nameoffile + 1;
                tex_printf("{%s", cur_file_name);
                while (!fm_eof())
                    fm_scan_line(mapitems);
                fm_close();
                tex_printf("}");
                fm_file = NULL;
            }
            break;
        case MAPLINE:
            cur_file_name = NULL;        /* makes pdftex_warn() shorter */
            fm_scan_line(mapitems);
            break;
        default:
            assert(0);
        }
        tmp = mapitems;
        mapitems = mapitems->next;
        xfree(tmp->line);
        xfree(tmp);
    }
    cur_file_name = NULL;
    return;
}

/**********************************************************************/

char *mk_basename(char *exname)
{
    static char buf[SMALL_BUF_SIZE];
    char *p = exname, *q, *r;
    if ((r = strrchr(p, '.')) == NULL)
        r = strend(p);
    for (q = r - 1; q > p && isdigit(*q); q--);
    if (q <= p || q == r - 1 || (*q != '+' && *q != '-'))
        pdftex_fail("invalid name of expanded font (%s)", p);
    check_buf(q - p + strlen(r) + 1, SMALL_BUF_SIZE);
    strncpy(buf, p, (unsigned) (q - p));
    buf[q - p] = 0;
    strcat(buf, r);
    return buf;
}

char *mk_exname(char *basename, int e)
{
    static char buf[SMALL_BUF_SIZE];
    char *p = basename, *r;
    if ((r = strrchr(p, '.')) == NULL)
        r = strend(p);
    check_buf(r - p + strlen(r) + 10, SMALL_BUF_SIZE);
    strncpy(buf, p, (unsigned) (r - p));
    sprintf(buf + (r - p), "%+i", e);
    strcat(buf, r);
    return buf;
}

internalfontnumber tfmoffm(fmentryptr fm_pt)
{
    return ((fm_entry *) fm_pt)->tfm_num;
}

void checkexpandtfm(strnumber s, integer e)
{
    if (e == 0)
        return;
    kpse_find_tfm(mk_exname(makecstring(s), e)); /* to create MM instance if needed */
}

static fm_entry *mk_ex_fm(internalfontnumber f, fm_entry * fm_e, int ex)
{
    fm_entry *fm;
    fm = new_fm_entry();
    fm->flags = fm_e->flags;
    fm->encoding = fm_e->encoding;
    fm->type = fm_e->type;
    fm->slant = fm_e->slant;
    fm->extend = fm_e->extend;
    fm->tfm_name = xstrdup(makecstring(fontname[f]));
    fm->ff_name = xstrdup(fm_e->ff_name);
    fm->ff_objnum = pdfnewobjnum();
    fm->expansion = ex;
    fm->tfm_num = f;
    assert(strcmp(fm->tfm_name, nontfm) != 0);
    return fm;
}

/**********************************************************************/

/*
   Early check whether a font file exists. Used e. g. for replacing fonts
   of embedded PDF files: Without font file, the font within the embedded
   PDF-file is used. Search tree ff_tree is used in 1st instance, as it
   may be faster than the kpse_find_file(), and kpse_find_file() is called
   only once per font file name + expansion parameter. This might help
   keeping speed, if many PDF pages with same fonts are to be embedded.

   The ff_tree contains only font files, which are actually needed,
   so this tree typically is much smaller than the tfm_tree or ps_tree.
*/

ff_entry *check_ff_exist(fm_entry * fm)
{
    ff_entry *ff;
    ff_entry tmp;
    char *ex_ffname;

    assert(fm->ff_name != NULL);
    tmp.ff_name = fm->ff_name;
    tmp.expansion = fm->expansion;
    ff = (ff_entry *) avl_find(ff_tree, &tmp);
    if (ff == NULL) {                /* not yet in database */
        ff = new_ff_entry();
        ff->ff_name = xstrdup(fm->ff_name);
        ff->expansion = fm->expansion;
        if (is_truetype(fm))
            ff->ff_path =
                kpse_find_file(fm->ff_name, kpse_truetype_format, 0);
        else {
            if (fm->expansion != 0) {
                /* first try MM instance, e. g. cmr10+20.pfb */
                ex_ffname = mk_exname(fm->ff_name, fm->expansion);
                ff->ff_path =
                    kpse_find_file(ex_ffname, kpse_type1_format, 0);
            }
            if (ff->ff_path != NULL)
                ff->ismm = 1;
            else
                /* try raw ff_name */
                ff->ff_path =
                    kpse_find_file(fm->ff_name, kpse_type1_format, 0);
        }
        assert(avl_probe(ff_tree, ff) != NULL);
    }
    return ff;
}

/**********************************************************************/

/* Lookup fontmap for /BaseFont entries of embedded PDF-files */

fm_entry *lookup_fontmap(char *bname)
{
    fm_entry *fm, *fmx;
    fm_entry tmp, tmpx;
    ff_entry *ff;
    char buf[SMALL_BUF_SIZE];
    char *a, *b, *c, *d, *e, *s;
    int i, sl, ex;
    if (tfm_tree == NULL || mapitems != NULL)
        fm_read_info();
    if (bname == NULL)
        return dummy_fm_entry();
    if (strlen(bname) >= SMALL_BUF_SIZE)
        pdftex_fail("Font name too long: `%s'", bname);
    strcpy(buf, bname);         /* keep bname untouched for later */
    s = buf; 
    if (strlen(buf) > 7) {        /* check for subsetted name tag */
        for (i = 0; i < 6; i++, s++)
            if (*s < 'A' || *s > 'Z')
                break;
        if (i == 6 && *s == '+')
            s++;                /* if name tag found, skip behind it */
        else
            s = buf;
    }

    /*
       Scan -Slant_<slant> and -Extend_<extend> font name extensions;
       three valid formats:
       <fontname>-Slant_<slant>
       <fontname>-Slant_<slant>-Extend_<extend>
       <fontname>-Extend_<extend>
       Slant entry must come _before_ Extend entry
     */

    tmp.slant = 0;
    tmp.extend = 0;
    if ((a = strstr(s, "-Slant_")) != NULL) {
        b = a + strlen("-Slant_");
        sl = (int) strtol(b, &e, 10);
        if ((e != b) && (e == strend(b))) {
            tmp.slant = sl;
            *a = 0;                /* bname string ends before "-Slant_" */
        } else {
            if (e != b) {        /* only if <slant> is valid number */
                if ((c = strstr(e, "-Extend_")) != NULL) {
                    d = c + strlen("-Extend_");
                    ex = (int) strtol(d, &e, 10);
                    if ((e != d) && (e == strend(d))) {
                        tmp.slant = sl;
                        tmp.extend = ex;
                        *a = 0;        /* bname string ends before "-Slant_" */
                    }
                }
            }
        }
    } else {
        if ((a = strstr(s, "-Extend_")) != NULL) {
            b = a + strlen("-Extend_");
            ex = (int) strtol(b, &e, 10);
            if ((e != b) && (e == strend(b))) {
                tmp.extend = ex;
                *a = 0;                /* bname string ends before "-Extend_" */
            }
        }
    }
    tmp.ps_name = s;
    fm = (fm_entry *) avl_find(ps_tree, &tmp);
    if (fm != NULL) {
        if (is_basefont(fm) || is_noparsing(fm) || !is_included(fm))
            return dummy_fm_entry();
        ff = check_ff_exist(fm);
        if (ff->ff_path == NULL)    /* if no font file, use embedded font */
            return dummy_fm_entry();
        if (fm->tfm_num == getnullfont()) {
            if (fm->tfm_name == nontfm)
                fm->tfm_num = newnullfont();
            else
                fm->tfm_num = gettfmnum(maketexstring(fm->tfm_name));
        }
        i = fm->tfm_num;
        if (pdffontmap[i] == 0)
            pdffontmap[i] = (fmentryptr) fm;
        if (fm->ff_objnum == 0 && is_included(fm))
            fm->ff_objnum = pdfnewobjnum();
        if (!fontused[i])
            pdfinitfont(i);
        return fm;
    }
#ifdef AUTO_MAKE_EXT_FONT
/**********************************************************************/
/*
   The following code snipplet handles fonts with "Slant" and "Extend"
   name extensions in embedded PDF files, which don't yet have an
   fm_entry. If such a font is found (e. g. CMR10-Extend_1020), and no
   fm_entry for this is found in the ps_tree (e. g. ps_name = "CMR10",
   extend = 1020), and if an unextended base font (e. g. CMR10) is found,
   a new <nontfm> fm_entry is created and put into the ps_tree. Then
   the lookup_fontmap() function is (recursively) called again, which
   then should find the new fm_entry. The same can be done manually by
   a map entry e. g.:

   \pdfmapline{+<nontfm> CMR10 "1.02 ExtendFont" <cmr10.pfb}

   This would also match the embedded font CMR10-Extend_1020, and replace
   it by an extended copy of cmr10.pfb. -- But not by an expanded version;
   no MM files (e.g. cmr10+20.pfb) would be used.
*/

    tmpx.ps_name = s;
    tmpx.slant = 0;
    tmpx.extend = 0;
    fm = (fm_entry *) avl_find(ps_tree, &tmpx);
    if (fm != NULL) {
        if (is_truetype(fm) || is_basefont(fm) || 
            is_noparsing(fm) || !is_included(fm))
            return dummy_fm_entry();
        ff = check_ff_exist(fm);
        if (ff->ff_path == NULL)
            return dummy_fm_entry();
        fmx = new_fm_entry();
        fmx->flags = fm->flags;
        fmx->encoding = fm->encoding;
        fmx->type = fm->type;
        fmx->slant = tmp.slant;
        fmx->extend = tmp.extend;
        fmx->expansion = 0;        /* no MM fonts used in this mode */
        fmx->tfm_name = nontfm;
        fmx->ps_name = xstrdup(s);
        fmx->ff_name = xstrdup(fm->ff_name);
        assert(avl_do_entry(fmx, DUPIGNORE) == 0);
        assert((fm = lookup_fontmap(bname)) != NULL);        /* new try */
        return fm;
    }
/**********************************************************************/
#endif
    return dummy_fm_entry();
}

static void init_fm(fm_entry * fm, internalfontnumber f)
{
    if (fm->fd_objnum == 0)
        fm->fd_objnum = pdfnewobjnum();
    if (fm->ff_objnum == 0 && is_included(fm))
        fm->ff_objnum = pdfnewobjnum();
    if (fm->tfm_num == getnullfont())
        fm->tfm_num = f;
}

fmentryptr fmlookup(internalfontnumber f)
{
    char *tfm, *p;
    fm_entry *fm, *exfm;
    fm_entry tmp;
    int e;
    if (tfm_tree == NULL || mapitems != NULL)
        fm_read_info();
    tfm = makecstring(fontname[f]);
    assert(strcmp(tfm, nontfm) != 0);

    /* Look up for full <tfmname>[+-]<expand> with matching expansion */

    e = pdffontexpandratio[f];
    tmp.tfm_name = tfm;
    tmp.expansion = e;
    fm = (fm_entry *) avl_find(tfm_tree, &tmp);
    if (fm != NULL) {
        init_fm(fm, f);
        return (fmentryptr) fm;
    }
    if (e == 0)                        /* not even basefont found */
        return (fmentryptr) dummy_fm_entry();

    /* Look up for basefont tfm (unexpanded) to build expanded version */

    tfm = mk_basename(tfm);
    tmp.tfm_name = tfm;
    tmp.expansion = 0;
    fm = (fm_entry *) avl_find(tfm_tree, &tmp);
    if (fm != NULL) {
        exfm = mk_ex_fm(f, fm, e);
        init_fm(exfm, f);
        assert(avl_do_entry(exfm, DUPIGNORE) == 0);
        return (fmentryptr) exfm;
    }
    return (fmentryptr) dummy_fm_entry();
}

/**********************************************************************/
/* cleaning up... */

static void destroy_fm_entry_tfm(void *pa, void *pb)
{
    fm_entry *fm;
    fm = (fm_entry *) pa;
    if (!has_pslink(fm))
        delete_fm_entry(fm);
    else
        unset_tfmlink(fm);
}

static void destroy_fm_entry_ps(void *pa, void *pb)
{
    fm_entry *fm;
    fm = (fm_entry *) pa;
    if (!has_tfmlink(fm))
        delete_fm_entry(fm);
    else
        unset_pslink(fm);
}

static void destroy_ff_entry(void *pa, void *pb)
{
    ff_entry *ff;
    ff = (ff_entry *) pa;
    delete_ff_entry(ff);
}

void fm_free(void)
{
    if (tfm_tree != NULL)
        avl_destroy(tfm_tree, destroy_fm_entry_tfm);
    if (ps_tree != NULL)
        avl_destroy(ps_tree, destroy_fm_entry_ps);
    if (ff_tree != NULL)
        avl_destroy(ff_tree, destroy_ff_entry);
}

/**********************************************************************/

/*
Add mapfile name or mapline contents to the linked list "mapitems". Items
not beginning with [+-=] flush list with pending items. Leading blanks
and blanks immediately following [+-=] are ignored.
*/

char *add_map_item(char *s, int type)
{
    char *p;
    int l;			/* length of map item (without [+-=]) */
    mapitem *tmp;
    int mode;
    for (; *s == ' '; s++);	/* ignore leading blanks */
    switch (*s) {
    case '+':			/* +mapfile.map, +mapline */
	mode = DUPIGNORE;	/* insert entry, if it is not duplicate */
	s++;
	break;
    case '=':			/* =mapfile.map, =mapline */
	mode = REPLACE;		/* try to replace earlier entry */
	s++;
	break;
    case '-':			/* -mapfile.map, -mapline */
	mode = DELETE;		/* try to delete entry */
	s++;
	break;
    default:
	mode = DUPIGNORE;	/* also flush pending list */
	while (mapitems != NULL) {
	    tmp = mapitems;
	    mapitems = mapitems->next;
	    xfree(tmp->line);
	    xfree(tmp);
	}
    }
    for (; *s == ' '; s++);	/* ignore blanks after [+-=] */
    p = s;			/* map item starts here */
    switch (type) {		/* find end of map item */
    case MAPFILE:
	for (; *p != 0 && *p != ' ' && *p != 10; p++);
	break;
    case MAPLINE:		/* blanks allowed */
	for (; *p != 0 && *p != 10; p++);
	break;
    default:
	assert(0);
    }
    l = p - s;
    if (l > 0) {		/* only if real item to add */
	tmp = xtalloc(1, mapitem);
	if (mapitems == NULL)
	    mapitems = tmp;	/* start new list */
	else
	    miptr->next = tmp;
	miptr = tmp;
	miptr->mode = mode;
	miptr->type = type;
	miptr->line = xtalloc(l + 1, char);
	*(miptr->line) = 0;
	strncat(miptr->line, s, l);
	miptr->next = NULL;
    }
    return p;
}

void pdfmapfile(integer t)
{
    add_map_item(makecstring(tokenstostring(t)), MAPFILE);
}

void pdfmapline(integer t)
{
    add_map_item(makecstring(tokenstostring(t)), MAPLINE);
}

void pdfinitmapfile(string map_name)
{
    if (mapitems == NULL) {
        mapitems = xtalloc(1, mapitem);
        miptr = mapitems;
        miptr->mode = DUPIGNORE;
        miptr->type = MAPFILE;
        miptr->line = xstrdup(map_name);
        miptr->next = NULL;
    }
}

/**********************************************************************/

/* end of mapfile.c */
