
@x [247]
@d pdftex_last_dimen_code  = pdftex_first_dimen_code + 6 {last number defined in this section}
@y
@d pdf_first_line_height_code = pdftex_first_dimen_code + 7
@d pdf_last_line_depth_code   = pdftex_first_dimen_code + 8
@d pdf_each_line_height_code  = pdftex_first_dimen_code + 9
@d pdf_each_line_depth_code   = pdftex_first_dimen_code + 10
@d pdftex_last_dimen_code     = pdftex_first_dimen_code + 10 {last number defined in this section}
@z

@x [247]
@d pdf_thread_margin == dimen_par(pdf_thread_margin_code)
@y
@d pdf_thread_margin == dimen_par(pdf_thread_margin_code)
@d pdf_first_line_height == dimen_par(pdf_first_line_height_code)
@d pdf_last_line_depth   == dimen_par(pdf_last_line_depth_code)
@d pdf_each_line_height  == dimen_par(pdf_each_line_height_code)
@d pdf_each_line_depth   == dimen_par(pdf_each_line_depth_code)
@z

@x [247]
pdf_thread_margin_code: print_esc("pdfthreadmargin");
@y
pdf_thread_margin_code: print_esc("pdfthreadmargin");
pdf_first_line_height_code: print_esc("pdffirstlineheight");
pdf_last_line_depth_code: print_esc("pdflastlinedepth");
pdf_each_line_height_code: print_esc("pdfeachlineheight");
pdf_each_line_depth_code: print_esc("pdfeachlinedepth");
@z


@x [248]
primitive("pdfthreadmargin",assign_dimen,dimen_base+pdf_thread_margin_code);@/
@!@:pdf_thread_margin_}{\.{\\pdfthreadmargin} primitive@>
@y
primitive("pdfthreadmargin",assign_dimen,dimen_base+pdf_thread_margin_code);@/
@!@:pdf_thread_margin_}{\.{\\pdfthreadmargin} primitive@>
primitive("pdffirstlineheight",assign_dimen,dimen_base+pdf_first_line_height_code);@/
@!@:pdf_first_line_height_}{\.{\\pdffirstlineheight} primitive@>
primitive("pdflastlinedepth",assign_dimen,dimen_base+pdf_last_line_depth_code);@/
@!@:pdf_last_line_depth_}{\.{\\pdflastlinedepth} primitive@>
primitive("pdfeachlineheight",assign_dimen,dimen_base+pdf_each_line_height_code);@/
@!@:pdf_each_line_height_}{\.{\\pdfeachlineheight} primitive@>
primitive("pdfeachlinedepth",assign_dimen,dimen_base+pdf_each_line_depth_code);@/
@!@:pdf_each_line_depth_}{\.{\\pdfeachlinedepth} primitive@>
@z

@x [888]
append_to_vlist(just_box);
@y
if pdf_each_line_height <> 0 then
    height(just_box) := pdf_each_line_height;
if pdf_each_line_depth <> 0 then
    depth(just_box) := pdf_each_line_depth;
if (pdf_first_line_height <> 0) and (cur_line = prev_graf + 1) then
    height(just_box) := pdf_first_line_height;
if (pdf_last_line_depth <> 0) and (cur_line + 1 = best_line) then
    depth(just_box) := pdf_last_line_depth;
append_to_vlist(just_box);
@z
