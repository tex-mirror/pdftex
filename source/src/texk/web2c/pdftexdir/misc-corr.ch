%
% Copyright (c) 2006 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
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
%***********************************************************************
% $Id: misc-corr.ch,v 1.11 2006/01/14 22:20:33 hahe Exp hahe $
%
% misc-corr.ch
%
% patch for pdftex-1.40.0-alpha-20060106
%
% miscellaneous corrections:
% - endstream in new line
% - pdf_char_map is obsolete
% - remove divisions of 10^n by 10
% - pdf_decimal_digits := 3 is precise enough
% - spurious tab in hz.ch
%
%***********************************************************************
% spurious tab in hz.ch

@x 6917
	end;
@y
        end;
@z

%***********************************************************************
% pdf_decimal_digits := 3 is precise enough

@x 15226
pdf_decimal_digits := 4;
@y
pdf_decimal_digits := 3;
@z

%***********************************************************************
% endstream in new line

@x 15492
pdf_buf := pdf_op_buf;
@y
pdf_buf := pdf_op_buf;
pdf_seek_write_length := false;
@z

%***********************************************************************
% endstream in new line

@x 15584
                pdf_gone := pdf_gone + pdf_ptr;
@y
                pdf_gone := pdf_gone + pdf_ptr;
                pdf_last_byte := pdf_buf[pdf_ptr - 1];
@z

%***********************************************************************
% endstream in new line

@x 15599
    pdf_print_ln("/Length           ");
@y
    pdf_print_ln("/Length           ");
    pdf_seek_write_length := true; {fill in length at |pdf_end_stream| call}
@z

%***********************************************************************
% endstream in new line

@x 15618
    if pdf_compress_level > 0 then
        zip_write_state := zip_finish
    else
        pdf_stream_length := pdf_offset - pdf_save_offset;
    pdf_flush;
    write_stream_length(pdf_stream_length, pdf_stream_length_offset);
    if pdf_compress_level > 0 then
        pdf_out(pdf_new_line_char);
@y
    if zip_write_state = zip_writing then
        zip_write_state := zip_finish
    else
        pdf_stream_length := pdf_offset - pdf_save_offset;
    pdf_flush;
    if pdf_seek_write_length then
        write_stream_length(pdf_stream_length, pdf_stream_length_offset);
    pdf_seek_write_length := false;
    if pdf_last_byte <> pdf_new_line_char then
        pdf_out(pdf_new_line_char);
@z

%***********************************************************************
% endstream in new line
% looks as if this was a kludge for endstream?

@x 15636
@d pdf_print_nl == {output a new-line character to PDF buffer}
if (pdf_ptr > 0) and (pdf_buf[pdf_ptr - 1] <> pdf_new_line_char) then
    pdf_out(pdf_new_line_char)
@y
@d pdf_print_nl == {output a new-line character to PDF buffer}
    pdf_out(pdf_new_line_char)
@z

%***********************************************************************
% pdf_char_map is obsolete

@x 15731
    if c <= 32 then
        c := pdf_char_map[f, c];
@y
@z

%***********************************************************************
% remove divisions of 10^n by 10

@x 15930
procedure pdf_print_real(m, d: integer); {print $m/10^d$ as real}
var n: integer;
begin
    if m < 0 then begin
        pdf_out("-");
        m := -m;
    end;
    n := ten_pow[d];
    pdf_print_int(m div n);
    m := m mod n;
    if m > 0 then begin
        pdf_out(".");
        n := n div 10;
        while m < n do begin
            pdf_out("0");
            n := n div 10;
        end;
        while m mod 10 = 0 do
            m := m div 10;
        pdf_print_int(m);
    end;
end;
@y
procedure pdf_print_real(m, d: integer); {print $m/10^d$ as real}
begin
    if m < 0 then begin
        pdf_out("-");
        m := -m;
    end;
    pdf_print_int(m div ten_pow[d]);
    m := m mod ten_pow[d];
    if m > 0 then begin
        pdf_out(".");
        decr(d);
        while m < ten_pow[d] do begin
            pdf_out("0");
            decr(d);
        end;
        while m mod 10 = 0 do
            m := m div 10;
        pdf_print_int(m);
    end;
end;
@z

%***********************************************************************
% endstream in new line

@x 16480
@!pdf_stream_length_offset: integer; {file offset of the last stream length}
@y
@!pdf_stream_length_offset: integer; {file offset of the last stream length}
@!pdf_seek_write_length: boolean; {flag whether to seek back and write \.{/Length}}
@!pdf_last_byte: integer; {byte most recently written to PDF file; for \.{endstream} in new line}
@z

%***********************************************************************
% pdf_char_map is obsolete

@x 17499
@!pdf_char_map: ^char_map_array; {where to map chars 0..32}
@y
@z

%***********************************************************************
% pdf_char_map is obsolete

@x 32616
pdf_char_map:=xmalloc_array(char_map_array, font_max);
@y
@z

%***********************************************************************
% pdf_char_map is obsolete

@x 32644
    for k := 0 to 31 do begin
        pdf_char_used[font_k, k] := 0;
        pdf_char_map[font_k, k] := k;
    end;
    pdf_char_map[font_k, 32] := 32;
@y
    for k := 0 to 31 do
        pdf_char_used[font_k, k] := 0;
@z

%***********************************************************************
% pdf_char_map is obsolete

@x 33256
pdf_char_map:=xmalloc_array(char_map_array,font_max);
@y
@z

%***********************************************************************
% pdf_char_map is obsolete

@x 33284
    for k := 0 to 31 do begin
        pdf_char_used[font_k, k] := 0;
        pdf_char_map[font_k, k] := k;
    end;
    pdf_char_map[font_k, 32] := 32;
@y
    for k := 0 to 31 do
        pdf_char_used[font_k, k] := 0;
@z

%***********************************************************************
