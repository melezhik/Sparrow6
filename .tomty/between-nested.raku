#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-nested",
  root  => "examples/tasks",
  task => "between-nested",
  do-test => True,
  show-test-result => True,
).task-run;

