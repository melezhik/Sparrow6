#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-task-state",
  root  => "examples/tasks",
  task => "ruby-task-state",
  do-test => True,
  show-test-result => True,
).task-run;
