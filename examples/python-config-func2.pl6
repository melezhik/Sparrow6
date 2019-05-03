#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-config-func2",
  root  => "examples/tasks/",
  task => "python-config-func2",
  do-test => True,
  show-test-result => True,
).task-run;
