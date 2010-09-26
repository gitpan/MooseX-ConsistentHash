package MooseX::ConsistentHash::AlgorithmConsistentHashKetama;

our $VERSION = '0.01';

use Algorithm::ConsistentHash::Ketama;

use Moose;
use namespace::autoclean;

with 'MooseX::ConsistentHash::RoleInterface';

has 'ketama' => (
    is => 'ro',
    isa => 'Algorithm::ConsistentHash::Ketama',
    lazy => 1,
    default => sub {Algorithm::ConsistentHash::Ketama->new}
);

sub add_option {
    my ($self,$option) = @_;
    $self->ketama->add_bucket($option->identificator, $option->weight);
    return 1;
};

sub get_option {
    shift->ketama->hash(@_);
};

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 NAME

MooseX::ConsistentHash::AlgorithmConsistentHashKetama - moose version Algorithm::ConsistentHash::Ketama for MooseX::ConsistentHash
I<Version 0.01>

=head1 SYNOPSIS

for example

    use MooseX::ConsistentHash;
    my $hashing = MooseX::ConsistentHash->new(
        class => 'MooseX::ConsistentHash::AlgorithmConsistentHashKetama'
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
    my $hashing = MooseX::ConsistentHash->new();
    $hashing->add_options(
        {option => 'foo1', weight => 1},
        {option => 'foo2', weight => 2}
    );
    my $some = Some->new();
    $hashing->add_option(option => $some, weight => 10);
    my $result_option = $hashing->get_option('some_string');
    # $result_option may be 'foo1' or 'foo2' or $some 

By default, MooseX::ConsistentHash used as 'class' MooseX::ConsistentHash::AlgorithmConsistentHashKetama.

=head1 PROBLEMS

L<MooseX::ConsistentHash> with L<MooseX::ConsistentHash::AlgorithmConsistentHashKetama> slower by 80% than the module L<Algorithm::ConsistentHash::Ketama>

=head1 SEE ALSO

=over

=item 

L<MooseX::ConsistentHash>

=item 

L<Algorithm::ConsistentHash::Ketama>

=back

=head1 AUTHOR

Sivirinov Ivan, E<lt>catamoose at yandex.ruE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10 or,
at your option, any later version of Perl 5 you may have available.

And see L<Algorithm::ConsistentHash::Ketama>.

=cut
