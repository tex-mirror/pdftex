@x [416]
@d pdftex_last_item_codes     = pdftex_first_rint_code + 8 {end of \pdfTeX's command codes}
@y
@d pdf_last_ximage_colordepth_code = pdftex_first_rint_code + 9 {code for \.{\\pdflastximagecolordepth}}
@d pdftex_last_item_codes     = pdftex_first_rint_code + 9 {end of \pdfTeX's command codes}
@z

@x [416]
primitive("pdflastypos",last_item,pdf_last_y_pos_code);@/
@!@:pdf_last_y_pos_}{\.{\\pdflastypos} primitive@>
@y
primitive("pdflastypos",last_item,pdf_last_y_pos_code);@/
@!@:pdf_last_y_pos_}{\.{\\pdflastypos} primitive@>
primitive("pdflastximagecolordepth",last_item,pdf_last_ximage_colordepth_code);@/
@!@:pdf_last_ximage_colordepth_}{\.{\\pdflastximagecolordepth} primitive@>
@z

@x [417]
  pdf_last_y_pos_code:  print_esc("pdflastypos");
@y
  pdf_last_y_pos_code:  print_esc("pdflastypos");
  pdf_last_ximage_colordepth_code: print_esc("pdflastximagecolordepth");
@z

@x [424]
  pdf_last_y_pos_code:  cur_val := pdf_last_y_pos;
@y
  pdf_last_y_pos_code:  cur_val := pdf_last_y_pos;
  pdf_last_ximage_colordepth_code: cur_val := pdf_last_ximage_colordepth;
@z

@x
@!pdf_last_ximage_pages: integer;
@y
@!pdf_last_ximage_pages: integer;
@!pdf_last_ximage_colordepth: integer;
@z

@x
    pdf_last_ximage_pages := image_pages(obj_ximage_data(k));
@y
    pdf_last_ximage_pages := image_pages(obj_ximage_data(k));
    pdf_last_ximage_colordepth := image_colordepth(obj_ximage_data(k));
@z

