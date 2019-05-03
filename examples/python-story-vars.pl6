#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-task-vars",
  root  => "examples/tasks/",
  task => "python-task-vars",
  do-test => True,
  show-test-result => True,
).task-run;
