#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash-task-library",
  root  => "examples/tasks",
  task => "bash-task-library",
  do-test => True,
  show-test-result => True,
).task-run;
