#!perl6

task-run "examples/tasks/args-stringification-example", %(
  args => [
    %( a => "=value" ),
  ]
);

task-run "examples/tasks/args-stringification-example", %(
  args => [
    %( a => "value" ),
    ['verbose', 'force']
  ]
);

task-run "examples/tasks/args-stringification-example", %(
  args => [
    %( a => "value" ),
    'verbose=true', 
    'force=false'
  ]
);

