#!/usr/bin/perl
use strict;
use warnings;

use Card;
use Deck;
use Hand;

sub display_cards {
    return join( ' ', map { $_->two_char() } @_ );
}

my $deck = Deck->new();

#print "initializing deck:\n";
#print $deck->display_cards(), "\n";
#print "\n";
$deck->shuffle();

#print "shuffled deck:\n";
#print $deck->display_cards(), "\n";
#print "\n";

my $num_players = 5;

my @hands;
for ( my $i = 0 ; $i < $num_players ; $i++ ) {
    push @hands, Hand->new();
}

for my $i ( 1 .. 2 ) {
    foreach my $hand (@hands) {
        $hand->add_card( $deck->deal_card() );
    }
}

my $house_hand = Hand->new();
my @table_cards;
my $burn = $deck->deal_card();

for my $i ( 1 .. 3 ) {    #flop
    my $card = $deck->deal_card();
    push @table_cards, $card;
    foreach my $hand ( $house_hand, @hands ) {
        $hand->add_card($card);
    }
}

$burn = $deck->deal_card();

my $turn = $deck->deal_card();
push @table_cards, $turn;
foreach my $hand ( $house_hand, @hands ) {
    $hand->add_card($turn);
}

$burn = $deck->deal_card();

my $river = $deck->deal_card();
push @table_cards, $river;
foreach my $hand ( $house_hand, @hands ) {
    $hand->add_card($river);
}

print "on the table:\n";
print display_cards(@table_cards), "\n";
my $best_hand = $house_hand->best_hand();
print "    ", $best_hand->{name}, " [ ", join( ', ', @{ $best_hand->{rank} } ),
  " ]:\n";
my @hand_cards = @{ $best_hand->{cards} };
print "    [ ", display_cards(@hand_cards), " ]\n";

my $best_rank = $best_hand->{rank};
my $tie       = 0;
my @winner    = ('the table');

my $i = 0;
foreach my $hand (@hands) {
    $i++;
    print "\n";
    print "player $i:\n";
    print display_cards( $hand->cards() ), "\n";
    my $player_hand = $hand->best_hand();
    print "    ", $player_hand->{name}, " [ ",
      join( ', ', @{ $player_hand->{rank} } ), " ]:\n";
    my @player_cards = @{ $player_hand->{cards} };
    @player_cards = @{ $player_hand->{cards} };
    print "    [ ", display_cards(@player_cards), " ]\n";
    my $compare = Hand->compare_ranks( $player_hand->{rank}, $best_rank );

    if ( $compare > 0 ) {
        $best_rank = $player_hand->{rank};
        $tie       = 0;
        @winner    = ("player $i");
    }
    elsif ( $compare == 0 ) {
        $tie = 1;
        push @winner, "player $i";
    }
}

print "\n";
my $msg = ($tie) ? "The winners are: " : "The winner is: ";
print $msg, join( ', ', @winner ), "\n";
