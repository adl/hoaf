#!/usr/bin/perl -w
use strict;
my %seenfiles;
undef $/;
$_ = <>;

while (m{!\[automaton\]\(figures/(?<filename>[^)]*)\.svg\)\s*\n    (?<body>HOA:.*?--END--)}msg)
{
  my $name = $1;
  my $body = $2;
  $body =~ s/^    //mg;
  # Sort out repeated uses of same filename by appending a number.
  $name = "$name." . ++$seenfiles{$name} if exists $seenfiles{$name};
  $seenfiles{$name} = 1;
  $name = "examples/$name.hoa";

  print "writing $name\n";
  open(OUT, '>', $name) or die("cannot open $name: $!");
  print OUT "$body\n";
  close(OUT);
}
