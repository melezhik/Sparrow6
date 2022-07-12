=begin tomty 
%(
  tag => [ "plugin", "python" ]
)
=end tomty 

task-run "run cli-weather", "cli-weather", %(
  args => [
    [ "version" ],
  ]
);
