% Copyright (c) 2005 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
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
% $Id: //depot/Build/source.development/TeX/texk/web2c/pdftexdir/pdftex.ch#163 $
%
% patch to grow pdf_mem dynamically (pdf_mem_size from texmf.cnf is ignored).
% patch must come after tex.pch!
%
% Further required changes:
%
% 1. to cpascal.h add this line after the one with xmallocarray:
% #define xreallocarray(ptr,type,size) ((type*)xrealloc(ptr,(size+1)*sizeof(type)))
%
% 2. to common.defines add this line after the one with xmallocarray:
% @define function xreallocarray ();

%***********************************************************************

@x
@!inf_pdf_mem_size = 32000; {min size of the |pdf_mem| array}
@!sup_pdf_mem_size = 524288; {max size of the |pdf_mem| array}
@y
@!inf_pdf_mem_size = 10000; {min size of the |pdf_mem| array}
@!sup_pdf_mem_size = 10000000; {max size of the |pdf_mem| array}
@z

%***********************************************************************

@x
pdf_mem_ptr := 1; {the first word is not used so we can use zero as a value for testing
whether a pointer to |pdf_mem| is valid}
@y
pdf_mem_ptr := 1; {the first word is not used so we can use zero as a value for testing
whether a pointer to |pdf_mem| is valid}
pdf_mem_size := inf_pdf_mem_size; {allocated size of |pdf_mem| array}
@z

%***********************************************************************

@x
@p function pdf_get_mem(s: integer): integer; {allocate |s| words in
|pdf_mem|}
begin
    if pdf_mem_ptr + s > pdf_mem_size then
        overflow("PDF memory size (pdf_mem_size)", pdf_mem_size);
    pdf_get_mem := pdf_mem_ptr;
    pdf_mem_ptr := pdf_mem_ptr + s;
end;
@y
@p function pdf_get_mem(s: integer): integer; {allocate |s| words in |pdf_mem|}
var a: integer;
begin
  if s > sup_pdf_mem_size - pdf_mem_size then
      overflow("PDF memory size (pdf_mem_size)", pdf_mem_size);
  if pdf_mem_ptr + s > pdf_mem_size then begin
    a := 0.2 * pdf_mem_size;
    if pdf_mem_ptr + s > pdf_mem_size + a then
        pdf_mem_size := pdf_mem_ptr + s
    else if pdf_mem_size < sup_pdf_mem_size - a then
        pdf_mem_size := pdf_mem_size + a
    else
        pdf_mem_size := sup_pdf_mem_size;
    pdf_mem := xrealloc_array(pdf_mem, integer, pdf_mem_size);
  end;
  pdf_get_mem := pdf_mem_ptr;
  pdf_mem_ptr := pdf_mem_ptr + s;
end;
@z

%***********************************************************************

@x
  setup_bound_var (65536)('pdf_mem_size')(pdf_mem_size);
@y
@z

%***********************************************************************

@x
  pdf_mem:=xmalloc_array (integer, pdf_mem_size);
@y
  pdf_mem:=xmalloc_array (integer, inf_pdf_mem_size); {will grow dynamically}
@z

%***********************************************************************
