#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "text-blocks-stream3",
  root  => "examples/tasks",
  task => "text-blocks-stream3",
  do-test => True,
  show-test-result => True,
).task-run;
