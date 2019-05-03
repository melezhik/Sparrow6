#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-run-task",
  root  => "examples/tasks/",
  task => "python-run-task",
  do-test => True,
  show-test-result => True,
).task-run;
