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

