#!raku

=begin tomty 
%(
  tag => [ "sandbox" ]
)
=end tomty

say "examples/tasks/mkinitcpio/mkinitcpio.conf".IO.slurp();

say "====";

task-run "examples/tasks/mkinitcpio", %(
    :path<examples/tasks/mkinitcpio/mkinitcpio.conf>,
);

say "====";

say "examples/tasks/mkinitcpio/mkinitcpio.conf".IO.slurp();

