#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl-inline",
  root  => "examples/tasks",
  task => "perl-inline",
  do-test => True,
  show-test-result => True,
).task-run;
