package MooseX::ConsistentHash::Option;

our $VERSION = '0.01';

use Storable qw(freeze);
use Digest::MD5 qw(md5_hex);

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

# type describing value for 'hash' attribute
subtype 'md5_hex'
    => as 'Str'
    => where {
        /^[\d|a-z]{32}$/
    }
    => message { "'identificator' value ('$_') of the option is not like a result Digest::MD5::md5_hex\n"};

# option value to choice return
has 'option' => (
    is => 'ro',
    isa => 'Defined',
    required => 1
);

# weight option
has 'weight' => (
    is => 'rw',
    isa => 'Int',
    required => 1
);

# option uniquie identificator (md5 by value thing)
# Probably a good idea to use Data::UUID, but there are doubts in the case of threads or forks
# because the attribute is 'lazy'
# Therefore used a bunch of Digest::MD5 with Storable
has 'identificator' => (
    is => 'ro',
    isa => 'md5_hex',
    lazy => 1,
    default => sub {md5_hex freeze shift}
);

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

MooseX::ConsistentHash::Option - is the bucket for MooseX::ConsistentHash::*
I<Version 0.01>

=head1 SYNOPSIS
.
    use MooseX::ConsistentHash::Option;
    my $option = MooseX::ConsistentHash::Option->new(
        value => $some_value,
        weight => $some_integer
    );

=head1 METHODS

In addition to methods 'value' and 'weight' is available:

=head2 identificator

is a 'lazy' method. By default, returns the 'md5_hex' string from the 'freeze' objects value.

=head1 SEE ALSO

L<MooseX::ConsistentHash>

=head1 AUTHOR

Sivirinov Ivan, E<lt>catamoose at yandex.ruE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10 or,
at your option, any later version of Perl 5 you may have available.

And see L<Set::ConsistentHash>.

=cut
