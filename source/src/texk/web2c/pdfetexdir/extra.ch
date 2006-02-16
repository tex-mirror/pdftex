% Copyright (c) 2005-2006 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
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
% This is a change file implementing some (highly) exprimental features in pdftex.
% To be applied to pdftex-1.30 as the last change file to pdfetex
%
% Implemented features:
% - snapping
% - \pdfinsertht
% - kbs: kern before interword space and certain characters
% - \ifincsname
%
% Module numbers are taken from the pdfetex sources after all change files
%
% $Id: //depot/Build/source.development/TeX/texk/web2c/pdftexdir/pdftex.ch#163 $

@x [171] kbs
@d tag_code == 5
@y
@d tag_code == 5
@d kn_bs_code_base == 7
@d st_bs_code_base == 8
@d sh_bs_code_base == 9
@d kn_bc_code_base == 10
@d kn_ac_code_base == 11

@d auto_kern == explicit {please don't drop this}
@z

@x [252] kbs
@d pdf_objcompresslevel_code = pdftex_first_integer_code + 21 {activate object streams}
@d pdf_int_pars=pdftex_first_integer_code + 22 {total number of \pdfTeX's integer parameters}
@y
@d pdf_objcompresslevel_code = pdftex_first_integer_code + 21 {activate object streams}
@d pdf_adjust_interword_glue_code    = pdftex_first_integer_code + 22 {adjust interword glue?}
@d pdf_prepend_kern_code     = pdftex_first_integer_code + 23 {prepend kern before certain characters?}
@d pdf_append_kern_code      = pdftex_first_integer_code + 24 {prepend kern before certain characters?}
@d pdf_int_pars=pdftex_first_integer_code + 25 {total number of \pdfTeX's integer parameters}
@z

@x [252] kbs
@d pdf_tracing_fonts    == int_par(pdf_tracing_fonts_code)
@y
@d pdf_tracing_fonts    == int_par(pdf_tracing_fonts_code)
@d pdf_adjust_interword_glue == int_par(pdf_adjust_interword_glue_code)
@d pdf_prepend_kern == int_par(pdf_prepend_kern_code)
@d pdf_append_kern == int_par(pdf_append_kern_code)
@z

@x [253] kbs
pdf_tracing_fonts_code:    print_esc("pdftracingfonts");
@y
pdf_tracing_fonts_code:    print_esc("pdftracingfonts");
pdf_adjust_interword_glue_code:    print_esc("pdfadjustinterwordglue");
pdf_prepend_kern_code:    print_esc("pdfprependkern");
pdf_append_kern_code:    print_esc("pdfappendkern");
@z

@x [254] kbs
primitive("pdftracingfonts",assign_int,int_base+pdf_tracing_fonts_code);@/
@!@:pdf_tracing_fonts_}{\.{\\pdftracingfonts} primitive@>
@y
primitive("pdftracingfonts",assign_int,int_base+pdf_tracing_fonts_code);@/
@!@:pdf_tracing_fonts_}{\.{\\pdftracingfonts} primitive@>
primitive("pdfadjustinterwordglue",assign_int,int_base+pdf_adjust_interword_glue_code);@/
@!@:pdf_adjust_interword_glue_}{\.{\\pdfadjustinterwordglue} primitive@>
primitive("pdfprependkern",assign_int,int_base+pdf_prepend_kern_code);@/
@!@:pdf_prepend_kern_}{\.{\\pdfprependkern} primitive@>
primitive("pdfappendkern",assign_int,int_base+pdf_append_kern_code);@/
@!@:pdf_append_kern_}{\.{\\pdfappendkern} primitive@>
@z

@x [382] \ifincsname
var t:halfword; {token that is being ``expanded after''}
@y
var t:halfword; {token that is being ``expanded after''}
b:boolean; {keep track of nested csnames}
@z

@x [382] \ifincsname + \ifinedef
cur_order:=co_backup; link(backup_head):=backup_backup;
end;
@y
cur_order:=co_backup; link(backup_head):=backup_backup;
end;

@ @<Glob...@>=
@!is_in_csname: boolean;
@!is_in_edef: boolean;

@ @<Set init...@>=
is_in_csname := false;
is_in_edef := false;
@z

@x [388] \ifincsname
begin r:=get_avail; p:=r; {head of the list of characters}
@y
begin r:=get_avail; p:=r; {head of the list of characters}
b := is_in_csname; is_in_csname := true;
@z

@x [388] \ifincsname
if (cur_cmd<>end_cs_name) or (cur_chr<>0) then @<Complain about missing \.{\\endcsname}@>;
@y
if (cur_cmd<>end_cs_name) or (cur_chr<>0) then @<Complain about missing \.{\\endcsname}@>;
is_in_csname := b;
@z

@x [442] kbs
    tag_code: scanned_result(get_tag_code(n, k))(int_val);
@y
    tag_code: scanned_result(get_tag_code(n, k))(int_val);
    kn_bs_code_base: scanned_result(get_kn_bs_code(n, k))(int_val);
    st_bs_code_base: scanned_result(get_st_bs_code(n, k))(int_val);
    sh_bs_code_base: scanned_result(get_sh_bs_code(n, k))(int_val);
    kn_bc_code_base: scanned_result(get_kn_bc_code(n, k))(int_val);
    kn_ac_code_base: scanned_result(get_kn_ac_code(n, k))(int_val);
@z

@x [484] \pdfinsertht, \pdfximagebbox
@d pdftex_convert_codes     = pdftex_first_expand_code + 23 {end of \pdfTeX's command codes}
@y
@d pdf_insert_ht_code       = pdftex_first_expand_code + 23 {command code for \.{\\pdfinsertht}}
@d pdf_ximage_bbox_code     = pdftex_first_expand_code + 24 {command code for \.{\\pdfximagebbox}}
@d pdftex_convert_codes     = pdftex_first_expand_code + 25 {end of \pdfTeX's command codes}
@z

@x [484] \pdfinsertht, \pdfximagebbox
primitive("jobname",convert,job_name_code);@/
@!@:job_name_}{\.{\\jobname} primitive@>
@y
primitive("jobname",convert,job_name_code);@/
@!@:job_name_}{\.{\\jobname} primitive@>
primitive("pdfinsertht",convert,pdf_insert_ht_code);@/
@!@:pdf_insert_ht_}{\.{\\pdfinsertht} primitive@>
primitive("pdfximagebbox",convert,pdf_ximage_bbox_code);@/
@!@:pdf_ximage_bbox_}{\.{\\pdfximagebbox} primitive@>
@z

@x [485] \pdfinsertht, \pdfximagebbox
  othercases print_esc("jobname")
@y
  pdf_insert_ht_code: print_esc("pdfinsertht");
  pdf_ximage_bbox_code: print_esc("pdfximagebbox");
  othercases print_esc("jobname")
@z

@x [487] \pdfinsertht, \pdfximagebbox
end {there are no other cases}
@y
pdf_insert_ht_code: scan_register_num;
pdf_ximage_bbox_code: begin
    scan_int;
    pdf_check_obj(obj_type_ximage, cur_val);
    i := obj_ximage_data(cur_val);
    scan_int;
    j := cur_val;
    if (j < 1) or (j > 4) then
        pdf_error("pdfximagebbox", "invalid parameter");
end;
end {there are no other cases}
@z

@x [488] \pdfinsertht, \pdfximagebbox
job_name_code: print(job_name);
end {there are no other cases}
@y
pdf_insert_ht_code: begin
    i := qi(cur_val);
    p := page_ins_head;
    while i >= subtype(link(p)) do
        p := link(p);
    if subtype(p) = i then
        print_scaled(height(p))
    else
        print("0");
    print("pt");
end;
pdf_ximage_bbox_code: begin
    case j of
    1: print_scaled(epdf_orig_x(i));
    2: print_scaled(epdf_orig_y(i));
    3: print_scaled(epdf_orig_x(i) + image_width(i));
    4: print_scaled(epdf_orig_y(i) + image_height(i));
    endcases;
    print("pt");
end;
job_name_code: print(job_name);
end {there are no other cases}
@z

@x [514]  \ifincsname
var b:boolean; {is the condition true?}
@y
var b:boolean; {is the condition true?}
e:boolean; {keep track of nested csnames}
@z

@x [684] snapping
so we can use this field for both}
@y
so we can use this field for both}

@# {data structure of snap node}
@d snap_node_size           == 3
@d snap_glue_ptr(#)         == info(# + 1)
@d final_skip(#)            == mem[# + 2].sc {the amount to skip}
@# {data structure of snap compensation node}
@d snapy_comp_ratio(#)       == mem[# + 1].int
@z

@x [692] kbs
function expand_font_name(f: internal_font_number; e: integer): str_number;
@y
procedure set_kn_bs_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_kn_bs_base[f] = 0 then
        pdf_font_kn_bs_base[f] := init_font_base(0);
    pdf_mem[pdf_font_kn_bs_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure set_st_bs_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_st_bs_base[f] = 0 then
        pdf_font_st_bs_base[f] := init_font_base(0);
    pdf_mem[pdf_font_st_bs_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure set_sh_bs_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_sh_bs_base[f] = 0 then
        pdf_font_sh_bs_base[f] := init_font_base(0);
    pdf_mem[pdf_font_sh_bs_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure set_kn_bc_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_kn_bc_base[f] = 0 then
        pdf_font_kn_bc_base[f] := init_font_base(0);
    pdf_mem[pdf_font_kn_bc_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure set_kn_ac_code(f: internal_font_number; c: eight_bits; i: integer);
begin
    if pdf_font_kn_ac_base[f] = 0 then
        pdf_font_kn_ac_base[f] := init_font_base(0);
    pdf_mem[pdf_font_kn_ac_base[f] + c] := fix_int(i, -1000, 1000);
end;

procedure adjust_interword_glue(p, g: pointer); {adjust the interword
glue |g| after a character |p|}
var kn, st, sh: scaled;
    q: pointer;
    c: eight_bits;
    f: internal_font_number;
begin
    if not (not is_char_node(g) and type(g) = glue_node) then begin
        pdf_warning("adjust_interword_glue", "g is not a glue", false);
        return;
    end;
    if (not is_char_node(p)) and (type(p) <> ligature_node) then
        return;
    if is_char_node(p) then begin
        c := character(p);
        f := font(p);
    end
    else begin
        c := character(lig_char(p));
        f := font(lig_char(p));
    end;
    kn := get_kn_bs_code(f, c);
    st := get_st_bs_code(f, c);
    sh := get_sh_bs_code(f, c);
    if (kn <> 0) or (st <> 0) or (sh <> 0) then begin
        q := new_spec(glue_ptr(g));
        delete_glue_ref(glue_ptr(g));
        width(q) := width(q) + round_xn_over_d(quad(f), kn, 1000);
        stretch(q) := stretch(q) + round_xn_over_d(quad(f), st, 1000);
        shrink(q) := shrink(q) + round_xn_over_d(quad(f), sh, 1000);
        glue_ptr(g) := q;
    end;
end;

procedure auto_prepend_kern(p: pointer); {prepend a kern before |p| if
|p| is a charnode with non-zero |knbccode|}
var k: integer;
    q: pointer;
    c: eight_bits;
    f: internal_font_number;
begin
    if (not is_char_node(p)) and (type(p) <> ligature_node) then
        return;
    if is_char_node(p) then begin
        c := character(p);
        f := font(p);
    end
    else begin
        c := character(lig_char(p));
        f := font(lig_char(p));
    end;
    k := get_kn_bc_code(f, c);
    if k = 0 then
        return;
    q := new_kern(round_xn_over_d(quad(f), k, 1000));
    subtype(q) := auto_kern;
    tail_append(q);
end;

procedure auto_append_kern(p: pointer); {append a kern after |p| if
|p| is a charnode with non-zero |knaccode|}
var k: integer;
    q: pointer;
    c: eight_bits;
    f: internal_font_number;
begin
    breadth_max := 10;
    depth_threshold := 2;
    show_node_list(p);
    print_ln;
    if (not is_char_node(p)) and (type(p) <> ligature_node) then
        return;
    if is_char_node(p) then begin
        c := character(p);
        f := font(p);
    end
    else begin
        c := character(lig_char(p));
        f := font(lig_char(p));
    end;
    k := get_kn_ac_code(f, c);
    if k = 0 then
        return;
    q := new_kern(round_xn_over_d(quad(f), k, 1000));
    subtype(q) := auto_kern;
    tail_append(q);
end;

function expand_font_name(f: internal_font_number; e: integer): str_number;
@z

@x [692] kbs
    pdf_font_ef_base[k] := pdf_font_ef_base[f];
end;
@y
    pdf_font_ef_base[k] := pdf_font_ef_base[f];

    if pdf_font_kn_bs_base[f] = 0 then
        pdf_font_kn_bs_base[f] := init_font_base(0);
    if pdf_font_st_bs_base[f] = 0 then
        pdf_font_st_bs_base[f] := init_font_base(0);
    if pdf_font_sh_bs_base[f] = 0 then
        pdf_font_sh_bs_base[f] := init_font_base(0);
    if pdf_font_kn_bc_base[f] = 0 then
        pdf_font_kn_bc_base[f] := init_font_base(0);
    if pdf_font_kn_ac_base[f] = 0 then
        pdf_font_kn_ac_base[f] := init_font_base(0);
    pdf_font_kn_bs_base[k] := pdf_font_kn_bs_base[f];
    pdf_font_st_bs_base[k] := pdf_font_st_bs_base[f];
    pdf_font_sh_bs_base[k] := pdf_font_sh_bs_base[f];
    pdf_font_kn_bc_base[k] := pdf_font_kn_bc_base[f];
    pdf_font_kn_ac_base[k] := pdf_font_kn_ac_base[f];
end;
@z

@x [802] kbs
@!pdf_font_ef_base: ^integer; {base of font expansion factor}
@y
@!pdf_font_ef_base: ^integer; {base of font expansion factor}
@!pdf_font_kn_bs_base: ^integer; {base of kern before space}
@!pdf_font_st_bs_base: ^integer; {base of stretch before space}
@!pdf_font_sh_bs_base: ^integer; {base of shrink before space}
@!pdf_font_kn_bc_base: ^integer; {base of kern before character}
@!pdf_font_kn_ac_base: ^integer; {base of kern after character}
@z

@x [1125] snapping
@p function prune_page_top(@!p:pointer;@!s:boolean):pointer;
@y
@d discard_or_move = 60
@p function prune_page_top(@!p:pointer;@!s:boolean):pointer;
label discard_or_move;
@z

@x [1125] snapping
  whatsit_node,mark_node,ins_node: begin prev_p:=p; p:=link(prev_p);
    end;
  glue_node,kern_node,penalty_node: begin q:=p; p:=link(q); link(q):=null;
@y
  whatsit_node,mark_node,ins_node: begin 
    if (type(p) = whatsit_node) and
        ((subtype(p) = pdf_snapy_node) or 
         (subtype(p) = pdf_snapy_comp_node)) then 
      begin
        print("snap node being discarded");
        goto discard_or_move;
      end;
    prev_p:=p; p:=link(prev_p);
    end;
  glue_node,kern_node,penalty_node: begin 
discard_or_move:
    @{
    print("discard_or_move: ");
    show_node_list(p);
    print_ln;
    @}
    q:=p; p:=link(q); link(q):=null;
@z

@x [1157] snapping
whatsit_node: @<Prepare to move whatsit |p| to the current page,
  then |goto contribute|@>;
@y
whatsit_node: if (page_contents < box_there) and
                  ((subtype(p) = pdf_snapy_node) or 
                   (subtype(p) = pdf_snapy_comp_node)) then 
              begin
                  print("snap node being discarded");
                  goto done1;
              end
              else @<Prepare to move whatsit |p| to the current page, 
                     then |goto contribute|@>;
@z

@x [1187] snapping
hmode+spacer: if space_factor=1000 then goto append_normal_space
  else app_space;
@y
hmode+spacer: 
  if (space_factor = 1000) or (pdf_adjust_interword_glue > 0) then 
    goto append_normal_space
  else app_space;
@z

@x [1193] kbs
tail_append(lig_stack) {|main_loop_lookahead| is next}
@y
if pdf_prepend_kern > 0 then
    auto_prepend_kern(lig_stack);
tail_append(lig_stack);
if pdf_append_kern > 0 then
    auto_append_kern(lig_stack)
@z

@x [1198] kbs
link(tail):=temp_ptr; tail:=temp_ptr;
goto big_switch
@y
if pdf_adjust_interword_glue > 0 then
    adjust_interword_glue(tail, temp_ptr);
link(tail):=temp_ptr; tail:=temp_ptr;
goto big_switch
@z

@x [1375] \ifinedef
  e:=(cur_chr>=2); get_r_token; p:=cur_cs;
@y
  e:=(cur_chr>=2); get_r_token; p:=cur_cs;
  is_in_edef := e;
@z

@x [1375] \ifinedef
  define(p,call+(a mod 4),def_ref);
@y
  define(p,call+(a mod 4),def_ref);
  is_in_edef := false;
@z

@x [1410] kbs
    tag_code: set_tag_code(f, p, cur_val);
@y
    kn_bs_code_base: set_kn_bs_code(f, p, cur_val);
    st_bs_code_base: set_st_bs_code(f, p, cur_val);
    sh_bs_code_base: set_sh_bs_code(f, p, cur_val);
    kn_bc_code_base: set_kn_bc_code(f, p, cur_val);
    kn_ac_code_base: set_kn_ac_code(f, p, cur_val);
@z

@x [1411] kbs
primitive("tagcode",assign_font_int,tag_code);
@!@:tag_code_}{\.{\\tagcode} primitive@>
@y
primitive("tagcode",assign_font_int,tag_code);
@!@:tag_code_}{\.{\\tagcode} primitive@>
primitive("knbscode",assign_font_int,kn_bs_code_base);
@!@:kn_bs_code_}{\.{\\knbscode} primitive@>
primitive("stbscode",assign_font_int,st_bs_code_base);
@!@:st_bs_code_}{\.{\\stbscode} primitive@>
primitive("shbscode",assign_font_int,sh_bs_code_base);
@!@:sh_bs_code_}{\.{\\shbscode} primitive@>
primitive("knbccode",assign_font_int,kn_bc_code_base);
@!@:kn_bc_code_}{\.{\\knbccode} primitive@>
primitive("knaccode",assign_font_int,kn_ac_code_base);
@!@:kn_ac_code_}{\.{\\knaccode} primitive@>
@z

@x [1412] kbs
tag_code: print_esc("tagcode");
@y
tag_code: print_esc("tagcode");
kn_bs_code_base: print_esc("knbscode");
st_bs_code_base: print_esc("stbscode");
sh_bs_code_base: print_esc("shbscode");
kn_bc_code_base: print_esc("knbccode");
kn_ac_code_base: print_esc("knaccode");
@z

@x [1480] kbs
pdf_font_ef_base:=xmalloc_array(integer, font_max);
@y
pdf_font_ef_base:=xmalloc_array(integer, font_max);
pdf_font_kn_bs_base:=xmalloc_array(integer, font_max);
pdf_font_st_bs_base:=xmalloc_array(integer, font_max);
pdf_font_sh_bs_base:=xmalloc_array(integer, font_max);
pdf_font_kn_bc_base:=xmalloc_array(integer, font_max);
pdf_font_kn_ac_base:=xmalloc_array(integer, font_max);
@z

@x [1480] kbs
    pdf_font_ef_base[font_k] := 0;
@y
    pdf_font_ef_base[font_k] := 0;
    pdf_font_kn_bs_base[font_k] := 0;
    pdf_font_st_bs_base[font_k] := 0;
    pdf_font_sh_bs_base[font_k] := 0;
    pdf_font_kn_bc_base[font_k] := 0;
    pdf_font_kn_ac_base[font_k] := 0;
@z

@x [1494] kbs
pdf_font_ef_base:=xmalloc_array(integer,font_max);
@y
pdf_font_ef_base:=xmalloc_array(integer,font_max);
pdf_font_kn_bs_base:=xmalloc_array(integer, font_max);
pdf_font_st_bs_base:=xmalloc_array(integer, font_max);
pdf_font_sh_bs_base:=xmalloc_array(integer, font_max);
pdf_font_kn_bc_base:=xmalloc_array(integer, font_max);
pdf_font_kn_ac_base:=xmalloc_array(integer, font_max);
@z

@x [1494] kbs
    pdf_font_ef_base[font_k] := 0;
@y
    pdf_font_ef_base[font_k] := 0;
    pdf_font_kn_bs_base[font_k] := 0;
    pdf_font_st_bs_base[font_k] := 0;
    pdf_font_sh_bs_base[font_k] := 0;
    pdf_font_kn_bc_base[font_k] := 0;
    pdf_font_kn_ac_base[font_k] := 0;
@z

@x [1501] snapping
@d pdftex_last_extension_code  == pdftex_first_extension_code + 26
@y
@d pdf_snap_ref_point_node       == pdftex_first_extension_code + 27
@d pdf_snapy_node                == pdftex_first_extension_code + 28
@d pdf_snapy_comp_node           == pdftex_first_extension_code + 29
@d pdftex_last_extension_code    == pdftex_first_extension_code + 29
@z

@x [1501] snapping
primitive("pdfsavepos",extension,pdf_save_pos_node);@/
@!@:pdf_save_pos_}{\.{\\pdfsavepos} primitive@>
@y
primitive("pdfsavepos",extension,pdf_save_pos_node);@/
@!@:pdf_save_pos_}{\.{\\pdfsavepos} primitive@>
primitive("pdfsnaprefpoint",extension,pdf_snap_ref_point_node);@/
@!@:pdf_snap_ref_point_}{\.{\\pdfsnaprefpoint} primitive@>
primitive("pdfsnapy",extension,pdf_snapy_node);@/
@!@:pdf_snapy_}{\.{\\pdfsnapy} primitive@>
primitive("pdfsnapycomp",extension,pdf_snapy_comp_node);@/
@!@:pdf_snapy_comp_}{\.{\\pdfsnapycomp} primitive@>
@z

@x [1503] snapping
  othercases print("[unknown extension!]")
@y
  pdf_snap_ref_point_node: print_esc("pdfsnaprefpoint");
  pdf_snapy_node: print_esc("pdfsnapy");
  pdf_snapy_comp_node: print_esc("pdfsnapycomp");
  othercases print("[unknown extension!]")
@z

@x [1505] snapping
pdf_save_pos_node: @<Implement \.{\\pdfsavepos}@>;
@y
pdf_save_pos_node: @<Implement \.{\\pdfsavepos}@>;
pdf_snap_ref_point_node: @<Implement \.{\\pdfsnaprefpoint}@>;
pdf_snapy_node: @<Implement \.{\\pdfsnapy}@>;
pdf_snapy_comp_node: @<Implement \.{\\pdfsnapycomp}@>;
@z

@x [1542] snapping
@ @<Implement \.{\\pdfendthread}@>=
begin
    check_pdfoutput("\pdfendthread", true);
    new_whatsit(pdf_end_thread_node, small_node_size);
end

@ @<Glob...@>=
@!pdf_last_x_pos: integer;
@!pdf_last_y_pos: integer;
@y
@ @<Implement \.{\\pdfendthread}@>=
begin
    check_pdfoutput("\pdfendthread", true);
    new_whatsit(pdf_end_thread_node, small_node_size);
end

@ @<Glob...@>=
@!pdf_last_x_pos: integer;
@!pdf_last_y_pos: integer;
@!pdf_snapx_refpos: integer;
@!pdf_snapy_refpos: integer;
@!count_do_snapy: integer;

@ @<Set init...@>=
count_do_snapy := 0;
@z

@x [1544] snapping
@ @<Implement \.{\\pdfsavepos}@>=
@y
@ @<Implement \.{\\pdfsnaprefpoint}@>=
begin
    check_pdfoutput("\pdfsnaprefpoint", true);
    new_whatsit(pdf_snap_ref_point_node, small_node_size);
end

@ @<Declare procedures needed in |do_ext...@>=
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
    final_skip(p) := 0;
    new_snap_node := p;
end;

@ @<Implement \.{\\pdfsnapy}@>=
begin
    check_pdfoutput("\pdfsnapy", true);
    tail_append(new_snap_node(pdf_snapy_node));
end

@ @<Implement \.{\\pdfsnapycomp}@>=
begin
    check_pdfoutput("\pdfsnapycomp", true);
    new_whatsit(pdf_snapy_comp_node, small_node_size);
    scan_int;
    snapy_comp_ratio(tail) := fix_int(cur_val, 0, 1000);
end

@ @<Implement \.{\\pdfsavepos}@>=
@z

@x [1562] snapping
othercases print("whatsit?")
@y
pdf_snap_ref_point_node: print_esc("pdfsnaprefpoint");
pdf_snapy_node: begin
    print_esc("pdfsnapy");
    print_char(" ");
    print_spec(snap_glue_ptr(p), 0);
    print_char(" ");
    print_spec(final_skip(p), 0);
end;
pdf_snapy_comp_node: begin
    print_esc("pdfsnapycomp");
    print_char(" ");
    print_int(snapy_comp_ratio(p));
end;
othercases print("whatsit?")
@z

@x [1563] snapping
othercases confusion("ext2")
@y
pdf_snap_ref_point_node:
    r := get_node(small_node_size);
pdf_snapy_node: begin
    add_glue_ref(snap_glue_ptr(p));
    r := get_node(snap_node_size);
    words := snap_node_size;
end;
pdf_snapy_comp_node:
    r := get_node(small_node_size);
othercases confusion("ext2")
@z

@x [1564] snapping
othercases confusion("ext3")
@y
pdf_snap_ref_point_node:
    free_node(p, small_node_size);
pdf_snapy_node: begin
    delete_glue_ref(snap_glue_ptr(p));
    free_node(p, snap_node_size);
end;
pdf_snapy_comp_node:
    free_node(p, small_node_size);
othercases confusion("ext3")
@z

@x [1593] snapping
@ @<Output the whatsit node |p| in |pdf_vlist_out|@>=
@y
function gap_amount(p: pointer; cur_pos: scaled): scaled; {find the gap between
the position of the current snap node |p| and the nearest point on the grid}
var snap_unit, stretch_amount, shrink_amount: scaled;
    last_pos, next_pos, g, g2: scaled;
begin
    snap_unit := width(snap_glue_ptr(p));
    if stretch_order(snap_glue_ptr(p)) > normal then
        stretch_amount := max_dimen
    else
        stretch_amount := stretch(snap_glue_ptr(p));
    if shrink_order(snap_glue_ptr(p)) > normal then
        shrink_amount := max_dimen
    else
        shrink_amount := shrink(snap_glue_ptr(p));
    if subtype(p) = pdf_snapy_node then
        last_pos := pdf_snapy_refpos + 
            snap_unit * ((cur_pos - pdf_snapy_refpos) div snap_unit)
    else
        pdf_error("snapping", "invalid parameter value for gap_amount");
    next_pos := last_pos + snap_unit;
    @{
    print_nl("snap ref pos = "); print_scaled(pdf_snapy_refpos);
    print_nl("snap glue = "); print_spec(snap_glue_ptr(p), 0);
    print_nl("gap amount = "); print_scaled(snap_unit); 
    print_nl("stretch amount = "); print_scaled(stretch_amount); 
    print_nl("shrink amount = "); print_scaled(shrink_amount); 
    print_nl("last point = "); print_scaled(last_pos); 
    print_nl("cur point = "); print_scaled(cur_pos); 
    print_nl("next point = "); print_scaled(next_pos); 
    @}
    g := max_dimen;
    g2 := max_dimen;
    gap_amount := 0;
    if cur_pos - last_pos < shrink_amount then
        g := cur_pos - last_pos;
    if (next_pos - cur_pos < stretch_amount) then
        g2 := next_pos - cur_pos;
    if (g = max_dimen) and (g2 = max_dimen) then
        return; {unable to snap}
    if g2 <= g then
        gap_amount := g2 {skip forward}
    else
        gap_amount := -g; {skip backward}
end;

function get_vpos(p, q, b: pointer): pointer; {find the vertical position of
node |q| in the output PDF page; this functions is called when the current node
is |p| and current position is |cur_v| (global variable); |b| is the parent
box;}
var tmp_v: scaled;
    g_order: glue_ord; {applicable order of infinity for glue}
    g_sign: normal..shrinking; {selects type of glue}
    glue_temp: real; {glue value before rounding}
    cur_glue: real; {glue seen so far}
    cur_g: scaled; {rounded equivalent of |cur_glue| times the glue ratio}
    this_box: pointer; {pointer to containing box}
begin
    tmp_v := cur_v;
    this_box := b;
    cur_g := 0; 
    cur_glue := float_constant(0);
    g_order := glue_order(this_box);
    g_sign := glue_sign(this_box);
    while (p <> q) and (p <> null) do begin
        if is_char_node(p) then 
            confusion("get_vpos")
        else begin
            case type(p) of
            hlist_node,
            vlist_node,
            rule_node:
                tmp_v := tmp_v + height(p) + depth(p);
            whatsit_node:
                if (subtype(p) = pdf_refxform_node) or 
                   (subtype(p) = pdf_refximage_node) then
                    tmp_v := tmp_v + pdf_height(p) + pdf_depth(p);
            glue_node: begin
                @<Move down without outputting leaders@>;
                tmp_v := tmp_v + rule_ht;
            end;
            kern_node:
                tmp_v := tmp_v + width(p);
            othercases do_nothing;
            endcases;
        end;
        p := link(p);
    end;
    get_vpos := tmp_v;
end;

procedure do_snapy_comp(p, b: pointer); {do snapping compensation in vertical
direction; searchs for the next snap node and do the compensation if found}
var q: pointer;
    tmp_v, g, g2: scaled;
begin
    if not (not is_char_node(p) and 
            (type(p) = whatsit_node) and 
            (subtype(p) = pdf_snapy_comp_node)) 
    then
        pdf_error("snapping", "invalid parameter value for do_snapy_comp");
    q := p;
    while (q <> null) do begin
        if not is_char_node(q) and 
           (type(q) = whatsit_node) and 
           (subtype(q) = pdf_snapy_node)
        then begin
            tmp_v := get_vpos(p, q, b); {get the position of |q|}
            g := gap_amount(q, tmp_v); {get the gap to the grid}
            g2 := round_xn_over_d(g, snapy_comp_ratio(p), 1000); {adjustment for |p|}
            @{
            print_nl("do_snapy_comp: tmp_v = "); print_scaled(tmp_v); 
            print_nl("do_snapy_comp: cur_v = "); print_scaled(cur_v); 
            print_nl("do_snapy_comp: g = "); print_scaled(g); 
            print_nl("do_snapy_comp: g2 = "); print_scaled(g2); 
            @}
            cur_v := cur_v + g2; 
            final_skip(q) := g - g2; {adjustment for |q|}
            if final_skip(q) = 0 then
                final_skip(q) := 1; {use |1sp| as the magic value to record
                                     that |final_skip| has been set here}
            return;
        end;
        q := link(q);
    end;
end;

procedure do_snapy(p: pointer);
begin
    incr(count_do_snapy);
    @{
    print_nl("do_snapy: count = "); print_int(count_do_snapy);
    print_nl("do_snapy: cur_v = "); print_scaled(cur_v);
    print_nl("do_snapy: final skip = "); print_scaled(final_skip(p)); 
    @}
    if final_skip(p) <> 0 then
        cur_v := cur_v + final_skip(p)
    else
        cur_v := cur_v + gap_amount(p, cur_v);
    @{
    print_nl("do_snapy: cur_v after snap = "); print_scaled(cur_v);
    @}
end;

@ @<Move down without outputting leaders@>=
begin g:=glue_ptr(p); rule_ht:=width(g)-cur_g;
if g_sign<>normal then
  begin if g_sign=stretching then
    begin if stretch_order(g)=g_order then
      begin cur_glue:=cur_glue+stretch(g);
      vet_glue(float(glue_set(this_box))*cur_glue);
@^real multiplication@>
      cur_g:=round(glue_temp);
      end;
    end
  else if shrink_order(g)=g_order then
      begin cur_glue:=cur_glue-shrink(g);
      vet_glue(float(glue_set(this_box))*cur_glue);
      cur_g:=round(glue_temp);
      end;
  end;
rule_ht:=rule_ht+cur_g;
end

@ @<Output the whatsit node |p| in |pdf_vlist_out|@>=
@z


@x [1593] snapping
othercases out_what(p);
@y
pdf_snap_ref_point_node:
    @<Save current position to |pdf_snapx_refpos|, |pdf_snapy_refpos|@>;
pdf_snapy_comp_node:
    do_snapy_comp(p, this_box);
pdf_snapy_node:
    do_snapy(p);
othercases out_what(p);
@z

@x [1596] snapping
@ @<Output a Image node in a vlist@>=
@y
@ @<Save current position to |pdf_snapx_refpos|, |pdf_snapy_refpos|@>=
begin
    pdf_snapx_refpos := cur_h;
    pdf_snapy_refpos := cur_v;
end

@ @<Output a Image node in a vlist@>=
@z

@x [1598] snapping
othercases out_what(p);
@y
pdf_snap_ref_point_node:
    @<Save current position to |pdf_snapx_refpos|, |pdf_snapy_refpos|@>;
pdf_snapy_comp_node, 
pdf_snapy_node: do_nothing; {snapy nodes do nothing in hlist}
othercases out_what(p);
@z

@x [1716] \ifincsname + \ifinedef
@d if_font_char_code=19 { `\.{\\iffontchar}' }
@y
@d if_font_char_code=19 { `\.{\\iffontchar}' }
@d if_in_csname_code=20 { `\.{\\ifincsname}' }
@d if_in_edef_code=22 { `\.{\\ifinedef}' }
@z

@x [1716] \ifincsname + \ifinedef
primitive("iffontchar",if_test,if_font_char_code);
@!@:if_font_char_}{\.{\\iffontchar} primitive@>
@y
primitive("iffontchar",if_test,if_font_char_code);
@!@:if_font_char_}{\.{\\iffontchar} primitive@>
primitive("ifincsname",if_test,if_in_csname_code);
@!@:if_in_csname_}{\.{\\ifincsname} primitive@>
primitive("ifinedef",if_test,if_in_edef_code);
@!@:if_in_edef_}{\.{\\ifinedef} primitive@>
@z

@x [1718] \ifincsname + \ifinedef
if_font_char_code:print_esc("iffontchar");
@y
if_font_char_code:print_esc("iffontchar");
if_in_csname_code:print_esc("ifincsname");
if_in_edef_code:print_esc("ifinedef");
@z

@x [1721] \ifincsname
if_cs_code:begin n:=get_avail; p:=n; {head of the list of characters}
@y
if_cs_code:begin n:=get_avail; p:=n; {head of the list of characters}
e := is_in_csname; is_in_csname := true;
@z

@x [1721] \ifincsname
  b:=(eq_type(cur_cs)<>undefined_cs);
  end;
@y
  b:=(eq_type(cur_cs)<>undefined_cs);
  is_in_csname := e;
  end;
@z

@x [1723] \ifincsname + \ifinedef
if_font_char_code:begin scan_font_ident; n:=cur_val; scan_char_num;
@y
if_in_csname_code: b := is_in_csname;
if_in_edef_code: b := is_in_edef;
if_font_char_code:begin scan_font_ident; n:=cur_val; scan_char_num;
@z
