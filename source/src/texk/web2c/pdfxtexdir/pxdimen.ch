% WEB change file containing the \pdfpxdimen extension for pdfTeX
%
% Copyright (c) 2004 Taco Hoekwater, <taco@aanhet.net>
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
% $Id $

@x [236]
@d pdf_protrude_chars_code   = pdftex_first_integer_code + 11 {protrude chars at left/right edge of paragraphs}
@d pdf_int_pars=pdftex_first_integer_code + 12 {total number of \pdfTeX's integer parameters}
@y
@d pdf_protrude_chars_code   = pdftex_first_integer_code + 11 {protrude chars at left/right edge of paragraphs}
@d pdf_px_dimen_code = pdftex_first_integer_code + 12 {the code for the pixel dimen value}
@d pdf_int_pars=pdftex_first_integer_code + 13 {total number of \pdfTeX's integer parameters}
@z

@x [236]
@d pdf_option_pdf_inclusion_errorlevel == int_par(pdf_option_pdf_inclusion_errorlevel_code)
@y
@d pdf_option_pdf_inclusion_errorlevel == int_par(pdf_option_pdf_inclusion_errorlevel_code)
@d pdf_px_dimen == int_par(pdf_px_dimen_code)
@z

@x [237]
pdf_option_pdf_inclusion_errorlevel_code: print_esc("pdfoptionpdfinclusionerrorlevel");
@y
pdf_option_pdf_inclusion_errorlevel_code: print_esc("pdfoptionpdfinclusionerrorlevel");
pdf_px_dimen_code: print_esc("pdfpxdimen");
@z

@x [238]
primitive("pdfoptionpdfinclusionerrorlevel",assign_int,int_base+pdf_option_pdf_inclusion_errorlevel_code);@/
@!@:pdf_option_pdf_inclusion_errorlevel_}{\.{\\pdfoptionpdfinclusionerrorlevel} primitive@>
@y
primitive("pdfoptionpdfinclusionerrorlevel",assign_int,int_base+pdf_option_pdf_inclusion_errorlevel_code);@/
@!@:pdf_option_pdf_inclusion_errorlevel_}{\.{\\pdfoptionpdfinclusionerrorlevel} primitive@>
primitive("pdfpxdimen",assign_int,int_base+pdf_px_dimen_code);@/
@!@:pdf_px_dimen_}{\.{\\pdfpxdimen} primitive@>
@z

@x [240]
for k:=int_base to del_code_base-1 do eqtb[k].int:=0;
@y
for k:=int_base to del_code_base-1 do eqtb[k].int:=0;
pdf_px_dimen := unity;
@z

@x [455]
else if scan_keyword("ex") then v:=(@<The x-height for |cur_font|@>)
@.ex@>
@y
else if scan_keyword("ex") then v:=(@<The x-height for |cur_font|@>)
@.ex@>
else if scan_keyword("px") then v:=pdf_px_dimen
@.px@>
@z

