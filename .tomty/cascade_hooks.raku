#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "cascade_hooks",
  root  => "examples/tasks/cascade_hooks",
  task => "",
  do-test => True,
  show-test-result => True,  
).task-run;

