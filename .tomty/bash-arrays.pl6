#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash-arrays",
  root  => "examples/tasks",
  task => "bash-arrays",
  do-test => True,
  show-test-result => True,
).task-run;
