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

sub print_cards {
    my @cards = @_;
    my $i = 0;
    foreach my $card (@cards) {
        if ($i > 0) {
            if (($i % 5) == 0) {
                print "\n";
            } else {
                print " ";
            }
        }
        $i++;
        my $suit = $card->{suit};
        my $rank = rank_char($card->{rank});
        print sprintf("%2s%1s", $rank, $suit);
    }
    print "\n";
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
print_cards(@deck);
print "\n";
shuffle(\@deck);
print "shuffled deck:\n";
print_cards(@deck);
