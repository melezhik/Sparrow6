#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-ignore-err",
  root  => "examples/tasks/",
  task => "python-ignore-err",
  do-test => True,
  show-test-result => True,
).task-run;
