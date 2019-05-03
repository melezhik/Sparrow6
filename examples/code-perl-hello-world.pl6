#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "code-perl-hello-world",
  root  => "examples/tasks",
  task => "code-perl-hello-world",
  do-test => True,
  show-test-result => True,
).task-run;
