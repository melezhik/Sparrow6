#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "asserts",
  root  => "examples/tasks",
  task => "asserts",
  do-test => True,
  show-test-result => True,
).task-run;

