#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-pass-config-to-scenario",
  root  => "examples/tasks",
  task => "ruby-pass-config-to-scenario",
  do-test => True,
  show-test-result => True,
).task-run;
