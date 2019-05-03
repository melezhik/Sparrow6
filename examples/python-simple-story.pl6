#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-simple-task",
  root  => "examples/tasks/",
  task => "python-simple-task",
  do-test => True,
  show-test-result => True,
).task-run;
