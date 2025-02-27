#!perl6 

=begin tomty
%(
  tag => "dsl"
)
=end tomty

systemd-service "long-dream", %(
  :user<foo>,
  :workdir</home/foo>,
  :command</bin/bash -c 'sleep 10000'>,
  :dry-run,
);
