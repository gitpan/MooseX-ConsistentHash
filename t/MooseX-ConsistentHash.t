# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl MooseX-ConsistentHash.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 57;
BEGIN { 
    use_ok('MooseX::ConsistentHash');
    use_ok('MooseX::ConsistentHash::Option');
    use_ok('MooseX::ConsistentHash::AlgorithmConsistentHashKetama');
    use_ok('MooseX::ConsistentHash::SetConsistentHash');
    use_ok('Digest::MD5');
};

can_ok('MooseX::ConsistentHash', 'new');
my $consistent = MooseX::ConsistentHash->new();
ok(defined $consistent eq 1, 'create object');
isa_ok($consistent, 'MooseX::ConsistentHash');
ok($consistent->class eq 'MooseX::ConsistentHash::AlgorithmConsistentHashKetama', 'default hash class');
can_ok($consistent->class, 'add_option');
can_ok($consistent->class, 'get_option');
ok($consistent->class->does('MooseX::ConsistentHash::RoleInterface') eq 1, 'check role');
my $identificator = $consistent->add_option(option => 'foo',weight => 10); 
ok(defined $identificator eq 1, 'consistent object succeful add option');
my $md5 = Digest::MD5->new;
ok(defined $consistent->add_option(option => $md5,weight => 10) eq 1, 'consistent object succeful add object option');
ok(defined $consistent->clear_option($identificator) eq 1, 'deleted option is succeful');
ok(int($consistent->clear_option('dummy')||0) eq 0, 'delete fiction identificator');
ok(defined $consistent->get_option('some') eq 1, 'get_option test');
isa_ok($consistent->get_option('some'), 'Digest::MD5');
ok($consistent->clear_options() eq 1, 'clear all options');
ok(scalar(grep {$_} @{$consistent->add_options({option => $md5,weight => 10},{option => 'dummy',weight => 50})}) eq 2, 'add options');
$consistent->add_option(option => 'some',weight => 10);
ok(scalar keys %{$consistent->show_options} eq 3, 'correct set option');
ok(ref $consistent->show_options eq 'HASH', 'check show options');
$consistent->clear_options();
ok($#{keys %{$consistent->show_options}} eq '-1', 'correct clear options');

$consistent = MooseX::ConsistentHash->new(class => 'MooseX::ConsistentHash::SetConsistentHash');
ok(defined $consistent eq 1, 'create object on MooseX::ConsistentHash::SetConsistentHash');
isa_ok($consistent, 'MooseX::ConsistentHash');
ok($consistent->class eq 'MooseX::ConsistentHash::SetConsistentHash', 'default hash class');
can_ok($consistent->class, 'add_option');
can_ok($consistent->class, 'get_option');
ok($consistent->class->does('MooseX::ConsistentHash::RoleInterface') eq 1, 'check role');
$identificator = $consistent->add_option(option => 'foo',weight => 10); 
ok(defined $identificator eq 1, 'consistent object succeful add option');
$md5 = Digest::MD5->new;
ok(defined $consistent->add_option(option => $md5,weight => 10) eq 1, 'consistent object succeful add object option');
ok(defined $consistent->clear_option($identificator) eq 1, 'deleted option is succeful');
ok(int($consistent->clear_option('dummy')||0) eq 0, 'delete fiction identificator');
ok(defined $consistent->get_option('some') eq 1, 'get_option test');
isa_ok($consistent->get_option('some'), 'Digest::MD5');
ok($consistent->clear_options() eq 1, 'clear all options');
ok(scalar(grep {$_} @{$consistent->add_options({option => $md5,weight => 10},{option => 'dummy',weight => 50})}) eq 2, 'add options');
ok(ref $consistent->show_options eq 'HASH', 'check show options');
ok(scalar keys %{$consistent->show_options} eq 2, 'correct set option');
ok($consistent->_consistent_object->hash_func->('dummy') eq Digest::MD5::md5_hex('dummy'), 'check hash function');


$consistent = MooseX::ConsistentHash->new(class => 'MooseX::ConsistentHash::SetConsistentHash', hash_option => {hash_func => \&Digest::MD5::md5});
ok(defined $consistent eq 1, 'create object on MooseX::ConsistentHash::SetConsistentHash');
isa_ok($consistent, 'MooseX::ConsistentHash');
ok($consistent->class eq 'MooseX::ConsistentHash::SetConsistentHash', 'default hash class');
can_ok($consistent->class, 'add_option');
can_ok($consistent->class, 'get_option');
ok($consistent->class->does('MooseX::ConsistentHash::RoleInterface') eq 1, 'check role');
$identificator = $consistent->add_option(option => 'foo',weight => 10); 
ok(defined $identificator eq 1, 'consistent object succeful add option');
$md5 = Digest::MD5->new;
ok(defined $consistent->add_option(option => $md5,weight => 10) eq 1, 'consistent object succeful add object option');
ok(defined $consistent->clear_option($identificator) eq 1, 'deleted option is succeful');
ok(int($consistent->clear_option('dummy')||0) eq 0, 'delete fiction identificator');
ok(defined $consistent->get_option('some') eq 1, 'get_option test');
isa_ok($consistent->get_option('some'), 'Digest::MD5');
ok($consistent->clear_options() eq 1, 'clear all options');
ok(scalar(grep {$_} @{$consistent->add_options({option => $md5,weight => 10},{option => 'dummy',weight => 50})}) eq 2, 'add options');
ok(ref $consistent->show_options eq 'HASH', 'check show options');
ok(scalar keys %{$consistent->show_options} eq 2, 'correct set option');
ok($consistent->_consistent_object->hash_func->('dummy') eq Digest::MD5::md5('dummy'), 'check hash function');


#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

