#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "run-task",
  root  => "examples/tasks",
  task => "run-task",
  do-test => True,
  show-test-result => True,  
).task-run;

