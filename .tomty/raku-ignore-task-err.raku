#!raku

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-ignore-task-err",
  root  => "examples/tasks",
  task => "raku-ignore-task-err",
  do-test => True,
  show-test-result => True,
).task-run;
