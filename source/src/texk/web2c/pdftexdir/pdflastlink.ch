% WEB change file to introduce pdflastlink
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
% \pdflastlink (read-only integer)
%
% This primitive returns the object number of the last 
% object created with \pdfstartlink
%
% Tested with pdftex 1.30
% Ralf Utermann, ralf.utermann@physik.uni-augsburg.de, August 17, 2005.
%
% It turns out that when a node list is copied, the sixth field of an
% annot whatsit is not carried over to the copy. This caused crashes.
% I've added a line to copy this sixth field. Hope this is ok now.
% Taco Hoekwater. December 12, 2005
%
@x
@d pdftex_last_item_codes     = pdftex_first_rint_code + 12 {end of \pdfTeX's command codes}
@y
@d pdf_last_link_code        = pdftex_first_rint_code + 13 {code for \.{\\pdflastlink}}
@d pdftex_last_item_codes     = pdftex_first_rint_code + 13 {end of \pdfTeX's command codes}
@z

@x
primitive("pdflastannot",last_item,pdf_last_annot_code);@/
@!@:pdf_last_annot_}{\.{\\pdflastannot} primitive@>
@y
primitive("pdflastannot",last_item,pdf_last_annot_code);@/
@!@:pdf_last_annot_}{\.{\\pdflastannot} primitive@>
primitive("pdflastlink",last_item,pdf_last_link_code);@/
@!@:pdf_last_link_}{\.{\\pdflastlink} primitive@>
@z

@x
  pdf_last_annot_code:  print_esc("pdflastannot");
@y
  pdf_last_annot_code:  print_esc("pdflastannot");
  pdf_last_link_code:   print_esc("pdflastlink");
@z

@x
  pdf_last_annot_code:  cur_val := pdf_last_annot;
@y
  pdf_last_annot_code:  cur_val := pdf_last_annot;
  pdf_last_link_code:   cur_val := pdf_last_link;
@z

@x l. 14910
@d pdf_annot_objnum(#)     == mem[# + 6].int {object number of corresponding object}
@y
@d pdf_annot_objnum(#)     == mem[# + 6].int {object number of corresponding object}
@d pdf_link_objnum(#)      == mem[# + 6].int {object number of corresponding object}
@z

@x l. 31759
@ @<Implement \.{\\pdfstartlink}@>=
begin
    check_pdfoutput("\pdfstartlink", true);
    if abs(mode) = vmode then
        pdf_error("ext1", "\pdfstartlink cannot be used in vertical mode");
    new_annot_whatsit(pdf_start_link_node, pdf_annot_node_size);
    pdf_link_action(tail) := scan_action;
end
@y
@ pdflastlink needs an extra global variable
@<Glob...@>=
@!pdf_last_link: integer;

@ @<Implement \.{\\pdfstartlink}@>=
begin
    check_pdfoutput("\pdfstartlink", true);
    if abs(mode) = vmode then
        pdf_error("ext1", "\pdfstartlink cannot be used in vertical mode");
    k := pdf_new_objnum;
    new_annot_whatsit(pdf_start_link_node, pdf_annot_node_size);
    pdf_link_action(tail) := scan_action;
    pdf_link_objnum(tail) := k;
    pdf_last_link := k;
end
@z

@x l. 32444 This is a synchronization trick
@ @<Make a partial copy of the whatsit...@>=
@y
@ @<Make a partial copy of the whatsit...@>=
@z

@x
pdf_start_link_node: begin
    r := get_node(pdf_annot_node_size);
    pdf_height(r) := pdf_height(p);
    pdf_depth(r)  := pdf_depth(p);
    pdf_width(r)  := pdf_width(p);
    pdf_link_attr(r) := pdf_link_attr(p);
    if pdf_link_attr(r) <> null then
        add_token_ref(pdf_link_attr(r));
    pdf_link_action(r) := pdf_link_action(p);
    add_action_ref(pdf_link_action(r));
@y
pdf_start_link_node: begin
    r := get_node(pdf_annot_node_size);
    pdf_height(r) := pdf_height(p);
    pdf_depth(r)  := pdf_depth(p);
    pdf_width(r)  := pdf_width(p);
    pdf_link_attr(r) := pdf_link_attr(p);
    if pdf_link_attr(r) <> null then
        add_token_ref(pdf_link_attr(r));
    pdf_link_action(r) := pdf_link_action(p);
    add_action_ref(pdf_link_action(r));
    pdf_link_objnum(r) := pdf_link_objnum(p);
@z

@x l. 33040
    pdf_create_obj(obj_type_others, 0);
    obj_annot_ptr(obj_ptr) := p;
    pdf_append_list(obj_ptr)(pdf_link_list);
end;
@y
    obj_annot_ptr(pdf_link_objnum(p)) := p;
    pdf_append_list(pdf_link_objnum(p))(pdf_link_list);
end;
@z

