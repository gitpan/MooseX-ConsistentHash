package MooseX::ConsistentHash::SetConsistentHash;

our $VERSION = '0.01';

use Set::ConsistentHash;
use Digest::MD5 qw();

use Moose;
use namespace::autoclean;

with 'MooseX::ConsistentHash::RoleInterface';

has 'hash_func' => (
    is => 'ro',
    isa => 'Any',
    default => sub { return \&Digest::MD5::md5_hex},
    required => 1   
);

has 'consistent_hash' => (
    is => 'ro',
    isa => 'Set::ConsistentHash',
    lazy => 1,
    default => sub {
        my $self = shift;
        my $hash = Set::ConsistentHash->new;
        $hash->set_hash_func($self->hash_func);
        $hash;
    }
);

sub add_option {
    my ($self,$option) = @_;
    $self->consistent_hash->set_target($option->identificator => $option->weight);
    return 1;
};

sub get_option {
    shift->consistent_hash->get_target(@_);
};

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

MooseX::ConsistentHash::SetConsistentHash - moose version Set::ConsistentHash for MooseX::ConsistentHash
I<Version 0.01>

=head1 SYNOPSIS

for example

    use Digest::JHash qw();
    use MooseX::ConsistentHash;
    my $hashing = MooseX::ConsistentHash->new(
        class => 'MooseX::ConsistentHash::SetConsistentHash', 
        init_hash => {hash_func => \&Digest::JHash::jhash}
    );
    $hashing->add_options(
        {option => 'foo1', weight => 1},
        {option => 'foo2', weight => 2}
    );
    my $some = Some->new();
    $hashing->add_option(option => $some, weight => 10);
    my $result_option = $hashing->get_option('some_string');
    # $result_option may be 'foo1' or 'foo2' or $some  


=head2 MORE EXAMPLE

another example

    use MooseX::ConsistentHash;
    my $hashing = MooseX::ConsistentHash->new(
        class => 'MooseX::ConsistentHash::SetConsistentHash'
    );
    $hashing->add_options(
        {option => 'foo1', weight => 1},
        {option => 'foo2', weight => 2}
    );
    my $some = Some->new();
    $hashing->add_option(option => $some, weight => 10);
    my $result_option = $hashing->get_option('some_string');
    # $result_option may be 'foo1' or 'foo2' or $some 

By default, MooseX::ConsistentHash::SetConsistentHash used as hash_func Digest::MD5::md5_hex

=head1 PROBLEMS

L<MooseX::ConsistentHash> with L<MooseX::ConsistentHash::SetConsistentHash> slower by 80% than the module L<Set::ConsistentHash>

=head1 SEE ALSO

=over

=item 

L<MooseX::ConsistentHash>

=item 

L<Set::ConsistentHash>

=back

=head1 AUTHOR

Sivirinov Ivan, E<lt>catamoose at yandex.ruE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10 or,
at your option, any later version of Perl 5 you may have available.

And see L<Set::ConsistentHash>.

=cut
