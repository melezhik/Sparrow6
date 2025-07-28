#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "streams-array-with-negation",
  root  => "examples/tasks",
  task => "streams-array-with-negation",
  do-test => True,
  show-test-result => True,
).task-run;
