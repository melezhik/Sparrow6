#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-config-func",
  root  => "examples/tasks/",
  task => "python-config-func",
  do-test => True,
  show-test-result => True,
).task-run;
