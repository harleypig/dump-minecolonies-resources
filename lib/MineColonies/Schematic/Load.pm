package MineColonies::Schematic::Load;

use strict;
use warnings;

use Minecraft::NBTReader;

sub read_file {
  my ( $filename ) = @_;
  my $r            = Minecraft::NBTReader->new;
  my %d            = $r->readFile( $filename );

  my $expected_root_key = 'unnamed_0000001';

  die "unexpected root key\n"
    unless exists $d{$expected_root_key};

  return $d{$expected_root_key};

}

1;
