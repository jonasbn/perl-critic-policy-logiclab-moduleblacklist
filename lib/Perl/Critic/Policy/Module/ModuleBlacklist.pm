package Perl::Critic::Policy::Module::ModuleBlacklist;

use strict;
use warnings;
use 5.008;

use base 'Perl::Critic::Policy';
use Perl::Critic::Utils qw{ $SEVERITY_MEDIUM :booleans};
use Carp qw(carp);
use Data::Dumper;

our $VERSION = '1.00';

use constant supported_parameters => qw(modules debug);
use constant default_severity     => $SEVERITY_MEDIUM;
use constant default_themes       => qw(logiclab maintenance);

sub applies_to {
    return (
        qw(
          PPI::Statement::Include
          )
    );
}

sub violates {
    my ( $self, $elem ) = @_;

    #Policy not configured, nothing to assert
    if ( not $self->{_modules} ) {
        return;
    }

    my @children = $elem->children;

    if ( $children[0]->content eq 'use' or $children[0]->content eq 'require' )
    {

        my $package = $children[2]->content;

        if ( $self->{debug} ) {
            print STDERR "located include: $package\n";
        }

        foreach my $module ( keys %{ $self->{_modules} } ) {

            if ( $package eq $module ) {

                if ( defined $self->{_modules}->{$module} ) {
                    my $recommendation = $self->{_modules}->{$module};
                    return $self->violation(
"Blacklisted: $package is not recommended by required standard",
"Use recommended module: $recommendation instead of $package",
                        $elem,
                    );

                }
                else {

                    return $self->violation(
"Blacklisted: $package is not recommended by required standard",
"Use alternative implementation or module instead of $package",
                        $elem,
                    );
                }
            }
        }

        #we ignore negative use statements, they are for pragma [issue1]
    }
    elsif ( $children[0]->content eq 'no' ) {
        if ( $self->{debug} ) {
            print STDERR "located 'no' use/require statement\n";
        }
    }
    else {
        carp 'Unable to locate package keyword';
    }

    return;
}

sub initialize_if_enabled {
    my ( $self, $config ) = @_;

    #debug - order is significant, since we might need debugging
    $self->{debug} = $config->get('debug') || $FALSE;

    #Names:
    #fetching list of blacklisted modules
    my $modules = $config->get('modules');

    if ( $self->{debug} ) {
        carp "Blacklisted modules are: $modules\n";
    }

    #parsing blacklisted modules, see also _parse_blacklist
    if ($modules) {
        $self->{_modules} = $self->_parse_modules($modules) || q{};
    }

    return $TRUE;
}

sub _parse_modules {
    my ( $self, $config_string ) = @_;

    #first we split on commas
    my @parameters = split /\s*,\s*/, $config_string;
    my %modules;

    #then we split on fat commas, to locate recommendations
    foreach my $parameter (@parameters) {
        if ( $parameter =~ m/\s*=>\s*/ ) {
            my @p = split /\s*=>\s*/, $parameter;

            $modules{ $p[0] } = $p[1];
        }
        else {
            $modules{$parameter} = undef;
        }
    }

    return \%modules;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Perl::Critic::Policy::Module::ModuleBlacklist - blacklist modules you want to prohibit use of

=head1 AFFILIATION

This policy has no affiliation The policy is themed: C<logiclab> and C<maintenance>.

=head1 VERSION

This documentation describes version 1.00

=head1 DESCRIPTION

This policy can be used to specify a list of unwanted modules. Using a blacklisting, so if the
modules are used in the evaluated code a violation is triggered.

In addition to blacklisting modules it is possible to recommend alternatives to
blacklisted modules.

And alternative could be Perl::Critic core has L<Perl::Critic::Policy::Modules::ProhibitEvilModules|https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitEvilModules>. which offers a solution in the same problem area.

=head1 CONFIGURATION AND ENVIRONMENT

=head2 modules

You can blacklist modules using the configuration parameter B<modules>

    [Module::ModuleBlacklist]
    modules = IDNA::Punycode

If you want to blacklist multiple modules specify using a comma separated list:

    [Module::ModuleBlacklist]
    modules = Try::Tiny, Contextual::Return, IDNA::Punycode

If you want to recommend alternatives to, use fat comma in addition

    [Module::ModuleBlacklist]
    modules = Try::Tiny => TryCatch, Contextual::Return, IDNA::Punycode => Net::IDN::Encode

=head1 DEPENDENCIES AND REQUIREMENTS

=over

=item * L<Perl> 5.8.0 syntactically for the actual implementation

=item * L<Perl 5.14|https://metacpan.org/pod/release/JESSE/perl-5.14.0/pod/perl.pod> for developing the distribution, which relies on L<Dist::Zilla|http://dzil.org/>. The features on which this policy relies, where introduced in Perl 5.14, but this does not make for an actual requirement for the policy only the recommendations it imposes.

=item * L<Module::Build>

=item * L<Perl::Critic>

=item * L<Perl::Critic::Utils>

=item * L<Perl::Critic::Policy>

=item * L<Test::More>

=item * L<Test::Perl::Critic>

=item * L<Data::Dumper>

=item * L<Carp>

=back

=head1 INCOMPATIBILITIES

This distribution has no known incompatibilities.

=head1 BUGS AND LIMITATIONS

There are no known bugs or limitations

=head1 TEST AND QUALITY

The following policies have been disabled for this distribution

=over

=item * L<Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma>

Constants are good, - see the link below.

=over

=item * L<https://logiclab.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma>

=back

=item * L<Perl::Critic::Policy::NamingConventions::Capitalization>

=back

See also F<t/perlcriticrc>

=head2 TEST COVERAGE

Coverage test executed the following way, the coverage report is based on the
version described in this documentation (see L</VERSION>).

    ./Build testcover

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    ...Module/ModuleBlacklist.pm   92.4   70.0   62.5  100.0  100.0  100.0   87.3
    Total                          92.4   70.0   62.5  100.0  100.0  100.0   87.3
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 BUG REPORTING

Please report issues via CPAN RT:

  http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-Policy-logicLAB-ModuleBlacklist

or by sending mail to

  bug-Perl-Critic-Policy-logicLAB-ModuleBlacklist@rt.cpan.org

=head1 SEE ALSO

=over

=item * L<Perl::Critic>

=item * L<Perl::Critic::Policy::Modules::ProhibitEvilModules|https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitEvilModules>

=item * L<Website|http://jonasbn.github.io/perl-critic-policy-module-moduleblacklist/>

=back

=head1 MOTIVATION

I once read an article which compared programming languages to
natural languages. Programming languages in themselves are not
large as such, but if you also regard the APIs, data structures
and components a computer programmer use on a daily basis, the
amount is enormous.

Where I work We try to keep a more simple code base, the complexity
is in our business and that is our primary problem area, so it should
not be difficult to understand the code used to model this complexity.

So sometimes it is necessary to make a decision on what should be
allowed in our code base and what should not. This policy aims to
support this coding practice.

The practice it basically to prohibit problematic components and
recommend alternatives where possible.

=head1 RECOMMENDATIONS

Here follows some recommendations I have picked up.

=over

=item * L<Error> should be replaced by L<Class::Exception>, by recommendation
of the author

=item * L<IDNA::Punycode> should be replaced by L<Net::IDN::Encode> by recommendation of the author, who wrote both

=item * L<File::Slurp> should be replaced by either L<File::Slurper>, L<Path::Tiny> or L<IO::All> See also blog post: "L<File::Slurp is broken and wrong|http://blogs.perl.org/users/leon_timmermans/2015/08/fileslurp-is-broken-and-wrong.html>" by Leon Timmermans

=item * L<File::Stat> should be replaced by L<File::stat>

=back

=head1 AUTHOR

=over

=item * Jonas B. Nielsen, jonasbn C<< <jonasbn@cpan.org> >>

=back

=head1 ACKNOWLEDGEMENTS

=over

=item * Perl::Critic authors and maintainers for Perl::Critic

=item * Milan Šorm for the first and second bug reports on this policy

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2014-2019 Jonas B. Nielsen, jonasbn. All rights reserved.

Perl::Critic::Policy::Module::ModuleBlacklist is released under
the Artistic License 2.0

The distribution is licensed under the Artistic License 2.0, as specified by
the license file included in this distribution.

=cut