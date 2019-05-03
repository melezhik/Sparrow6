#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "case-sensetve-plain-strings",
  root  => "examples/tasks",
  task => "case-sensetve-plain-strings",
  do-test => True,
  show-test-result => True,
).task-run;
