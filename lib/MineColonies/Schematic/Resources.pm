package MineColonies::Schematic::Resources;

use strict;
use warnings;

use File::Basename;

sub dump_required_resources {
  my ( $hut_info, $filename ) = @_;

  my $hut_name    = hut_name($filename);
  my $hut_details = hut_details( $hut_info );
  #my $hut_outline = hut_outline( $hut_info );

  my ( $res_fmt, $resources ) = hut_resources( $hut_info );

  my $ot = $hut_info->{output_type} || die "output_type not set";
  $ot = "output_type_$ot";

  no strict 'refs';
  &$ot($hut_name, $hut_details, $res_fmt, $resources);

}

sub hut_name {
  my ( $filename ) = @_;
  my ( $name, $path, $suffix ) = fileparse($filename, '.nbt');
  $path =~ s{^.*/(\w*)/$}{$1};
  return sprintf '%s %s', $path, $name;
}

sub hut_details {
  my ( $hut_info ) = @_;

  my $join = sub { join ' x ', map { sprintf "%2d", $_ } @{$_[0]} };

  my $hut_size_txt = 'Size (xyz):';
  my $hut_size_len = length $hut_size_txt;
  my $hut_size_val = $join->($hut_info->{size});

  #my $hut_pos_txt = 'Hut Location (xyz):';
  #my $hut_pos_len = length $hut_pos_txt;
  #my $hut_pos_val = $join->($hut_info->{hut_pos});

  #my $info_pad = $hut_size_len > $hut_pos_len ? $hut_size_len : $hut_pos_len;
  my $info_pad = $hut_size_len;

  my $hut_size = sprintf "  %${info_pad}s %s", $hut_size_txt, $hut_size_val;
  #my $hut_pos  = sprintf "  %${info_pad}s %s", $hut_pos_txt,  $hut_pos_val;

  #return "$hut_size\n$hut_pos";
  return $hut_size;

}

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

  for my $type ( keys %{$hut_info->{count}} ) {
    my $name   = $hut_info->{block_types}[$type]{Name};

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

  }

  my $hut_res_fmt = "  %${max_string_len}s: %${max_count_len}d\n";

  return ( $hut_res_fmt, $resources );

}

sub output_type_text {
  my ( $hut_name, $hut_details, $res_fmt, $resources ) = @_;
  printf "%s\n\n%s\n\n%s\n\n", $hut_name, $hut_details, '-' x 40;
  printf $res_fmt, $_, $resources->{$_} for sort keys %$resources;

}

sub output_type_forum {
  my ( $hut_name, $hut_details, $res_fmt, $resources ) = @_;
  printf "%s\n\n%s\n\n%s\n\n", $hut_name, $hut_details, '-' x 40;
  printf "[table]\n[thead]\n[theader]Resource[/theader]\n[theader]Amount[/theader]\n[/thead]\n[tbody]";
  printf $res_fmt, $_, $resources->{$_} for sort keys %$resources;
  printf "[/tbody]";
  printf "[/table]";
  printf "\n";

}

1;
