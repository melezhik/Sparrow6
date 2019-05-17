#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "range",
  root  => "examples/tasks",
  task => "range",
  do-test => True,
  show-test-result => True,
).task-run;

