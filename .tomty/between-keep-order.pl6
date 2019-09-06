#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-keep-order",
  root  => "examples/tasks",
  task => "between-keep-order",
  do-test => True,
  show-test-result => True,
).task-run;

