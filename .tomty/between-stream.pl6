#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-stream",
  root  => "examples/tasks",
  task => "between-stream",
  do-test => True,
  show-test-result => True,
).task-run;

