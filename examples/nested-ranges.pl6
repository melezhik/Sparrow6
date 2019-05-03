#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "nested-ranges",
  root  => "examples/tasks",
  task => "nested-ranges",
  do-test => True,
  show-test-result => True,
).task-run;
