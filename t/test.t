
# $Id: test.t 7587 2011-04-16 16:00:36Z jonasbn $

use strict;
use warnings;

use Env qw($TEST_VERBOSE);
use Data::Dumper;
use Test::More qw(no_plan);

use_ok 'Perl::Critic::Policy::logicLAB::ModuleBlacklist';

require Perl::Critic;
my $critic = Perl::Critic->new(
    '-profile'       => 't//example.conf',
    '-single-policy' => 'logicLAB::ModuleBlacklist'
);
{
    my @p = $critic->policies;
    is( scalar @p, 1, 'single policy ModuleBlacklist' );

    my $policy = $p[0];

    if ($TEST_VERBOSE) {
        diag Dumper $policy;
    }
}

my $str = q{package Acme::BadCode;

use Contextual::Return;
use Try::Tiny;
use IDNA::Encode;
};

my @violations = $critic->critique( \$str );

is( scalar @violations, 3 );

foreach my $violation (@violations) {
    is( $violation->explanation,
        q{Use Params::Validate for public facing APIs} );
    is( $violation->description,
        q{Parameter validation not complying with required standard} );
}

if ($TEST_VERBOSE) {
    diag Dumper \@violations;
}

