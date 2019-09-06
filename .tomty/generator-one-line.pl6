#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "generator-one-line",
  root  => "examples/tasks",
  task => "generator-one-line",
  do-test => True,
  show-test-result => True,
).task-run;
