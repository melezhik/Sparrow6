=begin tomty 
%(
  tag => [ "plugin", "broken" ]
)
=end tomty 

task-run "run python puck", "puck", %(
  args => [
    [ "version" ],
  ]
);
