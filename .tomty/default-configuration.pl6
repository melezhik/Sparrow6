#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "default-configuration",
  do-test => True,
  show-test-result => True,
  root  => "examples/tasks",
  task => "default-configuration",
).task-run;


