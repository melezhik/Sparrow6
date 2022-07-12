#!perl6

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "ruby-captures",
  root  => "examples/tasks",
  task => "ruby-captures",
  do-test => True,
  show-test-result => True,
).task-run;
