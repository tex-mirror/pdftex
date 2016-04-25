#!/usr/bin/env perl
# $Id$
# Public domain.  Originally written by Karl Berry, 2016.
# Read pdftex-t.tex, generate pdftex-syntax.tex
# by looking for the primitive descriptions.

use warnings;

sub main {
  my %primitive = &read_manual_for_primitives ();

  # group primitives into classes based on their \Whatever construct.
  my %class;
  for my $p (sort keys %primitive) {
    my ($class) = $primitive{$p} =~ /\\Whatever *\{(.*?)\}/;
    # general commands don't have a \Whatever.
    $class = "general" if ! $class;
    
    # append this primitive, comma-separated.
    $class{$class} .= "$p,"
  }
  
  print <<END_HEADER;
%%S $Id$
%%S This is the list of new or extended primitives provided by pdftex.
%%S Don't edit this file, as it is now auto-generated from the
%%S pdfTeX manual source pdftex-t.tex (and the generated
%%S pdftex-syntax.tex) by the script syntaxform.awk.
%%S Syntax rule conventions borrowed from `TeXbook naruby' by Petr Olsak.
END_HEADER
  &print_by_class (\%class, \%primitive);
  return 0;
}

{
  # classes should be shown in a specific order,
  # and have specific text for the headings.
  # sorry for using an array.
  my %class_info = (
    "integer"            => [1, "Integer registers"],
    "read||only integer" => [2, "Read-only integers"],
    "dimen"              => [3, "Dimen registers"],
    "tokens"             => [4, "Token registers"],
    "expandable"         => [5, "Expandable commands"],
    "general"            => [6, "General commands"],
  );

sub print_by_class {
  my ($class_ref,$primitive_ref) = @_;
  my %class = %$class_ref;  
  
  for my $c (sort by_class keys %class) {
  my $aref = $class_info{$c};
    my $heading_name = $class_info{$c}->[1];
    # the %%S lines are for syntaxform.awk
    print <<END_START_CLASS;
%%S NL
%%S $heading_name:
\\subsubject{$heading_name}

\\startpacked
END_START_CLASS

    # extract list of primitives for this class.
    my @prims = split (/,/, $class{$c});
    for my $p (@prims) {
      my $val = $primitive_ref->{$p};
      
      # get rid of the \pdftexprimitive{ and trailing }
      $val =~ s,^\\pdftexprimitive *\{,,;
      $val =~ s, *\} *$,,;
      
      # leading \Syntax and trailing } on their own lines for syntaxform.awk.
      $val =~ s,^ *\\Syntax *\{,\\Syntax\{\n,;
      $val =~ s, *\} *$,\n\},;
      
      # collapse multiple spaces
      $val =~ s,  +, ,g;
      
      print "\n$val\n";
    }
    print "\n\\stoppacked\n";
  }
}

sub by_class { $class_info{$a}->[0] <=> $class_info{$b}->[0]; }

} # end block for %class_info


# read <> for \pdftexprimitive blocks.  Return hash with keys being the
# primitive name (including the leading \) and values the entire block,
# without newlines.
# 
sub read_manual_for_primitives {
  my $printing = 0;
  my $primitive = "";

  while (<>) {
    # \pdftexprimitive block ends at next unindented blank or \... line.
    $printing = 0 if /^($|\\)/;
    if (/^\\pdftexprimitive/) {
      $printing = 1;
      
      my $type;
      # \tex is used for primitives specified without a leading \.
      ($type,$primitive) = m/\\([Tt])ex *\{(.*?)\}/;
      warn "$ARGV:$.: no primitive found in: $_" if (! $primitive);
      $primitive = "\\$primitive" if $type eq "t";
      
      # \pdfmovechars is still in the manual, but doesn't do anything.
      # Omit it from the output.
      next if $primitive eq "\\pdfmovechars";
      
      # Just one case, \special, has multiple instances of \pdftexprimitive.
      # kludge by appending spaces to the name to make it unique;
      # we later reduce multiple spaces to one, so it's not visible.
      $primitive .= " " until ! exists $primitive{$primitive};
    }

    if ($printing) {
      # concatenate lines of definition; assume spacing is reasonable.
      chomp;
      $primitive{$primitive} .= $_;
    }
  }
  
  return %primitive;
}

exit (&main ());
