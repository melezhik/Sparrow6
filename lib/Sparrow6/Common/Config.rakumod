#!raku

unit module Sparrow6::Common::Config;

my %config;
my $os;


sub config() is export {

  return %config if %config;

  if %*ENV<SP6_CONFIG> {

    %*ENV<SP6_CONFIG>.IO ~~ :e or die "configuration file {%*ENV<SP6_CONFIG>} does not exist";
    %config = (EVALFILE %*ENV<SP6_CONFIG>);

  }

  return %config;

}

sub set-config(%c) is export {
  %config = %c;
}

sub os() is export {

return 'windows' if $*DISTRO.is-win;

return $os if $os;

my $script = slurp %?RESOURCES<os-resolver.sh>;

$os = qqx{$script};

}

# this is deprecated alias
# you should os() instead

sub target_os is export {
  os();
}

sub os-resolver is export {
  slurp %?RESOURCES<os-resolver.sh>;
}

