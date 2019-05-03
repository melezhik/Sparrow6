#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "regexp-check-trailing-spaces",
  do-test => True,
  show-test-result => True,
  root  => "examples/tasks",
  task => "regexp-check-trailing-spaces",
).task-run;


