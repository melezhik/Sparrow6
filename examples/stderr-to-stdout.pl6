#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "stderr-to-stdout",
  root  => "examples/tasks",
  task => "stderr-to-stdout",
  do-test => True,
  show-test-result => True,
).task-run;

