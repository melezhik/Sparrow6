#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "plain-check-case-sensetive",
  root  => "examples/tasks",
  task => "plain-check-case-sensetive",
  do-test => True,
  show-test-result => True,
).task-run;

