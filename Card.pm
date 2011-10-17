package Card;

use strict;
use warnings;

sub new {
    my $class = shift;
    my ($rank, $suit) = @_;
    my $self = {};
    if ($rank < 1 or $rank > 14) {
        die "bad rank $rank";
    }
    if ($rank == 1) {
        $rank = 14; #Ace is rank 14 for most stuff
    }
    $self->{_rank} = $rank;

    $suit = lc($suit);
    if (($suit eq 's') or ($suit eq 'spades') or ($suit eq 'spade')) {
        $self->{_suit} = 's';
    }
    elsif (($suit eq 'h') or ($suit eq 'hearts') or ($suit eq 'heart')) {
        $self->{_suit} = 'h';
    }
    elsif (($suit eq 'd') or ($suit eq 'diamonds') or ($suit eq 'diamond')) {
        $self->{_suit} = 'd';
    }
    elsif (($suit eq 'c') or ($suit eq 'clubs') or ($suit eq 'club')) {
        $self->{_suit} = 'c';
    }
    else {
        die "bad suit $suit";
    }

    bless $self, $class;
    return $self;
}

sub rank {
    my ($self) = @_;
    return $self->{_rank};
}

sub rank_char {
    my ($self) = @_;
    my $rank = $self->rank();
    if (($rank >= 2) and ($rank <= 10)) {
        return $rank;
    }
    if ($rank == 11) {
        return 'J';
    }
    if ($rank == 12) {
            return 'Q';
    }
    if ($rank == 13) {
            return 'K';
    }
    if (($rank == 14) or ($rank == 1)){
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
   if ($suit_char eq 's') {
       return 'spades';
   }
   if ($suit_char eq 'h') {
       return 'hearts';
   }
   if ($suit_char eq 'd') {
       return 'diamonds';
   }
   if ($suit_char eq 'c') {
       return 'clubs';
   }
   die "bad suit '$suit_char'";
}

sub compare_to {
    my ($self, $other) = @_;
    if ($self->rank() < $other->rank()) {
        return -1;
    }
    if ($self->rank() > $other->rank()) {
        return 1;
    }
    if ($self->suit_char() lt $other->suit_char()) {
        return -1;
    }
    if ($self->suit_char() gt $other->suit_char()) {
        return 1;
    }
    return 0;
}

1;
