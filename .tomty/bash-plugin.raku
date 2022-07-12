#!perl6 

=begin tomty
%(
  tag => "plugin"
)
=end tomty

task-run "bash plugin", "bash", %(
  command => 'echo $foo',
  debug   => 1,
  envvars => %(
    foo => "BAR"
  ),
  expect_stdout => "BAR"
);

