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

$Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/vfpacket.c#11 $
*/

#include "ptexlib.h"

typedef struct {
    internalfontnumber font;
    char *dataptr;
    int  len;
} packet_entry;

static packet_entry *packet_ptr, *packet_tab = 0;
static int packet_max;

typedef struct {
    char **data;
    int *len;
    internalfontnumber font;
}  vf_entry;

static vf_entry *vf_ptr, *vf_tab = 0;
static int vf_max;

static char *packet_data_ptr;

integer newvfpacket(internalfontnumber f)
{
    int i,
        n = fontec[f] - fontbc[f] + 1;
    entry_room(vf, 1, 256);
    vf_ptr->len = xtalloc(n, int);
    vf_ptr->data = xtalloc(n, char *);
    for (i = 0; i < n; i++) {
        vf_ptr->data[i] = 0;
        vf_ptr->len[i] = 0;
    }
    vf_ptr->font = f;
    return vf_ptr++ - vf_tab;
}

void storepacket(integer f, integer c, integer s)
{
    int l = strstart[s + 1] - strstart[s];
    vf_tab[vfpacketbase[f]].len[c - fontbc[f]] = l;
    vf_tab[vfpacketbase[f]].data[c - fontbc[f]] = xtalloc(l, char);
    memcpy((void *)vf_tab[vfpacketbase[f]].data[c - fontbc[f]], 
           (void *)(strpool + strstart[s]), (unsigned)l);
}

void pushpacketstate()
{
    entry_room(packet, 1, 256);
    packet_ptr->font = f;
    packet_ptr->dataptr = packet_data_ptr;
    packet_ptr->len = vfpacketlength;
    packet_ptr++;
}

void poppacketstate()
{
    if (packet_ptr == packet_tab)
        pdftex_fail("packet stack empty, impossible to pop");
    packet_ptr--;
    f = packet_ptr->font;
    packet_data_ptr = packet_ptr->dataptr;
    vfpacketlength = packet_ptr->len;
}

void startpacket(internalfontnumber f, integer c)
{
    packet_data_ptr = vf_tab[vfpacketbase[f]].data[c - fontbc[f]];
    vfpacketlength = vf_tab[vfpacketbase[f]].len[c - fontbc[f]];
}

eightbits packetbyte()
{
    vfpacketlength--;
    return *packet_data_ptr++;
}

void vf_free(void)
{
    vf_entry *v;
    int n;
    char **p;
    if (vf_tab != 0) {
        for (v = vf_tab; v < vf_ptr; v++) {
            xfree(v->len);
            n = fontec[v->font] - fontec[v->font] + 1;
            for (p = v->data; p - v->data < n ; p++)
                xfree(*p);
            xfree(v->data);
        }
        xfree(vf_tab);
    }
    xfree(packet_tab);
}
