#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "within-colors",
  root  => "examples/tasks",
  task => "within-colors",
  do-test => True,
  show-test-result => True,
).task-run;
