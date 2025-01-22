=begin tomty 
%(
  tag => [ "plugin", "python" ]
)
=end tomty 

task-run "run python httpx help", "python-httpx", %(
  args => [
    [ "help" ],
  ]
);
