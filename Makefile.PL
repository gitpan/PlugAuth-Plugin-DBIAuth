
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "DBI Authentication back end for PlugAuth",
  "AUTHOR" => "Graham Ollis <gollis\@sesda3.com>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "PlugAuth-Plugin-DBIAuth",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "PlugAuth::Plugin::DBIAuth",
  "PREREQ_PM" => {
    "Crypt::PasswdMD5" => 0,
    "DBI" => 0,
    "Log::Log4perl" => 0,
    "PlugAuth" => 0,
    "PlugAuth::Role::Auth" => 0,
    "PlugAuth::Role::Plugin" => 0,
    "Role::Tiny::With" => 0
  },
  "TEST_REQUIRES" => {
    "File::HomeDir" => 0,
    "File::HomeDir::Test" => 0,
    "File::Spec" => 0,
    "PlugAuth" => 0,
    "Test::Differences" => 0,
    "Test::More" => 0,
    "Test::PlugAuth::Plugin::Auth" => 0,
    "YAML" => 0
  },
  "VERSION" => "0.02",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



