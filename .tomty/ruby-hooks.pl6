#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-hooks",
  root  => "examples/tasks",
  task => "ruby-hooks",
  do-test => True,
  show-test-result => True,
).task-run;
