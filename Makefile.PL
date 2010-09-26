use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'MooseX::ConsistentHash',
    VERSION_FROM      => 'lib/MooseX/ConsistentHash.pm', # finds $VERSION
    PREREQ_PM         => {
                           Digest::MD5 => 0,
                           Moose => 0,
                           Moose::Util::TypeConstraints => 0,
                           Moose::Role => 0,
                           Algorithm::ConsistentHash::Ketama => 0,
                           Set::ConsistentHash => 0
    }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (#ABSTRACT_FROM  => 'lib/MooseX/ConsistentHash.pm', # retrieve abstract from module
       AUTHOR         => 'Sivirinov Ivan <catamoose@yandex.ru>') : ()),
);
