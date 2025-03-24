#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "within-zoom-abcd",
  root  => "examples/tasks",
  task => "within-zoom-abcd",
  do-test => True,
  show-test-result => True,
).task-run;
