#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "captures",
  root  => "examples/tasks",
  task => "captures",
  do-test => True,
  show-test-result => True,
).task-run;

