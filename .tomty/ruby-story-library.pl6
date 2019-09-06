#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-task-library",
  root  => "examples/tasks",
  task => "ruby-task-library",
  do-test => True,
  show-test-result => True,
).task-run;
