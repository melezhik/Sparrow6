#!perl6 

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-streams",
  root  => "examples/tasks",
  task => "perl6-streams",
  do-test => True,
  show-test-result => True,
).task-run;
