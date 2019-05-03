#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "streams-ranges-different-length",
  root  => "examples/tasks",
  task => "streams-ranges-different-length",
  do-test => True,
  show-test-result => True,
).task-run;
