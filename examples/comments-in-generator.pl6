#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "comments-in-generator",
  root  => "examples/tasks",
  task => "comments-in-generator",
  do-test => True,
  show-test-result => True,
).task-run;

