#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "config-array",
  root  => "examples/tasks",
  task => "config-array",
  do-test => True,
  show-test-result => True,
).task-run;
