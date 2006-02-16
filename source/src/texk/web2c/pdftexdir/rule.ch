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
%$Id: rule.ch,v 1.12 2005/12/23 23:09:31 hahe Exp hahe $
%
% rule in a group
%
%***********************************************************************

@x 15882
    pdf_last_v := pdf_origin_v;
end;
@y
    pdf_last_v := pdf_origin_v;
end;

procedure pdf_set_origin_temp(h, v: scaled); {set the origin to |h|, |v| inside group}
begin
    if (abs(h - pdf_origin_h) >= min_bp_val) or
        (abs(v - pdf_origin_v) >= min_bp_val) then begin
        pdf_print("1 0 0 1 ");
        pdf_print_bp(h - pdf_origin_h);
        pdf_out(" ");
        pdf_print_bp(pdf_origin_v - v);
        pdf_print_ln(" cm");
    end;
end;
@z

%***********************************************************************

@x 16045
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

@y
procedure pdf_set_rule(x, y, w, h: scaled); {draw a rule}
begin
    pdf_end_text;
    pdf_print_ln("q");
    if h <= one_bp then begin
        pdf_set_origin_temp(cur_h, cur_v - (h + 1)/2);
        pdf_print("[]0 d 0 J ");
        pdf_print_bp(h); pdf_print(" w 0 0 m ");
        pdf_print_bp(w); pdf_print_ln(" 0 l S");
    end
    else if w <= one_bp then begin
        pdf_set_origin_temp(cur_h + (w + 1)/2, cur_v);
        pdf_print("[]0 d 0 J ");
        pdf_print_bp(w); pdf_print(" w 0 0 m 0 ");
        pdf_print_bp(h); pdf_print_ln(" l S");
    end
    else begin
        pdf_set_origin_temp(cur_h, cur_v);
        pdf_print("0 0 ");
        pdf_print_bp(w); pdf_out(" ");
        pdf_print_bp(h); pdf_print_ln(" re f");
    end;
    pdf_print_ln("Q");
end;
@z

%***********************************************************************
