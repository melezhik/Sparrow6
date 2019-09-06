#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash nested task vars",
  root  => "examples/tasks",
  task => "bash-nested-vars",
  do-test => True,
  show-test-result => True,
).task-run;

