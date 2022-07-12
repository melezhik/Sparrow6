#!raku 

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-captures",
  root  => "examples/tasks",
  task => "raku-captures",
  do-test => True,
  show-test-result => True,
).task-run;

