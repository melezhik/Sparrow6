#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "between-narrow-search",
  root  => "examples/tasks",
  task => "between-narrow-search",
  do-test => True,
  show-test-result => True,
).task-run;

