/*
Copyright (c) 2006 Han The Thanh, <thanh@pdftex.org>

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
*/

#include "ptexlib.h"

static struct avl_table *glyph_unicode_tree = NULL;

static int comp_glyph_unicode_entry (const void *pa, const void *pb, void *p)
{
    return strcmp (((const glyph_unicode_entry *) pa)->name,
                   ((const glyph_unicode_entry *) pb)->name);
}

static glyph_unicode_entry *new_glyph_unicode_entry (void)
{
    glyph_unicode_entry *e;
    e = xtalloc (1, glyph_unicode_entry);
    e->name = NULL;
    e->code = -1;
    e->unicode_seq = NULL;
    return e;
}

static void destroy_glyph_unicode_entry (void *pa, void *pb)
{
    glyph_unicode_entry *e = (glyph_unicode_entry *) pa;
    xfree (e->name);
    if (e->code == -2) {
        assert (e->unicode_seq != NULL);
        xfree (e->unicode_seq);
    }
}

void glyph_unicode_free (void)
{
    if (glyph_unicode_tree != NULL)
        avl_destroy (glyph_unicode_tree, destroy_glyph_unicode_entry);
}

void deftounicode (strnumber glyph, strnumber unistr)
{
    char buf[SMALL_BUF_SIZE], *p;
    boolean valid_unistr;
    int i, l;
    glyph_unicode_entry *gu, t;
    void **aa;

    p = makecstring (glyph);
    assert (strlen (p) < SMALL_BUF_SIZE);
    strcpy (buf, p);            /* copy the result to buf before next call of makecstring() */
    p = makecstring (unistr);
    l = strlen (p);
    valid_unistr = true;
    if (l < 4 || l % 4 != 0)
        valid_unistr = false;
    else
        for (i = 0; i < l; i++) {
            if (!isxdigit (p[i])) {
                valid_unistr = false;
                break;
            }
        }
    if (!valid_unistr || strlen (buf) == 0 || strcmp (buf, notdef) == 0) {
        pdftex_warn ("ToUnicode: invalid parameter(s): `%s' => `%s'", buf, p);
        return;
    }
    if (glyph_unicode_tree == NULL) {
        glyph_unicode_tree =
            avl_create (comp_glyph_unicode_entry, NULL, &avl_xallocator);
        assert (glyph_unicode_tree != NULL);
    }
    t.name = buf;
    /* allow overriding existing entries */
    if ((gu =
         (glyph_unicode_entry *) avl_find (glyph_unicode_tree, &t)) != NULL) {
        if (gu->code == -2) {
            assert (gu->unicode_seq != NULL);
            xfree (gu->unicode_seq);
        }
    } else {                    /* make new entry */
        gu = new_glyph_unicode_entry ();
        gu->name = xstrdup (buf);
    }
    if (l > 4) {
        gu->code = -2;
        gu->unicode_seq = xstrdup (p);
    } else {
        i = sscanf (p, "%lX", &(gu->code));
        assert (i == 1);
    }
    aa = avl_probe (glyph_unicode_tree, gu);
    assert (aa != NULL);
}

static char *str_rstr (char *str, char *substr)
{
    char *p, *q;
    int i, l;

    l = strlen (substr);
    if (l > strlen (str))
        return NULL;
    p = strend (str) - 1;
    q = strend (substr) - 1;
    i = l;
    while (i > 0) {
        if (*p != *q)
            return NULL;
        p--;
        q--;
        i--;
    }
    return p + 1;
}

/* some simple translations to unify glyph name */
static boolean trans_glyph (char *target, char *name)
{
    char *p, *q;
    boolean b;
    assert (strlen (name) < SMALL_BUF_SIZE);
    *target = 0;                /* for use of strncat which appends '\0' */

    /* remove ".xxx" from the end of name */
    if ((q = strrchr (name, '.')) != NULL) {
        b = true;
        p = q + 1;
        while (*p) {
            if (!islower (*p) && !isupper (*p)) {
                b = false;
                break;
            }
            p++;
        }
        if (b) {
            strncat (target, name, q - name);
            return true;
        }
        return false;
    }

    /* remove "small", "oldstyle", "inferior" and "superior" from the end of name */
    if ((p = str_rstr (name, "small")) != NULL ||
        (p = str_rstr (name, "oldstyle")) != NULL ||
        (p = str_rstr (name, "inferior")) != NULL ||
        (p = str_rstr (name, "superior")) != NULL) {
        strncat (target, name, p - name);
        return true;
    }

    return false;
}

integer write_tounicode (char **glyph_names, char *name)
{
    char buf[SMALL_BUF_SIZE], *p;
    static char builtin_suffix[] = "-builtin";
    short range_size[257];
    glyph_unicode_entry gtab[257], t, *pg;
    integer objnum;
    int i, j;
    int bfchar_count, bfrange_count, subrange_count;
    assert (strlen (name) + strlen (builtin_suffix) < SMALL_BUF_SIZE);
    if (glyph_unicode_tree == NULL) {
        pdftex_warn ("no GlyphToUnicode entry has been inserted yet!");
        fixedgentounicode = 0;
        return 0;
    }
    strcpy (buf, name);
    if ((p = strrchr (buf, '.')) != NULL && strcmp (p, ".enc") == 0)
        *p = 0;                 /* strip ".enc" from encoding name */
    else
        strcat (buf, builtin_suffix);   /* ".enc" not present, this is a builtin
                                           encoding so the name is eg "cmr10-builtin" */
    objnum = pdfnewobjnum ();
    pdfbegindict (objnum, 0);
    pdfbeginstream ();
    pdf_printf ("%%!PS-Adobe-3.0 Resource-CMap\n"
                "%%%%DocumentNeededResources: ProcSet (CIDInit)\n"
                "%%%%IncludeResource: ProcSet (CIDInit)\n"
                "%%%%BeginResource: CMap (TeX-%s-0)\n"
                "%%%%Title: (TeX-%s-0 TeX %s 0)\n"
                "%%%%Version: 1.000\n"
                "%%%%EndComments\n"
                "/CIDInit /ProcSet findresource begin\n"
                "12 dict begin\n"
                "begincmap\n"
                "/CIDSystemInfo\n"
                "<< /Registry (TeX)\n"
                "/Ordering (%s)\n"
                "/Supplement 0\n"
                ">> def\n"
                "/CMapName /TeX-%s-0 def\n"
                "/CMapType 2 def\n"
                "1 begincodespacerange\n"
                "<00> <FF>\n" "endcodespacerange\n", buf, buf, buf, buf, buf);

    /* set gtab */
    for (i = 0; i <= 256; ++i)
        gtab[i].code = -1;
    for (i = 0; i < 256; ++i) {
        if (glyph_names[i] == NULL || glyph_names[i] == notdef)
            continue;
        if (sscanf (glyph_names[i], "uni%lX", &gtab[i].code) == 1)
            continue;
        t.name = glyph_names[i];
        pg = (glyph_unicode_entry *) avl_find (glyph_unicode_tree, &t);
        if (pg == NULL) {       /* not found, let's try some simple name translations */
            if (trans_glyph (buf, t.name)) {    /* something has stripped from buf,
                                                   try to look up again */
                t.name = buf;
                pg = (glyph_unicode_entry *) avl_find (glyph_unicode_tree, &t);
            }
        }
        if (pg != NULL) {
            gtab[i].code = pg->code;
            gtab[i].unicode_seq = pg->unicode_seq;
        }
    }

    /* set range_size */
    for (i = 0; i < 256;) {
        if (gtab[i].code == -2) {
            range_size[i] = 1;  /* single entry */
            i++;
        } else if (gtab[i].code == -1) {
            range_size[i] = 0;  /* no entry */
            i++;
        } else {                /* gtab[i].code >= 0 */
            j = i;
            while (i < 256 && gtab[i + 1].code >= 0 &&
                   gtab[i].code + 1 == gtab[i + 1].code)
                i++;
            /* at this point i is the last entry of the subrange */
            i++;                /* move i to the next entry */
            range_size[j] = i - j;
        }
    }

    /* calculate bfrange_count and bfchar_count */
    bfrange_count = 0;
    bfchar_count = 0;
    for (i = 0; i < 256;) {
        if (range_size[i] == 1) {
            bfchar_count++;
            i++;
        } else if (range_size[i] > 1) {
            bfrange_count++;
            i += range_size[i];
        } else
            i++;
    }

    /* write out bfrange */
    i = 0;
  write_bfrange:
    if (bfrange_count > 100)
        subrange_count = 100;
    else
        subrange_count = bfrange_count;
    bfrange_count -= subrange_count;
    pdf_printf ("%i beginbfrange\n", subrange_count);
    for (j = 0; j < subrange_count; j++) {
        while (range_size[i] <= 1 && i < 256)
            i++;
        assert (i < 256);
        pdf_printf ("<%02X> <%02X> <%04lX>\n", i, i + range_size[i] - 1,
                    gtab[i].code);
        i += range_size[i];
    }
    pdf_printf ("endbfrange\n");
    if (bfrange_count > 0)
        goto write_bfrange;

    /* write out bfchar */
    i = 0;
  write_bfchar:
    if (bfchar_count > 100)
        subrange_count = 100;
    else
        subrange_count = bfchar_count;
    bfchar_count -= subrange_count;
    pdf_printf ("%i beginbfchar\n", subrange_count);
    for (j = 0; j < subrange_count; j++) {
        while (i < 256) {
            if (range_size[i] > 1)
                i += range_size[i];
            else if (range_size[i] == 0)
                i++;
            else                /* range_size[i] == 1 */
                break;
        }
        assert (i < 256 && gtab[i].code != -1);
        if (gtab[i].code == -2) {
            assert (gtab[i].unicode_seq != NULL);
            pdf_printf ("<%02X> <%s>\n", i, gtab[i].unicode_seq);
        } else
            pdf_printf ("<%02X> <%04lX>\n", i, gtab[i].code);
        i++;
    }
    pdf_printf ("endbfchar\n");
    if (bfchar_count > 0)
        goto write_bfchar;

    pdf_printf ("endcmap\n"
                "CMapName currentdict /CMap defineresource pop\n"
                "end\n" "end\n" "%%%%EndResource\n" "%%%%EOF\n");
    pdfendstream ();
    return objnum;
}
