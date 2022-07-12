#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "code-perl-shebang",
  root  => "examples/tasks",
  task => "code-perl-shebang",
  do-test => True,
  show-test-result => True,
).task-run;
