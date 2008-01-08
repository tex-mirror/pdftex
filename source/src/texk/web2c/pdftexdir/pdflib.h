/*
Copyright (c) 2008 Martin Schröder <martin@pdftex.org, Han The Thanh, <thanh@pdftex.org>

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

This is a wrapper around xpdf (or any other pdf library) for use by pdfTeX,
specifying only the classes and members actually used by pdfTeX. All classes of
xpdf used by pdfTeX have been subclassed; these subclasses all have the prefix
p_.

*/

#ifndef PDFLIB_H
#  define PDFLIB_H
extern
#  ifdef __cplusplus
 "C"
#  endif
char *getPDFLibVersion();
extern
#  ifdef __cplusplus
 "C"
#  endif
char *getPDFLibName();
#  ifdef __cplusplus
#    include "xpdf/aconf.h"
#    include "goo/gfile.h"
#    include "goo/GString.h"
#    include "xpdf/Object.h"
#    include "xpdf/Array.h"
#    include "xpdf/Dict.h"
#    include "xpdf/Error.h"
#    include "xpdf/GfxFont.h"
#    include "xpdf/Link.h"
#    include "xpdf/PDFDoc.h"
#    include "xpdf/Stream.h"
#    include "xpdf/XRef.h"

extern void initGlobalParams();
extern void globalParams_setErrQuiet(GBool errQuietA);
extern void deleteGlobalParams();

class p_GString:private GString {
  public:
    p_GString(const char *sA):GString(sA) {
    };
    int getLength() {
        return GString::getLength();
    }
    char *getCString() {
        return GString::getCString();
    }
    char getChar(int i) {
        return GString::getChar(i);
    }
};

class p_Dict;
class p_Stream;
class p_XRef;

class p_Object:private Object {
  public:
    // Initialize an object.
    // Object *initBool(GBool boolnA)
    //   { initObj(objBool); booln = boolnA; return this; }
    // Object *initInt(int intgA)
    //   { initObj(objInt); intg = intgA; return this; }
    // Object *initReal(double realA)
    //   { initObj(objReal); real = realA; return this; }
    // Object *initString(GString *stringA)
    //   { initObj(objString); string = stringA; return this; }
    // Object *initName(char *nameA)
    //   { initObj(objName); name = copyString(nameA); return this; }
    p_Object * initNull() {
        return (p_Object *) Object::initNull();
    }
    Object *initArray(XRef * xref);
    p_Object *initDict(p_XRef * xref) {
        return (p_Object *) Object::initDict((XRef *) xref);
    }
    // Object *initDict(Dict *dictA);
    p_Object *initStream(p_Stream * streamA) {
        return (p_Object *) Object::initStream((Stream *) streamA);
    }
    // Object *initRef(int numA, int genA)
    //   { initObj(objRef); ref.num = numA; ref.gen = genA; return this; }
    // Object *initCmd(char *cmdA)
    //   { initObj(objCmd); cmd = copyString(cmdA); return this; }
    // Object *initError()
    //   { initObj(objError); return this; }
    // Object *initEOF()

    p_Object *fetch(p_XRef * xref, p_Object * obj) {
        return (p_Object *) Object::fetch((XRef *) xref, (Object *) obj);
    }

    void free() {
        Object::free();
    }

    // Type checking.
    // ObjType getType() { return type; }
    GBool isBool() {
        return Object::isBool();
    }
    GBool isInt() {
        return Object::isInt();
    }
    GBool isReal() {
        return Object::isReal();
    }
    GBool isNum() {
        return Object::isNum();
    }
    GBool isString() {
        return Object::isString();
    }
    GBool isName() {
        return Object::isName();
    }
    GBool isNull() {
        return Object::isNull();
    }
    GBool isArray() {
        return Object::isArray();
    }
    GBool isDict() {
        return Object::isDict();
    }
    GBool isStream() {
        return Object::isStream();
    }
    GBool isRef() {
        return Object::isRef();
    }
    // GBool isCmd() { return type == objCmd; }
    // GBool isError() { return type == objError; }
    // GBool isEOF() { return type == objEOF; }

    GBool isDict(char *dictType) {
        return Object::isDict(dictType);
    }
    GBool isStream(char *dictType) {
        return Object::isStream(dictType);
    }

    // Accessors.  NB: these assume object is of correct type.
    GBool getBool() {
        return Object::getBool();
    }
    int getInt() {
        return Object::getInt();
    }
    double getReal() {
        return Object::getReal();
    }
    double getNum() {
        return Object::getNum();
    }
    p_GString *getString() {
        return (p_GString *) Object::getString();
    }
    char *getName() {
        return Object::getName();
    }
    // Array *getArray() { return array; }
    p_Dict *getDict() {
        return (p_Dict *) Object::getDict();
    }
    p_Stream *getStream() {
        return (p_Stream *) Object::getStream();
    }
    Ref getRef() {
        return Object::getRef();
    }
    // int getRefNum() { return ref.num; }
    // int getRefGen() { return ref.gen; }
    // char *getCmd() { return cmd; }

    // Array accessors.
    int arrayGetLength() {
        return Object::arrayGetLength();
    }
    // void arrayAdd(Object *elem);
    p_Object *arrayGet(int i, p_Object * obj) {
        return (p_Object *) Object::arrayGet(i, (Object *) obj);
    }
    p_Object *arrayGetNF(int i, p_Object * obj) {
        return (p_Object *) Object::arrayGetNF(i, (Object *) obj);
    }

    // Dict accessors.
    int dictGetLength() {
        return Object::dictGetLength();
    }
    void dictAdd(char *key, p_Object * val) {
        Object::dictAdd(key, (Object *) val);
    }
    // GBool dictIs(char *dictType);
    p_Object *dictLookup(char *key, p_Object * obj) {
        return (p_Object *) Object::dictLookup(key, (Object *) obj);
    }
    p_Object *dictLookupNF(char *key, p_Object * obj) {
        return (p_Object *) Object::dictLookupNF(key, (Object *) obj);
    }
    char *dictGetKey(int i) {
        return Object::dictGetKey(i);
    }
    p_Object *dictGetVal(int i, p_Object * obj) {
        return (p_Object *) Object::dictGetVal(i, (Object *) obj);
    }
    p_Object *dictGetValNF(int i, p_Object * obj) {
        return (p_Object *) Object::dictGetValNF(i, (Object *) obj);
    }

    // Stream accessors.
    // GBool streamIs(char *dictType);
    // void streamReset();
    // void streamClose();
    // int streamGetChar();
    // int streamLookChar();
    // char *streamGetLine(char *buf, int size);
    // Guint streamGetPos();
    // void streamSetPos(Guint pos, int dir = 0);
    p_Dict *streamGetDict() {
        return (p_Dict *) Object::streamGetDict();
    }

    char *getTypeName() {
        return Object::getTypeName();
    }
};

class p_ObjectStream:private ObjectStream {
  public:
    p_ObjectStream(p_XRef * xref, int objStrNumA):ObjectStream((XRef *) xref,
                                                               objStrNumA) {
    };
    int *getOffsets() {
        return ObjectStream::getOffsets();
    }
    Guint getFirstOffset() {
        return ObjectStream::getFirstOffset();
    }
};

class p_XRef:private XRef {
  public:
#if __GNUC__ < 4 // gcc 3 is broken and needs this
    p_XRef();
#endif
    p_Object *getCatalog(p_Object * obj) {
        return (p_Object *) XRef::getCatalog((Object *) obj);
    }
    p_Object *fetch(int num, int gen, p_Object * obj) {
        return (p_Object *) XRef::fetch(num, gen, (Object *) obj);
    }
    int getSize() {
        return XRef::getSize();
    }
    XRefEntry *getEntry(int i) {
        return XRef::getEntry(i);
    }
    p_ObjectStream *getObjStr() {
        return (p_ObjectStream *) XRef::getObjStr();
    }
};

class p_Dict:private Dict {
  public:
    p_Dict(p_XRef * xrefA):Dict((XRef *) xrefA) {
    };
    int incRef() {
        return Dict::incRef();
    }
    int getLength() {
        return Dict::getLength();
    }
    p_Object *lookup(char *key, p_Object * obj) {
        return (p_Object *) Dict::lookup(key, (Object *) obj);
    }
    char *getKey(int i) {
        return Dict::getKey(i);
    }
    p_Object *getValNF(int i, p_Object * obj) {
        return (p_Object *) Dict::getValNF(i, (Object *) obj);
    }
};

class p_Stream:private Stream {
  public:
    virtual void reset() = 0;
    virtual int getChar() = 0;
    virtual p_Stream *getUndecodedStream() = 0;
    p_Object *Dict_lookup(char *key, p_Object * obj) {
        return (p_Object *) getDict()->lookup(key, (Object *) obj);
}};

class p_LinkDest:private LinkDest {
  public:
    p_LinkDest(Array * a):LinkDest(a) {
    };
    GBool isOk() {
        return LinkDest::isOk();
    }
    Ref getPageRef() {
        return LinkDest::getPageRef();
    }
};

class p_PDFRectangle:private PDFRectangle {
  public:
    PDFRectangle::x1;
    PDFRectangle::y1;
    PDFRectangle::x2;
    PDFRectangle::y2;
};

class p_Page:private Page {
  public:
    p_Page(p_XRef * xrefA, int numA, p_Dict * pageDict,
           PageAttrs * attrsA):Page((XRef *) xrefA, numA, (Dict *) pageDict,
                                    attrsA) {
    };
    p_PDFRectangle *getMediaBox() {
        return (p_PDFRectangle *) Page::getMediaBox();
    }
    p_PDFRectangle *getCropBox() {
        return (p_PDFRectangle *) Page::getCropBox();
    }
    p_PDFRectangle *getBleedBox() {
        return (p_PDFRectangle *) Page::getBleedBox();
    }
    p_PDFRectangle *getTrimBox() {
        return (p_PDFRectangle *) Page::getTrimBox();
    }
    p_PDFRectangle *getArtBox() {
        return (p_PDFRectangle *) Page::getArtBox();
    }
    int getRotate() {
        return Page::getRotate();
    }
    p_Dict *getGroup() {
        return (p_Dict *) Page::getGroup();
    }
    p_GString *getLastModified() {
        return (p_GString*) Page::getLastModified();
    }
    p_Stream *getMetadata() {
        return (p_Stream *) Page::getMetadata();
    }
    p_Dict *getPieceInfo() {
        return (p_Dict *) Page::getPieceInfo();
    }
    p_Dict *getSeparationInfo() {
        return (p_Dict *) Page::getSeparationInfo();
    }
    p_Dict *getResourceDict() {
        return (p_Dict *) Page::getResourceDict();
    }
    p_Object *getContents(p_Object * obj) {
        return (p_Object *) Page::getContents((Object *) obj);
    }
};

class p_Catalog:private Catalog {
  public:
    p_Catalog(p_XRef * xrefA):Catalog((XRef *) xrefA) {
    };
    int getNumPages() {
        return Catalog::getNumPages();
    }
    p_Page *getPage(int i) {
        return (p_Page *) Catalog::getPage(i);
    }
    int findPage(int num, int gen) {
        return Catalog::findPage(num, gen);
    }
};

class p_GfxFont:private GfxFont {
  public:
    static p_GfxFont *makeFont(p_XRef * xref, char *tagA, Ref idA,
                               p_Dict * fontDict) {
        return (p_GfxFont *) GfxFont::makeFont((XRef *) xref, tagA, idA,
                                               (Dict *) fontDict);
    }
    p_GfxFont(char *tagA, Ref idA, p_GString * nameA):GfxFont(tagA, idA,
                                                              (GString *)
                                                              nameA) {
    };
    virtual GBool isCIDFont() {
        return gFalse;
    }
};

class p_Gfx8BitFont:private Gfx8BitFont {
  public:
    p_Gfx8BitFont(p_XRef * xref, char *tagA, Ref idA, p_GString * nameA,
                  GfxFontType typeA,
                  p_Dict * fontDict):Gfx8BitFont((XRef *) xref, tagA, idA,
                                                 (GString *) nameA, typeA,
                                                 (Dict *) fontDict) {
    };
    char *getCharName(int code) {
        return Gfx8BitFont::getCharName(code);
    }
};

class p_PDFDoc:private PDFDoc {
  public:
    p_PDFDoc(p_GString * fileNameA):PDFDoc((GString *) fileNameA, NULL, NULL,
                                           NULL) {
    };
    GBool isOk() {
        return PDFDoc::isOk();
    }
    p_Catalog *getCatalog() {
        return (p_Catalog *) PDFDoc::getCatalog();
    }
    p_XRef *getXRef() {
        return (p_XRef *) PDFDoc::getXRef();
    }
    GBool okToPrint(GBool ignoreOwnerPW = gFalse) {
        return PDFDoc::okToPrint(ignoreOwnerPW);
    }
    p_LinkDest *findDest(p_GString * name) {
        return (p_LinkDest *) PDFDoc::findDest((GString *) name);
    }
    p_Object *getDocInfoNF(p_Object * obj) {
        return (p_Object *) PDFDoc::getDocInfo((Object *) obj);
    }
    double getPDFVersion() {
        return PDFDoc::getPDFVersion();
    }
};

#  endif                        /* __cplusplus */
#endif                          /* pdflib.h */
