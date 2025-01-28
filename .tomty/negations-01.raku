#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "hello",
  root  => "examples/tasks/negations",
  task => "01",
  do-test => True,
  show-test-result => True,  
).task-run;

