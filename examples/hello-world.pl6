#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "hello/world",
  root  => "examples/tasks",
  task => "hello/world",
  do-test => True,
  show-test-result => True,  
).task-run;

