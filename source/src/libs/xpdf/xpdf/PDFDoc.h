//========================================================================
//
// PDFDoc.h
//
// Copyright 1996-2003 Glyph & Cog, LLC
//
//========================================================================

/* ------------------------------------------------------------------------
* Changed by Martin Schröder <martin@pdftex.org>
* $Id$
* Changelog:
* ------------------------------------------------------------------------
* r224 | oneiros | 2007-08-08 16:18:49 +0200 (Mi, 08 Aug 2007) | 2 lines
* 
* Clean up our use of xpdf more: remove OutputDev, Outline and SecurityHandler
* 
* ------------------------------------------------------------------------
* r150 | ms | 2007-06-25 18:27:16 +0200 (Mo, 25 Jun 2007) | 3 lines
* 
* Merging xpdf 3.02 into HEAD
* svn merge -r147:148 svn+ssh://svn/srv/svn/repos/pdftex/vendor/xpdf/current .
* 
* ------------------------------------------------------------------------
* r52 | ms | 2006-02-16 14:00:00 +0100 (Do, 16 Feb 2006) | 2 lines
* 
* 1.40.0-alpha-20051205
* 
* ------------------------------------------------------------------------
* r10 | ms | 2004-09-06 14:00:00 +0200 (Mo, 06 Sep 2004) | 1 line
* 
* 1.20
* ------------------------------------------------------------------------
* r4 | ms | 2003-10-05 14:00:00 +0200 (So, 05 Okt 2003) | 2 lines
* 
* Moved sources to src
* 
* ------------------------------------------------------------------------
* r1 | ms | 2003-08-02 14:00:00 +0200 (Sa, 02 Aug 2003) | 1 line
* 
* 1.11a
* ------------------------------------------------------------------------ */

#ifndef PDFDOC_H
#define PDFDOC_H

#include <aconf.h>

#ifdef USE_GCC_PRAGMAS
#pragma interface
#endif

#include <stdio.h>
#include "XRef.h"
#include "Catalog.h"
#include "Page.h"

class GString;
class BaseStream;
class OutputDev;
class Links;
class LinkAction;
class LinkDest;
#ifndef DISABLE_OUTLINE
class Outline;
#endif

//------------------------------------------------------------------------
// PDFDoc
//------------------------------------------------------------------------

class PDFDoc {
public:

  PDFDoc(GString *fileNameA, GString *ownerPassword = NULL,
	 GString *userPassword = NULL, void *guiDataA = NULL);
#ifdef WIN32
  PDFDoc(wchar_t *fileNameA, int fileNameLen, GString *ownerPassword = NULL,
	 GString *userPassword = NULL, void *guiDataA = NULL);
#endif
  PDFDoc(BaseStream *strA, GString *ownerPassword = NULL,
	 GString *userPassword = NULL, void *guiDataA = NULL);
  ~PDFDoc();

  // Was PDF document successfully opened?
  GBool isOk() { return ok; }

  // Get the error code (if isOk() returns false).
  int getErrorCode() { return errCode; }

  // Get file name.
  GString *getFileName() { return fileName; }

  // Get the xref table.
  XRef *getXRef() { return xref; }

  // Get catalog.
  Catalog *getCatalog() { return catalog; }

  // Get base stream.
  BaseStream *getBaseStream() { return str; }

  // Get page parameters.
  double getPageMediaWidth(int page)
    { return catalog->getPage(page)->getMediaWidth(); }
  double getPageMediaHeight(int page)
    { return catalog->getPage(page)->getMediaHeight(); }
  double getPageCropWidth(int page)
    { return catalog->getPage(page)->getCropWidth(); }
  double getPageCropHeight(int page)
    { return catalog->getPage(page)->getCropHeight(); }
  int getPageRotate(int page)
    { return catalog->getPage(page)->getRotate(); }

  // Get number of pages.
  int getNumPages() { return catalog->getNumPages(); }

  // Return the contents of the metadata stream, or NULL if there is
  // no metadata.
  GString *readMetadata() { return catalog->readMetadata(); }

  // Return the structure tree root object.
  Object *getStructTreeRoot() { return catalog->getStructTreeRoot(); }

  // Display a page.
  void displayPage(OutputDev *out, int page,
		   double hDPI, double vDPI, int rotate,
		   GBool useMediaBox, GBool crop, GBool printing,
		   GBool (*abortCheckCbk)(void *data) = NULL,
		   void *abortCheckCbkData = NULL);

#ifndef PDF_PARSER_ONLY
  // Display a range of pages.
  void displayPages(OutputDev *out, int firstPage, int lastPage,
		    double hDPI, double vDPI, int rotate,
		    GBool useMediaBox, GBool crop, GBool printing,
		    GBool (*abortCheckCbk)(void *data) = NULL,
		    void *abortCheckCbkData = NULL);

  // Display part of a page.
  void displayPageSlice(OutputDev *out, int page,
			double hDPI, double vDPI, int rotate,
			GBool useMediaBox, GBool crop, GBool printing,
			int sliceX, int sliceY, int sliceW, int sliceH,
			GBool (*abortCheckCbk)(void *data) = NULL,
			void *abortCheckCbkData = NULL);
#endif

  // Find a page, given its object ID.  Returns page number, or 0 if
  // not found.
  int findPage(int num, int gen) { return catalog->findPage(num, gen); }

  // Returns the links for the current page, transferring ownership to
  // the caller.
  Links *getLinks(int page);

  // Find a named destination.  Returns the link destination, or
  // NULL if <name> is not a destination.
  LinkDest *findDest(GString *name)
    { return catalog->findDest(name); }

#ifndef PDF_PARSER_ONLY
  // Process the links for a page.
  void processLinks(OutputDev *out, int page);
#endif

#ifndef DISABLE_OUTLINE
  // Return the outline object.
  Outline *getOutline() { return outline; }
#endif

  // Is the file encrypted?
  GBool isEncrypted() { return xref->isEncrypted(); }

  // Check various permissions.
  GBool okToPrint(GBool ignoreOwnerPW = gFalse)
    { return xref->okToPrint(ignoreOwnerPW); }
  GBool okToChange(GBool ignoreOwnerPW = gFalse)
    { return xref->okToChange(ignoreOwnerPW); }
  GBool okToCopy(GBool ignoreOwnerPW = gFalse)
    { return xref->okToCopy(ignoreOwnerPW); }
  GBool okToAddNotes(GBool ignoreOwnerPW = gFalse)
    { return xref->okToAddNotes(ignoreOwnerPW); }

  // Is this document linearized?
  GBool isLinearized();

  // Return the document's Info dictionary (if any).
  Object *getDocInfo(Object *obj) { return xref->getDocInfo(obj); }
  Object *getDocInfoNF(Object *obj) { return xref->getDocInfoNF(obj); }

  // Return the PDF version specified by the file.
  double getPDFVersion() { return pdfVersion; }

  // Save this file with another name.
  GBool saveAs(GString *name);

  // Return a pointer to the GUI (XPDFCore or WinPDFCore object).
  void *getGUIData() { return guiData; }


private:

  GBool setup(GString *ownerPassword, GString *userPassword);
  void checkHeader();
  GBool checkEncryption(GString *ownerPassword, GString *userPassword);

  GString *fileName;
  FILE *file;
  BaseStream *str;
  void *guiData;
  double pdfVersion;
  XRef *xref;
  Catalog *catalog;
  GBool ok;
  int errCode;
#ifndef DISABLE_OUTLINE
  Outline *outline;
#else
  void *dummy;
#endif
};

#endif
