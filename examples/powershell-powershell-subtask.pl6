#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "powershell-subtask",
  root  => "examples/tasks/",
  task => "powershell/powershell-subtask",
  do-test => True,
  show-test-result => True,
).task-run;
