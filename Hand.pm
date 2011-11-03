package Hand;

use strict;
use warnings;

use Card;

sub new {
    my $class = shift;
    my $self = { _cards => [] };
    bless $self, $class;
    foreach my $card (@_) {
        $self->add_card($card);
    }
    return $self;
}

sub add_card {
    my ( $self, $card ) = @_;
    push @{ $self->{_cards} }, $card;
}

sub add_cards {
    my $self  = shift;
    my @cards = @_;
    foreach my $card (@cards) {
        $self->add_card($card);
    }
}

sub cards {
    my ($self) = @_;
    my $cards = $self->{_cards};
    return $cards;
}

sub sorted_cards {
    my ( $self, $ace_low ) = @_;
    my $cards = $self->cards();
    return __sort_cards( $cards, $ace_low );
}

sub __sort_cards {
    my ( $cards, $ace_low ) = @_;
    my @sorted = sort { $b->compare_to( $a, $ace_low ) } @$cards;
    return wantarray ? @sorted : \@sorted;
}

sub num_cards {
    my ($self) = @_;
    my $cards = $self->cards();
    return scalar @$cards;
}

sub _straight {
    my ($self) = @_;
    return __straight( $self->cards() );
}

sub __straight {
    my ($cards) = @_;
    my $num_cards = scalar @{$cards};
    if ( $num_cards < 5 ) {
        return undef;
    }
    foreach my $ace_low ( 0 .. 1 ) {
        my $cards = __sort_cards( $cards, $ace_low );
        my $end = $num_cards - 5 + 1;

        for ( my $start = 0 ; $start < $end ; $start++ ) {
            my $ca = $cards->[ $start + 0 ];
            my $cb = $cards->[ $start + 1 ];
            my $cc = $cards->[ $start + 2 ];
            my $cd = $cards->[ $start + 3 ];
            my $ce = $cards->[ $start + 4 ];

            if (    ( $ca->rank() == $cb->rank() + 1 )
                and ( $cb->rank() == $cc->rank() + 1 )
                and ( $cc->rank() == $cd->rank() + 1 )
                and ( $cd->rank() == $ce->rank($ace_low) + 1 ) )
            {
                my @hand = ( $ca, $cb, $cc, $cd, $ce );
                my $best = {
                    name  => 'straight',
                    rank  => [ 20, $hand[0]->rank() ],
                    cards => \@hand,
                };
                return $best;
            }
        }
    }
    return undef;
}

sub _flush {
    my ($self) = @_;
    return __flush( $self->cards() );
}

sub __flush {
    my ($unsorted) = @_;
    my $num_cards = scalar @$unsorted;
    if ( $num_cards < 5 ) {
        return undef;
    }
    my @cards = reverse sort {
             ( $a->suit_char() cmp $b->suit_char() )
          or ( $a->rank() <=> $b->rank() )
    } @$unsorted;

    my $end = $num_cards - 5 + 1;

    for ( my $start = 0 ; $start < $end ; $start++ ) {
        my $ca = $cards[ $start + 0 ];
        my $cb = $cards[ $start + 1 ];
        my $cc = $cards[ $start + 2 ];
        my $cd = $cards[ $start + 3 ];
        my $ce = $cards[ $start + 4 ];

        if (    ( $ca->suit() eq $cb->suit() )
            and ( $ca->suit() eq $cc->suit() )
            and ( $ca->suit() eq $cd->suit() )
            and ( $ca->suit() eq $ce->suit() ) )
        {
            my @hand = ( $ca, $cb, $cc, $cd, $ce );
            my $best = {
                name  => 'flush',
                rank  => [32],
                cards => \@hand,
            };
            push @{ $best->{rank} }, map { $_->rank() } @hand;
            return $best;
        }
    }
    return undef;
}

sub _straight_flush {
    my ($self) = @_;
    if ( $self->num_cards() < 5 ) {
        return undef;
    }
    foreach my $ace_low ( 0 .. 1 ) {
        my @cards = reverse sort {
                 ( $a->suit_char() cmp $b->suit_char() )
              or ( $a->rank($ace_low) <=> $b->rank($ace_low) )
        } @{ $self->cards() };
        my $end = $self->num_cards() - 5 + 1;

        # straight flush
        for ( my $start = 0 ; $start < $end ; $start++ ) {
            my @hand = @cards[ $start .. $start + 4 ];
            if ( __flush( \@hand ) and __straight( \@hand ) ) {
                my $best = {
                    name  => 'straight flush',
                    rank  => [ 3216, $hand[0]->rank() ],
                    cards => \@hand,
                };
                return $best;
            }
        }
    }
    return undef;
}

sub __rank_for_n {
    my ($n) = @_;
    if ( $n == 4 ) {
        return 594;
    }
    if ( $n == 3 ) {
        return 19;
    }
    if ( $n == 2 ) {
        return 1;
    }
    die "no rank for $n";
}

sub _n_of_a_kind {
    my ( $self, $n, $cards ) = @_;

    $cards ||= $self->sorted_cards();
    my $num_cards = scalar @$cards;
    my $end       = $num_cards - $n;

    for ( my $start = 0 ; $start <= $end ; $start++ ) {
        my @hand;
        push @hand, $cards->[$start];
        for ( my $i = $start + 1 ; $i < $num_cards ; $i++ ) {
            my $ca = $cards->[$i];
            if ( $cards->[$start]->rank() == $ca->rank() ) {
                push @hand, $ca;
            }
        }
        if ( ( scalar @hand ) >= $n ) {
            my $best = {
                name  => $n . ' of a kind',
                rank  => [ __rank_for_n($n), $hand[0]->rank() ],
                cards => \@hand,
            };
            for ( my $i = 0 ; $i < $num_cards ; $i++ ) {
                my $card = $cards->[$i];
                if ( $card->rank() != $cards->[$start]->rank() ) {
                    push @{ $best->{cards} }, $card;
                    if (   ( scalar @{ $best->{cards} } == 5 )
                        or ( $i == $num_cards - 1 ) )
                    {
                        if ( defined $hand[$n] ) {
                            push @{ $best->{rank} }, $hand[$n]->rank();
                        }
                        return $best;
                    }
                }
            }
            return $best;
        }
    }
    return undef;
}

sub _full_house {
    my ($self) = @_;
    if ( $self->num_cards() < 5 ) {
        return undef;
    }
    my $cards = $self->sorted_cards();
    my $best = $self->_n_of_a_kind( 3, $cards );
    if ( not defined $best ) {
        return undef;
    }
    my @hand = @{ $best->{cards} }[ 0 .. 2 ];

    # print join(', ', map { $_->two_char() } @hand ), "\n";

    my @remainder;
    foreach my $card (@$cards) {
        if (    ( $card->compare_to( $hand[0] ) )
            and ( $card->compare_to( $hand[1] ) )
            and ( $card->compare_to( $hand[2] ) ) )
        {

            # this card is not in the @hand
            push @remainder, $card;
        }
    }
    $best = $self->_n_of_a_kind( 2, \@remainder );
    if ( not defined $best ) {
        return undef;
    }
    push @hand, @{ $best->{cards} }[ 0 .. 1 ];
    $best = {
        name  => 'full house',
        rank  => [ 37, $hand[0]->rank(), $hand[3]->rank() ],
        cards => \@hand,
    };
    return $best;
}

sub _two_pair {
    my ($self) = @_;
    if ( $self->num_cards() < 4 ) {
        return undef;
    }
    my $cards = $self->sorted_cards();
    my $best = $self->_n_of_a_kind( 2, $cards );
    if ( not defined $best ) {
        return undef;
    }
    my @hand = @{ $best->{cards} }[ 0 .. 1 ];

    # print join(', ', map { $_->two_char() } @hand ), "\n";

    my @remainder;
    foreach my $card (@$cards) {
        if (    ( $card->compare_to( $hand[0] ) )
            and ( $card->compare_to( $hand[1] ) ) )
        {

            # this card is not in the @hand
            push @remainder, $card;
        }
    }
    $best = $self->_n_of_a_kind( 2, \@remainder );
    if ( not defined $best ) {
        return undef;
    }
    my $have_4 = ( $self->num_cards() == 4 );
    my $end = ($have_4) ? 1 : 2;
    push @hand, @{ $best->{cards} }[ 0 .. $end ];
    my $high = ($have_4) ? 0 : $hand[4]->rank();
    $best = {
        name  => 'two pair',
        rank  => [ 3, $hand[0]->rank(), $hand[2]->rank(), $high ],
        cards => \@hand,
    };
    return $best;
}

sub best_hand {
    my ($self) = @_;
    my $best;

    $best = $self->_straight_flush();
    return $best if $best;

    #four of a kind
    $best = $self->_n_of_a_kind(4);
    return $best if $best;

    #full house
    $best = $self->_full_house();
    return $best if $best;

    #flush
    $best = $self->_flush();
    return $best if $best;

    #straight
    $best = $self->_straight();
    return $best if $best;

    #three of a kind
    $best = $self->_n_of_a_kind(3);
    return $best if $best;

    #two pair
    $best = $self->_two_pair();
    return $best if $best;

    #pair
    $best = $self->_n_of_a_kind(2);
    return $best if $best;

    #high card
    my $cards     = $self->sorted_cards();
    my $num_cards = $self->num_cards();
    my @hand;
    my $end = $num_cards < 5 ? $num_cards : 5;
    for ( my $i = 0 ; $i < 5 ; $i++ ) {
        push @hand, $cards->[$i];
    }
    $best = {
        name  => 'high card',
        rank  => [ 0, $hand[0]->rank() ],
        cards => \@hand,
    };
    return $best;
}

sub compare_ranks {
    my ( $class, $r1, $r2 ) = @_;
    my $ranks = scalar @{$r1};
    for ( my $i = 0 ; $i < $ranks ; $i++ ) {
        if ( $r1->[$i] > $r2->[$i] ) {
            return 1;
        }
        if ( $r1->[$i] < $r2->[$i] ) {
            return -1;
        }
    }
    return 0;
}

1;
