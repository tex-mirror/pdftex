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

@x
@d pdf_annot_objnum(#)     == mem[# + 6].int {object number of corresponding object}
@y
@d pdf_annot_objnum(#)     == mem[# + 6].int {object number of corresponding object}
@d pdf_link_objnum(#)      == mem[# + 6].int {object number of corresponding object}
@z

@x
        pdf_annot_data(tail) := def_ref;
        pdf_last_annot := k;
    end
end
@y
        pdf_annot_data(tail) := def_ref;
        pdf_last_annot := k;
    end
end

@ @<Glob...@>=
@!pdf_last_link: integer;

@z

@x
        pdf_error("ext1", "\pdfstartlink cannot be used in vertical mode");
@y
        pdf_error("ext1", "\pdfstartlink cannot be used in vertical mode");
    k := pdf_new_objnum;
@z

@x
    new_annot_whatsit(pdf_start_link_node, pdf_annot_node_size);
@y
    new_annot_whatsit(pdf_start_link_node, pdf_annot_node_size);
    pdf_link_objnum(tail) := k;
@z

@x
    pdf_link_action(tail) := scan_action;
@y
    pdf_link_action(tail) := scan_action;
    pdf_last_link := k;
@z



@x
    obj_annot_ptr(obj_ptr) := p;
    pdf_append_list(obj_ptr)(pdf_link_list);
@y
    obj_annot_ptr(pdf_link_objnum(p)) := p;
    pdf_append_list(pdf_link_objnum(p))(pdf_link_list);
@z

