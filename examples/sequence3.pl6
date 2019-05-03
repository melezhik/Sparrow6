#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sequence3",
  root  => "examples/tasks",
  task => "sequence3",
  do-test => True,
  show-test-result => True,
).task-run;
