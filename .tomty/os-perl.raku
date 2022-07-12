#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "os-perl",
  root  => "examples/tasks",
  task => "os-perl",
  do-test => True,
  show-test-result => True,  
).task-run;

