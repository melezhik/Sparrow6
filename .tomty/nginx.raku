#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "nginx",
  root  => "examples/tasks/nginx",
  #task => "",
  do-test => True,
  show-test-result => True,  
).task-run;

