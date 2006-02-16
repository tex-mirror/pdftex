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
%***********************************************************************
%
%
% Experimental patch onto pdftex-1.30.3 to have less )1( and )-1(
% corrections in the TJ arrays, particularily when typesetting with
% CM fonts.
%
% The /Widths array output gets one digit after the decimal point
% (inline with the PDF standard), so that CM fonts, with their
% character widths not on a strict raster of fontsize/1000 (as usual
% with PostScript Type 1 fonts) are better handled. (Having more than
% one digit would raise potential problems with numeric overflow in
% the current implementation.)
%
% This increased resolution by one digit lets positioning errors
% accumulate less quickly, so that in most cases there will be a kern
% before a )1( or )-1( correction needs to be done.
%
% BTW, looking into the file PDFReference15_v5.pdf shows, that there
% even fractional corrections like )-10.4( are used.
%
% Still these )1( or )-1( will happen, if corrections fall just near
% to the middle between the raster points. This could be prevented
% by adding a hysteresis, but such an additional tolerance would
% cost resolution. Anyway, the increased /Widths array resolution
% brings these cases down to 10 % of their previous frequency.
%
% Patch also simplifies the TJ array building in procedure
% pdf_begin_text; semaphor variable b is removed.
%
% Patch also removes pdf_first_space_corr variable.
%
% Patch also gives pdf_set_origin two parameters (h, v), makes
% positioning more transparent, and simplifies procedure pdf_begin_text.
%
% Change file positioning.ch should come after randoms.ch.
% Also patching of writefont.c is required, see writefont.c.diff.
%
% Rough patch, not for production. Testing welcome.
%
%***********************************************************************
% $Id: positioning.ch,v 1.41 2005/10/09 13:04:04 hahe Exp hahe $

@x we have to move literal() behind pdf_set_origin() declaration
procedure literal(s: str_number; literal_mode: integer; warn: boolean);
var j: pool_pointer; {current character code position}
begin
    j:=str_start[s];
    if literal_mode = scan_special then begin
        if not (str_in_str(s, "PDF:", 0) or str_in_str(s, "pdf:", 0)) then begin
            if warn and not (str_in_str(s, "SRC:", 0)
                or str_in_str(s, "src:", 0)
                or (length(s) = 0)) then
                    print_nl("Non-PDF special ignored!");
            return;
        end;
        j := j + length("PDF:");
        if str_in_str(s, "direct:", length("PDF:")) then begin
            j := j + length("direct:");
            literal_mode := direct_always; end
        else if str_in_str(s, "page:", length("PDF:")) then begin
            j := j + length("page:");
            literal_mode := direct_page; end
        else
            literal_mode := reset_origin;
    end;
    case literal_mode of
    reset_origin: begin
        pdf_end_text;
        pdf_set_origin;
        end;
    direct_page:
        pdf_end_text;
    direct_always: begin
        pdf_first_space_corr := 0;
        pdf_end_string;
        pdf_print_nl;
        end;
    othercases confusion("literal1")
    endcases;
    while j<str_start[s+1] do begin
       pdf_out(str_pool[j]);
       incr(j);
    end;
    pdf_print_nl;
end;

@y
@z

%***********************************************************************

@x
@ Next subroutines are needed for controling spacing in PDF page description.
The procedure |adv_char_width| advances |pdf_h| by the amount |w|, which is
the character width. We cannot simply add |w| to |pdf_h|, but must
calculate the amount corresponding to |w| in the PDF output. For PK fonts
things are more complicated, as we have to deal with scaling bitmaps as well.

@p
procedure adv_char_width(f: internal_font_number; w: scaled); {update |pdf_h|
by character width |w| from font |f|}
begin
    if hasfmentry(f) then begin
        call_func(divide_scaled(w, pdf_font_size[f], 3));
        pdf_h := pdf_h + scaled_out;
    end
    else
        pdf_h := pdf_h + get_pk_char_width(f, w);
end;
@y
@ Next subroutines are needed for controling spacing in PDF page description.
For a given character |c| from a font |f|,
the procedure |adv_char_width| advances |pdf_h|
by {\it about\/} the amount |w|, which is the character width.
But we cannot simply add |w| to |pdf_h|.
Instead we have to bring the required shift into the same raster,
on which also the \.{/Widths} array values,
as they appear in the PDF file, are based.
The |scaled_out| value is the |w| value moved into this raster.
The \.{/Widths} values are used by the PDF reader independently
to update its positions.
So one has to be sure, that calculations are properly synchronized.
Currently the \.{/Widths} array values are output
with one digit after the decimal point,
therefore the raster on which |adv_char_width| is operating
is $1/10000$ of the |pdf_font_size|.

For PK fonts things are more complicated,
as we have to deal with scaling bitmaps as well.

@p
procedure adv_char_width(f: internal_font_number; c: eight_bits); {update |pdf_h|
by character width |w| from font |f|}
var w: scaled;
begin
    w := char_width(f)(char_info(f)(c));
    if hasfmentry(f) then begin
        call_func(divide_scaled(w, pdf_font_size[f], 4));
        pdf_h := pdf_h + scaled_out;
    end
    else
        pdf_h := pdf_h + get_pk_char_width(f, w);
end;
@z

%***********************************************************************

@x
@!pdf_first_space_corr: integer; {amount of first word spacing while drawing a string;
for some reason it is not taken into account of the length of the string, so we
have to save it in order to adjust spacing when string drawing is finished}
@y
@z

%***********************************************************************

@x
@!min_bp_val: scaled;
@y
@!min_bp_val: scaled;
@!min_font_val: scaled; {(TJ array system)}
@z

%***********************************************************************

@x
@p procedure pdf_set_origin; {set the origin to |cur_h|, |cur_v|}
begin
    if (abs(cur_h - pdf_origin_h) >= min_bp_val) or
        (abs(cur_v - pdf_origin_v) >= min_bp_val) then begin
        pdf_print("1 0 0 1 ");
        pdf_print_bp(cur_h - pdf_origin_h);
        pdf_origin_h := pdf_origin_h + scaled_out;
        pdf_out(" ");
        pdf_print_bp(pdf_origin_v - cur_v);
        pdf_origin_v := pdf_origin_v - scaled_out;
        pdf_print_ln(" cm");
    end;
    pdf_h := pdf_origin_h;
    pdf_last_h := pdf_origin_h;
    pdf_v := pdf_origin_v;
    pdf_last_v := pdf_origin_v;
end;
@y
@p procedure pdf_set_origin(h, v: scaled); {set the origin to |h|, |v|}
begin
    if (abs(h - pdf_origin_h) >= min_bp_val) or
        (abs(v - pdf_origin_v) >= min_bp_val) then begin
        pdf_print("1 0 0 1 ");
        pdf_print_bp(h - pdf_origin_h);
        pdf_origin_h := pdf_origin_h + scaled_out;
        pdf_out(" ");
        pdf_print_bp(pdf_origin_v - v);
        pdf_origin_v := pdf_origin_v - scaled_out;
        pdf_print_ln(" cm");
    end;
    pdf_h := pdf_origin_h;
    pdf_last_h := pdf_origin_h;
    pdf_v := pdf_origin_v;
    pdf_last_v := pdf_origin_v;
end;
@z

%***********************************************************************

@x
        if pdf_first_space_corr <> 0 then begin
            pdf_h := pdf_h - pdf_first_space_corr;
            pdf_first_space_corr := 0;
        end;
@y
@z

%***********************************************************************

@x
procedure pdf_begin_text; forward;

@y
@z

%***********************************************************************

@x
    pdf_begin_text;
@y
@z

%***********************************************************************

@x
    pdf_print_bp(font_size[f]);
@y
    pdf_print_real(divide_scaled(font_size[f], one_hundred_bp, 6), 4);
@z

%***********************************************************************

@x the new pdf_set_origin(h, v) simplifies pdf_begin_text.
procedure pdf_begin_text; {begin a text section}
var temp_cur_h, temp_cur_v: scaled;
begin
    if not pdf_doing_text then begin
        temp_cur_h := cur_h;
        temp_cur_v := cur_v;
        cur_h := 0;
        cur_v := cur_page_height;
        pdf_set_origin;
        cur_h := temp_cur_h;
        cur_v := temp_cur_v;
        pdf_print_ln("BT");
        pdf_doing_text := true;
        pdf_f := null_font;
        pdf_first_space_corr := 0;
        pdf_doing_string := false;
    end;
end;
@y
procedure pdf_begin_text; {begin a text section}
begin
    pdf_set_origin(0, cur_page_height);
    pdf_print_ln("BT");
    pdf_doing_text := true;
    pdf_f := null_font;
    pdf_doing_string := false;
end;
@z

%***********************************************************************

@x
procedure pdf_begin_string(f: internal_font_number); {begin to draw a string}
var b: boolean; {|b| is true only when we must adjust word spacing
at the beginning of string}
    s, s_out, v, v_out: scaled;
begin
    pdf_begin_text;
    if f <> pdf_f then begin
        pdf_end_string;
        pdf_set_font(f);
    end;
    b := false;
    s := divide_scaled(cur_h - pdf_h, pdf_font_size[f], 3);
    s_out := scaled_out;
@y
@ The value of |min_font_val| is calculated only once
for each font change.
Division by $2000$ there sets |min_font_val| just at the
trigger level of the |divide_scaled| operation below.
Therefore the comparison |abs(cur_h - pdf_h)| does not
cost precision, it just makes the |divide_scaled|
operation happen less often.

@p
procedure pdf_begin_string(f: internal_font_number); {begin to draw a string}
var s, s_out, v, v_out: scaled;
begin
    if not pdf_doing_text then
        pdf_begin_text;
    if f <> pdf_f then begin
        pdf_end_string;
        pdf_set_font(f);
        min_font_val :=
            divide_scaled(pdf_font_size[f], 2000, 0);
    end;
    if abs(cur_h - pdf_h) >= min_font_val then begin
        s := divide_scaled(cur_h - pdf_h, pdf_font_size[f], 3);
        s_out := scaled_out;
    end else
        s := 0;
@z

%***********************************************************************

@x this is redundant, as s := 0 anyway
        s_out := 0;
@y
@z

%***********************************************************************

@x simplify the TJ array building procedure
    if pdf_doing_string then begin
        if s <> 0 then
            pdf_out(")");
    end
    else begin
        pdf_out("[");
        if s <> 0 then
            b := true
        else
            pdf_out("(");
        pdf_doing_string := true;
    end;
    if s <> 0 then begin
        pdf_print_int(-s);
        if b then
            pdf_first_space_corr := s_out;
        pdf_out("(");
        pdf_h := pdf_h + s_out;
    end;
@y
    if not pdf_doing_string then begin
        pdf_out("[");
        if s = 0 then
            pdf_out("(");
    end;
    if s <> 0 then begin
        if pdf_doing_string then
            pdf_out(")");
        pdf_print_int(-s);
        pdf_out("(");
        pdf_h := pdf_h + s_out;
    end;
    pdf_doing_string := true;
@z

%***********************************************************************

@x
    pdf_print_mag_bp(pdf_y(top));
    pdf_print_ln("]");
end;

@y
    pdf_print_mag_bp(pdf_y(top));
    pdf_print_ln("]");
end;

procedure literal(s: str_number; literal_mode: integer; warn: boolean);
var j: pool_pointer; {current character code position}
begin
    j:=str_start[s];
    if literal_mode = scan_special then begin
        if not (str_in_str(s, "PDF:", 0) or str_in_str(s, "pdf:", 0)) then begin
            if warn and not (str_in_str(s, "SRC:", 0)
                or str_in_str(s, "src:", 0)
                or (length(s) = 0)) then
                    print_nl("Non-PDF special ignored!");
            return;
        end;
        j := j + length("PDF:");
        if str_in_str(s, "direct:", length("PDF:")) then begin
            j := j + length("direct:");
            literal_mode := direct_always; end
        else if str_in_str(s, "page:", length("PDF:")) then begin
            j := j + length("page:");
            literal_mode := direct_page; end
        else
            literal_mode := reset_origin;
    end;
    case literal_mode of
    reset_origin: begin
        pdf_end_text;
        pdf_set_origin(cur_h, cur_v);
        end;
    direct_page:
        pdf_end_text;
    direct_always: begin
        pdf_end_string;
        pdf_print_nl;
        end;
    othercases confusion("literal1")
    endcases;
    while j<str_start[s+1] do begin
       pdf_out(str_pool[j]);
       incr(j);
    end;
    pdf_print_nl;
end;

@z

%***********************************************************************

@x
    call_func(divide_scaled(font_size[f], one_hundred_bp,
                            fixed_decimal_digits + 2));
@y
    call_func(divide_scaled(font_size[f], one_hundred_bp, 6));
@z

%***********************************************************************

@x
        adv_char_width(f, char_width(f)(char_info(f)(#)));
@y
        adv_char_width(f, #);
@z

%***********************************************************************
