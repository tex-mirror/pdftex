%
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
%***********************************************************************
% $Id: pkdpi.ch,v 1.16 2005/12/05 20:35:00 hahe Exp hahe $
%
% take PK resolution from "pk_dpi" parameter in texmf.cnf,
% if it has not been set by the format file or by the user.
%
%***********************************************************************

@x 16307
@!sup_dest_names_size = 131072; {max size of the destination names table for PDF output}
@y
@!sup_dest_names_size = 131072; {max size of the destination names table for PDF output}
@!inf_pk_dpi = 72; {min PK pixel density value from \.{texmf.cnf}}
@!sup_pk_dpi = 8000; {max PK pixel density value from \.{texmf.cnf}}
@z

%***********************************************************************

@x 18742
fixed_pk_resolution := fix_int(pdf_pk_resolution, 72, 2400);
@y
if pdf_pk_resolution = 0 then {if not set from format file or by user}
    pdf_pk_resolution := pk_dpi; {take it from \.{texmf.cnf}}
fixed_pk_resolution := fix_int(pdf_pk_resolution, 72, 8000);
@z

%***********************************************************************

@x 32322
  setup_bound_var (0)('hash_extra')(hash_extra);
@y
  setup_bound_var (0)('hash_extra')(hash_extra);
  setup_bound_var (72)('pk_dpi')(pk_dpi);
@z

%***********************************************************************

@x 32356
  const_chk (dest_names_size);
@y
  const_chk (dest_names_size);
  const_chk (pk_dpi);
@z

%***********************************************************************

@x 35005
@!dest_names: ^dest_name_entry;
@y
@!dest_names: ^dest_name_entry;
@!pk_dpi: integer; {PK pixel density value from \.{texmf.cnf}}
@z

%***********************************************************************
