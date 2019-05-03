#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash-set-stdout",
  root  => "examples/tasks",
  task => "bash-set-stdout",
  do-test => True,
  show-test-result => True,
).task-run;
