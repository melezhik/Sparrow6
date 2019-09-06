#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "no-scenario2",
  root  => "examples/tasks",
  task => "no-scenario2",
  do-test => True,
  show-test-result => True,
).task-run;
