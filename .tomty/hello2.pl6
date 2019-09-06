#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "hello2",
  root  => "examples/tasks",
  task => "hello2",
  do-test => True,
  show-test-result => True,
).task-run;

