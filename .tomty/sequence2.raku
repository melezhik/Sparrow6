#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sequence2",
  root  => "examples/tasks",
  task => "sequence2",
  do-test => True,
  show-test-result => True,
).task-run;

