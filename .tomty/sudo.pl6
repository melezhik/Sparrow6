#!perl6 

=begin tomty
%(
  tag => "sudo"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "sudo",
  root  => "examples/tasks",
  task => "sudo",
  do-test => True,
  show-test-result => True,
).task-run;

