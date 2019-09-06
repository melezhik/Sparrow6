#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "set-stdout-merged-with-task-stdout",
  root  => "examples/tasks",
  task => "set-stdout-merged-with-task-stdout",
  do-test => True,
  show-test-result => True,
).task-run;
