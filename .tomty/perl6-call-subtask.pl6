#!perl6 

=begin tomty
%(
  tag => "windows"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "perl6-call-subtask",
  root  => "examples/tasks",
  task => "perl6-call-subtask",
  do-test => True,
  show-test-result => True, 
  parameters => %(
    language => "Perl6"
  )
).task-run;

