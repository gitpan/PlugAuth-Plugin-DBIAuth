use strict;
use warnings;
use File::HomeDir::Test;
use File::HomeDir;
use File::Spec;
use Test::More;
use PlugAuth;
use YAML ();

if(eval qq{ require DBD::SQLite; 1 })
{
  plan tests => 9;
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
        check_credentials => "SELECT password FROM users WHERE username = ?",
        init              => "CREATE TABLE users ( username VARCHAR, password VARCHAR )",
      },
    }
  } ],
});

my $app = PlugAuth->new;
isa_ok $app, 'PlugAuth';
isa_ok $app->auth, 'PlugAuth::Plugin::DBIAuth';

$app->auth->dbh->do('INSERT INTO users (username, password) VALUES (?,?)', undef, 'optimus','ZL3D6w7QAFAK.'); # optimus:matrix

is $app->auth->check_credentials('optimus',   'matrix'), 1, "optimus matrix is good";
is $app->auth->check_credentials('optimus',   'badpas'), 0, "optimus badpas is bad";
is $app->auth->check_credentials('galvatron', 'matrix'), 0, "galvatron matrix is bad";

$app->auth->dbh->do('INSERT INTO users (username, password) VALUES (?,?)', undef, 'rodimus', '$apr1$WHAldQQD$eQdIoS1n9pVIkYTxPoGl.0'); # rodimus:cybetron

is $app->auth->check_credentials('rodimus',   'cybertron'), 1, "rodimus cybertron is good";
is $app->auth->check_credentials('rodimus',   'badpas'),    0, "rodimus badpas is bad";
is $app->auth->check_credentials('galvatron', 'matrix'),    0, "galvatron matrix is bad";

pass 'test count is divisible by 3';
