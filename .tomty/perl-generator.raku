#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl-generator",
  root  => "examples/tasks",
  task => "perl-generator",
  do-test => True,
  show-test-result => True,
).task-run;
