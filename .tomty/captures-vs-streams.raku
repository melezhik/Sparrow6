#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "captures-vs-streams",
  root  => "examples/tasks",
  task => "captures-vs-streams",
  do-test => True,
  show-test-result => True,
).task-run;
