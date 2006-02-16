%
% Copyright (c) 2006 Han Th\^e\llap{\raise 0.5ex\hbox{\'{}}} Th\`anh, <thanh@pdftex.org>
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
% primitive.ch 
%
% The basic idea is to copy a section of the |hash| and |eqtb| into
% new arrays |prim| and |prim_eqtb|. A dedicated function is used to 
% query these new arrays. The sneakiest bit is that the handling of
% |\primitive| needs to be inside |main_control|, because it has to
% jump back to reswitch without loading another token. For that reason,
% it has the rather strange command code |ignore_spaces|. 

@x [web sync]
@!cs_count:integer; {total number of known identifiers}
@y
@!cs_count:integer; {total number of known identifiers}
@z

@x
@ @<Set init...@>=
no_new_control_sequence:=true; {new identifiers are usually forbidden}
@y
@ Primitive support needs a few extra variables and definitions

@d prim_size=2100 {maximum number of primitives }
@d prim_prime=1777 {about 85\pct! of |primitive_size|}
@d prim_base=1 
@d prim_next(#) == prim[#].lh {link for coalesced lists}
@d prim_text(#) == prim[#].rh {string number for control sequence name}
@d prim_is_full == (prim_used=prim_base) {test if all positions are occupied}
@d prim_eq_level_field(#)==#.hh.b1
@d prim_eq_type_field(#)==#.hh.b0
@d prim_equiv_field(#)==#.hh.rh
@d prim_eq_level(#)==prim_eq_level_field(prim_eqtb[#]) {level of definition}
@d prim_eq_type(#)==prim_eq_type_field(prim_eqtb[#]) {command code for equivalent}
@d prim_equiv(#)==prim_equiv_field(prim_eqtb[#]) {equivalent value}
@d undefined_primitive=0

@<Glob...@>=
@!prim: array [0..prim_size] of two_halves;  {the primitives table}
@!prim_used:pointer; {allocation pointer for |prim|}
@!prim_eqtb:array[0..prim_size] of memory_word;

@ @<Set init...@>=
no_new_control_sequence:=true; {new identifiers are usually forbidden}
prim_next(0):=0; prim_text(0):=0;
for k:=1 to prim_size do prim[k]:=prim[0];
prim_eq_level(0) := level_zero;
prim_eq_type(0) := undefined_cs;
prim_equiv(0) := null;
for k:=1 to prim_size do prim_eqtb[k]:=prim_eqtb[0];
@z


@x
@ @<Initialize table entries...@>=
@y
@ @<Initialize table entries...@>=
prim_used:=prim_size; {nothing is used}
@z


@x
@<Compute the hash code |h|@>=
h:=buffer[j];
for k:=j+1 to j+l-1 do
  begin h:=h+h+buffer[k];
  while h>=hash_prime do h:=h-hash_prime;
  end
@y
@<Compute the hash code |h|@>=
h:=buffer[j];
for k:=j+1 to j+l-1 do
  begin h:=h+h+buffer[k];
  while h>=hash_prime do h:=h-hash_prime;
  end

@ Here is the subroutine that searches the primitive table for an identifier

@p function prim_lookup(@!s:str_number):pointer; {search the primitives table}
label found; {go here if you found it}
var h:integer; {hash code}
@!p:pointer; {index in |hash| array}
@!k:pointer; {index in string pool}
@!j,@!l:integer;
begin 
if s<256 then begin
  p := s;
  if (p<0) or (prim_eq_level(p)<>level_one) then
    p := undefined_primitive;
end
else begin
  j:=str_start[s];
  if s = str_ptr then l := cur_length else l := length(s);
  @<Compute the primitive code |h|@>;
  p:=h+prim_base; {we start searching here; note that |0<=h<hash_prime|}
  loop@+begin if prim_text(p)>0 then if length(prim_text(p))=l then
    if str_eq_str(prim_text(p),s) then goto found;
    if prim_next(p)=0 then
      begin if no_new_control_sequence then
        p:=undefined_primitive
      else @<Insert a new primitive after |p|, then make
        |p| point to it@>;
      goto found;
      end;
    p:=prim_next(p);
    end;
  end;
found: prim_lookup:=p;
end;

@ @<Insert a new primitive...@>=
begin if prim_text(p)>0 then
  begin repeat if prim_is_full then overflow("primitive size",prim_size);
@:TeX capacity exceeded primitive size}{\quad primitive size@>
  decr(prim_used);
  until prim_text(prim_used)=0; {search for an empty location in |prim|}
  prim_next(p):=prim_used; p:=prim_used;
  end;
prim_text(p):=s;
end

@ The value of |prim_prime| should be roughly 85\pct! of
|prim_size|, and it should be a prime number. 

@<Compute the primitive code |h|@>=
h:=str_pool[j];
for k:=j+1 to j+l-1 do
  begin h:=h+h+str_pool[k];
  while h>=prim_prime do h:=h-prim_prime;
  end

@z

@x
begin if s<256 then cur_val:=s+single_base
@y
@!prim_val:integer; {needed to fill |prim_eqtb|}
begin if s<256 then begin 
  cur_val:=s+single_base;
  prim_val:=s;
end
@z

@x
  flush_string; text(cur_val):=s; {we don't want to have the string twice}
  end;
eq_level(cur_val):=level_one; eq_type(cur_val):=c; equiv(cur_val):=o;
end;
@y
  flush_string; text(cur_val):=s; {we don't want to have the string twice}
  prim_val:=prim_lookup(s); 
  end;
eq_level(cur_val):=level_one; eq_type(cur_val):=c; equiv(cur_val):=o;
prim_eq_level(prim_val):=level_one; 
prim_eq_type(prim_val):=c; 
prim_equiv(prim_val):=o;
end;
@z


% now for the |\primitive| primitive

@x l.6135
primitive("ignorespaces",ignore_spaces,0);@/
@!@:ignore_spaces_}{\.{\\ignorespaces} primitive@>
@y
primitive("ignorespaces",ignore_spaces,0);@/
@!@:ignore_spaces_}{\.{\\ignorespaces} primitive@>
primitive("primitive",ignore_spaces,1);@/
@!@:primitive_}{\.{\\primitive} primitive@>
@z

@x l.6213
ignore_spaces: print_esc("ignorespaces");
@y
ignore_spaces: if chr_code=0 then print_esc("ignorespaces") else print_esc("primitive");
@z


@x l.10443
@d if_case_code=16 { `\.{\\ifcase}' }
@y
@d if_case_code=16 { `\.{\\ifcase}' }
@d if_primitive_code=21 { `\.{\\ifprimitive}' }
@z

@x l. 10478
primitive("ifcase",if_test,if_case_code);
@!@:if_case_}{\.{\\ifcase} primitive@>
@y
primitive("ifcase",if_test,if_case_code);
@!@:if_case_}{\.{\\ifcase} primitive@>
primitive("ifprimitive",if_test,if_primitive_code);
@!@:if_primitive_}{\.{\\ifprimitive} primitive@>
@z

@x l.10499
  if_case_code:print_esc("ifcase");
@y
  if_case_code:print_esc("ifcase");
  if_primitive_code:print_esc("ifprimitive");
@z

@x l.10602
if_case_code: @<Select the appropriate case
  and |return| or |goto common_ending|@>;
@y
if_case_code: @<Select the appropriate case
  and |return| or |goto common_ending|@>;
if_primitive_code: begin
  save_scanner_status:=scanner_status;
  scanner_status:=normal;
  get_next;
  scanner_status:=save_scanner_status;
  if cur_cs < hash_base then
    m := prim_lookup(cur_cs-257)
  else
    m := prim_lookup(text(cur_cs));
  b :=((cur_cmd<>undefined_cs) and 
       (m<>undefined_primitive) and
       (cur_cmd=prim_eq_type(m)) and 
       (cur_chr=prim_equiv(m)));
  end;
@z

@x l. 26403
any_mode(ignore_spaces): begin @<Get the next non-blank non-call...@>;
  goto reswitch;
  end;
@y
any_mode(ignore_spaces): begin 
  if cur_chr = 0 then begin
    @<Get the next non-blank non-call...@>;
    goto reswitch;
  end
  else begin
    t:=scanner_status;
    scanner_status:=normal; 
    get_next; 
    scanner_status:=t;
    if cur_cs < hash_base then
      cur_cs := prim_lookup(cur_cs-257)
    else
      cur_cs  := prim_lookup(text(cur_cs));
    if cur_cs<>undefined_primitive then begin
      cur_cmd := prim_eq_type(cur_cs);
      cur_chr := prim_equiv(cur_cs);
      goto reswitch;
      end;
    end;
  end;
@z

@x l.30182
@<Dump the hash table@>=
@y
@<Dump the hash table@>=
for p:=0 to prim_size do dump_hh(prim[p]);
for p:=0 to prim_size do dump_wd(prim_eqtb[p]);
@z

@x
@ @<Undump the hash table@>=
@y
@ @<Undump the hash table@>=
for p:=0 to prim_size do undump_hh(prim[p]);
for p:=0 to prim_size do undump_wd(prim_eqtb[p]);
@z

