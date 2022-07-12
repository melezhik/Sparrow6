#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "os-bash",
  root  => "examples/tasks",
  task => "os-bash",
  do-test => True,
  show-test-result => True,  
).task-run;

