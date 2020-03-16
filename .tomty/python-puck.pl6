=begin tomty 
%(
  tag => "plugin"
)
=end tomty 

task-run "run python puck", "puck", %(
  args => [
    [ "version" ]
  ]
);
