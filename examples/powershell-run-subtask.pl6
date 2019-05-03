#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "run-subtask",
  root  => "examples/tasks/",
  task => "powershell/run-subtask",
  do-test => True,
  show-test-result => True,
).task-run;
