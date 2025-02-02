#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "logrorate-01",
  root  => "examples/tasks/logrorate/01",
  task => "",
  do-test => True,
  show-test-result => True,  
).task-run;

