#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-dont-preserve-consecutive-order",
  root  => "examples/tasks",
  task => "between-dont-preserve-consecutive-order",
  do-test => True,
  show-test-result => True,
).task-run;
