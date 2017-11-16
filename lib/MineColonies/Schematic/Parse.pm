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

sub simple { $hut_info->{$_[0]} = $_[1] }

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
        # XXX: how to handle multiple nbt keys
        $hut_info->{hut_pos} ||= $block->{pos};

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

    # Normalize minecraft vanilla blocks.
    $string =~ s/^minecraft://;

    # We can't have a lit anything (like a lamp) in our inventory.
    $string =~ s/^lit_//;

    # We don't differentiate between log and log2, slab and slab2, etc.
    $string =~ s/2$//;

    # If it starts with fence, it's an oak fence.
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

      $string = "$variant $string"
        if $variant ne '' && ! grep { /$variant/ } @skip_variant;

      $string = "$props->{color} $string"
        if exists $props->{color};

    }

    # Replace underscores with spaces for readability.
    $string =~ s/_+/ /g;

    # Get rid of all doubled words, like cobblestone cobblestone wall.
    $string =~ s/(\b(\w+)\b\s+\b\2\b)/$2/g;

    $type->{string} = $string;

  }

  $hut_info->{block_types} = $types;

}

1;
