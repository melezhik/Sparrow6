#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "regexp-check",
  root  => "examples/tasks",
  task => "regexp-check",
  do-test => True,
  show-test-result => True,
).task-run;

