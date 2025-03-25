#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sln/02",
  root  => "examples/tasks/sln",
  task => "03",
  do-test => True,
  show-test-result => True,  
).task-run;

