% WEB change file containing the \pdfstrcmp extension for pdfTeX 
%
% Copyright (c) 2004 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
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
% $Id: strcmp.ch,v 1.2 2004/07/30 07:12:48 olaf Exp $

@x [416]
@d pdftex_last_item_codes     = pdftex_first_rint_code + 7 {end of \pdfTeX's command codes}
@y
@d pdf_strcmp_result_code     = pdftex_first_rint_code + 8 {result of \.{\\pdfstrcmp}}
@d pdftex_last_item_codes     = pdftex_first_rint_code + 8 {end of \pdfTeX's command codes}
@z

@x [416]
primitive("pdflastypos",last_item,pdf_last_y_pos_code);@/
@!@:pdf_last_y_pos_}{\.{\\pdflastypos} primitive@>
@y
primitive("pdflastypos",last_item,pdf_last_y_pos_code);@/
@!@:pdf_last_y_pos_}{\.{\\pdflastypos} primitive@>
primitive("pdfstrcmpresult",last_item,pdf_strcmp_result_code);@/
@!@:pdf_strcmp_result_}{\.{\\pdfstrcmpresult} primitive@>
@z

@x [417]
  pdf_last_y_pos_code:  print_esc("pdflastypos");
@y
  pdf_last_y_pos_code:  print_esc("pdflastypos");
  pdf_strcmp_result_code: print_esc("pdfstrcmpresult");
@z

@x [424]
  pdf_last_y_pos_code:  cur_val := pdf_last_y_pos;
@y
  pdf_last_y_pos_code:  cur_val := pdf_last_y_pos;
  pdf_strcmp_result_code:  cur_val := pdf_strcmp_result;
@z

@x [1344]
@d pdftex_last_extension_code  == pdftex_first_extension_code + 24
@y
@d pdf_strcmp_code             == pdftex_first_extension_code + 25
@d pdftex_last_extension_code  == pdftex_first_extension_code + 25
@z

@x [1344]
primitive("pdfliteral",extension,pdf_literal_node);@/
@!@:pdf_literal_}{\.{\\pdfliteral} primitive@>
@y
primitive("pdfliteral",extension,pdf_literal_node);@/
@!@:pdf_literal_}{\.{\\pdfliteral} primitive@>
primitive("pdfstrcmp",extension,pdf_strcmp_code);@/
@!@:pdf_strcmp_}{\.{\\pdfstrcmp} primitive@>
@z

@x [1348]
pdf_literal_node: @<Implement \.{\\pdfliteral}@>;
@y
pdf_literal_node: @<Implement \.{\\pdfliteral}@>;
pdf_strcmp_code: @<Implement \.{\\pdfstrcmp}@>;
@z

@x [1354]
@ @<Implement \.{\\pdfliteral}@>=
@y
@ @<Declare procedures needed in |do_ext...@>=
procedure compare_strings;
label done;
var s1, s2: str_number;
    i1, i2, j1, j2: pool_pointer;
    result: integer;
begin
    call_func(scan_toks(false, true));
    s1 := tokens_to_string(def_ref);
    delete_token_ref(def_ref);
    call_func(scan_toks(false, true));
    s2 := tokens_to_string(def_ref);
    delete_token_ref(def_ref);
    i1 := str_start[s1];
    j1 := str_start[s1 + 1];
    i2 := str_start[s2];
    j2 := str_start[s2 + 1];
    while (i1 < j1) and (i2 < j2) do begin
        if str_pool[i1] < str_pool[i2] then begin
            result := -1;
            goto done;
        end;
        if str_pool[i1] > str_pool[i2] then begin
            result := 1;
            goto done;
        end;
        incr(i1);
        incr(i2);
    end;
    if (i1 = j1) and (i2 = j2) then
        result := 0
    else if i1 < j1 then
        result := 1
    else
        result := -1;
done:
    pdf_strcmp_result := result;
    flush_str(s2);
    flush_str(s1);
end;

@ @<Implement \.{\\pdfstrcmp}@>=
compare_strings

@ @<Glob...@>=
@!pdf_strcmp_result: integer;

@ @<Implement \.{\\pdfliteral}@>=
@z
