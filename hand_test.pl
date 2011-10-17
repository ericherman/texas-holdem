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

my @cards = ( $two_of_hearts, $ace_of_spades );
my $hand = Hand->new(\@cards);
my $best = $hand->best_hand();
my $data = Dumper({ hand => $hand, best => $best, });
if ($best->{name} ne 'high card') {
    die $data;
}

$hand->add_cards($ace_of_clubs, $nine_of_hearts, $six_of_hearts);
$best = $hand->best_hand();
my $data = Dumper({ hand => $hand, best => $best, });
if ($best->{name} ne '2 of a kind') {
    die $data;
}

$hand->add_card($ace_of_hearts);
$best = $hand->best_hand();
my $data = Dumper({ hand => $hand, best => $best, });
if ($best->{name} ne '3 of a kind') {
    die $data;
}

$hand->add_card($four_of_hearts);
$best = $hand->best_hand();
my $data = Dumper({ hand => $hand, best => $best, });
if ($best->{name} ne 'flush') {
    die $data;
}
