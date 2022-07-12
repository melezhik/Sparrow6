#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-ignore-task-err",
  root  => "examples/tasks",
  task => "ruby-ignore-task-err",
  do-test => True,
  show-test-result => True,
).task-run;
