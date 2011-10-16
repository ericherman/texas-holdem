#!/usr/bin/perl
use strict;
use warnings;

sub rank_char {
    my ($rank) = @_;
    if (($rank >= 2) and ($rank <= 10)) {
        return $rank;
    }
    if ($rank == 11) {
        return 'J';
    }
    if ($rank == 12) {
            return 'Q';
    }
    if ($rank == 13) {
            return 'K';
    }
    if (($rank == 14) or ($rank == 1)){
        return 'A';
    }
}

sub display_cards {
    my @cards = @_;
    my $i = 0;
    my $str = '';
    foreach my $card (@cards) {
        if ($i > 0) {
            if (($i % 7) == 0) {
                $str .= "\n";
            } else {
                $str .= " ";
            }
        }
        $i++;
        my $suit = $card->{suit};
        my $rank_char = rank_char($card->{rank});
        $str = sprintf("%s%2s%1s", $str, $rank_char, $suit);
    }
    return $str;
}

sub order_cards {
    my ($unsorted) = @_;

    my @cards = sort { $b->{rank} <=> $a->{rank}
                    or $b->{suit} cmp $a->{suit} }
                @$unsorted;

    return \@cards;
}

sub straight {
    my ($cards) = @_;
    $cards = order_cards($cards);
    my $num_cards = scalar @$cards;
    my $end = $num_cards - 5 + 1;

    # straight flush
    for (my $start= 0; $start < $end; $start++) {
        my $ca = $cards->[$start + 0];
        my $cb = $cards->[$start + 1];
        my $cc = $cards->[$start + 2];
        my $cd = $cards->[$start + 3];
        my $ce = $cards->[$start + 4];

        if  (($ca->{rank} == $cb->{rank} + 1)
         and ($cb->{rank} == $cc->{rank} + 1)
         and ($cc->{rank} == $cd->{rank} + 1)
         and ($cd->{rank} == $ce->{rank} + 1)) {
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

sub straight_flush {
    my ($cards) = @_;
    $cards = order_cards($cards);
    my $num_cards = scalar @$cards;
    my $end = $num_cards - 5 + 1;

    # straight flush
    for (my $start= 0; $start < $end; $start++) {
        my $ca = $cards->[$start + 0];
        my $cb = $cards->[$start + 1];
        my $cc = $cards->[$start + 2];
        my $cd = $cards->[$start + 3];
        my $ce = $cards->[$start + 4];

        if ((($ca->{suit} eq $cb->{suit})
         and ($ca->{suit} eq $cc->{suit})
         and ($ca->{suit} eq $cd->{suit})
         and ($ca->{suit} eq $ce->{suit})) and
            (($ca->{rank} == $cb->{rank} + 1)
         and ($cb->{rank} == $cc->{rank} + 1)
         and ($cc->{rank} == $cd->{rank} + 1)
         and ($cd->{rank} == $ce->{rank} + 1))) {
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

sub n_of_a_kind {
    my ($n, $cards) = @_;

    $cards = order_cards($cards);
    my $num_cards = scalar @$cards;
    my $end = $num_cards - $n;

    for (my $start= 0; $start < $end; $start++) {
        my @hand;
        push @hand, $cards->[$start];
        for (my $i = $start + 1; $i < $num_cards; $i++) {
            my $ca = $cards->[$i];
            if ($cards->[$start]->{rank} == $ca->{rank}) {
                push @hand, $ca;
            }
        }
        if ((scalar @hand) >= $n) {
            for (my $i = 0; $i < $num_cards; $i++) {
                my $card = $cards->[$i];
                if ($card->{rank} != $cards->[$start]->{rank}) {
                    push @hand, $card;
                    my $best = {
                        name  => $n . ' of a kind',
                        cards => \@hand,
                    };
                    if (scalar @hand == 5) {
                        return $best;
                    }
                }
            }
        }
    }
    return undef;
}

sub best_hand {
    my ($cards) = @_;
    my $best;

    $best = straight_flush($cards);
    return $best if $best;

    #four of a kind
    $best = n_of_a_kind(4, $cards);
    return $best if $best;


    #full house
    #TODO FULL HOUSE

    #strait
    $best = n_of_a_kind(2, $cards);
    return $best if $best;

    #flush
    #TODO FLUSH

    #three of a kind
    $best = n_of_a_kind(2, $cards);
    return $best if $best;

    #two pair
    #TODO TWO PAIR

    #pair
    $best = n_of_a_kind(2, $cards);
    return $best if $best;


    #high card
    $cards = order_cards($cards);
    my @hand;
    for (my $i = 0; $i < 5; $i++) {
        push @hand, $cards->[$i];
    }
    $best = {
        name  => 'high card',
        cards => \@hand,
    };
    return $best;
}


sub shuffle {
    my ($deck) = @_;
    my $num_cards = scalar @$deck;
    for (my $i= 0; $i < $num_cards; $i++) {
        my $swap = int(rand($num_cards - $i)) + $i;
        my $card_a = @$deck[$i];
        my $card_b = @$deck[$swap];
        @$deck[$i] = $card_b;
        @$deck[$swap] = $card_a;
    }
}


my @deck;

foreach my $suit (qw{ s h c d }) { # spades hearts clubs diamonds }
    foreach my $rank (2..14) {
        my $card = { suit => $suit, rank => $rank };
        push @deck, $card;
    }
}

# print "initializing deck:\n";
# print display_cards(@deck), "\n";
# print "\n";
# shuffle(\@deck);
# print "shuffled deck:\n";
# print display_cards(@deck), "\n";

my $players = 5;

my @house_hand;
# push @house_hand, $deck[((2 * $players) + 0)]; # burn
push @house_hand, $deck[((2 * $players) + 1)]; # flop
push @house_hand, $deck[((2 * $players) + 2)]; # flop
push @house_hand, $deck[((2 * $players) + 3)]; # flop
# push @house_hand, $deck[((2 * $players) + 4)]; # burn
push @house_hand, $deck[((2 * $players) + 5)]; # turn
# push @house_hand, $deck[((2 * $players) + 6)]; # burn
push @house_hand, $deck[((2 * $players) + 7)]; # river

print "on the table:\n";
print display_cards(@house_hand), "\n";
my $best_hand = best_hand(\@house_hand);
print "    ", $best_hand->{name}, ":\n";
my @hand_cards = @{ $best_hand->{cards} };
print "    [ ", display_cards(@hand_cards), " ]\n";

for (my $i = 0; $i < $players; $i++) {
    print "\n";
    my @hand;
    push @hand, $deck[$i];
    push @hand, $deck[$i + $players];
    push @hand, @house_hand;
    print "player $i:\n";
    print display_cards(@hand), "\n";
    $best_hand = best_hand(\@hand);
    print "    ", $best_hand->{name}, ":\n";
    @hand_cards = @{ $best_hand->{cards} };
    print "    [ ", display_cards(@hand_cards), " ]\n";
}
