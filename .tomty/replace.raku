#!raku

=begin tomty 
%(
  tag => [ "replace" ]
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "replace",
  root  => "examples/tasks",
  task => "replace",
  do-test => True,
  show-test-result => True,  
).task-run;

