#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "python-captures",
  root  => "examples/tasks/",
  task => "python-captures",
  do-test => True,
  show-test-result => True,
).task-run;
