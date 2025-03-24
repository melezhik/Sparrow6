#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "within-zoom-click-me",
  root  => "examples/tasks",
  task => "within-zoom-click-me",
  do-test => True,
  show-test-result => True,
).task-run;
