# NAME

Perl::Critic::Policy::Module::ModuleBlacklist - blacklist modules you want to prohibit use of

# AFFILIATION

This policy has no affiliation The policy is themed: `logiclab` and `maintenance`.

# VERSION

This documentation describes version 1.00

# DESCRIPTION

This policy can be used to specify a list of unwanted modules. Using a blacklisting, so if the
modules are used in the evaluated code a violation is triggered.

In addition to blacklisting modules it is possible to recommend alternatives to
blacklisted modules.

And alternative could be Perl::Critic core has [Perl::Critic::Policy::Modules::ProhibitEvilModules](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitEvilModules). which offers a solution in the same problem area.

# CONFIGURATION AND ENVIRONMENT

## modules

You can blacklist modules using the configuration parameter **modules**

    [Module::ModuleBlacklist]
    modules = IDNA::Punycode

If you want to blacklist multiple modules specify using a comma separated list:

    [Module::ModuleBlacklist]
    modules = Try::Tiny, Contextual::Return, IDNA::Punycode

If you want to recommend alternatives to, use fat comma in addition

    [Module::ModuleBlacklist]
    modules = Try::Tiny => TryCatch, Contextual::Return, IDNA::Punycode => Net::IDN::Encode

# DEPENDENCIES AND REQUIREMENTS

- [Perl](https://metacpan.org/pod/Perl) 5.8.0 syntactically for the actual implementation
- [Perl 5.14](https://metacpan.org/pod/release/JESSE/perl-5.14.0/pod/perl.pod) for developing the distribution, which relies on [Dist::Zilla](http://dzil.org/). The features on which this policy relies, where introduced in Perl 5.14, but this does not make for an actual requirement for the policy only the recommendations it imposes.
- [Module::Build](https://metacpan.org/pod/Module::Build)
- [Perl::Critic](https://metacpan.org/pod/Perl::Critic)
- [Perl::Critic::Utils](https://metacpan.org/pod/Perl::Critic::Utils)
- [Perl::Critic::Policy](https://metacpan.org/pod/Perl::Critic::Policy)
- [Test::More](https://metacpan.org/pod/Test::More)
- [Test::Perl::Critic](https://metacpan.org/pod/Test::Perl::Critic)
- [Data::Dumper](https://metacpan.org/pod/Data::Dumper)
- [Carp](https://metacpan.org/pod/Carp)

# INCOMPATIBILITIES

This distribution has no known incompatibilities.

# BUGS AND LIMITATIONS

There are no known bugs or limitations

# TEST AND QUALITY

The following policies have been disabled for this distribution

- [Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma](https://metacpan.org/pod/Perl::Critic::Policy::ValuesAndExpressions::ProhibitConstantPragma)

    Constants are good, - see the link below.

    - [https://logiclab.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma](https://logiclab.jira.com/wiki/display/OPEN/Perl-Critic-Policy-ValuesAndExpressions-ProhibitConstantPragma)

- [Perl::Critic::Policy::NamingConventions::Capitalization](https://metacpan.org/pod/Perl::Critic::Policy::NamingConventions::Capitalization)

See also `t/perlcriticrc`

## TEST COVERAGE

Coverage test executed the following way, the coverage report is based on the
version described in this documentation (see ["VERSION"](#version)).

    ./Build testcover

    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    File                           stmt   bran   cond    sub    pod   time  total
    ---------------------------- ------ ------ ------ ------ ------ ------ ------
    ...Module/ModuleBlacklist.pm   92.4   70.0   62.5  100.0  100.0  100.0   87.3
    Total                          92.4   70.0   62.5  100.0  100.0  100.0   87.3
    ---------------------------- ------ ------ ------ ------ ------ ------ ------

# BUG REPORTING

Please report issues via CPAN RT:

    http://rt.cpan.org/NoAuth/Bugs.html?Dist=Perl-Critic-Policy-logicLAB-ModuleBlacklist

or by sending mail to

    bug-Perl-Critic-Policy-logicLAB-ModuleBlacklist@rt.cpan.org

# SEE ALSO

- [Perl::Critic](https://metacpan.org/pod/Perl::Critic)
- [Perl::Critic::Policy::Modules::ProhibitEvilModules](https://metacpan.org/pod/Perl::Critic::Policy::Modules::ProhibitEvilModules)
- [Website](http://jonasbn.github.io/perl-critic-policy-module-moduleblacklist/)

# MOTIVATION

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

# RECOMMENDATIONS

Here follows some recommendations I have picked up.

- [Error](https://metacpan.org/pod/Error) should be replaced by [Class::Exception](https://metacpan.org/pod/Class::Exception), by recommendation
of the author
- [IDNA::Punycode](https://metacpan.org/pod/IDNA::Punycode) should be replaced by [Net::IDN::Encode](https://metacpan.org/pod/Net::IDN::Encode) by recommendation of the author, who wrote both
- [File::Slurp](https://metacpan.org/pod/File::Slurp) should be replaced by either [File::Slurper](https://metacpan.org/pod/File::Slurper), [Path::Tiny](https://metacpan.org/pod/Path::Tiny) or [IO::All](https://metacpan.org/pod/IO::All) See also blog post: "[File::Slurp is broken and wrong](http://blogs.perl.org/users/leon_timmermans/2015/08/fileslurp-is-broken-and-wrong.html)" by Leon Timmermans
- [File::Stat](https://metacpan.org/pod/File::Stat) should be replaced by [File::stat](https://metacpan.org/pod/File::stat)

# AUTHOR

- Jonas B. Nielsen, jonasbn `<jonasbn@cpan.org>`

# ACKNOWLEDGEMENTS

- Perl::Critic authors and maintainers for Perl::Critic
- Milan Šorm for the first and second bug reports on this policy

# LICENSE AND COPYRIGHT

Copyright (c) 2014-2019 Jonas B. Nielsen, jonasbn. All rights reserved.

Perl::Critic::Policy::Module::ModuleBlacklist is released under
the Artistic License 2.0

The distribution is licensed under the Artistic License 2.0, as specified by
the license file included in this distribution.
