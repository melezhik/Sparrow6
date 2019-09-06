#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "within",
  root  => "examples/tasks",
  task => "within",
  do-test => True,
  show-test-result => True,
).task-run;
