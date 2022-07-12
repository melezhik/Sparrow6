#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "shared-state",
  root  => "examples/tasks/shared-state",
  do-test => True,
  show-test-result => True,  
).task-run;

