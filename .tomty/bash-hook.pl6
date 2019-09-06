#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "bash-hook",
  do-test => True,
  show-test-result => True,
  root  => "examples/tasks",
  task => "bash-hook",
).task-run;


