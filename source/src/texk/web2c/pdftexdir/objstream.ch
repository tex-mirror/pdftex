%$Id: objstream.ch,v 1.269 2005/12/04 22:34:18 hahe Exp hahe $
%
% PDF-1.5 object streams patch
%
% Copyright (c) 2005 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
%
% This file is part of pdfTeX.
%
% pdfTeX is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% pdfTeX is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with pdfTeX; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
%
% $Id: //depot/Build/source.development/TeX/texk/web2c/pdftexdir/hz.ch#15 $
%
% new primitive: \pdfobjectstreams
%
%***********************************************************************

%***********************************************************************

@x 5773
@d pdf_int_pars=pdftex_first_integer_code + 20 {total number of \pdfTeX's integer parameters}
@y
@d pdf_objectstreams_code    = pdftex_first_integer_code + 20 {activate object streams}
@d pdf_int_pars=pdftex_first_integer_code + 21 {total number of \pdfTeX's integer parameters}
@z

%***********************************************************************

@x 5865
@d pdf_compress_level   == int_par(pdf_compress_level_code)
@y
@d pdf_compress_level   == int_par(pdf_compress_level_code)
@d pdf_objectstreams    == int_par(pdf_objectstreams_code)
@z

%***********************************************************************

@x 5968
pdf_compress_level_code:   print_esc("pdfcompresslevel");
@y
pdf_compress_level_code:   print_esc("pdfcompresslevel");
pdf_objectstreams_code:    print_esc("pdfobjectstreams");
@z

%***********************************************************************

@x 6134
primitive("pdfcompresslevel",assign_int,int_base+pdf_compress_level_code);@/
@!@:pdf_compress_level_}{\.{\\pdfcompresslevel} primitive@>
@y
primitive("pdfcompresslevel",assign_int,int_base+pdf_compress_level_code);@/
@!@:pdf_compress_level_}{\.{\\pdfcompresslevel} primitive@>
primitive("pdfobjectstreams",assign_int,int_base+pdf_objectstreams_code);@/
@!@:pdf_objectstreams_}{\.{\\pdfobjectstreams} primitive@>
@z

%***********************************************************************

@x 15123
pdf_compress_level := 9;
@y
pdf_compress_level := 9;
pdf_objectstreams := 0;
@z

%***********************************************************************
% this was a small bug from a previous patch.

@x 15289
    if s > sup_pdf_mem_size - pdf_mem_size then
@y
    if s > sup_pdf_mem_size - pdf_mem_ptr then
@z

%***********************************************************************

@x 15313
@!pdf_buf_size = 16384; {size of the PDF buffer}
@y
@!pdf_op_buf_size = 16384; {size of the PDF output buffer}
@!inf_pdf_os_buf_size = 1; {initial value of |pdf_os_buf_size|}
@!sup_pdf_os_buf_size = 5000000; {arbitrary upper hard limit of |pdf_os_buf_size|}
@!pdf_os_max_objs = 100; {maximum number of objects in object stream}
@z

%***********************************************************************
% this could be written much shorter, but gives problems after convert

@x 15331
@d pdf_room(#) == {make sure that there are at least |n| bytes free in PDF
buffer}
begin
    if pdf_buf_size < # then
        overflow("PDF output buffer", pdf_buf_size);
    if pdf_ptr + # > pdf_buf_size then
        pdf_flush;
end
@y
@d pdf_room(#) == {make sure that there are at least |n| bytes free in PDF buffer}
begin
    if pdf_os_mode and (# + pdf_ptr > pdf_buf_size) then
        pdf_os_get_os_buf(#)
    else if not pdf_os_mode and (# > pdf_buf_size) then
        overflow("PDF output buffer", pdf_op_buf_size)
    else if not pdf_os_mode and (# + pdf_ptr > pdf_buf_size) then
        pdf_flush;
end
@z

%***********************************************************************

@x 15340
@d pdf_out(#) == {do the same as |pdf_quick_out| and flush the PDF
buffer if necessary}
begin
    if pdf_ptr > pdf_buf_size then
        pdf_flush;
    pdf_quick_out(#);
end
@y
@d pdf_out(#) == {do the same as |pdf_quick_out| and flush the PDF
buffer if necessary}
begin
    pdf_room(1);
    pdf_quick_out(#);
end
@z

%***********************************************************************

@x 15350
@!pdf_buf: array[0..pdf_buf_size] of eight_bits; {the PDF buffer}
@!pdf_ptr: integer; {pointer to the first unused byte in the PDF buffer}
@y
@!pdf_buf: ^eight_bits; {pointer to the PDF output buffer or PDF object stream buffer}
@!pdf_buf_size: integer; {end of PDF output buffer or PDF object stream buffer}
@!pdf_ptr: integer; {pointer to the first unused byte in the PDF buffer or object stream buffer}
@!pdf_op_buf: ^eight_bits; {the PDF output buffer}
@!pdf_os_buf: ^eight_bits; {the PDF object stream buffer}
@!pdf_os_buf_size: integer; {current size of the PDF object stream buffer, grows dynamically}
@!pdf_os_objnum: ^integer; {array of object numbers within object stream}
@!pdf_os_objoff: ^integer; {array of object offsets within object stream}
@!pdf_os_objidx: pointer; {pointer into |pdf_os_objnum| and |pdf_os_objoff|}
@!pdf_op_ptr: integer; {store for PDF buffer |pdf_ptr| while inside object streams}
@!pdf_os_ptr: integer; {store for object stream |pdf_ptr| while outside object streams}
@!pdf_os_mode: boolean; {true if producing object stream}
@!pdf_os_enable: boolean; {true if object streams are globally enabled}
@!pdf_os_cur_objnum: integer; {number of current object stream object}
@z

%***********************************************************************

@x 15355
@!fixed_pdf_minor_version: integer; {fixed minor part of the pdf version}
@y
@!fixed_pdf_minor_version: integer; {fixed minor part of the pdf version}
@!fixed_pdf_objectstreams: integer; {fixed flag for activating PDF object streams}
@z

%***********************************************************************

@x 15366
@ @<Set init...@>=
pdf_buf[0] := "%";
pdf_buf[1] := "P";
pdf_buf[2] := "D";
pdf_buf[3] := "F";
pdf_buf[4] := "-";
pdf_buf[5] := "1";
pdf_buf[6] := ".";
pdf_buf[7] := "4";
pdf_buf[8] := pdf_new_line_char;
pdf_buf[9] := "%";
pdf_buf[10] := 208;
pdf_buf[11] := 212;
pdf_buf[12] := 197;
pdf_buf[13] := 216;
pdf_buf[14] := pdf_new_line_char;
pdf_ptr := 15;
pdf_gone := 0;
zip_write_state := no_zip;
pdf_minor_version_written := false;
fixed_pdfoutput_set := false;
fixed_gamma := 1000;
fixed_image_gamma := 2200;
fixed_image_hicolor := 1;
fixed_image_apply_gamma := 0;
@y
@ @<Set init...@>=
pdf_gone := 0;
pdf_os_mode := false;
pdf_ptr := 0;
pdf_op_ptr := 0;
pdf_os_ptr := 0;
pdf_os_cur_objnum := 0;
pdf_buf_size := pdf_op_buf_size;
pdf_os_buf_size := inf_pdf_os_buf_size;
pdf_buf := pdf_op_buf;
zip_write_state := no_zip;
pdf_minor_version_written := false;
fixed_pdfoutput_set := false;
@z

%***********************************************************************

@x 15420
        pdf_buf[7] := chr(ord("0") + fixed_pdf_minor_version);
        fixed_gamma             := fix_int(pdf_gamma, 0, 1000000);
        fixed_image_gamma       := fix_int(pdf_image_gamma, 0, 1000000);
        fixed_image_hicolor     := fix_int(pdf_image_hicolor, 0, 1);
        fixed_image_apply_gamma := fix_int(pdf_image_apply_gamma, 0, 1);
@y
        fixed_gamma             := fix_int(pdf_gamma, 0, 1000000);
        fixed_image_gamma       := fix_int(pdf_image_gamma, 0, 1000000);
        fixed_image_hicolor     := fix_int(pdf_image_hicolor, 0, 1);
        fixed_image_apply_gamma := fix_int(pdf_image_apply_gamma, 0, 1);
        fixed_pdf_objectstreams := fix_int(pdf_objectstreams, 0, 1);
        if (fixed_pdf_minor_version >= 5) and (fixed_pdf_objectstreams > 0) then
            pdf_os_enable := true
        else begin
            if fixed_pdf_objectstreams > 0 then begin
                pdf_warning("\pdfobjectstreams", "Can't be used with \pdfminorversion < 5. Disabled now.", true);
                fixed_pdf_objectstreams := 0;
            end;
            pdf_os_enable := false;
        end;
        ensure_pdf_open;
        pdf_print("%PDF-1.");
        pdf_print_int_ln(fixed_pdf_minor_version);
        pdf_print("%");
        pdf_out(208); {'P' + 128}
        pdf_out(212); {'T' + 128}
        pdf_out(197); {'E' + 128}
        pdf_out(216); {'X' + 128}
        pdf_print_nl;
@z

%***********************************************************************

@x 15454 also redundant ensure_pdf_open and check_pdfminorversion
@p procedure pdf_flush; {flush out the |pdf_buf|}
begin
    ensure_pdf_open;
    check_pdfminorversion;
    case zip_write_state of
        no_zip: if pdf_ptr > 0 then begin
            write_pdf(0, pdf_ptr - 1);
            pdf_gone := pdf_gone + pdf_ptr;
        end;
        zip_writing:
            write_zip(false);
        zip_finish: begin
            write_zip(true);
            zip_write_state := no_zip;
        end;
    end;
    pdf_ptr := 0;
end;
@y
@p procedure pdf_flush; {flush out the |pdf_buf|}
begin
    if not pdf_os_mode then begin
        case zip_write_state of
            no_zip: if pdf_ptr > 0 then begin
                write_pdf(0, pdf_ptr - 1);
                pdf_gone := pdf_gone + pdf_ptr;
            end;
            zip_writing:
                write_zip(false);
            zip_finish: begin
                write_zip(true);
                zip_write_state := no_zip;
            end;
        end;
        pdf_ptr := 0;
    end;
end;
@z

%***********************************************************************

@x 15456
    ensure_pdf_open;
@y
@z

%***********************************************************************

@x 15559
procedure remove_last_space;
@y
procedure pdf_os_get_os_buf(s: integer); {check that |s| bytes more
fit into |pdf_os_buf|; increase it if required}
var a: integer;
begin
    if s > sup_pdf_os_buf_size - pdf_ptr then
        overflow("PDF object stream buffer", pdf_os_buf_size);
    if pdf_ptr + s > pdf_os_buf_size then begin
        a := 0.2 * pdf_os_buf_size;
        if pdf_ptr + s > pdf_os_buf_size + a then
            pdf_os_buf_size := pdf_ptr + s
        else if pdf_os_buf_size < sup_pdf_os_buf_size - a then
            pdf_os_buf_size := pdf_os_buf_size + a
        else
            pdf_os_buf_size := sup_pdf_os_buf_size;
        pdf_os_buf := xrealloc_array(pdf_os_buf, eight_bits, pdf_os_buf_size);
        pdf_buf := pdf_os_buf;
        pdf_buf_size := pdf_os_buf_size;
    end;
end;

procedure remove_last_space;
@z

%***********************************************************************

@x 16096
|tab_entry|. Each entry contains four integer fields and represents an object
@y
|tab_entry|. Each entry contains five integer fields and represents an object
@z

%***********************************************************************

@x 16103
    int0, int1, int2, int3: integer;
@y
    int0, int1, int2, int3, int4: integer;
@z

%***********************************************************************

@x 16111 typo
object in |obj_tab| if this object in linked in a list.

The third field holds the byte offset of the object in the output PDF file.
@y
object in |obj_tab| if this object is linked in a list.

The third field holds the byte offset of the object in the output PDF file,
or its byte offset within an object stream.
@z

%***********************************************************************

@x 16116
written out.
@y
written out.

The fourth field holds the object number of the object stream, into which
the object is included.
@z

%***********************************************************************

@x 16124
@d obj_offset(#) == obj_tab[#].int2 {byte offset of this object in PDF output file}
@d obj_aux(#) == obj_tab[#].int3 {auxiliary pointer}
@y
@d obj_offset(#) == obj_tab[#].int2 {byte offset for this object in PDF output file, or object stream number for this object}
@d obj_os_idx(#) == obj_tab[#].int3 {index of this object in object stream}
@d obj_aux(#) == obj_tab[#].int4 {auxiliary pointer}
@z

%***********************************************************************

@x 16143
@d name_tree_kids_max      == @'100000 {max number of kids of node of name tree for
@y
@d name_tree_kids_max      == 6 {max number of kids of node of name tree for
@z

%***********************************************************************

@x 16319
@!obj_ptr: integer; {objects counter}
@y
@!pages_tail: integer;
@!obj_ptr: integer; {user objects counter}
@!sys_obj_ptr: integer; {system objects counter, including object streams}
@z

%***********************************************************************

@x 16329
obj_ptr := 0;
@y
obj_ptr := 0;
sys_obj_ptr := 0;
@z

%***********************************************************************

@x 16356
procedure pdf_create_obj(t, i: integer); {create an object with type |t| and
identifier |i|}
label done;
var p, q: integer;
begin
    if obj_ptr = obj_tab_size then
        overflow("indirect objects table size", obj_tab_size);
    incr(obj_ptr);
@y
procedure pdf_create_obj(t, i: integer); {create an object with type |t| and
identifier |i|}
label done;
var p, q: integer;
begin
    if sys_obj_ptr = obj_tab_size then
        overflow("indirect objects table size", obj_tab_size);
    incr(sys_obj_ptr);
    obj_ptr := sys_obj_ptr;
@z

%***********************************************************************

@x 16401
procedure pdf_begin_obj(i: integer); {begin a PDF object}
begin
    ensure_pdf_open;
    check_pdfminorversion;
    obj_offset(i) := pdf_offset;
    pdf_print_int(i);
    pdf_print_ln(" 0 obj");
end;
@y
procedure pdf_os_switch(pdf_os: boolean); {switch between PDF stream and object stream mode}
begin
    if pdf_os and pdf_os_enable then begin
        if not pdf_os_mode then begin {back up PDF stream variables}
            pdf_op_ptr := pdf_ptr;
            pdf_ptr := pdf_os_ptr;
            pdf_buf := pdf_os_buf;
            pdf_buf_size := pdf_os_buf_size;
            pdf_os_mode := true; {switch to object stream}
        end;
    end else begin
        if pdf_os_mode then begin {back up object stream variables}
            pdf_os_ptr := pdf_ptr;
            pdf_ptr := pdf_op_ptr;
            pdf_buf := pdf_op_buf;
            pdf_buf_size := pdf_op_buf_size;
            pdf_os_mode := false; {switch to PDF stream}
        end;
    end;
end;

procedure pdf_os_prepare_obj(i: integer; pdf_os: boolean); {create new \.{/ObjStm} object
if required, and set up cross reference info}
begin
    pdf_os_switch(pdf_os);
    if pdf_os and pdf_os_enable then begin
        if pdf_os_cur_objnum = 0 then begin
            pdf_os_cur_objnum := pdf_new_objnum;
            decr(obj_ptr); {object stream is not accessible to user}
            pdf_os_objidx := 0;
            pdf_ptr := 0; {start fresh object stream}
        end else
            incr(pdf_os_objidx);
        obj_os_idx(i) := pdf_os_objidx;
        obj_offset(i) := pdf_os_cur_objnum;
        pdf_os_objnum[pdf_os_objidx] := i;
        pdf_os_objoff[pdf_os_objidx] := pdf_ptr;
    end else begin
        obj_offset(i) := pdf_offset;
        obj_os_idx(i) := -1; {mark it as not included in object stream}
    end;
end;

procedure pdf_begin_obj(i: integer; pdf_os: boolean); {begin a PDF object}
begin
    check_pdfminorversion;
    pdf_os_prepare_obj(i, pdf_os);
    if not pdf_os or not pdf_os_enable then begin
        pdf_print_int(i);
        pdf_print_ln(" 0 obj");
    end;
end;
@z

%***********************************************************************

@x 16410
procedure pdf_end_obj;
begin
    pdf_print_ln("endobj"); {end a PDF object}
end;
@y
procedure pdf_end_obj;
begin
    if pdf_os_mode then begin
        if pdf_os_objidx = pdf_os_max_objs - 1 then
            pdf_os_write_objstream;
    end else
        pdf_print_ln("endobj"); {end a PDF object}
end;
@z

%***********************************************************************

@x 16415
procedure pdf_begin_dict(i: integer); {begin a PDF dictionary object}
begin
    obj_offset(i) := pdf_offset;
    pdf_print_int(i);
    pdf_print_ln(" 0 obj <<");
end;
@y
procedure pdf_begin_dict(i: integer; pdf_os: boolean); {begin a PDF dictionary object}
begin
    pdf_os_prepare_obj(i, pdf_os);
    if not pdf_os or not pdf_os_enable then begin
        pdf_print_int(i);
        pdf_print(" 0 obj ");
    end;
    pdf_print_ln("<<");
end;
@z

%***********************************************************************

@x 16422
procedure pdf_end_dict; {end a PDF object of type dictionary}
begin
    pdf_print_ln(">> endobj");
end;
@y
procedure pdf_end_dict; {end a PDF object of type dictionary}
begin
    if pdf_os_mode then begin
        pdf_print_ln(">>");
        if pdf_os_objidx = pdf_os_max_objs - 1 then
            pdf_os_write_objstream;
    end else
        pdf_print_ln(">> endobj");
end;

procedure pdf_os_write_objstream;
{Write out the accumulated object stream.
First the object number and byte offset pairs are generated
and appended to the ready buffered object stream.
By this the value of \.{/First} can be calculated.
Then a new \.{/ObjStm} object is generated, and everything is
copied to the PDF output buffer, where also compression is done.
When calling this procedure, |pdf_os_mode| must be |true|.}
var i, j, p, q: pointer;
begin
    if pdf_os_cur_objnum = 0 then {no object stream started}
        return;
    p := pdf_ptr;
    i := 0;
    j := 0;
    while i <= pdf_os_objidx do begin {assemble object number and byte offset pairs}
        pdf_print_int(pdf_os_objnum[i]);
        pdf_print(" ");
        pdf_print_int(pdf_os_objoff[i]);
        if j = 9 then begin {print out in groups of ten for better readability}
            pdf_out(pdf_new_line_char);
            j := 0;
        end else begin
            pdf_print(" ");
            incr(j);
        end;
        incr(i);
    end;
    pdf_buf[pdf_ptr - 1] := pdf_new_line_char; {no risk of flush, as we are in |pdf_os_mode|}
    q := pdf_ptr;
    pdf_begin_dict(pdf_os_cur_objnum, false); {switch to PDF stream writing}
    pdf_print_ln("/Type /ObjStm");
    pdf_print("/N ");
    pdf_print_int_ln(pdf_os_objidx + 1);
    pdf_print("/First ");
    pdf_print_int_ln(q - p);
    pdf_begin_stream;
    pdf_room(q - p); {should always fit into the PDF output buffer}
    i := p;
    while i < q do begin {write object number and byte offset pairs}
        pdf_quick_out(pdf_os_buf[i]);
        incr(i);
    end;
    i := 0;
    while i < p do begin
        q := i + pdf_buf_size;
        if q > p then q := p;
        pdf_room(q - i);
        while i < q do begin {write the buffered objects}
            pdf_quick_out(pdf_os_buf[i]);
            incr(i);
        end;
    end;
    pdf_end_stream;
    pdf_os_cur_objnum := 0; {to force object stream generation next time}
end;
@z

%***********************************************************************

@x 16427
procedure pdf_new_obj(t, i: integer); {begin to a new object}
begin
    pdf_create_obj(t, i);
    pdf_begin_obj(obj_ptr);
end;
@y
procedure pdf_new_obj(t, i: integer; pdf_os: boolean); {begin to a new object}
begin
    pdf_create_obj(t, i);
    pdf_begin_obj(obj_ptr, pdf_os);
end;
@z

%***********************************************************************

@x 16433
procedure pdf_new_dict(t, i: integer); {begin a new object with type dictionary}
begin
    pdf_create_obj(t, i);
    pdf_begin_dict(obj_ptr);
end;
@y
procedure pdf_new_dict(t, i: integer; pdf_os: boolean); {begin a new object with type dictionary}
begin
    pdf_create_obj(t, i);
    pdf_begin_dict(obj_ptr, pdf_os);
end;
@z

%***********************************************************************

@x 16479
@p procedure pdf_print_fw_int(n, w: integer); {print out an integer with
fixed width; used for outputting cross-reference table}
var k:integer; {$0\le k\le23$}
begin
  k:=0;
  repeat dig[k]:=n mod 10; n:=n div 10; incr(k);
  until k = w;
  pdf_room(k);
  while k>0 do begin
    decr(k);
    pdf_quick_out("0"+dig[k]);
  end;
end;
@y
@p procedure pdf_print_fw_int(n, w: integer); {print out an integer with
fixed width; used for outputting cross-reference table}
var k: integer; {$0\le k\le23$}
begin
    k := 0;
    repeat dig[k] := n mod 10; n := n div 10; incr(k);
    until k = w;
    pdf_room(k);
    while k > 0 do begin
        decr(k);
        pdf_quick_out("0" + dig[k]);
    end;
end;

procedure pdf_out_bytes(n, w: integer); {print out an integer as
a number of bytes; used for outputting \.{/XRef} cross-reference stream}
var k: integer;
byte: array[0..3] of integer; {digits in a number being output}
begin
    k := 0;
    repeat byte[k] := n mod 256; n := n div 256; incr(k);
    until k = w;
    pdf_room(k);
    while k > 0 do begin
        decr(k);
        pdf_quick_out(byte[k]);
    end;
end;
@z

%***********************************************************************

@x 18121
    pdf_begin_dict(pdf_cur_form);
@y
    pdf_begin_dict(pdf_cur_form, false);
@z

%***********************************************************************

@x 18132
    pdf_new_dict(obj_type_others, 0);
@y
    pdf_new_dict(obj_type_others, 0, false);
@z

%***********************************************************************

@x 18227
pdf_begin_dict(pdf_last_resources);
@y
pdf_begin_dict(pdf_last_resources, true);
@z

%***********************************************************************

@x 18322
pdf_begin_dict(pdf_last_page);
@y
pdf_begin_dict(pdf_last_page, true);
@z

%***********************************************************************

@x 18379
        pdf_begin_dict(n);
@y
        pdf_begin_dict(n, false);
@z

%***********************************************************************

@x 18387
        pdf_begin_obj(n);
@y
        pdf_begin_obj(n, true);
@z

%***********************************************************************

@x 18470
    pdf_begin_dict(n);
@y
    pdf_begin_dict(n, false);
@z

%***********************************************************************

@x 18502
        pdf_begin_dict(info(k));
@y
        pdf_begin_dict(info(k), true);
@z

%***********************************************************************

@x 18521
    pdf_begin_dict(info(k));
@y
    pdf_begin_dict(info(k), true);
@z

%***********************************************************************

@x 18557
                pdf_begin_dict(info(k));
@y
                pdf_begin_dict(info(k), true);
@z

%***********************************************************************

@x 18561
                pdf_begin_obj(info(k));
@y
                pdf_begin_obj(info(k), true);
@z

%***********************************************************************

@x 18628
        pdf_new_obj(obj_type_others, 0);
@y
        pdf_new_obj(obj_type_others, 0, true);
@z

%***********************************************************************

@x 18646
    pdf_new_dict(obj_type_others, 0);
@y
    pdf_new_dict(obj_type_others, 0, true);
@z

%***********************************************************************

@x 18676
    pdf_begin_dict(k);
@y
    pdf_begin_dict(k, true);
@z

%***********************************************************************

@x 18701
    pdf_new_obj(obj_type_others, 0);
@y
    pdf_new_obj(obj_type_others, 0, true);
@z

%***********************************************************************

@x 18829
    pdf_print_info;
    @<Output the |obj_tab|@>;
@y
    pdf_print_info; {last candidate for object stream}
    if pdf_os_enable then begin
        pdf_os_switch(true);
        pdf_os_write_objstream;
        pdf_flush;
        pdf_os_switch(false);
        @<Output the cross-reference stream dictionary@>;
        pdf_flush;
    end else begin
        @<Output the |obj_tab|@>;
    end;
@z

%***********************************************************************

@x 18862
    pdf_begin_obj(k);
@y
    pdf_begin_obj(k, true);
@z

%***********************************************************************

@x 18897
k := head_tab[obj_type_pages];
@y
k := head_tab[obj_type_pages];
pages_tail := k;
@z

%***********************************************************************

@x 18931
@<Output pages tree@>=
a := obj_ptr + 1; {all Pages objects whose children are not Page objects
should have index greater than |a|}
l := head_tab[obj_type_pages]; {|l| is the index of current Pages object which is
being output}
k := head_tab[obj_type_page]; {|k| is the index of current child of |l|}
if obj_link(l) = 0 then
    is_root := true {only Pages object; total pages is not greater than
    |pages_tree_kids_max|}
else
    is_root := false;
b := obj_ptr + 1; {to init |c| in next step}
repeat
    i := 0; {counter of Pages object in current level}
    c := b; {first Pages object in previous level}
    b := obj_ptr + 1; {succcesor of last created object}
    repeat
        if not is_root then begin
            if i mod pages_tree_kids_max = 0 then begin {create a new Pages object for next level}
                pdf_last_pages := pdf_new_objnum;
                obj_info(pdf_last_pages) := obj_info(l);
            end
            else
                obj_info(pdf_last_pages) := obj_info(pdf_last_pages) +
                    obj_info(l);
        end;
        @<Output the current Pages object in this level@>;
        incr(i);
        if l < a  then
            l := obj_link(l)
        else
            incr(l);
    until (l = 0) or (l = b);
    if l = 0 then
        l := a;
    if b = obj_ptr then
        is_root := true;
until false;
done:

@ @<Output the current Pages object in this level@>=
pdf_begin_dict(l);
pdf_print_ln("/Type /Pages");
pdf_int_entry_ln("Count", obj_info(l));
if not is_root then
    pdf_indirect_ln("Parent", pdf_last_pages);
pdf_print("/Kids [");
j := 0;
repeat
    pdf_print_int(k);
    pdf_print(" 0 R ");
    if k < a then {the next Pages/Page object must be |obj_link(k)|}
        k := obj_link(k)
    else {|k >= a|, the next Pages object is |k + 1|}
        incr(k);
    incr(j);
until ((l < a) and (j = obj_info(l))) or
    (k = 0) or (k = c) or
    (j = pages_tree_kids_max);
remove_last_space;
pdf_print_ln("]");
if k = 0 then begin
    if head_tab[obj_type_pages] <> 0 then begin {we are in Page objects list}
        k := head_tab[obj_type_pages];
        head_tab[obj_type_pages] := 0;
    end
    else {we are in Pages objects list}
        k := a;
end;
if is_root and (pdf_pages_attr <> null) then
    pdf_print_toks_ln(pdf_pages_attr);
pdf_end_dict;
if is_root then
    goto done
@y
@<Output pages tree@>=
a := sys_obj_ptr + 1; {all Pages objects whose children are not Page objects
                       should have index greater than |a|}
l := head_tab[obj_type_pages]; {|l| is the index of current Pages object
                                which is being output}
k := head_tab[obj_type_page]; {|k| is the index of current child of |l|}
b := 0;
repeat
    i := 0; {counter of Pages object in current level}
    c := 0; {first Pages object in previous level}
    if obj_link(l) = 0 then
        is_root := true {only Pages object; total pages is
                         not greater than |pages_tree_kids_max|}
    else
        is_root := false;
    repeat
        if not is_root then begin
            if i mod pages_tree_kids_max = 0 then begin {create a new Pages object
                                                         for next level}
                pdf_last_pages := pdf_new_objnum;
                if c = 0 then
                    c := pdf_last_pages;
                obj_link(pages_tail) := pdf_last_pages;
                pages_tail := pdf_last_pages;
                obj_link(pdf_last_pages) := 0;
                obj_info(pdf_last_pages) := obj_info(l);
            end
            else
                obj_info(pdf_last_pages) := obj_info(pdf_last_pages) +
                    obj_info(l);
        end;
        @<Output the current Pages object in this level@>;
        incr(i);
        l := obj_link(l);
    until (l = c);
    b := c;
    if l = 0 then
        goto done;
until false;
done:

@ @<Output the current Pages object in this level@>=
pdf_begin_dict(l, true);
pdf_print_ln("/Type /Pages");
pdf_int_entry_ln("Count", obj_info(l));
if not is_root then
    pdf_indirect_ln("Parent", pdf_last_pages);
pdf_print("/Kids [");
j := 0;
repeat
    pdf_print_int(k);
    pdf_print(" 0 R ");
    k := obj_link(k);
    incr(j);
until ((l < a) and (j = obj_info(l))) or
    (k = 0) or ((k = b) and (b <> 0)) or
    (j = pages_tree_kids_max);
remove_last_space;
pdf_print_ln("]");
if k = 0 then begin
    k := head_tab[obj_type_pages];
    head_tab[obj_type_pages] := 0;
end;
if is_root and (pdf_pages_attr <> null) then
    pdf_print_toks_ln(pdf_pages_attr);
pdf_end_dict;
@z

%***********************************************************************

@x 19013
@<Output name tree@>=
if pdf_dest_names_ptr = 0 then begin
    dests := 0;
    goto done1;
end;
sort_dest_names(0, pdf_dest_names_ptr - 1);
a := obj_ptr + 1; {first intermediate node of name tree}
l := a; {index of node being output}
k := 0; {index of current child of |l|; if |k < pdf_dest_names_ptr| then this is
pointer to |dest_names| array; otherwise it is the pointer to |obj_tab|
(object number) }
repeat
    c := obj_ptr + 1; {first node in current level}
    repeat
        pdf_create_obj(obj_type_others, 0); {create a new node for next level}
        @<Output the current node in this level@>;
        incr(l);
        incr(i);
    until k = c;
until false;
done1:
if (dests <> 0) or (pdf_names_toks <> null) then begin
    pdf_new_dict(obj_type_others, 0);
    if (dests <> 0) then
        pdf_indirect_ln("Dests", dests);
    if pdf_names_toks <> null then begin
        pdf_print_toks_ln(pdf_names_toks);
        delete_toks(pdf_names_toks);
    end;
    pdf_end_dict;
    names_tree := obj_ptr;
end
else
    names_tree := 0

@ @<Output the current node in this level@>=
pdf_begin_dict(l);
j := 0;
if k < pdf_dest_names_ptr then begin
    obj_info(l) := dest_names[k].objname;
    pdf_print("/Names [");
    repeat
        pdf_print_str(dest_names[k].objname);
        pdf_out(" ");
        pdf_print_int(dest_names[k].objnum);
        pdf_print(" 0 R ");
        incr(j);
        incr(k);
    until (j = name_tree_kids_max) or (k = pdf_dest_names_ptr);
    remove_last_space;
    pdf_print_ln("]");
    obj_link(l) := dest_names[k - 1].objname;
    if k = pdf_dest_names_ptr then
        k := a;
end
else begin
    obj_info(l) := obj_info(k);
    pdf_print("/Kids [");
    repeat
        pdf_print_int(k);
        pdf_print(" 0 R ");
        incr(j);
        incr(k);
    until (j = name_tree_kids_max) or (k = c);
    remove_last_space;
    pdf_print_ln("]");
    obj_link(l) := obj_link(k - 1);
end;
if (l > k) or (l = a) then begin
    pdf_print("/Limits [");
    pdf_print_str(obj_info(l));
    pdf_out(" ");
    pdf_print_str(obj_link(l));
    pdf_print_ln("]");
    pdf_end_dict;
end
else begin
    pdf_end_dict;
    dests := l;
    goto done1;
end
@y
@<Output name tree@>=
if pdf_dest_names_ptr = 0 then begin
    dests := 0;
    goto done1;
end;
sort_dest_names(0, pdf_dest_names_ptr - 1);
names_head := 0;
names_tail := 0;
k := 0; {index of current child of |l|; if |k < pdf_dest_names_ptr|
         then this is pointer to |dest_names| array;
         otherwise it is the pointer to |obj_tab| (object number)}
is_names := true; {flag whether Names or Kids}
b := 0;
repeat
    repeat
        pdf_create_obj(obj_type_others, 0); {create a new node}
        l := obj_ptr;
        if b = 0 then
            b := l; {first in this level}
        if names_head = 0 then begin
            names_head := l;
            names_tail := l;
        end else begin
            obj_link(names_tail) := l;
            names_tail := l;
        end;
        obj_link(names_tail) := 0;
        @<Output the current node in this level@>;
    until b = 0;
    if k = l then begin
        dests := l;
        goto done1;
    end;
until false;
done1:
if (dests <> 0) or (pdf_names_toks <> null) then begin
    pdf_new_dict(obj_type_others, 0, true);
    if (dests <> 0) then
        pdf_indirect_ln("Dests", dests);
    if pdf_names_toks <> null then begin
        pdf_print_toks_ln(pdf_names_toks);
        delete_toks(pdf_names_toks);
    end;
    pdf_end_dict;
    names_tree := obj_ptr;
end
else
    names_tree := 0

@ @<Output the current node in this level@>=
pdf_begin_dict(l, true);
j := 0;
if is_names then begin
    obj_info(l) := dest_names[k].objname;
    pdf_print("/Names [");
    repeat
        pdf_print_str(dest_names[k].objname);
        pdf_out(" ");
        pdf_print_int(dest_names[k].objnum);
        pdf_print(" 0 R ");
        incr(j);
        incr(k);
    until (j = name_tree_kids_max) or (k = pdf_dest_names_ptr);
    remove_last_space;
    pdf_print_ln("]");
    obj_aux(l) := dest_names[k - 1].objname;
    if k = pdf_dest_names_ptr then begin
        is_names := false;
        k := names_head;
        b := 0;
    end;
end
else begin
    obj_info(l) := obj_info(k);
    pdf_print("/Kids [");
    repeat
        pdf_print_int(k);
        pdf_print(" 0 R ");
        incr(j);
        obj_aux(l) := obj_aux(k);
        k := obj_link(k);
    until (j = name_tree_kids_max) or (k = b) or (obj_link(k) = 0);
    remove_last_space;
    pdf_print_ln("]");
    if k = b then
        b := 0;
end;
pdf_print("/Limits [");
pdf_print_str(obj_info(l));
pdf_out(" ");
pdf_print_str(obj_aux(l));
pdf_print_ln("]");
pdf_end_dict;
@z

%***********************************************************************

@x 19096
pdf_new_dict(obj_type_others, 0);
@y
pdf_new_dict(obj_type_others, 0, true);
@z

%***********************************************************************

@x 19145
    pdf_new_dict(obj_type_others, 0);
@y
    pdf_new_dict(obj_type_others, 0, false); {keep Info readable}
@z

%***********************************************************************

@x 19192
for k := 1 to obj_ptr do
@y
for k := 1 to sys_obj_ptr do
@z

%***********************************************************************

@x 19212
end
@y
end

@ @<Output the cross-reference stream dictionary@>=
pdf_new_dict(obj_type_others, 0, false);
if obj_offset(sys_obj_ptr) > 16777215 then
    xref_offset_width := 4
else if obj_offset(sys_obj_ptr) > 65535 then
    xref_offset_width := 3
else if obj_offset(sys_obj_ptr) > 255 then
    xref_offset_width := 2
else
    xref_offset_width := 1;
l := 0;
for k := 1 to sys_obj_ptr do
    if obj_offset(k) = 0 then begin
        obj_link(l) := k;
        l := k;
    end;
obj_link(l) := 0;
pdf_print_ln("/Type /XRef");
pdf_print("/Index [0 ");
pdf_print_int(obj_ptr);
pdf_print_ln("]");
pdf_int_entry_ln("Size", obj_ptr);
pdf_print("/W [1 ");
pdf_print_int(xref_offset_width);
pdf_print_ln(" 1]");
pdf_indirect_ln("Root", root);
pdf_indirect_ln("Info", obj_ptr - 1);
if pdf_trailer_toks <> null then begin
    pdf_print_toks_ln(pdf_trailer_toks);
    delete_toks(pdf_trailer_toks);
end;
print_ID(output_file_name);
pdf_print_nl;
pdf_begin_stream;
for k := 0 to sys_obj_ptr do begin
    if obj_offset(k) = 0 then begin {free object}
        pdf_out(0);
        pdf_out_bytes(obj_link(k), xref_offset_width);
        pdf_out(255);
    end else begin
        if obj_os_idx(k) = -1 then begin {object not in object stream}
            pdf_out(1);
            pdf_out_bytes(obj_offset(k), xref_offset_width);
            pdf_out(0);
        end else begin {object in object stream}
            pdf_out(2);
            pdf_out_bytes(obj_offset(k), xref_offset_width);
            pdf_out(obj_os_idx(k));
        end;
    end;
end;
pdf_end_stream;
@z

%***********************************************************************

@x 19214
@ @<Output the trailer@>=
pdf_print_ln("trailer");
pdf_print("<< ");
pdf_int_entry_ln("Size", obj_ptr + 1);
pdf_indirect_ln("Root", root);
pdf_indirect_ln("Info", obj_ptr);
if pdf_trailer_toks <> null then begin
    pdf_print_toks_ln(pdf_trailer_toks);
    delete_toks(pdf_trailer_toks);
end;
print_ID(output_file_name);
pdf_print_ln(" >>");
pdf_print_ln("startxref");
pdf_print_int_ln(pdf_save_offset);
pdf_print_ln("%%EOF")
@y
@ @<Output the trailer@>=
if not pdf_os_enable then begin
    pdf_print_ln("trailer");
    pdf_print("<< ");
    pdf_int_entry_ln("Size", sys_obj_ptr + 1);
    pdf_indirect_ln("Root", root);
    pdf_indirect_ln("Info", sys_obj_ptr);
    if pdf_trailer_toks <> null then begin
        pdf_print_toks_ln(pdf_trailer_toks);
        delete_toks(pdf_trailer_toks);
    end;
    print_ID(output_file_name);
    pdf_print_ln(" >>");
end;
pdf_print_ln("startxref");
if pdf_os_enable then
    pdf_print_int_ln(obj_offset(sys_obj_ptr))
else
    pdf_print_int_ln(pdf_save_offset);
pdf_print_ln("%%EOF")
@z

%***********************************************************************

@x 32378
  dest_names:=xmalloc_array (dest_name_entry, dest_names_size);
@y
  dest_names:=xmalloc_array (dest_name_entry, dest_names_size);
  pdf_op_buf:=xmalloc_array (eight_bits, pdf_op_buf_size);
  pdf_os_buf:=xmalloc_array (eight_bits, inf_pdf_os_buf_size);
  pdf_os_objnum:=xmalloc_array (integer, pdf_os_max_objs);
  pdf_os_objoff:=xmalloc_array (integer, pdf_os_max_objs);
@z

%***********************************************************************

@x 32439
    is_root: boolean; {|pdf_last_pages| is root of Pages tree?}
    root, outlines, threads, names_tree, dests, fixed_dest: integer;
@y
    is_root: boolean; {|pdf_last_pages| is root of Pages tree?}
    is_names: boolean; {flag for name tree output: is it Names or Kids?}
    root, outlines, threads, names_tree, dests, fixed_dest: integer;
    xref_offset_width, names_head, names_tail: integer;
@z

%***********************************************************************

@x 33855
    pdf_new_obj(obj_type_others, 0);
@y
    pdf_new_obj(obj_type_others, 0, true);
@z

%***********************************************************************

@x 33865
    pdf_new_obj(obj_type_others, 0);
@y
    pdf_new_obj(obj_type_others, 0, true);
@z

%***********************************************************************

@x 34098
            pdf_new_obj(obj_type_others, 0);
@y
            pdf_new_obj(obj_type_others, 0, true);
@z

%***********************************************************************

@x 34235
    pdf_new_dict(obj_type_others, 0);
@y
    pdf_new_dict(obj_type_others, 0, false);
@z

%***********************************************************************

@x 34246
    pdf_begin_dict(thread);
@y
    pdf_begin_dict(thread, true);
@z

%***********************************************************************

@x 34262
    pdf_begin_dict(thread);
@y
    pdf_begin_dict(thread, true);
@z

%***********************************************************************

@x 34281
        pdf_begin_dict(a);
@y
        pdf_begin_dict(a, true);
@z

%***********************************************************************
