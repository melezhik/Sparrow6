#!raku 

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-hello-world",
  root  => "examples/tasks",
  task => "raku-hello-world",
  do-test => True,
  show-test-result => True,
  parameters => %(
    language => "raku"
  )
).task-run;

