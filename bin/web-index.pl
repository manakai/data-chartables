use strict;
use warnings;

print "{\n";

for my $file_name (sort { $a cmp $b } glob "source/web-*.txt") {
  die $file_name unless $file_name =~ m{/web-([a-z0-9_-]+)\.txt$};
  my $name = $1;

  open my $fh, '<', $file_name or die "$0: $file_name: $!";
  my @arr;
  my $max_idx = -1;

  while (my $line = <$fh>) {
    $line =~ s/^\s+//; $line =~ s/\s+$//;

    if ($line =~ /^0x([0-9A-Fa-f]{2})\tU\+([0-9A-Fa-f]{4,})(?: U\+([0-9A-Fa-f]{4,}))?$/) {
      my ($bhex, $u1hex, $u2hex) = ($1, $2, $3);
      my $byte = hex($bhex);
      my $idx = $byte;
      $idx -= 0x80 unless $name eq 'viscii' or $name eq 'vps' or $name eq 'tcvn-decode';
      my $value;
      if (defined $u2hex) {
        $value = [ hex($u1hex), hex($u2hex) ];
      } else {
        $value = hex($u1hex);
      }
      $arr[$idx] = $value;
      $max_idx = $idx if $idx > $max_idx;
    } elsif ($line =~ /\S/) {
      die "Bad line |$line|";
    }
  }

  print q{"};
  print {
    armscii8 => 'armscii-8',
    georgianacademy => "georgian-academy",
    georgianps => "georgian-ps",
    macce => "x-mac-ce",
    vni => "x-viet-vni",
    vps => "x-viet-vps",
    mns4330 => "x-mns4330",
  }->{$name} // $name;
  print q{":[};

  {
    if (defined $arr[0]) {
      if (ref $arr[0]) {
        print ",[";
        print join ",", @{$arr[0]};
        print "]";
      } else {
        print $arr[0];
      }
    } else {
      print "null";
    }
  }
  for (@arr[1..$#arr]) {
    if (defined $_) {
      if (ref $_) {
        print ",[";
        print join ",", @$_;
        print "]";
      } else {
        print ",", $_;
      }
    } else {
      print ",null";
    }
  }

  print qq{]};
  print q{,} unless $name eq "vps";
  print qq{\n};
}

print "}\n";

## License: Public Domain.
