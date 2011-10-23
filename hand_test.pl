#!/usr/bin/perl
use Hand;
use Card;
use Data::Dumper;

my $two_of_hearts = Card->new( 2, 'h' );
my $ace_of_spades = Card->new( 1, 's' );

my $ace_of_clubs   = Card->new( 1, 'c' );
my $nine_of_hearts = Card->new( 9, 'h' );
my $six_of_hearts  = Card->new( 6, 'h' );

my $ace_of_hearts = Card->new( 1, 'h' );

my $four_of_hearts = Card->new( 4, 'h' );
my $three_of_clubs = Card->new( 3, 'c' );
my $nine_of_spades = Card->new( 9, 's' );
my $five_of_spades = Card->new( 5, 's' );
my $ace_of_diamond = Card->new( 1, 'd' );
my $nine_of_clubs  = Card->new( 9, 'c' );

sub expect_name {
    my $hand_name = shift;
    my @cards     = @_;
    my $from      = join ", ", map { $_->two_char() } @cards;
    my $hand      = Hand->new(@cards);
    my $best      = $hand->best_hand();
    my $fail      = ($best->{name} ne $hand_name);
    if (0 or $fail) {
        my $cards = join ", ",
          map { ($_) ? $_->two_char() : () } @{ $best->{cards} };
        print "Got: $cards (" . $best->{name} . ")\n";
    }
    if ( $fail ) {
        my $data = Dumper( { from => $from, best => $best } );
        die $data . " expected $hand_name \n";
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

push @cards, $ace_of_diamond;
expect_name( '4 of a kind', @cards );

@cards = (
    $four_of_hearts, $two_of_hearts, $three_of_clubs,
    $six_of_hearts,  $five_of_spades
);
expect_name( 'straight', @cards );

my @cards = (
    $two_of_hearts, $ace_of_spades, $nine_of_clubs, $nine_of_hearts,
    $six_of_hearts, $ace_of_hearts, $nine_of_spades
);
expect_name( 'full house', @cards );

my @cards = (
    $two_of_hearts, $ace_of_spades, $nine_of_clubs, $four_of_hearts,
    $six_of_hearts, $ace_of_hearts, $nine_of_spades
);
expect_name( 'two pair', @cards );
