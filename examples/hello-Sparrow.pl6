#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "hello-Sparrow",
  root  => "examples/tasks",
  task => "hello-Sparrow",
  do-test => True,
  show-test-result => True,
).task-run;
