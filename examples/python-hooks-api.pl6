#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-hooks-api",
  root  => "examples/tasks/",
  task => "python-hooks-api",
  do-test => True,
  show-test-result => True,
).task-run;
