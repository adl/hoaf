#!/usr/bin/perl -w
use strict;
my %seenfiles;
undef $/;
$_ = <>;
my %svg2hoa;
my @order;

while (m{!\[automaton\]\(figures/(?<filename>[^)]*)\.svg\)\s*\n    (?<body>HOA:.*?--END--)}msg)
{
  my $name = $1;
  my $body = $2;
  $body =~ s/^    //mg;
  # Sort out repeated uses of same filename by appending a number.
  my $svg = "figures/$name.svg";
  if (exists $seenfiles{$name})
  {
      $name = "$name." . ++$seenfiles{$name};
  }
  else
  {
      push @order, $svg;
  }
  $seenfiles{$name} = 1;
  $name = "examples/$name.hoa";
  push @{$svg2hoa{$svg}}, $name;

  print "writing $name\n";
  open(OUT, '>', $name) or die("cannot open $name: $!");
  print OUT "$body\n";
  close(OUT);
}


open(OUT, '>', 'examples.html');
print(OUT <<'EOF');
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <meta http-equiv="Content-Style-Type" content="text/css" />
  <meta name="generator" content="pandoc" />
  <title></title>
  <style type="text/css">code{white-space: pre;}</style>
  <link rel="stylesheet" href="pandoc.css" type="text/css" />
</head>
<body>
<h1>HOA Examples</h1>
<p>The following examples have all been extracted from the <a href="index.html">HOA Format Specifications</a>.
You can also <a href="examples/examples.zip">download them all as a ZIP file</a>.</p>
<table class='examples'>
EOF

# Output the SVG files in the same order we discovered them.
foreach my $svg (@order)
{
    print OUT " <tr>\n  <td>";
    foreach my $hoa (@{$svg2hoa{$svg}})
    {
	print OUT "    <a href='$hoa'><code>$hoa</code></a><br/>\n";
    }
    print OUT "  </td>\n  <td><img src='$svg'></td>\n </tr>\n";
}
print OUT "</table>\n</body>\n";
close(OUT)
