#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-inline-code",
  root  => "examples/tasks/",
  task => "python-inline-code",
  do-test => True,
  show-test-result => True,
).task-run;
