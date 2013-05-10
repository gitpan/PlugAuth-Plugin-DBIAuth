use strict;
use warnings;
use File::HomeDir::Test;
use File::HomeDir;
use File::Spec;
use Test::More;
use PlugAuth;
use YAML ();
use Test::Differences;

if(eval qq{ require DBD::SQLite; 1 })
{
  plan tests => 4;
}
else
{
  plan skip_all => 'Test requires DBD::SQLite';
}

my $home = File::HomeDir->my_home;
mkdir(File::Spec->catdir($home, 'etc'));
my $dbfile = File::Spec->catfile($home, 'auth.sqlite');
YAML::DumpFile(File::Spec->catfile($home, 'etc', 'PlugAuth.conf'), {
  plugins => [ {
    'PlugAuth::Plugin::DBIAuth' => {
      db => {
        dsn  => "dbi:SQLite:dbname=$dbfile",
        user => '',
        pass => '',
      },
      sql => {
        all_users => "SELECT username FROM users",
        init      => "CREATE TABLE users ( username VARCHAR, password VARCHAR )",
      },
    }
  } ],
});

my $app = PlugAuth->new;
isa_ok $app, 'PlugAuth';
isa_ok $app->auth, 'PlugAuth::Plugin::DBIAuth';

eq_or_diff [ sort $app->auth->all_users ], [], "all_users = ()";

$app->auth->dbh->do('INSERT INTO users (username) VALUES (?)', undef, $_) for (qw( foo bar baz ));

eq_or_diff [ sort $app->auth->all_users ], [sort qw( foo bar baz )], "all_users = foo bar baz";
