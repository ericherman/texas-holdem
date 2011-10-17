package Deck;

use strict;
use warnings;

sub new {
    my $class = shift;
    my ($rank, $suit) = @_;
    my $self = {};
    bless $self, $class;

    my @deck;
    foreach my $suit (qw{ clubs diamonds hearts spades }) {
        foreach my $rank (1..13) {
            my $card = Card->new( $rank, $suit );
            push @deck, $card;
        }
    }
    $self->{_cards} = \@deck;
    $self->{_top} = 0;

    return $self;
}

sub shuffle {
    my ($self) = @_;
    my $deck = $self->{_cards};
    my $num_cards = scalar @$deck;
    for (my $i= 0; $i < $num_cards; $i++) {
        my $swap = int(rand($num_cards - $i)) + $i;
        my $card_a = @$deck[$i];
        my $card_b = @$deck[$swap];
        @$deck[$i] = $card_b;
        @$deck[$swap] = $card_a;
    }
}

sub deal_card {
    my ($self) = @_;
    return $self->{_cards}->[$self->{_top}++];
}

sub display_cards {
    my ($self, $columns) = @_;
    $columns ||= 8;
    my $i = 0;
    my $str = '';
    foreach my $card (@{$self->{_cards}}) {
        if ($i > 0) {
            if (($i % $columns) == 0) {
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

1;
