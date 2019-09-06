#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-generators",
  root  => "examples/tasks",
  task => "ruby-generators",
  do-test => True,
  show-test-result => True,
).task-run;
