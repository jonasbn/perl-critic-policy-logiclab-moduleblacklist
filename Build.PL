# Build.PL for Perl::Critic::Policy::logicLAB::ModuleBlacklist

# $Id: Build.PL 7707 2011-06-08 21:19:25Z jonasbn $

use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    dist_author       => 'Jonas B. Nielsen, (jonasbn) <jonasbn@cpan.org>',
    module_name       => 'Perl::Critic::Policy::logicLAB::ModuleBlacklist',
    dist_version_from => 'lib/Perl/Critic/Policy/logicLAB/ModuleBlacklist.pm',
    license           => 'artistic_2',

#REF: http://logicLAB.jira.com/wiki/display/OPEN/Module-Build#Module-Build-AutogeneratetheMakefile.PLforbackwardscompatibility
    create_makefile_pl   => 'traditional',
    create_readme        => 1,
    recursive_test_files => 1,
    create_license       => 1,
    configure_requires   => { 'Module::Build' => '0.40' },
    requires             => {
        'Perl::Critic::Policy' => '0',
        'Perl::Critic::Utils'  => '0',
        'perl'                 => '5.8.0',
        'Carp'                 => '0', #core
        'Data::Dumper'         => '0', #core
    },
    build_requires => {
        'Test::Perl::Critic'  => '0',
    },
    meta_merge => {
        resources => {
            homepage =>
                'https://github.com/jonasbn/Perl-Critic-Policy-logicLAB-ModuleBlacklist',
            bugtracker =>
                'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-Policy-logicLAB-ModuleBlacklist',
            repository =>
                'https://github.com/jonasbn/Perl-Critic-Policy-logicLAB-ModuleBlacklist',
        }
    },
);
$build->create_build_script();

__END__

=pod

=head1 SEE ALSO

=over

=item * L<http://logicLAB.jira.com/wiki/display/OPEN/Module-Build#Module-Build-AutogeneratetheMakefile.PLforbackwardscompatibility>

=back

=cut
