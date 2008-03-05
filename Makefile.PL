use inc::Module::Install 0.68;

if ( -e 'MANIFEST.SKIP' ) {
    system( 'pod2text lib/Catalyst/Model/DBIC.pm > README' );
}

name 'Catalyst-Model-DBIC';
all_from 'lib/Catalyst/Model/DBIC.pm';

requires 'Catalyst::Runtime' => '5.0000';
requires 'DBIx::Class';
requires 'DBIx::Class::Loader';

test_requires 'Test::More';

print <<EOWARNING;
****************************************************
This module has been deprecated. You should be using
Catalyst::Model::DBIC::Schema instead.
****************************************************
EOWARNING

auto_install;
WriteAll;
