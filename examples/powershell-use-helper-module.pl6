#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "use-helper-module",
  root  => "examples/tasks/",
  task => "powershell/use-helper-module",
  do-test => True,
  show-test-result => True,
).task-run;
