#!/usr/bin/perl
use Card;
use Data::Dumper;

my $two_of_clubs1  = Card->new( 2,   'c' );
my $ace_of_hearts  = Card->new( 1,   'hearts' );
my $jack_of_hearts = Card->new( 'j', 'h' );
my $ace_of_spades  = Card->new( 1,   's' );
my $two_of_clubs2  = Card->new( 2,   'Club' );

my @cards = (
    $two_of_clubs1, $ace_of_hearts, $jack_of_hearts,
    $ace_of_spades, $two_of_clubs2
);
my @sorted = sort { $a->compare_to($b) } @cards;

my $data = Dumper( { cards => \@cards, sorted => \@sorted, } );

if (   ( $cards[0] ne $sorted[0] )
    or ( $cards[1] ne $sorted[3] )
    or ( $cards[2] ne $sorted[2] )
    or ( $cards[3] ne $sorted[4] )
    or ( $cards[4] ne $sorted[1] ) )
{
    die $data;
}

if ( $ace_of_spades->rank() != 14 ) {
    die "14 != " . $ace_of_spades->rank();
}

my $ace_low = 0;
if ( $ace_of_spades->rank($ace_low) != 14 ) {
    die "14 != " . $ace_of_spades->rank();
}
$ace_low = 1;
if ( $ace_of_spades->rank($ace_low) != 1 ) {
    die "1 != " . $ace_of_spades->rank();
}
