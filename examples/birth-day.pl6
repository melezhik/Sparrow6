#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "birth-day",
  root  => "examples/tasks",
  task => "birth-day",
  do-test => True,
  show-test-result => True,
).task-run;
