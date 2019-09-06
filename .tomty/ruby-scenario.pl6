#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-scenario",
  root  => "examples/tasks",
  task => "ruby-scenario",
  do-test => True,
  show-test-result => True,
).task-run;
