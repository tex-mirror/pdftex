% WEB change file containing code for pdfTeX feature extending TeX;
% to be applied to tex.web (Version 3.14159) in order to define the
% pdfTeX program.
%
% (WEB2C!) indicates parts that may need adjusting in tex.pch
% (ETEX!) indicates parts that may need adjusting in pdfetex.ch[12]
%
% Copyright (c) 1996-2003 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
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
% $Id: //depot/Build/source/TeX/texk/web2c/pdftexdir/pdftex.ch#18 $
%
% The TeX program is copyright (C) 1982 by D. E. Knuth.
% TeX is a trademark of the American Mathematical Society.
%
% all pdfTeX new primitives have the prefix "\pdf", apart from:
%   o  extension of \vadjust 
%   o  extension of \font
%   o  \efcode
%   o  \lpcode, \rpcode
    
@x limbo
\def\PASCAL{Pascal}
@y
\def\PASCAL{Pascal}
\def\pdfTeX{pdf\TeX}
\def\PDF{PDF}
@z

@x [2] - This change is made for TeX 3.14159
@d banner=='This is TeX, Version 3.141592' {printed when \TeX\ starts}
@y
@d banner=='This is pdfTeX, Version 3.141592','-',pdftex_version_string
   {printed when \pdfTeX\ starts}
@d pdftex_version==111 { \.{\\pdftexversion} }
@d pdftex_revision=="b" { \.{\\pdftexrevision} }
@d pdftex_version_string=='1.11b' {current pdf\TeX\ version}

@z

@x [142] - pre vadjust
@d adjust_node=5 {|type| of an adjust node}
@y
@d adjust_node=5 {|type| of an adjust node}
@d adjust_pre == subtype  {pre-adjustment?}
@z

@x [155] - margin kerning
@d acc_kern=2 {|subtype| of kern nodes from accents}
@y
@d acc_kern=2 {|subtype| of kern nodes from accents}
@d margin_kern_node = 40
@d margin_kern_node_size = 3
@d margin_char(#) == info(# + 2)
@d left_side == 0
@d right_side == 1
@z


@x [162] - pre vadjust
@d backup_head==mem_top-13 {head of token list built by |scan_keyword|}
@d hi_mem_stat_min==mem_top-13 {smallest statically allocated word in
  the one-word |mem|}
@d hi_mem_stat_usage=14 {the number of one-word nodes always present}
@y
@d backup_head==mem_top-13 {head of token list built by |scan_keyword|}
@d pre_adjust_head==mem_top-14  {head of pre-adjustment list returned by |hpack|}
@d hi_mem_stat_min==mem_top-14 {smallest statically allocated word in
  the one-word |mem|}
@d hi_mem_stat_usage=15 {the number of one-word nodes always present}
@z

% Some procedures that need to be declared forward
@x [173]
@* \[12] Displaying boxes.
@y
@<Declare procedures that need to be declared forward for pdftex@>
@* \[12] Displaying boxes.
@z

@x [174] - displaying fonts
        print_char(" "); font_in_short_display:=font(p);
@y
        font_in_short_display:=font(p);
@z

@x [176] - displaying fonts
  print_char(" "); print_ASCII(qo(character(p)));
@y
  print_ASCII(qo(character(p)));
@z

@x [183] - margin kerning
  kern_node: @<Display kern |p|@>;
@y
  margin_kern_node: begin
    print_esc("kern");
    print_scaled(width(p));
    if subtype(p) = left_side then
        print(" (left margin)")
    else
        print(" (right margin)");
  end;
  kern_node: @<Display kern |p|@>;
@z

@x [197] - pre vadjust
begin print_esc("vadjust"); node_list_display(adjust_ptr(p)); {recursive call}
@y
begin print_esc("vadjust"); if adjust_pre(p) <> 0 then print(" pre ");
node_list_display(adjust_ptr(p)); {recursive call}
@z

@x [202] - margin kerning
    kern_node,math_node,penalty_node: do_nothing;
@y
    margin_kern_node: begin
        free_avail(margin_char(p));
        free_node(p, margin_kern_node_size);
        goto done;
    end;
    kern_node,math_node,penalty_node: do_nothing;
@z

@x [206] - margin kerning
kern_node,math_node,penalty_node: begin r:=get_node(small_node_size);
  words:=small_node_size;
  end;
@y
margin_kern_node: begin
    r := get_node(margin_kern_node_size);
    fast_get_avail(margin_char(r));
    font(margin_char(r)) := font(margin_char(p));
    character(margin_char(r)) := character(margin_char(p));
    words := small_node_size;
end;
kern_node,math_node: begin 
    r := get_node(small_node_size);
    words:=small_node_size;
end;
penalty_node: begin
    r := get_node(small_node_size);
    penalty(r) := penalty(p);
    if (pdf_max_penalty <> 0) and (penalty(r) > pdf_max_penalty) then
        penalty(r) := pdf_max_penalty;
    if (pdf_min_penalty <> 0) and (penalty(r) < pdf_min_penalty) then
        penalty(r) := pdf_min_penalty;
end;
@z

% Define pdftex tokens parameters (ETEX!)
@x [230]
@d err_help_loc=local_base+9 {points to token list for \.{\\errhelp}}
@d toks_base=local_base+10 {table of 256 token list registers}
@y
@d pdf_pages_attr_loc=local_base+9 {points to token list for \.{\\pdfpagesattr}}
@d pdf_page_attr_loc=local_base+10 {points to token list for \.{\\pdfpageattr}}
@d pdf_page_resources_loc=local_base+11 {points to token list for \.{\\pdfpageresources}}
@d err_help_loc=local_base+12 {points to token list for \.{\\errhelp}}
@d toks_base=local_base+13 {table of 256 token list registers}
@z

@x [230]
@d err_help==equiv(err_help_loc)
@y
@d pdf_pages_attr==equiv(pdf_pages_attr_loc)
@d pdf_page_attr==equiv(pdf_page_attr_loc)
@d pdf_page_resources==equiv(pdf_page_resources_loc)
@d err_help==equiv(err_help_loc)
@z

@x [230]
primitive("errhelp",assign_toks,err_help_loc);
@!@:err_help_}{\.{\\errhelp} primitive@>
@y
primitive("pdfpagesattr",assign_toks,pdf_pages_attr_loc);
@!@:pdf_pages_attr_}{\.{\\pdfpagesattr} primitive@>
primitive("pdfpageattr",assign_toks,pdf_page_attr_loc);
@!@:pdf_page_attr_}{\.{\\pdfpageattr} primitive@>
primitive("pdfpageresources",assign_toks,pdf_page_resources_loc);
@!@:pdf_page_resources_}{\.{\\pdfpageresources} primitive@>
primitive("errhelp",assign_toks,err_help_loc);
@!@:err_help_}{\.{\\errhelp} primitive@>
@z

@x [231]
  othercases print_esc("errhelp")
@y
  pdf_pages_attr_loc: print_esc("pdfpagesattr");
  pdf_page_attr_loc: print_esc("pdfpageattr");
  pdf_page_resources_loc: print_esc("pdfpageresources");
  othercases print_esc("errhelp")
@z

% Define pdftex integer parameters -- (WEB2C!)
@x [236]
@d error_context_lines_code=54 {maximum intermediate line pairs shown}
@y
@d error_context_lines_code=54 {maximum intermediate line pairs shown}
@d pdf_output_code           = 55 {switch on PDF output if positive}
@d pdf_adjust_spacing_code   = 56 {level of spacing adjusting}
@d pdf_compress_level_code   = 57 {compress level of streams}
@d pdf_decimal_digits_code   = 58 {digits after the decimal point of numbers}
@d pdf_move_chars_code       = 59 {move chars 0..31 to higher area if possible}
@d pdf_image_resolution_code = 60 {default image resolution}
@d pdf_pk_resolution_code    = 61 {default resolution of PK font}
@d pdf_unique_resname_code   = 62 {generate unique names for resouces}
@d pdf_protrude_chars_code   = 63 {protrude chars at left/right edge of paragraphs}
@d pdf_avoid_overfull_code   = 64 {try to avoid overfull boxes?}
@d pdf_max_penalty_code      = 65 {maximal allowed value of penalty for copying}
@d pdf_min_penalty_code      = 66 {minimal allowed value of penalty for copying}
@d pdf_option_pdf_minor_version_code = 70 {fractional part of the pdf version produced}
@d pdf_option_always_use_pdfpagebox_code = 71 {if the pdf inclusion should 
   always use a specific pdf page box}
@d pdf_option_pdf_inclusion_errorlevel_code = 72 {if the pdf inclusion should treat 
   pdfs newer than pdf_option_pdf_minor_version as an error}
@# {N.B.: don't forget to check for |char_sub_def_min_code|,...,|int_pars| in
   \.{tex.pch}} 
@z

@x [236]
@d error_context_lines==int_par(error_context_lines_code)
@y
@d error_context_lines==int_par(error_context_lines_code)
@d pdf_output           == int_par(pdf_output_code)
@d pdf_adjust_spacing   == int_par(pdf_adjust_spacing_code)
@d pdf_compress_level   == int_par(pdf_compress_level_code)
@d pdf_decimal_digits   == int_par(pdf_decimal_digits_code)
@d pdf_move_chars       == int_par(pdf_move_chars_code)
@d pdf_image_resolution == int_par(pdf_image_resolution_code)
@d pdf_pk_resolution    == int_par(pdf_pk_resolution_code)
@d pdf_unique_resname   == int_par(pdf_unique_resname_code)
@d pdf_protrude_chars   == int_par(pdf_protrude_chars_code)
@d pdf_avoid_overfull   == int_par(pdf_avoid_overfull_code)
@d pdf_max_penalty      == int_par(pdf_max_penalty_code)
@d pdf_min_penalty      == int_par(pdf_min_penalty_code)
@d pdf_option_pdf_minor_version == int_par(pdf_option_pdf_minor_version_code)
@d pdf_option_always_use_pdfpagebox == int_par(pdf_option_always_use_pdfpagebox_code)
@d pdf_option_pdf_inclusion_errorlevel == int_par(pdf_option_pdf_inclusion_errorlevel_code)
@z

@x [237]
error_context_lines_code:print_esc("errorcontextlines");
@y
error_context_lines_code:print_esc("errorcontextlines");
pdf_output_code:           print_esc("pdfoutput");
pdf_adjust_spacing_code:   print_esc("pdfadjustspacing");
pdf_compress_level_code:   print_esc("pdfcompresslevel");
pdf_decimal_digits_code:   print_esc("pdfdecimaldigits");
pdf_move_chars_code:       print_esc("pdfmovechars");
pdf_image_resolution_code: print_esc("pdfimageresolution");
pdf_pk_resolution_code:    print_esc("pdfpkresolution");
pdf_unique_resname_code:   print_esc("pdfuniqueresname");
pdf_protrude_chars_code:   print_esc("pdfprotrudechars");
pdf_avoid_overfull_code:   print_esc("pdfavoidoverfull");
pdf_max_penalty_code:      print_esc("pdfmaxpenalty");
pdf_min_penalty_code:      print_esc("pdfminpenalty");
pdf_option_pdf_minor_version_code: print_esc("pdfoptionpdfminorversion");
pdf_option_always_use_pdfpagebox_code: print_esc("pdfoptionalwaysusepdfpagebox");
pdf_option_pdf_inclusion_errorlevel_code: print_esc("pdfoptionpdfinclusionerrorlevel");
@z

@x [238]
primitive("errorcontextlines",assign_int,int_base+error_context_lines_code);@/
@!@:error_context_lines_}{\.{\\errorcontextlines} primitive@>
@y
primitive("errorcontextlines",assign_int,int_base+error_context_lines_code);@/
@!@:error_context_lines_}{\.{\\errorcontextlines} primitive@>
primitive("pdfoutput",assign_int,int_base+pdf_output_code);@/
@!@:pdf_output_}{\.{\\pdfoutput} primitive@>
primitive("pdfadjustspacing",assign_int,int_base+pdf_adjust_spacing_code);@/
@!@:pdf_adjust_spacing_}{\.{\\pdfadjustspacing} primitive@>
primitive("pdfcompresslevel",assign_int,int_base+pdf_compress_level_code);@/
@!@:pdf_compress_level_}{\.{\\pdfcompresslevel} primitive@>
primitive("pdfdecimaldigits",assign_int,int_base+pdf_decimal_digits_code);@/
@!@:pdf_decimal_digits_}{\.{\\pdfdecimaldigits} primitive@>
primitive("pdfmovechars",assign_int,int_base+pdf_move_chars_code);@/
@!@:pdf_move_chars_}{\.{\\pdfmovechars} primitive@>
primitive("pdfimageresolution",assign_int,int_base+pdf_image_resolution_code);@/
@!@:pdf_image_resolution_}{\.{\\pdfimageresolution} primitive@>
primitive("pdfpkresolution",assign_int,int_base+pdf_pk_resolution_code);@/
@!@:pdf_pk_resolution_}{\.{\\pdfpkresolution} primitive@>
primitive("pdfuniqueresname",assign_int,int_base+pdf_unique_resname_code);@/
@!@:pdf_unique_resname_}{\.{\\pdfuniqueresname} primitive@>
primitive("pdfprotrudechars",assign_int,int_base+pdf_protrude_chars_code);@/
@!@:pdf_protrude_chars_}{\.{\\pdfprotrudechars} primitive@>
primitive("pdfavoidoverfull",assign_int,int_base+pdf_avoid_overfull_code);@/
@!@:pdf_avoid_overfull_}{\.{\\pdfavoidoverfull} primitive@>
primitive("pdfmaxpenalty",assign_int,int_base+pdf_max_penalty_code);@/
@!@:pdf_max_penalty_}{\.{\\pdfmaxpenalty} primitive@>
primitive("pdfminpenalty",assign_int,int_base+pdf_min_penalty_code);@/
@!@:pdf_min_penalty_}{\.{\\pdfminpenalty} primitive@>
primitive("pdfoptionpdfminorversion",assign_int,int_base+pdf_option_pdf_minor_version_code);@/
@!@:pdf_option_pdf_minor_version_}{\.{\\pdfoptionpdfminorversion} primitive@>
primitive("pdfoptionalwaysusepdfpagebox",assign_int,int_base+pdf_option_always_use_pdfpagebox_code);@/
@!@:pdf_option_always_use_pdfpagebox_}{\.{\\pdfoptionalwaysusepdfpagebox} primitive@>
primitive("pdfoptionpdfinclusionerrorlevel",assign_int,int_base+pdf_option_pdf_inclusion_errorlevel_code);@/
@!@:pdf_option_pdf_inclusion_errorlevel_}{\.{\\pdfoptionpdfinclusionerrorlevel} primitive@>
@z

% Define pdftex dimension parameters
@x [247]
@d emergency_stretch_code=20 {reduces badnesses on final pass of line-breaking}
@d dimen_pars=21 {total number of dimension parameters}
@y
@d emergency_stretch_code=20 {reduces badnesses on final pass of line-breaking}
@d pdf_h_origin_code      = 21 {horigin of the PDF output}
@d pdf_v_origin_code      = 22 {horigin of the PDF output}
@d pdf_page_width_code    = 23 {page width of the PDF output}
@d pdf_page_height_code   = 24 {page height of the PDF output}
@d pdf_link_margin_code   = 25 {link margin in the PDF output}
@d pdf_dest_margin_code   = 26 {dest margin in the PDF output}
@d pdf_thread_margin_code = 27 {thread margin in the PDF output}
@d dimen_pars             = 28 {total number of dimension parameters}
@z

@x [247]
@d emergency_stretch==dimen_par(emergency_stretch_code)
@y
@d emergency_stretch==dimen_par(emergency_stretch_code)
@d pdf_h_origin      == dimen_par(pdf_h_origin_code)
@d pdf_v_origin      == dimen_par(pdf_v_origin_code)
@d pdf_page_width    == dimen_par(pdf_page_width_code)
@d pdf_page_height   == dimen_par(pdf_page_height_code)
@d pdf_link_margin   == dimen_par(pdf_link_margin_code)
@d pdf_dest_margin   == dimen_par(pdf_dest_margin_code)
@d pdf_thread_margin == dimen_par(pdf_thread_margin_code)
@z

@x [247]
emergency_stretch_code:print_esc("emergencystretch");
@y
emergency_stretch_code:print_esc("emergencystretch");
pdf_h_origin_code:      print_esc("pdfhorigin");
pdf_v_origin_code:      print_esc("pdfvorigin");
pdf_page_width_code:    print_esc("pdfpagewidth");
pdf_page_height_code:   print_esc("pdfpageheight");
pdf_link_margin_code:   print_esc("pdflinkmargin");
pdf_dest_margin_code:   print_esc("pdfdestmargin");
pdf_thread_margin_code: print_esc("pdfthreadmargin");
@z

@x [248]
primitive("emergencystretch",assign_dimen,dimen_base+emergency_stretch_code);@/
@!@:emergency_stretch_}{\.{\\emergencystretch} primitive@>
@y
primitive("emergencystretch",assign_dimen,dimen_base+emergency_stretch_code);@/
@!@:emergency_stretch_}{\.{\\emergencystretch} primitive@>
primitive("pdfhorigin",assign_dimen,dimen_base+pdf_h_origin_code);@/
@!@:pdf_h_origin_}{\.{\\pdfhorigin} primitive@>
primitive("pdfvorigin",assign_dimen,dimen_base+pdf_v_origin_code);@/
@!@:pdf_v_origin_}{\.{\\pdfvorigin} primitive@>
primitive("pdfpagewidth",assign_dimen,dimen_base+pdf_page_width_code);@/
@!@:pdf_page_width_}{\.{\\pdfpagewidth} primitive@>
primitive("pdfpageheight",assign_dimen,dimen_base+pdf_page_height_code);@/
@!@:pdf_page_height_}{\.{\\pdfpageheight} primitive@>
primitive("pdflinkmargin",assign_dimen,dimen_base+pdf_link_margin_code);@/
@!@:pdf_link_margin_}{\.{\\pdflinkmargin} primitive@>
primitive("pdfdestmargin",assign_dimen,dimen_base+pdf_dest_margin_code);@/
@!@:pdf_dest_margin_}{\.{\\pdfdestmargin} primitive@>
primitive("pdfthreadmargin",assign_dimen,dimen_base+pdf_thread_margin_code);@/
@!@:pdf_thread_margin_}{\.{\\pdfthreadmargin} primitive@>
@z

@x [267] - displaying fonts
@<Print the font identifier for |font(p)|@>=
print_esc(font_id_text(font(p)))
@y
@<Print the font identifier for |font(p)|@>=
begin
    print("/");
    print(font_name[font(p)]);
    if font_size[font(p)] <> font_dsize[font(p)] then begin 
        print("@@");
        print_scaled(font_size[font(p)]);
        print("pt");
    end;
    print("/");
end
@z

% Define pdftex tokens parameters
@x [307]
@d write_text=15 {|token_type| code for \.{\\write}}
@y
@d write_text=15 {|token_type| code for \.{\\write}}
@d pdf_pages_attr_text  = 16 {|token_type| code for \.{\\pdfpagesattr}}
@d pdf_page_attr_text  = 17 {|token_type| code for \.{\\pdfpageattr}}
@d pdf_page_resources_text = 18 {|token_type| code for \.{\\pdfpageresources}}
@z

@x [314]
write_text: print_nl("<write> ");
othercases print_nl("?") {this should never happen}
@y
write_text: print_nl("<write> ");
pdf_pages_attr_text:  print_nl("<pdfpagesattr> ");
pdf_page_attr_text:  print_nl("<pdfpageattr> ");
pdf_page_resources_text: print_nl("<pdfpageresources> ");
othercases print_nl("?") {this should never happen}
@z

% Define some read-only pdfTeX primitives
@x [410]
@d tok_val=5 {token lists}
@y
@d tok_val=5 {token lists}
@d pdftex_revision_code   = 6  {command code for \.{\\pdftexrevision}}
@d pdf_font_name_code     = 7  {command code for \.{\\pdffontname}}
@d pdf_font_objnum_code   = 8  {command code for \.{\\pdffontobjnum}}
@d pdf_font_size_code     = 9  {command code for \.{\\pdffontsize}}
@z

@x [413] - HZ
var m:halfword; {|chr_code| part of the operand token}
@y
var m:halfword; {|chr_code| part of the operand token}
    n, k: integer; {accumulators}
@z

@x [416]
|glue_val|, |input_line_no_code|, or |badness_code|.

@d input_line_no_code=glue_val+1 {code for \.{\\inputlineno}}
@d badness_code=glue_val+2 {code for \.{\\badness}}
@y
|glue_val|, |input_line_no_code|, |badness_code|, or one of the other codes for
\pdfTeX{} extensions.

@d input_line_no_code=glue_val+1 {code for \.{\\inputlineno}}
@d badness_code=glue_val+2 {code for \.{\\badness}}
@d pdftex_version_code     = glue_val + 3 {code for \.{\\pdftexversion}}
@d pdf_last_obj_code       = glue_val + 4 {code for \.{\\pdflastobj}}
@d pdf_last_xform_code     = glue_val + 5 {code for \.{\\pdflastxform}}
@d pdf_last_ximage_code    = glue_val + 6 {code for \.{\\pdflastximage}}
@d pdf_last_ximage_pages_code = glue_val + 7 {code for \.{\\pdflastximagepages}}
@d pdf_last_annot_code     = glue_val + 8 {code for \.{\\pdflastannot}}
@d pdf_last_x_pos_code     = glue_val + 9 {code for \.{\\pdflastxpos}}
@d pdf_last_y_pos_code     = glue_val + 10 {code for \.{\\pdflastypos}}
@d pdf_last_demerits_code  = glue_val + 11 {code for \.{\\pdflastdemerits}}
@d pdf_last_vbreak_penalty_code = glue_val + 12 {code for \.{\\pdflastvbreakpenalty}}
@# {N.B.: don't forget to check \.{pdfetex.ch2}} 
@z

@x [416]
primitive("badness",last_item,badness_code);
@!@:badness_}{\.{\\badness} primitive@>
@y
primitive("badness",last_item,badness_code);@/
@!@:badness_}{\.{\\badness} primitive@>
primitive("pdftexversion",last_item,pdftex_version_code);@/
@!@:pdftex_version_}{\.{\\pdftexversion} primitive@>
primitive("pdflastobj",last_item,pdf_last_obj_code);@/
@!@:pdf_last_obj_}{\.{\\pdflastobj} primitive@>
primitive("pdflastxform",last_item,pdf_last_xform_code);@/
@!@:pdf_last_xform_}{\.{\\pdflastxform} primitive@>
primitive("pdflastximage",last_item,pdf_last_ximage_code);@/
@!@:pdf_last_ximage_}{\.{\\pdflastximage} primitive@>
primitive("pdflastximagepages",last_item,pdf_last_ximage_pages_code);@/
@!@:pdf_last_ximage_pages_}{\.{\\pdflastximagepages} primitive@>
primitive("pdflastannot",last_item,pdf_last_annot_code);@/
@!@:pdf_last_annot_}{\.{\\pdflastannot} primitive@>
primitive("pdflastxpos",last_item,pdf_last_x_pos_code);@/
@!@:pdf_last_x_pos_}{\.{\\pdflastxpos} primitive@>
primitive("pdflastypos",last_item,pdf_last_y_pos_code);@/
@!@:pdf_last_y_pos_}{\.{\\pdflastypos} primitive@>
primitive("pdflastdemerits",last_item,pdf_last_demerits_code);@/
@!@:pdf_last_demerits_}{\.{\\pdflastdemerits} primitive@>
primitive("pdflastvbreakpenalty",last_item,pdf_last_vbreak_penalty_code);@/
@!@:pdf_last_vbreak_penalty_}{\.{\\pdflastvbreakpenalty} primitive@>
primitive("pdftexrevision",convert,pdftex_revision_code);@/
@!@:pdftex_revision_}{\.{\\pdftexrevision} primitive@>
primitive("pdffontname",convert,pdf_font_name_code);@/
@!@:pdf_font_name_}{\.{\\pdffontname} primitive@>
primitive("pdffontobjnum",convert,pdf_font_objnum_code);@/
@!@:pdf_font_objnum_}{\.{\\pdffontobjnum} primitive@>
primitive("pdffontsize",convert,pdf_font_size_code);@/
@!@:pdf_font_size_}{\.{\\pdffontsize} primitive@>
@z

@x [417]
  othercases print_esc("badness")
@y
  pdftex_version_code:  print_esc("pdftexversion");
  pdf_last_obj_code:    print_esc("pdflastobj");
  pdf_last_xform_code:  print_esc("pdflastxform");
  pdf_last_ximage_code: print_esc("pdflastximage");
  pdf_last_ximage_pages_code: print_esc("pdflastximagepages");
  pdf_last_annot_code:  print_esc("pdflastannot");
  pdf_last_x_pos_code:  print_esc("pdflastxpos");
  pdf_last_y_pos_code:  print_esc("pdflastypos");
  pdf_last_demerits_code:  print_esc("pdflastdemerits");
  pdf_last_vbreak_penalty_code:  print_esc("pdflastvbreakpenalty");
  othercases print_esc("badness")
@z

@x [424]
if cur_chr>glue_val then
  begin if cur_chr=input_line_no_code then cur_val:=line
  else cur_val:=last_badness; {|cur_chr=badness_code|}
@y
if cur_chr>glue_val then
  begin case cur_chr of
  input_line_no_code: cur_val:=line;
  badness_code: cur_val:=last_badness;
  pdftex_version_code:  cur_val := pdftex_version;
  pdf_last_obj_code:    cur_val := pdf_last_obj;
  pdf_last_xform_code:  cur_val := pdf_last_xform;
  pdf_last_ximage_code: cur_val := pdf_last_ximage;
  pdf_last_ximage_pages_code: cur_val := pdf_last_ximage_pages;
  pdf_last_annot_code:  cur_val := pdf_last_annot;
  pdf_last_x_pos_code:  cur_val := pdf_last_x_pos;
  pdf_last_y_pos_code:  cur_val := pdf_last_y_pos;
  pdf_last_demerits_code:  cur_val := fewest_demerits;
  pdf_last_vbreak_penalty_code:  cur_val := last_vbreak_penalty;
  endcases;
@z

@x [426]
begin scan_font_ident;
if m=0 then scanned_result(hyphen_char[cur_val])(int_val)
else scanned_result(skew_char[cur_val])(int_val);
@y
begin scan_font_ident;
if m=0 then scanned_result(hyphen_char[cur_val])(int_val)
else if m=1 then scanned_result(skew_char[cur_val])(int_val)
else begin
    n := cur_val;
    scan_char_num;
    k := cur_val;
    case m of 
    lp_code_base: scanned_result(get_lp_code(n, k))(int_val);
    rp_code_base: scanned_result(get_rp_code(n, k))(int_val);
    ef_code_base: scanned_result(get_ef_code(n, k))(int_val);
    end;
end;
@z

@x [469]
  othercases print_esc("jobname")
@y
  pdftex_revision_code:  print_esc("pdftexrevision");
  pdf_font_name_code:     print_esc("pdffontname");
  pdf_font_objnum_code:   print_esc("pdffontobjnum");
  pdf_font_size_code:     print_esc("pdffontsize");
  othercases print_esc("jobname")
@z

@x [471]
end {there are no other cases}
@y
pdftex_revision_code: do_nothing;
pdf_font_name_code, pdf_font_objnum_code, pdf_font_size_code: begin
    scan_font_ident;
    if cur_val = null_font then
        pdf_error("font", "invalid font identifier");
    if c <> pdf_font_size_code then begin
        pdf_check_vf(cur_val);
        if not font_used[cur_val] then
            pdf_init_font(cur_val);
    end;
end;
end {there are no other cases}
@z

@x [472]
end {there are no other cases}
@y
pdftex_revision_code: print(pdftex_revision);
pdf_font_name_code, pdf_font_objnum_code: begin
    set_ff(cur_val);
    if c = pdf_font_name_code then
        print_int(obj_info(pdf_font_num[ff]))
    else
        print_int(pdf_font_num[ff]);
end;
pdf_font_size_code: print_scaled(font_size[cur_val]);
end {there are no other cases}
@z

@x [622] - margin kerning
kern_node,math_node:cur_h:=cur_h+width(p);
@y
kern_node,math_node:cur_h:=cur_h+width(p);
margin_kern_node:cur_h:=cur_h+width(p);
@z

% Shipping out to PDF
@x [638]
@ The |hlist_out| and |vlist_out| procedures are now complete, so we are
ready for the |ship_out| routine that gets them started in the first place.

@p procedure ship_out(@!p:pointer); {output the box |p|}
@y
@ The |hlist_out| and |vlist_out| procedures are now complete, so we are
ready for the |dvi_ship_out| routine that gets them started in the first place.

@p procedure dvi_ship_out(@!p:pointer); {output the box |p|}
@z

@x [644]
@* \[33] Packaging.
@y

@* \[32a] \pdfTeX\ basic.

When \pdfTeX{} starts without ``init'', it reads a number of parameters
from the config file before starting input. The values from the config file
thus overwrite \TeX{} parameters that have been set in the format. We want
to use the codes corresponding to \pdfTeX{} parameters
(e.g.~|cfg_output_code|) in~C as well, so we must define the following
constants.

@<Constants...@>=
cfg_output_code = pdf_output_code;
cfg_adjust_spacing_code = pdf_adjust_spacing_code;
cfg_compress_level_code = pdf_compress_level_code;
cfg_decimal_digits_code = pdf_decimal_digits_code;
cfg_move_chars_code = pdf_move_chars_code;
cfg_image_resolution_code = pdf_image_resolution_code;
cfg_pk_resolution_code = pdf_pk_resolution_code;
cfg_unique_resname_code = pdf_unique_resname_code;
cfg_protrude_chars_code = pdf_protrude_chars_code;
cfg_h_origin_code = pdf_h_origin_code;
cfg_v_origin_code = pdf_v_origin_code;
cfg_page_height_code = pdf_page_height_code;
cfg_page_width_code = pdf_page_width_code;
cfg_link_margin_code = pdf_link_margin_code;
cfg_dest_margin_code = pdf_dest_margin_code;
cfg_thread_margin_code = pdf_thread_margin_code;
cfg_pdf12_compliant_code = pdf_thread_margin_code + 1;
cfg_pdf13_compliant_code = cfg_pdf12_compliant_code + 1;
cfg_pdf_minor_version_code = pdf_option_pdf_minor_version_code;
cfg_always_use_pdf_pagebox_code = 71; {must be the same as the definition in epdf.h}
cfg_pdf_option_pdf_inclusion_errorlevel_code = pdf_option_pdf_inclusion_errorlevel_code;

@ Integer parameters are initialized immediately after the config file is
read, but dimension parameters are set when opening the PDF output file.

@d do_pdf_int_pars(#) ==
    #(output_);
    #(adjust_spacing_);
    #(compress_level_);
    #(decimal_digits_);
    #(move_chars_);
    #(image_resolution_);
    #(pk_resolution_);
    #(unique_resname_);
    #(protrude_chars_);

@d do_pdf_dimen_pars(#) ==
    #(h_origin_);
    #(v_origin_);
    #(page_height_);
    #(page_width_);
    #(link_margin_);
    #(dest_margin_);
    #(thread_margin_)

@d get_cfg_int(#) == int_par(cfg_@&#@&code) := cfg_par(cfg_@&#@&code)

@d get_cfg_dimen(#) == dimen_par(cfg_@&#@&code) := cfg_par(cfg_@&#@&code)

@d mag_cfg_dimen(#) ==
    if (dimen_par(cfg_@&#@&code) = cfg_par(cfg_@&#@&code)) and
        is_cfg_truedimen(cfg_@&#@&code)
    then
        dimen_par(cfg_@&#@&code) := 
            round_xn_over_d(dimen_par(cfg_@&#@&code), 1000, mag)

@d get_cfg_int_pars == do_pdf_int_pars(get_cfg_int)
@d get_cfg_dimen_pars == do_pdf_dimen_pars(get_cfg_dimen)
@d mag_cfg_dimen_pars == do_pdf_dimen_pars(mag_cfg_dimen)

@ Here we read the values from the config file and initialize any integer
parameters, e.g. |pdf_option_pdf_minor_version|.

@<Read values from config file if necessary@>=
read_config_file;
get_cfg_int_pars;
get_cfg_dimen_pars;
if pdf_pk_resolution = 0 then
    pdf_pk_resolution := 600;
pdf_option_pdf_minor_version := 4;
if cfg_par(cfg_pdf12_compliant_code) > 0 then
    pdf_option_pdf_minor_version := 2;
if cfg_par(cfg_pdf13_compliant_code) > 0 then
    pdf_option_pdf_minor_version := 3;
if cfg_par(cfg_pdf_minor_version_code) > -1 then
    pdf_option_pdf_minor_version := cfg_par(cfg_pdf_minor_version_code);
pdf_option_always_use_pdfpagebox := cfg_par(cfg_always_use_pdf_pagebox_code);
pdf_option_pdf_inclusion_errorlevel := cfg_par(cfg_pdf_option_pdf_inclusion_errorlevel_code);

@ The subroutines define the corresponding macros so we can use them
in C.

@d flushable(#) == (# = str_ptr - 1)

@d flush_fontname_k(#) == 
if (# <> font_name[k]) and (flushable(#) or flushable(font_name[k])) then begin
    if flushable(#) then
        # := font_name[k]
    else
        font_name[k] := #;
    flush_string;
end

@d is_valid_char(#)==((font_bc[f] <= #) and (# <= font_ec[f]) and 
                      char_exists(char_info(f)(#)))

@p function get_int_par(p: integer): integer;
begin
    get_int_par := int_par(p);
end;

function get_nullfont: internal_font_number;
begin
    get_nullfont := null_font;
end;

function get_nullcs: pointer;
begin
    get_nullcs := null_cs;
end;

function get_nullptr: pointer;
begin
    get_nullptr := null;
end;

function get_tex_int(code: integer): integer;
begin
    get_tex_int := int_par(code);
end;

function get_tex_dimen(code: integer): scaled;
begin
    get_tex_dimen := dimen_par(code);
end;

function get_x_height(f: internal_font_number): scaled;
begin
    get_x_height := x_height(f);
end;

function get_charwidth(f: internal_font_number; c: eight_bits): scaled;
begin
    if is_valid_char(c) then
        get_charwidth := char_width(f)(char_info(f)(c))
    else
        get_charwidth := 0;
end;

function get_charheight(f: internal_font_number; c: eight_bits): scaled;
begin
    if is_valid_char(c) then
        get_charheight := char_height(f)(height_depth(char_info(f)(c)))
    else
        get_charheight := 0;
end;

function get_chardepth(f: internal_font_number; c: eight_bits): scaled;
begin
    if is_valid_char(c) then
        get_chardepth := char_depth(f)(height_depth(char_info(f)(c)))
    else
        get_chardepth := 0;
end;

function get_quad(f: internal_font_number): scaled;
begin
    get_quad := quad(f);
end;

function get_slant(f: internal_font_number): scaled;
begin
    get_slant := slant(f);
end;

function new_null_font: internal_font_number;
begin
    new_null_font := read_font_info(null_cs, "dummy", "", -1000);
end;

procedure flush_str(s: str_number); {flush a string if possible}
begin
    if flushable(s) then
        flush_string;
end;

function get_tfm_num(s: str_number): internal_font_number;
label found;
var k: internal_font_number;
begin
    for k := font_base + 1 to font_ptr do
        if str_eq_str(font_name[k], s) then begin
            flush_fontname_k(s);
            if pdf_font_expand_ratio[k] = 0 then
                goto found;
        end;
    k := read_font_info(null_cs, s, "", -1000);
found:
    get_tfm_num := k;
end;

@ Here we have some utilities for tracing purpose.

@d print_delta_field_end(#) == 
    print_glue(s, # - 2, 0); end

@d print_delta_field(#) ==
s := #;
if s <> 0 then begin 
    if not_printed_plus_yet then begin
        print(" plus ");
        not_printed_plus_yet := false;
    end;
print_delta_field_end

@d print_delta_like_node(#) == begin
    print_scaled(#(1));
    print_delta_field(#(2))(2);
    print_delta_field(#(3))(3);
    print_delta_field(#(4))(4);
    print_delta_field(#(5))(5);
    if #(6) <> 0 then begin 
        print(" minus ");
        print_glue(#(6), 0, 0);
    end;
end

@d delta_field(#) == mem[p + #].sc
@d active_width_field(#) == active_width[#]
@d cur_active_width_field(#) == cur_active_width[#]
@d break_width_field(#) == break_width[#]
@d prev_active_width_field(#) == prev_active_width[#]

@p
procedure short_display_n(@!p, m:integer); {prints highlights of list |p|}
var n:integer; {for replacement counts}
    i: integer;
begin 
i := 0; 
font_in_short_display:=null_font;
if p = null then
    return;
while p>mem_min do
  begin if is_char_node(p) then
    begin if p<=mem_end then
      begin if font(p)<>font_in_short_display then
        begin if (font(p)<font_base)or(font(p)>font_max) then
          print_char("*")
@.*\relax@>
        else @<Print the font identifier for |font(p)|@>;
        print_char(" "); font_in_short_display:=font(p);
        end;
      print_ASCII(qo(character(p)));
      end;
    end
  else begin
      if (type(p) = glue_node) or 
         (type(p) = disc_node) or 
         (type(p) = penalty_node) or
         ((type(p) = kern_node) and (subtype(p) = explicit)) then 
         incr(i);
      if i >= m then
         return;
      if (type(p) = disc_node) then begin 
          print("|");
          short_display(pre_break(p));
          print("|");
          short_display(post_break(p));
          print("|");
          n:=replace_count(p);
          while n>0 do
              begin if link(p)<>null then p:=link(p);
          decr(n);
          end;
        end
        else
            @<Print a short indication of the contents of node |p|@>;
  end;
  p:=link(p);
  if p = null then
      return;
  end;
  update_terminal;
end;

function show_line_breaking: integer;
label done;
var not_printed_plus_yet: boolean;
    p, q: pointer;
    s: scaled;
begin
    print_nl("cur_active_width: "); print_delta_like_node(cur_active_width_field);
    print_ln;
    not_printed_plus_yet := true;
    print_nl("active list: ");
    p := link(active);
    while true do begin 
        if type(p) = 2  {|delta_node| = 2}
        then begin
            print("delta: "); print_delta_like_node(delta_field);
        end
        else begin
            print("active: ");
            if break_node(p) <>  null then
                short_display_n(cur_break(break_node(p)), 5);
        end;
        if link(p) = last_active then
            goto done;
        p := link(p);
        print_ln;
    end;
done:
    print_ln;
    print_nl("active_width: "); print_delta_like_node(active_width_field);
    print_nl("break_width: "); print_delta_like_node(break_width_field);
    print_nl("prev_active_width: "); print_delta_like_node(prev_active_width_field);
    print_nl("cur_p: "); short_display_n(cur_p, 5);
    if prev_legal <> null then begin
        print_nl("prev_legal: "); short_display_n(prev_legal, 5);
    end;
    if rejected_cur_p <> null then begin
        print_nl("rejected_cur_p: "); short_display_n(rejected_cur_p, 5);
    end;
    if prev_p <> null then begin
        print_nl("prev_p: "); short_display_n(prev_p, 5);
    end;
    if prev_legal <> null then begin
        print_nl("prev_legal: "); short_display_n(prev_legal, 5);
    end;
    print_ln;
    show_line_breaking := 0;
end;

function mi(p: pointer): pointer;
begin
    mi := info(p);
end;

function ml(p: pointer): pointer;
begin
    ml := link(p);
end;

@ Sometimes it is neccesary to allocate memory for PDF output that cannot
be deallocated then, so we use |pdf_mem| for this purpose.

@<Constants...@>=
@!inf_pdf_mem_size = 32000; {min size of the |pdf_mem| array}
@!sup_pdf_mem_size = 524288; {max size of the |pdf_mem| array}

@ @<Glob...@>=
@!pdf_mem_size: integer;
@!pdf_mem: ^integer;
@!pdf_mem_ptr: integer;

@ @<Set init...@>=
pdf_mem_ptr := 1; {the first word is not used so we can use zero as a value for testing
whether a pointer to |pdfmem| is valid}

@ We use |pdf_get_mem| to allocate memory in |pdf_mem|

@p function pdf_get_mem(s: integer): integer; {allocate |s| words in
|pdf_mem|}
begin
    if pdf_mem_ptr + s > pdf_mem_size then
        overflow("PDF memory size", pdf_mem_size);
    pdf_get_mem := pdf_mem_ptr;
    pdf_mem_ptr := pdf_mem_ptr + s;
end;


@* \[32b] \pdfTeX\ output low-level subroutines.
We use the similiar subroutines to handle the output buffer for
PDF output. When compress is used, the state of writing to buffer
is held in |zip_write_state|. We must write the header of PDF
output file in initialization to ensure that it will be the first
written bytes.

@<Constants...@>=
@!pdf_buf_size = 16384; {size of the PDF buffer}

@ The following macros are similar as for \.{DVI} buffer handling

@d pdf_offset == (pdf_gone + pdf_ptr) {the file offset of last byte in PDF
buffer that |pdf_ptr| points to}

@d no_zip == 0 {no \.{ZIP} compression}
@d zip_writing == 1 {\.{ZIP} compression being used}
@d zip_finish == 2 {finish \.{ZIP} compression}

@d pdf_quick_out(#) == {output a byte to PDF buffer without checking of
overflow}
begin
    pdf_buf[pdf_ptr] := #;
    incr(pdf_ptr);
end

@d pdf_room(#) == {make sure that there are at least |n| bytes free in PDF
buffer}
begin
    if pdf_buf_size - # < 0 then
        overflow("PDF output buffer", pdf_buf_size);
    if # + pdf_ptr >= pdf_buf_size then
        pdf_flush;
end

@d pdf_out(#) == {do the same as |pdf_quick_out| and flush the PDF
buffer if necessary}
begin
    if pdf_ptr + 1 >= pdf_buf_size then
        pdf_flush;
    pdf_quick_out(#);
end

@<Glob...@>=
@!fixed_output: integer; {fixed output format}
@!pdf_file: byte_file; {the PDF output file}
@!pdf_buf: array[0..pdf_buf_size] of eight_bits; {the PDF buffer}
@!pdf_ptr: integer; {pointer to the first unused byte in the PDF buffer}
@!pdf_gone: integer; {number of bytes that were flushed to output}
@!pdf_save_offset: integer; {to save |pdf_offset|}
@!zip_write_state: integer; {which state of compression we are in}
@!fixed_pdf_minor_version: integer; {fixed minor part of the pdf version}
@!pdf_minor_version_has_been_written: boolean; {flag if the pdf version has been written}

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
pdf_ptr := 9;
pdf_gone := 0;
zip_write_state := no_zip;
pdf_minor_version_has_been_written := false;

@ @p 
function fix_int(val, min, max: integer): integer;
begin
    if val < min then
        fix_int := min
    else if val > max then
        fix_int := max
    else
        fix_int := val;
end;

@ This checks that |pdfoptionpdfminorversion| can only be set before any
bytes have been written to the generated pdf file. It should be called
directly every after |ensure_pdf_open|.

@p procedure check_and_set_pdfoptionpdfminorversion;
begin
    if not pdf_minor_version_has_been_written then begin
        pdf_minor_version_has_been_written := true;
        if (pdf_option_pdf_minor_version < 0) or (pdf_option_pdf_minor_version > 9) then begin
        print_err("pdfTeX error (illegal pdfoptionpdfminorversion)");
        print_ln;
        help2 ("The pdfoptionpdfminorversion must be between 0 and 9.")@/
            ("I changed this to 4.");
        int_error (pdf_option_pdf_minor_version);
        pdf_option_pdf_minor_version := 4;
        end;
        fixed_pdf_minor_version := pdf_option_pdf_minor_version;
        pdf_buf[7] := chr(ord("0") + fixed_pdf_minor_version);
    end
    else begin
        if fixed_pdf_minor_version <> pdf_option_pdf_minor_version then
            pdf_error("setup", 
               "\pdfoptionpdfminorversion cannot be changed after data is written to the pdf file");
    end;
end;

@ Checks that we have a name for the generated pdf file and that it's open.
|check_and_set_pdfoptionpdfminorversion| should be called directly
hereafter.

@p procedure ensure_pdf_open;
begin
    if output_file_name <> 0 then
        return;
    if job_name = 0 then
        open_log_file;
    pack_job_name(".pdf");
    while not b_open_out(pdf_file) do
        prompt_file_name("file name for output",".pdf");
    output_file_name := b_make_name_string(pdf_file);
end;

@ The PDF buffer is flushed by calling |pdf_flush|, which checks the
variable |zip_write_state| and will compress the buffer before flushing if
neccesary. We call |pdf_begin_stream| to begin a stream  and |pdf_end_stream|
to finish it. The stream contents will be compressed if compression is turn on.

@p procedure pdf_flush; {flush out the |pdf_buf|}
begin
    ensure_pdf_open;
    check_and_set_pdfoptionpdfminorversion;
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

procedure pdf_begin_stream; {begin a stream}
begin
    ensure_pdf_open;
    check_and_set_pdfoptionpdfminorversion;
    pdf_print_ln("/Length           ");
    pdf_stream_length_offset := pdf_offset - 11;
    pdf_stream_length := 0;
    if pdf_compress_level > 0 then begin
        pdf_print_ln("/Filter /FlateDecode");
        pdf_print_ln(">>");
        pdf_print_ln("stream");
        pdf_flush;
        zip_write_state := zip_writing;
    end
    else begin
        pdf_print_ln(">>");
        pdf_print_ln("stream");
        pdf_save_offset := pdf_offset;
    end;
end;

procedure pdf_end_stream; {end a stream}
begin
    if pdf_compress_level > 0 then
        zip_write_state := zip_finish
    else
        pdf_stream_length := pdf_offset - pdf_save_offset;
    pdf_flush;
    write_stream_length(pdf_stream_length, pdf_stream_length_offset);
    pdf_print_ln("endstream");
    pdf_end_obj;
end;

@ Basic printing procedures for PDF output are very similiar to \TeX\ basic
printing ones but the output is going to PDF buffer. Subroutines with
suffix |_ln| append a new-line character to the PDF output.

@d pdf_new_line_char == 10 {new-line character for UNIX platforms}

@d pdf_print_nl == {output a new-line character to PDF buffer}
    pdf_out(pdf_new_line_char)

@d pdf_print_ln(#) == {print out a string to PDF buffer followed by
a new-line character}
begin
    pdf_print(#);
    pdf_print_nl;
end

@d pdf_print_int_ln(#) == {print out an integer to PDF buffer followed by
a new-line character}
begin
    pdf_print_int(#);
    pdf_print_nl;
end

@<Declare procedures that need to be declared forward for pdftex@>=
procedure pdf_error(t, p: str_number);
begin
    normalize_selector;
    print_err("pdfTeX error");
    if t <> 0 then begin
        print(" (");
        print(t);
        print(")");
    end;
    print(": "); print(p);
    succumb;
end;

procedure pdf_warning(t, p: str_number; append_nl: boolean);
begin
    print_err("pdfTeX warning");
    if t <> 0 then begin
        print(" (");
        print(t);
        print(")");
    end;
    print(": "); print(p);
    if append_nl then
        print_ln;
end;

procedure remove_last_space;
begin
    if (pdf_ptr > 0) and (pdf_buf[pdf_ptr - 1] = 32) then
        decr(pdf_ptr);
end;

procedure pdf_print_octal(n: integer); {prints an integer in octal form to
PDF buffer}
var k:0..23; {index to current digit; we assume that $|n|<10^{23}$}
begin
  k:=0;
  repeat dig[k]:=n mod 8; n:=n div 8; incr(k);
  until n=0;
  if k = 1 then begin
    pdf_out("0");
    pdf_out("0");
  end;
  if k = 2 then
    pdf_out("0");
  while k>0 do begin
    decr(k);
    pdf_out("0"+dig[k]);
  end;
end;

procedure pdf_print_char(f: internal_font_number; c: integer);
{ print out a character to PDF buffer; the character will be printed in octal
  form in the following cases: chars <= 32, backslash (92), left parenthesis
  (40) and  right parenthesis (41) }
begin
    if c <= 32 then
        c := pdf_char_map[f, c];
    pdf_mark_char(f, c);
    if (c <= 32) or (c = 92) or (c = 40) or (c = 41) or (c > 127) then begin
        pdf_out(92);           {output a backslash}
        pdf_print_octal(c);
    end
    else
        pdf_out(c);
end;

procedure pdf_print(s: str_number); {print out a string to PDF buffer}
var j: pool_pointer; {current character code position}
    c: integer;
begin
    j := str_start[s];
    while j < str_start[s + 1] do begin
       c := str_pool[j];
       pdf_out(c);
       incr(j);
    end;
end;

function str_in_str(s, r: str_number; i: integer): boolean;
  {test equality of strings}
label not_found; {loop exit}
var j, k: pool_pointer; {running indices}
@!result: boolean; {result of comparison}
begin 
    str_in_str := false;
    if length(s) < i + length(r) then
        return;
    j := i + str_start[s];
    k := str_start[r];
    while (j < str_start[s + 1]) and (k < str_start[r + 1]) do begin
        if str_pool[j] <> str_pool[k] then
            return;
        incr(j);
        incr(k);
    end;
    str_in_str := true;
end;

procedure literal(s: str_number; reset_origin, is_special, warn: boolean);
var j: pool_pointer; {current character code position}
begin
    j:=str_start[s];
    if is_special then begin
        if not (str_in_str(s, "PDF:", 0) or str_in_str(s, "pdf:", 0)) then begin
            if warn and not (str_in_str(s, "SRC:", 0) or str_in_str(s, "src:", 0)) then
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
        pdf_end_string;
        pdf_print_nl;
    end;
    while j<str_start[s+1] do begin
       pdf_out(str_pool[j]);
       incr(j);
    end;
    pdf_print_nl;
end;

procedure pdf_print_int(n:integer); {print out a integer to PDF buffer}
var k:0..23; {index to current digit; we assume that $|n|<10^{23}$}
m:integer; {used to negate |n| in possibly dangerous cases}
begin
  k:=0;
  if n<0 then
    begin pdf_out("-");
    if n>-100000000 then negate(n)
    else  begin m:=-1-n; n:=m div 10; m:=(m mod 10)+1; k:=1;
      if m<10 then dig[0]:=m
      else  begin dig[0]:=0; incr(n);
        end;
      end;
    end;
  repeat dig[k]:=n mod 10; n:=n div 10; incr(k);
  until n=0;
  pdf_room(k);
  while k>0 do begin
    decr(k);
    pdf_quick_out("0"+dig[k]);
  end;
end;

procedure pdf_print_two(n:integer); {prints two least significant digits in
decimal form to PDF buffer}
begin n:=abs(n) mod 100; pdf_out("0"+(n div 10));
pdf_out("0"+(n mod 10));
end;

@ To print |scaled| value to PDF output we need some subroutines to ensure
accurary.

@d max_integer == @"7FFFFFFF {$2^{31}-1$}
@d call_func(#) == begin if # <> 0 then do_nothing end

@<Glob...@>=
@!one_bp: scaled; {scaled value corresponds to 1bp}
@!one_hundred_bp: scaled; {scaled value corresponds to 100bp}
@!one_hundred_inch: scaled; {scaled value corresponds to 100in}
@!ten_pow: array[0..9] of integer; {$10^0..10^9$}
@!scaled_out: integer; {amount of |scaled| that was taken out in
|divide_scaled|}
@!init_pdf_output: boolean;

@ @<Set init...@>=
one_bp := 65782; {65781.76}
one_hundred_bp := 6578176;
one_hundred_inch := 473628672;
ten_pow[0] := 1;
for i := 1 to 9 do
    ten_pow[i] := 10*ten_pow[i - 1];
init_pdf_output := false;


@ The following function divides |s| by |m|. |dd| is number of decimal digits.

@<Declare procedures that need to be declared forward for pdftex@>=
function divide_scaled(s, m: scaled; dd: integer): scaled;
var q, r: scaled;
    sign, i: integer;
begin
    sign := 1;
    if s < 0 then begin
        sign := -sign;
        s := -s;
    end;
    if m < 0 then begin
        sign := -sign;
        m := -m;
    end;
    if m = 0 then
        pdf_error("arithmetic", "divided by zero")
    else if m >= (max_integer div 10) then
        pdf_error("arithmetic", "number too big");
    q := s div m;
    r := s mod m;
    for i := 1 to dd do begin
        q := 10*q + (10*r) div m;
        r := (10*r) mod m;
    end;
    if 2*r >= m then begin
        incr(q);
        r := r - m;
    end;
    scaled_out := sign*(s - (r div ten_pow[dd]));
    divide_scaled := sign*q;
end;

function round_xn_over_d(@!x:scaled; @!n,@!d:integer):scaled;
var positive:boolean; {was |x>=0|?}
@!t,@!u,@!v:nonnegative_integer; {intermediate quantities}
begin if x>=0 then positive:=true
else  begin negate(x); positive:=false;
  end;
t:=(x mod @'100000)*n;
u:=(x div @'100000)*n+(t div @'100000);
v:=(u mod d)*@'100000 + (t mod @'100000);
if u div d>=@'100000 then arith_error:=true
else u:=@'100000*(u div d) + (v div d);
v := v mod d;
if 2*v >= d then
    incr(u);
if positive then 
    round_xn_over_d := u
else
    round_xn_over_d := -u;
end;


@ Next subroutines are needed for controling spacing in PDF page description.
The procedure |adv_char_width| advances |pdf_h| by the amount |w|, which is
the character width. We cannot simply add |w| to |pdf_h|, but must
calculate the amount corresponding to |w| in the PDF output. For PK fonts
things are more complicated, as we have to deal with scaling bitmaps as well.

@p 
procedure adv_char_width(f: internal_font_number; w: scaled); {update |pdf_h|
by character width |w| from font |f|} 
begin
    if pdf_font_map[f] >= 0 then begin
        call_func(divide_scaled(w, pdf_font_size[f], 3));
        pdf_h := pdf_h + scaled_out;
    end
    else
        pdf_h := pdf_h + get_pk_char_width(f, w);
end;

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

procedure pdf_print_bp(s: scaled); {print scaled as |bp|}
begin
    pdf_print_real(divide_scaled(s, one_hundred_bp, fixed_decimal_digits + 2), 
                   fixed_decimal_digits);
end;

procedure pdf_print_mag_bp(s: scaled); {take |mag| into account}
begin
    if (mag <> 1000) and (mag <> 0) then
        s := round_xn_over_d(s, mag, 1000);
    pdf_print_bp(s);
end;

@* \[32c] PDF page description.

@d pdf_x(#) == ((#) - pdf_origin_h) {convert $x$-coordinate from \.{DVI} to
PDF}
@d pdf_y(#) == (pdf_origin_v - (#)) {convert $y$-coordinate from \.{DVI} to
PDF}

@<Glob...@>=
@!pdf_f: internal_font_number; {the current font in PDF output page}
@!pdf_h: scaled; {current horizontal coordinate in PDF output page}
@!pdf_v: scaled; {current vertical coordinate in PDF output page}
@!pdf_last_h: scaled; {last horizontal coordinate in PDF output page}
@!pdf_last_v: scaled; {last vertical coordinate in PDF output page}
@!pdf_origin_h: scaled; {current horizontal origin in PDF output page}
@!pdf_origin_v: scaled; {current vertical origin in PDF output page}
@!pdf_first_space_corr: integer; {amount of first word spacing while drawing a string;
for some reason it is not taken into account of the length of the string, so we
have to save it in order to adjust spacing when string drawing is finished}
@!pdf_doing_string: boolean; {we are writing string to PDF file?}
@!pdf_doing_text: boolean; {we are writing text section to PDF file?}
@!pdf_font_changed: boolean; {current font has been changed?}
@!min_bp_val: scaled; 
@!fixed_pk_resolution: integer; 
@!fixed_decimal_digits: integer;
@!pk_scale_factor: integer;

@ Following procedures implement low-level subroutines to convert \TeX{}
internal structures to PDF page description.

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

procedure pdf_end_string; {end the current string}
begin
    if pdf_doing_string then begin
        pdf_print(")]TJ");
        if pdf_first_space_corr <> 0 then begin
            pdf_h := pdf_h - pdf_first_space_corr;
            pdf_first_space_corr := 0;
        end;
        pdf_doing_string := false;
    end;
end;

procedure pdf_moveto(v, v_out: scaled); {set the next starting point to |cur_h|, |cur_v|}
begin
    pdf_out(" ");
    pdf_print_bp(cur_h - pdf_last_h);
    pdf_h := pdf_last_h + scaled_out;
    pdf_out(" ");
    pdf_print_real(v, fixed_decimal_digits);
    pdf_print(" Td");
    pdf_v := pdf_last_v - v_out;
    pdf_last_h := pdf_h;
    pdf_last_v := pdf_v;
end;

procedure pdf_begin_text; forward;

procedure pdf_print_font_tag(f: internal_font_number);
begin
    if pdf_font_expand_ratio[f] = 0 then
        return;
    if pdf_font_expand_ratio[f] > 0 then
        pdf_print("+"); {minus sign will be printed by |pdf_print_int|}
    pdf_print_int(pdf_font_expand_ratio[f]);
end;

procedure pdf_set_font(f: internal_font_number);
label found;
var p: pointer;
    k: internal_font_number;
begin
    if not font_used[f] then
        pdf_init_font(f);
    set_ff(f);
    k := ff;
    p := pdf_font_list;
    while p <> null do begin
        set_ff(info(p));
        if ff = k then
            goto found;
        p := link(p);
    end;
    pdf_append_list(f)(pdf_font_list); {|f| not found in |pdf_font_list|}
found:
    pdf_begin_text;
    pdf_print("/F");
    pdf_print_int(k);
    pdf_print_resname_prefix;
    pdf_print_font_tag(f);
    pdf_out(" ");
    pdf_print_bp(font_size[f]);
    pdf_print(" Tf");
    pdf_f := f;
    pdf_font_changed := true;
end;

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
    if abs(cur_v - pdf_v) >= min_bp_val then begin
        v := divide_scaled(pdf_last_v - cur_v, one_hundred_bp, 
                           fixed_decimal_digits + 2);
        v_out := scaled_out;
    end
    else begin
        v := 0;
        v_out := 0;
    end;
    if pdf_font_changed or (v <> 0) or (abs(s) >= @'100000) then begin
        pdf_end_string;
        pdf_moveto(v, v_out);
        pdf_font_changed := false;
        s := 0;
        s_out := 0;
    end;
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
end;

procedure pdf_end_text; {end a text section}
begin
    if pdf_doing_text then begin
        pdf_end_string;
        pdf_print_nl;
        pdf_print_ln("ET");
        pdf_doing_text := false;
    end;
end;

procedure pdf_set_rule(x, y, w, h: scaled); {draw a rule}
begin                                                                           
    pdf_end_text;
    pdf_set_origin;
    if h <= one_bp then begin
        pdf_print_ln("q"); 
        pdf_print_ln("[]0 d");                                                    
        pdf_print_ln("0 J");                                                        
        pdf_print_bp(h); pdf_print_ln(" w");
        pdf_print("0 "); pdf_print_bp((h + 1)/2); pdf_print_ln(" m");
        pdf_print_bp(w); pdf_print(" "); pdf_print_bp((h + 1)/2);
        pdf_print_ln(" l");
        pdf_print_ln("S");
        pdf_print_ln("Q"); 
    end
    else if w <= one_bp then begin
        pdf_print_ln("q"); 
        pdf_print_ln("[]0 d");                                                    
        pdf_print_ln("0 J");                                                        
        pdf_print_bp(w); pdf_print_ln(" w");
        pdf_print_bp((w + 1)/2); pdf_print_ln(" 0 m");
        pdf_print_bp((w + 1)/2); pdf_print(" "); pdf_print_bp(h);
        pdf_print_ln(" l");
        pdf_print_ln("S");
        pdf_print_ln("Q"); 
    end
    else begin
        pdf_print_bp(pdf_x(x)); pdf_out(" "); 
        pdf_print_bp(pdf_y(y)); pdf_out(" "); 
        pdf_print_bp(w); pdf_out(" "); 
        pdf_print_bp(h); pdf_print_ln(" re f");
    end;
end;


procedure pdf_rectangle(left, top, right, bottom: scaled); {output a
rectangle specification to PDF file}
begin
    prepare_mag;
    pdf_print("/Rect [");
    pdf_print_mag_bp(pdf_x(left)); pdf_out(" ");
    pdf_print_mag_bp(pdf_y(bottom)); pdf_out(" ");
    pdf_print_mag_bp(pdf_x(right)); pdf_out(" ");
    pdf_print_mag_bp(pdf_y(top));
    pdf_print_ln("]");
end;

@* \[32d] The cross-reference table.

The cross-reference table |obj_tab| is an array of |obj_tab_size| of
|tab_entry|. Each entry contains four integer fields and represents an object
in PDF file whose object number is the index of this entry in |obj_tab|.
Objects in |obj_tab| maybe linked into list; objects in such a linked list have
the same type.

@<Types...@>=
@!obj_entry = record@;@/
    int0, int1, int2, int3: integer;
end;

@ The first field contains information representing identifier of this object.
It is usally a number for most of object types, but it may be a string number
for named destination or named thread.

The second field of |obj_entry| contains link to the next
object in |obj_tab| if this object in linked in a list.

The third field holds the byte offset of the object in the output PDF file.
Objects that have been not written yet have this field set to zero. However
sometimes we have to use this field to store some info before the object is
written out.

The last field usually represents the pointer to some auxiliary data
structure depending on the object type; however it may be used as a counter as
well.

@d obj_info(#) == obj_tab[#].int0 {information representing identifier of this object}
@d obj_link(#) == obj_tab[#].int1 {link to the next entry in linked list}
@d obj_offset(#) == obj_tab[#].int2 {byte offset of this object in PDF output file}
@d obj_aux(#) == obj_tab[#].int3 {auxiliary pointer}
@d is_obj_written(#) == (obj_offset(#) <> 0)

@# {types of objects}
@d obj_type_others              == 0 {objects which are not linked in any list}
@d obj_type_page                == 1 {index of linked list of Page objects}
@d obj_type_pages               == 2 {index of linked list of Pages objects}
@d obj_type_font                == 3 {index of linked list of Fonts objects}
@d obj_type_outline             == 4 {index of linked list of outline objects}
@d obj_type_dest                == 5 {index of linked list of destination objects}
@d obj_type_obj                 == 6 {index of linked list of raw objects}
@d obj_type_xform               == 7 {index of linked list of XObject forms}
@d obj_type_ximage              == 8 {index of linked list of XObject image}
@d obj_type_thread              == 9 {index of linked list of num article threads}
@d head_tab_max                 == obj_type_thread {max index of |head_tab|}

@# {max number of kids for balanced trees}
@d pages_tree_kids_max     == 6 {max number of kids of Pages tree node}
@d name_tree_kids_max      == @'100000 {max number of kids of node of name tree for
name destinations}

@# {when a whatsit node representing annotation is created, words |1..3| are
width, height and depth of this annotation; after shipping out words |1..4|
are rectangle specification of annotation. For whatsit node representing
destination |pdf_left| and |pdf_top| are used for some types of destinations}

@# {coordinates of destinations/threads/annotations (in whatsit node)}
@d pdf_left(#)             == mem[# + 1].sc
@d pdf_top(#)              == mem[# + 2].sc
@d pdf_right(#)            == mem[# + 3].sc
@d pdf_bottom(#)           == mem[# + 4].sc

@# {dimesion of destinations/threads/annotations (in whatsit node)}
@d pdf_width(#)            == mem[# + 1].sc
@d pdf_height(#)           == mem[# + 2].sc
@d pdf_depth(#)            == mem[# + 3].sc

@# {data struture for \.{\\pdfliteral}}
@d pdf_literal_data(#)     == link(#+1) {data}
@d pdf_literal_direct(#)   == info(#+1) {write data directly to the page
                              contents without resetting text matrix}

@# {data struture for \.{\\pdfobj} and \.{\\pdfrefobj}}
@d pdf_refobj_node_size    == 2 {size of whatsit node representing the raw object}
@d pdf_obj_objnum(#)       == info(# + 1) {number of the raw object}
@d obj_data_ptr            == obj_aux {pointer to |pdf_mem|}
@d pdfmem_obj_size         == 4 {size of memory in |pdf_mem| which
                              |obj_data_ptr| holds}
@d obj_obj_data(#)         == pdf_mem[obj_data_ptr(#) + 0] {object data}
@d obj_obj_is_stream(#)    == pdf_mem[obj_data_ptr(#) + 1] {will this object
                              be written as a stream instead of a dictionary?}
@d obj_obj_stream_attr(#)  == pdf_mem[obj_data_ptr(#) + 2] {additional
                              object attributes for streams}
@d obj_obj_is_file(#)      == pdf_mem[obj_data_ptr(#) + 3] {data should be 
                              read from an external file?}

@# {data struture for \.{\\pdfxform} and \.{\\pdfrefxform}}
@d pdf_refxform_node_size  == 5 {size of whatsit node for xform; words 1..3 are
                              form dimensions}
@d pdf_xform_objnum(#)     == info(# + 4) {object number}
@d pdfmem_xform_size       == 6 {size of memory in |pdf_mem| which
                              |obj_data_ptr| holds}
@d obj_xform_width(#)      == pdf_mem[obj_data_ptr(#) + 0]
@d obj_xform_height(#)     == pdf_mem[obj_data_ptr(#) + 1]
@d obj_xform_depth(#)      == pdf_mem[obj_data_ptr(#) + 2]
@d obj_xform_box(#)        == pdf_mem[obj_data_ptr(#) + 3] {this field holds
                              pointer to the corresponding box}
@d obj_xform_attr(#)       == pdf_mem[obj_data_ptr(#) + 4] {additional xform
                              attributes}
@d obj_xform_resources(#)  == pdf_mem[obj_data_ptr(#) + 5] {additional xform
                              Resources}

@# {data struture for \.{\\pdfximage} and \.{\\pdfrefximage}}
@d pdf_refximage_node_size == 5 {size of whatsit node for ximage; words 1..3
                               are image dimensions}
@d pdf_ximage_objnum(#)    == info(# + 4) {object number}
@d pdfmem_ximage_size      == 5 {size of memory in |pdf_mem| which
                              |obj_data_ptr| holds}
@d obj_ximage_width(#)     == pdf_mem[obj_data_ptr(#) + 0]
@d obj_ximage_height(#)    == pdf_mem[obj_data_ptr(#) + 1]
@d obj_ximage_depth(#)     == pdf_mem[obj_data_ptr(#) + 2]
@d obj_ximage_attr(#)      == pdf_mem[obj_data_ptr(#) + 3] {additional ximage attributes}
@d obj_ximage_data(#)      == pdf_mem[obj_data_ptr(#) + 4] {pointer to image data}

@# {data struture of annotations; words 1..4 represent the coordinates of
    the annotation}
@d obj_annot_ptr           == obj_aux {pointer to corresponding whatsit node}
@d pdf_annot_node_size     == 7 {size of whatsit node representing annotation}
@d pdf_annot_data(#)       == info(# + 5) {raw data of general annotations}
@d pdf_link_attr(#)        == info(# + 5) {attributes of link annotations}
@d pdf_link_action(#)      == link(# + 5) {pointer to action structure}
@d pdf_annot_objnum(# )    == mem[# + 6].int {object number of corresponding object}

@# {types of actions}
@d pdf_action_page         == 0 {Goto action}
@d pdf_action_goto         == 1 {Goto action}
@d pdf_action_thread       == 2 {Thread action}
@d pdf_action_user         == 3 {user-defined action}

@# {data structure of actions}
@d pdf_action_size         == 3 {size of action structure in |mem|}
@d pdf_action_type         == type {action type}
@d pdf_action_named_id     == subtype {identifier is type of name}
@d pdf_action_id           == link {destination/thread name identifier}
@d pdf_action_file(#)      == info(# + 1) {file name for external action}
@d pdf_action_new_window(#)== link(# + 1) {open a new window?}
@d pdf_action_page_tokens(#) == info(# + 2) {specification of goto page action}
@d pdf_action_user_tokens(#) == info(# + 2) {user-defined action string}
@d pdf_action_refcount(#)  == link(# + 2) {counter of references to this action}

@# {data structure of outlines; it's not able to write out outline entries
before all outline entries are defined, so memory allocated for outline
entries can't not be deallocated and will stay in memory. For this reason we
will store data of outline entries in |pdf_mem| instead of |mem|}

@d pdfmem_outline_size     == 8 {size of memory in |pdf_mem| which
|obj_outline_ptr| points to}
@d obj_outline_count        == obj_info{count of all opened children}
@d obj_outline_ptr          == obj_aux {pointer to |pdf_mem|}
@d obj_outline_title(#)     == pdf_mem[obj_outline_ptr(#)]
@d obj_outline_parent(#)    == pdf_mem[obj_outline_ptr(#) + 1]
@d obj_outline_prev(#)      == pdf_mem[obj_outline_ptr(#) + 2]
@d obj_outline_next(#)      == pdf_mem[obj_outline_ptr(#) + 3]
@d obj_outline_first(#)     == pdf_mem[obj_outline_ptr(#) + 4]
@d obj_outline_last(#)      == pdf_mem[obj_outline_ptr(#) + 5]
@d obj_outline_action_objnum(#) == pdf_mem[obj_outline_ptr(#) + 6] {object number of
action}
@d obj_outline_attr(#)      == pdf_mem[obj_outline_ptr(#) + 7]

@# {types of destinations}
@d pdf_dest_xyz             == 0
@d pdf_dest_fit             == 1
@d pdf_dest_fith            == 2
@d pdf_dest_fitv            == 3
@d pdf_dest_fitb            == 4
@d pdf_dest_fitbh           == 5
@d pdf_dest_fitbv           == 6
@d pdf_dest_fitr            == 7

@# {data structure of destinations}
@d obj_dest_ptr             == obj_aux {pointer to |pdf_dest_node|}
@d pdf_dest_node_size       == 7 {size of whatsit node for destination;
words |1..4| hold dest dimensions, word |6| identifier type, subtype
and identifier of destination, word |6| the corresponding object number}
@d pdf_dest_type(#)          == type(# + 5) {type of destination}
@d pdf_dest_named_id(#)      == subtype(# + 5) {is named identifier?}
@d pdf_dest_id(#)            == link(# + 5) {destination identifier}
@d pdf_dest_xyz_zoom(#)      == info(# + 6) {zoom factor for |destxyz| destination}
@d pdf_dest_objnum(#)        == link(# + 6) {object number of corresponding
object}

@# {data structure of threads; words 1..4 represent the coordinates of the
    corners}
@d pdf_thread_node_size      == 7
@d pdf_thread_named_id(#)    == subtype(# + 5) {is a named identifier}
@d pdf_thread_id(#)          == link(# + 5) {thread identifier}
@d pdf_thread_attr(#)        == info(# + 6) {attributes of thread}
@d obj_thread_first          == obj_aux {pointer to the first bead}

@# {data structure of beads}
@d pdfmem_bead_size         == 5 {size of memory in |pdf_mem| which 
                                  |obj_bead_ptr| points to}
@d obj_bead_ptr             == obj_aux {pointer to |pdf_mem|}
@d obj_bead_rect(#)         == pdf_mem[obj_bead_ptr(#)]
@d obj_bead_page(#)         == pdf_mem[obj_bead_ptr(#) + 1]
@d obj_bead_next(#)         == pdf_mem[obj_bead_ptr(#) + 2]
@d obj_bead_prev(#)         == pdf_mem[obj_bead_ptr(#) + 3]
@d obj_bead_attr(#)         == pdf_mem[obj_bead_ptr(#) + 4]
@d obj_bead_data            == obj_bead_rect {pointer to the corresponding
whatsit node; |obj_bead_rect| is needed only when the bead rectangle has
been written out and after that |obj_bead_data| is not needed any more
so we can use this field for both}

@# {data structure of snap node}
@d snap_glue_ptr(#)         == info(# + 1)

@<Constants...@>=
@!inf_obj_tab_size = 32000; {min size of the cross-reference table for PDF output}
@!sup_obj_tab_size = 8388607; {max size of the cross-reference table for PDF output}
@!inf_dest_names_size = 10000; {min size of the destination names table for PDF output}
@!sup_dest_names_size = 131072; {max size of the destination names table for PDF output}
@!pdf_pdf_box_spec_media  = 0;
@!pdf_pdf_box_spec_crop   = 1;
@!pdf_pdf_box_spec_bleed  = 2;
@!pdf_pdf_box_spec_trim   = 3;
@!pdf_pdf_box_spec_art    = 4;

@ @<Glob...@>=
@!obj_tab_size:integer;
@!obj_tab:^obj_entry;
@!head_tab: array[1..head_tab_max] of integer;
@!obj_ptr: integer; {objects counter}
@!pdf_last_pages: integer; {pointer to most recently generated pages object}
@!pdf_last_page: integer; {pointer to most recently generated page object}
@!pdf_last_stream: integer; {pointer to most recently generated stream}
@!pdf_stream_length: integer; {length of most recently generated stream}
@!pdf_stream_length_offset: integer; {file offset of the last stream length}
@!pdf_append_list_arg: integer; {for use with |pdf_append_list|}
@!ff: integer; {for use with |set_ff|}

@ @<Set init...@>=
obj_ptr := 0;
for k := 1 to head_tab_max do
    head_tab[k] := 0;

@ Here we implement subroutines for work with objects and related things.
Some of them are used in former parts too, so we need to declare them
forward.

@d pdf_append_list_end(#) == # := append_ptr(#, pdf_append_list_arg); end
@d pdf_append_list(#) == begin pdf_append_list_arg := #; pdf_append_list_end
@d set_ff(#) == begin 
    if pdf_font_num[#] < 0 then
        ff := -pdf_font_num[#]
    else 
        ff := #;
end

@<Declare procedures that need to be declared forward for pdftex@>=
procedure append_dest_name(s: str_number; n: integer);
begin
    if pdf_dest_names_ptr = dest_names_size then
        overflow("number of destination names", dest_names_size);
    dest_names[pdf_dest_names_ptr].objname := s;
    dest_names[pdf_dest_names_ptr].objnum := n;
    incr(pdf_dest_names_ptr);
end;

procedure pdf_create_obj(t, i: integer); {create an object with type |t| and
identifier |i|}
label done;
var p, q: integer;
begin
    if obj_ptr = obj_tab_size then
        overflow("indirect objects table size", obj_tab_size);
    incr(obj_ptr);
    obj_info(obj_ptr) := i;
    obj_offset(obj_ptr) := 0;
    obj_aux(obj_ptr) := 0;
    if t = obj_type_page then begin
        p := head_tab[t];
        {find the right poition to insert newly created object}@/
        if (p = 0) or (obj_info(p) < i) then begin
            obj_link(obj_ptr) := p;
            head_tab[t] := obj_ptr;
        end
        else begin
            while p <> 0 do begin
                if obj_info(p) < i then
                    goto done;
                q := p;
                p := obj_link(p);
            end;
done:
            obj_link(q) := obj_ptr;
            obj_link(obj_ptr) := p;
        end;
    end
    else if t <> obj_type_others then begin
        obj_link(obj_ptr) := head_tab[t];
        head_tab[t] := obj_ptr;
        if (t = obj_type_dest) and (i < 0) then
            append_dest_name(-obj_info(obj_ptr), obj_ptr);
    end;
end;

function pdf_new_objnum: integer; {create a new object and return its number}
begin
    pdf_create_obj(obj_type_others, 0);
    pdf_new_objnum := obj_ptr;
end;

procedure pdf_begin_obj(i: integer); {begin a PDF object}
begin
    ensure_pdf_open;
    check_and_set_pdfoptionpdfminorversion;
    obj_offset(i) := pdf_offset;
    pdf_print_int(i);
    pdf_print_ln(" 0 obj");
end;

procedure pdf_end_obj;
begin
    pdf_print_ln("endobj"); {end a PDF object}
end;

procedure pdf_begin_dict(i: integer); {begin a PDF dictionary object}
begin
    obj_offset(i) := pdf_offset;
    pdf_print_int(i);
    pdf_print_ln(" 0 obj <<");
end;

procedure pdf_end_dict; {end a PDF object of type dictionary}
begin
    pdf_print_ln(">> endobj");
end;

procedure pdf_new_obj(t, i: integer); {begin to a new object}
begin
    pdf_create_obj(t, i);
    pdf_begin_obj(obj_ptr);
end;

procedure pdf_new_dict(t, i: integer); {begin a new object with type dictionary}
begin
    pdf_create_obj(t, i);
    pdf_begin_dict(obj_ptr);
end;

function append_ptr(p: pointer; i: integer): pointer; {appends a pointer with
info |i| to the end of linked list with head |p|}
var q: pointer;
begin
    append_ptr := p;
    fast_get_avail(q);
    info(q) := i;
    link(q) := null;
    if p = null then begin
        append_ptr := q;
        return;
    end;
    while link(p) <> null do
        p := link(p);
    link(p) := q;
end;

function pdf_lookup_list(p: pointer; i: integer): pointer; {looks up for pointer
with info |i| in list |p|}
begin
    pdf_lookup_list := null;
    while p <> null do begin
        if info(p) = i then begin
            pdf_lookup_list := p;
            return;
        end;
        p := link(p);
    end;
end;

@ ProcSet's handling.

@ @<Glob...@>=
@!pdf_image_procset: integer; {collection of image types used in current page/form}
@!pdf_text_procset: boolean; {mask of used ProcSet's in the current page/form}

@ Subroutines to print out various PDF objects

@p procedure pdf_print_fw_int(n, w: integer); {print out an integer with 
fixed width; used for outputting cross-reference table}
var k:0..23;
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

procedure pdf_int_entry(s: str_number; v: integer); {print out an entry in
dictionary with integer value to PDF buffer}
begin
    pdf_out("/");
    pdf_print(s);
    pdf_out(" ");
    pdf_print_int(v);
end;

procedure pdf_int_entry_ln(s: str_number; v: integer);
begin
    pdf_int_entry(s, v);
    pdf_print_nl;
end;

procedure pdf_indirect(s: str_number; o: integer); {print out an indirect
entry in dictionary}
begin
    pdf_out("/");
    pdf_print(s);
    pdf_out(" ");
    pdf_print_int(o);
    pdf_print(" 0 R");
end;

procedure pdf_indirect_ln(s: str_number; o: integer);
begin
    pdf_indirect(s, o);
    pdf_print_nl;
end;

procedure pdf_print_str(s: str_number); {print out |s| as string in PDF
output}
begin
    pdf_out("(");
    pdf_print(s);
    pdf_out(")");
end;

procedure pdf_print_str_ln(s: str_number); {print out |s| as string in PDF
output}
begin
    pdf_print_str(s);
    pdf_print_nl;
end;

procedure pdf_str_entry(s, v: str_number); {print out an entry in
dictionary with string value to PDF buffer}
begin
    if v = 0 then
        return;
    pdf_out("/");
    pdf_print(s);
    pdf_out(" ");
    pdf_print_str(v);
end;

procedure pdf_str_entry_ln(s, v: str_number);
begin
    if v = 0 then
        return;
    pdf_str_entry(s, v);
    pdf_print_nl;
end;

@* \[32e] Font processing.

As pdfTeX should also act as a back-end driver, it needs to support virtual
font too. Information about virtual font can be found in source of some
\.{DVI}-related programs.

Whenever we want to write out a character in a font to PDF output, we
should check whether the used font is new font (has not been used yet),
virtual font or real font. The array |pdf_font_type| holds flag of each used
font. After initialization flag of each font is set to |new_font_type|.
The first time when a character of a font is written out, pdfTeX looks for
the corresponding virtual font. If the corresponding virtual font exists, then
the font type is set to |virtual_font_type|; otherwise it will be set to
|real_font_type|. |subst_font_type| indicates fonts that have been substituted
during adjusting spacing. Such fonts are linked via the |pdf_font_link| array.

@d new_font_type = 0 {new font (has not been used yet)}
@d virtual_font_type = 1 {virtual font}
@d real_font_type = 2 {real font}
@d subst_font_type = 3 {substituted font}
@d pdf_init_font(#) == begin tmp_f := #; pdf_create_font_obj; end
@d pdf_check_vf(#) == begin 
    tmp_f := #; 
    do_vf; 
    if pdf_font_type[#] = virtual_font_type then
        pdf_error("font", "command cannot be used with virtual font");
end

@d pdf_check_new_font(#) == 
    if pdf_font_type[#] = new_font_type then begin
        tmp_f := #;
        do_vf;
    end

@<Declare procedures that need to be declared forward...@>=
procedure pdf_create_font_obj; forward;
procedure do_vf; forward;

@ @<Glob...@>=
@!pdf_font_type: ^eight_bits; {the type of font}
@!pdf_font_attr: ^str_number; {pointer to additional attributes}
@!pdf_font_link: ^internal_font_number; {link to expanded fonts}
@!pdf_font_stretch: ^integer; {limit of stretching}
@!pdf_font_shrink: ^integer; {limit of shrinking}
@!pdf_font_step: ^integer;  {amount of one step}
@!pdf_font_expand_factor: ^integer;
@!pdf_font_expand_ratio: ^integer;
@!pdf_font_lp_base: ^integer;
@!pdf_font_rp_base: ^integer;
@!pdf_font_ef_base: ^integer;
@!tmp_f: internal_font_number; {for use with |pdf_init_font|}

@ Here come some subroutines to deal with expanded fonts for HZ-algorithm.

@d copy_char_settings(#) == 
if (#[k] < 0) and (#[f] >= 0) then begin
    i := pdf_get_mem(256);
    for j := 0 to 255 do
        pdf_mem[i + j] := pdf_mem[#[f] + j];
    #[k] := i;
end

@p
function init_font_base: integer;
var i, j: integer;
begin
    i := pdf_get_mem(256);
    for j := 0 to 255 do
        pdf_mem[i + j] := 0;
    init_font_base := i;
end;

procedure set_lp_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_lp_base[f] < 0 then
        pdf_font_lp_base[f] := init_font_base;
    pdf_mem[pdf_font_lp_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure set_rp_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_rp_base[f] < 0 then
        pdf_font_rp_base[f] := init_font_base;
    pdf_mem[pdf_font_rp_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure set_ef_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_ef_base[f] < 0 then
        pdf_font_ef_base[f] := init_font_base;
    pdf_mem[pdf_font_ef_base[f] + c] := fix_int(i, 0, 1000);
end;

function read_expand_font(f: internal_font_number; e: scaled): internal_font_number;
{read font |f| expanded by |e| thousandths into font memory}
label found;
var old_setting:0..max_selector; {holds |selector| setting}
    s: str_number; {font name}
    k: internal_font_number;
begin
    old_setting:=selector; selector:=new_string;
    print(font_name[f]);
    if e > 0 then
        print("+"); {minus sign will be printed by |print_int|}
    print_int(e);
    selector:=old_setting;
    s := make_string;
    for k := font_base + 1 to font_ptr do
        if str_eq_str(font_name[k], s) then begin
            flush_fontname_k(s);
            if (font_dsize[k] = font_dsize[f]) and
               (font_size[k] = font_size[f]) and
               {|
               (((pdf_font_expand_ratio[k] = 0) and
                 (pdf_font_expand_factor[k] = 0)) or
                ((pdf_font_expand_ratio[k] = e) and
                 (pdf_font_expand_factor[k] = pdf_font_expand_factor[f])))
               |}
                ((pdf_font_expand_ratio[k] = e) and
                 (pdf_font_expand_factor[k] = pdf_font_expand_factor[f]))
            then
                goto found;
        end;
    k := read_font_info(null_cs, s, "", font_size[f]);
found:
    read_expand_font := k;
end;

procedure set_expand_param(k, f: internal_font_number; e: integer);
var i, j: integer;
begin
    pdf_font_expand_ratio[k] := e;
    pdf_font_step[k] := pdf_font_step[f];
    pdf_font_expand_factor[k] := pdf_font_expand_factor[f];
    copy_char_settings(pdf_font_lp_base);
    copy_char_settings(pdf_font_rp_base);
    copy_char_settings(pdf_font_ef_base);
end;

function get_expand_value(f: internal_font_number; e, max_expand: integer): integer;
var step: integer;
    neg: boolean;
begin
    if e = 0 then begin
        get_expand_value := e;
        return;
    end;
    if e < 0 then begin
        e := -e;
        max_expand := -max_expand;
        neg := true;
    end
    else begin
        neg := false;
    end;
    step := pdf_font_step[f];
    if e mod step > 0 then
        e := step*round_xn_over_d(e, 1, step);
    if e > max_expand then
        e :=  max_expand - max_expand mod step;
    if neg then
        e := -e;
    get_expand_value := e;
end;

function get_expand_factor(f: internal_font_number): integer;
begin
    if pdf_font_expand_ratio[f] = 0 then
        get_expand_factor := 0
    else
        get_expand_factor := 
            get_expand_value(f, 
                             round_xn_over_d(pdf_font_expand_ratio[f], 
                                             pdf_font_expand_factor[f], 
                                             1000), 
                             pdf_font_expand_ratio[f]);
end;

function new_ex_font(f: internal_font_number; e: scaled): internal_font_number;
var k: internal_font_number;
begin
    k := pdf_font_link[f];
    while k <> null_font do begin
        if pdf_font_expand_ratio[k] = e then begin
            new_ex_font := k;
            return;
        end;
        k := pdf_font_link[k];
    end;
    k := read_expand_font(f, e);
    set_expand_param(k, f, e);
    check_ex_tfm(font_name[f], get_expand_factor(k));
    pdf_font_link[k] := pdf_font_link[f];
    pdf_font_link[f] := k;
    new_ex_font := k;
end;

function expand_font(f: internal_font_number; e: integer): internal_font_number;
{look up for font |f| expanded by |e| thousandths}
var max_expand: integer;
begin
    expand_font := f;
    if pdf_font_link[f] = null_font then
        pdf_error("expand", "uninitialized pdf_font_link");
    if e = 0 then
        return;
    if e < 0 then
        max_expand := pdf_font_expand_ratio[pdf_font_shrink[f]]
    else
        max_expand := pdf_font_expand_ratio[pdf_font_stretch[f]];
    e := get_expand_value(f, e, max_expand);
    if e <> 0 then
        expand_font := new_ex_font(f, e);
end;

@ To set PDF font we need to find out fonts with the same name, because \TeX\
can load the same font several times for various sizes. For such fonts we
define only one font resources. The array |pdf_font_num| holds the object
number of font resource. A negative value of an entry of |pdf_font_num|
indicates that the corresponding font shares the font resource with the font
which internal number is the absolute value of the entry. For partial
downloading we also need to hold flags indicating which charaters in particular
font are used in array |pdf_char_used|.

@d pdf_print_resname_prefix == 
if pdf_resname_prefix <> 0 then
    pdf_print(pdf_resname_prefix)

@p procedure pdf_use_font(f: internal_font_number; fontnum: integer);
begin
    call_func(divide_scaled(font_size[f], one_hundred_bp, 
                            fixed_decimal_digits + 2));
    pdf_font_size[f] := scaled_out;
    font_used[f] := true;
    pdf_font_num[f] := fontnum;
    set_char_map(f);
end;

procedure pdf_create_font_obj; 
var f, k: internal_font_number;
begin
    f := tmp_f;
    if not font_used[f] then begin
        if pdf_font_map[f] = -1 then
            pdf_font_map[f] := fmlookup(f);
        if (pdf_font_map[f] >= 0) then begin
            k := tfm_of_fm(pdf_font_map[f]);
            if (k <> f) and 
               str_eq_str(font_name[k], font_name[f]) and
               (font_dsize[k] = font_dsize[f]) and
               (get_expand_factor(k) = get_expand_factor(f)) then begin
                pdf_use_font(f, -k);
                return;
            end;
        end;
        pdf_create_obj(obj_type_font, f);
        pdf_use_font(f, obj_ptr);
    end;
end;

@ We need to hold information about used characters in each font for partial
downloading.

@<Types...@>=
char_used_array = array[0..31] of eight_bits; 
char_map_array = array[0..32] of eight_bits; {move chars in range 0..32}

@ @<Glob...@>=
@!pdf_char_used: ^char_used_array; {to mark used chars}
@!pdf_char_map: ^char_map_array; {where to map chars 0..32}
@!pdf_font_size: ^scaled; {used size of font in PDF file}
@!pdf_font_num: ^integer; {mapping between internal font number in \TeX\ and
    font name defined in resources in PDF file}
@!pdf_font_map: ^integer; {index in table of font mappings}
@!pdf_font_list: pointer; {list of used fonts in current page}
@!pdf_resname_prefix: str_number; {global prefix of resources name}
@!last_tokens_string: str_number; {the number of the most recently string
created by |tokens_to_string|}

@ @<Set init...@>=
pdf_resname_prefix := 0;
last_tokens_string := 0;


@ Here we implement reading information from \.{VF} file.

@d vf_max_packet_length = 10000 {max length of character packet in \.{VF} file}

@#
@d vf_error = 61 {label to go to when an error occur}
@d do_char = 70 {label to go to typesetting a character of virtual font}
@#
@d long_char = 242 {\.{VF} command for general character packet}
@d vf_id = 202 {identifies \.{VF} files}
@d put1=133 {typeset a character}

@#
@d vf_byte == getc(vf_file) {get a byte from\.{VF} file}
@d vf_packet(#) == vf_packet_start[vf_packet_base[#] + vf_packet_end
@d vf_packet_end(#) == #]

@#
@d bad_vf(#) == begin vf_err_str := #; goto vf_error; end {go out \.{VF}
processing with an error message}
@d four_cases(#) == #,#+1,#+2,#+3

@#
@d tmp_b0 == tmp_w.qqqq.b0
@d tmp_b1 == tmp_w.qqqq.b1
@d tmp_b2 == tmp_w.qqqq.b2
@d tmp_b3 == tmp_w.qqqq.b3
@d tmp_int == tmp_w.int

@#
@d scaled3u == {convert |tmp_b1..tmp_b3| to an unsigned scaled dimension}
(((((tmp_b3*vf_z)div@'400)+(tmp_b2*vf_z))div@'400)+(tmp_b1*vf_z))div vf_beta
@d scaled4(#) == {convert |tmp_b0..tmp_b3| to a scaled dimension}
  #:=scaled3u;
  if tmp_b0>0 then if tmp_b0=255 then # := # - vf_alpha
@d scaled3(#) == {convert |tmp_b1..tmp_b3| to a scaled dimension}
  #:=scaled3u; @+ if tmp_b1>127 then # := # - vf_alpha
@d scaled2 == {convert |tmp_b2..tmp_b3| to a scaled dimension}
  if tmp_b2>127 then tmp_b1:=255 else tmp_b1:=0;
  scaled3
@d scaled1 == {convert |tmp_b3| to a scaled dimension}
  if tmp_b3>127 then tmp_b1:=255 else tmp_b1:=0;
  tmp_b2:=tmp_b1; scaled3

@<Glob...@>=
@!vf_packet_base: ^integer; {base addresses of character
packets from virtual fonts}
@!vf_default_font: ^internal_font_number; {default font in a \.{VF} file}
@!vf_local_font_num: ^internal_font_number; {number of local fonts in a \.{VF} file}
@!vf_packet_length: integer; {length of the current packet}
@!vf_file: byte_file;
@!vf_nf: internal_font_number; {the local fonts counter}
@!vf_e_fnts: ^integer; {external font numbers}
@!vf_i_fnts: ^internal_font_number; {corresponding internal font numbers}
@!tmp_w: memory_word; {accumulator}
@!vf_z: integer; {multiplier}
@!vf_alpha: integer; {correction for negative values}
@!vf_beta: 1..16; {divisor}

@ @<Set init...@>=
vf_nf := 0;

@ The |do_vf| procedure attempts to read the \.{VF} file for a font, and sets
|pdf_font_type| to |real_font_type| if the \.{VF} file could not be found
or loaded, otherwise sets |pdf_font_type| to |virtual_font_type|.  At this
time, |tmp_f| is the internal font number of the current \.{TFM} font.  To
process font definitions in virtual font we call |vf_def_font|.

@p procedure vf_replace_z;
begin
    vf_alpha:=16;
    while vf_z>=@'40000000 do begin
        vf_z:=vf_z div 2;
        vf_alpha:=vf_alpha+vf_alpha;
    end;
    vf_beta:=256 div vf_alpha;
    vf_alpha:=vf_alpha*vf_z;
end;

function vf_read(k: integer): integer; {read |k| bytes as an integer from \.{VF} file}
var i: integer;
begin
    i := 0;
    while k > 0 do begin
        i := i*256 + vf_byte;
        decr(k);
    end;
    vf_read := i;
end;

procedure vf_local_font_warning(f, k: internal_font_number; s: str_number);
{print a warning message if an error ocurrs during processing local fonts in
\.{VF} file}
begin
    print_nl(s);
    print(" in local font ");
    print(font_name[k]);
    print(" in virtual font ");
    print(font_name[f]);
    print(".vf ignored.");
end;

function vf_def_font(f: internal_font_number): internal_font_number; {process a local font in \.{VF} file}
label found;
var k: internal_font_number;
    s: str_number;
    ds, fs: scaled;
    cs: four_quarters;
    c: integer;
begin
    cs.b0 := vf_byte; cs.b1 := vf_byte; cs.b2 := vf_byte; cs.b3 := vf_byte;
    tmp_b0 := vf_byte; tmp_b1 := vf_byte; tmp_b2 := vf_byte; tmp_b3 := vf_byte;
    scaled4(fs);
    ds := vf_read(4) div @'20;
    tmp_b0 := vf_byte;
    tmp_b1 := vf_byte;
    while tmp_b0 > 0 do begin
        decr(tmp_b0);
        if vf_byte > 0 then
            do_nothing; {skip the font path}
    end;
    str_room(tmp_b1);
    while tmp_b1 > 0 do begin
        decr(tmp_b1);
        append_char(vf_byte);
    end;
    s := make_string;
    for k := font_base + 1 to font_ptr do
        if str_eq_str(font_name[k], s) then begin
            flush_fontname_k(s);
            if (font_dsize[k] = ds) and (font_size[k] = fs) and
               (pdf_font_expand_ratio[k] = pdf_font_expand_ratio[f]) and
               (pdf_font_expand_factor[k] = pdf_font_expand_factor[f]) then
                goto found;
        end;
    k := read_font_info(null_cs, s, "", fs);
found:
    if k <> null_font then begin
        if ((cs.b0 <> 0) or (cs.b1 <> 0) or (cs.b2 <> 0) or (cs.b3 <> 0)) and
           ((font_check[k].b0 <> 0) or (font_check[k].b1 <> 0) or
            (font_check[k].b2 <> 0) or (font_check[k].b3 <> 0)) and
           ((cs.b0 <> font_check[k].b0) or (cs.b1 <> font_check[k].b1) or
            (cs.b2 <> font_check[k].b2) or (cs.b3 <> font_check[k].b3)) then
            vf_local_font_warning(f, k, "checksum mismatch");
        if ds <> font_dsize[k] then
            vf_local_font_warning(f, k, "design size mismatch");
    end;
    if pdf_font_expand_ratio[f] <> 0 then
        set_expand_param(k, f, pdf_font_expand_ratio[f]);
    vf_def_font := k;
end;

procedure do_vf; {process \.{VF} file with font
internal number |f|}
label vf_error;
var cmd, k, n: integer;
    cc, cmd_length: integer;
    tfm_width: scaled;
    vf_err_str, s: str_number;
    stack_level: vf_stack_index;
    save_vf_nf: internal_font_number;
    f: internal_font_number;
begin
    f := tmp_f;
    stack_level := 0;
    pdf_font_type[f] := real_font_type;
    @<Open |vf_file|, return if not found@>;
    @<Process the preamble@>;@/
    @<Process the font definitions@>;@/
    @<Allocate memory for the new virtual font@>;@/
    while cmd <= long_char do begin@/
        @<Build a character packet@>;@/
    end;
    if cmd <> post then
        bad_vf("POST command expected");
    b_close(vf_file);
    pdf_font_type[f] := virtual_font_type;
    return;
vf_error:
    print_nl("Error in processing VF font (");
    print(font_name[f]);
    print(".vf): ");
    print(vf_err_str);
    print(", virtual font will be ignored");
    print_ln;
    b_close(vf_file);
    update_terminal;
end;

@ @<Open |vf_file|, return if not found@>=
pack_file_name(font_name[f], "", ".vf");
if not vf_b_open_in(vf_file) then
    return

@ @<Process the preamble@>=
if vf_byte <> pre then
    bad_vf("PRE command expected");
if vf_byte <> vf_id then
    bad_vf("wrong id byte");
cmd_length := vf_byte;
for k := 1 to cmd_length do
    tmp_int := vf_byte;
tmp_b0 := vf_byte; tmp_b1 := vf_byte; tmp_b2 := vf_byte; tmp_b3 := vf_byte;
if ((tmp_b0 <> 0) or (tmp_b1 <> 0) or (tmp_b2 <> 0) or (tmp_b3 <> 0)) and
   ((font_check[f].b0 <> 0) or (font_check[f].b1 <> 0) or
    (font_check[f].b2 <> 0) or (font_check[f].b3 <> 0)) and
   ((tmp_b0 <> font_check[f].b0) or (tmp_b1 <> font_check[f].b1) or
    (tmp_b2 <> font_check[f].b2) or (tmp_b3 <> font_check[f].b3)) then begin
    print_nl("checksum mismatch in font ");
    print(font_name[f]);
    print(".vf ignored");
end;
if vf_read(4) div @'20 <> font_dsize[f] then begin
    print_nl("design size mismatch in font ");
    print(font_name[f]);
    print(".vf ignored");
end;
update_terminal;
vf_z := font_size[f];
vf_replace_z

@ @<Process the font definitions@>=
cmd := vf_byte;
save_vf_nf := vf_nf;
while (cmd >= fnt_def1) and (cmd <= fnt_def1 + 3) do begin
    vf_e_fnts[vf_nf] := vf_read(cmd - fnt_def1 + 1);
    vf_i_fnts[vf_nf] := vf_def_font(f);
    incr(vf_nf);
    cmd := vf_byte;
end;
vf_default_font[f] := save_vf_nf;
vf_local_font_num[f] := vf_nf - save_vf_nf;

@ @<Allocate memory for the new virtual font@>=
    vf_packet_base[f] := new_vf_packet(f)

@ @<Build a character packet@>=
if cmd = long_char then begin
    vf_packet_length := vf_read(4);
    cc := vf_read(4);
    if not is_valid_char(cc) then
        bad_vf("invalid character code");
    tmp_b0 := vf_byte; tmp_b1 := vf_byte; tmp_b2 := vf_byte; tmp_b3 := vf_byte;
    scaled4(tfm_width);
end
else begin
    vf_packet_length := cmd;
    cc := vf_byte;
    if not is_valid_char(cc) then
        bad_vf("invalid character code");
    tmp_b1 := vf_byte; tmp_b2 := vf_byte; tmp_b3 := vf_byte;
    scaled3(tfm_width);
end;
if vf_packet_length < 0 then
    bad_vf("negative packet length");
if vf_packet_length > vf_max_packet_length then
    bad_vf("packet length too long");
if (tfm_width <> char_width(f)(char_info(f)(cc))) then begin
    print_nl("character width mismatch in font ");
    print(font_name[f]);
    print(".vf ignored");
end;
str_room(vf_packet_length);
while vf_packet_length > 0 do begin
    cmd := vf_byte;
    decr(vf_packet_length);
    @<Cases of \.{DVI} commands that can appear in character packet@>;
    if cmd <> nop then
        append_char(cmd);
    vf_packet_length := vf_packet_length - cmd_length;
    while cmd_length > 0 do begin
        decr(cmd_length);
        append_char(vf_byte);
    end;
end;
if stack_level <> 0 then
    bad_vf("more PUSHs than POPs in character packet");
if vf_packet_length <> 0 then
    bad_vf("invalid packet length or DVI command in packet");
@<Store the packet being built@>;
cmd := vf_byte

@ @<Store the packet being built@>=
s := make_string;
storepacket(f, cc, s);
flush_str(s)

@ @<Cases of \.{DVI} commands that can appear in character packet@>=
if (cmd >= set_char_0) and (cmd <= set_char_0 + 127) then
    cmd_length := 0
else if ((fnt_num_0 <= cmd) and (cmd <= fnt_num_0 + 63)) or
        ((fnt1 <= cmd) and (cmd <= fnt1 + 3)) then begin
    if cmd >= fnt1 then begin
        k := vf_read(cmd - fnt1 + 1);
        vf_packet_length := vf_packet_length - (cmd - fnt1 + 1);
    end
    else
        k := cmd - fnt_num_0;
    if k >= 256 then
        bad_vf("too many local fonts");
    n := 0;
    while (n < vf_local_font_num[f]) and
          (vf_e_fnts[vf_default_font[f] + n] <> k) do
        incr(n);
    if n = vf_local_font_num[f] then
        bad_vf("undefined local font");
    if k <= 63 then
        append_char(fnt_num_0 + k)
    else begin
        append_char(fnt1);
        append_char(k);
    end;
    cmd_length := 0;
    cmd := nop;
end
else case cmd of
set_rule, put_rule: cmd_length := 8;
four_cases(set1):   cmd_length := cmd - set1 + 1;
four_cases(put1):   cmd_length := cmd - put1 + 1;
four_cases(right1): cmd_length := cmd - right1 + 1;
four_cases(w1):     cmd_length := cmd - w1 + 1;
four_cases(x1):     cmd_length := cmd - x1 + 1;
four_cases(down1):  cmd_length := cmd - down1 + 1;
four_cases(y1):     cmd_length := cmd - y1 + 1;
four_cases(z1):     cmd_length := cmd - z1 + 1;
four_cases(xxx1):  begin
    cmd_length := vf_read(cmd - xxx1 + 1);
    vf_packet_length := vf_packet_length - (cmd - xxx1 + 1);
    if cmd_length > vf_max_packet_length then
        bad_vf("packet length too long");
    if cmd_length < 0 then
        bad_vf("string of negative length");
    append_char(xxx1);
    append_char(cmd_length);
    cmd := nop; {|cmd| has been already stored above as |xxx1|}
end;
w0, x0, y0, z0, nop:
    cmd_length := 0;
push, pop:  begin
    cmd_length := 0;
    if cmd = push then
        if stack_level = vf_stack_size then
            overflow("virtual font stack size", vf_stack_size)
        else
            incr(stack_level)
    else
        if stack_level = 0 then
            bad_vf("more POPs than PUSHs in character")
        else
            decr(stack_level);
end;
othercases
    bad_vf("improver DVI command");
endcases

@ The |do_vf_packet| procedure is called in order to interpret the
character packet for a virtual character. Such a packet may contain the
instruction to typeset a character from the same or an other virtual
font; in such cases |do_vf_packet| calls itself recursively. The
recursion level, i.e., the number of times this has happened, is kept
in the global variable |vf_cur_s| and should not exceed |vf_max_recursion|.

@<Constants...@>=
@!vf_max_recursion=10; {\.{VF} files shouldn't recurse beyond this level}
@!vf_stack_size=100; {\.{DVI} files shouldn't |push| beyond this depth}

@ @<Types...@>=
@!vf_stack_index=0..vf_stack_size; {an index into the stack}
@!vf_stack_record=record
    stack_h, stack_v, stack_w, stack_x, stack_y, stack_z: scaled;
end;

@ @<Glob...@>=
@!vf_cur_s: 0..vf_max_recursion; {current recursion level}
@!vf_stack: array [vf_stack_index] of vf_stack_record;
@!vf_stack_ptr: vf_stack_index; {pointer into |vf_stack|}

@ @<Set init...@>=
vf_cur_s := 0;
vf_stack_ptr := 0;

@ Some functions for processing character packets.

@p function packet_read(k: integer): integer; {read |k| bytes as an integer from
character packet}
var i: integer;
begin
    i := 0;
    while k > 0 do begin
        i := i*256 + packet_byte;
        decr(k);
    end;
    packet_read := i;
end;

function packet_scaled(k: integer): integer; {get |k| bytes from packet as a
scaled}
var s: scaled;
begin
    case k of
    1: begin
        tmp_b3 := packet_byte;
        scaled1(s);
    end;
    2: begin
        tmp_b2 := packet_byte;
        tmp_b3 := packet_byte;
        scaled2(s);
    end;
    3: begin
        tmp_b1 := packet_byte;
        tmp_b2 := packet_byte;
        tmp_b3 := packet_byte;
        scaled3(s);
    end;
    4: begin
        tmp_b0 := packet_byte;
        tmp_b1 := packet_byte;
        tmp_b2 := packet_byte;
        tmp_b3 := packet_byte;
        scaled4(s);
    end;
    othercases pdf_error("vf", "invalid number size");
    endcases;
    packet_scaled := s;
end;

procedure do_vf_packet(f: internal_font_number; c: eight_bits); {typeset the \.{DVI} commands in the
character packet for character |c| in current font |f|}
label do_char, continue;
var save_packet_ptr, save_packet_length: pool_pointer;
    save_vf, k, n: internal_font_number;
    base_line, save_h, save_v: scaled;
    cmd: integer;
    char_move: boolean;
    w, x, y, z: scaled;
    s: str_number;
begin
    incr(vf_cur_s);
    if vf_cur_s > vf_max_recursion then
        overflow("max level recursion", vf_max_recursion);
    push_packet_state;
    start_packet(f, c);
    vf_z := font_size[f];
    vf_replace_z;
    save_vf := f;
    f := vf_i_fnts[vf_default_font[save_vf]];
    save_v := cur_v;
    save_h := cur_h;
    w := 0; x := 0; y := 0; z := 0;
    while vf_packet_length > 0 do begin
        cmd := packet_byte;
        @<Do typesetting the \.{DVI} commands in virtual character packet@>;
continue:
    end;
    cur_h := save_h;
    cur_v := save_v;
    pop_packet_state;
    vf_z := font_size[f];
    vf_replace_z;
    decr(vf_cur_s);
end;

@ The following code typesets a character to PDF output.

@d output_one_char(#)==begin
    pdf_check_new_font(f);
    if pdf_font_type[f] = virtual_font_type then
        do_vf_packet(f, #)
    else begin
        pdf_begin_string(f);
        pdf_print_char(f, #);
        adv_char_width(f, char_width(f)(char_info(f)(#)));
    end;
end


@<Do typesetting the \.{DVI} commands in virtual character packet@>=
if (cmd >= set_char_0) and (cmd <= set_char_0 + 127)  then begin
    if not is_valid_char(cmd) then begin
        char_warning(f, cmd);
        goto continue;
    end;
    c := cmd;
    char_move := true;
    goto do_char;
end
else if ((fnt_num_0 <= cmd) and (cmd <= fnt_num_0 + 63)) or (cmd = fnt1) then begin
    if cmd = fnt1 then
        k := packet_byte
    else
        k := cmd - fnt_num_0;
    n := 0;
    while (n < vf_local_font_num[save_vf]) and
          (vf_e_fnts[vf_default_font[save_vf] + n] <> k) do
        incr(n);
    if (n = vf_local_font_num[save_vf]) then
        f := null_font
    else
        f := vf_i_fnts[vf_default_font[save_vf] + n];
end
else case cmd of
push: begin
    vf_stack[vf_stack_ptr].stack_h := cur_h;
    vf_stack[vf_stack_ptr].stack_v := cur_v;
    vf_stack[vf_stack_ptr].stack_w := w;
    vf_stack[vf_stack_ptr].stack_x := x;
    vf_stack[vf_stack_ptr].stack_y := y;
    vf_stack[vf_stack_ptr].stack_z := z;
    incr(vf_stack_ptr);
end;
pop: begin
    decr(vf_stack_ptr);
    cur_h := vf_stack[vf_stack_ptr].stack_h;
    cur_v := vf_stack[vf_stack_ptr].stack_v;
    w := vf_stack[vf_stack_ptr].stack_w;
    x := vf_stack[vf_stack_ptr].stack_x;
    y := vf_stack[vf_stack_ptr].stack_y;
    z := vf_stack[vf_stack_ptr].stack_z;
end;
four_cases(set1), four_cases(put1): begin
    if (set1 <= cmd) and (cmd <= set1 + 3) then begin
        tmp_int := packet_read(cmd - set1 + 1);
        char_move := true;
    end
    else begin
        tmp_int := packet_read(cmd - put1 + 1);
        char_move := false;
    end;
    if not is_valid_char(tmp_int) then begin
        char_warning(f, tmp_int);
        goto continue;
    end;
    c := tmp_int;
    goto do_char;
end;
set_rule, put_rule: begin
    rule_ht := packet_scaled(4);
    rule_wd := packet_scaled(4);
    if (rule_wd > 0) and (rule_ht > 0) then begin
        pdf_set_rule(cur_h, cur_v, rule_wd, rule_ht);
        if cmd = set_rule then
            cur_h := cur_h + rule_wd;
    end;
end;
four_cases(right1):
    cur_h := cur_h + packet_scaled(cmd - right1 + 1);
w0, four_cases(w1): begin
    if cmd > w0 then
        w := packet_scaled(cmd - w0);
    cur_h := cur_h + w;
end;
x0, four_cases(x1): begin
    if cmd > x0 then
        x := packet_scaled(cmd - x0);
    cur_h := cur_h + x;
end;
four_cases(down1):
    cur_v := cur_v + packet_scaled(cmd - down1 + 1);
y0, four_cases(y1): begin
    if cmd > y0 then
        y := packet_scaled(cmd - y0);
    cur_v := cur_v + y;
end;
z0, four_cases(z1): begin
    if cmd > z0 then
        z := packet_scaled(cmd - z0);
    cur_v := cur_v + z;
end;
four_cases(xxx1):  begin
    tmp_int := packet_read(cmd - xxx1 + 1);
    str_room(tmp_int);
    while tmp_int > 0 do begin
        decr(tmp_int);
        append_char(packet_byte);
    end;
    s := make_string;
    literal(s, true, true, false);
    flush_str(s);
end;
othercases pdf_error("vf", "invalid DVI command");
endcases;
goto continue;
do_char:
if is_valid_char(c) then 
    output_one_char(c)
else
    char_warning(f, c);
if char_move then
    cur_h := cur_h + char_width(f)(char_info(f)(c))

@* \[32f] PDF shipping out.
To ship out a \TeX\ box to PDF page description we need to implement
|pdf_hlist_out|, |pdf_vlist_out| and |pdf_ship_out|, which are equivalent to
the \TeX' original |hlist_out|, |vlist_out| and |ship_out| resp. But first we
need to declare some procedures needed in |pdf_hlist_out| and |pdf_vlist_out|.

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
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

function tokens_to_string(p: pointer): str_number; {return a string from tokens
list}
begin
    old_setting:=selector; selector:=new_string;
    show_token_list(link(p),null,pool_size-pool_ptr);
    selector:=old_setting;
    last_tokens_string := make_string;
    tokens_to_string := last_tokens_string;
end;

procedure pdf_print_toks(p: pointer); {print tokens list |p|}
var s: str_number;
begin
    s := tokens_to_string(p);
    if length(s) > 0 then
        pdf_print(s);
    flush_str(s);
end;

procedure pdf_print_toks_ln(p: pointer); {print tokens list |p|}
var s: str_number;
begin
    s := tokens_to_string(p);
    if length(s) > 0 then begin
        pdf_print(s);
        pdf_print_nl;
    end;
    flush_str(s);
end;

@ Similiar to |vlist_out|, |pdf_vlist_out| needs to be declared forward

@p procedure@?pdf_vlist_out; forward;

@ The implementation of procedure |pdf_hlist_out| is similiar to |hlist_out|

@p @t\4@>@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>@t@>@/

procedure pdf_hlist_out; {output an |hlist_node| box}
label reswitch, move_past, fin_rule, next_p;
var base_line: scaled; {the baseline coordinate for this box}
@!left_edge: scaled; {the left coordinate for this box}
@!save_h: scaled; {what |cur_h| should pop to}
@!this_box: pointer; {pointer to containing box}
@!g_order: glue_ord; {applicable order of infinity for glue}
@!g_sign: normal..shrinking; {selects type of glue}
@!p:pointer; {current position in the hlist}
@!leader_box:pointer; {the leader box being replicated}
@!leader_wd:scaled; {width of leader box being replicated}
@!lx:scaled; {extra space between leader boxes}
@!outer_doing_leaders:boolean; {were we doing leaders?}
@!edge:scaled; {left edge of sub-box, or right edge of leader space}
@!running_link: pointer; {pointer to `running' link if exists}
begin this_box:=temp_ptr; g_order:=glue_order(this_box);
g_sign:=glue_sign(this_box); p:=list_ptr(this_box);
incr(cur_s);
base_line:=cur_v; left_edge:=cur_h;
running_link := null;
@<Create link annottation for the current hbox if needed@>;
while p<>null do
    @<Output node |p| for |pdf_hlist_out| and move to the next node,
    maintaining the condition |cur_v=base_line|@>;
decr(cur_s);
end;

@ @<Create link annottation for the current hbox if needed@>=
if running_link = null then begin
    if is_running(pdf_link_wd) and (pdf_link_level = cur_s) then begin
        append_link(this_box, left_edge, base_line);
        running_link := last_link;
    end;
end
else
    last_link := running_link

@ @<Output node |p| for |pdf_hlist_out|...@>=
reswitch: if is_char_node(p) then
  begin
  repeat f:=font(p); c:=character(p);
  if is_valid_char(c) then 
      output_one_char(c)
  else
      char_warning(f, c);
  cur_h:=cur_h+char_width(f)(char_info(f)(c));
  p:=link(p);
  until not is_char_node(p);
  end
else @<Output the non-|char_node| |p| for |pdf_hlist_out|
    and move to the next node@>

@ @<Output the non-|char_node| |p| for |pdf_hlist_out|...@>=
begin case type(p) of
hlist_node,vlist_node:@<(\pdfTeX) Output a box in an hlist@>;
rule_node: begin rule_ht:=height(p); rule_dp:=depth(p); rule_wd:=width(p);
  goto fin_rule;
  end;
whatsit_node: @<Output the whatsit node |p| in |pdf_hlist_out|@>;
glue_node: @<(\pdfTeX) Move right or output leaders@>;
margin_kern_node:cur_h:=cur_h+width(p);
kern_node,math_node:cur_h:=cur_h+width(p);
ligature_node: @<Make node |p| look like a |char_node| and |goto reswitch|@>;
othercases do_nothing
endcases;@/
goto next_p;
fin_rule: @<(\pdfTeX) Output a rule in an hlist@>;
move_past: cur_h:=cur_h+rule_wd;
next_p:p:=link(p);
end

@ @<(\pdfTeX) Output a box in an hlist@>=
if list_ptr(p)=null then cur_h:=cur_h+width(p)
else  begin
  cur_v:=base_line+shift_amount(p); {shift the box down}
  temp_ptr:=p; edge:=cur_h;
  if type(p)=vlist_node then pdf_vlist_out@+else pdf_hlist_out;
  cur_h:=edge+width(p); cur_v:=base_line;
  end

@ @<(\pdfTeX) Output a rule in an hlist@>=
if is_running(rule_ht) then rule_ht:=height(this_box);
if is_running(rule_dp) then rule_dp:=depth(this_box);
rule_ht:=rule_ht+rule_dp; {this is the rule thickness}
if (rule_ht>0)and(rule_wd>0) then {we don't output empty rules}
  begin cur_v:=base_line+rule_dp;
  pdf_set_rule(cur_h, cur_v, rule_wd, rule_ht);
  cur_v:=base_line;
  end

@ @<(\pdfTeX) Move right or output leaders@>=
begin g:=glue_ptr(p); rule_wd:=width(g);
if g_sign<>normal then
  begin if g_sign=stretching then
    begin if stretch_order(g)=g_order then
      rule_wd:=rule_wd+round(float(glue_set(this_box))*stretch(g));
@^real multiplication@>
    end
  else  begin if shrink_order(g)=g_order then
      rule_wd:=rule_wd-round(float(glue_set(this_box))*shrink(g));
    end;
  end;
if subtype(p)>=a_leaders then
  @<(\pdfTeX) Output leaders in an hlist, |goto fin_rule| if a rule
    or to |next_p| if done@>;
goto move_past;
end

@ @<(\pdfTeX) Output leaders in an hlist...@>=
begin leader_box:=leader_ptr(p);
if type(leader_box)=rule_node then
  begin rule_ht:=height(leader_box); rule_dp:=depth(leader_box);
  goto fin_rule;
  end;
leader_wd:=width(leader_box);
if (leader_wd>0)and(rule_wd>0) then
  begin rule_wd:=rule_wd+10; {compensate for floating-point rounding}
  edge:=cur_h+rule_wd; lx:=0;
  @<(\pdfTeX) Let |cur_h| be the position of the first box, and set |leader_wd+lx|
    to the spacing between corresponding parts of boxes@>;
  while cur_h+leader_wd<=edge do
    @<(\pdfTeX) Output a leader box at |cur_h|,
      then advance |cur_h| by |leader_wd+lx|@>;
  cur_h:=edge-10; goto next_p;
  end;
end

@ @<(\pdfTeX) Let |cur_h| be the position of the first box, ...@>=
if subtype(p)=a_leaders then
  begin save_h:=cur_h;
  cur_h:=left_edge+leader_wd*((cur_h-left_edge)div leader_wd);
  if cur_h<save_h then cur_h:=cur_h+leader_wd;
  end
else  begin lq:=rule_wd div leader_wd; {the number of box copies}
  lr:=rule_wd mod leader_wd; {the remaining space}
  if subtype(p)=c_leaders then cur_h:=cur_h+(lr div 2)
  else  begin lx:=(2*lr+lq+1) div (2*lq+2); {round|(lr/(lq+1))|}
    cur_h:=cur_h+((lr-(lq-1)*lx) div 2);
    end;
  end

@ @<(\pdfTeX) Output a leader box at |cur_h|, ...@>=
begin cur_v:=base_line+shift_amount(leader_box);@/
save_h:=cur_h; temp_ptr:=leader_box;
outer_doing_leaders:=doing_leaders; doing_leaders:=true;
if type(leader_box)=vlist_node then pdf_vlist_out@+else pdf_hlist_out;
doing_leaders:=outer_doing_leaders;
cur_v:=base_line;
cur_h:=save_h+leader_wd+lx;
end

@ The |pdf_vlist_out| routine is similar to |pdf_hlist_out|, but a bit simpler.
@p procedure pdf_vlist_out; {output a |pdf_vlist_node| box}
label move_past, fin_rule, next_p;
var left_edge: scaled; {the left coordinate for this box}
@!top_edge: scaled; {the top coordinate for this box}
@!save_v: scaled; {what |cur_v| should pop to}
@!this_box: pointer; {pointer to containing box}
@!g_order: glue_ord; {applicable order of infinity for glue}
@!g_sign: normal..shrinking; {selects type of glue}
@!p:pointer; {current position in the vlist}
@!leader_box:pointer; {the leader box being replicated}
@!leader_ht:scaled; {height of leader box being replicated}
@!lx:scaled; {extra space between leader boxes}
@!outer_doing_leaders:boolean; {were we doing leaders?}
@!edge:scaled; {bottom boundary of leader space}
begin this_box:=temp_ptr; g_order:=glue_order(this_box);
g_sign:=glue_sign(this_box); p:=list_ptr(this_box);
incr(cur_s);
left_edge:=cur_h; cur_v:=cur_v-height(this_box); top_edge:=cur_v;
@<Create thread for the current vbox if needed@>;
while p<>null do
    @<Output node |p| for |pdf_vlist_out| and move to the next node,
    maintaining the condition |cur_h=left_edge|@>;
decr(cur_s);
end;

@ @<Create thread for the current vbox if needed@>=
if (last_thread <> null) and is_running(pdf_thread_dp) and 
    (pdf_thread_level = cur_s) then
    append_thread(this_box, left_edge, top_edge + height(this_box))

@ @<Output node |p| for |pdf_vlist_out|...@>=
begin if is_char_node(p) then confusion("pdfvlistout")
@:this can't happen pdfvlistout}{\quad pdfvlistout@>
else @<Output the non-|char_node| |p| for |pdf_vlist_out|@>;
next_p:p:=link(p);
end

@ @<Output the non-|char_node| |p| for |pdf_vlist_out|@>=
begin case type(p) of
hlist_node,vlist_node:@<(\pdfTeX) Output a box in a vlist@>;
rule_node: begin rule_ht:=height(p); rule_dp:=depth(p); rule_wd:=width(p);
  goto fin_rule;
  end;
whatsit_node: @<Output the whatsit node |p| in |pdf_vlist_out|@>;
glue_node: @<(\pdfTeX) Move down or output leaders@>;
kern_node:cur_v:=cur_v+width(p);
othercases do_nothing
endcases;@/
goto next_p;
fin_rule: @<(\pdfTeX) Output a rule in a vlist, |goto next_p|@>;
move_past: cur_v:=cur_v+rule_ht;
end

@ @<(\pdfTeX) Output a box in a vlist@>=
if list_ptr(p)=null then cur_v:=cur_v+height(p)+depth(p)
else  begin cur_v:=cur_v+height(p); save_v:=cur_v;
  cur_h:=left_edge+shift_amount(p); {shift the box right}
  temp_ptr:=p;
  if type(p)=vlist_node then pdf_vlist_out@+else pdf_hlist_out;
  cur_v:=save_v+depth(p); cur_h:=left_edge;
  end

@ @<(\pdfTeX) Output a rule in a vlist...@>=
if is_running(rule_wd) then rule_wd:=width(this_box);
rule_ht:=rule_ht+rule_dp; {this is the rule thickness}
cur_v:=cur_v+rule_ht;
if (rule_ht>0)and(rule_wd>0) then {we don't output empty rules}
  pdf_set_rule(cur_h, cur_v, rule_wd, rule_ht);
goto next_p

@ @<(\pdfTeX) Move down or output leaders@>=
begin g:=glue_ptr(p); rule_ht:=width(g);
if g_sign<>normal then
  begin if g_sign=stretching then
    begin if stretch_order(g)=g_order then
      rule_ht:=rule_ht+round(float(glue_set(this_box))*stretch(g));
@^real multiplication@>
    end
  else  begin if shrink_order(g)=g_order then
      rule_ht:=rule_ht-round(float(glue_set(this_box))*shrink(g));
    end;
  end;
if subtype(p)>=a_leaders then
  @<(\pdfTeX) Output leaders in a vlist, |goto fin_rule| if a rule
    or to |next_p| if done@>;
goto move_past;
end

@ @<(\pdfTeX) Output leaders in a vlist...@>=
begin leader_box:=leader_ptr(p);
if type(leader_box)=rule_node then
  begin rule_wd:=width(leader_box); rule_dp:=0;
  goto fin_rule;
  end;
leader_ht:=height(leader_box)+depth(leader_box);
if (leader_ht>0)and(rule_ht>0) then
  begin rule_ht:=rule_ht+10; {compensate for floating-point rounding}
  edge:=cur_v+rule_ht; lx:=0;
  @<(\pdfTeX) Let |cur_v| be the position of the first box, and set |leader_ht+lx|
    to the spacing between corresponding parts of boxes@>;
  while cur_v+leader_ht<=edge do
    @<(\pdfTeX) Output a leader box at |cur_v|,
      then advance |cur_v| by |leader_ht+lx|@>;
  cur_v:=edge-10; goto next_p;
  end;
end

@ @<(\pdfTeX) Let |cur_v| be the position of the first box, ...@>=
if subtype(p)=a_leaders then
  begin save_v:=cur_v;
  cur_v:=top_edge+leader_ht*((cur_v-top_edge)div leader_ht);
  if cur_v<save_v then cur_v:=cur_v+leader_ht;
  end
else  begin lq:=rule_ht div leader_ht; {the number of box copies}
  lr:=rule_ht mod leader_ht; {the remaining space}
  if subtype(p)=c_leaders then cur_v:=cur_v+(lr div 2)
  else  begin lx:=(2*lr+lq+1) div (2*lq+2); {round|(lr/(lq+1))|}
    cur_v:=cur_v+((lr-(lq-1)*lx) div 2);
    end;
  end

@ @<(\pdfTeX) Output a leader box at |cur_v|, ...@>=
begin cur_h:=left_edge+shift_amount(leader_box);@/
cur_v:=cur_v+height(leader_box); save_v:=cur_v;
temp_ptr:=leader_box;
outer_doing_leaders:=doing_leaders; doing_leaders:=true;
if type(leader_box)=vlist_node then pdf_vlist_out@+else pdf_hlist_out;
doing_leaders:=outer_doing_leaders;
cur_h:=left_edge;
cur_v:=save_v-height(leader_box)+leader_ht+lx;
end

@ |pdf_ship_out| is used instead of |ship_out| to shipout a box to PDF
output. If |shipping_page| is not set then the output will be a Form object,
otherwise it will be a Page object.

@p procedure pdf_ship_out(p: pointer; shipping_page: boolean); {output the box |p|}
label done, done1;
var i,j,k:integer; {general purpose accumulators}
r: integer; {accumulator to copy node for pending link annotation}
save_font_list: pointer; {to save |pdf_font_list| during flushing pending forms}
save_obj_list: pointer; {to save |pdf_obj_list|}
save_ximage_list: pointer; {to save |pdf_ximage_list|}
save_xform_list: pointer; {to save |pdf_xform_list|}
save_image_procset: integer;  {to save |pdf_image_procset|}
save_text_procset: integer;  {to save |pdf_text_procset|}
pdf_last_resources: integer; {pointer to most recently generated Resources object}
s:str_number;
old_setting:0..max_selector; {saved |selector| setting}
begin if tracing_output>0 then
  begin print_nl(""); print_ln;
  print("Completed box being shipped out");
@.Completed box...@>
  end;
if not init_pdf_output then begin
    @<Initialize variables for \.{PDF} output@>;
    init_pdf_output := true;
end;
is_shipping_page := shipping_page;
if shipping_page then begin
    if term_offset>max_print_line-9 then print_ln
    else if (term_offset>0)or(file_offset>0) then print_char(" ");
    print_char("["); j:=9;
    while (count(j)=0)and(j>0) do decr(j);
    for k:=0 to j do
      begin print_int(count(k));
      if k<j then print_char(".");
      end;
    update_terminal;
end;
if tracing_output>0 then
  begin if shipping_page then print_char("]");
  begin_diagnostic; show_box(p); end_diagnostic(true);
  end;
@<(\pdfTeX) Ship box |p| out@>;
if (tracing_output<=0) and shipping_page then print_char("]");
dead_cycles:=0;
update_terminal; {progress report}
@<(\pdfTeX) Flush the box from memory, showing statistics if requested@>;
end;

@ @<(\pdfTeX) Flush the box from memory, showing statistics if requested@>=
@!stat if tracing_stats>1 then
  begin print_nl("Memory usage before: ");
@.Memory usage...@>
  print_int(var_used); print_char("&");
  print_int(dyn_used); print_char(";");
  end;
tats@/
flush_node_list(p);
@!stat if tracing_stats>1 then
  begin print(" after: ");
  print_int(var_used); print_char("&");
  print_int(dyn_used); print("; still untouched: ");
  print_int(hi_mem_min-lo_mem_max-1); print_ln;
  end;
tats

@ @<(\pdfTeX) Ship box |p| out@>=
@<(\pdfTeX) Update the values of |max_h| and |max_v|; but if the page is too large,
  |goto done|@>;
@<Initialize variables as |pdf_ship_out| begins@>;
if type(p)=vlist_node then pdf_vlist_out@+else pdf_hlist_out;
if shipping_page then
    incr(total_pages);
cur_s:=-1;
@<Finish shipping@>;
done:

@ @<Initialize variables as |pdf_ship_out| begins@>=
temp_ptr:=p;
prepare_mag;
pdf_last_resources := pdf_new_objnum;
@<Reset resources lists@>;
if not shipping_page then begin
    pdf_xform_width := width(p);
    pdf_xform_height := height(p);
    pdf_xform_depth := depth(p);
    pdf_begin_dict(pdf_cur_form);
    pdf_last_stream := pdf_cur_form;
    cur_v := height(p);
    cur_h := 0;
    pdf_origin_h := 0;
    pdf_origin_v := pdf_xform_height + pdf_xform_depth;
end
else begin
    @<Calculate page dimensions and margins@>;
    pdf_last_page := get_obj(obj_type_page, total_pages + 1, 0);
    obj_aux(pdf_last_page) := 1; {mark that this page has beed created}
    pdf_new_dict(obj_type_others, 0);
    pdf_last_stream := obj_ptr;
    cur_h := cur_h_offset;
    cur_v := height(p) + cur_v_offset;
    pdf_origin_h := 0;
    pdf_origin_v := cur_page_height;
    @<Reset PDF mark lists@>;
end;
if not shipping_page then begin
    @<Write out Form stream header@>;
end;
@<Start stream of page/form contents@>

@ @<Reset resources lists@>=
pdf_font_list := null;
pdf_obj_list := null;
pdf_xform_list := null;
pdf_ximage_list := null;
pdf_text_procset := false;
pdf_image_procset := 0

@ @<Reset PDF mark lists@>=
pdf_annot_list := null;
pdf_link_list := null;
pdf_dest_list := null;
pdf_bead_list := null;
last_link := null;
last_thread := null

@ @<Calculate page dimensions and margins@>=
cur_h_offset := pdf_h_origin + h_offset;
cur_v_offset := pdf_v_origin + v_offset;
if pdf_page_width <> 0 then
    cur_page_width := pdf_page_width
else
    cur_page_width := width(p) + 2*cur_h_offset;
if pdf_page_height <> 0 then
    cur_page_height := pdf_page_height
else
    cur_page_height := height(p) + depth(p) + 2*cur_v_offset

@ Here we write out the header for Form.

@<Write out Form stream header@>=
pdf_print_ln("/Type /XObject");
pdf_print_ln("/Subtype /Form");
if obj_xform_attr(pdf_cur_form) <> null then begin
    pdf_print_toks_ln(obj_xform_attr(pdf_cur_form));
    delete_toks(obj_xform_attr(pdf_cur_form));
end;
pdf_print("/BBox [");
pdf_print("0 0 ");
pdf_print_bp(pdf_xform_width); pdf_out(" ");
pdf_print_bp(pdf_xform_height + pdf_xform_depth); pdf_print_ln("]");
pdf_print_ln("/FormType 1");
pdf_print_ln("/Matrix [1 0 0 1 0 0]");
pdf_indirect_ln("Resources", pdf_last_resources)

@ @<Start stream of page/form contents@>=
pdf_begin_stream;
if shipping_page then begin
    @<Adjust tranformation matrix for the magnification ratio@>;
end

@ @<Adjust tranformation matrix for the magnification ratio@>=
if (mag <> 1000) and (mag <> 0) then begin
    pdf_print_real(mag, 3);
    pdf_print(" 0 0 ");
    pdf_print_real(mag, 3);
    pdf_print_ln(" 0 0 cm");
end

@ @<(\pdfTeX) Update the values of |max_h| and |max_v|; but if the page is too large...@>=
if (height(p)>max_dimen)or@|(depth(p)>max_dimen)or@|
   (height(p)+depth(p)+v_offset>max_dimen)or@|
   (width(p)+h_offset>max_dimen) then
  begin print_err("Huge page cannot be shipped out");
@.Huge page...@>
  help2("The page just created is more than 18 feet tall or")@/
   ("more than 18 feet wide, so I suspect something went wrong.");
  error;
  if tracing_output<=0 then
    begin begin_diagnostic;
    print_nl("The following box has been deleted:");
@.The following...deleted@>
    show_box(p);
    end_diagnostic(true);
    end;
  goto done;
  end;
if height(p)+depth(p)+v_offset>max_v then max_v:=height(p)+depth(p)+v_offset;
if width(p)+h_offset>max_h then max_h:=width(p)+h_offset

@ @<Finish shipping@>=
@<Finish stream of page/form contents@>;
if shipping_page then begin
    @<Write out page object@>;
end;
@<Flush out pending raw objects@>;
@<Flush out pending forms@>;
@<Flush out pending images@>;
if shipping_page then begin
    @<Flush out pending PDF marks@>;
end;
@<Write out resources dictionary@>;
@<Flush resources lists@>;
if shipping_page then begin
    @<Flush PDF mark lists@>;
end

@ @<Finish stream of page/form contents@>=
pdf_end_text;
pdf_end_stream

@ @<Write out resources dictionary@>=
pdf_begin_dict(pdf_last_resources);
@<Print additional resources@>;
@<Generate font resources@>;
@<Generate XObject resources@>;
@<Generate ProcSet@>;
pdf_end_dict

@ @<Print additional resources@>=
if shipping_page then begin
    if pdf_page_resources <> null then
        pdf_print_toks_ln(pdf_page_resources);
end
else begin
    if obj_xform_resources(pdf_cur_form) <> null then begin
        pdf_print_toks_ln(obj_xform_resources(pdf_cur_form));
        delete_toks(obj_xform_resources(pdf_cur_form));
    end;
end

@ In the end of shipping out a page we reset all the lists holding objects
have been created during the page shipping.

@d delete_toks(#) == begin delete_token_ref(#); # := null; end

@<Flush resources lists@>=
flush_list(pdf_font_list);
flush_list(pdf_obj_list);
flush_list(pdf_xform_list);
flush_list(pdf_ximage_list)

@ @<Flush PDF mark lists@>=
flush_list(pdf_annot_list);
flush_list(pdf_link_list);
flush_list(pdf_dest_list);
flush_list(pdf_bead_list)

@ @<Generate font resources@>=
if pdf_font_list <> null then begin
    pdf_print("/Font << ");
    k := pdf_font_list;
    while k <> null do begin
        pdf_print("/F");
        set_ff(info(k));
        pdf_print_int(ff);
        pdf_print_font_tag(info(k));
        pdf_print_resname_prefix;
        pdf_out(" ");
        pdf_print_int(pdf_font_num[ff]);
        pdf_print(" 0 R ");
        k := link(k);
    end;
    pdf_print_ln(">>");
    pdf_text_procset := true;
end

@ @<Generate XObject resources@>=
if (pdf_xform_list <> null) or (pdf_ximage_list <> null) then begin
    pdf_print("/XObject << ");
    k := pdf_xform_list;
    while k <> null do begin
        pdf_print("/Fm");
        pdf_print_int(obj_info(info(k)));
        pdf_print_resname_prefix;
        pdf_out(" ");
        pdf_print_int(info(k));
        pdf_print(" 0 R ");
        k := link(k);
    end;
    k := pdf_ximage_list;
    while k <> null do begin
        pdf_print("/Im");
        pdf_print_int(obj_info(info(k)));
        pdf_print_resname_prefix;
        pdf_out(" ");
        pdf_print_int(info(k));
        pdf_print(" 0 R ");
        update_image_procset(obj_ximage_data(info(k)));
        k := link(k);
    end;
    pdf_print_ln(">>");
end

@ @<Generate ProcSet@>=
pdf_print("/ProcSet [ /PDF");
if pdf_text_procset then
    pdf_print(" /Text");
if check_image_b(pdf_image_procset) then
    pdf_print(" /ImageB");
if check_image_c(pdf_image_procset) then
    pdf_print(" /ImageC");
if check_image_i(pdf_image_procset) then
    pdf_print(" /ImageI");
pdf_print_ln(" ]")

@ @<Write out page object@>=
pdf_begin_dict(pdf_last_page);
pdf_print_ln("/Type /Page");
pdf_indirect_ln("Contents", pdf_last_stream);
pdf_indirect_ln("Resources", pdf_last_resources);
pdf_print("/MediaBox [0 0 ");
pdf_print_mag_bp(cur_page_width); pdf_out(" ");
pdf_print_mag_bp(cur_page_height);
pdf_print_ln("]");
if pdf_page_attr <> null then
    pdf_print_toks_ln(pdf_page_attr);
@<Generate parent pages object@>;
@<Generate array of annotations or beads in page@>;
pdf_end_dict

@ @<Generate parent pages object@>=
if total_pages mod pages_tree_kids_max = 1 then begin
    pdf_create_obj(obj_type_pages, pages_tree_kids_max);
    pdf_last_pages := obj_ptr;
end;
pdf_indirect_ln("Parent", pdf_last_pages)

@ @<Generate array of annotations or beads in page@>=
if (pdf_annot_list <> null) or (pdf_link_list <> null) then begin
    pdf_print("/Annots [ ");
    k := pdf_annot_list;
    while k <> null do begin
        pdf_print_int(info(k));
        pdf_print(" 0 R ");
        k := link(k);
    end;
    k := pdf_link_list;
    while k <> null do begin
        pdf_print_int(info(k));
        pdf_print(" 0 R ");
        k := link(k);
    end;
    pdf_print_ln("]");
end;
if pdf_bead_list <> null then begin
    k := pdf_bead_list;
    pdf_print("/B [ ");
    while k <> null do begin
        pdf_print_int(info(k));
        pdf_print(" 0 R ");
        k := link(k);
    end;
    pdf_print_ln("]");
end

@ @<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure pdf_write_obj(n: integer); {write a raw PDF object}
var s: str_number;
    f: byte_file;
begin
    s := tokens_to_string(obj_obj_data(n));
    delete_toks(obj_obj_data(n));
    if obj_obj_is_stream(n) > 0 then begin
        pdf_begin_dict(n);
        if obj_obj_stream_attr(n) <> null then begin
            pdf_print_toks_ln(obj_obj_stream_attr(n));
            delete_toks(obj_obj_stream_attr(n));
        end;
        pdf_begin_stream;
    end
    else
        pdf_begin_obj(n);
    if obj_obj_is_file(n) > 0 then begin
        cur_name := s;
        cur_area := "";
        cur_ext := "";
        pack_cur_name;
        if not tex_b_openin(f) then
            pdf_error("ext5", "cannot open file for embedding");
        print("<<");
        print(s);
        while not eof(f) do
            pdf_out(getc(f));
        print(">>");
        b_close(f);
    end
    else if obj_obj_is_stream(n) > 0 then
        pdf_print(s)
    else
        pdf_print_ln(s);
    if obj_obj_is_stream(n) > 0 then
        pdf_end_stream
    else
        pdf_end_obj;
    flush_str(s);
end;

procedure flush_whatsit_node(p: pointer; s: small_number);
begin
    type(p) := whatsit_node;
    subtype(p) := s;
    if link(p) <> null then
        pdf_error("flush_whatsit_node", "link(p) is not null");
    flush_node_list(p);
end;

@ @<Flush out pending raw objects@>=
if pdf_obj_list <> null then begin
    k := pdf_obj_list;
    while k <> null do begin
        if not is_obj_written(info(k)) then
            pdf_write_obj(info(k));
        k := link(k);
    end;
end

@ When flushing pending forms we need to save and restore resources lists
  (|pdf_font_list|, |pdf_obj_list|, |pdf_xform_list| and |pdf_ximage_list|),
  which are also used by page shipping.

@<Flush out pending forms@>=
if pdf_xform_list <> null then begin
    k := pdf_xform_list;
    while k <> null do begin
        if not is_obj_written(info(k)) then begin
            pdf_cur_form := info(k);
            @<Save resources lists@>;
            @<Reset resources lists@>;
            pdf_ship_out(obj_xform_box(pdf_cur_form), false);
            @<Restore resources lists@>;
        end;
        k := link(k);
    end;
end

@ @<Save resources lists@>=
save_font_list := pdf_font_list;
save_obj_list := pdf_obj_list;
save_xform_list := pdf_xform_list;
save_ximage_list := pdf_ximage_list;
save_text_procset := pdf_text_procset;
save_image_procset := pdf_image_procset

@ @<Restore resources lists@>=
pdf_font_list := save_font_list;
pdf_obj_list := save_obj_list;
pdf_xform_list := save_xform_list;
pdf_ximage_list := save_ximage_list;
pdf_text_procset := save_text_procset;
pdf_image_procset := save_image_procset

@ @<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure pdf_write_image(n: integer); {write an image}
begin
    pdf_begin_dict(n);
    if obj_ximage_attr(n) <> null then begin
        pdf_print_toks_ln(obj_ximage_attr(n));
        delete_toks(obj_ximage_attr(n));
    end;
    write_image(obj_ximage_data(n));
    delete_image(obj_ximage_data(n));
end;

@ @<Flush out pending images@>=
if pdf_ximage_list <> null then begin
    k := pdf_ximage_list;
    while k <> null do begin
        if not is_obj_written(info(k)) then
            pdf_write_image(info(k));
        k := link(k);
    end;
end

@ @<Flush out pending PDF marks@>=
pdf_origin_h := 0;
pdf_origin_v := cur_page_height;
@<Flush out PDF annotations@>;
@<Flush out PDF link annotations@>;
@<Flush out PDF mark destinations@>;
@<Flush out PDF bead rectangle specifications@>

@ @<Flush out PDF annotations@>=
if pdf_annot_list <> null then begin
    k := pdf_annot_list;
    while k <> null do begin
        i := obj_annot_ptr(info(k)); {|i| points to |pdf_annot_node|}
        pdf_begin_dict(info(k));
        pdf_print_ln("/Type /Annot");
        pdf_print_toks_ln(pdf_annot_data(i));
        pdf_rectangle(pdf_left(i), pdf_top(i), pdf_right(i), pdf_bottom(i));
        pdf_end_dict;
        k := link(k);
    end;
end

@ @<Flush out PDF link annotations@>=
if pdf_link_list <> null then begin
    @<Write out PDF link annotations@>;
    @<Free PDF link annotations@>;
end

@ @<Write out PDF link annotations@>=
k := pdf_link_list;
while k <> null do begin
    i := obj_annot_ptr(info(k));
    pdf_begin_dict(info(k));
    pdf_print_ln("/Type /Annot");
    if pdf_link_attr(i) <> null then
        pdf_print_toks_ln(pdf_link_attr(i));
    pdf_rectangle(pdf_left(i), pdf_top(i), pdf_right(i), pdf_bottom(i));
    if pdf_action_type(pdf_link_action(i)) <> pdf_action_user
    then begin
        pdf_print_ln("/Subtype /Link");
        pdf_print("/A ");
    end;
    write_action(pdf_link_action(i));
    pdf_end_dict;
    k := link(k);
end

@ @<Free PDF link annotations@>=
k := pdf_link_list;
while k <> null do begin
    i := obj_annot_ptr(info(k));
    {nodes with |info = null| were created by |append_link| and 
     must be flushed here, as they are not linked in any list}
    if info(i) = max_halfword then
        flush_whatsit_node(i, pdf_start_link_node);
    k := link(k);
end

@ @<Flush out PDF mark destinations@>=
if pdf_dest_list <> null then begin
    k := pdf_dest_list;
    while k <> null do begin
        if is_obj_written(info(k)) then
            pdf_error("ext5", 
                "destination has been already written (this shouldn't happen)")
        else begin
            i := obj_dest_ptr(info(k));
            if pdf_dest_named_id(i) > 0 then begin
                pdf_begin_dict(info(k));
                pdf_print("/D ");
            end
            else
                pdf_begin_obj(info(k));
            pdf_out("["); pdf_print_int(pdf_last_page); pdf_print(" 0 R ");
            case pdf_dest_type(i) of
            pdf_dest_xyz: begin
                pdf_print("/XYZ ");
                pdf_print_mag_bp(pdf_x(pdf_left(i))); pdf_out(" ");
                pdf_print_mag_bp(pdf_y(pdf_top(i))); pdf_out(" ");
                if pdf_dest_xyz_zoom(i) = null then
                    pdf_print("null")
                else begin
                    pdf_print_int(pdf_dest_xyz_zoom(i) div 1000);
                    pdf_out(".");
                    pdf_print_int((pdf_dest_xyz_zoom(i) mod 1000));
                end;
            end;
            pdf_dest_fit:
                pdf_print("/Fit");
            pdf_dest_fith: begin
                pdf_print("/FitH ");
                pdf_print_mag_bp(pdf_y(pdf_top(i)));
            end;
            pdf_dest_fitv: begin
                pdf_print("/FitV ");
                pdf_print_mag_bp(pdf_x(pdf_left(i)));
            end;
            pdf_dest_fitb:
                pdf_print("/FitB");
            pdf_dest_fitbh: begin
                pdf_print("/FitBH ");
                pdf_print_mag_bp(pdf_y(pdf_top(i)));
            end;
            pdf_dest_fitbv: begin
                pdf_print("/FitBV ");
                pdf_print_mag_bp(pdf_x(pdf_left(i)));
            end;
            pdf_dest_fitr: begin
                pdf_print("/FitR ");
                pdf_print_rect_spec(i);
            end;
            othercases pdf_error("ext5", "unknown dest type");
            endcases;
            pdf_print_ln("]");
            if pdf_dest_named_id(i) > 0 then
                pdf_end_dict
            else
                pdf_end_obj;
        end;
        k := link(k);
    end;
end

@ @<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure pdf_print_rect_spec(r: pointer); {prints a rect spec}
begin
    pdf_print_mag_bp(pdf_x(pdf_left(r)));
    pdf_out(" ");
    pdf_print_mag_bp(pdf_y(pdf_bottom(r)));
    pdf_out(" ");
    pdf_print_mag_bp(pdf_x(pdf_right(r)));
    pdf_out(" ");
    pdf_print_mag_bp(pdf_y(pdf_top(r)));
end;

@ @<Flush out PDF bead rectangle specifications@>=
if pdf_bead_list <> null then begin
    k := pdf_bead_list;
    while k <> null do begin
        pdf_new_obj(obj_type_others, 0);
        pdf_out("[");
        i := obj_bead_data(info(k)); {pointer to a whasit or whatsit-like node}
        pdf_print_rect_spec(i);
        if info(i) = max_halfword then {not a whatsit node, so must be destroyed here}
            flush_whatsit_node(i, pdf_start_thread_node);
        pdf_print_ln("]");
        obj_bead_rect(info(k)) := obj_ptr; {rewrite |obj_bead_data|}
        pdf_end_obj;
        k := link(k);
    end;
end

@ In the end we must flush PDF objects that cannot be written out
immediately after shipping out pages.

@ @<Output outlines@>=
if pdf_first_outline <> 0 then begin
    pdf_new_dict(obj_type_others, 0);
    outlines := obj_ptr;
    l := pdf_first_outline; k := 0;
    repeat
        incr(k);
        a := open_subentries(l);
        if obj_outline_count(l) > 0 then
            k := k + a;
        obj_outline_parent(l) := obj_ptr;
        l := obj_outline_next(l);
    until l = 0;
    pdf_print_ln("/Type /Outlines");
    pdf_indirect_ln("First", pdf_first_outline);
    pdf_indirect_ln("Last", pdf_last_outline);
    pdf_int_entry_ln("Count", k);
    pdf_end_dict;
    @<Output PDF outline entries@>;
end
else
    outlines := 0

@ @<Output PDF outline entries@>=
k := head_tab[obj_type_outline];
while k <> 0 do begin
    if obj_outline_parent(k) = pdf_parent_outline then begin
        if obj_outline_prev(k) = 0 then
            pdf_first_outline := k;
        if obj_outline_next(k) = 0 then
            pdf_last_outline := k;
    end;
    pdf_begin_dict(k);
    pdf_indirect_ln("Title", obj_outline_title(k));
    pdf_indirect_ln("A", obj_outline_action_objnum(k));
    if obj_outline_parent(k) <> 0 then
        pdf_indirect_ln("Parent", obj_outline_parent(k));
    if obj_outline_prev(k) <> 0 then
        pdf_indirect_ln("Prev", obj_outline_prev(k));
    if obj_outline_next(k) <> 0 then
        pdf_indirect_ln("Next", obj_outline_next(k));
    if obj_outline_first(k) <> 0 then
        pdf_indirect_ln("First", obj_outline_first(k));
    if obj_outline_last(k) <> 0 then
        pdf_indirect_ln("Last", obj_outline_last(k));
    if obj_outline_count(k) <> 0 then
        pdf_int_entry_ln("Count", obj_outline_count(k));
    if obj_outline_attr(k) <> 0 then begin
        pdf_print_toks_ln(obj_outline_attr(k));
        delete_toks(obj_outline_attr(k));
    end;
    pdf_end_dict;
    k := obj_link(k);
end

@ @<Output article threads@>=
if head_tab[obj_type_thread] <> 0 then begin
    pdf_new_obj(obj_type_others, 0);
    threads := obj_ptr;
    pdf_out("[");
    k := head_tab[obj_type_thread];
    while k <> 0 do begin
        pdf_print_int(k);
        pdf_print(" 0 R ");
        k := obj_link(k);
    end;
    remove_last_space;
    pdf_print_ln("]");
    pdf_end_obj;
    k := head_tab[obj_type_thread];
    while k <> 0 do begin
        out_thread(k);
        k := obj_link(k);
    end;
end
else
    threads := 0

@ Now we are ready to declare our new procedure |ship_out|.  It will call
|pdf_ship_out| if integer parametr |pdf_output| is positive; otherwise it
will call |dvi_ship_out|, which is the \TeX\ original |ship_out|. 

@p procedure ship_out(p:pointer); {output the box |p|}
begin
    if total_pages = 0 then
        fixed_output := pdf_output
    else begin 
        if fixed_output <> pdf_output then
            pdf_error("setup", 
               "\pdfoutput cannot be changed after shipping out the first page");
        end;
    if pdf_output > 0 then
        pdf_ship_out(p, true)
    else
        dvi_ship_out(p);
end;

@ @<Initialize variables for \.{PDF} output@>=
ensure_pdf_open;
check_and_set_pdfoptionpdfminorversion;
prepare_mag;
if (mag <> 1000) and (mag <> 0) then begin
    mag_cfg_dimen_pars;
end;
fixed_decimal_digits := fix_int(pdf_decimal_digits, 0, 4);
min_bp_val := 
    divide_scaled(one_hundred_bp, ten_pow[fixed_decimal_digits + 2], 0);
fixed_pk_resolution := fix_int(pdf_pk_resolution, 72, 2400);
pk_scale_factor := 
    divide_scaled(72, fixed_pk_resolution, 5 + fixed_decimal_digits);
set_job_id(year, month, day, time, pdftex_version, pdftex_revision);
if (pdf_unique_resname > 0) and (pdf_resname_prefix = 0) then
    pdf_resname_prefix := get_resname_prefix

@ Finishing the PDF output file.

The following procedures sort the table of destination names
@p function str_less_str(s1, s2: str_number): boolean; {compare two strings}
var j1, j2: pool_pointer;
    l, i: integer;
begin
    j1 := str_start[s1];
    j2 := str_start[s2];
    if length(s1) < length(s2) then
        l := length(s1)
    else
        l := length(s2);
    i := 0;
    while (i < l) and (str_pool[j1 + i] = str_pool[j2 + i]) do
        incr(i);
    if ((i < l) and (str_pool[j1 + i] < str_pool[j2 + i])) or
        ((i = l) and (length(s1) < length(s2))) then
        str_less_str := true
    else
        str_less_str := false;
end;

procedure sort_dest_names(l, r: integer); {sorts |dest_names| by names}
var i, j: integer;
    s: str_number;
    x, y: integer;
    e: dest_name_entry;
begin
    i := l;
    j := r;
    s := dest_names[(l + r) div 2].objname;
    repeat
        while str_less_str(dest_names[i].objname, s) do
            incr(i);
        while str_less_str(s, dest_names[j].objname) do
            decr(j);
        if i <= j then begin
            e := dest_names[i];
            dest_names[i] := dest_names[j];
            dest_names[j] := e;
            incr(i);
            decr(j);
        end;
    until i > j;
    if l < j then
        sort_dest_names(l, j);
    if i < r then
        sort_dest_names(i, r);
end;

@  Now the finish of PDF output file. At this moment all Page object
are already written completly to PDF output file.

@<Finish the PDF file@>=
if total_pages=0 then print_nl("No pages of output.")
@.No pages of output@>
else begin
    pdf_flush; {to make sure that the output file name has been already
    created}
    if total_pages mod pages_tree_kids_max <> 0 then
        obj_info(pdf_last_pages) := total_pages mod pages_tree_kids_max;
    {last pages object may have less than |pages_tree_kids_max| chilrend}
    @<Check for non-existing pages@>;
    @<Reverse the linked list of Page and Pages objects@>;
    @<Check for non-existing destinations@>;
    @<Output fonts definition@>;
    @<Output pages tree@>;
    @<Output outlines@>;
    @<Output name tree@>;
    @<Output article threads@>;
    @<Output the catalog object@>;
    pdf_print_info;
    @<Output the |obj_tab|@>;
    @<Output the trailer@>;
    pdf_flush;
    print_nl("Output written on "); slow_print(output_file_name);
  @.Output written on x@>
    print(" ("); print_int(total_pages); print(" page");
    if total_pages<>1 then print_char("s");
    print(", "); print_int(pdf_offset); print(" bytes).");
    libpdffinish;
    b_close(pdf_file);
end

@ Destinations that have been referenced but don't exists have
|obj_dest_ptr=null|. Leaving them undefined might cause troubles for
PDF browsers, so we need to fix them.

@p procedure pdf_fix_dest(k: integer);
begin
    if obj_dest_ptr(k) <> null then 
        return;
    pdf_warning("dest", "", false);
    if obj_info(k) < 0 then begin
        print("name{");
        print(-obj_info(k));
        print("}");
    end
    else begin
        print("num");
        print_int(obj_info(k));
    end;
    print(" has been referenced but does not exist, replaced by a fixed one");
    print_ln; print_ln;
    pdf_begin_obj(k);
    pdf_out("[");
    pdf_print_int(head_tab[obj_type_page]);
    pdf_print_ln(" 0 R /Fit]");
    pdf_end_obj;
end;

@ @<Check for non-existing destinations@>=
k := head_tab[obj_type_dest];
while k <> 0 do begin
    pdf_fix_dest(k);
    k := obj_link(k);
end

@ @<Check for non-existing pages@>=
k := head_tab[obj_type_page];
while obj_aux(k) = 0 do begin
    pdf_warning("dest", "Page ", false);
    print_int(obj_info(k));
    print(" has been referenced but does not exist!");
    print_ln; print_ln;
    k := obj_link(k);
end;
head_tab[obj_type_page] := k

@ @<Reverse the linked list of Page and Pages objects@>=
k := head_tab[obj_type_page];
l := 0;
repeat
    i := obj_link(k);
    obj_link(k) := l;
    l := k;
    k := i;
until k = 0;
head_tab[obj_type_page] := l;
k := head_tab[obj_type_pages];
l := 0;
repeat
    i := obj_link(k);
    obj_link(k) := l;
    l := k;
    k := i;
until k = 0;
head_tab[obj_type_pages] := l

@ @<Output fonts definition@>=
for k := font_base + 1 to font_ptr do
    if (font_used[k]) and (pdf_font_map[k] >= 0) then begin
        if (pdf_font_num[k] < 0) then
            i := -pdf_font_num[k]
        else 
            i := tfm_of_fm(pdf_font_map[k]);
        if i <> k then
            for j := 0 to 255 do
                if pdf_char_marked(k, j) then
                    pdf_mark_char(i, j);
    end;
k := head_tab[obj_type_font];
while k <> 0 do begin
    f := obj_info(k);
    do_pdf_font(k, f);
    k := obj_link(k);
end

@ We will generate in each single step the parents of all Pages/Page objects in
the previous level. These new generated Pages object will create a new level of
Pages tree. We will repeat this until search only one Pages object. This one
will be the Root object.

@<Output pages tree@>=
a := obj_ptr + 1; {all Pages object whose childrend are not Page objects
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

@ The name tree is very similiar to Pages tree so its construction should be
certain from Pages tree construction. For intermediate node |obj_info| will be
the first name and |obj_link| will be the last name in \.{\\Limits} array.
Note that |pdf_dest_names_ptr| will be less than |obj_ptr|, so we test if
|k < pdf_dest_names_ptr| then |k| is index of leaf in |dest_names|; else
|k| will be index in |obj_tab| of some intermediate node.

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

@ @<Output the catalog object@>=
pdf_new_dict(obj_type_others, 0);
root := obj_ptr;
pdf_print_ln("/Type /Catalog");
pdf_indirect_ln("Pages", pdf_last_pages);
if threads <> 0 then
    pdf_indirect_ln("Threads", threads);
if outlines <> 0 then
    pdf_indirect_ln("Outlines", outlines);
if names_tree <> 0 then
    pdf_indirect_ln("Names", names_tree);
if pdf_catalog_toks <> null then begin
    pdf_print_toks_ln(pdf_catalog_toks);
    delete_toks(pdf_catalog_toks);
end;
if pdf_catalog_openaction <> 0 then
    pdf_indirect_ln("OpenAction", pdf_catalog_openaction);
pdf_str_entry_ln("PTEX.Fullbanner", pdftex_banner);
pdf_end_dict

@ If the same keys in a dictionary are given several times,
then it is not defined which value is choosen by an application.
Therefore the keys |/Producer| and |/Creator| are only set,
if the token list |pdf_info_toks|, converted to a string does
not contain these key strings.

@p function substr_of_str(s, t: str_number):boolean;
label continue,exit;
var j, k, kk: pool_pointer; {running indices}
begin
    k:=str_start[t];
    while (k < str_start[t+1] - length(s)) do begin
        j:=str_start[s];
        kk:=k;
        while (j < str_start[s+1]) do begin
            if str_pool[j] <> str_pool[kk] then
                goto continue;
            incr(j);
            incr(kk);
        end;
        substr_of_str:=true;
        return;
        continue: incr(k);
    end;
    substr_of_str:=false;
end;

procedure pdf_print_info; {print info object}
var s: str_number;
    creator_given, producer_given, creationdate_given: boolean;
begin
    pdf_new_dict(obj_type_others, 0);
    creator_given:=false;
    producer_given:=false;
    creationdate_given:=false;
    if pdf_info_toks <> null then begin
        s:=tokens_to_string(pdf_info_toks);
        creator_given:=substr_of_str("/Creator", s);
        producer_given:=substr_of_str("/Producer", s);
        creationdate_given:=substr_of_str("/CreationDate", s);
    end;
    if not producer_given then begin
        @<Print the Producer key@>;
    end;
    if pdf_info_toks <> null then begin
        if length(s) > 0 then begin
            pdf_print(s);
            pdf_print_nl;
        end;
        flush_str(s);
        delete_toks(pdf_info_toks);
    end;
    if not creator_given then
        pdf_str_entry_ln("Creator", "TeX");
    if not creationdate_given then begin
        @<Print the CreationDate key@>;
    end;
    pdf_end_dict
end;

@ @<Print the Producer key@>=
pdf_print("/Producer (pdfTeX-");
pdf_print_int(pdftex_version div 100);
pdf_out(".");
pdf_print_int(pdftex_version mod 100);
pdf_print(pdftex_revision);
pdf_print_ln(")")

@ @<Print the CreationDate key@>=
print_creation_date;

@ @<Glob...@>=
@!pdftex_banner: str_number;   {the complete banner}

@ @<Output the |obj_tab|@>=
l := 0;
for k := 1 to obj_ptr do
    if obj_offset(k) = 0 then begin
        obj_link(l) := k;
        l := k;
    end;
obj_link(l) := 0;
pdf_save_offset := pdf_offset;
pdf_print_ln("xref");
pdf_print("0 "); pdf_print_int_ln(obj_ptr + 1);
pdf_print_fw_int(obj_link(0), 10);
pdf_print_ln(" 65535 f ");
for k := 1 to obj_ptr do begin
    if obj_offset(k) = 0 then begin
        pdf_print_fw_int(obj_link(k), 10);
        pdf_print_ln(" 00000 f ");
    end
    else begin
        pdf_print_fw_int(obj_offset(k), 10);
        pdf_print_ln(" 00000 n ");
    end;
end

@ @<Output the trailer@>=
pdf_print_ln("trailer");
pdf_print_ln("<<");
pdf_int_entry_ln("Size", obj_ptr + 1);
pdf_indirect_ln("Root", root);
pdf_indirect_ln("Info", obj_ptr);
if pdf_trailer_toks <> null then begin
    pdf_print_toks_ln(pdf_trailer_toks);
    delete_toks(pdf_trailer_toks);
end;
print_ID(output_file_name);
pdf_print_ln(">>");
pdf_print_ln("startxref");
pdf_print_int_ln(pdf_save_offset);
pdf_print_ln("%%EOF")

@* \[33] Packaging.
@z

@x [649] - HZ
@ Here now is |hpack|, which contains few if any surprises.

@p function hpack(@!p:pointer;@!w:scaled;@!m:small_number):pointer;
@y 
@ @<Glob...@>=
@!font_expand_ratio: integer;
@!last_leftmost_char: pointer;
@!last_rightmost_char: pointer;

@ @d cal_margin_kern_var(#) ==
begin
    character(cp) := character(#);
    font(cp) := font(#);
    do_subst_font(cp, 1000);
    if font(cp) <> font(#) then
        margin_kern_stretch := margin_kern_stretch + left_pw(#) - left_pw(cp);
    font(cp) := font(#);
    do_subst_font(cp, -1000);
    if font(cp) <> font(#) then
        margin_kern_shrink := margin_kern_shrink + left_pw(cp) - left_pw(#);
end
    
@<Calculate variations of marginal kerns@>=
begin
    lp := last_leftmost_char;
    rp := last_rightmost_char;
    fast_get_avail(cp);
    if lp <> null then
        cal_margin_kern_var(lp);
    if rp <> null then
        cal_margin_kern_var(rp);
    free_avail(cp);
end

@ Here now is |hpack|, which is place where we do font substituting when
font expansion is being used. 

@# {constants used when calling |hpack| to deal with font expansion}
@d cal_expand_ratio    == 2 {calculate amount for font expansion after breaking
                             paragraph into lines}
@d subst_ex_font       == 3 {substitute fonts}

@d substituted = 3 {|subtype| of kern nodes that should be substituted}

@d left_pw(#) == char_pw(#, left_side)
@d right_pw(#) == char_pw(#, right_side)

@p
function check_expand_pars(f: internal_font_number): boolean;
var k: internal_font_number;
begin
    check_expand_pars := false;
    if (pdf_font_step[f] = 0) or ((pdf_font_stretch[f] = null_font) and 
                                  (pdf_font_shrink[f] = null_font)) then
        return;
    if cur_font_step < 0 then
        cur_font_step := pdf_font_step[f]
    else if cur_font_step <> pdf_font_step[f] then
        pdf_error("HZ", "using fonts with different step of expansion in one paragraph is not allowed");
    k := pdf_font_stretch[f];
    if k <> null_font then begin
        if max_stretch_ratio < 0 then
            max_stretch_ratio := pdf_font_expand_ratio[k]
        else if max_stretch_ratio <> pdf_font_expand_ratio[k] then
            pdf_error("HZ", "using fonts with different limit of expansion in one paragraph is not allowed");
    end;
    k := pdf_font_shrink[f];
    if k <> null_font then begin
        if max_shrink_ratio < 0 then
            max_shrink_ratio := pdf_font_expand_ratio[k]
        else if max_shrink_ratio <> pdf_font_expand_ratio[k] then
            pdf_error("HZ", "using fonts with different limit of expansion in one paragraph is not allowed");
    end;
    check_expand_pars := true;
end;

function char_stretch(f: internal_font_number; c: eight_bits): scaled;
var k: internal_font_number;
    dw: scaled;
    ef: integer;
begin
    char_stretch := 0;
    k := pdf_font_stretch[f];
    ef := get_ef_code(f, c);
    if (k <> null_font) and (ef > 0) then begin
        dw := char_width(k)(char_info(k)(c)) - char_width(f)(char_info(f)(c));
        if dw > 0 then
            char_stretch := round_xn_over_d(dw, ef, 1000);
    end;
end;

function char_shrink(f: internal_font_number; c: eight_bits): scaled;
var k: internal_font_number;
    dw: scaled;
    ef: integer;
begin
    char_shrink := 0;
    k := pdf_font_shrink[f];
    ef := get_ef_code(f, c);
    if (k <> null_font) and (ef > 0) then begin
        dw := char_width(f)(char_info(f)(c)) - char_width(k)(char_info(k)(c));
        if dw > 0 then
            char_shrink := round_xn_over_d(dw, ef, 1000);
    end;
end;

function get_kern(f: internal_font_number; lc, rc: eight_bits): scaled;
label continue;
var i: four_quarters;
    j: four_quarters;
    k: font_index;
    p: pointer;
    s: integer;
begin
    get_kern := 0;
    i := char_info(f)(lc);
    if char_tag(i) <> lig_tag then
        return;
    k := lig_kern_start(f)(i);
    j := font_info[k].qqqq;
    if skip_byte(j) <= stop_flag then
        goto continue + 1;
    k := lig_kern_restart(f)(j);
continue:
    j := font_info[k].qqqq;
continue + 1:
    if (next_char(j) = rc) and (skip_byte(j) <= stop_flag) and 
       (op_byte(j) >= kern_flag)
    then begin
        get_kern := char_kern(f)(j);
        return;
    end;
    if skip_byte(j) = qi(0) then
        incr(k)
    else begin
        if skip_byte(j) >= stop_flag then
            return;
        k := k + qo(skip_byte(j)) + 1;
    end;
    goto continue;
end;

function kern_stretch(p: pointer): scaled;
var l, r: pointer;
    d: scaled;
begin
    kern_stretch := 0;
    if (prev_char_p = null) or (link(prev_char_p) <> p) or (link(p) = null)
    then
        return;
    l := prev_char_p;
    r := link(p);
    if type(l) = ligature_node then
        l := lig_char(l);
    if type(r) = ligature_node then
        r := lig_char(r);
    if not (is_char_node(l) and is_char_node(r) and 
            (font(l) = font(r)) and 
            (pdf_font_stretch[font(l)] <> null_font))
    then
        return;
    d := get_kern(pdf_font_stretch[font(l)], character(l), character(r));
    kern_stretch := round_xn_over_d(d - width(p), 
                                    get_ef_code(font(l), character(l)), 1000);
end;

function kern_shrink(p: pointer): scaled;
var l, r: pointer;
    d: scaled;
begin
    kern_shrink := 0;
    if (prev_char_p = null) or (link(prev_char_p) <> p) or (link(p) = null)
    then
        return;
    l := prev_char_p;
    r := link(p);
    if type(l) = ligature_node then
        l := lig_char(l);
    if type(r) = ligature_node then
        r := lig_char(r);
    if not (is_char_node(l) and is_char_node(r) and 
            (font(l) = font(r)) and 
            (pdf_font_shrink[font(l)] <> null_font))
    then
        return;
    d := get_kern(pdf_font_shrink[font(l)], character(l), character(r));
    kern_shrink := round_xn_over_d(width(p) - d, 
                                    get_ef_code(font(l), character(l)), 1000);
end;

procedure do_subst_font(p: pointer; ex_ratio: integer);
var f, k: internal_font_number;
    r: pointer;
    ef: integer;
begin
    if not is_char_node(p) and (type(p) = disc_node) then begin
        r := pre_break(p);
        while r <> null do begin
            if is_char_node(r) or (type(r) = ligature_node) then
                do_subst_font(r, ex_ratio);
            r := link(r);
        end;
        r := post_break(p);
        while r <> null do begin
            if is_char_node(r) or (type(r) = ligature_node) then
                do_subst_font(r, ex_ratio);
            r := link(r);
        end;
        return;
    end;
    if is_char_node(p) then
        r := p
    else if type(p) = ligature_node then
        r := lig_char(p)
    else begin
        short_display_n(p, 5);
        pdf_error("HZ", "invalid node type");
    end;
    f := font(r);
    ef := get_ef_code(f, character(r));
    if ef = 0 then
        return;
    if (pdf_font_stretch[f] <> null_font) and (ex_ratio > 0) then
        k := expand_font(f, divide_scaled(ex_ratio*
                                pdf_font_expand_ratio[pdf_font_stretch[f]]*ef,
                                1000000, 0))
    else if (pdf_font_shrink[f] <> null_font) and (ex_ratio < 0) then
        k := expand_font(f, -divide_scaled(ex_ratio*
                                pdf_font_expand_ratio[pdf_font_shrink[f]]*ef,
                                1000000, 0))
    else
        k := f;
    if k <> f then begin
        font(r) := k;
        if not is_char_node(p) then begin
            r := lig_ptr(p);
            while r <> null do begin
                font(r) := k;
                r := link(r);
            end;
        end;
    end;
end;

function char_pw(p: pointer; side: small_number): scaled;
var f: internal_font_number;
    c: integer;
begin
    char_pw := 0;
    if side = left_side then
        last_leftmost_char := null
    else
        last_rightmost_char := null;
    if p = null then
        return;
    if type(p) = ligature_node then
        p := lig_char(p)
    else if not is_char_node(p) then
        return;
    f := font(p);
    if side = left_side then begin
        c := get_lp_code(f, character(p));
        last_leftmost_char := p;
    end
    else begin
        c := get_rp_code(f, character(p));
        last_rightmost_char := p;
    end;
    if c = 0 then
        return;
    char_pw := 
        round_xn_over_d(quad(f), c, 1000);
end;

function new_margin_kern(w: scaled; p: pointer; side: small_number): pointer;
var k: pointer;
begin
    k := get_node(margin_kern_node_size);
    type(k) := margin_kern_node;
    subtype(k) := side;
    width(k) := w;
    if p = null then
        pdf_error("protruding", "invalid pointer to marginal char node");
    fast_get_avail(margin_char(k));
    character(margin_char(k)) := character(p);
    font(margin_char(k)) := font(p);
    new_margin_kern := k;
end;

function hpack(@!p:pointer;@!w:scaled;@!m:small_number):pointer;
@z


@x [649] - HZ
begin last_badness:=0; r:=get_node(box_node_size); type(r):=hlist_node;
subtype(r):=min_quarterword; shift_amount(r):=0;
q:=r+list_offset; link(q):=p;@/
@y
font_stretch: scaled;
font_shrink: scaled;
k: scaled;
begin last_badness:=0; r:=get_node(box_node_size); type(r):=hlist_node;
subtype(r):=min_quarterword; shift_amount(r):=0;
q:=r+list_offset; link(q):=p;@/
if m = cal_expand_ratio then begin
    prev_char_p := null;
    font_stretch := 0;
    font_shrink := 0;
    font_expand_ratio := 0;
end;
@z

@x [649] - pre vadjust
if adjust_tail<>null then link(adjust_tail):=null;
@y
if adjust_tail<>null then link(adjust_tail):=null;
if pre_adjust_tail<>null then link(pre_adjust_tail):=null;
@z

@x [649] - HZ
exit: hpack:=r;
@y
exit:
if (m = cal_expand_ratio) and (font_expand_ratio <> 0) then begin
    font_expand_ratio := fix_int(font_expand_ratio, -1000, 1000);
    q := list_ptr(r);
    free_node(r, box_node_size);
    r := hpack(q, w, subst_ex_font);
end;
hpack:=r;
@z

@x [651] - HZ
  kern_node,math_node: x:=x+width(p);
@y
  math_node: x:=x+width(p);
  margin_kern_node: begin
    if m = cal_expand_ratio then begin
        f := font(margin_char(p));
        do_subst_font(margin_char(p), 1000);
        if f <> font(margin_char(p)) then
            font_stretch := font_stretch - width(p) - 
                char_pw(margin_char(p), subtype(p));
        font(margin_char(p)) := f;
        do_subst_font(margin_char(p), -1000);
        if f <> font(margin_char(p)) then
            font_shrink := font_shrink - width(p) -
                char_pw(margin_char(p), subtype(p));
        font(margin_char(p)) := f;
    end
    else if m = subst_ex_font then begin
            do_subst_font(margin_char(p), font_expand_ratio);
            width(p) := -char_pw(margin_char(p), subtype(p));
    end;
    x := x + width(p);
  end;
  kern_node: begin
    if (m = cal_expand_ratio) and (subtype(p) = normal) then begin
        k := kern_stretch(p);
        if k <> 0 then begin
            subtype(p) := substituted;
            font_stretch := font_stretch + k;
        end;
        k := kern_shrink(p);
        if k <> 0 then begin
            subtype(p) := substituted;
            font_shrink := font_shrink + k;
        end;
    end
    else if (m = subst_ex_font) and (subtype(p) = substituted) then begin
        if type(link(p)) = ligature_node then
            width(p) := get_kern(font(prev_char_p),
                                 character(prev_char_p),
                                 character(lig_char(link(p))))
        else 
            width(p) := get_kern(font(prev_char_p),
                                 character(prev_char_p),
                                 character(link(p)))
    end;
    x := x + width(p);
  end;
@z

@x [651] - HZ
  ligature_node: @<Make node |p| look like a |char_node|
    and |goto reswitch|@>;
@y
  ligature_node: begin
      if m = subst_ex_font then
          do_subst_font(p, font_expand_ratio);
      @<Make node |p| look like a |char_node| and |goto reswitch|@>;
  end;
  disc_node:
      if m = subst_ex_font then
          do_subst_font(p, font_expand_ratio);
@z

@x [654] - HZ
begin f:=font(p); i:=char_info(f)(character(p)); hd:=height_depth(i);
@y
begin
if m >= cal_expand_ratio then begin
    prev_char_p := p;
    case m of
    cal_expand_ratio: begin
        f := font(p);
        add_char_stretch(font_stretch)(character(p));
        add_char_shrink(font_shrink)(character(p));
    end;
    subst_ex_font:
        do_subst_font(p, font_expand_ratio);
    endcases;
end;
f:=font(p); i:=char_info(f)(character(p)); hd:=height_depth(i);
@z

@x [655] - pre vadjust
@<Transfer node |p| to the adjustment list@>=
begin while link(q)<>p do q:=link(q);
if type(p)=adjust_node then
  begin link(adjust_tail):=adjust_ptr(p);
  while link(adjust_tail)<>null do adjust_tail:=link(adjust_tail);
  p:=link(p); free_node(link(q),small_node_size);
  end
@y
@<Glob...@>=
@!pre_adjust_tail: pointer;

@ @<Set init...@>=
pre_adjust_tail := null;

@ Materials in \.{\\vadjust} used with \.{pre} keyword will be appended to
|pre_adjust_tail| instead of |adjust_tail|.

@d update_adjust_list(#) == begin
    link(#) := adjust_ptr(p);
    while link(#) <> null do 
        # := link(#);
end

@<Transfer node |p| to the adjustment list@>=
begin while link(q)<>p do q:=link(q);
    if type(p) = adjust_node then begin
        if adjust_pre(p) <> 0 then
            update_adjust_list(pre_adjust_tail)
        else
            update_adjust_list(adjust_tail);
        p := link(p); free_node(link(q), small_node_size);
    end
@z

@x [658] - HZ
@ @<Determine horizontal glue stretch setting...@>=
begin @<Determine the stretch order@>;
@y
@ If |hpack| is called with |m=cal_expand_ratio| we calculate
|font_expand_ratio| and return without checking for overfull or underfull box.

@<Determine horizontal glue stretch setting...@>=
begin @<Determine the stretch order@>;
if (m = cal_expand_ratio) and (o = normal) and (font_stretch > 0) then begin
    font_expand_ratio := divide_scaled(x, font_stretch, 3);
    return;
end;
@z

@x [664] - HZ
@ @<Determine horizontal glue shrink setting...@>=
begin @<Determine the shrink order@>;
@y
@ @<Determine horizontal glue shrink setting...@>=
begin @<Determine the shrink order@>;
if (m = cal_expand_ratio) and (o = normal) and (font_shrink > 0) then begin
    font_expand_ratio := divide_scaled(x, font_shrink, 3);
    return;
end;
@z

@x [770] - pre vadjust
@d align_stack_node_size=5 {number of |mem| words to save alignment states}
@y
@d align_stack_node_size=6 {number of |mem| words to save alignment states}
@z

@x [770] - pre vadjust
@!cur_head,@!cur_tail:pointer; {adjustment list pointers}
@y
@!cur_head,@!cur_tail:pointer; {adjustment list pointers}
@!cur_pre_head,@!cur_pre_tail:pointer; {pre-adjustment list pointers}
@z

@x [771] - pre vadjust
cur_head:=null; cur_tail:=null;
@y
cur_head:=null; cur_tail:=null;
cur_pre_head:=null; cur_pre_tail:=null;
@z

@x [772] - pre vadjust
info(p+4):=cur_head; link(p+4):=cur_tail;
@y
info(p+4):=cur_head; link(p+4):=cur_tail;
info(p+5):=cur_pre_head; link(p+5):=cur_pre_tail;
@z

@x [771] - pre vadjust
cur_tail:=link(p+4); cur_head:=info(p+4);
@y
cur_tail:=link(p+4); cur_head:=info(p+4);
cur_pre_tail:=link(p+5); cur_pre_head:=info(p+5);
@z

@x [786] - pre vadjust
cur_align:=link(preamble); cur_tail:=cur_head; init_span(cur_align);
@y
cur_align:=link(preamble); cur_tail:=cur_head; cur_pre_tail:=cur_pre_head;
init_span(cur_align);
@z

@x [791] - pre vadjust
  begin adjust_tail:=cur_tail; u:=hpack(link(head),natural); w:=width(u);
  cur_tail:=adjust_tail; adjust_tail:=null;
  end
@y
  begin adjust_tail:=cur_tail; pre_adjust_tail:=cur_pre_tail;
  u:=hpack(link(head),natural); w:=width(u);
  cur_tail:=adjust_tail; adjust_tail:=null;
  cur_pre_tail:=pre_adjust_tail; pre_adjust_tail:=null;
  end
@z

@x [799] - pre vadjust
  pop_nest; append_to_vlist(p);
  if cur_head<>cur_tail then
    begin link(tail):=link(cur_head); tail:=cur_tail;
    end;
@y
  pop_nest;
  if cur_pre_head <> cur_pre_tail then
      append_list(cur_pre_head)(cur_pre_tail);
  append_to_vlist(p);
  if cur_head <> cur_tail then
      append_list(cur_head)(cur_tail);
@z

@x [822] - HZ
@d delta_node_size=7 {number of words in a delta node}
@y
@d delta_node_size=9 {number of words in a delta node}
@z

@x [823] - HZ, protruding chars, avoiding overfull boxes
@<Glo...@>=
@!active_width:array[1..6] of scaled;
  {distance from first active node to~|cur_p|}
@!cur_active_width:array[1..6] of scaled; {distance from current active node}
@!background:array[1..6] of scaled; {length of an ``empty'' line}
@!break_width:array[1..6] of scaled; {length being computed after current break}
@y
@d do_seven_eight(#) == if pdf_adjust_spacing > 1 then begin #(7);#(8); end
@d do_all_eight(#) == do_all_six(#); do_seven_eight(#)
@d do_one_seven_eight(#) == #(1); do_seven_eight(#)

@d total_font_stretch == cur_active_width[7] 
@d total_font_shrink == cur_active_width[8] 

@d save_active_width(#) == prev_active_width[#] := active_width[#]
@d restore_active_width(#) == active_width[#] := prev_active_width[#]

@<Glo...@>=
@!active_width:array[1..8] of scaled;
  {distance from first active node to~|cur_p|}
@!cur_active_width:array[1..8] of scaled; {distance from current active node}
@!background:array[1..8] of scaled; {length of an ``empty'' line}
@!break_width:array[1..8] of scaled; {length being computed after current break}
@#
@!auto_breaking: boolean; {make |auto_breaking| accessible out of |line_break|}
@!prev_p: pointer; {make |prev_p| accessible out of |line_break|}
@!first_p: pointer; {to access the first node of the paragraph}
@!prev_char_p: pointer; {pointer to the previous char of an implicit kern}
@!next_char_p: pointer; {pointer to the next char of an implicit kern}
@# 
@!try_prev_break: boolean; {force break at the previous legal breakpoint?}
@!prev_legal: pointer; {the previous legal breakpoint}
@!prev_prev_legal: pointer; {to save |prev_p| corresponding to |prev_legal|}
@!prev_auto_breaking: boolean; {to save |auto_breaking| corresponding to |prev_legal|}
@!prev_active_width: array[1..8] of scaled; {to save |active_width| corresponding to |prev_legal|}
@!rejected_cur_p: pointer; {the last |cur_p| that has been rejected}
@!before_rejected_cur_p: boolean; {|cur_p| is still before |rejected_cur_p|?}
@#
@!max_stretch_ratio: integer; {maximal stretch ratio of expanded fonts}
@!max_shrink_ratio: integer; {maximal shrink ratio of expanded fonts}
@!cur_font_step: integer; {the current step of expanded fonts}
@z

@x [827] - HZ
background[6]:=shrink(q)+shrink(r);
@y
background[6]:=shrink(q)+shrink(r);
if pdf_adjust_spacing > 1 then begin
    background[7] := 0;
    background[8] := 0;
    max_stretch_ratio := -1;
    max_shrink_ratio := -1;
    cur_font_step := -1;
    prev_char_p := null;
end;
@z

@x [829] - protruding chars
@<Declare subprocedures for |line_break|@>=
procedure try_break(@!pi:integer;@!break_type:small_number);
@y
@d discardable(#) == not(
    is_char_node(#) or 
    non_discardable(#) or
    ((type(#) = kern_node) and (subtype(#) <> explicit)) or
    (type(#) = margin_kern_node)
)

@<Declare subprocedures for |line_break|@>=
function prev_rightmost(s, e: pointer): pointer;
var p: pointer;
begin
    prev_rightmost := null;
    p := s;
    if p = null then
        return;
    while link(p) <> e do begin
        p := link(p);
        if p = null then
            return;
    end;
    prev_rightmost := p;
end;

function total_pw(q, p: pointer): scaled;
label reswitch;
var l, r, s: pointer;
    n: integer;
begin
    if break_node(q) = null then
        l := first_p
    else
        l := cur_break(break_node(q));
    r := prev_rightmost(prev_p, p); { get |link(r)=p| }
    if r <> null then begin
        if (type(r) = disc_node) and 
           (type(p) = disc_node) and 
           (pre_break(p) = null) then  
        { I cannot remember when this case happens but I encountered it once }
        begin { find the predecessor of |r| }
            if r = prev_p then 
            { |link(prev_p)=p| and |prev_p| is also a |disc_node| }
            begin
                { start from the leftmost node }
                r  := prev_rightmost(l, p);
            end
            else
                r := prev_rightmost(prev_p, p);
        end
        else if (p <> null) and 
                (type(p) = disc_node) and 
                (pre_break(p) <> null) then 
        { a |disc_node| with non-empty |pre_break|, protrude the last char }
        begin
            r := pre_break(p);
            while link(r) <> null do
                r := link(r);
        end;
    end;
reswitch:
    while (l <> null) and discardable(l) do
        l := link(l);
    if (l <> null) and (type(l) = disc_node) then begin
    {|
        short_display_n(l, 2);
        print_ln;
        breadth_max := 10;
        depth_threshold := 2;
        show_node_list(l);
        print_ln;
    |}
        if post_break(l) <> null then
            l := post_break(l)
        else begin
            n := replace_count(l);
            l := link(l);
            while n > 0 do begin 
                if link(l) <> null then 
                    l := link(l);
                decr(n);
            end;
        end;
        goto reswitch;
    end;
    total_pw := left_pw(l) + right_pw(r);
end;

procedure try_break(@!pi:integer;@!break_type:small_number);
@z

@x [829] - avoiding overfull boxes
@!no_break_yet:boolean; {have we found a feasible break at |cur_p|?}
@y
@!no_break_yet:boolean; {have we found a feasible break at |cur_p|?}
@!can_try_prev_break: boolean; {can we try to break at the previous breakpoint?}
@!margin_kern_stretch: scaled;
@!margin_kern_shrink: scaled;
@!lp, rp, cp: pointer;
@z

@x [829] - HZ
do_all_six(copy_to_cur_active);
@y
do_all_eight(copy_to_cur_active);
@z

@x [829] - avoiding overfull boxes
exit: @!stat @<Update the value of |printed_node| for
  symbolic displays@>@+tats@;
end;
@y
exit: 
if can_try_prev_break then 
    try_prev_break := true
else begin
    do_nothing;
@!stat @<Update the value of |printed_node| for symbolic displays@> @+tats@;
    do_nothing;
    if try_prev_break then begin
        prev_legal := null;
        try_prev_break := false;
    end
    else begin
        if pi < inf_penalty then begin
            prev_legal := cur_p;
            prev_prev_legal := prev_p;
            prev_auto_breaking := auto_breaking;
            do_all_eight(save_active_width);
        end;
        if before_rejected_cur_p and (cur_p = rejected_cur_p) then
            before_rejected_cur_p := false;
    end;
end;
end;
@z

@x [831] - avoiding overfull boxes
if abs(pi)>=inf_penalty then
@y
if try_prev_break and (pi <= inf_penalty) then
    pi := eject_penalty;
can_try_prev_break := false;
if abs(pi)>=inf_penalty then
@z

@x [832] - HZ
  begin do_all_six(update_width);
@y
  begin do_all_eight(update_width);
@z

@x [837] - HZ
begin no_break_yet:=false; do_all_six(set_break_width_to_background);
@y
begin no_break_yet:=false; do_all_eight(set_break_width_to_background);
@z

@x [839] - HZ
@<Glob...@>=
@!disc_width:scaled; {the length of discretionary material preceding a break}
@y
@d reset_disc_width(#) == disc_width[#] := 0

@d add_disc_width_to_break_width(#) ==  
    break_width[#] := break_width[#] + disc_width[#]

@d add_disc_width_to_active_width(#) ==  
    active_width[#] := active_width[#] + disc_width[#]

@d sub_disc_width_from_active_width(#) ==  
    active_width[#] := active_width[#] - disc_width[#]

@d add_char_stretch_end(#) == char_stretch(f, #)
@d add_char_stretch(#) == # := # + add_char_stretch_end

@d add_char_shrink_end(#) == char_shrink(f, #)
@d add_char_shrink(#) == # := # + add_char_shrink_end

@d sub_char_stretch_end(#) == char_stretch(f, #)
@d sub_char_stretch(#) == # := # - sub_char_stretch_end

@d sub_char_shrink_end(#) == char_shrink(f, #)
@d sub_char_shrink(#) == # := # - sub_char_shrink_end

@d add_kern_stretch_end(#) == kern_stretch(#)
@d add_kern_stretch(#) == # := # + add_kern_stretch_end

@d add_kern_shrink_end(#) == kern_shrink(#)
@d add_kern_shrink(#) == # := # + add_kern_shrink_end

@d sub_kern_stretch_end(#) == kern_stretch(#)
@d sub_kern_stretch(#) == # := # - sub_kern_stretch_end

@d sub_kern_shrink_end(#) == kern_shrink(#)
@d sub_kern_shrink(#) == # := # - sub_kern_shrink_end

@<Glob...@>=
@!disc_width: array[1..8] of scaled; {the length of discretionary material preceding a break}
@z

@x [840] - HZ
break_width[1]:=break_width[1]+disc_width;
@y
do_one_seven_eight(add_disc_width_to_break_width);
@z

@x [841] - HZ
  break_width[1]:=break_width[1]-char_width(f)(char_info(f)(character(v)));
@y
  break_width[1]:=break_width[1]-char_width(f)(char_info(f)(character(v)));
  if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
      prev_char_p := v;
      sub_char_stretch(break_width[7])(character(v));
      sub_char_shrink(break_width[8])(character(v));
  end;
@z

@x [841] - HZ
    break_width[1]:=@|break_width[1]-
      char_width(f)(char_info(f)(character(lig_char(v))));
@y
    break_width[1]:=@|break_width[1]-
      char_width(f)(char_info(f)(character(lig_char(v))));
    if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
        prev_char_p := v;
        sub_char_stretch(break_width[7])(character(lig_char(v)));
        sub_char_shrink(break_width[8])(character(lig_char(v)));
    end;
@z

@x [841] - HZ
  hlist_node,vlist_node,rule_node,kern_node:
    break_width[1]:=break_width[1]-width(v);
@y
  hlist_node,vlist_node,rule_node,kern_node: begin
    break_width[1]:=break_width[1]-width(v);
    if (type(v) = kern_node) and
       (pdf_adjust_spacing > 1) and (subtype(v) = normal)
    then begin
        sub_kern_stretch(break_width[7])(v);
        sub_kern_shrink(break_width[8])(v);
    end;
  end;
@z

@x [842] - HZ
  break_width[1]:=@|break_width[1]+char_width(f)(char_info(f)(character(s)));
@y
  break_width[1]:=@|break_width[1]+char_width(f)(char_info(f)(character(s)));
  if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
      prev_char_p := s;
      add_char_stretch(break_width[7])(character(s));
      add_char_shrink(break_width[8])(character(s));
  end;
@z

@x [842] - HZ
    break_width[1]:=break_width[1]+
      char_width(f)(char_info(f)(character(lig_char(s))));
@y
    break_width[1]:=break_width[1]+
      char_width(f)(char_info(f)(character(lig_char(s))));
    if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
        prev_char_p := s;
        add_char_stretch(break_width[7])(character(lig_char(s)));
        add_char_shrink(break_width[8])(character(lig_char(s)));
    end;
@z

@x [842] - HZ
  hlist_node,vlist_node,rule_node,kern_node:
    break_width[1]:=break_width[1]+width(s);
@y
  hlist_node,vlist_node,rule_node,kern_node: begin
    break_width[1]:=break_width[1]+width(s);
    if (type(s) = kern_node) and
       (pdf_adjust_spacing > 1) and (subtype(s) = normal)
    then begin
        add_kern_stretch(break_width[7])(s);
        add_kern_shrink(break_width[8])(s);
    end;
  end;
@z

@x [843] - HZ
  begin do_all_six(convert_to_break_width);
@y
  begin do_all_eight(convert_to_break_width);
@z

@x [843] - HZ
  begin do_all_six(store_break_width);
@y
  begin do_all_eight(store_break_width);
@z

@x [843] - HZ
  do_all_six(new_delta_to_break_width);
@y
  do_all_eight(new_delta_to_break_width);
@z

@x [844] - HZ
  do_all_six(new_delta_from_break_width);
@y
  do_all_eight(new_delta_from_break_width);
@z

@x [851] - HZ, protruding chars
shortfall:=line_width-cur_active_width[1]; {we're this much too short}
@y
shortfall:=line_width-cur_active_width[1]; {we're this much too short}

{|
if pdf_output > 2 then begin
print_ln;
if (r <> null) and (break_node(r) <> null) then
    short_display_n(cur_break(break_node(r)), 5);
print_ln;
short_display_n(cur_p, 5);
print_ln;
end;
|}

if pdf_protrude_chars > 1 then
    shortfall := shortfall + total_pw(r, cur_p);
if (pdf_adjust_spacing > 1) and (shortfall <> 0) then begin
    margin_kern_stretch := 0;
    margin_kern_shrink := 0;
    if pdf_protrude_chars > 1 then 
        @<Calculate variations of marginal kerns@>;
    if (shortfall > 0) and ((total_font_stretch + margin_kern_stretch) > 0) 
    then begin
        if (total_font_stretch + margin_kern_stretch) > shortfall then
            shortfall := ((total_font_stretch + margin_kern_stretch) div 
                          (max_stretch_ratio div cur_font_step)) div 2
        else
            shortfall := shortfall - (total_font_stretch + margin_kern_stretch);
    end
    else if (shortfall < 0) and ((total_font_shrink + margin_kern_shrink) > 0) 
    then begin
        if (total_font_shrink + margin_kern_shrink) > -shortfall then
            shortfall := -((total_font_shrink + margin_kern_shrink) div 
                           (max_shrink_ratio div cur_font_step)) div 2
        else
            shortfall := shortfall + (total_font_shrink + margin_kern_shrink);
    end;
end;
@z

@x [854] - HZ, avoiding overfull boxes
   (prev_r=active) then
  artificial_demerits:=true {set demerits zero, this break is forced}
@y
   (prev_r=active) then begin
        if (pdf_avoid_overfull > 0) and (b > inf_bad) and
           (prev_legal <> null) and (prev_legal <> cur_p) 
        then begin
            if try_prev_break then
                confusion("overfull box recovery");
            rejected_cur_p := cur_p;
            can_try_prev_break := true;
            return;
        end;
        artificial_demerits:=true {set demerits zero, this break is forced}
   end
@z

@x [860] - HZ
    begin do_all_six(downdate_width);
@y
    begin do_all_eight(downdate_width);
@z

@x [860] - HZ
    begin do_all_six(update_width);
    do_all_six(combine_two_deltas);
@y
    begin do_all_eight(update_width);
    do_all_eight(combine_two_deltas);
@z

@x [861] - HZ
  begin do_all_six(update_active);
  do_all_six(copy_to_cur_active);
@y
  begin do_all_eight(update_active);
  do_all_eight(copy_to_cur_active);
@z

@x [862] - protruding chars, avoiding overfull boxes
@!auto_breaking:boolean; {is node |cur_p| outside a formula?}
@!prev_p:pointer; {helps to determine when glue nodes are breakpoints}
@y
@z

@x [863] - avoiding overfull boxes
  final_pass:=(emergency_stretch<=0);
@y
  final_pass:=((emergency_stretch <= 0) and (pdf_avoid_overfull <= 0));
@z

@x [863] - protruding chars, avoiding overfull boxes
  while (cur_p<>null)and(link(active)<>last_active) do
@y
  prev_char_p := null;
  prev_legal := null;
  rejected_cur_p := null;
  try_prev_break := false;
  before_rejected_cur_p := false;
  first_p := cur_p; {to access the first node of paragraph as the first active
                     node has |break_node=null|}
  while (cur_p<>null)and(link(active)<>last_active) do
@z

@x [863] - avoiding overfull boxes
    threshold:=tolerance; second_pass:=true; final_pass:=(emergency_stretch<=0);
@y
    threshold:=tolerance; second_pass:=true;
    final_pass:=((emergency_stretch <= 0) and (pdf_avoid_overfull <= 0));
@z

@x [863] - avoiding overfull boxes
    background[2]:=background[2]+emergency_stretch; final_pass:=true;
@y
    if pdf_avoid_overfull <= 0 then
        background[2]:=background[2]+emergency_stretch;
    final_pass := true;
@z

@x [864] - HZ
do_all_six(store_background);@/
@y
do_all_eight(store_background);@/
@z

@x [866] - avoiding overfull boxes
  if second_pass and auto_breaking then
    @<Try to hyphenate the following word@>;
@y
  if second_pass and auto_breaking and
     not (before_rejected_cur_p or (cur_p = rejected_cur_p)) then
    @<Try to hyphenate the following word@>;
@z

@x [666] - HZ
  else act_width:=act_width+width(cur_p);
@y
  else begin
    act_width:=act_width+width(cur_p);
    if (pdf_adjust_spacing > 1) and (subtype(cur_p) = normal) then begin
        add_kern_stretch(active_width[7])(cur_p);
        add_kern_shrink(active_width[8])(cur_p);
    end;
  end;
@z

@x [866] - HZ
  act_width:=act_width+char_width(f)(char_info(f)(character(lig_char(cur_p))));
@y
  act_width:=act_width+char_width(f)(char_info(f)(character(lig_char(cur_p))));
  if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
      prev_char_p := cur_p;
      add_char_stretch(active_width[7])(character(lig_char(cur_p)));
      add_char_shrink(active_width[8])(character(lig_char(cur_p)));
  end;
@z

@x [866] - avoiding overfull boxes
done5:end
@y
done5:
if try_prev_break then begin
    if pdf_avoid_overfull > 1 then begin
        print_ln;
        print_nl("Overfull \hbox detected at breakpoint:");
        print_ln;
        short_display_n(prev_p, 10);
        print_ln;
        print_nl("Trying to break at the previous legal breakpoint:");
        print_ln;
        short_display_n(prev_legal, 10);
        print_ln;
    end;
    cur_p := prev_legal;
    prev_p := prev_prev_legal;
    auto_breaking := prev_auto_breaking;
    do_all_eight(restore_active_width);
    prev_legal := null;
    before_rejected_cur_p := true;
end;
end
@z

@x [867] - HZ
act_width:=act_width+char_width(f)(char_info(f)(character(cur_p)));
@y
act_width:=act_width+char_width(f)(char_info(f)(character(cur_p)));
if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
    prev_char_p := cur_p;
    add_char_stretch(active_width[7])(character(cur_p));
    add_char_shrink(active_width[8])(character(cur_p));
end;
@z

@x [869] - HZ
begin s:=pre_break(cur_p); disc_width:=0;
@y
begin s:=pre_break(cur_p);
do_one_seven_eight(reset_disc_width);
@z

@x [869] - HZ
  act_width:=act_width+disc_width;
  try_break(hyphen_penalty,hyphenated);
  act_width:=act_width-disc_width;
@y
  do_one_seven_eight(add_disc_width_to_active_width);
  try_break(hyphen_penalty,hyphenated);
  do_one_seven_eight(sub_disc_width_from_active_width);
@z

@x [870] - HZ
  disc_width:=disc_width+char_width(f)(char_info(f)(character(s)));
@y
  disc_width[1]:=disc_width[1]+char_width(f)(char_info(f)(character(s)));
  if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
      prev_char_p := s;
      add_char_stretch(disc_width[7])(character(s));
      add_char_shrink(disc_width[8])(character(s));
  end;
@z

@x [870] - HZ
    disc_width:=disc_width+
      char_width(f)(char_info(f)(character(lig_char(s))));
@y
    disc_width[1]:=disc_width[1]+
      char_width(f)(char_info(f)(character(lig_char(s))));
    if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
        prev_char_p := s;
        add_char_stretch(disc_width[7])(character(lig_char(s)));
        add_char_shrink(disc_width[8])(character(lig_char(s)));
    end;
@z

@x [870] - HZ
  hlist_node,vlist_node,rule_node,kern_node:
    disc_width:=disc_width+width(s);
@y
  hlist_node,vlist_node,rule_node,kern_node: begin
    disc_width[1]:=disc_width[1]+width(s);
    if (type(s) = kern_node) and
       (pdf_adjust_spacing > 1) and (subtype(s) = normal)
    then begin
        add_kern_stretch(disc_width[7])(s);
        add_kern_shrink(disc_width[8])(s);
    end;
  end;
@z

@x [871] - HZ
  act_width:=act_width+char_width(f)(char_info(f)(character(s)));
@y
  act_width:=act_width+char_width(f)(char_info(f)(character(s)));
  if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
      prev_char_p := s;
      add_char_stretch(active_width[7])(character(s));
      add_char_shrink(active_width[8])(character(s));
  end;
@z

@x [871] - HZ
    act_width:=act_width+
      char_width(f)(char_info(f)(character(lig_char(s))));
@y
    act_width:=act_width+
      char_width(f)(char_info(f)(character(lig_char(s))));
    if (pdf_adjust_spacing > 1) and check_expand_pars(f) then begin
        prev_char_p := s;
        add_char_stretch(active_width[7])(character(lig_char(s)));
        add_char_shrink(active_width[8])(character(lig_char(s)));
    end;
@z

@x [671] - HZ
  hlist_node,vlist_node,rule_node,kern_node:
    act_width:=act_width+width(s);
@y
  hlist_node,vlist_node,rule_node,kern_node: begin
    act_width:=act_width+width(s);
    if (type(s) = kern_node) and
       (pdf_adjust_spacing > 1) and (subtype(s) = normal)
    then begin
        add_kern_stretch(active_width[7])(s);
        add_kern_shrink(active_width[8])(s);
    end;
  end;
@z

@x [873] - avoiding overfull boxes
begin try_break(eject_penalty,hyphenated);
@y
begin try_break(eject_penalty,hyphenated);
if try_prev_break then
    goto done5;
@z

@x [877] - protruding chars
var q,@!r,@!s:pointer; {temporary registers for list manipulation}
@y
var q,@!r,@!s:pointer; {temporary registers for list manipulation}
    p, k: pointer; 
    w: scaled;
@z

@x [881] - protruding chars
@<Put the \(r)\.{\\rightskip} glue after node |q|@>;
done:
@y
@<Put the \(r)\.{\\rightskip} glue after node |q|@>;
done:
if pdf_protrude_chars > 0 then begin
    p := prev_rightmost(temp_head, q);
    if (p <> null) and 
       ((type(p) = disc_node) or (type(p) = penalty_node))
    then
        p := prev_rightmost(temp_head, p);
    w := right_pw(p);
    if p <> null then begin
        while link(p) <> q do
            p := link(p);
        if w <> 0 then begin
            k := new_margin_kern(-w, last_rightmost_char, right_side);
            link(p) := k;
            link(k) := q;
        end;
    end;
end;
@z

@x [887] - protruding chars
if left_skip<>zero_glue then
@y
if pdf_protrude_chars > 0 then begin
    p := q;
    while (p <> null) and discardable(p) do
        p := link(p);
    w := left_pw(p);
    if w <> 0 then begin
        k := new_margin_kern(-w, last_leftmost_char, left_side);
        link(k) := q;
        q := k;
    end;
end;
if left_skip<>zero_glue then
@z

@x [888] - pre vadjust,  line snapping
@ @<Append the new box to the current vertical list...@>=
append_to_vlist(just_box);
if adjust_head<>adjust_tail then
  begin link(tail):=link(adjust_head); tail:=adjust_tail;
   end;
adjust_tail:=null
@y
@ |append_list| is used to append a list to |tail|.

@d append_list_end(#) == tail := #; end
@d append_list(#) == begin link(tail) := link(#); append_list_end

@<Append the new box to the current vertical list...@>=
if pre_adjust_head <> pre_adjust_tail then
    append_list(pre_adjust_head)(pre_adjust_tail);
pre_adjust_tail := null;
prepend_line_snap_nodes;
append_to_vlist(just_box);
if adjust_head <> adjust_tail then
    append_list(adjust_head)(adjust_tail);
adjust_tail := null
@z

@x [889] - HZ, pre vadjust
adjust_tail:=adjust_head; just_box:=hpack(q,cur_width,exactly);
@y
adjust_tail := adjust_head;
pre_adjust_tail := pre_adjust_head;
if pdf_adjust_spacing > 0 then
    just_box := hpack(q, cur_width, cal_expand_ratio)
else
    just_box := hpack(q, cur_width, exactly);
@z

@x [970] - avoiding overfull boxes
done: vert_break:=best_place;
end;
@y
done: vert_break:=best_place;
if best_place = null then
    last_vbreak_penalty := eject_penalty
else if type(best_place) = penalty_node then
    last_vbreak_penalty := penalty(best_place)
else
    last_vbreak_penalty := 0;
end;

@ @<Glob...@>=
@!last_vbreak_penalty: integer;
@z

@x [1076] - pre vadjust
    begin append_to_vlist(cur_box);
    if adjust_tail<>null then
      begin if adjust_head<>adjust_tail then
        begin link(tail):=link(adjust_head); tail:=adjust_tail;
        end;
      adjust_tail:=null;
      end;
@y
    begin 
        if pre_adjust_tail <> null then begin
            if pre_adjust_head <> pre_adjust_tail then
                append_list(pre_adjust_head)(pre_adjust_tail);
            pre_adjust_tail := null;
        end;
        append_to_vlist(cur_box);
        if adjust_tail <> null then begin
            if adjust_head <> adjust_tail then
                append_list(adjust_head)(adjust_tail);
            adjust_tail := null;
        end;
@z

@x [1085] - pre vadjust
adjusted_hbox_group: begin adjust_tail:=adjust_head; package(0);
@y
adjusted_hbox_group: begin adjust_tail:=adjust_head; 
    pre_adjust_tail:=pre_adjust_head; package(0);
@z

@x [1099] - pre vadjust
saved(0):=cur_val; incr(save_ptr);
new_save_level(insert_group); scan_left_brace; normal_paragraph;
push_nest; mode:=-vmode; prev_depth:=ignore_depth;
end;
@y
saved(0) := cur_val;
if (cur_cmd = vadjust) and scan_keyword("pre") then
    saved(1) := 1
else
    saved(1) := 0;
save_ptr := save_ptr + 2;
new_save_level(insert_group); scan_left_brace; normal_paragraph;
push_nest; mode:=-vmode; prev_depth:=ignore_depth;
end;
@z

@x [1100] - pre vadjust
  d:=split_max_depth; f:=floating_penalty; unsave; decr(save_ptr);
@y
  d:=split_max_depth; f:=floating_penalty; unsave; save_ptr := save_ptr - 2;
@z

@x [1100] - pre vadjust
    subtype(tail):=0; {the |subtype| is not used}
@y
    adjust_pre(tail) := saved(1); {the |subtype| is used for |adjust_pre|}
@z

@x [1100] - margin kerning
var p:pointer; {the box}
@y
var p:pointer; {the box}
    r: pointer; {to remove marging kern nodes}
@z

@x [1100] - margin kerning
while link(tail)<>null do tail:=link(tail);
@y
if c = copy_code then begin
    while link(tail)<>null do tail:=link(tail);
end
else while link(tail) <> null do begin
    r := link(tail);
    if not is_char_node(r) and (type(r) = margin_kern_node) then begin
        link(tail) := link(r);
        free_avail(margin_char(r));
        free_node(r, margin_kern_node_size);
    end;
    tail:=link(tail);
end;
@z

@x [1147] - margin kerning
kern_node,math_node: d:=width(p);
@y
kern_node,math_node: d:=width(p);
margin_kern_node: d:=width(p);
@z

@x [1198] - pre vadjust
@!t:pointer; {tail of adjustment list}
@y
@!t:pointer; {tail of adjustment list}
@!pre_t:pointer; {tail of pre-adjustment list}
@z

@x [1199] - pre vadjust
adjust_tail:=adjust_head; b:=hpack(p,natural); p:=list_ptr(b);
t:=adjust_tail; adjust_tail:=null;@/
@y
adjust_tail:=adjust_head; pre_adjust_tail:=pre_adjust_head;
b:=hpack(p,natural); p:=list_ptr(b);
t:=adjust_tail; adjust_tail:=null;@/
pre_t:=pre_adjust_tail; pre_adjust_tail:=null;@/
@z

@x [1205] - pre vadjust
if t<>adjust_head then {migrating material comes after equation number}
  begin link(tail):=link(adjust_head); tail:=t;
  end;
@y
if t<>adjust_head then {migrating material comes after equation number}
  begin link(tail):=link(adjust_head); tail:=t;
  end;
if pre_t<>pre_adjust_head then
  begin link(tail):=link(pre_adjust_head); tail:=pre_t;
  end;
@z

@x [1253] - HZ
assign_font_int: begin n:=cur_chr; scan_font_ident; f:=cur_val;
  scan_optional_equals; scan_int;
  if n=0 then hyphen_char[f]:=cur_val@+else skew_char[f]:=cur_val;
  end;
@y
assign_font_int: begin n:=cur_chr; scan_font_ident; f:=cur_val;
  if n < lp_code_base then begin
    scan_optional_equals; scan_int;
    if n=0 then hyphen_char[f]:=cur_val@+else skew_char[f]:=cur_val;
  end
  else begin
    scan_char_num; p := cur_val;
    scan_optional_equals; scan_int;
    case n of 
    lp_code_base: set_lp_code(f, p, cur_val);
    rp_code_base: set_rp_code(f, p, cur_val);
    ef_code_base: set_ef_code(f, p, cur_val);
    end;
  end;
end;
@z

@x [1254] - HZ
@ @<Put each...@>=
primitive("hyphenchar",assign_font_int,0);
@!@:hyphen_char_}{\.{\\hyphenchar} primitive@>
primitive("skewchar",assign_font_int,1);
@!@:skew_char_}{\.{\\skewchar} primitive@>
@y
@ 
@d lp_code_base == 2
@d rp_code_base == 3
@d ef_code_base == 4

@<Put each...@>=
primitive("hyphenchar",assign_font_int,0);
@!@:hyphen_char_}{\.{\\hyphenchar} primitive@>
primitive("skewchar",assign_font_int,1);
@!@:skew_char_}{\.{\\skewchar} primitive@>
primitive("lpcode",assign_font_int,lp_code_base);
@!@:lp_code_}{\.{\\lpcode} primitive@>
primitive("rpcode",assign_font_int,rp_code_base);
@!@:rp_code_}{\.{\\rpcode} primitive@>
primitive("efcode",assign_font_int,ef_code_base);
@!@:ef_code_}{\.{\\efcode} primitive@>
@z

@x [1255] - HZ
assign_font_int: if chr_code=0 then print_esc("hyphenchar")
  else print_esc("skewchar");
@y
assign_font_int: case chr_code of
0: print_esc("hyphenchar");
1: print_esc("skewchar");
lp_code_base: print_esc("lpcode");
rp_code_base: print_esc("rpcode");
ef_code_base: print_esc("efcode");
endcases;
@z


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Print new line before termination; switch to editor if
% necessary.
% Declare the necessary variables for finishing PDF file
% Close PDF output if necessary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x [1333]
procedure close_files_and_terminate;
var k:integer; {all-purpose index}
begin @<Finish the extensions@>;
@!stat if tracing_stats>0 then @<Output statistics about this job@>;@;@+tats@/
wake_up_terminal; @<Finish the \.{DVI} file@>;
@y
procedure close_files_and_terminate;
label done, done1;
var a, b, c, i, j, k, l: integer; {all-purpose index}
    is_root: boolean; {|pdf_last_pages| is root of Pages tree?}
    root, outlines, threads, names_tree, dests, fixed_dest: integer;
begin @<Finish the extensions@>;
@!stat if tracing_stats>0 then @<Output statistics about this job@>;@;@+tats@/
wake_up_terminal;
if fixed_output > 0 then begin
    if history = fatal_error_stop then
        print_err(" ==> Fatal error occurred, the output PDF file is not finished!")
    else begin
        @<Finish the PDF file@>;
    end;
end
else begin
    @<Finish the \.{DVI} file@>;
end;
@z


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Output statistics about the pdftex specific sizes.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x [1334]
  wlog_ln(' ',max_in_stack:1,'i,',max_nest_stack:1,'n,',@|
    max_param_stack:1,'p,',@|
    max_buf_stack+1:1,'b,',@|
    max_save_stack+6:1,'s stack positions out of ',@|
    stack_size:1,'i,',
    nest_size:1,'n,',
    param_size:1,'p,',
    buf_size:1,'b,',
    save_size:1,'s');
  end
@y
  wlog_ln(' ',max_in_stack:1,'i,',max_nest_stack:1,'n,',@|
    max_param_stack:1,'p,',@|
    max_buf_stack+1:1,'b,',@|
    max_save_stack+6:1,'s stack positions out of ',@|
    stack_size:1,'i,',
    nest_size:1,'n,',
    param_size:1,'p,',
    buf_size:1,'b,',
    save_size:1,'s');
  wlog_ln(' ',obj_ptr:1,' PDF objects out of ',obj_tab_size:1);
  wlog_ln(' ',pdf_dest_names_ptr:1,' named destinations out of ',dest_names_size:1);
  wlog_ln(' ',pdf_mem_ptr:1,' words of extra memory for PDF output out of ',pdf_mem_size:1);
  end
@z

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read config file before input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x [1337]
@<Initialize the print |selector|...@>;
if (loc<limit)and(cat_code(buffer[loc])<>escape) then start_input;
  {\.{\\input} assumed}
@y
@<Initialize the print |selector|...@>;
if (loc<limit)and(cat_code(buffer[loc])<>escape) then start_input;
  {\.{\\input} assumed}
@<Read values from config file if necessary@>;
@z


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PDF-speficic extensions that don't fall to any previous category
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
@x [1344]
@d immediate_code=4 {command modifier for \.{\\immediate}}
@d set_language_code=5 {command modifier for \.{\\setlanguage}}
@y
@d immediate_code=4 {command modifier for \.{\\immediate}}
@d set_language_code=5 {command modifier for \.{\\setlanguage}}
@d pdf_literal_node              == 6
@d pdf_obj_code                  == 7
@d pdf_refobj_node               == 8
@d pdf_xform_code                == 9
@d pdf_refxform_node             == 10
@d pdf_ximage_code               == 11
@d pdf_refximage_node            == 12
@d pdf_annot_node                == 13
@d pdf_start_link_node           == 14
@d pdf_end_link_node             == 15
@d pdf_outline_code              == 16
@d pdf_dest_node                 == 17
@d pdf_thread_node               == 18
@d pdf_start_thread_node         == 19
@d pdf_end_thread_node           == 20
@d pdf_save_pos_node             == 21
@d pdf_snap_ref_point_node       == 22
@d pdf_snap_x_node               == 23
@d pdf_snap_y_node               == 24
@d pdf_line_snap_x_code          == 25
@d pdf_line_snap_y_code          == 26
@d pdf_info_code                 == 27
@d pdf_catalog_code              == 28
@d pdf_names_code                == 29
@d pdf_font_attr_code            == 30
@d pdf_include_chars_code        == 31
@d pdf_font_expand_code          == 32
@d pdf_map_file_code             == 33
@d pdf_trailer_code              == 34
@z

@x [1344]
primitive("setlanguage",extension,set_language_code);@/
@!@:set_language_}{\.{\\setlanguage} primitive@>
@y
primitive("setlanguage",extension,set_language_code);@/
@!@:set_language_}{\.{\\setlanguage} primitive@>
primitive("pdfliteral",extension,pdf_literal_node);@/
@!@:pdf_literal_}{\.{\\pdfliteral} primitive@>
primitive("pdfobj",extension,pdf_obj_code);@/
@!@:pdf_obj_}{\.{\\pdfobj} primitive@>
primitive("pdfrefobj",extension,pdf_refobj_node);@/
@!@:pdf_refobj_}{\.{\\pdfrefobj} primitive@>
primitive("pdfxform",extension,pdf_xform_code);@/
@!@:pdf_xform_}{\.{\\pdfxform} primitive@>
primitive("pdfrefxform",extension,pdf_refxform_node);@/
@!@:pdf_refxform_}{\.{\\pdfrefxform} primitive@>
primitive("pdfximage",extension,pdf_ximage_code);@/
@!@:pdf_ximage_}{\.{\\pdfximage} primitive@>
primitive("pdfrefximage",extension,pdf_refximage_node);@/
@!@:pdf_refximage_}{\.{\\pdfrefximage} primitive@>
primitive("pdfannot",extension,pdf_annot_node);@/
@!@:pdf_annot_}{\.{\\pdfannot} primitive@>
primitive("pdfstartlink",extension,pdf_start_link_node);@/
@!@:pdf_start_link_}{\.{\\pdfstartlink} primitive@>
primitive("pdfendlink",extension,pdf_end_link_node);@/
@!@:pdf_end_link_}{\.{\\pdfendlink} primitive@>
primitive("pdfoutline",extension,pdf_outline_code);@/
@!@:pdf_outline_}{\.{\\pdfoutline} primitive@>
primitive("pdfdest",extension,pdf_dest_node);@/
@!@:pdf_dest_}{\.{\\pdfdest} primitive@>
primitive("pdfthread",extension,pdf_thread_node);@/
@!@:pdf_thread_}{\.{\\pdfthread} primitive@>
primitive("pdfstartthread",extension,pdf_start_thread_node);@/
@!@:pdf_start_thread_}{\.{\\pdfstartthread} primitive@>
primitive("pdfendthread",extension,pdf_end_thread_node);@/
@!@:pdf_end_thread_}{\.{\\pdfendthread} primitive@>
primitive("pdfsavepos",extension,pdf_save_pos_node);@/
@!@:pdf_save_pos_}{\.{\\pdfsavepos} primitive@>
primitive("pdfsnaprefpoint",extension,pdf_snap_ref_point_node);@/
@!@:pdf_snap_ref_point_}{\.{\\pdfsnaprefpoint} primitive@>
primitive("pdfsnapx",extension,pdf_snap_x_node);@/
@!@:pdf_snap_x_}{\.{\\pdfsnapx} primitive@>
primitive("pdfsnapy",extension,pdf_snap_y_node);@/
@!@:pdf_snap_y_}{\.{\\pdfsnapy} primitive@>
primitive("pdflinesnapx",extension,pdf_line_snap_x_code);@/
@!@:pdf_line_snap_x_}{\.{\\pdflinesnapx} primitive@>
primitive("pdflinesnapy",extension,pdf_line_snap_y_code);@/
@!@:pdf_line_snap_y_}{\.{\\pdflinesnapy} primitive@>
primitive("pdfinfo",extension,pdf_info_code);@/
@!@:pdf_info_}{\.{\\pdfinfo} primitive@>
primitive("pdfcatalog",extension,pdf_catalog_code);@/
@!@:pdf_catalog_}{\.{\\pdfcatalog} primitive@>
primitive("pdfnames",extension,pdf_names_code);@/
@!@:pdf_names_}{\.{\\pdfnames} primitive@>
primitive("pdfincludechars",extension,pdf_include_chars_code);@/
@!@:pdf_include_chars_}{\.{\\pdfincludechars} primitive@>
primitive("pdffontattr",extension,pdf_font_attr_code);@/
@!@:pdf_font_attr_}{\.{\\pdffontattr} primitive@>
primitive("pdffontexpand",extension,pdf_font_expand_code);@/
@!@:pdf_font_expand_}{\.{\\pdffontexpand} primitive@>
primitive("pdfmapfile",extension,pdf_map_file_code);@/
@!@:pdf_map_file_}{\.{\\pdfmapfile} primitive@>
primitive("pdftrailer",extension,pdf_trailer_code);@/
@!@:pdf_trailer_}{\.{\\pdftrailer} primitive@>
@z

@x [1346]
  set_language_code:print_esc("setlanguage");
  othercases print("[unknown extension!]")
@y
  set_language_code: print_esc("setlanguage");
  pdf_literal_node: print_esc("pdfliteral");
  pdf_obj_code: print_esc("pdfobj");
  pdf_refobj_node: print_esc("pdfrefobj");
  pdf_xform_code: print_esc("pdfxform");
  pdf_refxform_node: print_esc("pdfrefxform");
  pdf_ximage_code: print_esc("pdfximage");
  pdf_refximage_node: print_esc("pdfrefximage");
  pdf_annot_node: print_esc("pdfannot");
  pdf_start_link_node: print_esc("pdfstartlink");
  pdf_end_link_node: print_esc("pdfendlink");
  pdf_outline_code: print_esc("pdfoutline");
  pdf_dest_node: print_esc("pdfdest");
  pdf_thread_node: print_esc("pdfthread");
  pdf_start_thread_node: print_esc("pdfstartthread");
  pdf_end_thread_node: print_esc("pdfendthread");
  pdf_save_pos_node: print_esc("pdfsavepos");
  pdf_snap_ref_point_node: print_esc("pdfsnaprefpoint");
  pdf_snap_x_node: print_esc("pdfsnapx");
  pdf_snap_y_node: print_esc("pdfsnapy");
  pdf_line_snap_x_code: print_esc("pdflinesnapx");
  pdf_line_snap_y_code: print_esc("pdflinesnapy");
  pdf_info_code: print_esc("pdfinfo");
  pdf_catalog_code: print_esc("pdfcatalog");
  pdf_names_code: print_esc("pdfnames");
  pdf_include_chars_code: print_esc("pdfincludechars");
  pdf_font_attr_code: print_esc("pdffontattr");
  pdf_font_expand_code: print_esc("pdffontexpand");
  pdf_map_file_code: print_esc("pdfmapfile");
  pdf_trailer_code: print_esc("pdftrailer");
  othercases print("[unknown extension!]")
@z

@x [1348]
set_language_code:@<Implement \.{\\setlanguage}@>;
othercases confusion("ext1")
@y
set_language_code: @<Implement \.{\\setlanguage}@>;
pdf_literal_node: @<Implement \.{\\pdfliteral}@>;
pdf_obj_code: @<Implement \.{\\pdfobj}@>;
pdf_refobj_node: @<Implement \.{\\pdfrefobj}@>;
pdf_xform_code: @<Implement \.{\\pdfxform}@>;
pdf_refxform_node: @<Implement \.{\\pdfrefxform}@>;
pdf_ximage_code: @<Implement \.{\\pdfximage}@>;
pdf_refximage_node: @<Implement \.{\\pdfrefximage}@>;
pdf_annot_node: @<Implement \.{\\pdfannot}@>;
pdf_start_link_node: @<Implement \.{\\pdfstartlink}@>;
pdf_end_link_node: @<Implement \.{\\pdfendlink}@>;
pdf_outline_code: @<Implement \.{\\pdfoutline}@>;
pdf_dest_node: @<Implement \.{\\pdfdest}@>;
pdf_thread_node: @<Implement \.{\\pdfthread}@>;
pdf_start_thread_node: @<Implement \.{\\pdfstartthread}@>;
pdf_end_thread_node: @<Implement \.{\\pdfendthread}@>;
pdf_save_pos_node: @<Implement \.{\\pdfsavepos}@>;
pdf_snap_ref_point_node: @<Implement \.{\\pdfsnaprefpoint}@>;
pdf_snap_x_node: @<Implement \.{\\pdfsnapx}@>;
pdf_snap_y_node: @<Implement \.{\\pdfsnapy}@>;
pdf_line_snap_x_code: @<Implement \.{\\pdflinesnapx}@>;
pdf_line_snap_y_code: @<Implement \.{\\pdflinesnapy}@>;
pdf_info_code: @<Implement \.{\\pdfinfo}@>;
pdf_catalog_code: @<Implement \.{\\pdfcatalog}@>;
pdf_names_code: @<Implement \.{\\pdfnames}@>;
pdf_include_chars_code: @<Implement \.{\\pdfincludechars}@>;
pdf_font_attr_code: @<Implement \.{\\pdffontattr}@>;
pdf_font_expand_code: @<Implement \.{\\pdffontexpand}@>;
pdf_map_file_code: @<Implement \.{\\pdfmapfile}@>;
pdf_trailer_code: @<Implement \.{\\pdftrailer}@>;
@z

@x [1354]
@<Implement \.{\\special}@>=
begin new_whatsit(special_node,write_node_size); write_stream(tail):=null;
p:=scan_toks(false,true); write_tokens(tail):=def_ref;
end
@y
@<Implement \.{\\special}@>=
begin new_whatsit(special_node,write_node_size); write_stream(tail):=null;
p:=scan_toks(false,true); write_tokens(tail):=def_ref;
end

@ The following macros are needed for further manipulation with whatsit nodes
for \pdfTeX{} extensions (copying, destroying etc.)

@d add_action_ref(#) == incr(pdf_action_refcount(#)) {increase count of
references to this action}

@d delete_action_ref(#) == {decrease count of references to this
action; free it if there is no reference to this action}
begin
    if pdf_action_refcount(#) = null then begin
        if pdf_action_type(#) = pdf_action_user then
            delete_token_ref(pdf_action_user_tokens(#))
        else begin
            if pdf_action_file(#) <> null then
                delete_token_ref(pdf_action_file(#));
            if pdf_action_type(#) = pdf_action_page then
                delete_token_ref(pdf_action_page_tokens(#))
            else if pdf_action_named_id(#) > 0 then
                delete_token_ref(pdf_action_id(#));
        end;
        free_node(#, pdf_action_size);
    end
    else
        decr(pdf_action_refcount(#));
end

@ We have to check whether \.{\\pdfoutput} is set for using \pdfTeX{}
  extensions.

@d scan_pdf_ext_toks == call_func(scan_toks(false, true)); {like \.{\\special}}

@<Declare procedures needed in |do_ext...@>=
procedure check_pdfoutput(s: str_number);
begin
    if pdf_output <= 0 then begin
        print_nl("pdfTeX error (ext1): ");
        print(s); 
        print(" used while \pdfoutput is not set"); 
        succumb;
    end;
end;

@ @<Implement \.{\\pdfliteral}@>=
begin
    check_pdfoutput("\pdfliteral");
    new_whatsit(pdf_literal_node, write_node_size);
    if scan_keyword("direct") then
        pdf_literal_direct(tail) := 1
    else
        pdf_literal_direct(tail) := 0;
    scan_pdf_ext_toks;
    pdf_literal_data(tail) := def_ref;
end

@ The \.{\\pdfobj} primitive is to create a ``raw'' object in PDF
  output file. The object contents will be hold in memory and will be written
  out only when the object je referenced by \.{\\pdfrefobj}. When \.{\\pdfobj}
  is used with \.{\\immediate}, the object contents will be written out
  immediately. Object referenced in current page are appended into
  |pdf_obj_list|.

@<Glob...@>=
@!pdf_last_obj: integer;

@ @<Implement \.{\\pdfobj}@>=
begin
    check_pdfoutput("\pdfobj");
    if scan_keyword("reserveobjnum") then begin
        incr(pdf_obj_count);
        pdf_create_obj(obj_type_obj, pdf_obj_count);
        pdf_last_obj := obj_ptr;
    end
    else begin
        if scan_keyword("useobjnum") then begin
            scan_int;
            k := cur_val;
	    if (k = 0) or (obj_data_ptr(k) <> 0) then 
	    	pdf_error("ext1", "this object numer appears to have been used");
        end
        else begin
            incr(pdf_obj_count);
            pdf_create_obj(obj_type_obj, pdf_obj_count);
            k := obj_ptr;
        end;
        obj_data_ptr(k) := pdf_get_mem(pdfmem_obj_size);
        if scan_keyword("stream") then begin
            obj_obj_is_stream(k) := 1;
            if scan_keyword("attr") then begin
                scan_pdf_ext_toks;
                obj_obj_stream_attr(k) := def_ref;
            end
            else
                obj_obj_stream_attr(k) := null;
        end
        else
            obj_obj_is_stream(k) := 0;
        if scan_keyword("file") then
            obj_obj_is_file(k) := 1
        else
            obj_obj_is_file(k) := 0;
        scan_pdf_ext_toks;
        obj_obj_data(k) := def_ref;
        pdf_last_obj := k;
    end;
end

@ We need to check whether the referenced object exists.

@<Declare procedures that need to be declared forward for pdftex@>=
procedure pdf_check_obj(t, n: integer);
var k: integer;
begin
    k := head_tab[t];
    while (k <> 0) and (k <> n) do
        k := obj_link(k);
    if k = 0 then
        pdf_error("ext1", "cannot find referenced object");
end;

@ @<Implement \.{\\pdfrefobj}@>=
begin
    check_pdfoutput("\pdfrefobj");
    scan_int;
    pdf_check_obj(obj_type_obj, cur_val);
    new_whatsit(pdf_refobj_node, pdf_refobj_node_size);
    pdf_obj_objnum(tail) := cur_val;
end

@ \.{\\pdfxform} and \.{\\pdfrefxform} are similiar to \.{\\pdfobj} and
  \.{\\pdfrefobj}

@<Glob...@>=
@!pdf_last_xform: integer;

@ @<Implement \.{\\pdfxform}@>=
begin
    check_pdfoutput("\pdfxform");
    incr(pdf_xform_count);
    pdf_create_obj(obj_type_xform, pdf_xform_count);
    k := obj_ptr;
    obj_data_ptr(k) := pdf_get_mem(pdfmem_xform_size);
    if scan_keyword("attr") then begin
        scan_pdf_ext_toks;
        obj_xform_attr(k) := def_ref;
    end
    else
        obj_xform_attr(k) := null;
    if scan_keyword("resources") then begin
        scan_pdf_ext_toks;
        obj_xform_resources(k) := def_ref;
    end
    else
        obj_xform_resources(k) := null;
    scan_int;
    if box(cur_val) = null then
        pdf_error("ext1", "\pdfxform cannot be used with a void box");
    obj_xform_width(k) := width(box(cur_val));
    obj_xform_height(k) := height(box(cur_val));
    obj_xform_depth(k) := depth(box(cur_val));
    obj_xform_box(k) := box(cur_val); {save pointer to the box}
    box(cur_val) := null;
    pdf_last_xform := k;
end

@ @<Implement \.{\\pdfrefxform}@>=
begin
    check_pdfoutput("\pdfrefxform");
    scan_int;
    pdf_check_obj(obj_type_xform, cur_val);
    new_whatsit(pdf_refxform_node, pdf_refxform_node_size);
    pdf_xform_objnum(tail) := cur_val;
    pdf_width(tail) := obj_xform_width(cur_val);
    pdf_height(tail) := obj_xform_height(cur_val);
    pdf_depth(tail) := obj_xform_depth(cur_val);
end

@ \.{\\pdfximage} and \.{\\pdfrefximage} are similiar to \.{\\pdfxform} and
  \.{\\pdfrefxform}. As we have to scan |<rule spec>| quite often, it is better
  have a |rule_node| that holds the most recently scanned |<rule spec>|.

@<Glob...@>=
@!pdf_last_ximage: integer;
@!pdf_last_ximage_pages: integer;
@!alt_rule: pointer;
@!pdf_last_pdf_box_spec: integer;

@ @<Set init...@>=
alt_rule := null;

@ @<Declare procedures needed in |do_ext...@>=
procedure scale_image(n: integer);
var x, y, xr, yr: integer; {size and resolution of image}
    w, h: scaled; {indeed size corresponds to image resolution}
    default_res: integer;
begin
    x := image_width(obj_ximage_data(n));
    y := image_height(obj_ximage_data(n));
    xr := image_x_res(obj_ximage_data(n));
    yr := image_y_res(obj_ximage_data(n));
    if (xr > 65536) or (yr > 65536) then begin
        xr := 0;
        yr := 0;
        pdf_warning("ext1", "too large image resolution ignored", true);
    end;
    if (x <= 0) or (y <= 0) or (xr < 0) or (yr < 0) then
        pdf_error("ext1", "invalid image dimensions");
    if is_pdf_image(obj_ximage_data(n)) then begin
        w := x;
        h := y;
    end
    else begin
        default_res := fix_int(pdf_image_resolution, 0, 2400);
        if (default_res > 0) and ((xr = 0) or (yr = 0)) then begin
            xr := default_res;
            yr := default_res;
        end;
        if is_running(obj_ximage_width(n)) and 
           is_running(obj_ximage_height(n)) then
        begin
            if (xr > 0) and (yr > 0) then begin
                w := ext_xn_over_d(one_hundred_inch, x, 100*xr);
                h := ext_xn_over_d(one_hundred_inch, y, 100*yr);
            end
            else begin
                w := ext_xn_over_d(one_hundred_inch, x, 7200);
                h := ext_xn_over_d(one_hundred_inch, y, 7200);
            end;
        end;
    end;
    if is_running(obj_ximage_width(n)) and is_running(obj_ximage_height(n)) and
        is_running(obj_ximage_depth(n)) then begin
        obj_ximage_width(n) := w;
        obj_ximage_height(n) := h;
        obj_ximage_depth(n) := 0;
    end
    else if is_running(obj_ximage_width(n)) then begin
        {image depth or height is explicitly specified}
        if is_running(obj_ximage_height(n)) then begin
            {image depth is explicitly specified}
            obj_ximage_width(n) := ext_xn_over_d(h, x, y);
            obj_ximage_height(n) := h - obj_ximage_depth(n);
        end
        else if is_running(obj_ximage_depth(n)) then begin
            {image height is explicitly specified}
            obj_ximage_width(n) := ext_xn_over_d(obj_ximage_height(n), x, y);
            obj_ximage_depth(n) := 0;
        end
        else begin
            {both image depth and height are explicitly specified}
            obj_ximage_width(n) := ext_xn_over_d(obj_ximage_height(n) + 
                                                 obj_ximage_depth(n), x, y);
        end;
    end
    else begin
        {image width is explicitly specified}
        if is_running(obj_ximage_height(n)) and 
           is_running(obj_ximage_depth(n)) then begin
            {both image depth and height are not specified}
            obj_ximage_height(n) := ext_xn_over_d(obj_ximage_width(n), y, x);
            obj_ximage_depth(n) := 0;
        end
        {image depth is explicitly specified}
        else if is_running(obj_ximage_height(n)) then begin
            obj_ximage_height(n) := 
                ext_xn_over_d(obj_ximage_width(n), y, x) - obj_ximage_depth(n);
        end
        {image height is explicitly specified}
        else if is_running(obj_ximage_depth(n)) then begin
            obj_ximage_depth(n) := 0;
        end
        {both image depth and height are explicitly specified}
        else
            do_nothing;
    end;
end;

procedure scan_pdf_box_spec; {scans pdf-box-spec to |pdf_last_pdf_box_spec|}
begin 
    pdf_last_pdf_box_spec := pdf_pdf_box_spec_crop; 
    
    if scan_keyword("mediabox") then
        pdf_last_pdf_box_spec := pdf_pdf_box_spec_media
    else if scan_keyword("cropbox") then 
        pdf_last_pdf_box_spec := pdf_pdf_box_spec_crop
    else if scan_keyword("bleedbox") then 
        pdf_last_pdf_box_spec := pdf_pdf_box_spec_bleed
    else if scan_keyword("trimbox") then 
        pdf_last_pdf_box_spec := pdf_pdf_box_spec_trim
    else if scan_keyword("artbox") then 
        pdf_last_pdf_box_spec := pdf_pdf_box_spec_art
end;

procedure scan_alt_rule; {scans rule spec to |alt_rule|}
label reswitch;
begin 
    if alt_rule = null then
        alt_rule := new_rule;
    width(alt_rule) := null_flag;
    height(alt_rule) := null_flag;
    depth(alt_rule) := null_flag;
reswitch: 
    if scan_keyword("width") then begin
        scan_normal_dimen;
        width(alt_rule) := cur_val;
        goto reswitch;
    end;
    if scan_keyword("height") then begin
        scan_normal_dimen;
        height(alt_rule) := cur_val;
        goto reswitch;
    end;
    if scan_keyword("depth") then begin
        scan_normal_dimen;
        depth(alt_rule) := cur_val;
        goto reswitch;
    end;
end;

procedure scan_image;
label reswitch;
var p: pointer;
    k: integer;
    named: str_number;
    s: str_number;
    page: integer;
begin
    incr(pdf_ximage_count);
    pdf_create_obj(obj_type_ximage, pdf_ximage_count);
    k := obj_ptr;
    obj_data_ptr(k) := pdf_get_mem(pdfmem_ximage_size);
    scan_alt_rule; {scans |<rule spec>| to |alt_rule|}
    obj_ximage_width(k) := width(alt_rule);
    obj_ximage_height(k) := height(alt_rule);
    obj_ximage_depth(k) := depth(alt_rule);
    if scan_keyword("attr") then begin
        scan_pdf_ext_toks;
        obj_ximage_attr(k) := def_ref;
    end
    else
        obj_ximage_attr(k) := null;
    named := 0;
    if scan_keyword("named") then begin
        scan_pdf_ext_toks;
       named := tokens_to_string(def_ref);
       delete_token_ref(def_ref);
    end
    else if scan_keyword("page") then begin
        scan_int;
        page := cur_val;
    end
    else
        page := 1;
    scan_pdf_box_spec; {scans pdf-box-spec to |pdf_last_pdf_box_spec|}
    scan_pdf_ext_toks;
    s := tokens_to_string(def_ref);
    delete_token_ref(def_ref);
    if pdf_option_always_use_pdfpagebox > 0 then begin
        print_err("pdfTeX warning (image inclusion): ");
        print ("\pdfoptionalwaysusepdfpagebox is in use ("); 
        print_int (pdf_option_always_use_pdfpagebox); 
        print (")");
        print_ln;
    end;
    obj_ximage_data(k) := read_image(s, page, named, 
                                     pdf_option_pdf_minor_version, 
                                     pdf_option_always_use_pdfpagebox,
                                     pdf_option_pdf_inclusion_errorlevel);
    if named <> 0 then flush_str(named);
    flush_str(s);
    scale_image(k);
    pdf_last_ximage := k;
    pdf_last_ximage_pages := image_pages(obj_ximage_data(k));
end;

@ @<Implement \.{\\pdfximage}@>=
begin
    check_pdfoutput("\pdfximage");
    check_and_set_pdfoptionpdfminorversion;
    scan_image;
end

@ @<Implement \.{\\pdfrefximage}@>=
begin
    check_pdfoutput("\pdfrefximage");
    scan_int;
    pdf_check_obj(obj_type_ximage, cur_val);
    new_whatsit(pdf_refximage_node, pdf_refximage_node_size);
    pdf_ximage_objnum(tail) := cur_val;
    pdf_width(tail) := obj_ximage_width(cur_val);
    pdf_height(tail) := obj_ximage_height(cur_val);
    pdf_depth(tail) := obj_ximage_depth(cur_val);
end

@ The following function finds object with identifier |i| and type |t|. 
  |i < 0| indicates that |-i| should be treated as a string number. If no
  such object exists then it will be created. This function is used mainly to
  find destination for link annotations and outlines; however it is also used
  in |pdf_ship_out| (to check whether a Page object already exists) so we need
  to declare it together with subroutines needed in |pdf_hlist_out| and
  |pdf_vlist_out|.

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
function find_obj(t, i: integer; byname: small_number): integer; 
label found, done;
var p, r: integer;
begin
    p := head_tab[t];
    r := 0;
    if byname > 0 then begin
        while p <> 0 do begin
            if (obj_info(p) < 0) and (str_eq_str(-obj_info(p), i)) then begin
                r := p;
                goto done;
            end;
            p := obj_link(p);
        end;
    end
    else while p <> 0 do begin
        if  obj_info(p) = i then begin
            r := p;
            goto done;
        end;
        p := obj_link(p);
    end;
done:
    find_obj := r;
end;

function get_obj(t, i: integer; byname: small_number): integer; 
var r: integer;
    s: str_number;
begin
    if byname > 0 then begin
        s := tokens_to_string(i);
        r := find_obj(t, s, true);
    end
    else begin
        s := 0;
        r := find_obj(t, i, false);
    end;
    if r = 0 then begin
        if byname > 0 then begin
            pdf_create_obj(t, -s);
            s := 0;
        end
        else
            pdf_create_obj(t, i);
        r := obj_ptr;
        if t = obj_type_dest then
            obj_dest_ptr(r) := null;
    end;
    if s <> 0 then
        flush_str(s);
    get_obj := r;
end;

@ @<Declare procedures needed in |do_ext...@>=
function scan_action: pointer; {read an action specification}
var p, t: integer;
    s: str_number;
begin
    p := get_node(pdf_action_size);
    scan_action := p;
    pdf_action_file(p) := null;
    pdf_action_refcount(p) := null;
    if scan_keyword("user") then
        pdf_action_type(p) := pdf_action_user
    else if scan_keyword("goto") then
        pdf_action_type(p) := pdf_action_goto
    else if scan_keyword("thread") then
        pdf_action_type(p) := pdf_action_thread
    else
        pdf_error("ext1", "action type missing");
    if pdf_action_type(p) = pdf_action_user then begin
        call_func(scan_toks(false, true));
        pdf_action_user_tokens(p) := def_ref;
        return;
    end;
    if scan_keyword("file") then begin
        call_func(scan_toks(false, true));
        pdf_action_file(p) := def_ref;
    end;
    if scan_keyword("page") then begin
        if pdf_action_type(p) <> pdf_action_goto then
            pdf_error("ext1", "only GoTo action can be used with `page'");
        pdf_action_type(p) := pdf_action_page;
        scan_int;
        if cur_val <= 0 then
            pdf_error("ext1", "page number must be positive");
        pdf_action_id(p) := cur_val;
        pdf_action_named_id(p) := 0;
        call_func(scan_toks(false, true));
        pdf_action_page_tokens(p) := def_ref;
    end
    else if scan_keyword("name") then begin
        call_func(scan_toks(false, true));
        pdf_action_named_id(p) := 1;
        pdf_action_id(p) := def_ref;
    end
    else if scan_keyword("num") then begin
        if (pdf_action_type(p) = pdf_action_goto) and
            (pdf_action_file(p) <> null) then
            pdf_error("ext1",
                "`goto' option cannot be used with both `file' and `num'");
        scan_int;
        if cur_val <= 0 then
            pdf_error("ext1", "num identifier must be positive");
        pdf_action_named_id(p) := 0;
        pdf_action_id(p) := cur_val;
    end
    else
        pdf_error("ext1", "identifier type missing");
    if scan_keyword("newwindow") then
        pdf_action_new_window(p) := 1
    else if scan_keyword("nonewwindow") then
        pdf_action_new_window(p) := 2
    else
        pdf_action_new_window(p) := 0;
    if (pdf_action_new_window(p) > 0) and
        (((pdf_action_type(p) <> pdf_action_goto) and
          (pdf_action_type(p) <> pdf_action_page)) or
         (pdf_action_file(p) = null)) then
            pdf_error("ext1",
                "`newwindow'/`nonewwindow' must be used with `goto' and `file' option");
end;

procedure new_annot_whatsit(w, s: small_number); {create a new whatsit node for
annotation}
var p: pointer;
begin
    new_whatsit(w, s);
    scan_alt_rule; {scans |<rule spec>| to |alt_rule|}
    pdf_width(tail) := width(alt_rule);
    pdf_height(tail) := height(alt_rule);
    pdf_depth(tail) := depth(alt_rule);
    if (w = pdf_start_link_node) then begin
        if scan_keyword("attr") then begin
            call_func(scan_toks(false, true));
            pdf_link_attr(tail) := def_ref;
        end
        else
            pdf_link_attr(tail) := null;
    end;
    if (w = pdf_thread_node) or (w = pdf_start_thread_node) then begin
        if scan_keyword("attr") then begin
            call_func(scan_toks(false, true));
            pdf_thread_attr(tail) := def_ref;
        end
        else
            pdf_thread_attr(tail) := null;
    end;
end;

@ @<Glob...@>=
@!pdf_last_annot: integer;

@ @<Implement \.{\\pdfannot}@>=
begin
    check_pdfoutput("\pdfannot");
    k := pdf_new_objnum;
    new_annot_whatsit(pdf_annot_node, pdf_annot_node_size);
    pdf_annot_objnum(tail) := k;
    call_func(scan_toks(false, true));
    pdf_annot_data(tail) := def_ref;
    pdf_last_annot := k;
end

@ @<Implement \.{\\pdfstartlink}@>=
begin
    check_pdfoutput("\pdfstartlink");
    if abs(mode) = vmode then
        pdf_error("ext1", "\pdfstartlink cannot be used in vertical mode");
    new_annot_whatsit(pdf_start_link_node, pdf_annot_node_size);
    pdf_link_action(tail) := scan_action;
end

@ @<Implement \.{\\pdfendlink}@>=
begin
    check_pdfoutput("\pdfendlink");
    if abs(mode) = vmode then
        pdf_error("ext1", "\pdfendlink cannot be used in vertical mode");
    new_whatsit(pdf_end_link_node, small_node_size);
end

@ @<Declare procedures needed in |do_ext...@>=
function outline_list_count(p: pointer): integer; {return number of outline
entries in the same level with |p|}
var k: integer;
begin
    k := 1;
    while obj_outline_prev(p) <> 0 do begin
        incr(k);
        p := obj_outline_prev(p);
    end;
    outline_list_count := k;
end;

@ @<Implement \.{\\pdfoutline}@>=
begin
    check_pdfoutput("\pdfoutline");
    if scan_keyword("attr") then begin
        scan_pdf_ext_toks;
        r := def_ref;
    end
    else
        r := 0;
    p := scan_action;
    if scan_keyword("count") then begin
        scan_int;
        i := cur_val;
    end
    else
        i := 0;
    call_func(scan_toks(false, true));
    q := def_ref;
    pdf_new_obj(obj_type_others, 0);
    j := obj_ptr;
    write_action(p);
    pdf_end_obj;
    delete_action_ref(p);
    pdf_create_obj(obj_type_outline, 0);
    k := obj_ptr;
    obj_outline_ptr(k) := pdf_get_mem(pdfmem_outline_size);
    obj_outline_action_objnum(k) := j;
    obj_outline_count(k) := i;
    pdf_new_obj(obj_type_others, 0);
    pdf_print_str_ln(tokens_to_string(q));
    flush_str(last_tokens_string);
    delete_token_ref(q);
    pdf_end_obj;
    obj_outline_title(k) := obj_ptr;
    obj_outline_prev(k) := 0;
    obj_outline_next(k) := 0;
    obj_outline_first(k) := 0;
    obj_outline_last(k) := 0;
    obj_outline_parent(k) := pdf_parent_outline;
    obj_outline_attr(k) := r;
    if pdf_first_outline = 0 then
        pdf_first_outline :=  k;
    if pdf_last_outline = 0 then begin
        if pdf_parent_outline <> 0 then
            obj_outline_first(pdf_parent_outline) := k;
    end
    else begin
        obj_outline_next(pdf_last_outline) := k;
        obj_outline_prev(k) := pdf_last_outline;
    end;
    pdf_last_outline := k;
    if obj_outline_count(k) <> 0 then begin
        pdf_parent_outline := k;
        pdf_last_outline := 0;
    end
    else if (pdf_parent_outline <> 0) and
    (outline_list_count(k) = abs(obj_outline_count(pdf_parent_outline))) then
    begin
        j := pdf_last_outline;
        repeat
            obj_outline_last(pdf_parent_outline) := j;
            j := pdf_parent_outline;
            pdf_parent_outline := obj_outline_parent(pdf_parent_outline);
        until (pdf_parent_outline = 0) or
        (outline_list_count(j) < abs(obj_outline_count(pdf_parent_outline)));
        if pdf_parent_outline = 0 then
            pdf_last_outline := pdf_first_outline
        else
            pdf_last_outline := obj_outline_first(pdf_parent_outline);
        while obj_outline_next(pdf_last_outline) <> 0 do
            pdf_last_outline := obj_outline_next(pdf_last_outline);
    end;
end

@ When a destination is created we need to check whether another destination
with the same identifier already exists and give a warning if needed.

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure warn_dest_dup(id: integer; byname: small_number; s1, s2: str_number);
begin
    pdf_warning(s1, "destination with the same identifier (", false);
    if byname > 0 then begin
        print("name");
        print_mark(id);
    end
    else begin
        print("num");
        print_int(id);
    end;
    print(") ");
    print(s2);
    print_ln;
    show_context;
end;

@ Notice that |scan_keyword| doesn't care if two words have same prefix; so
we should be careful when scan keywords with same prefix. The main rule: if
there are two or more keywords with the same prefix, then always test in
order from the longest one to the shortest one. 

@<Implement \.{\\pdfdest}@>=
begin
    check_pdfoutput("\pdfdest");
    q := tail;
    new_whatsit(pdf_dest_node, pdf_dest_node_size);
    if scan_keyword("num") then begin
        scan_int;
        if cur_val <= 0 then
            pdf_error("ext1", "num identifier must be positive");
        if cur_val > max_halfword then
            pdf_error("ext1", "number too big");
        pdf_dest_id(tail) := cur_val;
        pdf_dest_named_id(tail) := 0;
    end
    else if scan_keyword("name") then begin
        call_func(scan_toks(false, true));
        pdf_dest_id(tail) := def_ref;
        pdf_dest_named_id(tail) := 1;
    end
    else
        pdf_error("ext1", "identifier type missing");
    if scan_keyword("xyz") then begin
        pdf_dest_type(tail) := pdf_dest_xyz;
        if scan_keyword("zoom") then begin
            scan_int;
            if cur_val > max_halfword then
                pdf_error("ext1", "number too big");
            pdf_dest_xyz_zoom(tail) := cur_val;
        end
        else
            pdf_dest_xyz_zoom(tail) := null;
    end
    else if scan_keyword("fitbh") then
        pdf_dest_type(tail) := pdf_dest_fitbh
    else if scan_keyword("fitbv") then
        pdf_dest_type(tail) := pdf_dest_fitbv
    else if scan_keyword("fitb") then
        pdf_dest_type(tail) := pdf_dest_fitb
    else if scan_keyword("fith") then
        pdf_dest_type(tail) := pdf_dest_fith
    else if scan_keyword("fitv") then
        pdf_dest_type(tail) := pdf_dest_fitv
    else if scan_keyword("fitr") then
        pdf_dest_type(tail) := pdf_dest_fitr
    else if scan_keyword("fit") then
        pdf_dest_type(tail) := pdf_dest_fit
    else
        pdf_error("ext1", "destination type missing");
    if pdf_dest_type(tail) = pdf_dest_fitr then begin
        scan_alt_rule; {scans |<rule spec>| to |alt_rule|}
        pdf_width(tail) := width(alt_rule);
        pdf_height(tail) := height(alt_rule);
        pdf_depth(tail) := depth(alt_rule);
    end;
    if pdf_dest_named_id(tail) <> 0 then begin
        i := tokens_to_string(pdf_dest_id(tail));
        k := find_obj(obj_type_dest, i, true);
        flush_str(i);
    end
    else
        k := find_obj(obj_type_dest, pdf_dest_id(tail), false);
    if (k <> 0) and (obj_dest_ptr(k) <> null) then begin
        warn_dest_dup(pdf_dest_id(tail), pdf_dest_named_id(tail),
                      "ext4", "has been already used, duplicate ignored");
        flush_node_list(tail);
        tail := q;
        link(q) := null;
    end;
end

@ @<Declare procedures needed in |do_ext...@>=
procedure scan_thread_id;
begin
    if scan_keyword("num") then begin
        scan_int;
        if cur_val <= 0 then
            pdf_error("ext1", "num identifier must be positive");
        if cur_val > max_halfword then
            pdf_error("ext1", "number too big");
        pdf_thread_id(tail) := cur_val;
        pdf_thread_named_id(tail) := 0;
    end
    else if scan_keyword("name") then begin
        call_func(scan_toks(false, true));
        pdf_thread_id(tail) := def_ref;
        pdf_thread_named_id(tail) := 1;
    end
    else
        pdf_error("ext1", "identifier type missing");
end;

@ @<Implement \.{\\pdfthread}@>=
begin
    check_pdfoutput("\pdfthread");
    new_annot_whatsit(pdf_thread_node, pdf_thread_node_size);
    scan_thread_id;
end

@ @<Implement \.{\\pdfstartthread}@>=
begin
    check_pdfoutput("\pdfstartthread");
    new_annot_whatsit(pdf_start_thread_node, pdf_thread_node_size);
    scan_thread_id;
end

@ @<Implement \.{\\pdfendthread}@>=
begin
    check_pdfoutput("\pdfendthread");
    new_whatsit(pdf_end_thread_node, small_node_size);
end

@ Extensions for getting possions and snapping.
@d snap_node_size = 2

@<Glob...@>=
@!pdf_last_x_pos: integer;
@!pdf_last_y_pos: integer;
@!pdf_snap_x_pos: integer;
@!pdf_snap_y_pos: integer;
@!pdf_line_snap_x: pointer;
@!pdf_line_snap_y: pointer;

@ @<Set init...@>=
pdf_line_snap_x := null;
pdf_line_snap_y := null;

@ @<Implement \.{\\pdfsavepos}@>=
begin
    check_pdfoutput("\pdfsavepos");
    new_whatsit(pdf_save_pos_node, small_node_size);
end

@ @<Implement \.{\\pdfsnaprefpoint}@>=
begin
    check_pdfoutput("\pdfsnaprefpoint");
    new_whatsit(pdf_snap_ref_point_node, small_node_size);
end

@ @<Declare procedures that need to be declared forward for pdftex@>=
procedure prepend_line_snap_nodes; forward;

@ @d prepend_snap_node(#) == 
if (# <> null) and (width(snap_glue_ptr(#)) <> 0) then begin
    r := copy_node_list(#);
    link(r) := list_ptr(just_box);
    list_ptr(just_box) := r;
end;

@<Declare procedures needed in |do_ext...@>=
function new_snap_node(s: small_number): pointer;
var p: pointer;
begin
    scan_glue(glue_val);
    if width(cur_val) < 0 then
        pdf_error("ext1", "negative snap glue");
    p := get_node(snap_node_size);
    type(p) := whatsit_node;
    subtype(p) := s;
    link(p) := null;
    snap_glue_ptr(p) := cur_val;
    new_snap_node := p;
end;

procedure prepend_line_snap_nodes;
var r: pointer;
begin
    prepend_snap_node(pdf_line_snap_x);
    prepend_snap_node(pdf_line_snap_y);
end;

@ @<Implement \.{\\pdfsnapx}@>=
begin
    check_pdfoutput("\pdfsnapx");
    tail_append(new_snap_node(pdf_snap_x_node));
end

@ @<Implement \.{\\pdfsnapy}@>=
begin
    check_pdfoutput("\pdfsnapy");
    tail_append(new_snap_node(pdf_snap_y_node));
end

@ @<Implement \.{\\pdflinesnapx}@>=
begin
    check_pdfoutput("\pdflinesnapx");
    if pdf_line_snap_x <> null then
        flush_node_list(pdf_line_snap_x);
    pdf_line_snap_x := new_snap_node(pdf_snap_x_node);
end

@ @<Implement \.{\\pdflinesnapy}@>=
begin
    check_pdfoutput("\pdflinesnapy");
    if pdf_line_snap_y <> null then
        flush_node_list(pdf_line_snap_y);
    pdf_line_snap_y := new_snap_node(pdf_snap_y_node);
end

@ To implement primitives as \.{\\pdfinfo}, \.{\\pdfcatalog} or
\.{\\pdfnames} we need to concatenate tokens lists.

@<Declare procedures needed in |do_ext...@>=
function concat_tokens(q, r: pointer): pointer; {concat |q| and |r| and
returns the result tokens list}
var p: pointer;
begin
    if q = null then begin
        concat_tokens := r;
        return;
    end;
    p := q;
    while link(p) <> null do
        p := link(p);
    link(p) := link(r);
    free_avail(r);
    concat_tokens := q;
end;

@ @<Implement \.{\\pdfinfo}@>=
begin
    check_pdfoutput("\pdfinfo");
    call_func(scan_toks(false, true));
    pdf_info_toks := concat_tokens(pdf_info_toks, def_ref);
end

@ @<Implement \.{\\pdfcatalog}@>=
begin
    check_pdfoutput("\pdfcatalog");
    call_func(scan_toks(false, true));
    pdf_catalog_toks := concat_tokens(pdf_catalog_toks, def_ref);
    if scan_keyword("openaction") then
        if pdf_catalog_openaction <> 0 then
            pdf_error("ext1", "duplicate of openaction")
        else begin
            p := scan_action;
            pdf_new_obj(obj_type_others, 0);
            pdf_catalog_openaction := obj_ptr;
            write_action(p);
            pdf_end_obj;
            delete_action_ref(p);
        end;
end

@ @<Implement \.{\\pdfnames}@>=
begin
    check_pdfoutput("\pdfnames");
    call_func(scan_toks(false, true));
    pdf_names_toks := concat_tokens(pdf_names_toks, def_ref);
end

@ @<Implement \.{\\pdftrailer}@>=
begin
    check_pdfoutput("\pdftrailer");
    call_func(scan_toks(false, true));
    pdf_trailer_toks := concat_tokens(pdf_trailer_toks, def_ref);
end

@ The following subroutines are about PDF-specific font issues.

@<Declare procedures needed in |do_ext...@>=
procedure pdf_include_chars; 
var s: str_number;
    k: pool_pointer; {running indices}
    f: internal_font_number;
begin
    scan_font_ident;
    f := cur_val;
    if f = null_font then
        pdf_error("font", "invalid font identifier");
    pdf_check_vf(f);
    if not font_used[f] then
        pdf_init_font(f);
    call_func(scan_toks(false, true));
    s := tokens_to_string(def_ref);
    delete_token_ref(def_ref);
    k := str_start[s];
    while k < str_start[s + 1] do begin
       pdf_mark_char(f, str_pool[k]);
       incr(k);
    end;
    flush_str(s);
end;

procedure do_expand_font;
var font_shrink, font_stretch, font_step, expand_factor: integer;
    f: internal_font_number;
begin
    scan_font_ident;
    f := cur_val;
    if f = null_font then
        pdf_error("font", "invalid font identifier");
    scan_optional_equals;
    scan_int;
    font_stretch := fix_int(cur_val, 0, 1000);
    scan_int;
    font_shrink := fix_int(cur_val, 0, 1000);
    scan_int;
    font_step := fix_int(cur_val, 0, 1000);
    scan_int;
    expand_factor := fix_int(cur_val, 0, 1000);
    if (expand_factor <> 1000) and (pdf_output <= 0) then
        pdf_error("expand", "only font expansion factor 1000 can used in DVI mode");
    if font_step = 0 then
        pdf_error("expand", "invalid step of font expansion");
    font_stretch := font_stretch - font_stretch mod font_step;
    font_shrink := font_shrink - font_shrink mod font_step;
    pdf_font_step[f] := font_step;
    pdf_font_expand_factor[f] := expand_factor;
    if font_stretch > 0 then
        pdf_font_stretch[f] := new_ex_font(f, font_stretch);
    if font_shrink > 0 then
        pdf_font_shrink[f] := new_ex_font(f, -font_shrink);

end;

@ @<Implement \.{\\pdfincludechars}@>= 
begin
    check_pdfoutput("\pdfincludechars");
    pdf_include_chars;
end

@ @<Implement \.{\\pdffontattr}@>= 
begin
    check_pdfoutput("\pdffontattr");
    scan_font_ident;
    k := cur_val;
    if k = null_font then
        pdf_error("font", "invalid font identifier");
    call_func(scan_toks(false, true));
    pdf_font_attr[k] := tokens_to_string(def_ref);
end

@ @<Implement \.{\\pdffontexpand}@>= 
    do_expand_font

@ @<Implement \.{\\pdfmapfile}@>= 
begin
    check_pdfoutput("\pdfmapfile");
    call_func(scan_toks(false, true));
    pdfmapfile(def_ref);
    delete_token_ref(def_ref);
end

@ The following function are needed for outputing the article thread.

@<Declare procedures needed in |do_ext...@>=
procedure thread_title(thread: integer);
begin
    pdf_print("/Title (");
    if obj_info(thread) < 0 then
        pdf_print(-obj_info(thread))
    else
        pdf_print_int(obj_info(thread));
    pdf_print_ln(")");
end;

procedure pdf_fix_thread(thread: integer);
var a: pointer;
begin
    pdf_warning("thread", "destination ", false);
    if obj_info(thread) < 0 then begin
        print("name{");
        print(-obj_info(thread));
        print("}");
    end
    else begin
        print("num");
        print_int(obj_info(thread));
    end;
    print(" has been referenced but does not exist, replaced by a fixed one");
    print_ln; print_ln;
    pdf_new_dict(obj_type_others, 0);
    a := obj_ptr;
    pdf_indirect_ln("T", thread);
    pdf_indirect_ln("V", a);
    pdf_indirect_ln("N", a);
    pdf_indirect_ln("P", head_tab[obj_type_page]);
    pdf_print("/R [0 0 ");
    pdf_print_mag_bp(pdf_page_width); pdf_out(" ");
    pdf_print_mag_bp(pdf_page_height);
    pdf_print_ln("]");
    pdf_end_dict;
    pdf_begin_dict(thread);
    pdf_print_ln("/I << ");
    thread_title(thread);
    pdf_print_ln(">>");
    pdf_indirect_ln("F", a);
    pdf_end_dict;
end;

procedure out_thread(thread: integer);
var a, b, c: pointer;
    last_attr: integer;
begin
    if obj_thread_first(thread) = 0 then begin
        pdf_fix_thread(thread);
        return;
    end;
    pdf_begin_dict(thread);
    a := obj_thread_first(thread);
    b := a;
    last_attr := 0;
    repeat
        if obj_bead_attr(a) <> 0 then
            last_attr := obj_bead_attr(a);
        a := obj_bead_next(a);
    until a = b;
    if last_attr <> 0 then
        pdf_print_ln(last_attr)
    else begin
        pdf_print_ln("/I << ");
        thread_title(thread);
        pdf_print_ln(">>");
    end;
    pdf_indirect_ln("F", a);
    pdf_end_dict;
    repeat
        pdf_begin_dict(a);
        if a = b then
            pdf_indirect_ln("T", thread);
        pdf_indirect_ln("V", obj_bead_prev(a));
        pdf_indirect_ln("N", obj_bead_next(a));
        pdf_indirect_ln("P", obj_bead_page(a));
        pdf_indirect_ln("R", obj_bead_rect(a));
        pdf_end_dict;
        a := obj_bead_next(a);
    until a = b;
end;

@ @<Display <rule spec> for whatsit node created by pdf\TeX@>=
print("("); 
print_rule_dimen(pdf_height(p)); 
print_char("+");
print_rule_dimen(pdf_depth(p));
print(")x");
print_rule_dimen(pdf_width(p))
@z

@x [1356]
othercases print("whatsit?")
@y
pdf_literal_node: begin
    print_esc("pdfliteral");
    if pdf_literal_direct(p) > 0 then
        print(" direct");
    print_mark(pdf_literal_data(p));
end;
pdf_refobj_node: begin
    print_esc("pdfrefobj");
    if obj_obj_is_stream(pdf_obj_objnum(p)) > 0 then begin
        if obj_obj_stream_attr(pdf_obj_objnum(p)) <> null then begin
            print(" attr");
            print_mark(obj_obj_stream_attr(pdf_obj_objnum(p)));
        end;
        print(" stream");
    end;
    if obj_obj_is_file(pdf_obj_objnum(p)) > 0 then
        print(" file");
    print_mark(obj_obj_data(pdf_obj_objnum(p)));
end;
pdf_refxform_node: begin
    print_esc("pdfrefxform");
    print("("); 
    print_scaled(obj_xform_height(pdf_xform_objnum(p))); 
    print_char("+");
    print_scaled(obj_xform_depth(pdf_xform_objnum(p))); 
    print(")x");
    print_scaled(obj_xform_width(pdf_xform_objnum(p))); 
end;
pdf_refximage_node: begin
    print_esc("pdfrefximage");
    print("("); 
    print_scaled(obj_ximage_height(pdf_ximage_objnum(p))); 
    print_char("+");
    print_scaled(obj_ximage_depth(pdf_ximage_objnum(p))); 
    print(")x");
    print_scaled(obj_ximage_width(pdf_ximage_objnum(p))); 
end;
pdf_annot_node: begin
    print_esc("pdfannot");
    @<Display <rule spec> for whatsit node created by pdf\TeX@>;
    print_mark(pdf_annot_data(p));
end;
pdf_start_link_node: begin
    print_esc("pdflink");
    @<Display <rule spec> for whatsit node created by pdf\TeX@>;
    if pdf_link_attr(p) <> null then begin
        print(" attr");
        print_mark(pdf_link_attr(p));
    end;
    print(" action");
    if pdf_action_type(pdf_link_action(p)) = pdf_action_user then begin
        print(" user");
        print_mark(pdf_action_user_tokens(pdf_link_action(p)));
        return;
    end;
    if pdf_action_file(pdf_link_action(p)) <> null then begin
        print(" file");
        print_mark(pdf_action_file(pdf_link_action(p)));
    end;
    case pdf_action_type(pdf_link_action(p)) of
    pdf_action_goto: begin
        if pdf_action_named_id(pdf_link_action(p)) > 0 then begin
            print(" goto name");
            print_mark(pdf_action_id(pdf_link_action(p)));
        end
        else begin
            print(" goto num");
            print_int(pdf_action_id(pdf_link_action(p)))
        end;
    end;
    pdf_action_page: begin
        print(" page");
        print_int(pdf_action_id(pdf_link_action(p)));
        print_mark(pdf_action_page_tokens(pdf_link_action(p)));
    end;
    pdf_action_thread: begin
        if pdf_action_named_id(pdf_link_action(p)) > 0 then begin
            print(" thread name");
            print_mark(pdf_action_id(pdf_link_action(p)));
        end
        else begin
            print(" thread num");
            print_int(pdf_action_id(pdf_link_action(p)));
        end;
    end;
    othercases pdf_error("displaying", "unknown action type");
    endcases;
end;
pdf_end_link_node: print_esc("pdfendlink");
pdf_dest_node: begin
    print_esc("pdfdest");
    if pdf_dest_named_id(p) > 0 then begin
        print(" name");
        print_mark(pdf_dest_id(p));
    end
    else begin
        print(" num");
        print_int(pdf_dest_id(p));
    end;
    print(" ");
    case pdf_dest_type(p) of
    pdf_dest_xyz: begin
        print("xyz");
        if pdf_dest_xyz_zoom(p) <> null then begin
            print(" zoom");
            print_int(pdf_dest_xyz_zoom(p));
        end;
    end;
    pdf_dest_fitbh: print("fitbh");
    pdf_dest_fitbv: print("fitbv");
    pdf_dest_fitb: print("fitb");
    pdf_dest_fith: print("fith");
    pdf_dest_fitv: print("fitv");
    pdf_dest_fitr: begin 
        print("fitr");
        @<Display <rule spec> for whatsit node created by pdf\TeX@>;
    end;
    pdf_dest_fit: print("fit");
    othercases print("unknown!");
    endcases;
end;
pdf_thread_node,
pdf_start_thread_node: begin
    if subtype(p) = pdf_thread_node then
        print_esc("pdfthread")
    else
        print_esc("pdfstartthread");
    print("("); print_rule_dimen(pdf_height(p)); print_char("+");
    print_rule_dimen(pdf_depth(p)); print(")x");
    print_rule_dimen(pdf_width(p));
    if pdf_thread_attr(p) <> null then begin
        print(" attr");
        print_mark(pdf_thread_attr(p));
    end;
    if pdf_thread_named_id(p) > 0 then begin
        print(" name");
        print_mark(pdf_thread_id(p));
    end
    else begin
        print(" num");
        print_int(pdf_thread_id(p));
    end;
end;
pdf_end_thread_node: print_esc("pdfendthread");
pdf_save_pos_node: print_esc("pdfsavepos");
pdf_snap_ref_point_node: print_esc("pdfsnaprefpoint");
pdf_snap_x_node: begin
    print_esc("pdfsnapx");
    print_char(" ");
    print_spec(snap_glue_ptr(p), 0);
end;
pdf_snap_y_node: begin
    print_esc("pdfsnapy");
    print_char(" ");
    print_spec(snap_glue_ptr(p), 0);
end;
othercases print("whatsit?")
@z

@x [1357]
othercases confusion("ext2")
@y
pdf_literal_node: begin
    r := get_node(write_node_size);
    add_token_ref(pdf_literal_data(p));
    words := write_node_size;
end;
pdf_refobj_node: begin
    r := get_node(pdf_refobj_node_size);
    words := pdf_refobj_node_size;
end;
pdf_refxform_node: begin
    r := get_node(pdf_refxform_node_size);
    words := pdf_refxform_node_size;
end;
pdf_refximage_node: begin
    r := get_node(pdf_refximage_node_size);
    words := pdf_refximage_node_size;
end;
pdf_annot_node: begin
    r := get_node(pdf_annot_node_size);
    add_token_ref(pdf_annot_data(p));
    words := pdf_annot_node_size;
end;
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
end;
pdf_end_link_node:
    r := get_node(small_node_size);
pdf_dest_node: begin
    r := get_node(pdf_dest_node_size);
    if pdf_dest_named_id(p) > 0 then
        add_token_ref(pdf_dest_id(p));
    words := pdf_dest_node_size;
end;
pdf_thread_node,
pdf_start_thread_node: begin
    r := get_node(pdf_thread_node_size);
    if pdf_thread_named_id(p) > 0 then
        add_token_ref(pdf_thread_id(p));
    if pdf_thread_attr(p) <> null then
        add_token_ref(pdf_thread_attr(p));
    words := pdf_thread_node_size;
end;
pdf_end_thread_node:
    r := get_node(small_node_size);
pdf_save_pos_node,
pdf_snap_ref_point_node:
    r := get_node(small_node_size);
pdf_snap_x_node,
pdf_snap_y_node: begin
    add_glue_ref(snap_glue_ptr(p));
    r := get_node(small_node_size);
    words := small_node_size;
end;
othercases confusion("ext2")
@z

@x [1358]
othercases confusion("ext3")
@y
pdf_literal_node: begin
    delete_token_ref(pdf_literal_data(p));
    free_node(p, write_node_size);
end;
pdf_refobj_node:
    free_node(p, pdf_refobj_node_size);
pdf_refxform_node:
    free_node(p, pdf_refxform_node_size);
pdf_refximage_node:
    free_node(p, pdf_refximage_node_size);
pdf_annot_node: begin
    delete_token_ref(pdf_annot_data(p));
    free_node(p, pdf_annot_node_size);
end;
pdf_start_link_node: begin
    if pdf_link_attr(p) <> null then
        delete_token_ref(pdf_link_attr(p));
    delete_action_ref(pdf_link_action(p));
    free_node(p, pdf_annot_node_size);
end;
pdf_end_link_node:
    free_node(p, small_node_size);
pdf_dest_node: begin
    if pdf_dest_named_id(p) > 0 then
        delete_token_ref(pdf_dest_id(p));
    free_node(p, pdf_dest_node_size);
end;
pdf_thread_node,
pdf_start_thread_node: begin
    if pdf_thread_named_id(p) > 0 then
        delete_token_ref(pdf_thread_id(p));
    if pdf_thread_attr(p) <> null then
        delete_token_ref(pdf_thread_attr(p));
    free_node(p, pdf_thread_node_size);
end;
pdf_end_thread_node:
    free_node(p, small_node_size);
pdf_save_pos_node,
pdf_snap_ref_point_node:
    free_node(p, small_node_size);
pdf_snap_x_node,
pdf_snap_y_node: begin
    delete_glue_ref(snap_glue_ptr(p));
    free_node(p, small_node_size);
end;
othercases confusion("ext3")
@z

@x [1359]
@ @<Incorporate a whatsit node into a vbox@>=do_nothing
@y
@ @<Incorporate a whatsit node into a vbox@>=
if (subtype(p) = pdf_refxform_node) or (subtype(p) = pdf_refximage_node) then
begin x:=x+d+pdf_height(p); d:=pdf_depth(p);
s:=0;
if pdf_width(p)+s>w then w:=pdf_width(p)+s;
end
@z

@x [1360]
@ @<Incorporate a whatsit node into an hbox@>=do_nothing
@y
@ @<Incorporate a whatsit node into an hbox@>=
if (subtype(p) = pdf_refxform_node) or (subtype(p) = pdf_refximage_node) then
begin x:=x+pdf_width(p);
s:=0;
if pdf_height(p)-s>h then h:=pdf_height(p)-s;
if pdf_depth(p)+s>d then d:=pdf_depth(p)+s;
end
@z

@x [1361]
@ @<Let |d| be the width of the whatsit |p|@>=d:=0
@y
@ @<Let |d| be the width of the whatsit |p|@>=
if (subtype(p) = pdf_refxform_node) or (subtype(p) = pdf_refximage_node) then
    d := pdf_width(p)
else
    d := 0
@z

@x [1362]
@<Advance \(p)past a whatsit node in the \(l)|line_break| loop@>=@+
adv_past(cur_p)
@y
@<Advance \(p)past a whatsit node in the \(l)|line_break| loop@>=@+
begin
adv_past(cur_p);
if (subtype(cur_p) = pdf_refxform_node) or (subtype(cur_p) = pdf_refximage_node) then
    act_width:=act_width+pdf_width(cur_p);
end
@z

@x [1364]
@ @<Prepare to move whatsit |p| to the current page, then |goto contribute|@>=
goto contribute
@y
@ @<Prepare to move whatsit |p| to the current page, then |goto contribute|@>=
begin
  if (subtype(p) = pdf_refxform_node) or (subtype(p) = pdf_refximage_node) then
  begin page_total:=page_total+page_depth+pdf_height(p);
  page_depth:=pdf_depth(p);
  end;
  goto contribute;
end
@z

@x [1365]
@ @<Process whatsit |p| in |vert_break| loop, |goto not_found|@>=
goto not_found
@y
@ @<Process whatsit |p| in |vert_break| loop, |goto not_found|@>=
begin
  if (subtype(p) = pdf_refxform_node) or (subtype(p) = pdf_refximage_node) then
  begin cur_height:=cur_height+prev_dp+pdf_height(p); prev_dp:=pdf_depth(p);
  end;
  goto not_found;
end
@z

@x [1375]
@<Implement \.{\\immediate}@>=
begin get_x_token;
if (cur_cmd=extension)and(cur_chr<=close_node) then
  begin p:=tail; do_extension; {append a whatsit node}
  out_what(tail); {do the action immediately}
  flush_node_list(tail); tail:=p; link(p):=null;
  end
else back_input;
end
@y
@<Implement \.{\\immediate}@>=
begin get_x_token;
if cur_cmd=extension then begin
    if cur_chr<=close_node then
      begin p:=tail; do_extension; {append a whatsit node}
      out_what(tail); {do the action immediately}
      flush_node_list(tail); tail:=p; link(p):=null;
      end
    else case cur_chr of
        pdf_obj_code: begin
            do_extension; {scan object and set |pdf_last_obj|}
            if obj_data_ptr(pdf_last_obj) = 0 then {this object has not been initialized yet}
                pdf_error("ext1", "`\pdfobj reserveobjnum' cannot be used with \immediate");
            pdf_write_obj(pdf_last_obj);
        end;
        pdf_xform_code: begin
            do_extension; {scan form and set |pdf_last_xform|}
            pdf_cur_form := pdf_last_xform;
            pdf_ship_out(obj_xform_box(pdf_last_xform), false);
        end;
        pdf_ximage_code: begin
            do_extension; {scan image and set |pdf_last_ximage|}
            pdf_write_image(pdf_last_ximage);
        end;
    endcases;
end
else
    back_input;
end
@z

@x [1378]
@ @<Finish the extensions@>=
for k:=0 to 15 do if write_open[k] then a_close(write_file[k])
@y
@ @<Finish the extensions@>=
for k:=0 to 15 do if write_open[k] then a_close(write_file[k])

@ Shiping out PDF mark.


@<Types...@>=
dest_name_entry = record
    objname: str_number; {destination name}
    objnum: integer; {destination object number}
end;

@ @<Glob...@>=
@!cur_page_width: scaled; {width of page being shipped}
@!cur_page_height: scaled; {height of page being shipped}
@!cur_h_offset: scaled; {horizontal offset of page being shipped}
@!cur_v_offset: scaled; {vertical offset of page being shipped}
@!pdf_obj_list: pointer; {list of objects in the current page}
@!pdf_xform_list: pointer; {list of forms in the current page}
@!pdf_ximage_list: pointer; {list of images in the current page}
@!pdf_link_level: integer; {depth of nesting of box containing link annotation}
@!last_link: pointer; {pointer to the last link annotation}
@!pdf_link_ht, pdf_link_dp, pdf_link_wd: scaled; {dimensions of the last link
annotation}
@!last_thread: pointer; {pointer to the last thread}
@!pdf_thread_ht, pdf_thread_dp, pdf_thread_wd: scaled; {dimensions of the last 
thread}
@!pdf_last_thread_id: halfword; {identifier of the last thread}
@!pdf_last_thread_named_id: boolean; {is identifier of the last thread named}
@!pdf_thread_level: integer; {depth of nesting of box containing the last thread}
@!pdf_annot_list: pointer; {list of annotations in the current page}
@!pdf_link_list: pointer; {list of link annotations in the current page}
@!pdf_dest_list: pointer; {list of destinations in the current page}
@!pdf_bead_list: pointer; {list of thread beads in the current page}
@!pdf_obj_count: integer; {counter of objects}
@!pdf_xform_count: integer; {counter of forms}
@!pdf_ximage_count: integer; {counter of images}
@!pdf_cur_form: integer; {the form being output}
@!pdf_first_outline, pdf_last_outline, pdf_parent_outline: integer;
@!pdf_xform_width,
@!pdf_xform_height,
@!pdf_xform_depth: scaled; {dimension of the current form}
@!pdf_info_toks: pointer; {additional keys of Info dictionary}
@!pdf_catalog_toks: pointer; {additional keys of Catalog dictionary}
@!pdf_catalog_openaction: integer;
@!pdf_names_toks: pointer; {additional keys of Names dictionary}
@!pdf_dest_names_ptr: integer; {first unused position in |dest_names|}
@!dest_names_size: integer; {maximum number of names in name tree of PDF output file}
@!dest_names: ^dest_name_entry;
@!image_orig_x, image_orig_y: integer; {origin of cropped pdf images}
@!link_level_stack: pointer; {stack to save |pdf_link_level|}
@!pdf_trailer_toks: pointer; {additional keys of Trailer dictionary}

@ @<Set init...@>=
pdf_link_level := -1;
link_level_stack := null;
pdf_first_outline:= 0;
pdf_last_outline:= 0;
pdf_parent_outline:= 0;
pdf_obj_count := 0;
pdf_xform_count := 0;
pdf_ximage_count := 0;
pdf_dest_names_ptr := 0;
pdf_info_toks := null;
pdf_catalog_toks := null;
pdf_names_toks := null;
pdf_catalog_openaction := 0;
pdf_trailer_toks := null;

@ The following procedures are needed for outputing whatsit nodes for
pdfTeX.

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure write_action(p: pointer); {write an action specification}
var s: str_number;
    d: integer;
begin
    if pdf_action_type(p) = pdf_action_user then begin
        pdf_print_toks_ln(pdf_action_user_tokens(p));
        return;
    end;
    pdf_print("<< ");
    if pdf_action_file(p) <> null then begin
        pdf_print("/F ");
        s := tokens_to_string(pdf_action_file(p));
        if (str_pool[str_start[s]] = 40) and 
           (str_pool[str_start[s] + length(s) - 1] = 41) then
            pdf_print(s)
        else begin
            pdf_print_str(s);
        end;
        flush_str(s);
        pdf_print(" ");
        if pdf_action_new_window(p) > 0 then begin
            pdf_print("/NewWindow ");
            if pdf_action_new_window(p) = 1 then
                pdf_print("true ")
            else
                pdf_print("false ");
        end;
    end;
    case pdf_action_type(p) of
    pdf_action_page: begin
        if pdf_action_file(p) = null then begin
            pdf_print("/S /GoTo /D [");
            pdf_print_int(get_obj(obj_type_page, pdf_action_id(p), false));
            pdf_print(" 0 R");
        end
        else begin
            pdf_print("/S /GoToR /D [");
            pdf_print_int(pdf_action_id(p) - 1);
        end;
        pdf_out(" ");
        pdf_print(tokens_to_string(pdf_action_page_tokens(p)));
        flush_str(last_tokens_string);
        pdf_out("]");
    end;
    pdf_action_goto: begin
        if pdf_action_file(p) = null then begin
            pdf_print("/S /GoTo ");
            d := get_obj(obj_type_dest, pdf_action_id(p), 
                         pdf_action_named_id(p));
        end
        else
            pdf_print("/S /GoToR ");
        if pdf_action_named_id(p) > 0 then begin
            pdf_str_entry("D", tokens_to_string(pdf_action_id(p)));
            flush_str(last_tokens_string);
        end
        else if pdf_action_file(p) = null then
            pdf_indirect("D", d)
        else
            pdf_error("ext4", "`goto' option cannot be used with both `file' and `num'");
    end;
    pdf_action_thread: begin
        pdf_print("/S /Thread ");
        if pdf_action_file(p) = null then
            d := get_obj(obj_type_thread, pdf_action_id(p), 
                         pdf_action_named_id(p));
        if pdf_action_named_id(p) > 0 then begin
            pdf_str_entry("D", tokens_to_string(pdf_action_id(p)));
            flush_str(last_tokens_string);
        end
        else if pdf_action_file(p) = null then
            pdf_indirect("D", d)
        else
            pdf_int_entry("D", pdf_action_id(p));
    end;
    endcases;
    pdf_print_ln(" >>");
end;

procedure set_rect_dimens(p, parent_box: pointer; x, y, w, h, d, margin: scaled);
begin
    pdf_left(p) := cur_h;
    if is_running(w) then
        pdf_right(p) := x + width(parent_box)
    else
        pdf_right(p) := cur_h + w;
    if is_running(h) then
        pdf_top(p) := y - height(parent_box)
    else
        pdf_top(p) := cur_v - h;
    if is_running(d) then
        pdf_bottom(p) := y  + depth(parent_box)
    else
        pdf_bottom(p) := cur_v + d;
    pdf_left(p)   := pdf_left(p)   - margin;
    pdf_top(p)    := pdf_top(p)    - margin;
    pdf_right(p)  := pdf_right(p)  + margin;
    pdf_bottom(p) := pdf_bottom(p) + margin;
end;

procedure do_annot(p, parent_box: pointer; x, y: scaled);
begin
    if doing_leaders then
        return;
    set_rect_dimens(p, parent_box, x, y, 
                    pdf_width(p), pdf_height(p), pdf_depth(p), 0);
    obj_annot_ptr(pdf_annot_objnum(p)) := p;
    pdf_append_list(pdf_annot_objnum(p))(pdf_annot_list);
end;

@ To implement nesting link annotations, we need a stack to save box testing
level of each link that has been broken. Each stack entry holds the
box nesting level and pointer the whatsit node created for
corresponding \.{\\pdfstartlink}.

@d link_level(#) == info(#)
@d link_ptr(#) == info(# + 1)

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure save_link_level(l: pointer);
var p, r: pointer;
begin
    pdf_link_level := cur_s;
    r := copy_node_list(l);
    pdf_link_wd := pdf_width(r);
    pdf_link_ht := pdf_height(r);
    pdf_link_dp := pdf_depth(r);
    p := get_node(small_node_size);
    link_level(p) := pdf_link_level;
    link_ptr(p) := r;
    link(p) := link_level_stack;
    link_level_stack := p;
end;

procedure do_link(p, parent_box: pointer; x, y: scaled);
begin
    if type(parent_box) <> hlist_node then
        pdf_error("ext4", "link annotations can be inside hbox only");
    save_link_level(p);
    set_rect_dimens(p, parent_box, x, y, 
                    pdf_link_wd, pdf_link_ht, pdf_link_dp, pdf_link_margin);
    last_link := p;
    pdf_create_obj(obj_type_others, 0);
    obj_annot_ptr(obj_ptr) := p;
    pdf_append_list(obj_ptr)(pdf_link_list);
end;

procedure restore_link_level;
var p, r: pointer;
begin
    if link_level_stack = null then
        pdf_error("ext4", "invalid stack of link nesting level");
    p := link_level_stack;
    link_level_stack := link(p);
    r := link_ptr(p);
    flush_node_list(r);
    free_node(p, small_node_size);
    p := link_level_stack;
    if p = null then
        pdf_link_level := -1
    else begin
        pdf_link_level := link_level(p);
        r := link_ptr(p);
        pdf_link_wd := pdf_width(r);
        pdf_link_ht := pdf_height(r);
        pdf_link_dp := pdf_depth(r);
    end;
end;

procedure end_link;
begin
    if pdf_link_level <> cur_s then
        pdf_error("ext4", "\pdfendlink ended up in different nesting level than \pdfstartlink");
    if is_running(pdf_link_wd) and (last_link <> null) then
        pdf_right(last_link) := cur_h + pdf_link_margin;
    restore_link_level;
    last_link := null;
end;

@ For ``running'' annotations we must append a new node when the end of
annotation is in other box than its start. The new created node is identical to
corresponding whatsit node representing the start of annotation,  but its
|info| field is |null|. We set |info| field just before destroying the node, in 
order to use |flush_node_list| to do the job.

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure append_link(parent_box: pointer; x, y: scaled); {append a new
|pdf_start_link_node| to |pdf_link_list| and update |last_link|}
var p, r: integer;
begin
    if type(parent_box) <> hlist_node then
        pdf_error("ext4", "link annotations can be inside hbox only");
    r := copy_node_list(link_ptr(link_level_stack)); {copy link node to |r|}
    info(r) := max_halfword; {mark that this node is not a whatsit node}
    link(r) := null; {this node will be destroyed separately}
    set_rect_dimens(r, parent_box, x, y, 
                    pdf_link_wd, pdf_link_ht, pdf_link_dp, pdf_link_margin);
    pdf_create_obj(obj_type_others, 0);
    obj_annot_ptr(obj_ptr) := r;
    last_link := r;
    pdf_append_list(obj_ptr)(pdf_link_list);
end;

@ Threads are handled in similar way as link annotations.

@<Declare procedures needed in |pdf_hlist_out|, |pdf_vlist_out|@>=
procedure append_bead(p: pointer);
var a, b, c, t: integer;
begin
    t := get_obj(obj_type_thread, pdf_thread_id(p), pdf_thread_named_id(p));
    b := pdf_new_objnum;
    obj_bead_ptr(b) := pdf_get_mem(pdfmem_bead_size);
    obj_bead_page(b) := pdf_last_page;
    obj_bead_data(b) := p; 
    if pdf_thread_attr(p) <> null then
        obj_bead_attr(b) := tokens_to_string(pdf_thread_attr(p))
    else
        obj_bead_attr(b) := 0; 
    if obj_thread_first(t) = 0 then begin
        obj_thread_first(t) := b;
        obj_bead_next(b) := b;
        obj_bead_prev(b) := b;
    end
    else begin
        a := obj_thread_first(t);
        c := obj_bead_prev(a);
        obj_bead_prev(b) := c;
        obj_bead_next(b) := a;
        obj_bead_prev(a) := b;
        obj_bead_next(c) := b;
    end;
    pdf_append_list(b)(pdf_bead_list);
end;

procedure do_thread(p, parent_box: pointer; x, y: scaled);
begin
    if doing_leaders then
        return;
    if subtype(p) = pdf_start_thread_node then begin
        pdf_thread_wd := pdf_width(p);
        pdf_thread_ht := pdf_height(p);
        pdf_thread_dp := pdf_depth(p);
        pdf_last_thread_id := pdf_thread_id(p);
        pdf_last_thread_named_id := (pdf_thread_named_id(p) > 0);
        if pdf_last_thread_named_id then
            add_token_ref(pdf_thread_id(p));
        pdf_thread_level := cur_s;
    end;
    set_rect_dimens(p, parent_box, x, y, 
                    pdf_width(p), pdf_height(p), pdf_depth(p),
                    pdf_thread_margin);
    append_bead(p);
    last_thread := p;
end;

procedure append_thread(parent_box: pointer; x, y: scaled);
var p: pointer;
begin
    p := get_node(pdf_thread_node_size);
    info(p) := max_halfword; {this is not a whatsit node}
    link(p) := null; {this node will be destroyed separately}
    pdf_width(p) := pdf_thread_wd;
    pdf_height(p) := pdf_thread_ht;
    pdf_depth(p) := pdf_thread_dp;
    pdf_thread_attr(p) := null;
    pdf_thread_id(p) := pdf_last_thread_id;
    if pdf_last_thread_named_id then begin
        add_token_ref(pdf_thread_id(p));
        pdf_thread_named_id(p) := 1;
    end
    else
        pdf_thread_named_id(p) := 0;
    set_rect_dimens(p, parent_box, x, y, 
                    pdf_width(p), pdf_height(p), pdf_depth(p),
                    pdf_thread_margin);
    append_bead(p);
    last_thread := p;
end;

procedure end_thread;
begin
    if pdf_thread_level <> cur_s then
        pdf_error("ext4", "\pdfendthread ended up in different nesting level than \pdfstartthread");
    if is_running(pdf_thread_dp) and (last_thread <> null) then
        pdf_bottom(last_thread) := cur_v + pdf_thread_margin;
    if pdf_last_thread_named_id then
        delete_token_ref(pdf_last_thread_id);
    last_thread := null;
end;

function open_subentries(p: pointer): integer;
var k, c: integer;
    l, r: integer;
begin
    k := 0;
    if obj_outline_first(p) <> 0 then begin
        l := obj_outline_first(p);
        repeat
            incr(k);
            c := open_subentries(l);
            if obj_outline_count(l) > 0 then
                k := k + c;
            obj_outline_parent(l) := p;
            r := obj_outline_next(l);
            if r = 0 then
                obj_outline_last(p) := l;
            l := r;
        until l = 0;
    end;
    if obj_outline_count(p) > 0 then
        obj_outline_count(p) := k
    else
        obj_outline_count(p) := -k;
    open_subentries := k;
end;

procedure do_dest(p, parent_box: pointer; x, y: scaled);
var k: integer;
begin
    if doing_leaders then
        return;
    k := get_obj(obj_type_dest, pdf_dest_id(p), pdf_dest_named_id(p));
    if obj_dest_ptr(k) <> null then begin
        warn_dest_dup(pdf_dest_id(p), pdf_dest_named_id(p),
                      "ext4", "has been already used, duplicate ignored");
        return;
    end;
    obj_dest_ptr(k) := p;
    pdf_append_list(k)(pdf_dest_list);
    case pdf_dest_type(p) of
    pdf_dest_xyz: begin
        pdf_left(p) := cur_h;
        pdf_top(p) := cur_v;
    end;
    pdf_dest_fith,
    pdf_dest_fitbh:
        pdf_top(p) := cur_v;
    pdf_dest_fitv,
    pdf_dest_fitbv:
        pdf_left(p) := cur_h;
    pdf_dest_fit,
    pdf_dest_fitb:
        do_nothing;
    pdf_dest_fitr:
        set_rect_dimens(p, parent_box, x, y, 
                        pdf_width(p), pdf_height(p), pdf_depth(p), 
                        pdf_dest_margin);
    endcases;
end;

procedure out_form(p: pointer);
begin
    pdf_end_text;
    pdf_print_ln("q");
    if pdf_lookup_list(pdf_xform_list, pdf_xform_objnum(p)) = null then
        pdf_append_list(pdf_xform_objnum(p))(pdf_xform_list);
    cur_v := cur_v + obj_xform_depth(pdf_xform_objnum(p));
    pdf_print("1 0 0 1 ");
    pdf_print_bp(pdf_x(cur_h)); pdf_out(" ");
    pdf_print_bp(pdf_y(cur_v));
    pdf_print_ln(" cm");
    pdf_print("/Fm");
    pdf_print_int(obj_info(pdf_xform_objnum(p)));
    pdf_print_resname_prefix;
    pdf_print_ln(" Do");
    pdf_print_ln("Q");
end;

procedure out_image(p: pointer);
var image: integer;
begin
    image := obj_ximage_data(pdf_ximage_objnum(p));
    pdf_end_text;
    pdf_print_ln("q");
    if pdf_lookup_list(pdf_ximage_list, pdf_ximage_objnum(p)) = null then
        pdf_append_list(pdf_ximage_objnum(p))(pdf_ximage_list);
    if not is_pdf_image(image) then begin
        pdf_print_real(ext_xn_over_d(pdf_width(p), 
                       10000, one_bp), 4); {1000000,6 leads to overflows with large images}
        pdf_print(" 0 0 ");
        pdf_print_real(ext_xn_over_d(pdf_height(p) + pdf_depth(p), 
                       10000, one_bp), 4); {1000000,6 leads to overflows with large images}
        pdf_out(" ");
        pdf_print_bp(pdf_x(cur_h)); pdf_out(" ");
        pdf_print_bp(pdf_y(cur_v));
    end
    else begin
        pdf_print_real(ext_xn_over_d(pdf_width(p),
                       1000000, image_width(image)), 6);
        pdf_print(" 0 0 ");
        pdf_print_real(ext_xn_over_d(pdf_height(p) + pdf_depth(p),
                       1000000, image_height(image)), 6);
        pdf_out(" ");
        pdf_print_bp(pdf_x(cur_h) -
                     ext_xn_over_d(pdf_width(p), epdf_orig_x(image), 
                                   image_width(image)));
        pdf_out(" ");
        pdf_print_bp(pdf_y(cur_v) -
                     ext_xn_over_d(pdf_height(p), epdf_orig_y(image), 
                                   image_height(image)));
    end;
    pdf_print_ln(" cm");
    pdf_print("/Im");
    pdf_print_int(obj_info(pdf_ximage_objnum(p)));
    pdf_print_resname_prefix;
    pdf_print_ln(" Do");
    pdf_print_ln("Q");
end;

procedure do_snap(p: pointer);
var gap_amount, stretch_amount, shrink_amount: scaled;
    cur_point, last_point, next_point: scaled;
begin
    gap_amount := width(snap_glue_ptr(p));
    if stretch_order(snap_glue_ptr(p)) > normal then
        stretch_amount := max_dimen
    else
        stretch_amount := stretch(snap_glue_ptr(p));
    if shrink_order(snap_glue_ptr(p)) > normal then
        shrink_amount := max_dimen
    else
        shrink_amount := shrink(snap_glue_ptr(p));
    if subtype(p) = pdf_snap_x_node then begin
        cur_point := cur_h;
        last_point := pdf_snap_x_pos + 
            gap_amount * ((cur_point - pdf_snap_x_pos) div gap_amount);
    end
    else begin
        cur_point := cur_v;
        last_point := pdf_snap_y_pos + 
            gap_amount * ((cur_point - pdf_snap_y_pos) div gap_amount);
    end;
    next_point := last_point + gap_amount;
    {|
    print_nl("snap glue = "); print_spec(snap_glue_ptr(p), "pt");
    print_nl("gap amount = "); print_scaled(gap_amount); 
    print_nl("stretch amount = "); print_scaled(stretch_amount); 
    print_nl("shrink amount = "); print_scaled(shrink_amount); 
    print_nl("last point = "); print_scaled(last_point); 
    print_nl("cur point = "); print_scaled(cur_point); 
    print_nl("next point = "); print_scaled(next_point); 
    |}
    if (cur_point - last_point > shrink_amount) and
        (next_point - cur_point > stretch_amount) then
        return;
    if cur_point - last_point > shrink_amount then
        cur_point := next_point
    else if next_point - cur_point > stretch_amount then
        cur_point := last_point
    else if cur_point - last_point <= next_point - cur_point then
        cur_point := last_point
    else 
        cur_point := next_point;
    if subtype(p) = pdf_snap_x_node then
        cur_h := cur_point
    else
        cur_v := cur_point;
end;

function node_type(p: pointer): integer;
begin
    node_type := 0;
    if p = null then
        return;
    if is_char_node(p) then
        print("char_node")
    else case type(p) of
    hlist_node: print("hlist_node");
    vlist_node: print("vlist_node");
    rule_node: print("rule_node");
    ins_node: print("ins_node");
    mark_node: print("mark_node");
    adjust_node: print("adjust_node");
    ligature_node: print("ligature_node");
    disc_node: print("disc_node");
    whatsit_node: print("whatsit_node");
    math_node: print("math_node");
    glue_node: print("glue_node");
    kern_node: print("kern_node");
    penalty_node: print("penalty_node");
    unset_node: print("unset_node");
    style_node: print("style_node");
    choice_node: print("choice_node");
    endcases;
    print_ln;
end;


@ @<Output the whatsit node |p| in |pdf_vlist_out|@>=
case subtype(p) of
pdf_literal_node:
    pdf_out_literal(p);
pdf_refobj_node:
    pdf_append_list(pdf_obj_objnum(p))(pdf_obj_list);
pdf_refxform_node:
    @<Output a Form node in a vlist@>;
pdf_refximage_node:
    @<Output a Image node in a vlist@>;
pdf_annot_node:
    do_annot(p, this_box, left_edge, top_edge + height(this_box));
pdf_start_link_node:
    pdf_error("ext4", "\pdfstartlink ended up in vlist");
pdf_end_link_node:
    pdf_error("ext4", "\pdfendlink ended up in vlist");
pdf_dest_node:
    do_dest(p, this_box, left_edge, top_edge + height(this_box));
pdf_thread_node,
pdf_start_thread_node:
    do_thread(p, this_box, left_edge, top_edge + height(this_box));
pdf_end_thread_node:
    end_thread;
pdf_save_pos_node:
    @<Save current position to |pdf_last_x_pos|, |pdf_last_y_pos|@>;
pdf_snap_ref_point_node:
    @<Save current position to |pdf_snap_x_pos|, |pdf_snap_y_pos|@>;
pdf_snap_x_node,
pdf_snap_y_node: begin
    do_snap(p);
    if list_ptr(this_box) = p then begin
        top_edge := cur_v;
        left_edge := cur_h;
    end;
end;
special_node:
    pdf_special(p);
othercases out_what(p);
endcases

@ @<Glob...@>=
@!is_shipping_page: boolean; {set to |shipping_page| when |pdf_ship_out| starts}

@ @<Save current position to |pdf_last_x_pos|, |pdf_last_y_pos|@>=
begin
    pdf_last_x_pos := cur_h;
    if is_shipping_page then
        pdf_last_y_pos := cur_page_height - cur_v
    else
        pdf_last_y_pos := pdf_xform_height + pdf_xform_depth - cur_v;
end

@ @<Save current position to |pdf_snap_x_pos|, |pdf_snap_y_pos|@>=
begin
    pdf_snap_x_pos := cur_h;
    pdf_snap_y_pos := cur_v;
end

@ @<Output a Image node in a vlist@>=
begin cur_v:=cur_v+pdf_height(p)+pdf_depth(p); save_v:=cur_v;
  cur_h:=left_edge;
  out_image(p);
  cur_v:=save_v; cur_h:=left_edge;
  end

@ @<Output a Form node in a vlist@>=
begin cur_v:=cur_v+pdf_height(p); save_v:=cur_v;
  cur_h:=left_edge;
  out_form(p);
  cur_v:=save_v+pdf_depth(p); cur_h:=left_edge;
  end

@ @<Output the whatsit node |p| in |pdf_hlist_out|@>=
case subtype(p) of
pdf_literal_node:
    pdf_out_literal(p);
pdf_refobj_node:
    pdf_append_list(pdf_obj_objnum(p))(pdf_obj_list);
pdf_refxform_node:
    @<Output a Form node in a hlist@>;
pdf_refximage_node:
    @<Output a Image node in a hlist@>;
pdf_annot_node:
    do_annot(p, this_box, left_edge, base_line);
pdf_start_link_node:
    do_link(p, this_box, left_edge, base_line);
pdf_end_link_node: begin
    end_link;
    @<Create link annottation for the current hbox if needed@>;
end;
pdf_dest_node:
    do_dest(p, this_box, left_edge, base_line);
pdf_thread_node:
    do_thread(p, this_box, left_edge, base_line);
pdf_start_thread_node:
    pdf_error("ext4", "\pdfstartthread ended up in hlist");
pdf_end_thread_node:
    pdf_error("ext4", "\pdfendthread ended up in hlist");
pdf_save_pos_node:
    @<Save current position to |pdf_last_x_pos|, |pdf_last_y_pos|@>;
pdf_snap_ref_point_node:
    @<Save current position to |pdf_snap_x_pos|, |pdf_snap_y_pos|@>;
pdf_snap_x_node,
pdf_snap_y_node: begin
    do_snap(p);
    if list_ptr(this_box) = p then begin
        base_line := cur_v;
        left_edge := cur_h;
    end;
end;
special_node:
    pdf_special(p);
othercases out_what(p);
endcases

@ @<Output a Image node in a hlist@>=
begin
  cur_v:=base_line+pdf_depth(p);
  edge:=cur_h;
  out_image(p);
  cur_h:=edge+pdf_width(p); cur_v:=base_line;
  end

@ @<Output a Form node in a hlist@>=
begin
  cur_v:=base_line;
  edge:=cur_h;
  out_form(p);
  cur_h:=edge+pdf_width(p); cur_v:=base_line;
  end
@z
