#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-pass-config-to-hook",
  root  => "examples/tasks",
  task => "ruby-pass-config-to-hook",
  do-test => True,
  show-test-result => True,
).task-run;
