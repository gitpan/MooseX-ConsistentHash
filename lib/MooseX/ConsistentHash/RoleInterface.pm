package MooseX::ConsistentHash::RoleInterface;

our $VERSION = '0.01';

use Moose::Role;

# set option
requires 'add_option';

# get choiced identificator
requires 'get_option';


1;
__END__

=head1 NAME

MooseX::ConsistentHash::RoleInterface - abstract interface for MooseX::ConsistentHash::*
I<Version 0.01>

=head1 DESCRIPTION

If you want to add your own MooseX::ConsistentHash::* module, which will be available for use in L<MooseX::ConsistentHash>, then you should use this class as a role.

=head2 Abstaract methods

=head3 add_option($option)

option is a L<MooseX::ConsistentHash::Option> object.
$option-E<gt>identificator and $option-E<gt>weight are all you need.  

=head3 get_option($thing)

'thing' is a string for which your module should return the appropriate option.
You must return $option-E<gt>identificator 

=head1 EXAMPLE

=over

=item 

L<MooseX::ConsistentHash::AlgorithmConsistentHashKetama>

=item 

L<MooseX::ConsistentHash::SetConsistentHash>

=back

=head1 SEE ALSO

=over

=item 

L<MooseX::ConsistentHash>

=item 

L<MooseX::ConsistentHash::Option>

=back

=head1 AUTHOR

Sivirinov Ivan, E<lt>catamoose at yandex.ruE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10 or,
at your option, any later version of Perl 5 you may have available.

=cut
