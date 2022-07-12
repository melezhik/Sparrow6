#!raku 

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-streams",
  root  => "examples/tasks",
  task => "raku-streams",
  do-test => True,
  show-test-result => True,
).task-run;

