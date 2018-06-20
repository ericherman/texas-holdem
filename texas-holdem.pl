#!/usr/bin/perl
use strict;
use warnings;

use Card;
use Deck;
use Hand;

sub display_cards {
    return join( ' ', map { $_->two_char() } @_ );
}

sub visualize_game {
    my ( $house_hand, @hands ) = @_;

    my @table_cards = @{ $house_hand->cards() };
    print "on the table:\n";
    print display_cards(@table_cards), "\n";
    my $best_hand = $house_hand->best_hand();
    print "    ", $best_hand->{name}, "\n";
    my @hand_cards = @{ $best_hand->{cards} };
    print "    [ ", display_cards(@hand_cards), " ]\n";

    my $tie    = 0;
    my @winner = ('the table');

    my $i = 0;
    foreach my $hand (@hands) {
        $i++;
        print "\n";
        print "player $i:\n";
        print display_cards( @{ $hand->cards() }[0], @{ $hand->cards() }[1] ),
          "\n";
        my $player_hand = $hand->best_hand();
        print "    ", $player_hand->{name}, "\n";
        my @player_cards = @{ $player_hand->{cards} };
        print "    [ ", display_cards(@player_cards), " ]\n";

        my $best_rank   = $best_hand->{rank};
        my $player_rank = $player_hand->{rank};
        my $compare     = Hand->compare_ranks( $player_rank, $best_rank );

        if ( $compare > 0 ) {
            $best_hand = $player_hand;
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
    return $best_hand;
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

my $house_hand = Hand->new();
my @hands;
for ( my $i = 0 ; $i < $num_players ; $i++ ) {
    push @hands, Hand->new();
}

for my $i ( 1 .. 2 ) {
    foreach my $hand (@hands) {
        $hand->add_card( $deck->deal_card() );
    }
}

visualize_game( $house_hand, @hands );
my $userinput = <STDIN>;
chomp($userinput);

my $burn = $deck->deal_card();

for my $i ( 1 .. 3 ) {    #flop
    my $card = $deck->deal_card();
    foreach my $hand ( $house_hand, @hands ) {
        $hand->add_card($card);
    }
}

visualize_game( $house_hand, @hands );
$userinput = <STDIN>;
chomp($userinput);

$burn = $deck->deal_card();

my $turn = $deck->deal_card();
foreach my $hand ( $house_hand, @hands ) {
    $hand->add_card($turn);
}

visualize_game( $house_hand, @hands );
$userinput = <STDIN>;
chomp($userinput);

$burn = $deck->deal_card();

my $river = $deck->deal_card();
foreach my $hand ( $house_hand, @hands ) {
    $hand->add_card($river);
}

my $best_hand = visualize_game( $house_hand, @hands );

printf( "\twith a %s (odds over %s to 1 against)\n",
    $best_hand->{name}, $best_hand->{rank}->[0] );
