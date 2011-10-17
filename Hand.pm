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
    my ($self, $card) = @_;
    push @{ $self->{_cards} }, $card;
}

sub add_cards {
    my $self = shift;
    my @cards = @_;
    foreach my $card (@cards) {
        $self->add_card($card);
    }
}

sub cards {
    my ($self) = @_;
    my $cards = $self->{_cards};
    return wantarray ? @{$cards} : $cards;
}

sub sorted_cards {
    my ($self) = @_;
    my @cards = $self->cards();
    my @sorted = sort { $b->compare_to($a) } @cards;
    return wantarray ? @sorted : \@sorted;
}

sub num_cards {
    my ($self) = @_;
    my @cards = $self->cards();
    return scalar @cards;
}

sub _straight {
    my ($self) = @_;
    if ($self->num_cards() < 5) {
        return undef;
    }
    my $cards = $self->sorted_cards();
    my $end = $self->num_cards() - 5 + 1;

    for (my $start= 0; $start < $end; $start++) {
        my $ca = $cards->[$start + 0];
        my $cb = $cards->[$start + 1];
        my $cc = $cards->[$start + 2];
        my $cd = $cards->[$start + 3];
        my $ce = $cards->[$start + 4];

        if  (($ca->rank() == $cb->rank() + 1)
         and ($cb->rank() == $cc->rank() + 1)
         and ($cc->rank() == $cd->rank() + 1)
         and ($cd->rank() == $ce->rank() + 1)) {
            my @hand = ($ca, $cb, $cc, $cd, $ce);
            my $best = {
                name  => 'straight',
                cards => \@hand,
            };
            return $best;
        }
    }
    return undef;
}

sub _flush {
    my ($self) = @_;
    if ($self->num_cards() < 5) {
        return undef;
    }
    my @unsorted = $self->cards();
    my @cards = reverse sort {
                        ($a->suit_char() cmp $b->suit_char())
                     or ($a->rank()      <=> $b->rank())
                } @unsorted;

    my $end = $self->num_cards() - 5 + 1;

    for (my $start= 0; $start < $end; $start++) {
        my $ca = $cards[$start + 0];
        my $cb = $cards[$start + 1];
        my $cc = $cards[$start + 2];
        my $cd = $cards[$start + 3];
        my $ce = $cards[$start + 4];

        if (($ca->suit() eq $cb->suit())
         and ($ca->suit() eq $cc->suit())
         and ($ca->suit() eq $cd->suit())
         and ($ca->suit() eq $ce->suit())) {
            my @hand = ($ca, $cb, $cc, $cd, $ce);
            my $best = {
                name  => 'flush',
                cards => \@hand,
            };
            return $best;
        }
    }
    return undef;
}

sub _straight_flush {
    my ($self) = @_;
    if ($self->num_cards() < 5) {
        return undef;
    }
    my $cards = $self->sorted_cards();
    my $end = $self->num_cards() - 5 + 1;

    # straight flush
    for (my $start= 0; $start < $end; $start++) {
        my $ca = $cards->[$start + 0];
        my $cb = $cards->[$start + 1];
        my $cc = $cards->[$start + 2];
        my $cd = $cards->[$start + 3];
        my $ce = $cards->[$start + 4];

        if ((($ca->suit() eq $cb->suit())
         and ($ca->suit() eq $cc->suit())
         and ($ca->suit() eq $cd->suit())
         and ($ca->suit() eq $ce->suit())) and
            (($ca->rank() == $cb->rank() + 1)
         and ($cb->rank() == $cc->rank() + 1)
         and ($cc->rank() == $cd->rank() + 1)
         and ($cd->rank() == $ce->rank() + 1))) {
            my @hand = ($ca, $cb, $cc, $cd, $ce);
            my $best = {
                name  => 'straight flush',
                cards => \@hand,
            };
            return $best;
        }
    }
    return undef;
}

sub _n_of_a_kind {
    my ($self, $n) = @_;

    my $cards = $self->sorted_cards();
    my $end = $self->num_cards() - $n;

    for (my $start= 0; $start < $end; $start++) {
        my @hand;
        push @hand, $cards->[$start];
        for (my $i = $start + 1; $i < $self->num_cards(); $i++) {
            my $ca = $cards->[$i];
            if ($cards->[$start]->rank() == $ca->rank()) {
                push @hand, $ca;
            }
        }
        if ((scalar @hand) >= $n) {
            for (my $i = 0; $i < $self->num_cards(); $i++) {
                my $card = $cards->[$i];
                if ($card->rank() != $cards->[$start]->rank()) {
                    push @hand, $card;
                    my $best = {
                        name  => $n . ' of a kind',
                        cards => \@hand,
                    };
                    if ((scalar @hand == 5) or ($i == $self->num_cards()-1)) {
                        return $best;
                    }
                }
            }
        }
    }
    return undef;
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
    #TODO FULL HOUSE

    #straight
    $best = $self->_straight();
    return $best if $best;

    #flush
    $best = $self->_flush();
    return $best if $best;

    #three of a kind
    $best = $self->_n_of_a_kind(3);
    return $best if $best;

    #two pair
    #TODO TWO PAIR

    #pair
    $best = $self->_n_of_a_kind(2);
    return $best if $best;


    #high card
    my $cards = $self->sorted_cards();
    my $num_cards = $self->num_cards();
    my @hand;
    my $end = $num_cards < 5 ? $num_cards : 5;
    for (my $i = 0; $i < 5; $i++) {
        push @hand, $cards->[$i];
    }
    $best = {
        name  => 'high card',
        cards => \@hand,
    };
    return $best;
}

1;
