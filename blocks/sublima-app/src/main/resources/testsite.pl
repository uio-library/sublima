use Test::More tests => 5;
use Test::WWW::Mechanize;

# Documentation is at http://search.cpan.org/dist/Test-WWW-Mechanize/Mechanize.pm

# Set to where we want to start the test
my $baseurl = 'http://tigger.computas.int:8180/sublima-webapp-1.0-SNAPSHOT/';

my $mech = Test::WWW::Mechanize->new;
$mech->get_ok( $baseurl );
#$mech->html_lint_ok( "Invalid HTML" );
$mech->content_contains( "Sublima" );
$mech->submit_form_ok(
		      { form_number => 1,
			fields => { searchstring => 'vondt'},
		      }, "Found form and searched for vondt");
$mech->content_contains( "RSS" );
$mech->content_contains( ": 77" );
