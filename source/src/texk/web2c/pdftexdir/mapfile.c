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

$Id$
*/

#include <math.h>
#include "ptexlib.h"
#include <kpathsea/c-auto.h>
#include <kpathsea/c-memstr.h>

static const char perforce_id[] = 
    "$Id$";

#define FM_BUF_SIZE     1024
#define FM_MAX_INC       256
#define FMHT_SIZE_INC    683
#define FMHT_MAX_INC    1024
/* FMHT_SIZE_INC/FMHT_MAX_INC is maximal fill of hash table */
#define FMHT_THETA 0.61803398875  /* (sqrt(5) - 1) / 2 */

static FILE *fm_file;

#define fm_open()       \
    open_input (&fm_file, kpse_tex_ps_header_format, FOPEN_RBIN_MODE)
#define fm_close()      xfclose(fm_file, cur_file_name)
#define fm_getchar()    xgetc(fm_file)
#define fm_eof()        feof(fm_file)

fm_entry *fm_cur, *fm_ptr, *fm_tab = 0;
static int fm_max;
char *mapfiles = 0;
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

#define read_field(r, q, buf) do {                         \
    for (q = buf; *r != ' ' && *r != 10; *q++ = *r++);     \
    *q = 0;                                                \
    skip(r, ' ');                                          \
} while (0)

#define set_field(F) do {                                  \
    if (q > buf)                                           \
        fm_ptr->F = xstrdup(buf);                          \
    if (*r == 10)                                          \
        goto done;                                         \
} while (0)

/*
  Ordered hashing with linear probing

  The map file "pdftex.map" of TeX Live 7 has about 3000 entries.
  Function fm_read_info uses most of the time for comparing
  the current tfm file name with the old entries.
  Complexity: N(N-1)/2 = O(N^2)
  For better performance a data structure is needed with
  the following properties:
  * Efficient insertion.
  * Fast check for entries that are not stored. If an entry
    is already available, then pdfTeX will generate a warning,
    therefore this is not the normal case.
  Hashtables provide nearly O(1) for insertion and lookup.
  But unfortunately the number of entries is not known
  at start. The reorganization is implemented here by
  reinsertion of all old entries. Therefore the complexity
  remains O(N^2), but in practice the performance is much
  better because of the factor of the square term:
    N + N*N/chunk_size

  Constants and variables:

  fmht_tab: Array that contains pointers to the tfm file
    names.
  FMHT_MAX_INC: chunk size by which the hash table size
    is increased.
  FMHT_SIZE_INC: size of a chunk that may be filled by
    entries.
  FMHT_SIZE_INC = 256 means FMHT_MAX_INC = 386 that
    the maximal fill of the hash table is 2/3.
  fmht_max: current maximal size of the hash table
  fmht_size: maximal allowed number of entries in the
    hash table
  fmht_curr_size: number of current entries in the hash table

  Functions:

  int fmht_get_hash_pos(char *str):
    Parameter str: tfm font file name
    Return value:  position in hash table
    Description:
      The font file name string is divided into four
      byte parts that are combined by xor. Then the
      hashing function uses the multiplicative method
      for calculating the key for the hash table.

   void fmht_entry_room():
     Description:
       The hashtable is increased. The old entries are
       inserted in the larger new hashtable.

   boolean fmht_check_and_insert(char *str):
     Parameter str: tfm font file name
     Return value:  true if tfm file is inserted,
                    false if the name is already in the hashtable
     Description:
       The hash position is calculated and the entry
       inserted, if this position is free.
       Otherwise linear probing with ordering is used:
       * Linear probing is easy to implement and it ensures,
         that a free place will be found.
       * Ordering improves the performance for
         unsuccessful lookups. If an entry is found
         that is greater, then the search can be aborted.
         That means for inserting, that smaller entries
         drive out larger ones.

   void fmht_new_place(int pos):
     Parameter pos: entry in hashtable that have to move away
     Description:
       The current entry in the hashtable is moved
       to a free place.
*/

static int fmht_max = 0;
static int fmht_size = 0;
static int fmht_curr_size = 0;
static char **fmht_tab = 0;

static int fmht_get_hash_pos(char *str) {
    double a;
    int hash_code_upper = 0;
    int hash_code_lower = 0;
    int i;
    for (i=0; *str; i++, str++) {
        hash_code_upper ^= (*str << 8) + *++str;
        if (!*str || !*++str) {
            break;
        }
        hash_code_lower ^= (*str << 8) + *++str;
        if (!*str) {
            break;
        }
    }
    a = ((hash_code_upper << 16) ^ hash_code_lower) * FMHT_THETA;
    return fmht_max * (a - floor(a));
}

static void fmht_new_place(int pos) {
    char *str = fmht_tab[pos];
    int cmp;
    do {
        pos++;
        pos %= fmht_max;
        if (fmht_tab[pos] == 0) {
            fmht_tab[pos] = str;
            return;
        }
        cmp = strcmp(fmht_tab[pos], str);
        if (cmp > 0) {
            fmht_new_place(pos);
            fmht_tab[pos] = str;
            return;
        }
        if (cmp == 0) {
            return;
        }
    }
    while (1);
}

static boolean fmht_check_and_insert(char *str) {
    int pos = fmht_get_hash_pos(str);
    int cmp;
    do {
        if (fmht_tab[pos] == 0) {
            fmht_tab[pos] = str;
            return true;
        }
        cmp = strcmp(fmht_tab[pos], str);
        if (cmp > 0) {
            fmht_new_place(pos);
            fmht_tab[pos] = str;
            return true;
        }
        if (cmp == 0) {
            return false;
        }
        pos++;
        pos %= fmht_max;
    }
    while (1);
}

static void fmht_entry_room() {
    int i;
    if (fmht_tab == 0) {
        fmht_max = FMHT_MAX_INC;
        fmht_size = FMHT_SIZE_INC;
        fmht_tab = xtalloc(fmht_max, char*);
        for (i=0; i<fmht_max; i++) {
            fmht_tab[i] = 0;
        }
    }
    else {
        char **fmht_tab_old = fmht_tab;
        int fmht_max_old = fmht_max;

        fmht_max += FMHT_MAX_INC;
        fmht_size += FMHT_SIZE_INC;
        fmht_tab = xtalloc(fmht_max, char*);
        for (i=0; i<fmht_max; i++) {
            fmht_tab[i] = 0;
        }
        for (i=0; i<fmht_max_old; i++) {
            if (fmht_tab_old[i]) {
                fmht_check_and_insert(fmht_tab_old[i]);
            }
        }
        xfree(fmht_tab_old);
    }
}

static void fm_new_entry(void)
{
    entry_room(fm, 1, FM_MAX_INC);
    fm_ptr->tfm_name        = 0;
    fm_ptr->ps_name         = 0;
    fm_ptr->flags           = 0;
    fm_ptr->ff_name         = 0;
    fm_ptr->subset_tag      = 0;
    fm_ptr->type            = 0;
    fm_ptr->slant           = 0;
    fm_ptr->extend          = 0;
    fm_ptr->expansion       = 0;
    fm_ptr->ff_objnum       = 0;
    fm_ptr->fn_objnum       = 0;
    fm_ptr->fd_objnum       = 0;
    fm_ptr->charset         = 0;
    fm_ptr->encoding        = -1;
    fm_ptr->found           = false;
    fm_ptr->all_glyphs      = false;
    fm_ptr->tfm_num         = getnullfont();
}

void fm_read_info(void)
{
    float d;
    int i, a, b, c;
    char fm_line[FM_BUF_SIZE], buf[FM_BUF_SIZE];
    char *p, *q, *r, *s, *n = mapfiles;
    fmht_entry_room();
    for (;;) {
        if (fm_file == NULL) {
            if ((n == NULL) || (*n == NULL)) {
                xfree(mapfiles);
                cur_file_name = 0;
                if (fm_tab == 0)
                     fm_new_entry();
                xfree(fmht_tab);
                return;
            }
            s = strchr(n, '\n');
            *s = 0;
            set_cur_file_name(n);
            n = s + 1;
            if (!fm_open()) {
                pdftex_warn("cannot open font map file");
                continue;
            }
            cur_file_name = (char *)nameoffile + 1;
            tex_printf("{%s", cur_file_name);
        }
        if (fm_eof()) {
            fm_close();
            tex_printf("}");
            fm_file = 0;
            continue;
        }
        fm_new_entry();
        p = fm_line;
        do {
            c = fm_getchar();
            append_char_to_buf(c, p, fm_line, FM_BUF_SIZE);
        } while (c != 10);
        append_eol(p, fm_line, FM_BUF_SIZE);
        c = *fm_line;
        if (p - fm_line == 1 || c == '*' || c == '#' || c == ';' || c == '%')
            continue;
        r = fm_line;
        read_field(r, q, buf);
        if (strcmp(buf, nontfm) == 0)
            fm_ptr->tfm_name = xstrdup(nontfm);
        else {
            if (fmht_curr_size >= fmht_size) {
                /* increase hashtable if maximal fill is reached */
                fmht_entry_room();
            }
            fm_ptr->tfm_name = xstrdup(buf);
            if (fmht_check_and_insert(fm_ptr->tfm_name) == false) {
                    pdftex_warn("entry for `%s' already exists, duplicates ignored", buf);
                    goto bad_line;
                }
            fmht_curr_size++;
            if (*r == 10)
                goto done;
        }
        p = r;
        read_field(r, q, buf);
        if (*buf != '<' && *buf != '"')
            set_field(ps_name);
        else
            r = p; /* unget the field */
        if (isdigit(*r)) { /* font flags given */
            fm_ptr->flags = atoi(r);
            while (isdigit(*r))
                r++;
        }
        else
            fm_ptr->flags = 4; /* treat as Symbol font */
reswitch:
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
        case '"':
            r++;
parse_next:
            skip(r, ' ');
            if (sscanf(r, "%f", &d) > 0) {
                for (s = r; *s != ' ' && *s != '"' && *s != 10; s++);
                skip(s, ' ');
                if (strncmp(s, "SlantFont", strlen("SlantFont")) == 0) {
                    fm_ptr->slant = (integer)((d+0.0005)*1000);
                    r = s + strlen("SlantFont");
                }
                else if (strncmp(s, "ExtendFont", strlen("ExtendFont")) == 0) {
                    fm_ptr->extend = (integer)((d+0.0005)*1000);
                    r = s + strlen("ExtendFont");
                }
                else {
                    pdftex_warn("invalid entry for `%s': unknown name `%s' ignored", fm_ptr->tfm_name, s);
                    for (r = s; *r != ' ' && *r != '"' && *r != 10; r++);
                }
            }
            else
                for (; *r != ' ' && *r != '"' && *r != 10; r++);
            if (*r == '"') {
                r++;
                goto reswitch;
            }
            else if (*r == ' ')
                goto parse_next;
            else {
                pdftex_warn("invalid entry for `%s': unknown line format", fm_ptr->tfm_name);
                goto bad_line;
            }
        default:
            read_field(r, q, buf);
            if ((a == '<' && b == '[') ||
                (a != '!' && b == 0 && (strlen(buf) > 4) &&
                 !strcasecmp(strend(buf) - 4, ".enc"))) {
                fm_ptr->encoding = add_enc(buf);
                goto reswitch;
            }
            if (a == '<') {
                set_included(fm_ptr);
                if (b == 0)
                    set_subsetted(fm_ptr);
            }
            else if (a == '!')
                set_noparsing(fm_ptr);
            set_field(ff_name);
            goto reswitch;
        }
done:
        if (fm_ptr->ps_name != 0) {
            for (i = 0; i < 14; i++)
                if (!strcmp(basefont_names[i], fm_ptr->ps_name))
                    break;
            if (i < 14) {
                set_basefont(fm_ptr);
                unset_included(fm_ptr);
                unset_subsetted(fm_ptr);
                unset_truetype(fm_ptr);
                unset_fontfile(fm_ptr);
            }
            else if (fm_ptr->ff_name == 0) {
                pdftex_warn("invalid entry for `%s': font file missing", fm_ptr->tfm_name);
                goto bad_line;
            }
        }
        if (fm_fontfile(fm_ptr) != 0 && 
            strcasecmp(strend(fm_fontfile(fm_ptr)) - 4, ".ttf") == 0)
            set_truetype(fm_ptr);
        if ((fm_ptr->slant != 0 || fm_ptr->extend != 0) &&
            (!is_included(fm_ptr) || is_truetype(fm_ptr))) {
            pdftex_warn("invalid entry for `%s': SlantFont/ExtendFont can be used only with embedded T1 fonts", fm_ptr->tfm_name);
            goto bad_line;
        }
        if (is_truetype(fm_ptr) && (is_reencoded(fm_ptr)) &&
            !is_subsetted(fm_ptr)) {
            pdftex_warn("invalid entry for `%s': only subsetted TrueType font can be reencoded", fm_ptr->tfm_name);
            goto bad_line;
        }
        if (abs(fm_ptr->slant) >= 2000) {
            pdftex_warn("invalid entry for `%s': too big value of SlantFont (%.3g)",
                        fm_ptr->tfm_name, fm_ptr->slant/1000.0);
            goto bad_line;
        }
        if (abs(fm_ptr->extend) >= 2000) {
            pdftex_warn("invalid entry for `%s': too big value of ExtendFont (%.3g)",
                        fm_ptr->tfm_name, fm_ptr->extend/1000.0);
            goto bad_line;
        }
        fm_ptr++;
        continue;
bad_line:
        if (fm_ptr->tfm_name != nontfm)
            xfree(fm_ptr->tfm_name);
        xfree(fm_ptr->ps_name);
        xfree(fm_ptr->ff_name);
    }
}

char *mk_basename(char *exname)
{
    char buf[SMALL_BUF_SIZE], *p = exname, *q, *r;
    if ((r = strrchr(p, '.')) == 0)
        r = strend(p);
    for (q = r - 1; q > p && isdigit(*q); q--);
    if (q <= p || q == r - 1 || (*q != '+' && *q != '-'))
        pdftex_fail("invalid name of expanded font (%s)", p);
    strncpy(buf, p, (unsigned)(q - p));
    buf[q - p] = 0;
    strcat(buf, r);
    return xstrdup(buf);
}

char *mk_exname(char *basename, int e)
{
    char buf[SMALL_BUF_SIZE], *p = basename, *r;
    if ((r = strrchr(p, '.')) == 0)
        r = strend(p);
    strncpy(buf, p, (unsigned)(r - p));
    sprintf(buf + (r - p), "%+i", e);
    strcat(buf, r);
    return xstrdup(buf);
}

internalfontnumber tfmoffm(integer i)
{
    return fm_tab[i].tfm_num;
}

void checkextfm(strnumber s, integer e)
{
    char *p;
    if (e == 0)
        return;
    p = mk_exname(makecstring(s), e);
    kpse_find_tfm(p); /* to create MM instance if needed */
    xfree(p);
}

static fm_entry *mk_ex_fm(internalfontnumber f, int fm_index, int ex)
{
    fm_entry *e;
    fm_new_entry();
    e = fm_tab + fm_index;
    fm_ptr->subset_tag = 0;
    fm_ptr->flags = e->flags;
    fm_ptr->encoding = e->encoding;
    fm_ptr->type = e->type;
    fm_ptr->slant = e->slant;
    fm_ptr->extend = e->extend;
    fm_ptr->tfm_name = xstrdup(makecstring(fontname[f]));
    fm_ptr->ff_name = xstrdup(e->ff_name);
    fm_ptr->ff_objnum = pdfnewobjnum();
    fm_ptr->expansion = ex;
    fm_ptr->tfm_num = f;
    return fm_ptr++;
}

int lookup_fontmap(char *bname)
{
    fm_entry *p;
    char *s = bname;
    int i;
    if (fm_tab == 0)
        fm_read_info();
    if (bname == 0)
        return -1;
    if (strlen(s) > 7) { /* check for subsetted name tag */
        for (i = 0; i < 6; i++, s++)
            if (!(*s >= 'A' && *s <= 'Z'))
                break;
        if (i == 6 && *s == '+')
            bname = s + 1;
    }
    for (p = fm_tab; p < fm_ptr; p++)
        if (p->ps_name != 0 && strcmp(p->ps_name, bname) == 0) {
            if (is_basefont(p) || is_noparsing(p) || !is_included(p))
                return -1;
            if (p->tfm_num == getnullfont()) {
                if (p->tfm_name == nontfm)
                    p->tfm_num = newnullfont();
                else
                    p->tfm_num = gettfmnum(maketexstring(p->tfm_name));
            }
            i = p->tfm_num;
            if (pdffontmap[i] == -1)
                pdffontmap[i] = p - fm_tab;
            if (p->ff_objnum == 0 && is_included(p))
                p->ff_objnum = pdfnewobjnum();
            if (!fontused[i])
                pdfinitfont(i);
            return p - fm_tab;
        }
    return -1;
}

static boolean isdigitstr(char *s)
{
    for (;*s != 0; s++)
        if (!isdigit(*s))
            return false;
    return true;
}

static void init_fm(fm_entry *fm, internalfontnumber f)
{
    if (fm->fd_objnum == 0)
        fm->fd_objnum = pdfnewobjnum();
    if (fm->ff_objnum == 0 && is_included(fm))
        fm->ff_objnum = pdfnewobjnum();
    if (fm->tfm_num == getnullfont())
        fm->tfm_num = f;
}

integer fmlookup(internalfontnumber f)
{
    char *tfm, *p;
    fm_entry *fm, *exfm;
    int e, l;
    if (fm_tab == 0)
        fm_read_info();
    tfm = makecstring(fontname[f]);
    /* loop up for tfm_name */
    for (fm = fm_tab; fm < fm_ptr; fm++)
        if (fm->tfm_name != nontfm && strcmp(tfm, fm->tfm_name) == 0) {
            init_fm(fm, f);
            return fm - fm_tab;
        }
    /* expanded fonts; loop up for base tfm_name */
    if (pdffontexpandratio[f] != 0) {
        tfm = mk_basename(tfm);
        if ((e = getexpandfactor(f)) != 0)
            goto ex_font;
        for (fm = fm_tab; fm < fm_ptr; fm++)
            if (fm->tfm_name != nontfm && strcmp(tfm, fm->tfm_name) == 0) {
                init_fm(fm, f);
                return fm - fm_tab;
            }
    }
    return -2;
ex_font:
    l = strlen(tfm);
    /* look up for expanded fonts in reversed direction, as they are
     * appended to the end of fm_tab */
    for (fm = fm_ptr - 1; fm >= fm_tab; fm--)
        if (fm->tfm_name != nontfm && strncmp(tfm, fm->tfm_name, l) == 0) {
            p = fm->tfm_name + l;
            if (fm->expansion == e && (*p == '+' || *p == '-') &&
                isdigitstr(p + 1))
                return fm - fm_tab;
            else if (fm->expansion == 0 && *p == 0) {
                exfm = mk_ex_fm(f, fm - fm_tab, e);
                init_fm(exfm, f);
                return exfm - fm_tab;
            }
        }
    return -2;
}

void fix_ffname(fm_entry *fm, char *name)
{
    xfree(fm->ff_name);
    fm->ff_name = xstrdup(name);
    fm->found   = true;     /* avoid next searching for the same file */
}

void fm_free(void)
{
    fm_entry *fm;
    for (fm = fm_tab; fm < fm_ptr; fm++) {
        if (fm->tfm_name != nontfm)
            xfree(fm->tfm_name);
        xfree(fm->ps_name);
        xfree(fm->ff_name);
        xfree(fm->subset_tag);
        xfree(fm->charset);
    }
    xfree(fm_tab);
}
