#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "cwd",
  root  => "examples/tasks",
  task => "cwd",
  do-test => True,
  show-test-result => True,  
).task-run;

