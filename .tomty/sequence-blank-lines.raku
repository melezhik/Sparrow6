#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sequence-blank-lines",
  root  => "examples/tasks",
  task => "sequence-blank-lines",
  do-test => True,
  show-test-result => True,
).task-run;
