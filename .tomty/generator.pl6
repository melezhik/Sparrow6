#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "generator",
  root  => "examples/tasks",
  task => "generator",
  do-test => True,
  show-test-result => True,
).task-run;

