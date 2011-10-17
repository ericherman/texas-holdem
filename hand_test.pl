#!/usr/bin/perl
use Hand;
use Card;
use Data::Dumper;

my $two_of_hearts  = Card->new( 2, 'h' );
my $ace_of_spades  = Card->new( 1, 's' );

my $ace_of_clubs   = Card->new( 1, 'c' );
my $nine_of_hearts = Card->new( 9, 'h' );
my $six_of_hearts  = Card->new( 6, 'h' );

my $ace_of_hearts  = Card->new( 1, 'h' );

my $four_of_hearts = Card->new( 4, 'h');

sub expect_name {
    my $hand_name = shift;
    my @cards = @_;
    my $hand = Hand->new(@cards);
    my $best = $hand->best_hand();
    my $data = Dumper({ hand => $hand, best => $best, });
    if ($best->{name} ne $hand_name) {
        die $data . ' not ' . $hand_name;
    }
}

my @cards = ( $two_of_hearts, $ace_of_spades );
expect_name( 'high card', @cards );

push @cards, $ace_of_clubs, $nine_of_hearts, $six_of_hearts;
expect_name( '2 of a kind', @cards );

push @cards, $ace_of_hearts;
expect_name( '3 of a kind', @cards );

push @cards, $four_of_hearts;
expect_name( 'flush', @cards );

