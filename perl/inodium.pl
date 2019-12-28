#!/usr/bin/perl

use strict;
use warnings;

print("This is a work in progress.\n")
print("This is not yet for production use.\n")
print("Refactoring of https://github.com/richardforth/inodium/blob/master/ruby/inodium.rb")

# CircularBuffer inpired by code and adapted from: https://gist.github.com/manchicken/6238117
# Class CircularBuffer
{
  package CircularBuffer;

  sub new {
    my ($class, $size) = @_;

    my $self = {
      elements => [],
      limit => $size,
    };
    $self->{elements}->[$size-1] = "This is the last element."; # Grow the array

    return bless ($self, $class);
  }

  sub append {
    my ($self, $entry) = @_;
    my $size = $self->{limit};

    shift (@{$self->{elements}});
    push (@{$self->{elements}}, $entry);
  }

  sub size {
    my ($self) = @_;

    return scalar(@{$self->{elements}});
  }

  sub highest {
  }

  sub entries {
    my ($self) = @_;

    my @to_return = @{$self->{elements}}[0 .. 19];

    return @to_return;
  }
};

# TODO: Finish higest method, to work with array of hashes, return integer of highest count.
# TODO: Finish off the circular buffer by adding logic around when to add (higher count than highest)
# TODO: Method is_dir
# TODO: Method is_file
# TODO: Method list_one_deep
# TODO: Method scan (formerly slow_scan)
# TODO: Check Args list == 1
# TODO: Method: usage
# TODO: Defaulting to /
# TODO: Run Scan
# TODO: Print report
