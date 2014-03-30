package Perl::Critic::Policy::logicLAB::ModuleBlacklist;

# $Id: ProhibitShellDispatch.pm 8114 2013-07-25 12:57:04Z jonasbn $

use strict;
use warnings;
use 5.008;

use base 'Perl::Critic::Policy';
use Perl::Critic::Utils qw{ $SEVERITY_MEDIUM :booleans};
use Carp qw(carp);
use Data::Dumper;

our $VERSION = '0.01';

use constant supported_parameters => qw(modules debug);
use constant default_severity     => $SEVERITY_MEDIUM;
use constant default_themes       => qw(logiclab);

sub applies_to {
    return (
        qw(
            PPI::Statement::Include
            )
    );
}

sub violates {
    my ( $self, $elem ) = @_;

    if ( not $self->{_modules} ) {
        return;
    }

    my @children = $elem->children;

    if ( $children[0]->content eq 'use' ) {

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
                        $elem
                    );

                } else {

                    return $self->violation(
                        "Blacklisted: $package is not recommended by required standard",
                        "Use alternative implementation or module instead of $package",
                        $elem
                    );
                }
            }
        }

    } else {
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
        warn "Blacklisted modules are: $modules\n";
    }

    #parsing blacklisted modules, see also _parse_blacklist
    if ($modules) {
        $self->{_modules} = $self->_parse_modules($modules) || q{};
    }

    return $TRUE;
}

sub _parse_modules {
    my ( $self, $config_string ) = @_;

    if ( $self->{debug} ) {
        warn "Blacklist config_string is: ", $config_string;
    }

    my @parameters = split /\s*,\s*/, $config_string;
    my %modules;

    if ( $self->{debug} ) {
        warn "Blacklist parameters are: ", Dumper \@parameters;
    }

    foreach my $parameter (@parameters) {
        if ( $parameter =~ m/\s*=>\s*/ ) {
            my @p = split /\s*=>\s*/, $parameter;

            $modules{ $p[0] } = $p[1];
        } else {
            $modules{$parameter} = undef;
        }
    }

    if ( $self->{debug} ) {
        print STDERR "our split line:\n";
        print STDERR Dumper \%modules;
    }

    return \%modules;
}

1;

__END__

=pod

=head1 NAME

Perl::Critic::Policy::logicLAB::ModuleBlacklist - blacklist modules you do not want in your code base

=head1 AFFILIATION

This policy is a policy in the Perl::Critic::logicLAB distribution. The policy
is themed: logiclab.

=head1 VERSION

This documentation describes version 0.01.

=head1 DESCRIPTION

=head1 SEE ALSO

=over

=item * L<Perl::Critic>

=item * perlmod manpage: L<http://perldoc.perl.org/perlmod.html>

=item * L<http://logiclab.jira.com/wiki/display/PCPLRPNP/Home>

=item * L<http://logiclab.jira.com/wiki/display/PCLL/Home>

=back

=head1 AUTHOR

=over

=item * Jonas B. Nielsen, jonasbn C<< <jonasbn@cpan.org> >>

=back

=head1 ACKNOWLEDGEMENT

=over

=item * Jeffrey Ryan Thalhammer (THALJEF) and the Perl::Critic contributors for
Perl::Critic

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2014 Jonas B. Nielsen, jonasbn. All rights reserved.

Perl::Critic::Policy::logicLAB::ModuleBlacklist;  is released under
the Artistic License 2.0

The distribution is licensed under the Artistic License 2.0, as specified by
the license file included in this distribution.

=cut
