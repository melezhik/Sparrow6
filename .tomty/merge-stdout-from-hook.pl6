#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "merge-stdout-from-hook",
  root  => "examples/tasks",
  task => "merge-stdout-from-hook",
  do-test => True,
  show-test-result => True,
).task-run;
