@x [468]
@d pdf_page_ref_code        = pdftex_first_expand_code + 5 {command code for \.{\\pdfpageref}}
@d pdftex_convert_codes     = pdftex_first_expand_code + 6 {end of \pdfTeX's command codes}
@y
@d pdf_page_ref_code        = pdftex_first_expand_code + 5 {command code for \.{\\pdfpageref}}
@d pdf_last_escaped_string_code = pdftex_first_expand_code + 6 {command code for \.{\\pdflastescapedstring}}
@d pdftex_convert_codes     = pdftex_first_expand_code + 7 {end of \pdfTeX's command codes}
@z

@x [468]
primitive("pdfpageref",convert,pdf_page_ref_code);@/
@!@:pdf_page_ref_}{\.{\\pdfpageref} primitive@>
@y
primitive("pdfpageref",convert,pdf_page_ref_code);@/
@!@:pdf_page_ref_}{\.{\\pdfpageref} primitive@>
primitive("pdflastescapedstring",convert,pdf_last_escaped_string_code);@/
@!@:pdf_last_escaped_string_}{\.{\\pdflastescapedstring} primitive@>
@z

@x [469]
  pdf_page_ref_code:    print_esc("pdfpageref");
@y
  pdf_page_ref_code:    print_esc("pdfpageref");
  pdf_last_escaped_string_code:    print_esc("pdflastescapedstring");
@z

@x [465]
@!b:pool_pointer; {base of temporary string}
@y
@!b:pool_pointer; {base of temporary string}
@!i, l: integer; {index to access escaped string}
@z

@x [471]
pdf_page_ref_code: begin
    scan_int;
    if cur_val <= 0 then
        pdf_error("pageref", "invalid page number");
end;
@y
pdf_page_ref_code: begin
    scan_int;
    if cur_val <= 0 then
        pdf_error("pageref", "invalid page number");
end;
pdf_escape_string_code: do_nothing;
@z

@x [472]
pdf_page_ref_code: print_int(get_obj(obj_type_page, cur_val, false));
@y
pdf_page_ref_code: print_int(get_obj(obj_type_page, cur_val, false));
pdf_last_escaped_string_code: begin
    l := escapedstrlen;
    for i := 0 to l - 1 do
        print_char(getescapedchar(i));
end;
@z

@x [1344]
@d pdftex_last_extension_code  == pdftex_first_extension_code + 25
@y
@d pdf_escape_string_code      == pdftex_first_extension_code + 26
@d pdftex_last_extension_code  == pdftex_first_extension_code + 26
@z

@x [1344]
primitive("pdfliteral",extension,pdf_literal_node);@/
@!@:pdf_literal_}{\.{\\pdfliteral} primitive@>
@y
primitive("pdfliteral",extension,pdf_literal_node);@/
@!@:pdf_literal_}{\.{\\pdfliteral} primitive@>
primitive("pdfescapestring",extension,pdf_escape_string_code);@/
@!@:pdf_escape_string_}{\.{\\pdfescapestring} primitive@>
@z


@x [1348]
pdf_literal_node: @<Implement \.{\\pdfliteral}@>;
@y
pdf_literal_node: @<Implement \.{\\pdfliteral}@>;
pdf_escape_string_code: @<Implement \.{\\pdfescapestring}@>;
@z

@x [1354]
@ @<Implement \.{\\pdfliteral}@>=
@y
@ @<Implement \.{\\pdfescapestring}@>=
begin
    scan_pdf_ext_toks;
    escapestr(tokens_to_string(def_ref));
    flush_str(last_tokens_string);
    delete_token_ref(def_ref);
end

@ @<Implement \.{\\pdfliteral}@>=
@z
