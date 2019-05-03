#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-downstream-stories",
  root  => "examples/tasks",
  task => "ruby-downstream-stories",
  do-test => True,
  show-test-result => True,
).task-run;
