#!raku

=begin tomty 
%(
  tag => [ "sandbox" ]
)
=end tomty

say "examples/tasks/mkinitcpi/mkinitcpio.conf".IO.slurp();

say "====";

task-run "examples/tasks/mkinitcpio", %(
    :path<examples/tasks/mkinitcpi/mkinitcpio.conf>,
);

say "====";

say "examples/tasks/mkinitcpi/mkinitcpio.conf".IO.slurp();

