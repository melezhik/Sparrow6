#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "no-scenario",
  do-test => True,
  show-test-result => True,
  root  => "examples/tasks",
  task => "no-scenario",
).task-run;


