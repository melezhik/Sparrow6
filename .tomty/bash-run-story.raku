#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash-run-task",
  do-test => True,
  show-test-result => True,
  root  => "examples/tasks",
  task => "bash-run-task",
).task-run;


