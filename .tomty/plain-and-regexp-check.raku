#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "plain-and-regexp-check",
  root  => "examples/tasks",
  task => "plain-and-regexp-check",
  do-test => True,
  show-test-result => True,
).task-run;

