#!perl6 

=begin tomty
%(
  tag => "windows"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-captures",
  root  => "examples/tasks",
  task => "perl6-captures",
  do-test => True,
  show-test-result => True,
).task-run;

