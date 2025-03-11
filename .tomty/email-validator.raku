#!raku

=begin tomty 
%(
  tag => [ "sandbox" ]
)
=end tomty

task-run "examples/tasks/email-validator", %(
    email => q["A"B"C"@localhost],
);

