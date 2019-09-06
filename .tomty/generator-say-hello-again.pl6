#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "generator-say-hello-again",
  root  => "examples/tasks",
  task => "generator-say-hello-again",
  do-test => True,
  show-test-result => True,
).task-run;
