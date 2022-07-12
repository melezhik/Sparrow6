#!raku 

=begin tomty
%(
  tag => "raku"
)
=end tomty

use Sparrow6::Task::Runner;

Sparrow6::Task::Runner::Api.new(
  name  => "raku-read-config",
  root  => "examples/tasks",
  task => "raku-read-config",
  do-test => True,
  show-test-result => True,  
).task-run;

