#!perl6

my $password = prompt("enter your CPAN password: ");

template-create "/home/{%*ENV<USER>}/.pause", %(
  mode => '700',
  variables => %(
    user      => 'melezhik',
    password  => $password
  ),
  source => q:to /TEMPL/
  user      [%= user %]
  password  $password
  TEMPL
);
