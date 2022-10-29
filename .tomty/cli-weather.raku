=begin tomty 
%(
  tag => [ "plugin", "python" ]
)
=end tomty 

task-run "run cli-weather", "weather", %(
  args => [
    [ "version" ],
  ]
);
