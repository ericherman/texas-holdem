package Card;

use strict;
use warnings;

sub new {
    my $class = shift;
    my ( $rank, $suit ) = @_;
    my $self = {};
    bless $self, $class;

    $self->_set_rank($rank);
    $self->_set_suit($suit);

    return $self;
}

sub _set_rank {
    my ( $self, $orig_rank ) = @_;
    my $rank = lc($orig_rank);
    if ( ( $rank eq 'a' ) or ( $rank eq 'ace' ) ) {
        $rank = 14;
    }
    elsif ( ( $rank eq 'k' ) or ( $rank eq 'king' ) ) {
        $rank = 13;
    }
    elsif ( ( $rank eq 'q' ) or ( $rank eq 'queen' ) ) {
        $rank = 12;
    }
    elsif ( ( $rank eq 'j' ) or ( $rank eq 'jack' ) ) {
        $rank = 11;
    }
    elsif ( ( $rank eq 't' ) or ( $rank eq 'ten' ) ) {
        $rank = 10;
    }
    else {
        $rank = $orig_rank;
    }
    if ( $rank == 1 ) {
        $rank = 14;    #Ace is rank 14 for most stuff
    }
    if ( not( $rank >= 2 and $rank <= 14 ) ) {
        die "bad rank $orig_rank";
    }
    $self->{_rank} = $rank;
}

sub _set_suit {
    my ( $self, $orig_suit ) = @_;

    my $suit = lc($orig_suit);
    if ( ( $suit eq 's' ) or ( $suit eq 'spades' ) or ( $suit eq 'spade' ) ) {
        $self->{_suit} = 's';
    }
    elsif ( ( $suit eq 'h' ) or ( $suit eq 'hearts' ) or ( $suit eq 'heart' ) )
    {
        $self->{_suit} = 'h';
    }
    elsif (( $suit eq 'd' )
        or ( $suit eq 'diamonds' )
        or ( $suit eq 'diamond' ) )
    {
        $self->{_suit} = 'd';
    }
    elsif ( ( $suit eq 'c' ) or ( $suit eq 'clubs' ) or ( $suit eq 'club' ) ) {
        $self->{_suit} = 'c';
    }
    else {
        die "bad suit $orig_suit";
    }
}

sub rank {
    my ( $self, $ace_low ) = @_;
    my $rank = $self->{_rank};
    if ( ($ace_low) && ( $rank == 14 ) ) {
        return 1;
    }
    return $rank;
}

sub rank_char {
    my ($self) = @_;
    my $rank = $self->rank();
    if ( ( $rank >= 2 ) and ( $rank <= 9 ) ) {
        return $rank;
    }
    if ( $rank == 10 ) {
        return 'T';
    }
    if ( $rank == 11 ) {
        return 'J';
    }
    if ( $rank == 12 ) {
        return 'Q';
    }
    if ( $rank == 13 ) {
        return 'K';
    }
    if ( ( $rank == 14 ) or ( $rank == 1 ) ) {
        return 'A';
    }
    die "bad rank '$rank'";
}

sub suit_char {
    my ($self) = @_;
    return $self->{_suit};
}

sub suit {
    my ($self) = @_;
    my $suit_char = $self->{_suit};
    if ( $suit_char eq 's' ) {
        return 'spades';
    }
    if ( $suit_char eq 'h' ) {
        return 'hearts';
    }
    if ( $suit_char eq 'd' ) {
        return 'diamonds';
    }
    if ( $suit_char eq 'c' ) {
        return 'clubs';
    }
    die "bad suit '$suit_char'";
}

sub two_char {
    my $self = shift;
    return $self->rank_char() . $self->suit_char();
}

sub compare_to {
    my ( $self, $other, $ace_low ) = @_;
    if ( not defined $other ) {
        die $self->two_char() . '->compare_to(undef)';
    }
    if ( $self->rank($ace_low) < $other->rank($ace_low) ) {
        return -1;
    }
    if ( $self->rank($ace_low) > $other->rank($ace_low) ) {
        return 1;
    }
    if ( $self->suit_char() lt $other->suit_char() ) {
        return -1;
    }
    if ( $self->suit_char() gt $other->suit_char() ) {
        return 1;
    }
    return 0;
}

1;
