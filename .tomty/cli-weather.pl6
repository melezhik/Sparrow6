=begin tomty 
%(
  tag => "plugin"
)
=end tomty 

task-run "run cli-weather", "cli-weather", %(
  args => [
    [ "version" ],
  ]
);
