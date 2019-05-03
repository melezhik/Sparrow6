#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-table-example",
  root  => "examples/tasks",
  task => "between-table-example",
  do-test => True,
  show-test-result => True,
).task-run;
