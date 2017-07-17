package MineColonies::Schematic::Parse;

use strict;
use warnings;


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

my $hut_info;

sub parse_data {
  my ( $data ) = @_;

  for my $el ( keys %$data ) {
    my $method = lc $el;

    warn sprintf "unknown method key: %s\n", Dumper $data->{$el}
      unless exists $method_hash->{$method};

    $method_hash->{$method}->( $data->{$el} );

  }

  return $hut_info;

}

sub simple { $hut_info->{$_[0]} = $_[1] }

sub blocks {
  my ( $blocks ) = @_;

  my @blocks_info;

  my @ignore_key = ();

  for my $block ( @$blocks ) {
    my $block_info;

    for my $key ( keys %$block ) {

      if ( $key eq 'pos' ) {
        $block_info->{xyz} = $block->{$key};

      } elsif ( $key eq 'state' ) {
        $block_info->{type} = $block->{$key};
        $hut_info->{count}{$block->{$key}}++;

      } elsif ( $key eq 'nbt' ) {
        #die "multiple nbt's, don't know what to do"
        #  if exists $hut_info->{hut_pos};

        if ( exists $hut_info->{hut_pos} ) {
          # Don't do anything with extra nbt's at all.
          #warn "multiple nbt's, not doing anything with this key";
        } else {
          $hut_info->{hut_pos} = $block->{pos};
        }

      } else {
        warn "uknown key ($key) in blocks\n"
          unless grep {$key} @ignore_key;

      }
    }

    push @blocks_info, $block_info;

  }

  $hut_info->{block_matrix} = \@blocks_info;

}

sub palette {
  my ( $types ) = @_;

  for my $type ( @$types ) {
    my $string = $type->{Name};

    $string =~ s/^minecraft://;

    # Special cases.

    $string =~ s/_+/ /g;
    $string =~ s/^log2$/log/;
    $string =~ s/^fence$/oak fence/;

    # Skip variants of these values.

    my @skip_variant = qw(
      default
      lines_x
      lines_y
      lines_z
    );

    if ( exists $type->{Properties} ) {
      my $props   = $type->{Properties};
      my $variant = exists $props->{variant} ? $props->{variant} : '';
      my $color   = exists $props->{color}   ? $props->{color}   : '';

      if ( $variant ne '' && ! grep { /$variant/ } @skip_variant ) {

        $variant =~ s/_+/ /g;

        # Avoid 'dirt dirt' or 'cracked stonebrick stonebrick'
        $string = $variant =~ /$string/ ? $variant : "$variant $string";

      }

      $string = "$color $string"
        unless $color eq '';

    }

    $type->{string} = $string;

  }

  $hut_info->{block_types} = $types;

}

1;
