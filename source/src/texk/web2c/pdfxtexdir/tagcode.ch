@ This change file creates an extra primitive named \.{\\tagcode}, allowing
read and write access to a character's |char_tag| info. The associated internal
command is |assign_font_int|, with the new modifier value |tag_code|.

The only write operation that is (currently) performed is clearing the value of
the |char_tag|, so it is more like `read/delete' access. The operation is done 
by substracting a value based on the user's input, using the following rules:

\item If the character doesn't exist, return immediately.
\item If the user's input is less than -7, it is first changed to -7. 
\item If the supplied input is positive, it is converted to 0. 
\item If the input is -4 or less, |ext_tag| will be cleared,
	and the input is increased by 4.
\item If the input is now -3 or -2, |list_tag| will be 
	cleared, and the input is increased by 2.
\item If the input is still negative (-1), |lig_tag| will be cleared.

Nothing other than the |char_tag| value is changed, and nothing is saved. 
The primitive works directly on |font_info|, so all changes are \.{\\global},
the same as for the other font assignment primitives.

If the character doesn't exist, the read operation returns
-1. Otherwise, the return value is the 4 if |ext_tag| was set, 2 if
|list_tag| was set, 1 if |lig_tag| was set, or 0 if the tag value was
|no_tag|.  The return values are chosen in such a way as to be
consistent with the absolute value of the assignment argument.

Released to the public domain by the author, Taco Hoekwater

@x [230]
@d ef_code_base == 4
@y
@d ef_code_base == 4
@d tag_code == 5
@z

@x [230]
    ef_code_base: scanned_result(get_ef_code(n, k))(int_val);
@y
    ef_code_base: scanned_result(get_ef_code(n, k))(int_val);
    tag_code: scanned_result(get_tag_code(n, k))(int_val);
@z

@x [577]
@<Declare procedures that scan font-related stuff@>=
procedure scan_font_ident;
@y
@<Declare procedures that scan font-related stuff@>=
function get_tag_code(f: internal_font_number; c: eight_bits): integer;
var i:small_number;
begin
	if (c>=font_bc[f]) and (c<=font_ec[f]) and (char_exists(char_info(f)(c))) then
      begin i := char_tag(char_info(f)(c));
      if i = lig_tag then
        get_tag_code := 1
	  else if i = list_tag then
        get_tag_code := 2
	  else if i = ext_tag then
        get_tag_code := 4
	  else
	    get_tag_code := 0;
      end
   else
       get_tag_code := -1;
end;
procedure scan_font_ident;
@z

@x [???]
function init_font_base(v: integer): integer;
@y
procedure set_tag_code(f: internal_font_number; c: eight_bits; i: integer);
var fixedi:integer;
begin
  if (c>=font_bc[f]) and (c<=font_ec[f]) and (char_exists(char_info(f)(c))) then
    begin fixedi := abs(fix_int(i,-7,0));
      if fixedi >= 4 then begin
          if char_tag(char_info(f)(c)) = ext_tag then
          op_byte(char_info(f)(c)) := (op_byte(char_info(f)(c))) - ext_tag;
        fixedi := fixedi - 4;
      end;
      if fixedi >= 2 then begin
        if char_tag(char_info(f)(c)) = list_tag then
          op_byte(char_info(f)(c)) := (op_byte(char_info(f)(c))) - list_tag;
        fixedi := fixedi - 2;
      end;
      if fixedi >= 1 then begin
        if char_tag(char_info(f)(c)) = lig_tag then
          op_byte(char_info(f)(c)) := (op_byte(char_info(f)(c))) - lig_tag;
    end;
  end;
end;

function init_font_base(v: integer): integer;
@z

@x [1253]
    ef_code_base: set_ef_code(f, p, cur_val);
@y
    ef_code_base: set_ef_code(f, p, cur_val);
    tag_code: set_tag_code(f, p, cur_val);
@z

@x [1254]
primitive("efcode",assign_font_int,ef_code_base);
@!@:ef_code_}{\.{\\efcode} primitive@>
@y
primitive("efcode",assign_font_int,ef_code_base);
@!@:ef_code_}{\.{\\efcode} primitive@>
primitive("tagcode",assign_font_int,tag_code);
@!@:tag_code_}{\.{\\tagcode} primitive@>
@z

@x [1255]
ef_code_base: print_esc("efcode");
@y
ef_code_base: print_esc("efcode");
tag_code: print_esc("tagcode");
@z
