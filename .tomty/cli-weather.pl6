=begin tomty 
%(
  tag => [ "plugin", "broken" ]
)
=end tomty 

task-run "run cli-weather", "cli-weather", %(
  args => [
    [ "version" ],
  ]
);
