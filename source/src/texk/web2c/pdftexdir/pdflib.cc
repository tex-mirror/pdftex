/*
Copyright (c) 2007 Martin Schröder <martin@pdftex.org, Han The Thanh, <thanh@pdftex.org>

This file is part of pdfTeX.

pdfTeX is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

pdfTeX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with pdfTeX; if not, write to the Free Software Foundation, Inc., 51
Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

$Id$
*/

#include "xpdf/config.h"
#include "xpdf/GlobalParams.h"
#include "pdflib.h"

void initGlobalParams()
{
    if (globalParams == NULL) {
        globalParams = new GlobalParams();
    }
}

void deleteGlobalParams()
{
    if (globalParams != NULL) {
        delete globalParams;
        globalParams = NULL;
    }
}

void globalParams_setErrQuiet(GBool errQuietA)
{
    globalParams->setErrQuiet(gFalse);
}

char *getPDFLibVersion()
{
    return xpdfVersion;
}

char *getPDFLibName()
{
    return "xpdf";
}
