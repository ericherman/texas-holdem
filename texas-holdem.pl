#!/usr/bin/perl
use strict;
use warnings;

use Card;
use Deck;
use Hand;

sub display_cards {
    return join(' ', map { $_->two_char() } @_);
}

my $cards = Deck->new();

#print "initializing deck:\n";
#print $cards->display_cards(), "\n";
#print "\n";
$cards->shuffle();
#print "shuffled deck:\n";
#print $cards->display_cards(), "\n";
#print "\n";

my @deck = @{ $cards->{_cards} };

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
