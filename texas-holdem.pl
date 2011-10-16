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

print "initializing deck:\n";
print display_cards(@deck), "\n";
print "\n";
shuffle(\@deck);
print "shuffled deck:\n";
print display_cards(@deck), "\n";
