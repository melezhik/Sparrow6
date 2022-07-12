#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "comments",
  root  => "examples/tasks",
  task => "comments",
  do-test => True,
  show-test-result => True,
).task-run;
