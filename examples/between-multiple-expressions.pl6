#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-multiple-expressions",
  root  => "examples/tasks",
  task => "between-multiple-expressions",
  do-test => True,
  show-test-result => True,
).task-run;

