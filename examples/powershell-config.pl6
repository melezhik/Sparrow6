#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "config",
  root  => "examples/tasks/",
  task => "powershell/config",
  do-test => True,
  show-test-result => True,
).task-run;
