#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "no-check-file",
  root  => "examples/tasks",
  task => "no-check-file",
  do-test => True,
  show-test-result => True,
).task-run;
