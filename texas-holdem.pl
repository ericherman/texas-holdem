#!/usr/bin/perl
use strict;
use warnings;

use Card;
use Hand;

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
        $str = sprintf("%s%s", $str, $card->two_char());
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
        my $card = Card->new( $rank, $suit );
        push @deck, $card;
    }
}

#print "initializing deck:\n";
#print display_cards(@deck), "\n";
#print "\n";
shuffle(\@deck);
#print "shuffled deck:\n";
#print display_cards(@deck), "\n";

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
my $best_hand = Hand->new(\@house_hand)->best_hand();
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
    $best_hand = Hand->new(\@hand)->best_hand();
    print "    ", $best_hand->{name}, ":\n";
    @hand_cards = @{ $best_hand->{cards} };
    print "    [ ", display_cards(@hand_cards), " ]\n";
}
