@ Here is a really small patch to add a new primitive called
\.{\\quitvmode}. In vertical modes, it is identical to \.{\\indent},
but in horizontal and math modes it is really a no-op (as opposed to
\.{\\indent}, which executes the |indent_in_hmode| procedure). 


@x [1088]
@ A paragraph begins when horizontal-mode material occurs in vertical mode,
or when the paragraph is explicitly started by `\.{\\indent}' or
`\.{\\noindent}'.

@<Put each...@>=
primitive("indent",start_par,1);
@!@:indent_}{\.{\\indent} primitive@>
primitive("noindent",start_par,0);
@!@:no_indent_}{\.{\\noindent} primitive@>
@y
@ A paragraph begins when horizontal-mode material occurs in vertical mode,
or when the paragraph is explicitly started by `\.{\\quitvmode}', 
`\.{\\indent}' or `\.{\\noindent}'.

@<Put each...@>=
primitive("indent",start_par,1);
@!@:indent_}{\.{\\indent} primitive@>
primitive("noindent",start_par,0);
@!@:no_indent_}{\.{\\noindent} primitive@>
primitive("quitvmode",start_par,2);
@!@:quit_vmode_}{\.{\\quitvmode} primitive@>
@z

@x [1089]
start_par: if chr_code=0 then print_esc("noindent")@+ else print_esc("indent");
@y
start_par: if chr_code=0 then print_esc("noindent")@+ else if chr_code=1 then print_esc("indent")@+ else print_esc("quitvmode");
@z

@x [1092]
hmode+start_par,mmode+start_par: indent_in_hmode;
@y
hmode+start_par,mmode+start_par: if cur_chr<>2 then indent_in_hmode;
@z
