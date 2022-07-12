#!raku

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-set-stdout",
  root  => "examples/tasks/",
  task => "raku-set-stdout",
  do-test => True,
  show-test-result => True,
).task-run;
