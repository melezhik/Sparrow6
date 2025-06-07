#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "within-first-run-issue",
  root  => "examples/tasks",
  task => "within-first-run-issue",
  do-test => True,
  show-test-result => True,  
).task-run;

