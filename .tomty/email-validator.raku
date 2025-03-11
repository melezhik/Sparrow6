#!raku

=begin tomty 
%(
  tag => [ "untested" ]
)
=end tomty

task-run "examples/tasks/email-validator", %(
    email => q["A"B"C"@localhost],
);

