#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash-generators",
  root  => "examples/tasks",
  task => "bash-generators",
  do-test => True,
  show-test-result => True,
).task-run;
