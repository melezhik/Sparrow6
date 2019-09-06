#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "checks/generator-multiline",
  root  => "examples/tasks",
  task => "checks/generator-multiline",
  do-test => True,
  show-test-result => True,
).task-run;

