package MooseX::ConsistentHash;

our $VERSION = '0.01';

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;

use MooseX::ConsistentHash::Option;

# store consistent object after create instance of class
has '_consistent_object' => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub {
        my $self = shift;
        $self->has_hash_option ? $self->class->new($self->hash_option) : $self->class->new();
    }
);

# type describing the class of ConsistentHash with load, if necessary
subtype 'ConsistentClass'
    => as 'ClassName'
    => where {
        $_->does('MooseX::ConsistentHash::RoleInterface');
    }
    => message { "Class '$_' must have role 'MooseX::ConsistentHash::RoleInterface'\n"};

coerce 'ConsistentClass'
    => from 'Str'
    => via {
        Class::MOP::load_class($_); $_;
    };

# the only attribute that should make the constructor, the other attributes are established methods
has 'class' => (
    is => 'ro',
    isa => 'ConsistentClass',
    default => 'MooseX::ConsistentHash::AlgorithmConsistentHashKetama',
    coerce => 1
);

# somr option to init consistent hashing object
has 'hash_option' => (
    is => 'ro',
    isa => 'HashRef',
    predicate => 'has_hash_option'
);

# hold all options
has '_options' => (
    is => 'rw',
    isa => 'HashRef',
    lazy => 1,
    default => sub{ {} }
);

sub add_option {
    my $self = shift;
    my $option = UNIVERSAL::isa($_[0],'MooseX::ConsistentHash::Option') ? $_[0] : MooseX::ConsistentHash::Option->new(@_);
    unless(exists $self->_options->{$option->identificator}) {
        # new option
        return unless $self->_consistent_object->add_option($option);
        $self->_options->{$option->identificator} = $option;
    } elsif ($self->_options->{$option->identificator}->weight ne $option->weight) {
        $self->clear_option($option->identificator);
        return unless $self->_consistent_object->add_option($option);
        $self->_options->{$option->identificator} = $option;
    };
    return $option->identificator;
}

sub add_options {
    my $self = shift;
    return [map {$self->add_option($_)} @_] 
}

sub clear_options {
    my $self = shift;
    $self->_consistent_object($self->has_hash_option ? $self->class->new($self->hash_option) : $self->class->new);
    $self->_options({});
    return 1;
}

sub clear_option {
    my ($self, $identificator) = @_;
    return unless $identificator;
    if (delete $self->_options->{$identificator}) {
        my $options = $self->_options;
        $self->clear_options();
        $self->add_options(values %$options);
        return 1;
    };
    return;
}

sub get_option {
    my $self = shift;
    my $identificator = $self->_consistent_object->get_option(@_);
    return exists $self->_options->{$identificator} ? $self->_options->{$identificator}->option : undef; 
}

sub show_options {
    shift->_options;
}

sub new_weight {
    my ($self, $identificator, $new_weight) = @_;
    return unless ($identificator and int($new_weight) and exists $self->_options->{$identificator});

    $self->_options->{$identificator}->weight($new_weight);
    my $options = $self->_options;
    $self->clear_options();
    $self->add_options(values %$options);    
    
    return 1;
}

__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 NAME

MooseX::ConsistentHash - unified consistent hashing interface
I<Version 0.01>

=head1 SYNOPSIS

some examples

    use MooseX::ConsistentHash;
    
    my $hashing = MooseX::ConsistentHash->new();
    -- or --
    my $hashing = MooseX::ConsistentHash->new(
        class => 'MooseX::ConsistentHash::AlgorithmConsistentHashKetama'
    );
    -- or --
    use Digest::JHash qw();
    my $hashing = MooseX::ConsistentHash->new(
        class => 'MooseX::ConsistentHash::SetConsistentHash', 
        init_hash => {hash_func => \&Digest::JHash::jhash}
    );
    -- or --
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

=head1 DESCRIPTION

MooseX::ConsistentHash provides a unified consistent hashing API.
By default, this module can work with L<Algorithm::ConsistentHash::Ketama>,L<Set::ConsistentHash> and any of your module for consistent hashing.

=head2 METHODS

=head3 new

It takes two parameters:

=over

=item 

class - name class for consistent hashing. The class must support the role of L<MooseX::ConsistentHash::RoleInterface>.
By default class is L<MooseX::ConsistentHash::AlgorithmConsistentHashKetama>

=item 

init_hash - optional hashref argument. He will be transferred to a constructor consistent hashing class. 

=back

=head3 add_option(option => $some, weight => $integer_weight)

This method added option to the consistent hashing instance through L<MooseX::ConsistentHash::Option> object.
Return identificator option or undef.

=head3 add_options({option => $some, weight => $integer_weight},...)

Some sugar.
Return list identificators options.

=head3 new_weight($identificator, $new_weight)

change weight for current identificator.
retuns true if succeful.

=head3 clear_options

remove all options and reinint instance consistent hashing.
retuns true if succeful.

=head3 clear_option($identificator)

remove one option.
retuns true if succeful.

=head3 show_options

return hashref all options (keys are identificators)

=head3 get_option($key)

select the option in the set to which that key is mapped and returns value.

=head1 PROBLEMS

L<MooseX::ConsistentHash> with L<MooseX::ConsistentHash::AlgorithmConsistentHashKetama> or L<MooseX::ConsistentHash::SetConsistentHash> slower by 80% than the original module L<Algorithm::ConsistentHash::Ketama> or L<Set::ConsistentHash>.

=head1 SEE ALSO

=over

=item 

L<MooseX::ConsistentHash::RoleInterface>, L<MooseX::ConsistentHash::Option>

=item 

L<MooseX::ConsistentHash::AlgorithmConsistentHashKetama>, L<Algorithm::ConsistentHash::Ketama>

=item 

L<MooseX::ConsistentHash::SetConsistentHash>, L<Set::ConsistentHash>

=back

=head1 AUTHOR

Sivirinov Ivan, E<lt>catamoose at yandex.ruE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10 or,
at your option, any later version of Perl 5 you may have available.

And see L<Algorithm::ConsistentHash::Ketama>, L<Set::ConsistentHash>.

=cut