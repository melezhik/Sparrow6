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

task-run "run python httpx get https://raku.org", "python-httpx", %(
  args => [
    "https://raku.org",
  ]
);
