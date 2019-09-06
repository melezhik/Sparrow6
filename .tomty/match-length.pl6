#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "match-length",
  root  => "examples/tasks",
  task => "match-length",
  do-test => True,
  show-test-result => True,
).task-run;

