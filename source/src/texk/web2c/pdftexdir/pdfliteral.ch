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
% $Id: pdfliteral.ch,v 1.20 2005/07/19 23:06:59 hahe Exp hahe $
%
% \pdfliteral {...}
% \pdfliteral page {...}
% \pdfliteral direct {...}
% \special{pdf:...}
% \special{pdf:page:...}
% \special{pdf:direct:...}
%
%***********************************************************************

@x 15638
procedure literal(s: str_number; reset_origin, is_special, warn: boolean);
var j: pool_pointer; {current character code position}
begin
    j:=str_start[s];
    if is_special then begin
        if not (str_in_str(s, "PDF:", 0) or str_in_str(s, "pdf:", 0)) then begin
            if warn and not (str_in_str(s, "SRC:", 0) or str_in_str(s, "src:", 0) or (length(s) = 0)) then
                print_nl("Non-PDF special ignored!");
            return;
        end;
        j := j + length("PDF:");
        if str_in_str(s, "direct:", length("PDF:")) then begin
            j := j + length("direct:");
            reset_origin := false;
        end
        else
            reset_origin := true;
    end;
    if reset_origin then begin
        pdf_end_text;
        pdf_set_origin;
    end
    else begin
        pdf_first_space_corr := 0;
        pdf_end_string;
        pdf_print_nl;
    end;
    while j<str_start[s+1] do begin
       pdf_out(str_pool[j]);
       incr(j);
    end;
    pdf_print_nl;
end;
@y
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
@z

%***********************************************************************

@x 16159
@# {data struture for \.{\\pdfliteral}}
@d pdf_literal_data(#)     == link(#+1) {data}
@d pdf_literal_direct(#)   == info(#+1) {write data directly to the page
                              contents without resetting text matrix}
@y
@# {data struture for \.{\\pdfliteral}}
@d pdf_literal_data(#)     == link(#+1) {data}
@d pdf_literal_mode(#)     == info(#+1) {mode of resetting the text matrix
                              while writing data to the page stream}
@# {modes of resetting the text matrix}
@d reset_origin == 0          {end text (ET) if needed, reset text matrix}
@d direct_page == 1           {end text (ET) if needed, don't reset text matrix}
@d direct_always == 2         {don't reset text matrix}
@d scan_special == 3          {look into special text}
@z

%***********************************************************************

@x 17592
    literal(s, true, true, false);
@y
    literal(s, scan_special, false);
@z

%***********************************************************************

@x 17613
procedure pdf_out_literal(p:pointer);
var old_setting:0..max_selector; {holds print |selector|}
    s: str_number;
begin
    old_setting:=selector; selector:=new_string;
    show_token_list(link(pdf_literal_data(p)),null,pool_size-pool_ptr);
    selector:=old_setting;
    s := make_string;
    if pdf_literal_direct(p) = 1 then
        literal(s, false, false, false)
    else
        literal(s, true, false, false);
    flush_str(s);
end;
@y
procedure pdf_out_literal(p:pointer);
var old_setting:0..max_selector; {holds print |selector|}
    s: str_number;
begin
    old_setting:=selector; selector:=new_string;
    show_token_list(link(pdf_literal_data(p)),null,pool_size-pool_ptr);
    selector:=old_setting;
    s := make_string;
    literal(s, pdf_literal_mode(p), false);
    flush_str(s);
end;
@z

%***********************************************************************

@x 17628
procedure pdf_special(p: pointer);
var old_setting:0..max_selector; {holds print |selector|}
    s: str_number;
begin
    old_setting:=selector; selector:=new_string;
    show_token_list(link(write_tokens(p)),null,pool_size-pool_ptr);
    selector:=old_setting;
    s := make_string;
    literal(s, true, true, true);
    flush_str(s);
end;
@y
procedure pdf_special(p: pointer);
var old_setting:0..max_selector; {holds print |selector|}
    s: str_number;
begin
    old_setting:=selector; selector:=new_string;
    show_token_list(link(write_tokens(p)),null,pool_size-pool_ptr);
    selector:=old_setting;
    s := make_string;
    literal(s, scan_special, true);
    flush_str(s);
end;
@z

%***********************************************************************

@x 33200
@ @<Implement \.{\\pdfliteral}@>=
begin
    check_pdfoutput("\pdfliteral", true);
    new_whatsit(pdf_literal_node, write_node_size);
    if scan_keyword("direct") then
        pdf_literal_direct(tail) := 1
    else
        pdf_literal_direct(tail) := 0;
    scan_pdf_ext_toks;
    pdf_literal_data(tail) := def_ref;
end
@y
@ @<Implement \.{\\pdfliteral}@>=
begin
    check_pdfoutput("\pdfliteral", true);
    new_whatsit(pdf_literal_node, write_node_size);
    if scan_keyword("direct") then
        pdf_literal_mode(tail) := direct_always
    else if scan_keyword("page") then
        pdf_literal_mode(tail) := direct_page
    else
        pdf_literal_mode(tail) := reset_origin;
    scan_pdf_ext_toks;
    pdf_literal_data(tail) := def_ref;
end
@z

%***********************************************************************

@x 34308
pdf_literal_node: begin
    print_esc("pdfliteral");
    if pdf_literal_direct(p) > 0 then
        print(" direct");
    print_mark(pdf_literal_data(p));
@y
pdf_literal_node: begin
    print_esc("pdfliteral");
    case pdf_literal_mode(p) of
    reset_origin:
        do_nothing;
    direct_page:
        print(" page");
    direct_always:
        print(" direct");
    othercases confusion("literal2")
    endcases;
    print_mark(pdf_literal_data(p));
@z

%***********************************************************************
