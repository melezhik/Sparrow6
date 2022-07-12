#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sequence",
  root  => "examples/tasks",
  task => "sequence",
  do-test => True,
  show-test-result => True,
).task-run;

