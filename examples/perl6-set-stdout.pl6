#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-set-stdout",
  root  => "examples/tasks/",
  task => "perl6-set-stdout",
  do-test => True,
  show-test-result => True,
).task-run;
