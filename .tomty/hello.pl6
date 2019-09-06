#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "hello",
  root  => "examples/tasks",
  task => "hello",
  do-test => True,
  show-test-result => True,  
).task-run;

