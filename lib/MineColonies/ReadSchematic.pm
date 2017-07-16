package MineColonies::Schematic::Load;

use strict;
use warnings;

use Data::Dumper;
use File::Basename;
use Minecraft::NBTReader;
use YAML::Syck;

$Data::Dumper::Indent = 1;

{
  # Hide!
  my $method_hash = {
    author   => sub { simple( 'author',   @_ ) },
    entities => sub { simple( 'entities', @_ ) },
    version  => sub { simple( 'version',  @_ ) },
    size     => sub { simple( 'size',     @_ ) },

    dataversion      => sub { 1 },
    forgedataversion => sub { 1 },

    blocks  => \&blocks,
    palette => \&palette,

  };

  sub new {
    my ( $filename ) = @_;
    my $raw = read_file( $filename );

  }

  sub read_file {
    my ( $filename ) = @_;
    my $r            = Minecraft::NBTReader->new;
    my %d            = $r->readFile( $filename );

    my $expected_root_key = 'unnamed_0000001';

    die "unexpected root key\n"
      unless exists $d{$expected_root_key};

    return $d{$expected_root_key};

  }

  sub hut_name {
    my ( $name, $path, $suffix ) = fileparse( $filename, '.nbt' );
    $path =~ s{^.*/(\w*)/$}{$1};
    return sprintf '%s %s', $path, $name;
  }

  sub hut_details {
    my ( $hut_info ) = @_;

    my $join = sub {
      join ' x ', map { sprintf "%2d", $_ } @{ $_[0] };
    };

    my $hut_size_txt = 'Size (xyz):';
    my $hut_size_len = length $hut_size_txt;
    my $hut_size_val = $join->( $hut_info->{size} );

    #my $hut_pos_txt = 'Hut Location (xyz):';
    #my $hut_pos_len = length $hut_pos_txt;
    #my $hut_pos_val = $join->($hut_info->{hut_pos});

    #my $info_pad = $hut_size_len > $hut_pos_len ? $hut_size_len : $hut_pos_len;
    my $info_pad = $hut_size_len;

    my $hut_size = sprintf "  %${info_pad}s %s", $hut_size_txt, $hut_size_val;

    #my $hut_pos  = sprintf "  %${info_pad}s %s", $hut_pos_txt,  $hut_pos_val;

    #return "$hut_size\n$hut_pos";
    return $hut_size;

  } ## end sub hut_details

  sub hut_resources {
    my ( $hut_info ) = @_;

    my $resources;

    my @ignore = qw(
      minecraft:air
      minecolonies:blockSubstitution
      minecolonies:blockSolidSubstitution
    );

    my $max_string_len = -1;
    my $max_count_len  = -1;

    for my $type ( keys %{ $hut_info->{count} } ) {
      my $name = $hut_info->{block_types}[$type]{Name};

      next if grep { /$name/ } @ignore;
      next if $name =~ /^minecolonies:blockHut/;

      my $count  = $hut_info->{count}{$type};
      my $string = $hut_info->{block_types}[$type]{string};

      # Special cases
      if ( $string =~ /double wooden slab$/ ) {
        $string =~ s/double //;
        $resources->{$string} += $count;

      }

      $resources->{$string} += $count;

      $max_string_len = length $string
        if $max_string_len < length $string;

      $max_count_len = length $count
        if $max_count_len < length $count;

    } ## end for my $type ( keys %{ ...})

    my $hut_res_fmt = "  %${max_string_len}s: %${max_count_len}d\n";

    return ( $hut_res_fmt, $resources );

  } ## end sub hut_resources
}
