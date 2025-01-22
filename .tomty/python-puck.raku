=begin tomty 
%(
  tag => [ "plugin", "python", "broken" ]
)
=end tomty 

task-run "run python puck", "puck", %(
  args => [
    [ "version" ],
  ]
);
