#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "one-liners",
  do-test => True,
  show-test-result => True,
  root  => "examples/tasks",
  task => "one-liners",
).task-run;


