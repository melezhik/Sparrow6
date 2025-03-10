#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "within-zoom",
  root  => "examples/tasks",
  task => "within-zoom",
  do-test => True,
  show-test-result => True,
).task-run;
