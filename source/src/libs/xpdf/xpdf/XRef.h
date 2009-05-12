//========================================================================
//
// XRef.h
//
// Copyright 1996-2003 Glyph & Cog, LLC
//
//========================================================================

/* ------------------------------------------------------------------------
* Changed by Martin Schröder <martin@pdftex.org>
* $Id$
* Changelog:
* ------------------------------------------------------------------------
* r151 | ms | 2007-06-25 18:53:17 +0200 (Mo, 25 Jun 2007) | 3 lines
* 
* Merging xpdf 3.02 from HEAD into stable
* svn merge -r149:150 --dry-run svn+ssh://svn/srv/svn/repos/pdftex/trunk/source/src/libs/xpdf .
* 
* ------------------------------------------------------------------------
* r77 | ms | 2007-01-01 13:01:00 +0100 (Mo, 01 Jan 2007) | 2 lines
* 
* 1.40.0
* 
* ------------------------------------------------------------------------
* r38 | ms | 2005-08-21 14:00:00 +0200 (So, 21 Aug 2005) | 2 lines
* 
* 1.30.1
* r11 | ms | 2004-09-06 14:01:00 +0200 (Mo, 06 Sep 2004) | 2 lines
* 
* 1.20a
* 
* ------------------------------------------------------------------------
* r6 | ms | 2003-10-06 14:01:00 +0200 (Mo, 06 Okt 2003) | 2 lines
* 
* released v1.11b
* 
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

#ifndef XREF_H
#define XREF_H

#include <aconf.h>

#ifdef USE_GCC_PRAGMAS
#pragma interface
#endif

#include "gtypes.h"
#include "Object.h"

class Dict;
class Stream;
class Parser;

class ObjectStream {
public:

  // Create an object stream, using object number <objStrNum>,
  // generation 0.
  ObjectStream(XRef *xref, int objStrNumA);

  ~ObjectStream();

  // Return the object number of this object stream.
  int getObjStrNum() { return objStrNum; }

  // Get the <objIdx>th object from this stream, which should be
  // object number <objNum>, generation 0.
  Object *getObject(int objIdx, int objNum, Object *obj);

  int *getOffsets() { return offsets; }
  Guint getFirstOffset() { return firstOffset; }

private:

  int objStrNum;		// object number of the object stream
  int nObjects;			// number of objects in the stream
  Object *objs;			// the objects (length = nObjects)
  int *objNums;			// the object numbers (length = nObjects)
  int *offsets;			// the object offsets (length = nObjects)
  Guint firstOffset;
};


//------------------------------------------------------------------------
// XRef
//------------------------------------------------------------------------

enum XRefEntryType {
  xrefEntryFree,
  xrefEntryUncompressed,
  xrefEntryCompressed
};

struct XRefEntry {
  Guint offset;
  int gen;
  XRefEntryType type;
};

class XRef {
public:

  // Constructor.  Read xref table from stream.
  XRef(BaseStream *strA);

  // Destructor.
  ~XRef();

  // Is xref table valid?
  GBool isOk() { return ok; }

  // Get the error code (if isOk() returns false).
  int getErrorCode() { return errCode; }

  // Set the encryption parameters.
  void setEncryption(int permFlagsA, GBool ownerPasswordOkA,
		     Guchar *fileKeyA, int keyLengthA, int encVersionA,
		     CryptAlgorithm encAlgorithmA);

  // Is the file encrypted?
  GBool isEncrypted() { return encrypted; }

  // Check various permissions.
  GBool okToPrint(GBool ignoreOwnerPW = gFalse);
  GBool okToChange(GBool ignoreOwnerPW = gFalse);
  GBool okToCopy(GBool ignoreOwnerPW = gFalse);
  GBool okToAddNotes(GBool ignoreOwnerPW = gFalse);

  // Get catalog object.
  Object *getCatalog(Object *obj) { return fetch(rootNum, rootGen, obj); }

  // Fetch an indirect reference.
  Object *fetch(int num, int gen, Object *obj);

  // Return the document's Info dictionary (if any).
  Object *getDocInfo(Object *obj);
  Object *getDocInfoNF(Object *obj);

  // Return the number of objects in the xref table.
  int getNumObjects() { return size; }

  // Return the offset of the last xref table.
  Guint getLastXRefPos() { return lastXRefPos; }

  // Return the catalog object reference.
  int getRootNum() { return rootNum; }
  int getRootGen() { return rootGen; }

  // Get end position for a stream in a damaged file.
  // Returns false if unknown or file is not damaged.
  GBool getStreamEnd(Guint streamStart, Guint *streamEnd);

  // Direct access.
  int getSize() { return size; }
  XRefEntry *getEntry(int i) { return &entries[i]; }
  Object *getTrailerDict() { return &trailerDict; }
  ObjectStream *getObjStr() { return objStr; }

private:

  BaseStream *str;		// input stream
  Guint start;			// offset in file (to allow for garbage
				//   at beginning of file)
  XRefEntry *entries;		// xref entries
  int size;			// size of <entries> array
  int rootNum, rootGen;		// catalog dict
  GBool ok;			// true if xref table is valid
  int errCode;			// error code (if <ok> is false)
  Object trailerDict;		// trailer dictionary
  Guint lastXRefPos;		// offset of last xref table
  Guint *streamEnds;		// 'endstream' positions - only used in
				//   damaged files
  int streamEndsLen;		// number of valid entries in streamEnds
  ObjectStream *objStr;		// cached object stream
  GBool encrypted;		// true if file is encrypted
  int permFlags;		// permission bits
  GBool ownerPasswordOk;	// true if owner password is correct
  Guchar fileKey[16];		// file decryption key
  int keyLength;		// length of key, in bytes
  int encVersion;		// encryption version
  CryptAlgorithm encAlgorithm;	// encryption algorithm

  Guint getStartXref();
  GBool readXRef(Guint *pos);
  GBool readXRefTable(Parser *parser, Guint *pos);
  GBool readXRefStreamSection(Stream *xrefStr, int *w, int first, int n);
  GBool readXRefStream(Stream *xrefStr, Guint *pos);
  GBool constructXRef();
  Guint strToUnsigned(char *s);
};

#endif