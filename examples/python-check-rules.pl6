#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-check-rules",
  root  => "examples/tasks/",
  task => "python-check-rules",
  do-test => True,
  show-test-result => True,
).task-run;
