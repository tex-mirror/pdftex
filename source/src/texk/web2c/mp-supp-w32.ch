@x
@!file_line_error_style_p:boolean; {file:line:error style messages.}
@y
@!file_line_error_style_p:boolean; {output file:line:error style errors.}
@!halt_on_error_p:boolean; {stop at first error.}
@z

@x
   ready_already:=0;
   if (history <> spotless) and (history <> warning_issued) then
@y
   ready_already:=0;
   texmf_finish_job;
   if (history <> spotless) and (history <> warning_issued) then
@z

@x
else begin print_char("."); show_context end;
@y
else begin print_char("."); show_context end;
if (halt_on_error_p) then begin
  history:=fatal_error_stop; jump_out;
end;
@z

@x
@p begin @!{|start_here|}
@y
@p begin @!{|start_here|}

  texmf_start_job;
@z
