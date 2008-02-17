/* 
Copyright (c) 2008 Jerome.Laurens AT u-bourgogne.fr
$Id$

pdfTeX is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
any later version.

pdfTeX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with pdftex; if not, see <http://www.gnu.org/licenses/>.

Important notice:
-----------------
This file is named "synctex.c", it may or may not have a header counterpart
depending on its use.  It aims to provide basic components useful for the
input/output synchronization technology for TeX.
The purpose of the implementation is threefold
- firstly, it defines a new input/output synchronization technology named
  "synchronize texnology", "SyncTeX" or "synctex"
- secondly, it defines the naming convention and format of the auxiliary file
  used by this technology
- thirdly, it defines the API of a controller and a controller, used in
  particular by the pdfTeX program to prepare synchronization, and hopefully
  other programs.

All these are up to a great extent de facto definitions, which means that they
are partly defined by the implementation itself.

This technology was first designed for pdfTeX, an extension of TeX managing the
pdf output file format, but it can certainly be adapted to other programs built
from TeX as long as the extensions do not break too much the core design.
Moreover, the synchronize texnology only relies on code concept and not
implementation details, so it can be ported to other TeX systems.  In order to
support SyncTeX, one can start reading the dedicated section in pdftex.web.

Other existing public synchronization technologies are defined by srcltx.sty -
also used by source specials - and pdfsync.sty.  Like them, the synchronize
texnology is meant to be shared by various text editors, viewers and TeX
engines.  A centralized reference and source of information is available on
CTAN, in directory support/synctex.

*/

#include "ptexlib.h"

#if defined(pdfTeX) || defined(__syncTeX__)

#  define SYNCTEX_DEBUG 0

/*  Here are all the local variables gathered in one "synchronization context"  */
static struct {
    FILE *file;                 /*  the foo.synctex I/O identifier  */
    char *name;                 /*  the real "foo.synctex" name  */
    char *root_name;            /*  in general jobname.tex  */
    /*  next concern the last sync record encountered  */
    halfword p;                 /*  the last synchronized node, must be set 
                                 *  before the recorder */
    void (*recorder) (halfword p);      /*  the recorder of the node above, the
                                         *  routine that knows how to record the 
                                         *  node to the .synctex file */
    integer h, v;               /*  the last sync record coordinates  */
    integer offset;             /*  the offset of the origin / the topleft of
                                 *  the page in both directions  */
} synctex_ctxt = {
NULL, NULL, NULL, 0, NULL, 0, 0, 0};

/*  SYNCTEX_VERSION is a version number at the top of the .synctex file
    It indicates the format of its contents.
*/
#  define SYNCTEX_VERSION 1

/*  the macros defined below do the same job than their almost eponym
 *  counterparts of *tex.web, the memory access is sometimes more direct
 *  because *tex.web won't share its own constants the main purpose is to
 *  maintain very few hook points into *tex.web in order both to ensure
 *  portability and not modifying to much the original code.  see texmfmem.h
 *  and *tex.web for details, the synctex_ prefix prevents name conflicts, it
 *  is some kind of namespace
*/
#  warning These structures MUST be kept in synchronization with the main program
/*  synctexoption is a global integer variable defined in *tex.web
 *  it is set to 1 by texmfmp.c if the command line has the '-synchronize=1'
 *  option.  */
#  define SYNCTEX_OPTIONS synctexoption
#  define SYNCTEX_DISABLED_MASK 0x80000000
/*  if the SYNCTEX_DISABLED_MASK bit of SYNCTEX_OPTIONS is set, the
 *  synchronization is definitely disabled.  */
#  define SYNCTEX_IGNORE_CLI_MASK 0x40000000
/*  if the SYNCTEX_IGNORE_CLI_MASK bit of SYNCTEX_OPTIONS is set, the option
 *  given from the command line is ignored.  */

/*  glue code: really define the main memory.  */
#  define MEM zmem
/*  glue code: synctexoffset is a global integer variable defined in *tex.web
 *  it is set to the offset where the primitive \synctex reads and writes its
 *  value.  */
#  define SYNCTEX_IS_ENABLED zeqtb[synctexoffset].cint
/*  if there were a mean to share the value of synctex_code between pdftex.web
 *  and this file, it would be great.  */

/*  synctex_dot_open ensures that the foo.synctex file is open.
 *  In case of problem, it definitely disables synchronization
 *  Now all the synchronization info is gathered in only one file.
 *  It is possible to split this info into as many different files as sheets
 *  plus 1 for the control but the overall benefits are not so clear.
 *      For example foo-i.synctex would contain input synchronization
 *      information for page i alone.
*/
static FILE *synctex_dot_open(void)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nwarning: Synchronize DEBUG: synctex_dot_open\n");
    fprintf(stdout, "\nwarning: SYNCTEX_IS_ENABLED=%i\n", SYNCTEX_IS_ENABLED);
    fprintf(stdout, "\nwarning: SYNCTEX_OPTIONS=%i\n", SYNCTEX_OPTIONS);
#  endif
    if (0 != (SYNCTEX_OPTIONS & SYNCTEX_DISABLED_MASK)) {
        return 0;               /*  synchronization is definitely disabled: do nothing  */
    }
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nwarning: Synchronize DEBUG: synctex_dot_open 1\n");
#  endif
    if (NULL == synctex_ctxt.file) {
        /*  this is the first time we are asked to open the file
           this part of code is executed only once:
           either synctex_ctxt.file is nonnegative or synchronization is
           definitely disabled. */
        static char *suffix = ".synctex";
        /*  jobname was set by the \jobname command on the *TeX side  */
        char *tmp = makecstring(jobname);
        /*  tmp is just a static buffer  we have to duplicate */
        char *the_jobname = xstrdup(tmp);
        check_buf(strlen(the_jobname) + strlen(suffix) + 1, MAX_CSTRING_LEN);
        strcat(the_jobname, suffix);
        synctex_ctxt.file = xfopen(the_jobname, FOPEN_W_MODE);
#  if SYNCTEX_DEBUG
        fprintf(stdout, "\nwarning: Synchronize DEBUG: synctex_dot_open 2\n");
#  endif
        if (NULL != synctex_ctxt.file) {
            /*  synctex_ctxt.name was NULL before, it now owns a copy of the_jobname */
            synctex_ctxt.name = xstrdup(the_jobname);
            /*  print the preamble, this is an UTF8 file  */
            fprintf(synctex_ctxt.file, "SyncTeX\nversion: %d\n",
                    SYNCTEX_VERSION);
            if (NULL != synctex_ctxt.root_name) {
                fprintf(synctex_ctxt.file, "i:1:%s\n", synctex_ctxt.root_name);
                xfree(synctex_ctxt.root_name);
                synctex_ctxt.root_name = NULL;
            }
#  if SYNCTEX_DEBUG
            fprintf(stdout,
                    "\nwarning: Synchronize DEBUG: synctex_dot_open 3-a\n");
#  endif
        } else {
            /*  no .synctex file available, so disable synchronization  */
            SYNCTEX_OPTIONS = SYNCTEX_DISABLED_MASK;
#  if SYNCTEX_DEBUG
            fprintf(stdout,
                    "\nwarning: Synchronize DEBUG: synctex_dot_open 3-b\n");
#  endif
        }
        xfree(the_jobname);
        the_jobname = NULL;
    }
    return synctex_ctxt.file;
}

/*  Each time TeX opens a file, it sends a syncstartinput message and enters
 *  this function.  Here, a new synchronization tag is created and stored in
 *  the synctex_tag_field of the TeX current input context.  Each synchronized
 *  TeX node will record this tag instead of the file name.  syncstartinput
 *  writes the mapping synctag <-> file name to the .synctex file.  A client
 *  will read the .synctex file and retrieve this mapping, it will be able to
 *  open the correct file just knowing its tag.  If the same file is read
 *  multiple times, it might be associated to different tags.  Synchronization
 *  controller, either in viewers, editors or standalone should be prepared to
 *  handle this situation and take the appropriate action of they want to
 *  optimize memory.  No two different files will have the same positive tag.
 *  It is not advisable to definitely store the file names here.  If the file
 *  names ever have to be stored, it should definitely be done at the TeX level
 *  just like src-specials do such that other components of the program can use
 *  it.  This function does not make any difference between the files, it
 *  treats the same way .tex, .aux, .sty ... files, even if many of them do not
 *  contain any material meant to be typeset.
*/
void synctexstartinput(void)
{
    static unsigned int synctex_tag_counter = 0;

#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nwarning: Synchronize DEBUG: synctexstartinput %i\n",
            synctex_tag_counter);
    fprintf(stdout, "\nwarning: SYNCTEX_IS_ENABLED=%i\n", SYNCTEX_IS_ENABLED);
    fprintf(stdout, "\nwarning: SYNCTEX_OPTIONS=%i\n", SYNCTEX_OPTIONS);
    fprintf(stdout, "\nwarning: SYNCTEX_DISABLED_MASK=%i\n",
            SYNCTEX_DISABLED_MASK);
#  endif

    if (0 != (SYNCTEX_OPTIONS & SYNCTEX_DISABLED_MASK)) {
        /*  this is where we disable synchronization -synchronization=-1  */
        return;
    }
    /*  synctex_tag_counter is a counter uniquely identifying the file actually
     *  open each time tex opens a new file, syncstartinput will increment this
     *  counter  */
    if (~synctex_tag_counter > 0) {
        ++synctex_tag_counter;
    } else {
        /*  we have reached the limit, subsequent files will be softly ignored
         *  this makes a lot of files... even in 32 bits  */
        curinput.synctextagfield = 0;
        return;
    }

    if (0 == (SYNCTEX_OPTIONS & SYNCTEX_IGNORE_CLI_MASK)) {
        /*  the command line options are not ignored  */
        SYNCTEX_IS_ENABLED = MAX(SYNCTEX_OPTIONS, SYNCTEX_IS_ENABLED);
        SYNCTEX_OPTIONS |= SYNCTEX_IGNORE_CLI_MASK;
        /*  the command line options will be ignored from now on.  every
         *  subsequent call of syncstartinput won't get there SYNCTEX_OPTIONS
         *  is now the list of option flags  */
    }

    curinput.synctextagfield = synctex_tag_counter;     /*  -> *TeX.web  */
    if (synctex_tag_counter == 1) {
        /*  this is the first file TeX ever opens, in general \jobname.tex we
         *  do not know yet if synchronization will ever be enabled so we have
         *  to store the file name, because we will need it later This is
         *  certainly not necessary due to \jobname  */
        synctex_ctxt.root_name = xstrdup(makecstring(curinput.namefield));
        return;
    }
    if ((NULL != synctex_ctxt.file)
        || ((SYNCTEX_IS_ENABLED && synctex_dot_open()) != 0)) {
        fprintf(synctex_ctxt.file, "i:%u:%s\n", curinput.synctextagfield,
                makecstring(curinput.namefield));
    }
    return;
}

/*  All the synctex... functions below have the smallest set of parameters.  It
 *  appears to be either the address of a node, or nothing at all.  Using zmem,
 *  which is the place where all the nodes are stored, one can retrieve every
 *  information about a node.  The other information is obtained through the
 *  global context variable.
*/

/*  Recording the "s:..." line.  In *tex.web, use synctex_sheet(pdf_output) at
 *  the very beginning of the ship_out procedure.
*/
void synctexsheet(integer pdf_output)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctexsheet\n");
#  endif
    if (0 != (SYNCTEX_OPTIONS & SYNCTEX_DISABLED_MASK)) {
        return;
    }
    /*  update the offsets, depending on the output mode
       dvi and pdf don't start from the same origin
       dvi starts at (1in,1in) from the top left corner
       pdf starts exactly from the top left corner */
    synctex_ctxt.offset = pdf_output ? 0 : 4736286;
    if ((synctex_ctxt.file != NULL)
        || ((SYNCTEX_IS_ENABLED && synctex_dot_open()) != 0)) {
        /*  tries to open the .synctex, useful if synchronization was enabled
         *  from the source file and not from the CLI  */
        if ((totalpages == 0) && (pdf_output == 0)) {
            fprintf(synctex_ctxt.file, ">:no pdf\n");
        }
        fprintf(synctex_ctxt.file, "s:%ld\n", (long int) totalpages + 1);
    }
}

#  define UNIT / 8192
/*  UNIT is the scale. TeX coordinates are very accurate and client won't need
 *  that, at leat in a first step.  1.0 <-> 2^16 = 65536. 
 *  The TeX unit is sp (scaled point) or pt/65536 which means that the scale
 *  factor to retrieve a bp unit (a postscript) is 72/72.27/65536 =
 *  1/4096/16.06 = 1/8192/8.03
 *  Here we use 1/8192 as scale factor, then we can limit ourselves to
 *  integers.
 *  IMPORTANT: We can say that the natural unit of .synctex files is 8192 sp.
 *  To retrieve the proper bp unit, we'll have to divide by 8.03.  To reduce
 *  rounding errors, we'll certainly have to add 0.5 for non negative integers
 *  and ±0.5 for negative integers.  This trick is mainly to gain speed and
 *  size. A binary file would be more appropriate in that respect, but I guess
 *  that some clients like auctex would not like it very much.  we cannot use
 *  "<<13" instead of "/8192" because the integers are signed and we do not
 *  want the sign bit to be propagated.  The origin of the coordinates is at
 *  the top left corner of the page.  For pdf mode, it is straightforward, but
 *  for dvi mode, we'll have to add the 1in offset in both directions.
*/

/*  WARNING:
        The 5 definitions below must be in sync with their eponym declarations in *tex.web
*/
#  define SYNCHRONIZATION_FIELD_SIZE 2
#  define BOX_NODE_SIZE (7+SYNCHRONIZATION_FIELD_SIZE)
/*  see: @d BOX_NODE_SIZE=...  */
#  define WIDTH_OFFSET 1
/*  see: @d WIDTH_OFFSET=...  */
#  define DEPTH_OFFSET 2
/*  see: @d DEPTH_OFFSET=...  */
#  define HEIGHT_OFFSET 3
/*  see: @d HEIGHT_OFFSET=...  */

/*  Now define the local version of width(##), height(##) and depth(##) macros
        These only depend on the macros above.  */
#  define SYNCTEX_WIDTH(NODE) MEM[NODE+WIDTH_OFFSET].cint
#  define SYNCTEX_DEPTH(NODE) MEM[NODE+DEPTH_OFFSET].cint
#  define SYNCTEX_HEIGHT(NODE) MEM[NODE+HEIGHT_OFFSET].cint

/*  The tag and the line are just the two last words of the node.  This is a
 *  very handy design but this is not strictly required by the concept.  If
 *  really necessary, one can define other storage rules.  */
#  define SYNCTEX_TAG(NODE) MEM[NODE+BOX_NODE_SIZE-2].cint
#  define SYNCTEX_LINE(NODE) MEM[NODE+BOX_NODE_SIZE-1].cint

/*  When an hlist ships out, it can contain many different kern nodes with
 *  exactly the same sync tag and line.  To reduce the size of the .synctex
 *  file, we only display a kern node sync info when either the sync tag or the
 *  line changes.  Also, we try ro reduce the distance between the chosen nodes
 *  in order to improve accuracy.  It means that we display information for
 *  consecutive nodes, as far as possible.  This tricky part uses a "recorder",
 *  which is the address of the routine that knows how to write the
 *  synchronization info to the .synctex file.  It also uses criteria to detect
 *  a change in the context, this is the macro SYNCTEX_CONTEXT_DID_CHANGE The
 *  SYNCTEX_IGNORE macro is used to detect unproperly initialized nodes.  See
 *  details in the implementation of the functions below.  */
#  define SYNCTEX_IGNORE(NODE) (0 != (SYNCTEX_OPTIONS & SYNCTEX_DISABLED_MASK) ) \
                                || (SYNCTEX_IS_ENABLED == 0) \
                                || (synctex_ctxt.file == 0)

/*  Recording a "h:..." line  */
void synctex_hlist_recorder(halfword p)
{
    fprintf(synctex_ctxt.file, "h:%u:%u(%i,%i,%i,%i)%i\n",
            SYNCTEX_TAG(p), SYNCTEX_LINE(p),
            (curh + synctex_ctxt.offset) UNIT,
            (curv + SYNCTEX_DEPTH(p) + synctex_ctxt.offset) UNIT,
            SYNCTEX_WIDTH(p) UNIT, (SYNCTEX_HEIGHT(p) + SYNCTEX_DEPTH(p)) UNIT,
            SYNCTEX_DEPTH(p) UNIT);
}

/*  This message is sent when an hlist will be shipped out, more precisely at
 *  the beginning of the hlist_out procedure in *TeX.web.  It will be balanced
 *  by a synctex_tsilh, sent at the end of the hlist_out procedure.  p is the
 *  address of the hlist We assume that p is really an hlist node! */
void synctexhlist(halfword p)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctexhlist\n");
#  endif
    if (SYNCTEX_IGNORE(p)) {
        return;
    }
    synctex_ctxt.p = 0;         /*  reset  */
    synctex_ctxt.recorder = NULL;       /*  reset  */
    synctex_hlist_recorder(p);
}

/*  Recording a "e" line ending an hbox this message is sent whenever an hlist
 *  has been shipped out it is used to close the hlist nesting level. It is
 *  sent at the end of the hlist_out procedure in *TeX.web to balance a former
 *  synctex_hlist sent at the beginning of that procedure.    */
void synctextsilh(halfword p)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctextsilh\n");
#  endif
    if (SYNCTEX_IGNORE(p)) {
        return;
    }
    /*  is there a pending info to be recorded  */
    if (NULL != synctex_ctxt.recorder) {
        /*  synctex_ctxt node is set and must be recorded as last node  */
        (*synctex_ctxt.recorder) (synctex_ctxt.p);
        synctex_ctxt.p = 0;     /*  force next node to be recorded!  */
        synctex_ctxt.recorder = NULL;
    }
    fputs("e\n", synctex_ctxt.file);
}

#  undef SYNCTEX_IGNORE
#  define SYNCTEX_IGNORE(NODE) (0 != (SYNCTEX_OPTIONS & SYNCTEX_DISABLED_MASK) ) \
                                || (0 == SYNCTEX_IS_ENABLED) \
                                || (0 >= SYNCTEX_TAG(NODE)) \
                                || (0 >= SYNCTEX_LINE(NODE)) \
                                || (0 == synctex_ctxt.file)
#  undef SYNCTEX_TAG
#  undef SYNCTEX_LINE
/*  glue code: these only work with nodes of size MEDIUM_NODE_SIZE  */
#  define SMALL_NODE_SIZE 2
/*  see: @d small_node_size=2 {number of words to allocate for most node types}  */
#  define MEDIUM_NODE_SIZE (SMALL_NODE_SIZE+SYNCHRONIZATION_FIELD_SIZE)
#  define SYNCTEX_TAG(NODE) MEM[NODE+MEDIUM_NODE_SIZE-2].cint
#  define SYNCTEX_LINE(NODE) MEM[NODE+MEDIUM_NODE_SIZE-1].cint

/*  This macro will detect a change in the synchronization context.  As long as
 *  the synchronization context remains the same, there is no need to write
 *  synchronization info: it would not help more.  The synchronization context
 *  has changed when either the line number or the file tag has changed.  */
#  define SYNCTEX_CONTEXT_DID_CHANGE ((0 == synctex_ctxt.p)\
                                      || (SYNCTEX_TAG(p) != SYNCTEX_TAG(synctex_ctxt.p))\
                                      || (SYNCTEX_LINE(p) != SYNCTEX_LINE(synctex_ctxt.p)))

/*  Recording a "$:..." line  */
void synctex_math_recorder(halfword p)
{
    fprintf(synctex_ctxt.file, "$:%u:%u(%i,%i)\n",
            SYNCTEX_TAG(p), SYNCTEX_LINE(p),
            (synctex_ctxt.h + synctex_ctxt.offset) UNIT,
            (synctex_ctxt.v + synctex_ctxt.offset) UNIT);
}

/*  glue code this message is sent whenever an inline math node will ship out
        See: @ @<Output the non-|char_node| |p| for...  */
void synctexmath(halfword p)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctexmath\n");
#  endif
    if (SYNCTEX_IGNORE(p)) {
        return;
    }
    if ((synctex_ctxt.recorder != NULL) && SYNCTEX_CONTEXT_DID_CHANGE) {
        /*  the sync context did change  */
        (*synctex_ctxt.recorder) (synctex_ctxt.p);
    }
    synctex_ctxt.h = curh;
    synctex_ctxt.v = curv;
    synctex_ctxt.p = p;
    synctex_ctxt.recorder = NULL;       /*  no need to record once more  */
    synctex_math_recorder(p);   /*  always record  */
}

/*  Recording a "g:..." line  */
void synctex_glue_recorder(halfword p)
{
    fprintf(synctex_ctxt.file, "g:%u:%u(%i,%i)\n",
            SYNCTEX_TAG(p), SYNCTEX_LINE(p),
            (synctex_ctxt.h + synctex_ctxt.offset) UNIT,
            (synctex_ctxt.v + synctex_ctxt.offset) UNIT);
}

/*  this message is sent whenever a glue node ships out
        See: @ @<Output the non-|char_node| |p| for...    */
void synctexglue(halfword p)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctexglue\n");
#  endif
    if (SYNCTEX_IGNORE(p)) {
        return;
    }
    if (SYNCTEX_CONTEXT_DID_CHANGE) {
        /*  the sync context has changed  */
        if (synctex_ctxt.recorder != NULL) {
            /*  but was not yet recorded  */
            (*synctex_ctxt.recorder) (synctex_ctxt.p);
        }
        synctex_ctxt.h = curh;
        synctex_ctxt.v = curv;
        synctex_ctxt.p = p;
        synctex_ctxt.recorder = NULL;
        /*  always record when the context has just changed  */
        synctex_glue_recorder(p);
    } else {
        /*  just update the geometry and type (for future improvements)  */
        synctex_ctxt.h = curh;
        synctex_ctxt.v = curv;
        synctex_ctxt.p = p;
        synctex_ctxt.recorder = &synctex_glue_recorder;
    }
}

/*  Recording a "k:..." line  */
void synctex_kern_recorder(halfword p)
{
    fprintf(synctex_ctxt.file, "k:%u:%u(%i,%i)\n",
            SYNCTEX_TAG(p), SYNCTEX_LINE(p),
            (synctex_ctxt.h + synctex_ctxt.offset) UNIT,
            (synctex_ctxt.v + synctex_ctxt.offset) UNIT);
}

/*  this message is sent whenever a kern node or a glue node ships out
        See: @ @<Output the non-|char_node| |p| for...    */
void synctexkern(halfword p)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctexkern\n");
#  endif
    if (SYNCTEX_IGNORE(p)) {
        return;
    }
    if (SYNCTEX_CONTEXT_DID_CHANGE) {
        /*  the sync context has changed  */
        if (synctex_ctxt.recorder != NULL) {
            /*  but was not yet recorded  */
            (*synctex_ctxt.recorder) (synctex_ctxt.p);
        }
        synctex_ctxt.h = curh;
        synctex_ctxt.v = curv;
        synctex_ctxt.p = p;
        synctex_ctxt.recorder = NULL;
        /*  always record when the context has just changed  */
        synctex_kern_recorder(p);
    } else {
        /*  just update the geometry and type (for future improvements)  */
        synctex_ctxt.h = curh;
        synctex_ctxt.v = curv;
        synctex_ctxt.p = p;
        synctex_ctxt.recorder = &synctex_kern_recorder;
    }
}

/*  Free all memory used and close the file
    sent by utils.c  */
void synctex_terminate(void)
{
#  if SYNCTEX_DEBUG
    fprintf(stdout, "\nSynchronize DEBUG: synctex_terminate\n");
#  endif
    if (synctex_ctxt.file != NULL) {
        xfclose(synctex_ctxt.file, synctex_ctxt.name);
        xfree(synctex_ctxt.name);
    }
    xfree(synctex_ctxt.root_name);
}

#endif
