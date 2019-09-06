#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "matched",
  root  => "examples/tasks",
  task => "matched",
  do-test => True,
  show-test-result => True,
).task-run;
