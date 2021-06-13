=begin tomty 
%(
  tag => [ "plugin", "python" ]
)
=end tomty 

task-run "run python puck", "puck", %(
  args => [
    [ "version" ],
  ]
);
