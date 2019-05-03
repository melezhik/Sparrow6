#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl-pass-conf-to-scenario",
  root  => "examples/tasks",
  task => "perl-pass-conf-to-scenario",
  do-test => True,
  show-test-result => True,
).task-run;
