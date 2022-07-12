#!raku

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-call-subtask",
  root  => "examples/tasks",
  task => "raku-call-subtask",
  do-test => True,
  show-test-result => True, 
  parameters => %(
    language => "raku"
  )
).task-run;

