#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-reset-context",
  root  => "examples/tasks",
  task => "between-reset-context",
  do-test => True,
  show-test-result => True,
).task-run;
