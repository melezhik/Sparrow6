#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between",
  root  => "examples/tasks",
  task => "between",
  do-test => True,
  show-test-result => True,
).task-run;

