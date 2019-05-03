#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-streams",
  root  => "examples/tasks",
  task => "ruby-streams",
  do-test => True,
  show-test-result => True,
).task-run;
