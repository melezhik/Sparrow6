#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl-pass-task-vars-to-scenario",
  root  => "examples/tasks",
  task => "perl-pass-task-vars-to-scenario",
  do-test => True,
  show-test-result => True,
).task-run;
