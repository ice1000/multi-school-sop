#!/usr/bin/perl

use strict;
use warnings FATAL => 'all';

system 'mkdir', '-p', 'out';

my @schools = qw/Penn Uiuc UofT/;
sub pdflatexWithPrefix {
  system 'pdflatex', '-halt-on-error', '-output-directory', 'out', $_[0] . '\input{sop.tex}';
}
sub pdflatex2 {
  my ($school) = @_;
  pdflatexWithPrefix $school;
  pdflatexWithPrefix $school;
}
sub latexDef {
  return '\def\include' . $_[0] . '{1}';
}
sub pdflatex1 {
  pdflatexWithPrefix(latexDef($_[0]));
}
sub moveFile {
  system 'cp', 'out/sop.pdf', 'sop-' . $_[0] . '.pdf';
}
sub pdflatex {
  my ($school) = @_;
  pdflatex2(latexDef($school));
  moveFile(lc $school);
}

pdflatex1 'Penn';
system 'biber out/sop';
pdflatex $_ for @schools;

# null
pdflatex2 '';
moveFile 'null';

# all
my $commonPrefix = join ' ', (map { latexDef $_ } @schools);
pdflatex2 $commonPrefix;
moveFile 'all';
