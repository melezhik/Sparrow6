task-run "utils/curl", "curl", %(
  args => [
    %( 
      '-D' => '-',
      'output' => '/dev/null'
    ),
    [
      'silent',
      '-f',
      'location'
    ],
    'http://raku.org'
  ]
);

